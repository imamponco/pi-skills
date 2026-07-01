# pi-skills

A collection of skills for [pi-coding-agent](https://pi.dev).

> Status: pre-release (`v0.1.0-pre.1`). Behavior and skill prompts may still change.

## Overview

`pi-skills` is organized into reusable skill families:

- **Review and publishing**: `code-review`, `publish-message`
- **Planning**: `prd`, `task-detail`
- **Execution loop**: `task-breakdown`, `task-execute`, `task-verify`, `task-loop`
- **Loop engineering**: `loop-engineering`, `morning-triage`, `loop-state`, `loop-judge`, `loop-harness`, `loop-scheduler`

The goal is to keep each skill small, stable, and composable so you can build workflows without turning them into one large prompt.

## Skills

| Skill | `/skill:` | Description |
|-------|-----------|-------------|
| [code-review](code-review/SKILL.md) | `code-review` | Multi-agent PR review squad. Generates `review_result.md`. |
| [publish-message](publish-message/SKILL.md) | `publish-message` | Sends any Markdown/text file to Discord, Telegram, or GitLab MR. Defaults to `review_result.md`. |
| [prd](prd/SKILL.md) | `prd` | Turns vague ideas into a structured, challengeable PRD. |
| [task-detail](task-detail/SKILL.md) | `task-detail` | Converts an approved PRD into implementation-ready tasks, estimates, and timeline. |
| [task-breakdown](task-breakdown/SKILL.md) | `task-breakdown` | Breaks plans into atomic execution tasks and identifies the next best slice. |
| [task-execute](task-execute/SKILL.md) | `task-execute` | Executes one atomic task with minimal safe changes. |
| [task-verify](task-verify/SKILL.md) | `task-verify` | Verifies implementation against task-detail and acceptance criteria. |
| [task-loop](task-loop/SKILL.md) | `task-loop` | Orchestrates the iterative break-execute-verify loop. |
| [loop-engineering](loop-engineering/SKILL.md) | `loop-engineering` | Coordinates the loop-engineering stack and human checkpoints. |
| [morning-triage](morning-triage/SKILL.md) | `morning-triage` | Reads fresh inputs, triages items, and writes initial loop state. |
| [loop-state](loop-state/SKILL.md) | `loop-state` | Persists durable loop memory across cycles. |
| [loop-judge](loop-judge/SKILL.md) | `loop-judge` | Independently judges whether outputs are worth acting on. |
| [loop-harness](loop-harness/SKILL.md) | `loop-harness` | Defines loop tools, limits, checkpoints, and stop conditions. |
| [loop-scheduler](loop-scheduler/SKILL.md) | `loop-scheduler` | Time-boxes and reschedules recurring loop runs. |

## Quick links for the added skills

For a full usage guide, see [`docs/skills.md`](docs/skills.md).

### Planning and task execution

- `prd` — `/skill:prd`
- `task-detail` — `/skill:task-detail`
- `task-breakdown` — `/skill:task-breakdown`
- `task-execute` — `/skill:task-execute`
- `task-verify` — `/skill:task-verify`
- `task-loop` — `/skill:task-loop`

### Loop engineering workflow

- `loop-engineering` — `/skill:loop-engineering`
- `morning-triage` — `/skill:morning-triage`
- `loop-state` — `/skill:loop-state`
- `loop-judge` — `/skill:loop-judge`
- `loop-harness` — `/skill:loop-harness`
- `loop-scheduler` — `/skill:loop-scheduler`

### Recommended flows

- Task flow: `/skill:prd` → `/skill:task-detail` → `/skill:task-breakdown` → `/skill:task-execute` → `/skill:task-verify` → `/skill:task-loop`
- Loop flow: `/skill:morning-triage` → `/skill:loop-state` → `/skill:loop-judge` → `/skill:loop-harness` → `/skill:loop-scheduler` → `/skill:loop-engineering`

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

## Quickstart

### 1) Install the baseline dependency

`code-review` needs `pi-multiagent`.

```bash
pi install npm:pi-multiagent
```

### 2) Install the skills

Recommended order:

```bash
pi install npm:pi-multiagent
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- all --force
```

Then restart pi.

If you later want to upgrade/reinstall without overwriting your existing publish-message config, use `update`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- update all
```

### 3) Install a single skill or everything

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

### 4) Verify the installed skills

In pi, check the skills you expect to use:

```text
/skill:code-review
/skill:publish-message
/skill:prd
/skill:loop-engineering
/skill:morning-triage
```

### 5) Start using the workflows

- Review and publish: `/skill:code-review main` → `/skill:publish-message`
- Plan work: `/skill:prd` → `/skill:task-detail`
- Execute work: `/skill:task-breakdown` → `/skill:task-execute` → `/skill:task-verify`
- Run a loop system: `/skill:morning-triage` → `/skill:loop-state` → `/skill:loop-judge` → `/skill:loop-harness` → `/skill:loop-scheduler` → `/skill:loop-engineering`
- Run the best local quality check before shipping: `python3 scripts/run-best-local-check.py .`
- If there is no local command, the helper will tell you which common files were checked

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

Use `update` when you want to reinstall skills but keep your existing `~/.publish-message.env` delivery config.

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
