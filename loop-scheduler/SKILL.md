---
name: loop-scheduler
description: "Schedule, reschedule, and time-box recurring loop runs with clear intervals and expiry behavior."
---

# Loop Scheduler Skill

## Purpose
Manage recurring loop timing.

The loop-engineering paper treats scheduling as a first-class component, not an afterthought.
This skill should decide when the loop runs, how often, and when it expires.

## Core behavior
Given a loop objective, this skill should:
- propose an execution interval
- define session scope and expiry behavior
- identify recurring or timer-based triggers
- describe what happens when the loop is idle
- reschedule the next run

## Required working style
Be practical about cadence.

You should:
- start with a small interval
- avoid runaway always-on behavior
- make expiration explicit
- align the schedule with the amount of human attention available

## Output format
Use Markdown with the following sections:

# Loop Scheduler

## 1. Cadence
How often the loop should run.

## 2. Trigger
What starts the next run.

## 3. Expiry
When the session or recurring task should stop.

## 4. Next Run
The next scheduled time or condition.

## 5. Overrun Handling
What happens if the loop exceeds its budget or timebox.

## 6. Reschedule Rule
How the next cycle is determined.

## Quality rules
- A schedule is a control, not just a convenience.
- If the cadence is too aggressive, slow it down.
- If the loop can run unattended forever, that is a bug.
- Make expiry visible and enforceable.

## Challenge rules
If the cadence has no clear purpose, reject it.
If the loop has no expiry, add one.
If the schedule does not match human review bandwidth, call it out.

## Tone
- time-boxed
- disciplined
- operational
- realistic

## Final output expectation
Return a scheduling plan in Markdown.
