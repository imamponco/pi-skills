#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$HOME/.publish-message.env"
FILE="review_result.md"
GITLAB_PROJECT_ID_ARG=""
GITLAB_MR_IID_ARG=""
GITLAB_API_URL_ARG=""

usage() {
  cat <<'EOF'
Usage: bash publish_message.sh [file] [options]

Default file: review_result.md
Config: ~/.publish-message.env

Options:
  --gitlab-project-id <id>   Required for GitLab publish
  --gitlab-mr-iid <iid>      Required for GitLab publish
  --gitlab-api-url <url>     GitLab API base URL (optional, default https://gitlab.com)
  --gitlab-url <url>         GitLab MR URL (auto-detects project + MR, e.g.
                             https://gitlab.com/namespace/project/-/merge_requests/123)
  -h, --help                 Show help

Examples:
  bash publish_message.sh
  bash publish_message.sh docs/summary.md
  bash publish_message.sh review_result.md --gitlab-project-id 123 --gitlab-mr-iid 45
  bash publish_message.sh review_result.md --gitlab-api-url https://gitlab.example.com --gitlab-project-id 123 --gitlab-mr-iid 45
  bash publish_message.sh review_result.md --gitlab-url https://gitlab.com/namespace/project/-/merge_requests/123
EOF
}

parse_gitlab_url() {
  python3 - "$1" <<'PY'
import re, sys
url = sys.argv[1]
m = re.match(r'^(https?://[^/]+)(/.*?)/-/(?:merge_requests|mr)/(\d+)/?$', url)
if not m:
    sys.exit(1)
api_url = m.group(1)
project_path = m.group(2).strip('/')
mr_iid = m.group(3)
print(api_url)
print(project_path)
print(mr_iid)
PY
}

while [ $# -gt 0 ]; do
  case "$1" in
    --gitlab-project-id) GITLAB_PROJECT_ID_ARG="${2:?missing GitLab project ID}"; shift 2 ;;
    --gitlab-mr-iid) GITLAB_MR_IID_ARG="${2:?missing GitLab MR IID}"; shift 2 ;;
    --gitlab-api-url) GITLAB_API_URL_ARG="${2:?missing GitLab API URL}"; shift 2 ;;
    --gitlab-url)
      parsed="$(parse_gitlab_url "${2:?missing GitLab URL}")" || { echo "❌ Invalid GitLab MR URL. Expected: https://host/namespace/project/-/merge_requests/123" >&2; exit 1; }
      { read -r GITLAB_API_URL_ARG; read -r GITLAB_PROJECT_ID_ARG; read -r GITLAB_MR_IID_ARG; } <<< "$parsed"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) FILE="$1"; shift ;;
  esac
done

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

send_chunks() {
  local limit="$1"
  local callback="$2"
  local total_len
  total_len=$(wc -c < "$FILE" | tr -d ' ')

  if [ "$total_len" -le "$limit" ]; then
    "$callback" "$(cat "$FILE")" "1" "1"
    return 0
  fi

  local tmp_dir chunks total idx chunk_file
  tmp_dir="$(mktemp -d)"
  python3 - "$FILE" "$limit" "$tmp_dir" <<'PY'
import pathlib, sys
path = pathlib.Path(sys.argv[1])
limit = int(sys.argv[2])
out = pathlib.Path(sys.argv[3])
text = path.read_text()
chunks = []
current = ""
for line in text.splitlines(keepends=True):
    if len(line) > limit:
        if current:
            chunks.append(current)
            current = ""
        for i in range(0, len(line), limit):
            chunks.append(line[i:i+limit])
    elif len(current) + len(line) > limit:
        chunks.append(current)
        current = line
    else:
        current += line
if current:
    chunks.append(current)
for i, chunk in enumerate(chunks, 1):
    (out / f"chunk_{i:04d}.txt").write_text(chunk)
PY

  chunks=("$tmp_dir"/chunk_*.txt)
  total="${#chunks[@]}"
  idx=1
  for chunk_file in "${chunks[@]}"; do
    "$callback" "$(cat "$chunk_file")" "$idx" "$total"
    idx=$((idx + 1))
  done
  rm -rf "$tmp_dir"
}

if [ ! -f "$CONFIG_FILE" ]; then
    echo "=========================================================="
    echo "⚙️  FIRST TIME SETUP: Generating Configuration File"
    echo "=========================================================="
    cat << 'EOF' > "$CONFIG_FILE"
# ==========================================
# Publish Message Configuration
# ==========================================
# Set ACTIVE_PLATFORM to one of: discord, telegram, gitlab
ACTIVE_PLATFORM="discord"

# --- DISCORD ---
DISCORD_WEBHOOK_URL=""

# --- TELEGRAM ---
TELEGRAM_BOT_TOKEN=""
TELEGRAM_CHAT_ID=""

# --- GITLAB ---
GITLAB_TOKEN=""
# Optional, default: https://gitlab.com
GITLAB_API_URL=""
EOF
    chmod 600 "$CONFIG_FILE"
    echo "❌ Missing Webhooks/Tokens."
    echo "👉 Config created: $CONFIG_FILE"
    echo "Fill it, then rerun: bash publish_message.sh ${FILE}"
    exit 1
fi

# shellcheck disable=SC1090
source "$CONFIG_FILE"

if [ ! -f "$FILE" ]; then
    echo "❌ Error: file not found: $FILE"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "❌ Error: python3 is required for JSON escaping and chunking."
  exit 1
fi

GITLAB_PROJECT_ID="$GITLAB_PROJECT_ID_ARG"
GITLAB_MR_IID="$GITLAB_MR_IID_ARG"

# URL-encode project path for GitLab API; numeric ID used as-is
encode_project_ref() {
  local ref="$1"
  if [[ "$ref" =~ ^[0-9]+$ ]]; then
    printf '%s' "$ref"
  else
    python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""), end="")' "$ref"
  fi
}
GITLAB_PROJECT_REF="$(encode_project_ref "$GITLAB_PROJECT_ID")"

# Resolve GitLab API URL: CLI arg > env var > prompt > default
GITLAB_API_URL="${GITLAB_API_URL_ARG:-${GITLAB_API_URL:-}}"
if [ -z "$GITLAB_API_URL" ] && [[ ",${ACTIVE_PLATFORM:-}," = *",gitlab,"* ]]; then
  if [ -t 0 ]; then
    printf "GitLab API URL [https://gitlab.com]: "
    read -r GITLAB_API_URL
  fi
  GITLAB_API_URL="${GITLAB_API_URL:-https://gitlab.com}"
fi

send_discord_chunk() {
    local content="$1" idx="$2" total="$3" prefix=""
    [ "$total" -gt 1 ] && prefix="[Part $idx/$total]\n"
    local payload
    payload=$(printf "%b%s" "$prefix" "$content" | json_escape)
    curl -fsS -H "Content-Type: application/json" -X POST -d "{\"content\": $payload}" "$DISCORD_WEBHOOK_URL" >/dev/null
}

send_telegram_chunk() {
    local content="$1" idx="$2" total="$3" prefix=""
    [ "$total" -gt 1 ] && prefix="[Part $idx/$total]\n"
    local payload
    payload=$(printf "%b%s" "$prefix" "$content" | json_escape)
    curl -fsS -H "Content-Type: application/json" -X POST -d "{\"chat_id\": \"$TELEGRAM_CHAT_ID\", \"text\": $payload}" "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" >/dev/null
}

send_gitlab_chunk() {
    local content="$1" idx="$2" total="$3" prefix=""
    [ "$total" -gt 1 ] && prefix="[Part $idx/$total]\n\n"
    local payload gitlab_url
    payload=$(printf "%b%s" "$prefix" "$content" | json_escape)
    gitlab_url="${GITLAB_API_URL:-https://gitlab.com}"
    curl -fsS --request POST --header "PRIVATE-TOKEN: $GITLAB_TOKEN" --header "Content-Type: application/json" --data "{\"body\": $payload}" "$gitlab_url/api/v4/projects/$GITLAB_PROJECT_REF/merge_requests/$GITLAB_MR_IID/notes" >/dev/null
}

send_discord() {
    if [ -z "${DISCORD_WEBHOOK_URL:-}" ]; then echo "❌ Error: DISCORD_WEBHOOK_URL is empty in $CONFIG_FILE"; exit 1; fi
    send_chunks 1850 send_discord_chunk
    echo "✅ Sent $FILE to Discord."
}

send_telegram() {
    if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then echo "❌ Error: Telegram config empty in $CONFIG_FILE"; exit 1; fi
    send_chunks 3900 send_telegram_chunk
    echo "✅ Sent $FILE to Telegram."
}

send_gitlab() {
    if [ -z "${GITLAB_TOKEN:-}" ]; then echo "❌ Error: GITLAB_TOKEN is empty in $CONFIG_FILE"; exit 1; fi
    if [ -z "$GITLAB_PROJECT_REF" ] || [ -z "$GITLAB_MR_IID" ]; then echo "❌ Error: GitLab requires --gitlab-project-id or --gitlab-url and --gitlab-mr-iid"; exit 1; fi
    send_chunks 950000 send_gitlab_chunk
    echo "✅ Sent $FILE to GitLab MR."
}

send_all() {
  local IFS=','
  for platform in ${ACTIVE_PLATFORM:-}; do
    platform="${platform## }"
    platform="${platform%% }"
    case "$platform" in
      discord)  send_discord ;;
      telegram) send_telegram ;;
      gitlab)   send_gitlab ;;
      *) echo "⚠️  Unknown platform in ACTIVE_PLATFORM: $platform" >&2 ;;
    esac
  done
}

trimmed="${ACTIVE_PLATFORM## }"
trimmed="${trimmed%% }"
if [ -z "$trimmed" ]; then
  echo "❌ Error: ACTIVE_PLATFORM is empty in $CONFIG_FILE" >&2
  exit 1
fi
send_all
