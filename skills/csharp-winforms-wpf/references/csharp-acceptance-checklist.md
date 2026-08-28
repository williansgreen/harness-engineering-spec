# C# Acceptance Checklist

Use this checklist before declaring a formal C# WinForms/WPF project initialized, refactored, or ready for handoff.

## Solution

- [ ] `.sln` exists.
- [ ] `src/` exists.
- [ ] `tests/` exists.
- [ ] Formal project includes UI, Application, Domain, Devices, Infrastructure.
- [ ] Project names and solution naming are coherent.
- [ ] `.editorconfig` exists or the project records why not.
- [ ] `Directory.Build.props` exists for formal projects.
- [ ] `Directory.Packages.props` exists when central package management is used.
- [ ] Platform strategy is explicit: AnyCPU, x86, or x64.
- [ ] Platform strategy matches vendor SDK bitness when a vendor SDK is used.
- [ ] WPF project has `<UseWPF>true</UseWPF>` when applicable.
- [ ] WinForms project has `<UseWindowsForms>true</UseWindowsForms>` when applicable.
- [ ] Target framework is supported by installed SDKs, Visual Studio/Build Tools, vendor SDKs, and deployment machines.
- [ ] CI does not depend on real hardware.

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
- [ ] WinForms fixed layout avoids loops, runtime conditions, service calls, and helper-built whole-window layout in `.Designer.cs`.
- [ ] WinForms dynamic controls mount into stable designer-created containers.
- [ ] WinForms scaling policy is explicit: `AutoScaleMode = Dpi` with PerMonitorV2 set before WinForms initialization, or a recorded exception.
- [ ] If any form uses `AutoScaleMode = Font`, the reason is recorded and `AutoScaleDimensions` matches the font actually in use.
- [ ] WinForms manifest, app config, startup DPI call, and form `AutoScaleMode` agree with the documented scaling policy.
- [ ] WinForms internal controls use adaptive containers, `Dock`, `Anchor`, `MinimumSize`, and scrollable panels instead of normal-form absolute positioning.
- [ ] WPF fixed shell is XAML-based.
- [ ] WPF uses adaptive layout containers instead of `Canvas` for normal resizable app layout.
- [ ] WPF reused colors, spacing, typography, and templates live in resources.
- [ ] WPF ViewModels implement state and commands without directly accessing controls.
- [ ] WPF ViewModels do not directly access controls or real device SDKs.
- [ ] UI does not block on device communication.
- [ ] Core UI has no obvious clipped text, overlapping controls, or unreachable actions at the project's target sizes.
- [ ] Runtime visual checks use the same DPI awareness policy as the application.
- [ ] Runtime visual check ran when environment allowed it.
- [ ] Fixed IPC or workstation UI acceptance records target resolution, Windows scale, font, and screenshot or render evidence when applicable.

## Devices And Data

- [ ] Device abstraction exists.
- [ ] Simulated, mock, or replay device path exists.
- [ ] Communication supports timeout and cancellation.
- [ ] Communication tests or substitutes cover normal response, timeout, error response, disconnect, and cancellation.
- [ ] Data save includes raw data and metadata when required.
- [ ] Schema/software/algorithm/report versions are recorded when data is long-lived.
- [ ] Data processing uses fixed samples, expected outputs, and tolerance when applicable.
- [ ] Workflow/state-machine features cover legal transitions, illegal transitions, repeated clicks, stop/cancel, and failure recovery.
- [ ] Long-running workflows have one transition authority, stable item identity, coherent snapshots, and no duplicate production driver.
- [ ] Shared device resources have atomic arbitration and macro/sequence ownership where interleaving would be unsafe.
- [ ] Stop/fault completion waits for the defined execution-track and dangerous-output conditions.
- [ ] Recovery reconciles persisted execution state with fresh physical observations before resuming irreversible work.
- [ ] Hardware-dependent features have real-device evidence or documented replay/simulator substitute evidence plus explicit physical blockers.
- [ ] Protocol replay covers normal, timeout, error, corrupt frame, split/sticky frame, disconnect, and cancellation when protocol behavior is touched.

## Logging And Exceptions

- [ ] Unified logging exists.
- [ ] Global exception handlers exist.
- [ ] Device errors are logged and visible to users.
- [ ] Secrets and sensitive data are not logged.
- [ ] Patient, sample, customer, account, biometric, report, token, and certificate data are classified and excluded from Git unless approved as sanitized fixtures.

## Tests And Verification

- [ ] Domain tests cover core rules.
- [ ] Application tests cover workflow and state transitions.
- [ ] Devices tests cover simulator, protocol parsing, timeout, error, and disconnect.
- [ ] Data or algorithm tests use fixed samples and tolerances.
- [ ] `dotnet build` passes or blocker is recorded.
- [ ] `dotnet test` passes or blocker is recorded.
- [ ] Harness docs contain real build, run, test, and quality commands.
- [ ] Release readiness records config/log/data directories, vendor DLLs or drivers, target platform, and manual blockers.
- [ ] Packaging/deployment readiness records installer or package path, checksums, runtime prerequisites, native dependencies, target machine startup, and rollback or uninstall notes when applicable.
