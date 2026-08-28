# UI Layout, State, And Charting

Use this reference for instrument dashboards, adaptive layout, state display, and graph-heavy UI. For WinForms DPI policy details, read `references/winforms-dpi-scaling.md`.

## Layout Priorities

Instrument UI must prioritize:

- No overlapping controls.
- No clipped text.
- Device and workflow status remain visible.
- Chart/data workspace gets primary space.
- Parameter panels can scroll or collapse.
- Logs can collapse or move to a details panel.
- High DPI remains readable and clickable.

Check at least:

- Project default window.
- 1366x768 or the project's narrow target.
- 1920x1080.
- 150% DPI when possible.
- 200% DPI for core workflow when possible.

Do not hard-code these sizes as fixed design constraints. They are inspection scenarios.

## Size Units

- WPF sizes are device-independent units, not physical pixels.
- WinForms design-time sizes scale with DPI; do not treat Designer numbers as fixed physical pixels.
- Size ranges given in this reference are layout guidance. Adjust them for font, language string length, DPI, control library, and the project's default window.

## WinForms Layout

Prefer:

- `TableLayoutPanel`
- `SplitContainer`
- `FlowLayoutPanel`
- `Panel`
- `UserControl`
- `MenuStrip`
- `StatusStrip`
- `ToolStrip`

Set:

- `Dock`
- `Anchor`
- `MinimumSize`
- `AutoScroll` on parameter panels that can exceed the available height.

- Match the project's documented scaling policy before changing `AutoScaleMode`, manifest, app config, or entry-point DPI calls.

Avoid placing every control directly on the form with absolute coordinates.
Use containers for normal UI and reserve absolute positions for physical maps, calibrated overlays, or custom drawing surfaces with documented coordinate meaning.

Typical shell proportions, to adapt rather than copy:

```text
Header row:        56-72 px, optional
Main area:         fills remaining space
Status bar row:    32-48 px
Navigation panel:  ~220 px expanded, ~64 px collapsed
Parameter panel:   ~280-380 px
```

Parameter panels read well as a three-column `TableLayoutPanel`:

```text
Column 0: parameter name
Column 1: input control
Column 2: unit
```

When parameters outgrow the panel: enable `AutoScroll`, collapse advanced groups by default, and disable dangerous parameters while running.

## Menus, Toolbars, And Status Bars

- `MenuStrip`: low-frequency global commands such as file, experiment, import/export, settings, help.
- `ToolStrip`: high-frequency operator commands such as connect, start, pause, stop, save, export.
- `StatusStrip`: persistent status such as device state, workflow state, progress, last error.

Keep fixed menu items, toolbar buttons, and status items Designer-editable so text, order, icons, and shortcuts stay adjustable. Reserve runtime-generated menu items for recent files, plugin commands, or device-capability commands, and mount them under an existing static parent item.

## WPF Layout

Prefer:

- `Grid`
- `DockPanel`
- `StackPanel`
- `WrapPanel`
- `ContentControl`
- `ScrollViewer`
- `ItemsControl`
- `DataTemplate`
- `ControlTemplate`
- `ResourceDictionary`
- `VisualStateManager`

Use `Auto`, `*`, `MinWidth`, and `MaxWidth` rather than fixed widths. Avoid `Canvas` for normal resizable application layout. Split pages into `UserControl` and keep styles in resource dictionaries.

```xml
<Grid>
    <Grid.RowDefinitions>
        <RowDefinition Height="56" />
        <RowDefinition Height="*" />
        <RowDefinition Height="36" />
    </Grid.RowDefinitions>
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="{Binding NavigationWidth}" MinWidth="64" MaxWidth="240" />
        <ColumnDefinition Width="*" MinWidth="520" />
        <ColumnDefinition Width="320" MinWidth="280" MaxWidth="420" />
    </Grid.ColumnDefinitions>
</Grid>
```

## Collapse And Scroll Priority

When space runs short, sacrifice in this order:

1. Keep the central workspace usable.
2. Collapse or scroll the parameter panel.
3. Collapse the navigation panel.
4. Collapse the log panel.
5. Move non-critical detail to a details view.

Never compress the core chart below a readable size.

## WPF Animation

Animation should serve state transitions, not decoration.

Acceptable:

- Navigation expand/collapse.
- Parameter panel expand/collapse.
- Light page fade.
- Button hover/pressed feedback.
- Smooth state color change.
- Loading indicators.

Avoid:

- Large sustained animation.
- Many controls moving at once.
- Flashing alarms.
- Elaborate bounce effects.
- Particle or background animation.
- Real-time curves that animate point by point.

```text
Duration: 120-250 ms
Easing:   CubicEase / SineEase
Alarms:   restrained; must not interfere with reading values
Access:   support reduced or disabled animation
```

## Third-Party Controls

A third-party control library must have active maintenance, a clear license, support for the target framework and platform, high-DPI support, adequate documentation, and visual consistency with the project. Do not pull in a heavy UI framework for a single effect.

Wrap third-party APIs behind project types instead of calling them throughout business code.

Before adopting one, answer:

- Why is it needed?
- Is there a lighter alternative?
- What is the deployment size impact?
- What is the license impact?
- Can it be tested or wrapped?
- Does it keep UI style consistent?

For instrument software, stability and maintainability outrank visual novelty.

## Parameter Controls

| Parameter type | Suggested control |
| --- | --- |
| Toggle | `CheckBox` / toggle |
| Enum | `ComboBox` |
| Numeric | `NumericUpDown` or `TextBox` with validation |
| Range | Two inputs, or slider plus input |
| File path | `TextBox` plus Browse |
| Color | Swatch plus picker |
| Advanced group | Grouped or collapsible panel |

Every parameter must show its name, current value, unit, legal range, default or recommended value, and validation error.

## Notification Surfaces

- Top status bar: key device state.
- Bottom status bar: progress, save state, last message.
- Side summary: current experiment result.
- Log panel: detailed diagnostics.
- Non-blocking toast: light notifications.
- Modal dialog: dangerous-operation confirmation.

Do not route every notification through `MessageBox`.

## Icons

- Keep one icon style.
- Give every icon a tooltip.
- Never let an icon carry meaning alone.
- Prefer simple line icons for instrument UI.
- For high DPI, use SVG, vector `Path`, icon fonts, or multi-scale assets rather than a single low-resolution PNG.

## Status Model

Separate device state from experiment/workflow state.

Common states:

```text
Loading
Empty
Disconnected
Connecting
Connected
Ready
Preparing
Running
Paused
Stopping
Completed
Saving
Exporting
Faulted
Disabled
```

Rules:

- Disabled buttons should follow business state.
- Faulted state should show a user action and log details.
- Colors cannot be the only state signal; include text or icon.
- Key state transitions should be logged.

### State Presentation

| State | UI | Action policy |
| --- | --- | --- |
| Disconnected | Grey/offline label | Disable acquisition, allow connect |
| Connecting | Progress indicator | Disable repeat connect |
| Ready | Normal | Allow configure and start |
| Running | Running color, progress | Disable dangerous parameters, allow pause/stop |
| Paused | Paused color | Allow resume/stop |
| Stopping | Waiting indicator | Disable repeat stop |
| Completed | Success indicator | Allow save/export |
| Faulted | Error bar plus log detail | Disable dangerous actions, allow recovery |
| Saving | Save progress | Block close, or warn about the risk |
| Exporting | Export progress | Allow cancel or background execution |

### Button State

Enablement follows business state, for example:

- Device not connected: disable start.
- Running: disable dangerous parameter edits.
- Stopping: disable repeat stop.
- Saving: disable closing the experiment, or warn.
- Invalid parameter: disable start and show the error.

### State Colors

- Green: normal, complete, runnable.
- Blue: information, preparing, connecting.
- Yellow: warning, needs confirmation.
- Red: error, alarm, failure.
- Grey: offline, disabled, unconfigured.

Color is never the only signal; key states carry text or an icon.

### Empty States

An empty state must offer the next action:

- No device: show the connect entry point.
- No experiment: show create or open.
- No data: show waiting-for-acquisition or import.
- No records: show the active filter and a clear-filter action.

Do not leave a blank region.

### Error States

An error message should say what happened, whether the current experiment is affected, whether data was saved, what the user can do next, and whether logs should be consulted.

```text
Info:     status bar or toast
Warning:  inline hint or warning bar
Error:    error bar plus log detail
Critical: modal dialog plus stop dangerous operations
```

### Logged Transitions

Always log: connect, disconnect, start, pause, stop, complete, save, export, exception. The UI shows the summary; the log keeps the detail.

## Charts

Default recommendations:

- WinForms scientific curves: ScottPlot.
- WPF scientific curves: ScottPlot first; LiveCharts2 when MVVM binding or animated dashboard behavior is important.
- Existing OxyPlot projects should usually keep OxyPlot unless there is a concrete reason to migrate.

Chart features to consider:

- Title.
- Axis labels and units.
- Legend.
- Zoom and pan.
- Reset view.
- Export PNG.
- Export raw data or CSV.
- Cursor/data-point inspection.
- Multiple curves.

Chart color must not be the only distinguishing signal; use line style, markers, or legend text as well.

Real-time rule:

```text
Acquisition frequency is not UI refresh frequency.
```

Use buffers and refresh UI at a controlled rate, commonly 5-20 Hz. Do not redraw complex UI for every sampled point. Downsample or window large curves, page or virtualize large tables, and batch log appends. UI refresh must never block acquisition.

## Acceptance

Check at the project's documented targets:

- No overlapping controls at the default window.
- Core workflow usable at 1366x768 or the project's narrow target.
- Sensible information hierarchy at 1920x1080.
- No clipped text at 150% DPI, where the deployment environment can use it.
- Core workflow operable at 200% DPI, where relevant; navigation may collapse, parameters may scroll, logs may hide.
- On multi-monitor setups, moving the window between displays with different scales keeps the main window, dialogs, charts, and dropdowns usable.
- Layout stays stable after navigation collapse/expand.
- Parameter panels scroll when content overflows.
- Charts remain interactive after resize.
- An expanded log panel does not cover key actions.
- `MenuStrip`, `ToolStrip`, and `StatusStrip` text, icons, and dropdowns do not clip at high DPI.
- The main form and core `UserControl`s open in the Designer, and fixed menus, toolbars, status bars, and main containers remain editable there.
