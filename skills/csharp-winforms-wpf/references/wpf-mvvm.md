# WPF MVVM

Use this reference for WPF apps and XAML-heavy UI work.

For designer and XAML code rules read `references/designer-xaml-rules.md`. For layout, status, and charts read `references/ui-layout-state-charting.md`.

## Default Pattern

WPF defaults to MVVM:

- View: XAML layout, bindings, visual states, resources.
- ViewModel: state, commands, input validation, navigation state.
- Model/Domain: business entities and rules.
- Application services: workflows, device calls, data saving.

## View Rules

- Fixed layout belongs in XAML.
- Dynamic content should use `Binding`, `ItemsControl`, `DataTemplate`, `Style`, and `ResourceDictionary`.
- Avoid `Canvas` for normal app layout; reserve it for coordinate canvases, image annotation, board layouts, and similar visualizations.
- Avoid large runtime UI construction in code-behind.
- Code-behind should be limited to view-only concerns that are awkward in XAML.

WPF sizes are device-independent units. Fixed widths, `MinWidth`, `MaxWidth`, row heights, and column widths are not physical pixels; high-DPI usability still comes from containers, scrolling, and collapse strategy.

## ViewModel Rules

ViewModel may:

- Expose observable state and commands.
- Implement `INotifyPropertyChanged` or derive from the project's observable base.
- Expose bindable collections, current page, current selection, and error information.
- Use `ICommand`, `RelayCommand`, or `AsyncCommand`, each with `CanExecute` or an equivalent enable state.
- Validate input.
- Coordinate application services.
- Run long operations with async/await, background tasks, and `CancellationToken`.
- Publish UI state such as busy, error, warning, progress, selected item.

ViewModel must not:

- Directly access controls, `Window`, `TextBox`, `DataGrid`, or chart control instances.
- Directly access vendor SDKs, database implementations, or file dialogs.
- Open file dialogs without an abstraction.
- Run slow computation, device reads, database queries, or network calls inside a property getter.
- Grow into one giant `MainViewModel` holding all application state.
- Use `async void` for business flows; event handlers and framework callbacks are the exception.
- Block the UI thread.

Run state drives command enablement:

```text
Disconnected: disable Start, allow Connect
Ready:        allow configuration and Start
Running:      disable dangerous parameters, allow Pause / Stop
Stopping:     disable repeat Stop
Faulted:      disable dangerous actions, allow log inspection and recovery
```

## Validation And Errors

Validation belongs in the binding system, not in a dialog thrown at click time.

- Express view model validation with `INotifyDataErrorInfo`.
- `ValidationRule` is acceptable for simple input; business rules live in Application or Domain.
- Show errors near the control, and mirror severe ones to the status bar or log panel.
- Disable related commands while a parameter is invalid, and say why.
- Make dangerous parameters read-only while running.
- Keep error text, units, ranges, and defaults visible.

Avoid: routing every error to `MessageBox`; changing a border color with no text; burying validation rules in a XAML converter.

## Lists, Grids, And Live Data

- Enable virtualization for large lists and grids.
- Do not push high-frequency per-item updates through `ObservableCollection`.
- Buffer acquisition data and refresh the UI at a throttled rate; see `references/threading-logging-release.md`.
- Wrap chart controls in an adapter service or dedicated control; the view model never touches chart internals.
- Cap log panel rows or page them; the full log goes to file.
- Marshal background collection updates back to the UI thread.

## Resources And Theming

```text
Resources/
  Colors.xaml
  Spacing.xaml
  Typography.xaml
  ControlStyles.xaml
  DataTemplates.xaml
  Icons.xaml
  ChartStyles.xaml
```

- Reference colors, fonts, spacing, control heights, borders, and state colors through `StaticResource` or `DynamicResource`.
- Page-specific styles may stay local, but common buttons, inputs, grids, tabs, and status labels are defined centrally.
- Keep state colors consistent with `references/theme-design-tokens.md`; color is never the only signal.
- Do not copy a near-duplicate style set for one page.

## Code-Behind Boundary

Allowed: component initialization, purely visual events, light view-specific logic, adapters for controls that cannot be bound.

Not allowed: device communication, experiment workflow, data saving, core algorithms, complex business state machines.

## Project Layout

```text
ProjectName.UI.Wpf/
  Views/          windows, page-level UserControls, dialog views
  ViewModels/     page, panel, and dialog view models
  Controls/       reusable controls: status bar, parameter editor, navigation, log, chart
  Resources/      design tokens, styles, templates, icons
  Themes/         theme entry points and switchable theme resources
  Converters/     light value conversion; no business rules
  Behaviors/      interaction behavior and third-party adapters; no service calls
  Commands/       RelayCommand, AsyncCommand, and similar
  Navigation/     page navigation, region management, view-model-to-view mapping
  Services/       UI-only services: dialogs, file pickers, clipboard, dispatcher, notifications
  DesignTime/     design-time view models and sample data; never touches real devices
  Composition/    WpfCompositionRoot.cs
```

## Acceptance

- Clear `Views/`, `ViewModels/`, and `Resources/` separation exists.
- Main window and core page layout live in XAML.
- Layout uses `Grid`, `DockPanel`, `ScrollViewer`, `ContentControl`, and `ItemsControl`.
- `Canvas` is not used for ordinary layout.
- Header, navigation, workspace, parameter/inspector, and status/log regions are stable.
- Parameter panels, log panels, and long lists scroll, collapse, page, or virtualize.
- Styles, colors, fonts, spacing, and data templates are centralized in resource dictionaries.
- View models raise change notification, and commands expose enable state.
- Long commands are async, cancellable, and report failure without blocking the UI.
- Validation uses `INotifyDataErrorInfo`, `ValidationRule`, or the project standard, and surfaces near the control.
- View models do not touch concrete controls, vendor SDKs, database implementations, or file dialogs.
- Code-behind carries no device communication, workflow, saving, algorithms, or business state machine.
- Design-time data does not touch serial ports, databases, or network services.
- The build shows no missing XAML resources, unmatched `DataTemplate`s, or broken binding paths.
- Main window opens without real devices.
- If the UI runs, at least one post-run visual check is done.
