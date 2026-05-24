# Theme And Design Tokens

Use this reference when creating or reviewing WinForms/WPF instrument UI visuals.

## Visual Principles

- Professional, restrained, and stable.
- Charts, data, workflow state, and device status have priority over decoration.
- Colors communicate state and grouping; they should not dominate the whole app.
- Text must not clip at high DPI.
- Core actions must remain reachable at the project's narrow target window.

## Typography

Default choices:

```text
Chinese UI: Microsoft YaHei UI
English and numbers: Segoe UI
Monospace: Cascadia Mono or Consolas
```

Typical sizes:

```text
Body: 9-10 pt
Section heading: 11-12 pt
Page heading: 14-16 pt
Status bar: 9 pt
Tables: 9-10 pt
```

Do not use hero-sized headings inside dense desktop panels.

## Spacing And Sizing

Suggested tokens:

```text
Base spacing: 8
Compact spacing: 4
Group spacing: 12-16
Page padding: 16-24
Input height: 28-32
Button height: 32-36
Toolbar button: 32
Status bar height: 32-40
Left navigation expanded: 200-240
Left navigation collapsed: 56-72
Right parameter panel: 280-380
```

Treat these as starting points, not hard-coded requirements. Validate by running the UI when possible.

## State Colors

Suggested tokens:

```text
Info: #2563EB
Success: #16A34A
Warning: #D97706
Error: #DC2626
Disabled: #9CA3AF
TextPrimary: #111827
TextSecondary: #4B5563
Border: #D1D5DB
Surface: #FFFFFF
SurfaceMuted: #F3F4F6
```

Rules:

- Color cannot be the only state signal.
- Alarm and disabled colors must remain distinguishable.
- Dark theme is optional; if added, chart colors and warning states require another visual check.

## Chart Colors

Use a distinguishable sequence such as:

```text
Blue
Green
Orange
Purple
Red
Teal
Gray
```

When curves are numerous, also use legend, line style, marker, grouping, or filtering.

## Implementation

WinForms:

```text
ThemeColors.cs
ThemeFonts.cs
LayoutConstants.cs
```

WPF:

```text
Resources/Colors.xaml
Resources/Spacing.xaml
Resources/Typography.xaml
Resources/ControlStyles.xaml
```

