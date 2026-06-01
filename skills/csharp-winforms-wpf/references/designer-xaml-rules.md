# Designer And XAML Rules

Use this reference when creating or adjusting UI code.

## WinForms Hard Rules

Unless the user explicitly asks for pure runtime UI:

- Fixed shell belongs in `InitializeComponent()`.
- Fixed navigation, toolbars, status bars, parameter containers, chart/table containers, and main split layouts should be designer-visible.
- Runtime-generated controls may only be mounted into stable designer containers.
- Keep stable names for important controls.
- Do not build the whole main window through `BuildUi()`, `CreateLayout()`, or similar helpers.
- Use designer-visible containers such as `TableLayoutPanel`, `SplitContainer`, `FlowLayoutPanel`, `Panel`, and `UserControl` for normal UI layout.
- Avoid absolute coordinates for internal controls unless the UI represents a physical layout, calibrated image/fixture, or custom drawing surface.

Allowed in `.Designer.cs`:

- Field declarations.
- `components` and `Dispose`.
- Simple control creation, properties, `Controls.Add`, `Dock`, `Anchor`, `Name`, `Text`, `TabIndex`.
- Simple event binding to named methods.

Avoid in `.Designer.cs`:

- Business logic.
- Runtime conditions.
- Loops for fixed main layout.
- Device, database, network, file-system, or DI container access.
- Presenter or service calls.

## WPF Rules

- Use `Grid`, `DockPanel`, `ContentControl`, `ScrollViewer`, and `ItemsControl` for adaptive layout.
- Put colors, spacing, typography, and templates in resources when reused.
- Use design-time data for previews.
- Do not hide core app behavior inside code-behind.
- Avoid absolute positioning for resizable instrument dashboards unless there is a physical-layout reason.

## Runtime Visual Check

When the environment allows:

- Build.
- Launch the UI.
- Inspect the main screen.
- Check for clipped text, overlapping controls, unreachable actions, missing scroll, broken scaling assumptions, and stale status display.

If runtime UI inspection is not possible, report that visual acceptance is pending and complete static layout checks instead.
