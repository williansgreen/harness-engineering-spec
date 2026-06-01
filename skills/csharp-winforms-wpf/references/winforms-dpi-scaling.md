# WinForms DPI And Scaling

Use this reference when creating or reviewing WinForms DPI behavior, form scaling, or fixed industrial display layout.

## Policy Choice

First identify the project policy from:

- `app.manifest`
- `app.config` or `App.config`
- `Program.cs` or application startup
- Existing form `AutoScaleMode` values
- Deployment display resolution, Windows scale, and default font

Do not change DPI behavior as a side effect of ordinary UI cleanup.

## Fixed Industrial Or Legacy WinForms

For fixed IPC screens, lab instruments, hospital workstations, or legacy `.NET Framework` WinForms, this policy is acceptable:

- Form and user controls use `AutoScaleMode = Font`.
- Application DPI awareness is System/SystemAware.
- Target font, resolution, Windows scale, and minimum window size are documented.
- Runtime checks use the same DPI awareness policy as production.

This avoids mixed per-monitor behavior on machines where the app normally runs on one known display.

## Modern Multi-Monitor WinForms

Use `AutoScaleMode = Dpi` and PerMonitorV2-style behavior only when:

- The target framework and deployment OS support it.
- Startup code, manifest, and config agree.
- Forms have been visually checked after moving between monitors with different scales.
- Third-party controls and chart controls are known to behave correctly.

Do not enable PerMonitorV2 merely because a generic high-DPI guide recommends it.

## Layout Rules

- Use `TableLayoutPanel`, `SplitContainer`, `FlowLayoutPanel`, `Panel`, `UserControl`, `ToolStrip`, and `StatusStrip`.
- Set `Dock`, `Anchor`, `MinimumSize`, and `AutoScroll` where appropriate.
- Keep status and fault information visible when parameter panels scroll.
- Reserve absolute coordinates for physical maps, calibrated images, fixture layouts, or custom drawing surfaces.
- Do not reset `AutoScaleDimensions` at runtime to hide layout defects.
- Do not mix `Font` and `Dpi` scaling across related forms without recording the reason.

## Verification

Check at the project's documented target:

- Main workstation resolution.
- Main workstation Windows scale.
- Default application font.
- Narrow fallback size such as 1366x768 when relevant.
- 150% or 200% scale only if the deployment environment can use it.

Acceptance fails when text clips, controls overlap, key actions become unreachable, status is hidden, or chart/data areas collapse below usable size.
