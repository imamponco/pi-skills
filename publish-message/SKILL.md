---
name: publish-message
description: "Sends review_result.md to Discord, Telegram, or GitLab MR using publish_message.sh. Use after code-review generates review_result.md."
---

# Publish Message

Send a Markdown/text file from current working directory to configured platforms. Default file is `review_result.md`. Supports multiple platforms simultaneously (`ACTIVE_PLATFORM=discord,telegram`).

## Behavior

1. If user provides a file path argument, use that file. If no argument, use `review_result.md`.
2. Confirm the file exists in the user's current working directory.
3. Run this helper script from this skill directory:
   ```bash
   bash publish_message.sh [file]
   ```
4. If config is missing, the script creates `~/.publish-message.env` and exits with setup instructions.
5. The script automatically chunks long messages to fit platform limits.

## Config

Config file:

```bash
~/.publish-message.env
```

Supported platforms:

- `discord`
- `telegram`
- `gitlab`

Example config lives beside this file:

```bash
.publish-message.env.example
```

## Usage

```bash
/skill:publish-message [file] [options]
```

GitLab requires MR routing args:

```bash
/skill:publish-message review_result.md --gitlab-project-id 123 --gitlab-mr-iid 45

# By URL
/skill:publish-message review_result.md --gitlab-url https://gitlab.com/namespace/project/-/merge_requests/123

# Self-hosted by URL
/skill:publish-message review_result.md --gitlab-url https://gitlab.example.com/namespace/project/-/merge_requests/123
```

Usually after:

```bash
/skill:code-review main
/skill:publish-message

# or send any file
/skill:publish-message docs/summary.md

# GitLab MR
/skill:publish-message review_result.md --gitlab-project-id 123 --gitlab-mr-iid 45
/skill:publish-message review_result.md --gitlab-api-url https://gitlab.example.com --gitlab-project-id 123 --gitlab-mr-iid 45
```
