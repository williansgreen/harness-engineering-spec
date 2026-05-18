# AGENTS.md

本文件是 coding agent 的项目入口。

## Startup Workflow

Before writing code:

1. Read this file.
2. Read `feature_list.json`.
3. Read `progress.md`.
4. Read `session-handoff.md` if it exists.
5. Read relevant docs, harness commands, and checklists for the task.

## Working Rules

- Work on one active feature at a time.
- Do not mark a feature passing without evidence.
- Do not expand scope without recording why.
- Prefer small, verifiable changes.
- Do not overwrite user changes.
- Update state files before ending a substantial session.

## Required Artifacts

- `feature_list.json`: feature state and verification evidence.
- `progress.md`: session progress and known risks.
- `session-handoff.md`: restart path for the next session.
- `harness/`: real build, run, test, and quality commands.
- `clean-state-checklist.md`: end-of-session checklist.

## Definition of Done

A feature is done when:

- Implementation is complete.
- Required verification has passed.
- Evidence is recorded.
- Known gaps are documented.
- The next session can continue from repository files alone.

## End of Session

Before ending:

1. Update feature status and evidence.
2. Update progress.
3. Write handoff notes.
4. Record blockers and risks.
5. Leave the repository in a restartable state.

