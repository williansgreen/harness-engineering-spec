# Gates and Design Review

The gates create evidence for approval and learning. A checklist without findings or disposition is not a completed review.

For a worked example of every structure below — approval record, findings at each severity, gate result, and evidence scope — see [../assets/gate-artifacts.example.md](../assets/gate-artifacts.example.md).

## Gate 1 — Wireframe Approval

### Required packet

- Context summary with evidence, assumptions, open questions, and scope.
- Primary task flows and screen map.
- Risk classification for critical actions.
- State/action matrix.
- Low-fidelity wireframes for the minimum and default target windows.
- Normal plus applicable empty, loading, invalid, disconnected, alarm, fault, interrupted, stopping, partial-result, save-failed, and recovery states.
- Rejected alternatives and decision rationale.

### Acceptance questions

- Can each primary user identify current state, current task, next valid step, and completion condition?
- Is the screen's primary region justified by workflow shape?
- Are critical states and action scope visible at the moment of decision?
- Are routine and consequential actions distinguishable without relying on color?
- Can users recover from interruption or failure without guessing what happened to data or equipment?
- Does the core task remain usable at the minimum window and specified scaling/language conditions?
- Are diagnostics and advanced parameters disclosed according to task and role?
- Are material assumptions either resolved or explicitly accepted?

### Approval record

Record:

```yaml
gate: wireframe
result: approved | approved_with_findings | rework_required
approver: <name-or-role>
date: <YYYY-MM-DD>
artifact_revision: <revision-or-commit>
accepted_assumptions: []
open_findings: []
```

No approval means no visual styling, implementation, or XAML. A user may explicitly authorize a documented exception, but the exception is not an approval and must remain visible in the handoff.

## Gate 2 — Final Design Review

Review the approved design specification and, when implementation exists, runtime evidence at the documented target windows and scaling. Compare against Gate 1 rather than reviewing aesthetics in isolation.

### Review dimensions

- Task completion and navigation.
- Device/workflow/data/connection/alarm state clarity.
- Action availability, scope, consequence, interruption, and recovery.
- Information hierarchy, data meaning, units, freshness, and traceability.
- Alarm prioritization, acknowledgement, impact, and next action.
- Empty, loading, invalid, fault, stopping, partial, and save/export states.
- Minimum/default window adaptation, scaling, text expansion, keyboard, focus, and non-color cues.
- Conformance to the approved wireframe and existing design system.
- Quality of the implementation handoff and unresolved assumptions.

### Finding format

Every finding contains:

| Field | Meaning |
| --- | --- |
| ID | Stable identifier such as `UI-DR-007`. |
| Severity | `blocker`, `major`, `minor`, or `note`. |
| Evidence | Screenshot/region, state, task step, target size, or reproducible observation. |
| Expected | Approved behavior or principle. |
| Actual | Observed behavior. |
| Impact | User, task, data, equipment, or safety consequence. |
| Recommendation | Smallest change that resolves the issue; avoid prescribing XAML unless implementation is in scope. |
| Disposition | `open`, `accepted`, `fixed`, `rejected_with_reason`, or `deferred_with_owner`. |
| Owner | Person or role responsible for disposition. |

Severity guidance:

- `blocker`: a critical task cannot be completed or a plausible severe consequence is not adequately controlled or visible.
- `major`: high error likelihood, hidden critical state, unclear action scope, or substantial task failure.
- `minor`: localized inconsistency, avoidable inefficiency, or non-critical accessibility/adaptation issue.
- `note`: evidence-backed improvement that does not currently impair acceptance.

### Gate result

- `pass`: no unresolved blocker or major findings.
- `pass_with_findings`: only minor/note findings remain, or accountable owners explicitly accept documented residual risk.
- `rework_required`: any unresolved blocker, or major findings without an accepted disposition.
- `not_reviewable`: required artifacts or evidence are missing. List exactly what is needed.

## Learning output

After disposition, classify each useful finding as:

- Project-only context or convention.
- Candidate pattern observation.
- Evidence supporting or contradicting an existing pattern.
- Rare core-principle proposal.

Do not promote a finding during the same review that discovered it. Capture it, test it later, and preserve contrary evidence.

