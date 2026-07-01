# Contributing

Thank you for helping improve `pi-skills`.

## Commit messages

This repository uses Conventional Commits.

Recommended formats:

- `feat: add ...` for new user-facing behavior
- `fix: ...` for bug fixes
- `docs: ...` for documentation changes
- `chore: ...` for tooling, release, and maintenance work

Use the imperative mood and keep the subject line short and specific.

Examples:

- `docs(changelog): add pre-release notes`
- `feat: add update mode for publish-message config`
- `fix: preserve publish-message config on reinstall`

## Branches

Use a purpose-specific branch name:

- `feat/*` for new features
- `fix/*` for bug fixes
- `rc/*` for release candidate work

## Release flow

- Make changes on a branch
- Keep commits small and reviewable
- Run the strongest local verification command available
- Merge into `main`
- Create release tags from `main` after merge

Do not tag pre-release work on feature branches unless the release process explicitly requires it.

## Verification

Before opening a merge request or marking work complete, run the strongest local checks available in the repository.

Preferred order:

1. repo-local test/lint/security scripts
2. `python3 scripts/run-best-local-check.py .`
3. project-specific manual checks if no script exists

If a local quality/security check fails, treat it as a stop signal unless the failure is explicitly understood and approved.

## Scope and hygiene

- Keep changes focused to one concern when possible
- Update docs when behavior changes
- Avoid committing generated or temporary files unless they are part of the deliverable
- Preserve user configuration by default when reinstalling or updating
