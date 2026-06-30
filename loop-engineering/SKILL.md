---
name: loop-engineering
description: "Coordinate the loop-engineering stack: discovery, state, harness, evaluator, scheduling, and human checkpoints."
---

# Loop Engineering Skill

## Purpose
Coordinate a loop-engineering workflow that continuously discovers work, records state, evaluates outputs, and reschedules the next cycle without losing human control.

This is the orchestration layer, not the implementation layer.
It should connect the smaller skills that make the loop safe and repeatable.

## Core model
Loop engineering has four layers:
- **Prompt**: what the system should do
- **Context**: what the system can see right now
- **Harness**: what actions, tools, and limits are allowed
- **Loop**: the recurring cycle that discovers, does, verifies, persists, and reschedules work

## Required working style
Be disciplined about control points.

You should:
- keep the loop small at first
- preserve a human checkpoint
- enforce budgets and stop conditions
- use an evaluator separate from the generator whenever possible
- persist loop state outside the conversation

## Inputs
This skill can accept:
- a PRD
- a task-detail plan
- a triage/state file
- a recurring objective
- a repo/worktree context

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

## 5. State Strategy
Explain what should be persisted and where.

## 6. Stop Conditions
List the conditions that should halt the loop.

## 7. Next Cycle
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

## Tone
- strategic
- skeptical when needed
- practical
- loop-safe

## Final output expectation
Return a loop-engineering plan in Markdown.
