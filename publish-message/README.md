# publish-message

Sends any Markdown/text file to Discord, Telegram, or GitLab MR. Defaults to `review_result.md`.

## Install

Install only `publish-message`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message
```

Install and choose delivery setup (Discord, Telegram, GitLab, or skip):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --force
```

Non-interactive setup:

```bash
# Discord
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --discord-webhook-url "https://discord.com/api/webhooks/xxx/yyy"

# Telegram
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --telegram-bot-token "123:abc" --telegram-chat-id "123456"

# GitLab MR (PAT only; project/MR passed during publish)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- publish-message --gitlab-token "glpat-xxx"
```

## Usage

```bash
/skill:publish-message [file] [options]
```

Default:

```bash
/skill:publish-message
```

sends `review_result.md` to all configured platforms.

Custom file:

```bash
/skill:publish-message docs/summary.md
```

GitLab MR:

```bash
/skill:publish-message review_result.md --gitlab-project-id 123 --gitlab-mr-iid 45

# By URL
/skill:publish-message review_result.md --gitlab-url https://gitlab.com/namespace/project/-/merge_requests/123

# Self-hosted by URL
/skill:publish-message review_result.md --gitlab-url https://gitlab.example.com/namespace/project/-/merge_requests/123
```

## Config

Config path:

```bash
~/.publish-message.env
```

Example:

```bash
cp .publish-message.env.example ~/.publish-message.env
```

Supported platforms:

- Discord
- Telegram
- GitLab MR

## Message limits

`publish_message.sh` chunks long content automatically:

| Platform | Chunk target |
|----------|--------------|
| Discord | 1850 chars |
| Telegram | 3900 chars |
| GitLab MR | 950000 chars |

## Structure

```text
publish-message/
├── SKILL.md
├── publish_message.sh
├── .publish-message.env.example
├── package.json
└── README.md
```
