# WinForms MVP

Use this reference for WinForms apps, especially when Visual Studio Designer maintainability matters.

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

## Presenter Rules

Presenter may:

- Subscribe to view events.
- Update view state.
- Call application services.
- Convert exceptions into user-visible messages.

Presenter must not:

- Directly use vendor SDKs.
- Block the UI thread.
- Own protocol parsing or algorithm internals.
- Create global state hidden from tests.

## Recommended Files

```text
UI.WinForms/
  Forms/MainForm.cs
  Forms/MainForm.Designer.cs
  Views/IMainView.cs
  Presenters/MainPresenter.cs
  Composition/WinFormsCompositionRoot.cs
```

## Acceptance

- Designer opens without real runtime dependencies.
- Fixed layout is visible in Designer.
- Presenter can be tested with a fake view.
- Real and simulated device services can be swapped.

