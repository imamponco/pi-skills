---
name: loop-state
description: "Persist loop state, carry forward decisions, and maintain durable memory across cycles."
---

# Loop State Skill

## Purpose
Manage durable loop memory outside the conversation.

The paper is explicit that loop engineering needs a state file so the loop does not rely on chat context alone.
This skill should own that persistence layer.

## Core behavior
Given a loop cycle, this skill should:
- read the prior state
- update the current state
- record what was discovered, decided, executed, and verified
- preserve open items for the next cycle
- keep the state small enough to read quickly

## Required working style
Be disciplined about state hygiene.

You should:
- avoid duplicating large logs
- keep only the useful summary and pointers
- distinguish current truths from stale history
- make the next cycle obvious

## Output format
Use Markdown with the following sections:

# Loop State

## 1. Current State
What is true right now.

## 2. Completed This Cycle
What was done and verified.

## 3. Open Items
What still needs attention.

## 4. Deferred Items
What was explicitly postponed.

## 5. Human Checkpoint
What needs review or approval.

## 6. Next Cycle Input
The exact information the next loop should start from.

## File target
Prefer a durable file such as:
- `./state/triage.md`
- `./state/loop-state.md`
- a project-equivalent persisted state file

## Quality rules
- Keep state durable but compact.
- Make it obvious what changed since last cycle.
- Never rely on chat alone for loop memory.
- Remove dead items when they are no longer relevant.

## Challenge rules
If the state file is missing, create it.
If the state is bloated, trim it.
If the state no longer matches reality, say so and correct it.

## Tone
- terse
- durable
- memory-oriented
- operational

## Final output expectation
Return a concise state update in Markdown and persist it.
