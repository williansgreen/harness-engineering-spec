# C# WinForms/WPF Skill Evals

Use these tasks to forward-test the `csharp-winforms-wpf` skill on realistic requests.

## Eval 1: New Formal WPF Instrument Project

Prompt:

```text
Use $csharp-winforms-wpf to create a C# WPF scientific instrument app skeleton with simulated device support and tests.
```

Expected:

- Reads solution structure, project setup/CI, WPF MVVM, device validation, DI startup, and acceptance checklist references.
- Uses or explicitly considers `scripts/new-instrument-solution.ps1` for the starter solution.
- Creates `.sln`, `src/`, `tests/`.
- Selects target framework and platform strategy from project/tool/vendor constraints instead of blindly using a template value.
- Adds simulated device abstraction before real hardware.
- Runs or clearly blocks `dotnet build` and `dotnet test`.

## Eval 2: Review WinForms Designer Safety

Prompt:

```text
Use $csharp-winforms-wpf to review this WinForms MainForm implementation for Designer safety and MVP boundaries.
```

Fixture:

```text
evals/fixtures/winforms-designer-unsafe/
```

Expected:

- Prioritizes Designer visibility, parameterless constructor, no device calls in form constructor, and Presenter boundaries.
- Reports findings first with file/line references when code is provided.

## Eval 3: Device SDK Integration

Prompt:

```text
Use $csharp-winforms-wpf to design a serial/TCP device SDK wrapper with timeout, cancellation, simulated mode, and tests.
```

Expected:

- Uses device abstraction and validation reference.
- Uses feature validation checklist for normal, timeout, error, disconnect, cancellation, and resource release.
- Includes simulated/replay path.
- Specifies tests for normal, timeout, error, disconnect, and cancellation.

## Eval 4: Instrument Dashboard UI

Prompt:

```text
Use $csharp-winforms-wpf to design a high-DPI instrument dashboard with device status, realtime chart, parameters, and logs.
```

Expected:

- Separates device state and workflow state.
- Uses adaptive layout guidance.
- Uses shared visual tokens or resource-based styling.
- Controls chart refresh rate separately from acquisition rate.
- Avoids marketing-style UI.

## Eval 5: Release Readiness Review

Prompt:

```text
Use $csharp-winforms-wpf to review whether this C# instrument app is ready for release.
```

Expected:

- Checks Release build, tests, CI/harness commands, device/simulator flow, config/data/log directories, x86/x64, vendor DLLs, versioning, and manual blockers.
