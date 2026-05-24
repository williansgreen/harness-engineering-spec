# Solution Structure

Use this reference when initializing or restructuring a C# WinForms/WPF desktop project.

For target frameworks, platform bitness, shared build files, package versions, and CI, also use `project-setup-ci.md`.

## Formal Project Default

```text
InstrumentApp.sln
  src/
    InstrumentApp.UI.Wpf/ or InstrumentApp.UI.WinForms/
    InstrumentApp.Application/
    InstrumentApp.Domain/
    InstrumentApp.Devices/
    InstrumentApp.Infrastructure/
    InstrumentApp.Data/
  tests/
    InstrumentApp.Domain.Tests/
    InstrumentApp.Application.Tests/
    InstrumentApp.Devices.Tests/
```

Add `Algorithms`, `Reports`, or `Plugins` only when the project needs them.

## Dependency Direction

```text
UI -> Application -> Domain
UI -> Infrastructure only through composition root
Application -> Devices abstractions
Infrastructure/Devices -> vendor SDK implementations
Tests -> public project APIs
```

Rules:

- Domain does not reference UI, vendor SDKs, databases, or file dialogs.
- Application orchestrates use cases and workflow state.
- Devices wraps serial, TCP, USB, HTTP, SDK, or driver calls.
- Infrastructure owns persistence, configuration, logging sinks, and OS integration.
- UI composes views and user interactions; it does not own business logic.

## Project Initialization Checklist

- Create `.sln`.
- Create `src/` and `tests/`.
- For a new formal starter, use `scripts/new-instrument-solution.ps1` when its defaults match the target framework, UI framework, and platform bitness.
- Add `.gitignore`, `.gitattributes`, `.editorconfig`.
- Add `Directory.Build.props`; add `Directory.Packages.props` if central package management is useful.
- Record target framework, installed SDK assumptions, Visual Studio/Build Tools requirements, and x86/x64/AnyCPU strategy.
- Add logging and configuration policy.
- Add simulated devices before depending on real hardware.
- Write build, run, test, and quality commands to harness docs.

## When A Simpler Structure Is Acceptable

Use a single project or fewer layers for:

- Teaching demos.
- One-window prototypes.
- Disposable internal utilities.
- Experiments that do not touch real devices or retained data.

Still keep core logic testable and avoid putting device calls in forms, windows, or view models.
