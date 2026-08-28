# Threading, Logging, And Release

Use this reference for long-running operations, real-time UI, diagnostics, and release readiness.

For workflow state machines, stop phases, and recovery, read `references/runtime-workflow-loop-engineering.md`.
For status enums, chart refresh, and layout, read `references/ui-layout-state-charting.md`.

## Threading

Rules:

- Do not block the UI thread with device reads, file exports, network calls, or large algorithms.
- Use async workflows or background workers with cancellation.
- Marshal UI updates back to the UI thread.
- Rate-limit high-frequency chart or table updates.
- Release device handles on stop, cancel, error, and application exit.

Never run on the UI thread:

- Blocking device reads.
- Long file saves.
- Large data algorithms.
- Large exports.
- Network requests.
- `Thread.Sleep` used to wait for a device.

Acceptable on the UI thread:

- Control state updates.
- Short input validation.
- Binding property changes.
- Non-blocking notifications.

## Cancellation And Timeouts

Acquisition, save, export, and analysis paths must each define:

- A `CancellationToken` path.
- A timeout.
- User-initiated cancellation.
- Exception recovery.
- Resource release on every exit path.

## Refresh Rates

Acquisition frequency is not UI refresh frequency. Typical controlled rates:

```text
Device acquisition: device capability
Chart refresh:      5-20 Hz
Status bar:         2-5 Hz
Log panel:          batched append
Data grid:          paging or virtualization
```

## WinForms Performance

- Run device communication on background tasks.
- Return to the UI thread through `BeginInvoke` or the synchronization context.
- Throttle chart refresh.
- Do not add all rows at once for large tables.
- Cap the maximum line count of log controls.
- Split complex regions into `UserControl` to reduce main-form load.

## WPF Performance

- Use `async`/`await`.
- Avoid high-frequency per-item updates on `ObservableCollection`.
- Enable virtualization for large lists.
- Use `CollectionView` for filtering and sorting.
- Batch real-time curve updates.
- Keep animations light.
- Do not run heavy computation inside binding property getters.

Virtualization settings:

```xml
VirtualizingPanel.IsVirtualizing="True"
VirtualizingPanel.VirtualizationMode="Recycling"
ScrollViewer.CanContentScroll="True"
```

## Large Data Processing

- Run in the background.
- Expose progress.
- Support cancellation.
- Record elapsed time.
- Avoid unnecessary copies.
- Keep benchmark samples for stable algorithms so regressions are detectable.

## Long-Running Sessions

Watch for:

- Memory growth.
- Log file size.
- Chart point count.
- Leaked background tasks.
- Unreleased device handles.
- Unreleased file handles.

Mitigations:

- Window the data held for display.
- Write raw data to file or database rather than memory.
- Roll logs.
- Stop background tasks before exit.

## Logging

Log:

- App startup and shutdown.
- Device connect/disconnect.
- Commands and error codes where safe.
- Workflow start, pause, resume, stop, cancel.
- Parameter changes.
- Data save/export results.
- Significant user actions.
- Unexpected exceptions.

Do not log:

- Passwords.
- Access tokens.
- Private keys.
- Sensitive patient/customer/sample information unless the project explicitly allows it.

Whether device serial numbers and sample identifiers are sensitive is a project decision; record it in `harness/security-data.md`.

## Log Categories

Separate at least:

```text
Application
DeviceCommunication
Experiment
Operation
Error
Audit
```

These may be distinct loggers, distinct files, or a category field.

## Log Levels

```text
Trace:       protocol detail, debugging only
Debug:       development diagnostics
Information: key workflow milestones
Warning:     recoverable anomaly
Error:       operation failed, application continues
Critical:    severe fault or shutdown required
```

## Log Directories

```text
Development: project logs/ or bin/logs/
Production:  ProgramData/AppName/Logs or a user-selected directory
Experiment:  logs/ inside the experiment directory
```

Do not write production logs into the installation directory by default.

## Log Rotation

- Roll by date.
- Cap file size.
- Retain the last N days.
- Long acquisition sessions must not grow without bound.

## Device Communication Logs

Record:

- Command name.
- Send timestamp.
- Response timestamp.
- Status code.
- Timeouts.
- Retries.
- Error codes.

Do not log large raw binary payloads by default. When they are needed, cap the size or store them separately.

## Operation And Audit Logs

Record:

- Operator.
- Timestamp.
- Action name.
- Target experiment or sample.
- Parameter values before and after.
- Success or failure.

These actions must always be logged:

- Deleting data.
- Overwriting calibration.
- Force-stopping a device.
- Changing device connection configuration.

## Log Presentation

- Show a summary in the UI; keep detail in files.
- Show the most recent entries in a status area.
- Make the log panel expandable.
- Let errors navigate to detail.
- Provide a diagnostic bundle export.

Do not stream every log line into an unbounded `TextBox`.

## Logging Libraries

Serilog, NLog, or `Microsoft.Extensions.Logging` are all acceptable. A formal project should standardize on one logging entry point rather than mixing several logging stacks.

## Release Readiness

Before release or handoff:

- Build Release configuration.
- Run tests.
- Verify startup without development-only paths.
- Confirm config, log, and data directories.
- Verify simulated or real-device main path.
- Record known manual checks and blockers.

## Acceptance

Threading and long-running work is not done until:

- The UI does not freeze during acquisition.
- The stop button responds promptly.
- The UI recovers after a device disconnect.
- Memory shows no abnormal growth across a 30-minute run.
- Large exports show progress.
- Chart refresh does not slow acquisition.
