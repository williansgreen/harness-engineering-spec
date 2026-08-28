# WinForms MVP

Use this reference for WinForms apps, especially when Visual Studio Designer maintainability matters.

For designer-safe code rules read `references/designer-xaml-rules.md`. For scaling policy read `references/winforms-dpi-scaling.md`.

## Default Pattern

WinForms defaults to MVP:

- View: `Form` or `UserControl`, fixed UI shell, simple event forwarding.
- Presenter: UI behavior, command handling, validation, view state transitions.
- Application services: workflow, device calls, data saving.
- Domain: business rules and models.

## View Rules

- Keep `Form` and `UserControl` designer-openable.
- Keep a parameterless constructor for the designer.
- Do not connect devices, databases, network services, or DI containers in the designer path.
- Forward events to the presenter instead of placing business logic in event handlers.
- Keep `.Designer.cs` limited to designer-generated layout code.

The view owns only: layout produced by `InitializeComponent()`, event forwarding, simple display methods such as `SetRunState` / `ShowError` / `UpdateSummary`, and control enable/disable/text/selection synchronization.

## Presenter Rules

Presenter may:

- Subscribe to view events.
- Update view state.
- Call application services.
- Drive business state transitions.
- Convert exceptions into user-visible messages and log entries.
- Decide button enablement, parameter locking, and prompt content from state.

Presenter must not:

- Directly use vendor SDKs.
- Block the UI thread.
- Own protocol parsing or algorithm internals.
- Create global state hidden from tests.
- Bypass Application to reach a database, real device SDK, or algorithm internals.

## View Interface

Expose user intent and display capability, not a pile of concrete controls:

```csharp
public interface IMeasurementView
{
    event EventHandler StartRequested;
    event EventHandler StopRequested;

    MeasurementInput GetInput();
    void SetRunState(MeasurementRunState state);
    void SetValidationErrors(IReadOnlyList<ValidationMessage> messages);
    void UpdateChart(IReadOnlyList<MeasurementPoint> points);
    void ShowError(string message);
}
```

A presenter driving `Button`, `TextBox`, or `DataGridView` instances directly is acceptable only in a small prototype or a local control adapter.

## Threading And Lifetime

WinForms controls update on the UI thread only. When serial ports, sockets, device SDKs, live curves, logs, or background computation are involved:

- Device communication, file saving, algorithm work, and long exports never run on the UI thread.
- Background work returns to the UI thread through `BeginInvoke`, `SynchronizationContext`, or the project's UI dispatcher.
- Public display methods check `IsDisposed` / `IsHandleCreated` where relevant, so a closed form is not updated.
- Acquisition, refresh, save, and export hold a cancellable `CancellationTokenSource`, or get cancellation from an application service.
- `FormClosing`, `FormClosed`, and presenter disposal stop timers, cancel background tasks, unsubscribe device events, and release chart or log refresh resources.
- Every subscription — view events, device events, background service events — has a matching unsubscribe path, so reopening a page does not accumulate callbacks.
- `async void` is only for event handlers. Business flows return `Task`, and exceptions reach the log and the UI state.
- Throttle live curve, table, and log refresh; see `references/threading-logging-release.md`.

## Validation And Command State

WinForms needs the same validation discipline as WPF, not a dialog at the end:

- Validation results come from Application/Domain as structured data; the view renders them near the offending control.
- Use `ErrorProvider`, inline error labels, a status-bar summary, tooltips, or the project's standard validation control.
- Invalid parameters disable start, save, and apply, with a readable reason.
- Dangerous parameters become disabled or read-only while running; editable ones state their range and when they take effect.
- Modal dialogs are for severe errors. Ordinary validation, warnings, and hints do not all become `MessageBox`.
- Enablement follows run state and validation state together: no duplicate start, no second stop while stopping, no acquisition while disconnected.

## Dynamic Content

Runtime creation is fine for device-capability parameters, repeated controls, plugin panels, table rows, chart series, transient prompts, and config-driven local panels.

Keep that code in `Controls/`, `Presenters/`, or `Factories/` — not scattered through form constructors.

## Project Layout

```text
ProjectName.UI.WinForms/
  Forms/          top-level windows and dialogs
  Controls/       reusable UserControls: navigation, parameters, status, log, chart
  Views/          view interfaces such as IMeasurementView
  Presenters/     UI flow coordination
  ViewState/      display state, option lists, validation results; no domain rules
  Resources/      icons, images, .resx
  Theming/        color, font, spacing, size constants
  DesignTime/     design-time fakes; never touches real devices
  Composition/    WinFormsCompositionRoot.cs
```

The UI project may reference concrete implementation projects from its startup entry or composition root. Ordinary forms, user controls, and presenters may not.

## Acceptance

- `Form.cs` and `Form.Designer.cs` exist, plus `Form.resx` when resources are used.
- Standard `partial class`, `components`, and `Dispose(bool disposing)` structure is intact.
- The main form and core `UserControl`s open in Visual Studio Designer.
- Fixed menus, navigation, toolbar, status bar, workspace container, and parameter container are designer-visible.
- `.Designer.cs` is designer-safe: no loops, conditions, LINQ, runtime service calls, or helper assembly of the fixed shell.
- Fixed controls are fields with stable names, not runtime locals.
- Parameterless constructors are preserved and do only `InitializeComponent()` plus design-time-safe initialization.
- The main form uses designer-friendly layout containers rather than a pile of root-level absolute coordinates.
- The scaling policy matches what the project documented, with `MinimumSize`, `Dock`, and `Anchor` set accordingly.
- Default `ClientSize`, `MinimumSize`, and verification window sizes are distinct; no target resolution is baked in as a fixed design constraint.
- Parameter panels scroll or collapse when content overflows.
- Validation errors appear near their control, and related commands disable with a stated reason.
- Background threads reach the UI through the dispatcher.
- Closing a form or disposing a presenter cancels tasks, stops timers, and unsubscribes events.
- No `BuildUi()`-style whole-page construction exists; dynamic content only enters existing designer containers.
- The designer load path does not depend on real devices, serial ports, databases, network services, or user config files.
- Presenter can be tested with a fake view.
- Real and simulated device services can be swapped.
- If the UI runs, at least one post-run visual check is done.
