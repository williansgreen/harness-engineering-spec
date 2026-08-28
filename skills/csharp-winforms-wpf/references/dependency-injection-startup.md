# Dependency Injection And Startup

Use this reference for app startup, composition root, DI, global exceptions, and resource disposal.

## Composition Root

The UI project is usually the composition root:

```text
UI -> Application
UI -> Infrastructure
UI -> Devices
Application -> Domain
Application -> abstractions
Infrastructure/Devices/Data -> Application abstractions
```

Rules:

- Domain does not reference the DI container.
- UI registers concrete implementations.
- Application defines use cases and abstractions.
- Devices and Infrastructure provide concrete implementations.
- Real, simulated, and replay devices should be swappable through configuration.

## Where Interfaces Live

- Business use-case interfaces: Application.
- Device abstractions: Devices or `Application.Abstractions`.
- Storage abstractions: Application or `Data.Abstractions`.
- Logging: `ILogger<T>` or the project's single logging abstraction.
- Domain models: Domain.

Never expose a vendor SDK interface directly to the UI.

## Device Mode Switching

Select the device implementation from configuration rather than from a build flag:

```json
{
  "Device": {
    "Mode": "Simulated"
  }
}
```

```text
Simulated
Real
Replay
```

## WPF Startup

Recommended:

- Build `IHost` in `App.xaml.cs`.
- Register windows, view models, application services, infrastructure, and devices.
- Start host on startup and stop host on exit.
- Handle global exceptions.

View constructors should remain light and design-time safe.

View model rules:

- Inject services through the view model constructor; a view never news up a business service.
- A view model never touches concrete controls.
- `Window`/`UserControl` constructors do `InitializeComponent()` plus design-time-safe initialization only.
- `DataContext` may come from a DI-created window constructor, a view-model locator, a navigation service, or the composition root — but the design-time path must never depend on a real device, database, or network service.
- Keep design-time and runtime view models separate; design-time data must not start real background work.
- Route dialogs, file pickers, clipboard, and dispatcher access through a UI service abstraction rather than pushing them into Application or Domain.

## WinForms Startup

Recommended:

- Build `IHost` in `Program.cs`.
- Keep forms and user controls with designer-safe parameterless constructors.
- Attach presenters or runtime services from the composition root.
- Do not inject real device or database services directly into a form constructor if it breaks Designer.

Pattern:

```text
var form = new MainForm();
var presenter = ActivatorUtilities.CreateInstance<MainPresenter>(services, form);
form.AttachPresenter(presenter);
Application.Run(form);
```

## Global Exceptions

WPF:

- `DispatcherUnhandledException`
- `AppDomain.CurrentDomain.UnhandledException`
- `TaskScheduler.UnobservedTaskException`

WinForms:

- `Application.ThreadException`
- `AppDomain.CurrentDomain.UnhandledException`
- `TaskScheduler.UnobservedTaskException`

Requirements:

- Log the exception.
- Show a user-readable message.
- Distinguish recoverable from unrecoverable failures.
- Try to stop devices safely.
- Do not expose raw stack traces to normal users.

## Resource Release

On stop, cancel, error, and exit:

- Stop acquisition.
- Cancel background tasks.
- Disconnect devices.
- Flush pending data.
- Close files.
- Dispose SDK resources.
- Warn before losing unsaved data.

## Never

- Reference the DI container from Domain.
- New up a real device inside a view.
- Hard-code a vendor SDK inside a view model or presenter.
- Perform a slow connection inside a constructor.
- Require a real device to be present before the main window can open.

