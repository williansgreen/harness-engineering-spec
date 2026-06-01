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
- Chooses an explicit scaling policy; fixed IPC-style WinForms can use `AutoScaleMode = Font` with System/SystemAware DPI when target displays are verified.
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

## Eval 6: Fixed IPC WinForms DPI

Prompt:

```text
Use $csharp-winforms-wpf to review a fixed industrial WinForms upper-computer UI. The project should use AutoScaleMode=Font, System/SystemAware DPI, Designer-visible containers, and no absolute positioning for ordinary internal controls.
```

Expected:

- Reads the WinForms DPI/scaling reference and Designer/XAML rules.
- Accepts `AutoScaleMode = Font` with System/SystemAware DPI when manifest, app config, startup, and deployment display match.
- Rejects accidental PerMonitorV2 or mixed scaling unless a verified target requires it.
- Requires adaptive containers, `Dock`, `Anchor`, `MinimumSize`, and scrollable parameter panels.

## Eval 7: Serial Protocol Replay

Prompt:

```text
Use $csharp-winforms-wpf to design a replay harness for a serial control-board protocol with ACK, timeout, bad CRC, split frames, sticky frames, disconnect, retry, and emergency-stop cancellation.
```

Expected:

- Reads serial/protocol replay and hardware acceptance references.
- Separates replay evidence from physical hardware acceptance.
- Requires transport abstraction, deterministic fixtures, and request/response matching.
- Covers normal, timeout, error, corrupt, split/sticky, disconnect, write failure, and cancellation paths.

## Eval 8: C# Desktop Packaging Review

Prompt:

```text
Use $csharp-winforms-wpf to review whether a WinForms instrument app is ready to package for a fixed offline IPC machine with native DLLs, ONNX models, app.config binding redirects, logs, reports, and local config.
```

Expected:

- Reads packaging/deployment, configuration/data/release, and medical data security references.
- Checks Release build, bitness, runtime, native DLLs, drivers, content assets, config, logs, data directories, and target startup.
- Distinguishes package creation from deployment acceptance.
- Flags secrets, real patient/sample data, biometric features, and production endpoints in source or package inputs.

## Eval 9: Medical Data And Biometric Safety

Prompt:

```text
Use $csharp-winforms-wpf to review a C# hospital workstation that stores local accounts, face embeddings, audit logs, reports, upload retry records, and sample identifiers.
```

Expected:

- Reads medical data security and configuration/data/release references.
- Classifies accounts, biometric features, audit logs, reports, upload credentials, and sample identifiers.
- Flags sensitive data in Git, logs, packages, reports, and fixtures.
- Requires retention, deletion, export, backup, and audit expectations to be recorded.
