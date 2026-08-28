# Core Principles

These are the stable design principles for instrument interfaces, independent of UI framework. Apply them before selecting a page pattern. They describe design intent, not markup or styling mechanics.

## 1. Design around work and consequences

- Organize the UI around user tasks, decisions, handoffs, and recovery paths.
- Make the current task, next valid step, completion condition, and blocking condition understandable.
- Do not let the device category or a hardware block diagram dictate navigation by default.

## 2. Make state explicit

- Model device, connection, workflow, data, alarm, and save/export states separately.
- Show the states that change what the user may safely do.
- State presentation includes a label and, when useful, an icon or shape; never rely on color alone.
- A fault state explains impact, data status, and the next safe action.

## 3. Preserve information hierarchy

- Give primary space to the information needed for the current decision.
- Keep critical status and active risk visible while users inspect detail.
- Put engineering diagnostics behind progressive disclosure when the primary user is operating rather than diagnosing.
- Density is purposeful: compact repeated data, but preserve grouping, scan paths, units, and action separation.

## 4. Match action treatment to consequence

- Distinguish primary, secondary, reversible, destructive, emergency, and unavailable actions.
- Assess each consequential action; do not assign one risk label to the entire product and stop there.
- Choose safeguards from consequence, reversibility, detectability, time pressure, frequency, authorization, audit, and recovery—not from industry labels.
- Keep critical actions spatially and semantically distinct from routine actions.
- Confirmation is not the only safeguard. Prefer prevention, valid-state enablement, previews, undo, staged commitment, recovery, and physical interlocks where appropriate.
- UI treatment never substitutes for engineering safety controls.

## 5. Design failure and recovery as first-class flows

- Include disconnected, empty, loading, invalid, interrupted, stopping, faulted, partial-result, save-failed, and recovery states when applicable.
- Tell the user what happened, what was affected, whether data is intact, and what to do next.
- Avoid dead ends and blank regions; each non-terminal state offers a next action or a clear waiting condition.

## 6. Protect data meaning

- Keep value, unit, range, timestamp/freshness, source, and quality together when they affect decisions.
- Distinguish live, buffered, calculated, imported, stale, invalid, and unsaved data.
- Preserve traceability between settings, run/batch identity, results, alarms, and exports when the project requires it.

## 7. Make alarms actionable

- Separate normal status, advisory information, warnings, alarms, and faults.
- Prioritize by user consequence and required response, not visual drama.
- Show cause or observable condition, impact, required response, acknowledgement state, and access to details when known.
- Avoid uncontrolled flashing, alarm floods, and modal dialogs for routine notifications.

## 8. Support real operating conditions

- Design for the documented minimum window, scaling, language, input device, distance, lighting, and operator workload.
- Keep keyboard and focus order viable for frequent or gloved workflows when required.
- Do not assume mouse-only use, perfect vision, quiet surroundings, uninterrupted attention, or a single display size.

## 9. Separate design truth from implementation truth

- This skill owns why information and actions are arranged as specified.
- The project design system owns visual tokens and reusable component appearance.
- The UI-framework engineering skill owns markup, presentation patterns such as MVVM or MVP, DPI and scaling mechanics, threading, device boundaries, libraries, build, and verification.
- Link to an existing source of truth instead of copying it.

## Admission rule for new core principles

Do not add a project lesson directly to this file. A proposed core principle needs evidence that it:

- Applies across more than one independent project or is grounded in an authoritative standard.
- Changes a design decision in a repeatable, observable way.
- Is independent of device vocabulary and one implementation library.
- Does not conflict with a stronger safety, regulatory, accessibility, or project constraint.

Otherwise keep it as a project convention or candidate pattern.

