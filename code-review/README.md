# code-review

Multi-agent PR review squad for [pi-coding-agent](https://pi.dev). Diffs your branch against a target, spawns 4 parallel reviewers, gatekeeper filters noise → `review_result.md`.

## Requirements

`code-review` uses [`pi-multiagent`](https://pi.dev/packages/pi-multiagent) for parallel reviewer orchestration (`agent_team` + `/skill:pi-multiagent`).

### Install pi-multiagent

Global install:

```bash
pi install npm:pi-multiagent
```

Project-only install:

```bash
pi install -l npm:pi-multiagent
```

Restart pi, then check inside pi:

```text
/skill:pi-multiagent
```

If unavailable after restart, reconcile packages:

```bash
pi update --extensions
```

Manual fallback if package files exist but skill is not visible:

```bash
mkdir -p ~/.pi/agent/skills
cp -R ~/.pi/agent/npm/node_modules/pi-multiagent/skills/pi-multiagent ~/.pi/agent/skills/pi-multiagent
```

Restart pi again.

## Install

Install prerequisite first:

```bash
pi install npm:pi-multiagent
```

Install only `code-review`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- code-review
```

Install `code-review` + `publish-message` and choose publisher setup:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/imamponco/pi-skills/main/install.sh)" -- all --force
```

Restart pi, then use `/skill:code-review` in any git repo.

## Usage

```bash
/skill:code-review [target-branch]
```

Default target: `develop`.

| Command | Diff against |
|---------|-------------|
| `/skill:code-review` | `develop...HEAD` |
| `/skill:code-review main` | `main...HEAD` |
| `/skill:code-review refactor/x` | `refactor/x...HEAD` |

## Output

Writes `review_result.md` to your project root with readable tables:

- Summary counts by severity
- 🔴 Critical Security
- 🟠 High Priority
- 🟡 Medium Priority
- 🔵 Low Priority
- Suggested Tests
- Notes

Each finding includes file/line, problem, impact, and recommended fix. Empty sections auto-removed. If all clean: `✅ All Checks Passed`.

## The Squad

| Role | Catches |
|------|---------|
| **Senior Code Reviewer** | SQL bottlenecks, race conditions, missing validation, no unit tests, lint violations |
| **QA Engineer** | nil pointer panics, negative IDs, whitespace-only names, boundary busts, timeout holes |
| **Product Manager** | Breaking API changes, backward compat breaks, UX regressions |
| **IT Security Engineer** | JWT logged to console, missing auth checks, injection surfaces |
| **Diff Corrector** | Strips comments about untouched code, formats final markdown |

## Delivery

Use separate skill:

```bash
/skill:publish-message
```

## Structure

```text
code-review/
├── SKILL.md
├── REVIEW_AGENT.md
├── package.json
└── README.md
```

## License

MIT
