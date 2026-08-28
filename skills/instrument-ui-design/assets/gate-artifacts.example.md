# Gate Artifacts — Worked Example

A filled-in reference for the structures defined in `references/gates-and-review.md`.
The scenario here is a **single-measurement** workflow, deliberately different from the
evaluation fixture, so this file can be read as a format guide without supplying answers
to a review exercise.

Copy the shape, not the content.

---

## Gate 1 — Approval record

```yaml
gate: wireframe
result: approved_with_findings
approver: "K. Ito (design lead)"
date: 2026-07-14
artifact_revision: wireframe-r2
accepted_assumptions:
  - "Operators always run one sample at a time. Interview evidence covers 3 of 5 sites; \
     the remaining 2 sites are assumed similar (E-004, confidence medium)."
open_findings:
  - "UI-WF-002 — result screen does not yet show which calibration was in effect. \
     Accepted for wireframe; must be resolved before Gate 2."
```

Notes on use:

- `approved_with_findings` is the honest result when the layout is agreed but named gaps remain. It is not a softer `approved`.
- Accepted assumptions carry their evidence id and confidence, so a later reader can tell what was known versus assumed.
- An open finding recorded here must reappear at Gate 2 with a disposition.

---

## Gate 2 — Findings

### UI-DR-004

| Field | Value |
| --- | --- |
| ID | `UI-DR-004` |
| Severity | `blocker` |
| Evidence | Screenshot 3, `save_failed` state, 1920x1080 @100%, build 1.2.0 |
| Expected | A failed save states what was affected and offers a next action (approved spec §4.3). |
| Actual | A toast reads `保存失败` for 3 seconds, then disappears. The result screen still shows the run as complete. |
| Impact | The operator can close a run believing data was written. The sample is consumed and the acquisition is not repeatable. |
| Recommendation | Keep the failure state persistent on the result screen until acknowledged, and state whether raw data survived and where retry lives. |
| Disposition | `open` |
| Owner | app team |

### UI-DR-005

| Field | Value |
| --- | --- |
| ID | `UI-DR-005` |
| Severity | `major` |
| Evidence | Screenshot 1, `ready` state, 1366x768 @150%, build 1.2.0 |
| Expected | Core task remains usable at the minimum window and 150% scaling (context → constraints). |
| Actual | The Start button is pushed below the visible area; the panel does not scroll. |
| Impact | The primary task cannot be started at a documented supported configuration. |
| Recommendation | Let the parameter panel scroll and keep the primary action docked. |
| Disposition | `fixed` |
| Owner | app team |

### UI-DR-006

| Field | Value |
| --- | --- |
| ID | `UI-DR-006` |
| Severity | `minor` |
| Evidence | Screenshot 2, `running` state |
| Expected | Units accompany values that inform a decision. |
| Actual | Elapsed time shows a bare number with no unit. |
| Impact | Brief misreading; low consequence, corrected by context. |
| Recommendation | Append the unit, or label the field. |
| Disposition | `deferred_with_owner` |
| Owner | app team, next UI pass |

### UI-DR-007

| Field | Value |
| --- | --- |
| ID | `UI-DR-007` |
| Severity | `note` |
| Evidence | Operator interview E-004 |
| Expected | — |
| Actual | Two operators re-enter the same sample id across consecutive runs. |
| Impact | Repeated typing; no data risk observed. |
| Recommendation | Consider carrying the previous id forward as an editable default. Needs evidence from more sites before it becomes a pattern. |
| Disposition | `accepted` |
| Owner | design lead |

---

## Gate 2 — Result

```yaml
gate: design_review
result: rework_required
reason: "UI-DR-004 is an unresolved blocker."
reviewed_revision: build-1.2.0
evidence_scope:
  windows: ["1920x1080 @100%", "1366x768 @150%"]
  states_covered: ["ready", "running", "save_failed"]
  states_not_covered: ["disconnected", "faulted"]
findings: [UI-DR-004, UI-DR-005, UI-DR-006, UI-DR-007]
```

`evidence_scope` matters as much as the findings. Listing the states that were **not**
covered is what separates a real review from one that appears complete. If required
evidence had been missing entirely, the correct result would be `not_reviewable` with an
explicit list of what to supply.

---

## Learning output

`UI-DR-007` is the only finding here with pattern potential. It becomes a pattern
observation at project level, not a library change:

```text
UI-DR-007 -> accepted -> candidate observation (needs 2+ independent projects) -> trial
```

`UI-DR-004` and `UI-DR-005` are project defects, not pattern evidence. Recording them as
patterns would inflate the library without improving any future design.
