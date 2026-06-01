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

## WinForms Layout

Prefer:

- `TableLayoutPanel`
- `SplitContainer`
- `FlowLayoutPanel`
- `Panel`
- `UserControl`
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

## WPF Layout

Prefer:

- `Grid`
- `DockPanel`
- `ContentControl`
- `ScrollViewer`
- `ItemsControl`
- `DataTemplate`
- `ResourceDictionary`

Avoid `Canvas` for normal resizable application layout.

## Status Model

Separate device state from experiment/workflow state.

Common states:

```text
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

## Charts

Default recommendations:

- WinForms scientific curves: ScottPlot.
- WPF scientific curves: ScottPlot first; LiveCharts2 when MVVM binding or animated dashboard behavior is important.
- Existing OxyPlot projects should usually keep OxyPlot unless there is a concrete reason to migrate.

Chart features to consider:

- Axis labels and units.
- Legend.
- Zoom and pan.
- Reset view.
- Export PNG.
- Export raw data or CSV.
- Cursor/data-point inspection.
- Multiple curves.

Real-time rule:

```text
Acquisition frequency is not UI refresh frequency.
```

Use buffers and refresh UI at a controlled rate, commonly 5-20 Hz. Do not redraw complex UI for every sampled point.
