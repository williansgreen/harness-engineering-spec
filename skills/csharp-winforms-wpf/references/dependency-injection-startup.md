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

## WPF Startup

Recommended:

- Build `IHost` in `App.xaml.cs`.
- Register windows, view models, application services, infrastructure, and devices.
- Start host on startup and stop host on exit.
- Handle global exceptions.

View constructors should remain light and design-time safe.

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

