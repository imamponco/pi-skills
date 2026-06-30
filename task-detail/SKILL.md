---
name: task-detail
description: Convert an approved PRD into implementation-ready engineering tasks, estimates, dependencies, and an ideal timeline.
---

# Task Detail Skill

## Purpose
Turn an approved PRD into a detailed engineering execution plan.

This skill assumes the PRD is already approved or close to approved.
Its job is not to re-litigate the product strategy unless there is a contradiction, missing dependency, or impossible requirement.

## Core behavior
Given a PRD, produce:
- engineering task breakdown
- dependency sequence
- implementation notes
- estimates in mandays
- confidence/risk notes
- ideal timeline
- QA/testing tasks
- rollout considerations
- blockers and assumptions

## What this skill must optimize for
- execution readiness
- realistic planning
- dependency awareness
- estimation honesty
- operational clarity

## What this skill must not do
- Do not rewrite the PRD unless required to resolve a conflict.
- Do not treat estimates as certainty.
- Do not collapse all work into one vague task.
- Do not omit testing, review, or rollout work.
- Do not ignore cross-functional dependencies.

## Required working style
Be practical and precise.

You should:
- break work into sequenced tasks
- call out hidden work
- identify critical path items
- estimate effort using ranges, not fake precision
- show optimistic, realistic, and worst-case totals when useful
- challenge any tasking that is too vague, too large, or missing dependencies

## Input expectations
This skill expects:
- an approved PRD
- or a PRD that is ready to be translated into execution tasks

If the PRD is incomplete:
- identify the missing items
- either proceed with explicit assumptions or ask for clarification if the gap materially affects the plan

## Estimation rules
Use mandays as ranges, for example:
- 0.5–1 day
- 1–2 days
- 2–4 days

For each major task, include:
- estimated mandays
- confidence level if helpful
- key assumptions
- dependency notes

If you provide totals, include:
- **Optimistic total**
- **Realistic total**
- **Worst-case total**

Avoid presenting a single exact number unless the task is trivial.

## Timeline rules
Include an ideal timeline that reflects:
- task order
- dependencies
- parallelizable work
- review/QA time
- buffer for rework

If the schedule depends on team size, say so.
If the schedule assumes one engineer, say so.
If the schedule assumes parallel contributors, state that clearly.

## Output format
Use Markdown with the following sections:

# [Implementation Plan Title]

## 1. PRD Reference
Reference the PRD title and summarize the scope in one short paragraph.

## 2. Scope Summary
What is being built, in one concise block.

## 3. Assumptions
Any assumptions made in translating PRD to tasks.

## 4. Implementation Approach
High-level technical or delivery approach.

## 5. Task Breakdown
Break the work into clear tasks.

For each task include:
- task name
- description
- dependencies
- estimate in mandays
- notes / risks

Suggested task categories:
- discovery / refinement
- architecture or design
- backend work
- frontend work
- integration
- data migration
- automation
- testing / QA
- documentation
- rollout / release
- monitoring / follow-up

## 6. Dependencies and Critical Path
What must happen first and what could block delivery.

## 7. Estimates
Summarize estimated effort by task and total.

Include:
- optimistic total
- realistic total
- worst-case total

If useful, include confidence levels or risk multipliers.

## 8. Ideal Timeline
Provide an ideal delivery timeline in days or phases.

Example format:
- Day 1: ...
- Day 2: ...
- Day 3: ...

Or:
- Phase 1
- Phase 2
- Phase 3

Make sure the timeline accounts for review and QA.

## 9. Testing / QA Plan
What should be tested and how.

## 10. Rollout / Release Plan
Deployment, feature flags, migration, communication, fallback, or rollback considerations.

## 11. Risks / Blockers
What could delay, break, or increase effort.

## 12. Acceptance Checklist
A practical checklist for confirming the work is done.

## 13. Out-of-Scope Items
Anything intentionally left out.

## Quality rules
- Be concrete.
- Split large tasks into smaller executable pieces.
- Include hidden work such as tests, documentation, and rollout.
- If a task depends on another team or system, state it.
- If an estimate is uncertain, say why.
- Prefer a plan that can be executed by engineers without further interpretation.

## Challenge rules
If the PRD is unrealistic or underspecified, do not blindly convert it into tasks.
Instead:
- flag the issue
- identify the missing prerequisite
- explain the impact on schedule or delivery
- propose the smallest correction needed

## Tone
- direct
- execution-focused
- realistic
- not overly optimistic
- useful for engineering planning

## Final output expectation
Return a detailed implementation plan in Markdown that can be used to start engineering work.
