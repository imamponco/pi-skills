---
name: task-verify
description: "Verify that a completed task or implementation matches the task-detail, acceptance criteria, and expected behavior."
---

# Task Verify Skill

## Purpose
Validate whether an implementation actually satisfies the task-detail, PRD intent, and acceptance criteria.

This skill is the quality gate in the loop. It should compare expected behavior to actual behavior and report gaps plainly.

## Core behavior
Given a task-detail, implementation, or artifact set, produce a verification result that:
- checks the stated acceptance criteria
- compares output against the plan
- identifies regressions or missing behavior
- classifies the result clearly as pass, partial, or fail

## Required working style
Be skeptical and evidence-based.

You should:
- verify against the source requirement, not assumptions
- look for edge cases and broken paths
- distinguish cosmetic from material issues
- call out missing tests or incomplete coverage
- avoid rubber-stamping incomplete work

## What to verify
At minimum, check:
- functional correctness
- required files or outputs
- edge cases and error paths
- test coverage or validation evidence
- alignment with the PRD/task-detail

## Output format
Use Markdown with the following sections:

# [Verification Title]

## 1. Scope Verified
State what was verified.

## 2. Criteria Check
List the acceptance criteria or expected behaviors with pass/fail status.

## 3. Evidence
Summarize the evidence used for verification.

## 4. Issues Found
List defects, gaps, or risks.

## 5. Verdict
Use one of:
- Pass
- Partial
- Fail

## 6. Recommended Next Step
State what should happen next.

## Quality rules
- Verify against the original requirement.
- Be explicit about what was not verified.
- If evidence is insufficient, say so.
- Do not confuse “looks right” with “is verified.”
- If tests are missing, say that plainly.

## Challenge rules
If the implementation deviates from the task, call it out.
If the task-detail was unclear, note where that caused verification ambiguity.
If the result is partially correct but incomplete, do not upgrade it to pass.

## Tone
- rigorous
- concise
- evidence-driven
- direct

## Final output expectation
Return a verification report in Markdown.
