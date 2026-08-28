# WinForms DPI And Scaling

Use this reference when creating or reviewing WinForms DPI behavior, form scaling, or fixed industrial display layout.

## Default Policy

**Default to `AutoScaleMode = Dpi`, with PerMonitorV2 DPI awareness set before WinForms initializes.**

```csharp
// .NET 6+ / .NET 8+
Application.SetHighDpiMode(HighDpiMode.PerMonitorV2);
ApplicationConfiguration.Initialize();
Application.Run(new MainForm());
```

```csharp
// Legacy entry point
Application.SetHighDpiMode(HighDpiMode.PerMonitorV2);
Application.EnableVisualStyles();
Application.SetCompatibleTextRenderingDefault(false);
Application.Run(new MainForm());
```

The DPI call must come before any WinForms initialization. Manifest, app config, startup call, and every form's `AutoScaleMode` must agree; a project should not mix `Dpi` and `Font` across related forms without recording why.

## Why Not `AutoScaleMode = Font`

`Font` scaling is unreliable in any project that changes the default font, because of how the Designer serializes `InitializeComponent()`.

Properties are emitted in property-name order, so the assignments land like this:

```csharp
this.AutoScaleDimensions = new SizeF(7F, 17F);  // A — baseline, from the OLD font
this.AutoScaleMode = AutoScaleMode.Font;        // A
// ...
this.Font = new Font("Microsoft YaHei UI", 10F); // F — applied AFTER the baseline
```

`Font` mode computes its scale factor as current font dimensions divided by `AutoScaleDimensions`. That baseline is captured at design time and written before `Font` is assigned, so once the font is changed the baseline no longer describes the font actually in use. The scale factor is then computed against a stale reference — the mode looks configured but produces no scaling, or scales by the wrong factor. Inherited forms and nested `UserControl`s make it worse, because each level carries its own baseline.

This has been observed in production instrument software. `Dpi` mode does not have the problem: it scales against device DPI and never depends on a font baseline.

## When `Font` Is Still Acceptable

Only with a recorded reason:

- Legacy `.NET Framework` WinForms already built and verified around `Font` scaling, where migration risk outweighs the benefit.
- A form deliberately intended to reflow with the system font, whose font is never overridden in the Designer.

If a project keeps `Font` mode, it must also keep `AutoScaleDimensions` consistent with the font actually used, and re-verify layout after any font change.

## Identify The Existing Policy First

Before changing anything, read:

- `app.manifest`
- `app.config` or `App.config`
- `Program.cs` or application startup
- Existing form `AutoScaleMode` values
- Deployment display resolution, Windows scale, and default font

Do not change DPI behavior as a side effect of ordinary UI cleanup. Migrating an existing project from `Font` to `Dpi` is a deliberate task with its own layout re-verification.

## Fixed Industrial Displays

Fixed IPC screens, lab instruments, and hospital workstations still default to `Dpi`. Being deployed to one known display is a reason to document the target resolution, Windows scale, and font — not a reason to depend on font-based scaling.

Document for these deployments:

- Target resolution and Windows scale.
- Default application font.
- Minimum usable window size.
- Whether runtime checks use the same DPI awareness as production.

## Layout Rules

- Use `TableLayoutPanel`, `SplitContainer`, `FlowLayoutPanel`, `Panel`, `UserControl`, `ToolStrip`, and `StatusStrip`.
- Set `Dock`, `Anchor`, `MinimumSize`, and `AutoScroll` where appropriate.
- Keep status and fault information visible when parameter panels scroll.
- Reserve absolute coordinates for physical maps, calibrated images, fixture layouts, or custom drawing surfaces.
- Do not reset `AutoScaleDimensions` at runtime to hide layout defects.
- Do not mix `Font` and `Dpi` scaling across related forms without recording the reason.

## Verification

`Dpi` mode does not remove the need to look at the result. Check at the project's documented target:

- Main workstation resolution and Windows scale.
- Default application font.
- Narrow fallback size such as 1366x768 when relevant.
- 125%, 150%, and — for high-risk or formal projects — 200% scale.
- Moving the window between monitors with different scales, since PerMonitorV2 rescales live.
- `Label`, `TextBox`, `DataGridView`, `ToolStrip`, and `MenuStrip` at each scale, which clip before container layouts do.

Acceptance fails when text clips, controls overlap, key actions become unreachable, status is hidden, or chart/data areas collapse below usable size.
