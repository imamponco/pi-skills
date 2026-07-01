# Publish Message Docs

Contains the delivery workflow for sending a Markdown/text file to configured platforms.

## Skill
- `publish-message`

## Use when
- you have a local artifact to post
- you want Discord, Telegram, or GitLab MR delivery

## Default artifact
- `review_result.md`

## Notes
- supports `docs/summary.md` or any other file path
- chunks long messages automatically
