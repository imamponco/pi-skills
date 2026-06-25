#!/usr/bin/env bash
set -euo pipefail

TARGET="code-review"
MODE="user"
FORCE="false"
SETUP_PLATFORM=""
SETUP_PLATFORMS=""
DISCORD_WEBHOOK_URL=""
TELEGRAM_BOT_TOKEN=""
TELEGRAM_CHAT_ID=""
GITLAB_TOKEN=""
GITLAB_API_URL=""
REPO_URL="${REPO_URL:-https://github.com/imamponco/pi-skills.git}"

usage() {
  cat <<'EOF'
Usage: ./install.sh [skill|all] [options]

Targets:
  code-review              Install code-review skill only (default)
  publish-message          Install publish-message skill only
  all                      Install whole repo

Options:
  --project                Install to current project .pi/skills
  --force                  Replace existing install and prompt setup again
  --repo <url>             Override git repo URL
  --setup                  Interactive menu (multiple platforms allowed)
  --setup-discord          Configure Discord delivery
  --setup-telegram         Configure Telegram delivery
  --setup-gitlab           Configure GitLab MR delivery
  Can combine: --setup-discord --setup-telegram
  --discord-webhook-url <url>
  --telegram-bot-token <token>
  --telegram-chat-id <id>
  --gitlab-token <token>
  --gitlab-api-url <url>   Optional, default https://gitlab.com
  -h, --help               Show help

Examples:
  ./install.sh all --force
  ./install.sh publish-message --setup
  ./install.sh publish-message --setup-discord
  ./install.sh publish-message --discord-webhook-url https://discord.com/api/webhooks/xxx/yyy
  ./install.sh publish-message --setup-gitlab
EOF
}

prompt_platform_creds() {
  local platform="$1"

  case "$platform" in
    discord)
      if [ -z "$DISCORD_WEBHOOK_URL" ]; then
        printf "Discord webhook URL: "
        read -r DISCORD_WEBHOOK_URL
      fi
      if [ -z "$DISCORD_WEBHOOK_URL" ]; then echo "Skipped: empty Discord webhook URL"; return 1; fi
      ;;
    telegram)
      if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
        printf "Telegram bot token: "
        read -r TELEGRAM_BOT_TOKEN
      fi
      if [ -z "$TELEGRAM_CHAT_ID" ]; then
        printf "Telegram chat ID: "
        read -r TELEGRAM_CHAT_ID
      fi
      if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then echo "Skipped: empty Telegram config"; return 1; fi
      ;;
    gitlab)
      if [ -z "$GITLAB_TOKEN" ]; then
        printf "GitLab token: "
        read -r GITLAB_TOKEN
      fi
      if [ -z "$GITLAB_API_URL" ] && [ -t 0 ]; then
        printf "GitLab API base URL [https://gitlab.com]: "
        read -r GITLAB_API_URL
      fi
      GITLAB_API_URL="${GITLAB_API_URL:-https://gitlab.com}"
      if [ -z "$GITLAB_TOKEN" ]; then echo "Skipped: empty GitLab token"; return 1; fi
      ;;
    *) echo "Unknown platform: $platform"; return 1 ;;
  esac
  return 0
}

write_publish_message_env() {
  local platforms="$1"
  local env_file="$HOME/.publish-message.env"
  local IFS=','
  local ok_platforms=""

  for p in $platforms; do
    p="${p## }"
    p="${p%% }"
    if prompt_platform_creds "$p"; then
      [ -n "$ok_platforms" ] && ok_platforms="$ok_platforms,"
      ok_platforms="${ok_platforms}$p"
    fi
  done

  if [ -z "$ok_platforms" ]; then
    echo "No platforms configured, skipping."
    return 0
  fi

  cat > "$env_file" <<EOF
# Publish Message Configuration
# Set ACTIVE_PLATFORM to one or comma-separated: discord, telegram, gitlab
ACTIVE_PLATFORM="$ok_platforms"

# --- DISCORD ---
DISCORD_WEBHOOK_URL="$DISCORD_WEBHOOK_URL"

# --- TELEGRAM ---
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"

# --- GITLAB ---
GITLAB_TOKEN="$GITLAB_TOKEN"
GITLAB_API_URL="$GITLAB_API_URL"
EOF

  chmod 600 "$env_file"
  echo "Configured delivery ($ok_platforms) -> $env_file"
}

single_write_publish_message_env() {
  local platform="$1"
  local env_file="$HOME/.publish-message.env"

  if ! prompt_platform_creds "$platform"; then return 0; fi

  cat > "$env_file" <<EOF
# Publish Message Configuration
# Set ACTIVE_PLATFORM to one or comma-separated: discord, telegram, gitlab
ACTIVE_PLATFORM="$platform"

# --- DISCORD ---
DISCORD_WEBHOOK_URL="$DISCORD_WEBHOOK_URL"

# --- TELEGRAM ---
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"

# --- GITLAB ---
GITLAB_TOKEN="$GITLAB_TOKEN"
GITLAB_API_URL="$GITLAB_API_URL"
EOF

  chmod 600 "$env_file"
  echo "Configured $platform delivery -> $env_file"
}

valid_skill_name() {
  [[ "$1" =~ ^[a-z][a-z0-9-]{0,62}$ ]]
}

next_available_name() {
  local base_name="$1"
  local base="$HOME/.pi/agent/skills"
  local candidate="$base_name"
  local idx=1

  while [ -e "$base/$candidate" ] || [ -L "$base/$candidate" ]; do
    candidate="$base_name-$idx"
    idx=$((idx + 1))
  done

  printf '%s\n' "$candidate"
}

choose_skill_name() {
  local original="$1"
  local suggested
  suggested="$(next_available_name "$original")"

  while true; do
    printf "New skill name [%s]: " "$suggested" >&2
    local name
    read -r name
    name="${name:-$suggested}"

    if ! valid_skill_name "$name"; then
      echo "Invalid skill name. Use lowercase letters, numbers, hyphens; start with letter." >&2
      continue
    fi

    if [ -e "$HOME/.pi/agent/skills/$name" ] || [ -L "$HOME/.pi/agent/skills/$name" ]; then
      echo "Skill name already exists: /skill:$name" >&2
      continue
    fi

    printf '%s\n' "$name"
    return 0
  done
}

choose_conflict_action() {
  local original="$1"

  if [ "$FORCE" = "true" ] || [ ! -t 0 ]; then
    if [ "$FORCE" = "true" ]; then
      printf 'update:%s\n' "$original"
    else
      printf 'new:%s\n' "$(next_available_name "$original")"
    fi
    return 0
  fi

  echo "Skill name conflict: /skill:$original already exists." >&2
  echo "  1) Update existing /skill:$original" >&2
  echo "  2) Create new skill with custom name" >&2
  printf "Choose [1-2]: " >&2
  local choice
  read -r choice
  case "$choice" in
    1) printf 'update:%s\n' "$original" ;;
    *) printf 'new:%s\n' "$(choose_skill_name "$original")" ;;
  esac
}

rewrite_skill_name() {
  local skill_dir="$1"
  local new_name="$2"
  local skill_file="$skill_dir/SKILL.md"

  [ -f "$skill_file" ] || return 0
  python3 - "$skill_file" "$new_name" <<'PY'
import pathlib, re, sys
path = pathlib.Path(sys.argv[1])
name = sys.argv[2]
text = path.read_text()
text = re.sub(r'(?m)^name:\s*.*$', f'name: {name}', text, count=1)
text = re.sub(r'`/skill:[^`]+`', f'`/skill:{name}`', text)
path.write_text(text)
PY
}

install_all_skills() {
  local source_root="$1"
  local dest_base
  local has_publish=false

  if [ "$MODE" = "project" ]; then
    dest_base="$(pwd)/.pi/skills"
  else
    dest_base="$HOME/.pi/agent/skills"
  fi
  mkdir -p "$dest_base"

  # Collect skill dirs: prefer skills/ subdir, fall back to root level
  local skill_dirs=()
  if [ -d "$source_root/skills" ]; then
    for d in "$source_root/skills"/*/; do
      [ -d "$d" ] || continue
      [ -f "$d/SKILL.md" ] && skill_dirs+=("$d")
    done
  else
    for d in "$source_root"/*/; do
      [ -d "$d" ] || continue
      [ -f "$d/SKILL.md" ] && skill_dirs+=("$d")
    done
  fi

  if [ ${#skill_dirs[@]} -eq 0 ]; then
    echo "Error: no skills found in $source_root" >&2
    exit 1
  fi

  for skill_path in "${skill_dirs[@]}"; do
    local skill_name
    skill_name="$(basename "$skill_path")"
    local dest="$dest_base/$skill_name"

    if [ "$MODE" = "user" ] && { [ -e "$dest" ] || [ -L "$dest" ]; }; then
      if [ "$FORCE" = "true" ]; then
        rm -rf "$dest"
        cp -R "$skill_path" "$dest"
        echo "Updated existing skill -> /skill:$skill_name"
      else
        local action mode resolved
        action="$(choose_conflict_action "$skill_name")"
        mode="${action%%:*}"
        resolved="${action#*:}"
        if [ "$mode" = "update" ]; then
          rm -rf "$dest"
          cp -R "$skill_path" "$dest"
          echo "Updated existing skill -> /skill:$skill_name"
        else
          cp -R "$skill_path" "$dest_base/$resolved"
          rewrite_skill_name "$dest_base/$resolved" "$resolved"
          echo "Conflict found: installed new skill as /skill:$resolved"
        fi
      fi
    else
      cp -R "$skill_path" "$dest"
      echo "Installed /skill:$skill_name -> $dest"
    fi

    [ "$skill_name" = "publish-message" ] && has_publish=true
  done

  $has_publish && choose_publish_setup "$TARGET"
}

choose_publish_setup() {
  local target="${1:-}"

  if [ "$target" != "all" ] && [ "$target" != "publish-message" ]; then
    return 0
  fi

  if [ -n "$SETUP_PLATFORMS" ]; then
    write_publish_message_env "$SETUP_PLATFORMS"
    return 0
  fi

  if [ -n "$SETUP_PLATFORM" ] && [ "$SETUP_PLATFORM" != "prompt" ] && [ -z "$SETUP_PLATFORMS" ]; then
    single_write_publish_message_env "$SETUP_PLATFORM"
    return 0
  fi

  if [ ! -t 0 ]; then
    return 0
  fi

  if [ -f "$HOME/.publish-message.env" ] && [ "$FORCE" != "true" ]; then
    return 0
  fi

  while true; do
    echo "Setup publish-message delivery? (comma-separated, e.g. 1,2,3)"
    echo "  1) Discord"
    echo "  2) Telegram"
    echo "  3) GitLab MR"
    echo "  4) Skip"
    printf "Choose [1-4] [1]: "
    IFS= read -r choice
    choice="${choice:-1}"

    case "$choice" in
      4) echo "Skipped publish-message setup."; break ;;
      *)
        local platforms=""
        local IFS=','
        for num in $choice; do
          num="${num## }"
          num="${num%% }"
          case "$num" in
            1) [ -n "$platforms" ] && platforms="$platforms,"; platforms="${platforms}discord" ;;
            2) [ -n "$platforms" ] && platforms="$platforms,"; platforms="${platforms}telegram" ;;
            3) [ -n "$platforms" ] && platforms="$platforms,"; platforms="${platforms}gitlab" ;;
          esac
        done
        if [ -z "$platforms" ]; then
          echo "No valid choice, retry."
          continue
        fi
        write_publish_message_env "$platforms"
        break
        ;;
    esac
  done
}

while [ $# -gt 0 ]; do
  case "$1" in
    --project) MODE="project"; shift ;;
    --force) FORCE="true"; shift ;;
    --repo) REPO_URL="${2:?missing repo url}"; shift 2 ;;
    --setup) SETUP_PLATFORM="prompt"; shift ;;
    --setup-discord) [[ ",$SETUP_PLATFORMS," != *",discord,"* ]] && SETUP_PLATFORMS="${SETUP_PLATFORMS:+$SETUP_PLATFORMS,}discord"; shift ;;
    --setup-telegram) [[ ",$SETUP_PLATFORMS," != *",telegram,"* ]] && SETUP_PLATFORMS="${SETUP_PLATFORMS:+$SETUP_PLATFORMS,}telegram"; shift ;;
    --setup-gitlab) [[ ",$SETUP_PLATFORMS," != *",gitlab,"* ]] && SETUP_PLATFORMS="${SETUP_PLATFORMS:+$SETUP_PLATFORMS,}gitlab"; shift ;;
    --discord-webhook-url) DISCORD_WEBHOOK_URL="${2:?missing Discord webhook URL}"; [[ ",$SETUP_PLATFORMS," != *",discord,"* ]] && SETUP_PLATFORMS="${SETUP_PLATFORMS:+$SETUP_PLATFORMS,}discord"; shift 2 ;;
    --telegram-bot-token) TELEGRAM_BOT_TOKEN="${2:?missing Telegram bot token}"; [[ ",$SETUP_PLATFORMS," != *",telegram,"* ]] && SETUP_PLATFORMS="${SETUP_PLATFORMS:+$SETUP_PLATFORMS,}telegram"; shift 2 ;;
    --telegram-chat-id) TELEGRAM_CHAT_ID="${2:?missing Telegram chat ID}"; [[ ",$SETUP_PLATFORMS," != *",telegram,"* ]] && SETUP_PLATFORMS="${SETUP_PLATFORMS:+$SETUP_PLATFORMS,}telegram"; shift 2 ;;
    --gitlab-token) GITLAB_TOKEN="${2:?missing GitLab token}"; [[ ",$SETUP_PLATFORMS," != *",gitlab,"* ]] && SETUP_PLATFORMS="${SETUP_PLATFORMS:+$SETUP_PLATFORMS,}gitlab"; shift 2 ;; 

    --gitlab-api-url) GITLAB_API_URL="${2:?missing GitLab API URL}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) TARGET="$1"; shift ;;
  esac
done

if [ "$SETUP_PLATFORM" = "prompt" ]; then
  SETUP_PLATFORM=""
  FORCE="true"
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}" 2>/dev/null)" 2>/dev/null && pwd)" || SCRIPT_DIR="$(pwd)"

if [ "$TARGET" = "all" ]; then
  NAME="pi-skills"
else
  NAME="$TARGET"
fi

if [ "$MODE" = "project" ]; then
  DEST="$(pwd)/.pi/skills/$NAME"
else
  if [ "$TARGET" != "all" ] && { [ -e "$HOME/.pi/agent/skills/$TARGET" ] || [ -L "$HOME/.pi/agent/skills/$TARGET" ]; }; then
    ACTION="$(choose_conflict_action "$TARGET")"
    if [ "${ACTION%%:*}" = "update" ]; then
      NAME="$TARGET"
      FORCE="true"
    else
      NAME="${ACTION#*:}"
    fi
  fi
  DEST="$HOME/.pi/agent/skills/$NAME"
fi

if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  if [ "$FORCE" != "true" ]; then
    echo "Already exists: $DEST"
    echo "Use --force to replace it."
    exit 1
  fi
  rm -rf "$DEST"
fi

mkdir -p "$(dirname "$DEST")"

if [ "$TARGET" = "all" ] && [ -d "$SCRIPT_DIR/.git" ]; then
  install_all_skills "$SCRIPT_DIR"
  echo "Restart pi."
  exit 0
fi

if [ -f "$SCRIPT_DIR/$TARGET/SKILL.md" ]; then
  cp -R "$SCRIPT_DIR/$TARGET" "$DEST"
  if [ "$NAME" != "$TARGET" ]; then
    rewrite_skill_name "$DEST" "$NAME"
    echo "Conflict found: installed new skill as /skill:$NAME"
  fi
  echo "Installed $NAME -> $DEST"
  choose_publish_setup "$TARGET"
  echo "Restart pi, then use: /skill:$NAME"
  exit 0
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if [ "$TARGET" = "all" ]; then
  git clone --quiet "$REPO_URL" "$TMP_DIR/pi-skills"
  install_all_skills "$TMP_DIR/pi-skills"
  echo "Restart pi."
  exit 0
fi

git clone --quiet --filter=blob:none --sparse "$REPO_URL" "$TMP_DIR/pi-skills"
cd "$TMP_DIR/pi-skills"
git sparse-checkout set "$TARGET" >/dev/null

if [ ! -f "$TMP_DIR/pi-skills/$TARGET/SKILL.md" ]; then
  echo "Error: skill not found: $TARGET" >&2
  exit 1
fi

cp -R "$TMP_DIR/pi-skills/$TARGET" "$DEST"
if [ "$NAME" != "$TARGET" ]; then
  rewrite_skill_name "$DEST" "$NAME"
  echo "Conflict found: installed new skill as /skill:$NAME"
fi
echo "Installed $NAME -> $DEST"
choose_publish_setup "$TARGET"
echo "Restart pi, then use: /skill:$NAME"
