# Implementation Handoff

Use this after Gate 1 approval or when reviewing an existing implementation. Before approval, the design packet may contain only a non-executable routing note: the recorded UI framework, target implementation skill, and applicable reference filenames. That note is not approval to plan or write implementation.

When the UI framework is already known, include this routing note in every design packet, even if the user requested design only and Gate 1 is still pending. This proves that a WinForms design will not later be handed to WPF guidance, or vice versa.

## Design package handed to implementation

Provide:

- Approved project context and approval record.
- Screen map and low-fidelity wireframes with revision identifiers.
- State/action matrix.
- Interaction specification, including failure, interruption, recovery, validation, alarm, keyboard/focus, and adaptation behavior.
- Critical-action rationale and external safeguards.
- Links to the project's design-system tokens, components, icons, charts, and relevant existing views.
- Testable UI acceptance criteria at target windows, scaling, languages, and states.
- Accepted assumptions, open findings, and named owners.

## Ownership boundary

The design package specifies intent and observable behavior. It may name semantic component roles such as primary action, destructive action, alarm banner, parameter editor, trend workspace, or status summary. It does not duplicate:

- Markup layout recipes, resource dictionaries, or designer-generated code.
- MVVM, MVP, and code-behind rules.
- Concrete token values or control styles already owned by the design system.
- Device SDK boundaries, threading, logging, chart-library selection, build, test, or packaging guidance.

This exclusion applies even when the user asks for design and implementation planning in one prompt. Do not provide folder trees, files, classes, view models, presenters, resource-dictionary structure or merge order, bindings, commands, token organization, control selection, or sample markup. Explicitly defer those decisions to the implementation skill after Gate 1.

## Skill handoff

Select the implementation skill from the project's UI framework, recorded under `ui_implementation.ui_framework` in the project context. The filenames below are routing metadata while this design skill is active: name the applicable set, but do not read, summarize, or apply those files. After Gate 1 approval, invoke the implementation skill and let that skill load only the references the implementation task needs.

C# WPF, via `csharp-winforms-wpf`:

- `references/wpf-mvvm.md`
- `references/designer-xaml-rules.md`
- `references/ui-layout-state-charting.md`
- `references/theme-design-tokens.md`
- `references/csharp-acceptance-checklist.md` for final readiness

C# WinForms, via `csharp-winforms-wpf`:

- `references/winforms-mvp.md`
- `references/designer-xaml-rules.md`
- `references/winforms-dpi-scaling.md` for scaling policy
- `references/ui-layout-state-charting.md`
- `references/theme-design-tokens.md`
- `references/csharp-acceptance-checklist.md` for final readiness

Any other framework: stop with a complete implementation brief and state that no implementation skill covers this stack.

If `ui_implementation.ui_framework` is missing or ambiguous, do not infer a framework from generic terms such as MVVM, XAML, desktop, or upper-computer. Record the gap and ask for the framework before selecting a reference set.

If the selected skill is unavailable, stop with the brief and state the missing dependency. Do not create a competing implementation standard inside this skill.

## Implementation review evidence

Prefer runtime screenshots or recordings with known window size, scaling, language, data/state fixture, and revision. Where runtime evidence is impossible, mark code-only review limits explicitly. Re-run Gate 2 after changes that affect task flow, state visibility, critical actions, alarms, or minimum-window behavior.
