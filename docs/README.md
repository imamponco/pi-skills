# Skills Docs

This directory breaks the repo into one folder per skill family. The folder names use the stable skill names so docs stay aligned with the `/skill:` commands.

## Doc map

| Folder | Skills | Purpose |
|---|---|---|
| `docs/review` | `code-review`, `publish-message` | Review diffs and publish results |
| `docs/prd` | `prd` | Turn an idea into a challengeable PRD |
| `docs/task-detail` | `task-detail` | Convert PRDs into execution plans |
| `docs/task-breakdown` | `task-breakdown` | Split plans into atomic work |
| `docs/task-execute` | `task-execute` | Execute one atomic task |
| `docs/task-verify` | `task-verify` | Verify completed work |
| `docs/task-loop` | `task-loop` | Orchestrate break-execute-verify cycles |
| `docs/loop-engineering` | `loop-engineering` | Coordinate the full loop stack, including git delivery, MR handling, and naming conventions |
| `docs/morning-triage` | `morning-triage` | Triage fresh inputs into state |
| `docs/loop-state` | `loop-state` | Persist loop memory |
| `docs/loop-judge` | `loop-judge` | Independently evaluate work |
| `docs/loop-harness` | `loop-harness` | Define tools, budgets, and stop conditions |
| `docs/loop-scheduler` | `loop-scheduler` | Schedule and reschedule loop runs |

## Recommended starting points

- Review flow: `docs/review`
- Planning flow: `docs/prd`
- Execution flow: `docs/task-breakdown`
- Loop system flow: `docs/loop-engineering`
