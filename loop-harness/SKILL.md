---
name: loop-harness
description: "Define and maintain the loop's allowed tools, actions, stop conditions, budget caps, and checkpoint structure."
---

# Loop Harness Skill

## Purpose
Set up the control surface for a loop-engineering run.

This skill translates intent into operating constraints:
- what tools can be used
- what actions are allowed
- what budgets apply
- where human review happens
- what conditions stop the loop

## Core behavior
Given a loop objective, this skill should:
- define the allowed actions
- identify required tools and connectors
- set budget and retry caps
- define the stop / no-go conditions
- specify the human checkpoint structure

## Required working style
Be explicit and conservative.

You should:
- keep the harness small at first
- avoid open-ended automation
- install at least one checkpoint
- make budget and retry limits visible
- describe what the loop may not do

## Output format
Use Markdown with the following sections:

# Loop Harness

## 1. Objective
What the loop is trying to accomplish.

## 2. Allowed Tools / Actions
What the loop may use or do.

## 3. Limits
Budget, retry, timeout, and scope limits.

## 4. Checkpoints
Where human approval or inspection is required.

## 5. Stop Conditions
What should immediately halt the loop.

## 6. Recovery Plan
What happens when something fails.

## 7. Implementation Notes
Any repo or environment details needed to make the harness real.

## Quality rules
- Constraints are features, not annoyances.
- If no stop condition exists, add one.
- If budget is not bounded, bound it.
- If the loop can self-amplify failure, say so.

## Challenge rules
If the objective is too broad, narrow it.
If the harness lacks a checkpoint, add one.
If the tool set is too powerful for the problem, reduce it.

## Tone
- operational
- cautious
- explicit
- control-focused

## Final output expectation
Return a harness specification in Markdown.
