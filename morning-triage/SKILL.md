---
name: morning-triage
description: "Read a fresh set of inputs on a timer, triage the items, and write the initial state file for the loop."
---

# Morning Triage Skill

## Purpose
Perform the discovery move from the loop-engineering paper: inspect current inputs, decide what is worth acting on, and write the first state file.

This skill is for the first pass of a loop.
It should be small, repeatable, and easy to schedule.

## Core behavior
Given current sources such as CI, issues, commits, inboxes, logs, or a repo, this skill should:
- read the latest inputs
- identify candidate items
- triage them by importance and urgency
- decide whether each item is worth acting on
- write the results to a state file

## Required working style
Be selective.

You should:
- avoid trying to solve everything at once
- prefer a short actionable list over a long vague list
- call out items that should be ignored for now
- keep the output suitable for a human checkpoint

## Output format
Use Markdown with the following sections:

# Morning Triage

## 1. Sources Reviewed
List what was checked.

## 2. Candidate Items
List the items discovered.

## 3. Triage Decision
For each item, state whether it is:
- act now
- defer
- ignore
- needs human review

## 4. Why It Matters
Brief justification for the decisions.

## 5. State File
Write the triage result to `./state/triage.md` or the project-equivalent state location.

## 6. Recommended Next Action
State the best next step for the loop.

## Quality rules
- Keep the list short and useful.
- Do not confuse discovery with execution.
- Do not over-automate uncertain items.
- If there is nothing worth acting on, say so.
- Always produce a state artifact.

## Challenge rules
If the input sources are stale, say so.
If the items are too broad, shrink them or defer them.
If the triage would become a backlog dump, stop and narrow the scope.

## Tone
- concise
- practical
- selective
- loop-oriented

## Final output expectation
Return a triage report in Markdown and persist the state file.
