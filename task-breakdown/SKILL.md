---
name: task-breakdown
description: "Turn an approved PRD or task-detail into atomic execution chunks, prioritized next steps, dependencies, and handoff-ready task cards."
---

# Task Breakdown Skill

## Purpose
Convert a PRD or implementation plan into the smallest useful execution units.

This skill is the bridge between planning and doing. It should reduce a large plan into tasks that are:
- atomic enough to execute
- clear enough to assign
- small enough to estimate
- ordered enough to start work safely

## Core behavior
Given a PRD or task-detail document, produce a breakdown that:
- isolates the next smallest executable steps
- identifies dependencies and blockers
- highlights what can run in parallel
- flags tasks that are still too large or ambiguous
- preserves the intent of the original plan

## Required working style
Be strict about task size.

You should:
- split oversized tasks
- detect hidden sub-work
- expose sequencing constraints
- point out unclear ownership or acceptance criteria
- recommend the smallest next actionable slice

## When to use this skill
Use this skill when:
- a PRD is approved and needs execution slicing
- a task-detail document is too coarse for direct implementation
- you need to prepare a backlog of small work items for iterative delivery

## Output format
Use Markdown with the following sections:

# [Task Breakdown Title]

## 1. Source Reference
Reference the PRD or task-detail being broken down.

## 2. Breakdown Goal
State the immediate delivery goal in one short paragraph.

## 3. Atomic Task List
List the smallest practical tasks in execution order.

For each task include:
- task name
- purpose
- dependencies
- estimated size if known
- notes / blockers

## 4. Parallelizable Work
Call out tasks that can run in parallel.

## 5. Critical Path
Identify the minimum sequence required to get to a shippable result.

## 6. Too-Large Items
Flag anything that should be split further before execution.

## 7. Recommended Next Action
Name the single best next task to start with.

## Quality rules
- Prefer smaller tasks over vague bigger tasks.
- If a task cannot be executed in one focused session, split it.
- Do not invent implementation details unless needed to define the task.
- Preserve order where dependencies matter.
- If the input is already granular enough, say so.

## Challenge rules
If the PRD or task-detail is too broad, say so explicitly.
If a task is underspecified, identify what is missing before execution starts.
If the plan appears to skip setup, testing, or rollout, call that out.

## Tone
- direct
- practical
- sequencing-aware
- execution-oriented

## Final output expectation
Return a concise but actionable task breakdown in Markdown.
