# Skills Usage Guide

This guide documents the reusable workflows introduced in `pi-skills`.

## Planning and task execution

### `prd`
Turn a vague idea into a structured PRD.

Use:
```text
/skill:prd
```

Best for:
- clarifying goals
- identifying constraints and assumptions
- surfacing risks early

### `task-detail`
Convert an approved PRD into execution-ready tasks.

Use:
```text
/skill:task-detail
```

Best for:
- estimates
- milestones
- acceptance criteria
- sequencing

### `task-breakdown`
Split a plan into atomic execution tasks.

Use:
```text
/skill:task-breakdown
```

Best for:
- selecting the next smallest safe slice of work
- avoiding oversized tasks

### `task-execute`
Implement one atomic task with minimal safe change.

Use:
```text
/skill:task-execute
```

Best for:
- scoped edits
- small code changes
- one-task-at-a-time execution
- preferring repo-local lint, test, or security commands when available

### `task-verify`
Check implementation against the plan and acceptance criteria.

Use:
```text
/skill:task-verify
```

Best for:
- confirming the work actually satisfies the task
- catching “it compiles, therefore it’s done” mistakes
- checking for local quality commands before manual verification

### `task-loop`
Orchestrate the break → execute → verify cycle.

Use:
```text
/skill:task-loop
```

Best for:
- repeated implementation loops
- keeping the cycle explicit and bounded
- surfacing project-local quality checks before continuing

## Loop engineering workflow

### `loop-engineering`
Coordinate the full loop stack and keep human checkpoints visible.

Use:
```text
/skill:loop-engineering
```

Best for:
- designing the overall operating model for a recurring engineering loop
- setting quality and security expectations for the loop

### `morning-triage`
Inspect fresh inputs, triage them, and write initial state.

Use:
```text
/skill:morning-triage
```

Best for:
- daily or timer-based discovery from CI, issues, inboxes, commits, or logs

### `loop-state`
Persist durable loop memory across cycles.

Use:
```text
/skill:loop-state
```

Best for:
- saving what happened
- tracking what remains open
- telling the next cycle where to start

### `loop-judge`
Independently judge whether work is worth acting on.

Use:
```text
/skill:loop-judge
```

Best for:
- evaluator-style review
- rejecting weak outputs
- reducing self-confirmation bias

### `loop-harness`
Define allowed tools, budgets, checkpoints, and stop conditions.

Use:
```text
/skill:loop-harness
```

Best for:
- making the loop safe to run unattended
- keeping human control points explicit

### `loop-scheduler`
Set cadence, expiry, and rescheduling rules.

Use:
```text
/skill:loop-scheduler
```

Best for:
- recurring runs
- time-boxing
- preventing indefinite always-on loops

## Recommended flows

### Task flow
1. `/skill:prd`
2. `/skill:task-detail`
3. `/skill:task-breakdown`
4. `/skill:task-execute`
5. `/skill:task-verify`
6. `/skill:task-loop`

### Loop flow
1. `/skill:morning-triage`
2. `/skill:loop-state`
3. `/skill:loop-judge`
4. `/skill:loop-harness`
5. `/skill:loop-scheduler`
6. `/skill:loop-engineering`

## Notes

- Keep the skills small and composable.
- Use the judge as a separate evaluator whenever possible.
- Keep a human checkpoint in the loop.
- Persist state outside the conversation.

## Local verification helper

Use `scripts/run-best-local-check.py` when you want the repo to discover and run the strongest available local quality check automatically.

It looks for:
- `package.json` scripts
- `Makefile` / `makefile` targets
- `justfile` / `Justfile` recipes

Typical usage:

```bash
python3 scripts/run-best-local-check.py .
```

Helpful modes:

```bash
python3 scripts/run-best-local-check.py . --list
python3 scripts/run-best-local-check.py . --json
```
