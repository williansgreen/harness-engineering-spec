# WinForms Main Form Layout Template

Use this as a structure guide for Designer-visible instrument shells. Adapt names to the project.

```text
MainForm
  TableLayoutPanel rootLayout (Dock=Fill, rows: ToolStrip, content, StatusStrip)
    ToolStrip mainToolStrip
      Start / Stop / Save / Export / Settings commands
    SplitContainer mainSplit (Dock=Fill)
      Panel1: navigation or parameter area
        TableLayoutPanel parameterLayout (Dock=Fill, AutoScroll on nested panel when needed)
      Panel2: workspace area
        TableLayoutPanel workspaceLayout (Dock=Fill)
          status summary row
          chart/data panel
          collapsible log/details panel
    StatusStrip mainStatusStrip
      connection status
      workflow status
      last error/fault summary
```

Rules:

- Put this fixed shell in `InitializeComponent()` so Visual Studio Designer can see it.
- Mount runtime-generated parameter controls only inside named designer-created panels.
- Keep long-running device or data work outside the form and presenter UI thread.
- Use `AutoScaleMode = Dpi` with PerMonitorV2 set before WinForms initialization, or the project's documented alternative.
- Set `MinimumSize` on the form and critical panels so dynamic labels, toolbars, and charts do not collapse.
