---
name: loop-engineering
description: "Coordinate the loop-engineering stack: discovery, state, harness, evaluator, scheduling, and human checkpoints."
---

# Loop Engineering Skill

## Purpose
Coordinate a loop-engineering workflow that continuously discovers work, records state, evaluates outputs, delivers changes through git, and reschedules the next cycle without losing human control.

This is the orchestration layer, not the implementation layer.
It should connect the smaller skills that make the loop safe, repeatable, and shippable.

## Core model
Loop engineering has five layers:
- **Prompt**: what the system should do
- **Context**: what the system can see right now
- **Harness**: what actions, tools, and limits are allowed
- **Delivery**: how changes are committed, pushed, and attached to an MR
- **Loop**: the recurring cycle that discovers, does, verifies, persists, and reschedules work

## Required working style
Be disciplined about control points.

You should:
- keep the loop small at first
- preserve a human checkpoint
- enforce budgets and stop conditions
- use an evaluator separate from the generator whenever possible
- persist loop state outside the conversation
- commit and push changes in small, reviewable units
- create a merge request when the branch is ready, or keep pushing commits to the existing MR branch if one already exists
- follow the repository's branch naming, commit naming, and MR title conventions consistently
- run the repo's local linter, test, verify, or security commands when they exist before shipping

## Inputs
This skill can accept:
- a PRD
- a task-detail plan
- a triage/state file
- a recurring objective
- a repo/worktree context
- the current git branch and MR status
- the target branch prefix or MR naming convention

## Output format
Use Markdown with the following sections:

# [Loop Engineering Title]

## 1. Objective
State the recurring objective of the loop.

## 2. Current Layering
Describe the prompt, context, harness, and loop layers relevant to the run.

## 3. Recommended Skill Chain
List the small skills that should be used in order.

## 4. Human Checkpoints
State where the human must inspect, approve, or say no.
Call out any point where a local quality or security check should be reviewed before continuing.

## 5. State Strategy
Explain what should be persisted and where.

## 6. Delivery / Git Strategy
Describe how the loop should commit, push, and handle merge requests.
Include the rule for an existing MR: push new commits to the same MR branch instead of creating a duplicate MR.
Include the rule that local lint, verify, and security checks should run before pushing if available.

### Branch naming
Use these branch prefixes when creating or selecting work branches:
- `feat/*` for feature work
- `fix/*` for bug fixes
- `rc/*` for release candidates

### MR title naming
Use these MR title prefixes:
- `Feature:` for `feat/*`
- `Fix:` for `fix/*`
- `Release Candidate:` for `rc/*`

### Commit naming
Use Angular-style conventional commits for all commits, for example:
- `feat(loop-engineering): add MR title rules`
- `fix(publish-message): handle empty file input`
- `chore(docs): update loop engineering guide`

### MR description
Always add a clear MR description. Include:
- summary of the change
- why the change is needed
- verification performed
- related branch name
- any follow-up risk or caveat

## 7. Stop Conditions
List the conditions that should halt the loop.
Treat failing local quality or security checks as a hard stop unless there is an explicit override.

## 8. Next Cycle
State the exact next step for the next iteration.

## Quality rules
- Do not let the loop become a black box.
- Keep generator and evaluator separated when possible.
- Treat budget and state as first-class controls.
- If the loop lacks a checkpoint, call that out.
- If the loop cannot be safely repeated, say so.

## Challenge rules
If the loop design is too broad, shrink it.
If the state is not durable, note the risk.
If the evaluator can only grade its own output, call that out as weak.
If git delivery is missing, call that out as a shipping gap.
If the plan creates duplicate merge requests instead of updating the existing branch, flag it as wasteful.
If the branch prefix, MR title, or commit style is missing, call it out as inconsistent delivery.
If the MR description is missing useful context, flag it as incomplete.
If local lint or security checks are skipped without a good reason, flag that as avoidable risk.

## Tone
- strategic
- skeptical when needed
- practical
- loop-safe

## Final output expectation
Return a loop-engineering plan in Markdown.
