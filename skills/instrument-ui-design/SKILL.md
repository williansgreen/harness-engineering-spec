---
name: instrument-ui-design
description: Design and review upper-computer and instrument-control interfaces from project evidence, before implementation and independent of UI framework. Use for information architecture, low-fidelity wireframes, workflow- and risk-driven interaction specifications, design review findings, and evidence-backed pattern evolution. Applies to WPF, WinForms, and other desktop UI stacks. Do not use as a replacement for XAML/MVVM, theme-token, device-integration, or other implementation standards.
---

# Instrument UI Design

Turn instrument project evidence into a reviewable UI design. Keep design decisions separate from UI-framework implementation mechanics.

## Operating boundary

This skill owns:

- Project-context normalization.
- Task, state, risk, and information architecture.
- Low-fidelity wireframes and interaction specifications.
- Workflow/risk-based pattern selection.
- Wireframe approval and final design-review gates.
- Findings that can improve the pattern library or, rarely, the core principles.

This skill does not own:

- XAML structure, MVVM implementation, code-behind policy, threading, device abstractions, chart-library selection, DPI mechanics, design-token values, build, or test implementation.
- Domain profiles based only on labels such as medical, optical, or chemical.
- Product safety analysis, regulatory approval, or hardware interlocks.

When implementation is requested, read [references/implementation-handoff.md](references/implementation-handoff.md) and hand off to the implementation skill for the project's UI framework. Do not restate or fork its implementation rules.

Even when the same request asks for design plus implementation planning, this skill must not specify or recommend MVVM/MVP structure, view-model or presenter classes, folders, XAML resource dictionaries, bindings, commands, token organization, control libraries, or code. Decline that portion explicitly. During design, an implementation-routing note may name only the recorded UI framework, the implementation skill, and the applicable reference filenames; it must not load, summarize, or apply those implementation references before Gate 1 approval.

## Modes

Choose the smallest mode that satisfies the request:

- **Design:** context -> architecture -> wireframe -> approval -> interaction specification -> implementation brief.
- **Review:** inspect an existing wireframe, design, screenshot, or running UI and produce evidence-backed findings.
- **Pattern learning:** turn resolved project findings into candidate pattern updates without promoting them automatically.

## Required references

- For every design or review, read [references/core-principles.md](references/core-principles.md).
- When creating or repairing project context, read [references/project-context.md](references/project-context.md) and use [assets/project-context.template.yaml](assets/project-context.template.yaml).
- When selecting, comparing, or updating layouts, read [references/pattern-library.md](references/pattern-library.md).
- Before requesting wireframe approval or issuing a design-review result, read [references/gates-and-review.md](references/gates-and-review.md). For a filled-in approval record, findings, and gate result, see [assets/gate-artifacts.example.md](assets/gate-artifacts.example.md).
- Read [references/implementation-handoff.md](references/implementation-handoff.md) when implementation is requested or the UI framework is known. Before Gate 1 approval, use it only to emit the non-executable routing note; never load the implementation references it names.

## Decision axes

Use two independent axes. Do not replace them with an industry label.

1. **Consequence/risk per action:** what happens if this action is wrong, late, repeated, or interrupted? Consider reversibility, detectability, recovery, frequency, time pressure, authorization, audit needs, and non-UI safety controls.
2. **Workflow shape:** `single_measurement`, `continuous_process`, `batch_sequence`, `exploratory_live_tuning`, or a documented hybrid.

Device vocabulary such as wavelength, ROI, pressure, flow, or patient ID belongs in Project Context. It becomes a reusable rule only after evidence shows that it changes interaction or layout across projects.

## Design workflow

1. **Inspect evidence.** Read the supplied brief, repository docs, existing screenshots, user research, operating procedures, alarm lists, device state definitions, and current design-system sources. Distinguish facts from assumptions.
2. **Normalize context.** Create or update a context document using the template. Ask only about missing facts that materially change workflow, risk treatment, or screen constraints. Record lower-impact uncertainty as assumptions. When the UI framework is known, record the exact `ui_implementation.ui_framework` value even though implementation is not yet in scope.
   - **No-layout stop:** if the available evidence is only a product or industry label, or otherwise supplies neither a concrete primary task nor a defensible workflow shape, stop before pattern selection and wireframing. Return the material context gaps and offer to create the context document. A label such as medical, optical, chemical, or industrial supplies neither workflow evidence nor action risk.
   - For a domain-label-only request, the response must state that this skill performs neither hazard analysis nor regulatory approval and must ask for the specific critical actions. For each action, explicitly request consequence, reversibility/recovery, detectability, frequency/time pressure, authorization/audit expectations, and non-UI safeguards. Do not compress these fields into a generic question about risk.
   - When the prompt provides a concrete workflow such as continuous acquisition, a batch process, or a 20-item queue, proceed with the corresponding candidate architecture and low-fidelity wireframe. Do not stop solely because domain details, display targets, or action consequences are missing. Mark those as assumptions or open findings, keep consequential actions at `risk: unknown`, and do not claim their safeguards are adequate.
3. **Model before layout.** Produce:
   - Primary users, tasks, decisions, and success/failure outcomes.
   - Separate device, workflow, data, connection, and alarm states.
   - A state/action matrix showing visibility, enablement, confirmation, recovery, and audit expectations.
   - A screen map based on tasks, not an inherited list of generic pages.
4. **Select candidate patterns.** Use workflow shape for the screen's dominant structure and risk as a modifier of actions, state visibility, permissions, and recovery. Cite the selected pattern's maturity and project evidence. A candidate pattern is not a standard.
5. **Create low-fidelity wireframes.** Show regions, hierarchy, key data, actions, states, alarms, next steps, and adaptation at the minimum and default target windows. Exclude color palettes, shadows, gradients, decorative icon work, and detailed control styling.
6. **Run Gate 1: Wireframe Approval.** Produce the approval packet defined in `gates-and-review.md`. Do not proceed to visual styling, implementation, or XAML until a named approver records approval. If approval is absent, stop at a reviewable packet and request it.
7. **Specify interaction after approval.** Document navigation, state transitions, command availability, dangerous-action treatment, validation, interruption, recovery, empty/loading/error behavior, alarm acknowledgement, keyboard/focus expectations, and adaptive priorities. Refer to the existing design system for component and token choices instead of inventing parallel values.
8. **Prepare implementation handoff.** Package the approved design rationale and acceptance evidence. Invoke the implementation skill when available. Before approval, provide at most the non-executable routing note described under Operating boundary; do not produce implementation planning under the label of a handoff. Every design packet with a known UI framework must include that routing note and the exact applicable reference filenames from `implementation-handoff.md`.
9. **Run Gate 2: Design Review.** Review the final design or implemented UI against the approved context, wireframe, interaction specification, target sizes, and state coverage. Report findings with evidence and disposition; do not return a vague pass/fail.
10. **Capture learning.** Feed resolved findings into the pattern observation template. Keep one-project lessons at project or candidate-pattern level until broader evidence justifies promotion.

## Default artifacts

When the task creates durable files and the repository has no established location, use `docs/ui-design/`:

```text
docs/ui-design/
  project-context.yaml
  ui-architecture.md
  wireframes.md
  interaction-spec.md
  design-review.md
  pattern-observations.md
```

Preserve existing project locations and formats when present. Do not overwrite approved artifacts without recording the change and its reason.

Artifacts belong to the project or to this skill's source repository. Never write them into an installed copy of this skill — see `references/pattern-library.md` → Where observations live.

## Output quality

- Lead with the current decision or gate result.
- Label facts, assumptions, open questions, and rejected alternatives.
- Trace every critical screen element and action to a user task, state, risk, or evidence source.
- Show states and consequences with text or structure; color alone is never sufficient.
- Make findings testable and attach evidence such as a screenshot, state, task step, or target window.
- Match the user's working language while keeping stable identifiers in the context file.
