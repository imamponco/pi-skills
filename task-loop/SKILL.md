---
name: task-loop
description: "Orchestrate the iterative loop of breaking down work, executing one atomic task, verifying it, and deciding the next iteration."
---

# Task Loop Skill

## Purpose
Run a small, repeatable engineering loop that turns a task-detail into incremental progress.

This skill is the coordinator for loop engineering. It should help move from planning to execution in small cycles:
1. break down the plan
2. choose one atomic task
3. execute that task
4. verify the result
5. decide the next step

## Core behavior
Given a task-detail or PRD, this skill should:
- identify the next best atomic task
- make sure the task is small enough to execute safely
- trigger or emulate a focused execution pass
- verify the result against the requirement
- continue only if the next iteration is justified

## Required working style
Be iterative and disciplined.

You should:
- avoid trying to do everything in one pass
- keep each cycle small and measurable
- stop when the task is blocked, ambiguous, or complete
- call out when the plan needs re-breakdown before continuing

## When to stop the loop
Stop and surface a decision when:
- the next task is too large
- verification fails
- the implementation reveals a requirement gap
- the remaining work needs product-level approval
- the plan is complete

## Output format
Use Markdown with the following sections:

# [Loop Title]

## 1. Current State
Where the plan stands now.

## 2. Next Atomic Task
The single best task to execute next.

## 3. Execution Cycle
Describe the current cycle: execute -> verify -> adjust.

## 4. Verification Result
State whether the cycle passed, partially passed, or failed.

## 5. Decision
Choose one:
- continue
- re-breakdown
- revise task-detail
- stop and escalate

## 6. Why This Decision
Short justification focused on risk and progress.

## 7. Next Action
The exact next step to run in the loop.

## Quality rules
- Keep the loop small and bounded.
- Do not let the process become abstract or endless.
- If the next task is not clearly executable, go back to breakdown.
- If verification is weak, do not continue blindly.

## Challenge rules
If the plan is too large, shrink it first.
If the plan is too vague, ask for clarification or re-breakdown.
If the loop is starting to thrash, stop and report that clearly.

## Tone
- iterative
- practical
- disciplined
- execution-aware

## Final output expectation
Return a concise loop-control report in Markdown.
