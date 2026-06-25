---
name: code-review
description: Multi-agent code review squad — runs 4 parallel reviewers (Senior Dev, QA, PM, Security) against a git diff, compiles into review_result.md. Use during PR/code review workflows.
---

You are the Orchestrator. Execute a 5-way code review using `/skill:pi-multiagent` and export to `review_result.md`.

### Argument Handling
- User provided string → use as `[TARGET_BRANCH]`
- Empty → default to `develop`

### Operational Instructions

1. **Load Personas** — Read `REVIEW_AGENT.md` (same dir as this SKILL.md). Use exact definitions.

2. **Fetch Diff** — Run in the user's working directory:
   ```bash
   git diff [TARGET_BRANCH]...HEAD
   ```
   Save to `/tmp/code-review_diff.txt`.

3. **Summarize Diff** — Launch `summarizer` step (first, solo):
   ```json
   {"id": "summarizer", "task": "Read /tmp/code-review_diff.txt. Output per-file summary: file path, changed functions/structs, added/deleted lines count, risk level (low/medium/high). One line per file. No prose.\nSave to /tmp/code-review_summary.md"}
   ```

4. **Execute Squad** — After summarizer, launch 4 parallel steps:
   - `reviewer` — architecture, lint, validation, test gen
   - `qa` — edge cases, nil checks, timeouts
   - `pm` — backward compat, API contracts, UX
   - `security` — secrets, injection, auth gaps

   Each reads **only** `/tmp/code-review_summary.md` (not raw diff). Output ONLY actionable findings as compact table rows. No preamble.

5. **Gatekeep** — 5th step `gatekeeper` with `needs: [reviewer, qa, pm, security]`:
   - Read **only** `/tmp/code-review_summary.md` + all reviewer outputs
   - Filter out feedback referencing files/lines NOT in diff
   - Compile into template from REVIEW_AGENT.md, remove empty sections

6. **Export** — Gatekeeper writes final output to `review_result.md` in user's cwd.

6. **Deliver (Optional)** — After export, user can run `/skill:publish-message` to push `review_result.md` to Discord, Telegram, or GitLab MR.

### Graph configuration pattern

```json
{
  "objective": "Code review of [TARGET]...HEAD",
  "authority": {"allowFilesystemRead": true, "allowShellTools": true},
  "limits": {"concurrency": 4},
  "steps": [
    {"id": "summarizer", "task": "Read /tmp/code-review_diff.txt. Output per-file summary: file path, changed functions/structs, added/deleted lines, risk level. Save to /tmp/code-review_summary.md"},
    {"id": "reviewer", "agent": {"system": "...persona from REVIEW_AGENT.md..."}, "task": "Read /tmp/code-review_summary.md. Output actionable findings as table rows. No preamble.", "after": ["summarizer"]},
    {"id": "qa", ..., "after": ["summarizer"]},
    {"id": "pm", ..., "after": ["summarizer"]},
    {"id": "security", ..., "after": ["summarizer"]},
    {"id": "gatekeeper", "needs": ["reviewer","qa","pm","security"], ...}
  ]
}
```
