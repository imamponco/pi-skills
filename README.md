# pi-skills

A collection of skills for [pi-coding-agent](https://pi.dev).

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

## How to use the added skills

### Planning and task execution

- **`prd`** — turn a vague idea into a structured PRD.
  - Use: `/skill:prd`
  - Good for: clarifying goals, constraints, assumptions, and risks before implementation.

- **`task-detail`** — convert an approved PRD into execution-ready tasks.
  - Use: `/skill:task-detail`
  - Good for: estimates, milestones, acceptance criteria, and sequencing.

- **`task-breakdown`** — split a plan into atomic execution tasks.
  - Use: `/skill:task-breakdown`
  - Good for: identifying the next smallest safe slice of work.

- **`task-execute`** — implement one atomic task with minimal safe change.
  - Use: `/skill:task-execute`
  - Good for: small code changes, scoped edits, and one-task-at-a-time execution.

- **`task-verify`** — check implementation against the plan and acceptance criteria.
  - Use: `/skill:task-verify`
  - Good for: confirming the work actually satisfies the task, not just that it compiles.

- **`task-loop`** — orchestrate the break → execute → verify cycle.
  - Use: `/skill:task-loop`
  - Good for: repeated implementation loops when you want a structured iteration path.

### Loop engineering workflow

- **`loop-engineering`** — coordinate the full loop stack and keep human checkpoints visible.
  - Use: `/skill:loop-engineering`
  - Good for: designing the overall operating model for a recurring engineering loop.

- **`morning-triage`** — inspect fresh inputs, triage them, and write initial state.
  - Use: `/skill:morning-triage`
  - Good for: daily or timer-based discovery from CI, issues, inboxes, commits, or logs.

- **`loop-state`** — persist durable loop memory across cycles.
  - Use: `/skill:loop-state`
  - Good for: saving what happened, what remains open, and what should happen next.

- **`loop-judge`** — independently judge whether work is worth acting on.
  - Use: `/skill:loop-judge`
  - Good for: evaluator-style review, rejection of weak outputs, and reducing self-confirmation bias.

- **`loop-harness`** — define allowed tools, budgets, checkpoints, and stop conditions.
  - Use: `/skill:loop-harness`
  - Good for: making the loop safe to run unattended without removing human control.

- **`loop-scheduler`** — set cadence, expiry, and rescheduling rules.
  - Use: `/skill:loop-scheduler`
  - Good for: recurring runs, time-boxing, and preventing indefinite always-on loops.

### Recommended loop flow

A practical sequence is:

1. `/skill:morning-triage`
2. `/skill:loop-state`
3. `/skill:loop-judge`
4. `/skill:loop-harness`
5. `/skill:loop-scheduler`
6. `/skill:loop-engineering`

Use the task workflow when the loop produces implementation work:

1. `/skill:prd`
2. `/skill:task-detail`
3. `/skill:task-breakdown`
4. `/skill:task-execute`
5. `/skill:task-verify`
6. `/skill:task-loop`

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
