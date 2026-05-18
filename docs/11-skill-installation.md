# Skill Installation

This repository keeps skills under `skills/` so they can be reviewed before installation.

## Dry Run

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skill.ps1 -DryRun
```

## Install

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skill.ps1
```

By default, the script installs to:

```text
$CODEX_HOME\skills
```

or, when `CODEX_HOME` is not set:

```text
%USERPROFILE%\.codex\skills
```

## Overwrite

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skill.ps1 -Force
```

Use `-Force` only after reviewing local changes in the destination skill.

## Validate After Install

Run the spec check:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-spec.ps1
```

Then start a fresh Codex session and ask for a task that should trigger `$csharp-winforms-wpf`.

