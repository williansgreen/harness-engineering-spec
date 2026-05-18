# C# Acceptance Checklist

Use this checklist before declaring a formal C# WinForms/WPF project initialized, refactored, or ready for handoff.

## Solution

- [ ] `.sln` exists.
- [ ] `src/` exists.
- [ ] `tests/` exists.
- [ ] Formal project includes UI, Application, Domain, Devices, Infrastructure.
- [ ] Platform strategy is explicit: AnyCPU, x86, or x64.
- [ ] WPF project has `<UseWPF>true</UseWPF>` when applicable.
- [ ] WinForms project has `<UseWindowsForms>true</UseWindowsForms>` when applicable.

## Boundaries

- [ ] Domain does not reference UI.
- [ ] Domain does not reference concrete vendor SDKs.
- [ ] UI does not directly implement device protocol.
- [ ] UI does not directly access persistence internals.
- [ ] Real and simulated devices can be swapped.

## UI

- [ ] WPF uses MVVM.
- [ ] WinForms uses MVP.
- [ ] WinForms fixed shell is Designer-visible.
- [ ] WinForms forms and user controls have designer-safe parameterless constructors.
- [ ] WPF fixed shell is XAML-based.
- [ ] WPF ViewModels do not directly access controls or real device SDKs.
- [ ] UI does not block on device communication.
- [ ] Runtime visual check ran when environment allowed it.

## Devices And Data

- [ ] Device abstraction exists.
- [ ] Simulated, mock, or replay device path exists.
- [ ] Communication supports timeout and cancellation.
- [ ] Data save includes raw data and metadata when required.
- [ ] Schema/software/algorithm/report versions are recorded when data is long-lived.

## Logging And Exceptions

- [ ] Unified logging exists.
- [ ] Global exception handlers exist.
- [ ] Device errors are logged and visible to users.
- [ ] Secrets and sensitive data are not logged.

## Tests And Verification

- [ ] Domain tests cover core rules.
- [ ] Application tests cover workflow and state transitions.
- [ ] Devices tests cover simulator, protocol parsing, timeout, error, and disconnect.
- [ ] Data or algorithm tests use fixed samples and tolerances.
- [ ] `dotnet build` passes or blocker is recorded.
- [ ] `dotnet test` passes or blocker is recorded.
- [ ] Harness docs contain real build, run, test, and quality commands.

