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

## State File Discipline

- `session-handoff.md` is a rolling handoff; replace obsolete details instead of appending chat history.
- `progress.md` should keep current status plus recent sessions; compact old sessions into a short summary when it grows large.
- `feature_list.json` evidence should be structured and concise: command, result, date, and short notes rather than full logs.

## Git Checkpointing

Git checkpointing is opt-in. Do not create commits automatically unless the user has explicitly enabled this workflow.

Preferred helper after verification:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\harness\git-save-feature.ps1 -Message "<type(scope): summary>" -Paths <files...> -VerificationAlreadyRun
```

Record feature evidence with:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\harness\update-evidence.ps1 -FeatureId <id> -Type test -Result passed -Command "<command>" -Notes "<short evidence>"
```

When enabled, create a local commit only after a coherent, independently verifiable feature or fix:

- inspect `git status` first;
- stage only files changed for the current task;
- avoid `git add .`;
- run relevant build, test, or substitute verification;
- do not commit secrets, sensitive config, logs, build outputs, or temporary files;
- do not commit failed verification unless the user explicitly asks for a WIP commit;
- report the commit hash and verification result.

## Required Artifacts

- `feature_list.json`: feature state and verification evidence.
- `feature-list.schema.json`: machine-readable feature state contract.
- `progress.md`: session progress and known risks.
- `session-handoff.md`: restart path for the next session.
- `harness/`: real build, run, test, and quality commands.
- `harness/hardware-test.md`, `harness/protocol-replay.md`, `harness/ui-acceptance.md`, `harness/deployment-acceptance.md`, and `harness/security-data.md`: project-specific acceptance and risk checks when applicable.
- `clean-state-checklist.md`: end-of-session checklist.
- `evals/benchmark-record.md`: benchmark and forward-test results when harness or skill behavior is evaluated.

## Definition of Done

A feature is done when:

- Implementation is complete.
- Required verification has passed.
- Structured evidence is recorded in `feature_list.json`.
- Known gaps are documented.
- The next session can continue from repository files alone.

## End of Session

Before ending:

1. Update feature status and evidence.
2. Update progress.
3. Write handoff notes.
4. Record blockers and risks.
5. Record benchmark or forward-test results when this session evaluated harness behavior.
6. Leave the repository in a restartable state.
