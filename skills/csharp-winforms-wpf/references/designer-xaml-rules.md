# Designer And XAML Rules

Use this reference when creating or adjusting UI code.

The governing principle for instrument software:

```text
Static shell, dynamic content.
Layout visible in the designer, data bound at runtime.
```

## WinForms Hard Rules

Unless the user explicitly asks for pure runtime UI:

- Fixed shell belongs in `InitializeComponent()`.
- Fixed navigation, toolbars, status bars, parameter containers, chart/table containers, and main split layouts should be designer-visible.
- Runtime-generated controls may only be mounted into stable designer containers.
- Keep stable names for important controls.
- Do not build the whole main window through `BuildUi()`, `CreateLayout()`, `CreateControls()`, or similar helpers.
- Use designer-visible containers such as `TableLayoutPanel`, `SplitContainer`, `FlowLayoutPanel`, `Panel`, and `UserControl` for normal UI layout.
- Avoid absolute coordinates for internal controls unless the UI represents a physical layout, calibrated image/fixture, or custom drawing surface.
- Keep `Form` and `UserControl` parameterless constructors. They must not connect devices, read databases, load large files, start background tasks, or resolve from a DI container.

Allowed in `.Designer.cs`:

- Field declarations for every fixed control.
- `components` and `Dispose(bool disposing)`.
- Simple control creation, properties, `Controls.Add`, `Dock`, `Anchor`, `Size`, `Location`, `Name`, `Text`, `TabIndex`.
- `MenuStrip`, `ToolStrip`, and `StatusStrip` with their fixed items and properties.
- `SuspendLayout()` / `ResumeLayout(false)` / `PerformLayout()`.
- `BeginInit()` / `EndInit()` initialization blocks.
- Simple event binding to named methods.
- Design-time resources managed through `.resx`.

Avoid in `.Designer.cs`:

- Business logic.
- Runtime conditions — `if`/`switch` that change the fixed layout.
- `for`/`foreach` loops that build fixed main-layout controls.
- LINQ, lambdas, or large chained object initializers used to assemble fixed UI.
- Helper calls such as `BuildUi()`, `CreateLayout()`, `ConfigureRuntimePanels()`.
- Device, database, network, file-system, or DI container access.
- Presenter or service calls.
- Local-variable controls for fixed UI. The designer cannot round-trip them; fixed controls need fields with stable `Name` values.

### Designer-Safe Shell

Give the shell stable named hosts so presenters and factories have somewhere to mount content:

```text
workspaceHost
parameterPanelHost
chartHost
logPanelHost
```

Not this:

```csharp
private void InitializeComponent()
{
    BuildUiFromConfiguration();
    CreateDevicePanels(_runtimeDevice);
}
```

This:

```csharp
private void InitializeComponent()
{
    this.rootLayout = new TableLayoutPanel();
    this.workspaceHost = new Panel();
    this.parameterPanelHost = new Panel();

    this.rootLayout.Dock = DockStyle.Fill;
    this.workspaceHost.Name = "workspaceHost";
    this.parameterPanelHost.Name = "parameterPanelHost";

    this.rootLayout.Controls.Add(this.workspaceHost, 1, 0);
    this.rootLayout.Controls.Add(this.parameterPanelHost, 2, 0);
    this.Controls.Add(this.rootLayout);
}
```

Runtime wiring happens after construction, called by `Program.cs`, a form factory, or the composition root — never by the designer:

```csharp
public MainForm() => InitializeComponent();

public void AttachPresenter(MainPresenter presenter) => _presenter = presenter;
```

### Design-Time Safety

- Split large forms into several designer-friendly `UserControl`s rather than one deep `MainForm.Designer.cs`.
- Custom control constructors must be design-time safe. Guard runtime-only work with `LicenseManager.UsageMode == LicenseUsageMode.Designtime` or the project's equivalent check.
- When a third-party control is unstable in the designer, isolate it inside a small `UserControl` so the outer layout still opens.
- Keep regions users will want to tweak — menu items, toolbar buttons, parameter groups, status items, panel widths — editable in the designer rather than hidden behind runtime helpers.

## WPF Rules

- Fixed window, navigation, toolbar, status bar, parameter containers, and chart/table containers belong in XAML.
- Use `Grid`, `DockPanel`, `ContentControl`, `ScrollViewer`, and `ItemsControl` for adaptive layout.
- Do not assemble the main UI with `new Grid()` / `new Button()` in code-behind.
- Put colors, spacing, typography, and templates in resources when reused.
- Switch pages with `ContentControl` plus view model plus `DataTemplate`, not manual `new Page()` in code-behind.
- Avoid absolute positioning for resizable instrument dashboards unless there is a physical-layout reason.
- `Window`/`UserControl` constructors do `InitializeComponent()` and design-time-safe initialization only.

### Design-Time Data

- Keep design-time data under `DesignTime/`; it must never open serial ports, databases, or network connections.
- Use `d:DataContext` or a design-time view model to make previews useful.
- Cover the typical states: Disconnected, Ready, Running, Faulted, Empty.
- Isolate designer-hostile third-party controls so the main layout still previews.

```xml
<UserControl
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    d:DataContext="{d:DesignInstance Type=viewModels:MeasurementViewModel, IsDesignTimeCreatable=True}">
</UserControl>
```

## Runtime Visual Check

Compiling is not the completion bar for UI work. When the environment allows:

1. Build.
2. Launch the UI.
3. Inspect at the project default window, the narrow target such as 1366x768, and 1920x1080; check 125%/150% scale where the deployment environment can use it.
4. Look for clipped text, overlapping controls, unreachable actions, missing scroll, broken scaling assumptions, stale status display, and — for WPF — binding errors, missing resources, and unmatched `DataTemplate`s in the debug output.
5. Fix what you found.
6. Rebuild and re-check.

Bound the loop. Every round must correspond to a specific layout, binding, or usability defect, and the automatic iteration cap follows the project's strictness level:

| Level | Cap | Target |
| --- | --- | --- |
| L1 demo / teaching / one-off | 2 rounds | obvious overlap, clipping, unusable main flow |
| L2 prototype / internal tool | 2 rounds | main flow operable, no gross layout breakage |
| L3 formal scientific or industrial software | 3 rounds | main screen, scaling, status, core workflow usability |
| L4 medical, compliance, audited, high-risk | 5 rounds | more states, dialogs, permissions, failures, high DPI |

Screenshots and visual inspection are defect-finding tools, not a subjective polishing loop. Never iterate merely because it "could look a bit nicer". After the cap, stop adjusting and record the remaining issues, their impact, the scenarios already checked, and what needs human confirmation.

Final visual acceptance belongs to a person. You may produce the confirmation list; do not claim every visual detail passed without it.

If the same class of problem survives two rounds, stop pixel-level tuning and diagnose structure instead: root-level absolute coordinates, missing `TableLayoutPanel`/`SplitContainer`/`Dock`/`Anchor`, missing `MinimumSize`, a parameter panel that needs `AutoScroll`, a form that should be split into `UserControl`s, font or DPI clipping, or wrong overall layout proportions. Screenshots must not drive an unbounded repair loop.

If runtime UI inspection is not possible, say so, complete static layout, build, and binding-path checks, and report visual acceptance as pending rather than claiming the UI is accepted.
