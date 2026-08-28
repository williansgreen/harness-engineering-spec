---
name: csharp-winforms-wpf
description: C# WinForms/WPF desktop application engineering for Codex, especially scientific, industrial, medical, and instrument-control software. Use when creating, reviewing, refactoring, or implementing C# WinForms/WPF projects, C# upper-computer/instrument apps, MVVM/MVP UI, Visual Studio Designer-safe WinForms, XAML-based WPF, device communication abstractions, simulated devices, logging, threading, build/test harnesses, and verification workflows.
---

# C# WinForms/WPF

Use this skill to turn Codex into a C# desktop application collaborator with explicit rules for project structure, UI maintainability, device boundaries, and verification.

## Workflow

1. Classify the task:
   - New project or project initialization.
   - UI creation or UI adjustment.
   - Device communication or SDK integration.
   - Data processing, workflow/state machine, logging, or configuration.
   - Review, bug fix, or refactor.
2. Judge strictness:
   - Demo/prototype may use a simpler single project.
   - Formal instrument or industrial software should use `.sln`, `src/`, `tests/`, layered projects, logging, simulated devices, and verification evidence.
   - For a new formal project, prefer `scripts/new-instrument-solution.ps1` after confirming the target framework, UI framework, and platform bitness.
3. Read only the needed references:
   - Solution structure: `references/solution-structure.md`
   - Project setup, target framework, platform, and CI: `references/project-setup-ci.md`
   - WinForms: `references/winforms-mvp.md`
   - WPF: `references/wpf-mvvm.md`
   - Designer/XAML rules: `references/designer-xaml-rules.md`
   - WinForms DPI and scaling: `references/winforms-dpi-scaling.md`
   - Fixed IPC UI acceptance: `references/winforms-ipc-ui-acceptance.md`
   - UI layout, charts, and state: `references/ui-layout-state-charting.md`
   - Theme and design tokens: `references/theme-design-tokens.md`
   - Devices and validation: `references/instrument-device-validation.md`
   - Runtime workflow loops, state machines, scheduling, stop, and recovery: `references/runtime-workflow-loop-engineering.md`
   - Hardware acceptance: `references/hardware-acceptance.md`
   - Serial/protocol replay: `references/serial-protocol-replay.md`
   - Feature validation checklists: `references/feature-validation-checklists.md`
   - Dependency injection and startup: `references/dependency-injection-startup.md`
   - Configuration, data, and release: `references/configuration-data-release.md`
   - Packaging and deployment: `references/winforms-packaging-deployment.md`
   - Medical or sensitive data: `references/medical-data-security.md`
   - Threading, logging, release: `references/threading-logging-release.md`
   - Acceptance review: `references/csharp-acceptance-checklist.md`
4. Implement with the repo's existing conventions.
5. Run build and relevant tests from the project's harness docs.
6. Record verification, unverified paths, and remaining risk.

## Reference Selection

Use the smallest relevant set:

- Project setup or package versions: `project-setup-ci.md`, then `solution-structure.md` if structure changes.
- WinForms UI: `winforms-mvp.md`, `designer-xaml-rules.md`, and `ui-layout-state-charting.md`.
- Fixed IPC, DPI, or target screen acceptance: add `winforms-dpi-scaling.md` and `winforms-ipc-ui-acceptance.md`.
- WPF UI: `wpf-mvvm.md`, `designer-xaml-rules.md`, and `theme-design-tokens.md` when visual tokens are reused.
- Device communication: `instrument-device-validation.md`, `feature-validation-checklists.md`, and `serial-protocol-replay.md` when protocol behavior is touched.
- Long-running experiments, cyclic acquisition, schedulers, state machines, runtime append, shared resources, safe stop, or crash recovery: `runtime-workflow-loop-engineering.md`, plus `instrument-device-validation.md` when physical devices are involved.
- Real hardware verification: add `hardware-acceptance.md` and keep project-specific steps in `harness/hardware-test.md`.
- Packaging or deployment: `winforms-packaging-deployment.md`, `configuration-data-release.md`, and project `harness/release.md`.
- Sensitive data, accounts, reports, or biometrics: `medical-data-security.md` and project `harness/security-data.md`.
- Final readiness review: `csharp-acceptance-checklist.md` plus only the area-specific references above.

## Defaults

- Formal C# desktop apps use a solution with `src/` and `tests/`.
- Target framework, SDK, platform bitness, and CI must respect project and vendor constraints.
- WPF defaults to MVVM.
- WinForms defaults to MVP.
- WinForms fixed layout must stay Visual Studio Designer-safe.
- WinForms defaults to `AutoScaleMode = Dpi` with PerMonitorV2 set before WinForms initialization. `Font` scaling is unreliable once the default font is changed, because the Designer writes `AutoScaleDimensions` before `Font`.
- WPF fixed layout should live in XAML, with binding/templates for dynamic content.
- UI must not directly call real device SDKs, databases, or long-running algorithms.
- Real devices and simulated devices should be swappable through abstractions.
- Device, data, workflow, and UI changes require verification evidence.
- Configuration, experiment data, algorithm output, and reports should carry versioning when they must survive upgrades.
- Formal instrument UI should use shared visual tokens instead of one-off colors and sizes.

## Completion Bar

For implementation tasks, do not claim done until:

- The project builds, or the blocker is explicit.
- Relevant tests or substitute verification ran.
- Device-dependent paths have mock/simulator/protocol-replay coverage when real hardware is unavailable.
- Device, data-processing, workflow, and save/export paths include normal, boundary, and failure coverage when they are touched.
- UI work has at least code-level layout checks, and runtime visual verification when the environment allows it.
- Hardware-dependent work has real-device evidence or a documented replay/simulator substitute plus remaining physical blockers.
- Packaging or deployment work records target machine, dependencies, package path, and startup evidence.
- Remaining manual checks are listed.
- Feature status, progress, or handoff records are updated when the task is substantial.

## Assets

Use `assets/templates/` when creating new project documentation or scaffolding:

- `csharp-solution-structure.md`
- `winforms-mvp-template.md`
- `winforms-mainform-layout.md`
- `wpf-mvvm-template.md`
- `device-service-template.md`
- `device-protocol-template.md`

## Scripts

Use `scripts/new-instrument-solution.ps1` to create a formal starter solution with UI, Application, Domain, Devices, Infrastructure, tests, shared build props, and a simulated device path.

Example:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\new-instrument-solution.ps1 -ProductName InstrumentControl -TargetPath D:\work\InstrumentControl -UiFramework Wpf -Platform x64 -RunVerification
```

Before running it in a real project, confirm:

- Target framework matches installed SDKs, Visual Studio/Build Tools, deployment machines, and vendor SDKs.
- Platform bitness matches vendor SDK and driver constraints.
- The target directory is correct and does not contain unrelated work that would be overwritten.
