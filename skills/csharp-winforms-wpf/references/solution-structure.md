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

Add `Algorithms`, `Reports`, or `Plugins` only when the project needs them. When `Algorithms` exists, give it an `Algorithms.Tests` project too.

Create only the one UI project the user chose. Generate both `UI.Wpf` and `UI.WinForms` only when the user explicitly asks for both, or the project genuinely needs parallel UI frameworks for a migration.

The minimum formal structure drops `Data` and `Algorithms`:

```text
InstrumentApp.sln
  src/
    InstrumentApp.UI.Wpf/ or InstrumentApp.UI.WinForms/
    InstrumentApp.Application/
    InstrumentApp.Domain/
    InstrumentApp.Devices/
    InstrumentApp.Infrastructure/
  tests/
    InstrumentApp.Domain.Tests/
    InstrumentApp.Application.Tests/
    InstrumentApp.Devices.Tests/
```

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

## Test Projects

Default responsibilities:

- `Domain.Tests`: core models, value objects, business rules.
- `Application.Tests`: workflow, state machine, parameter validation, use-case orchestration.
- `Devices.Tests`: simulated devices, protocol parsing, timeout, retry, disconnect.
- `Algorithms.Tests`: fixed input/output, boundary values, error tolerance.

UI automation tests are optional and are not a default requirement for every project.

Test these first, regardless of UI framework:

- Parameter validation.
- State machines.
- Simulated devices.
- Data parsing.
- File save and reload.
- Failure paths.
- Long acquisition and cancellation.

Application, Domain, Devices, and Algorithms should be markedly easier to cover automatically than the UI layer. WinForms versus WPF is a UI choice only; verification requirements for data processing, device communication, workflow control, and save/load are identical for both.

## When A Simpler Structure Is Acceptable

Use a single project or fewer layers for:

- Teaching demos.
- One-window prototypes.
- Disposable internal utilities.
- Experiments that do not touch real devices or retained data.

A small prototype may collapse to:

```text
InstrumentPrototype/
  Views/
  ViewModels/
  Models/
  Services/
  Devices/
  Tests/
```

Still keep core logic testable and avoid putting device calls in forms, windows, or view models.
