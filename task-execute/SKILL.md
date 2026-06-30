---
name: task-execute
description: "Execute one atomic task from a task-detail or task-breakdown by making the smallest safe implementation change and documenting the result."
---

# Task Execute Skill

## Purpose
Carry out one focused engineering task from a task-detail or task breakdown.

This skill is for small, bounded execution steps. It should complete one task end-to-end, not the entire project.

## Core behavior
Given a single task:
- understand the task scope
- inspect the relevant code or artifacts
- make the smallest safe change needed
- update tests or docs if required
- report what changed and what remains

## Required working style
Be disciplined about scope.

You should:
- avoid scope creep
- make minimal changes
- preserve existing behavior unless the task requires change
- call out uncertainty before making risky edits
- stop and ask if the task is too large or ambiguous

## What counts as a valid task
A valid task is small enough to complete in one focused iteration, such as:
- adding a helper
- wiring a flag
- fixing one bug
- implementing one API behavior
- writing one test set
- updating one doc section

If the task is larger than that, recommend breaking it down first.

## Execution process
1. Read the task description and acceptance criteria.
2. Identify the minimum files or artifacts involved.
3. Determine whether the task is safe to implement as-is.
4. Execute the change.
5. Validate the result.
6. Prefer project-local quality commands where the repo provides them, such as lint, test, verify, audit, or security checks.
7. If the repo has no obvious local quality command, inspect common project files before falling back to manual checks.
8. Summarize what changed, what was verified, and any follow-up needed.

## Output format
Use Markdown with the following sections:

# [Task Name]

## 1. Task Selected
State the exact task being executed.

## 2. Plan
Briefly describe the minimal implementation approach.

## 3. Changes Made
List the concrete changes.

## 4. Files Touched
List modified files.

## 5. Validation
Describe tests, checks, or manual verification performed.

## 6. Result
State whether the task is done, partially done, or blocked.

## 7. Remaining Risks / Follow-up
Any known caveats or next steps.

## Quality rules
- Keep changes small and explainable.
- Prefer the safest implementation path.
- Add tests when they materially reduce risk.
- Do not silently broaden the task.
- If the repo has a local linter or security command, use it before claiming the task is done.
- If no local command exists, inspect common project files before choosing a manual fallback.
- If the task cannot be completed safely, stop and explain why.

## Challenge rules
If the task definition is vague, do not guess.
If the task depends on unresolved PRD ambiguity, raise it.
If implementation reveals a better design, note it but do not expand scope unless asked.

## Tone
- focused
- practical
- cautious where needed
- execution-first

## Final output expectation
Return a concise implementation report in Markdown.
