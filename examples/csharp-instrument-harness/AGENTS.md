# C# Instrument Harness Example

This project models a formal C# desktop instrument application using the `csharp-winforms-wpf` skill.

## Startup Workflow

1. Read this file.
2. Read `feature_list.json`.
3. Read `progress.md`.
4. Read `session-handoff.md`.
5. For C# work, use `skills/csharp-winforms-wpf/SKILL.md` from the harness-engineering-spec repository.
6. Read the relevant harness command files.

## Working Rules

- Formal app structure uses `.sln`, `src/`, and `tests/`.
- WPF uses MVVM; WinForms uses MVP.
- UI does not directly call real device SDKs.
- Simulated device path is required before real hardware-only verification.
- Passing features require build/test or substitute verification evidence.

## Definition of Done

A feature is done when implementation, tests or substitute verification, harness state, and handoff notes are all updated.

