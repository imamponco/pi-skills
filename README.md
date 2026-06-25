# pi-skills

A collection of skills for [pi-coding-agent](https://pi.dev).

## Skills

| Skill | `/skill:` | Description |
|-------|-----------|-------------|
| [code-review](code-review/SKILL.md) | `code-review` | Multi-agent PR review squad. Generates `review_result.md`. |
| [publish-message](publish-message/SKILL.md) | `publish-message` | Sends any Markdown/text file to Discord, Telegram, or GitLab MR. Defaults to `review_result.md`. |

## Requirements

`code-review` requires [`pi-multiagent`](https://pi.dev/packages/pi-multiagent). This package provides `agent_team` orchestration and `/skill:pi-multiagent`.

### Install pi-multiagent

Install globally:

```bash
pi install npm:pi-multiagent
```

Or install for current project only:

```bash
pi install -l npm:pi-multiagent
```

Restart pi, then verify inside pi:

```text
/skill:pi-multiagent
```

If command appears, `code-review` can run. If not, update/reconcile packages:

```bash
pi update --extensions
```

Manual fallback if package is already downloaded but skill is not visible:

```bash
mkdir -p ~/.pi/agent/skills
cp -R ~/.pi/agent/npm/node_modules/pi-multiagent/skills/pi-multiagent ~/.pi/agent/skills/pi-multiagent
```

Then restart pi again.

## Quick Install

Recommended order:

```bash
pi install npm:pi-multiagent
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- all --force
```

Then restart pi.

Install only `code-review`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- code-review
```

Install only `publish-message` and choose setup (Discord, Telegram, GitLab, or skip):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --force
```

Install all skills and choose setup:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- all --force
```

Project-level install:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- all --project --force
```

## Non-interactive setup

```bash
# Discord
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --discord-webhook-url "https://discord.com/api/webhooks/xxx/yyy"

# Telegram
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --telegram-bot-token "123:abc" --telegram-chat-id "123456"

# GitLab MR (PAT only; project/MR passed during publish)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --gitlab-token "glpat-xxx"
```

If same skill name already exists, installer prompts: update existing skill or create new skill with custom name. In non-interactive mode, `--force` updates existing; without `--force`, installer creates next available name like `code-review-1`. Restart pi after install.

## Workflow

```bash
# Generate review_result.md from current branch vs main
/skill:code-review main

# Send review_result.md to configured platform(s)
/skill:publish-message

# Send custom file
/skill:publish-message docs/summary.md

# GitLab MR by numeric project ID
/skill:publish-message --gitlab-project-id 123 --gitlab-mr-iid 45

# GitLab MR by URL, including self-hosted GitLab
/skill:publish-message --gitlab-url https://gitlab.example.com/namespace/project/-/merge_requests/42
```

## Local install from clone

```bash
git clone git@github.com:imamponco/pi-skills.git ~/pi-skills
cd ~/pi-skills
./install.sh all --force
```

## License

MIT
