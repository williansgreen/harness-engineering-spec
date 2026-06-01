# WinForms IPC UI Acceptance

Use this reference for fixed industrial PCs, medical workstations, kiosk-like screens, or lab instrument displays.

## Target Policy

For fixed IPC WinForms applications, prefer documenting:

- Target resolution.
- Windows scaling.
- Application font.
- DPI awareness policy.
- Minimum usable window size.
- Whether maximize is allowed.
- Whether each page may scroll.

`AutoScaleMode = Font` with System/SystemAware DPI is acceptable when the deployment display is fixed and verified.

## Visual Acceptance

Check every user-facing screen at the target display:

- No clipped labels, buttons, grid cells, tabs, status strips, or combo boxes.
- No overlapping controls.
- Primary actions are visible or reachable.
- Fault and safety state is visible without relying on color alone.
- Long Chinese labels fit or wrap intentionally.
- Tables have usable columns at the target width.
- Maintenance and debug screens do not compress device-control buttons below readable height.

## WinForms Implementation Rules

- Keep fixed shells Designer-visible.
- Use `TableLayoutPanel`, `SplitContainer`, `FlowLayoutPanel`, `Panel`, `UserControl`, `ToolStrip`, and `StatusStrip`.
- Use `Dock`, `Anchor`, `MinimumSize`, and scrollable panels.
- Avoid absolute positioning for ordinary controls.
- Reserve absolute coordinates for physical diagrams or custom drawing surfaces.

## Evidence

Static checks and offscreen render probes are useful, but final acceptance for fixed IPC UI should include target-machine screenshots or signed manual notes. Put project-specific targets in `harness/ui-acceptance.md`.
