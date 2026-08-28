# Pattern Library

Patterns are reusable design hypotheses tied to task shape. They are not universal sketches, domain profiles, or visual themes.

## Maturity

| Status | Meaning | Allowed use |
| --- | --- | --- |
| `candidate` | Reasonable hypothesis or one-project lesson. | Use with explicit rationale and validate in the current project. |
| `trial` | Applied with recorded evidence in at least one real project. | Reuse cautiously; look for contrary findings. |
| `validated` | Repeated evidence supports it across relevant projects and constraints. | Preferred when its applicability conditions match. |
| `deprecated` | Evidence shows material failure or a better replacement exists. | Do not select except to explain legacy designs. |

The library starts with candidates. Do not relabel them as validated merely because they appear in this file.

## Selection method

1. Identify the user's current task and dominant workflow shape.
2. Identify the decisions and states that must remain visible.
3. Select the smallest pattern that supports that task.
4. Apply risk modifiers per action.
5. Test at minimum/default windows and across normal, empty, busy, alarm, fault, and recovery states.
6. Record why rejected alternatives were weaker.

## Seed candidates

### Guided single-measurement flow — `candidate`

Use when users move through setup, readiness, one acquisition, result assessment, and save/export.

Likely structure:

- Step/status header with run identity.
- Central content for the current step.
- Contextual parameters and readiness checks.
- Clear next valid action and visible blockers.
- Result state with repeat, save, export, or close choices.

Validate whether expert users need a compact bypass or reusable method presets. Do not force a wizard when frequent users need rapid iteration.

### Continuous-process operations view — `candidate`

Use when persistent process state, trends, alarms, and intervention dominate.

Likely structure:

- Persistent global and process status.
- Primary process visualization or trend workspace.
- Key values and interventions adjacent to their effect.
- Alarm/event strip with drill-down.
- Diagnostics progressively disclosed.

Validate alarm load, intervention frequency, multi-monitor use, and which state must survive navigation.

### Batch and sequence control — `candidate`

Use when users prepare a queue, execute multiple items, handle exceptions, and assess partial completion.

Likely structure:

- Queue or sequence table with item and batch status.
- Current item detail and overall progress.
- Exception handling that preserves completed work.
- Pause/stop/retry/resume semantics at both item and batch scope.

Validate scheduling rules, edit cutoffs, partial-result meaning, and recovery after interruption.

### Exploratory live-tuning workspace — `candidate`

Use when the user repeatedly adjusts parameters and immediately interprets visual feedback.

Likely structure:

- Visualization receives primary space.
- Parameter inspector remains visible and grouped by effect.
- Current versus committed values are distinguishable.
- Reset, compare, snapshot, and history/undo are available when feasible.

Validate latency, data freshness, safe parameter bounds, expert shortcuts, and whether changes affect equipment or only visualization.

## Risk modifiers

Risk changes a pattern; it does not create a device profile. Candidate modifiers include:

- Stronger valid-state enablement and visible preconditions.
- Consequence preview or staged commitment.
- Spatial separation from routine actions.
- Explicit target/scope, especially for batch versus item actions.
- Undo, rollback, safe-stop, or recovery visibility.
- Authorization, re-authentication, reason capture, or audit linkage.
- Clear interlock and safeguard status.

Choose modifiers from project evidence. Do not mechanically map every `R2` or `R3` action to the same dialog.

## Pattern evolution

Use `assets/pattern-observation.template.md` for each proposed change.

```text
finding -> project disposition -> candidate observation -> trial -> validated or rejected
```

Promotion requires applicability conditions, contrary evidence, and a measurable acceptance check. Merge overlapping patterns instead of accumulating near-duplicates. Keep device terminology in Project Context unless it consistently changes layout or interaction.

### Where observations live

**Do not write observations into an installed copy of this skill.** A skill installed
under `~/.claude/skills/`, `$CODEX_HOME/skills/`, or an equivalent location is a
read-only copy. The next install overwrites it, the change is invisible to every other
machine, and copies drift apart silently. If you are reading this file from an install
path, you cannot durably record anything here.

Write instead to one of:

| Situation | Destination |
| --- | --- |
| Working in a project repository | that project's `docs/ui-design/pattern-observations.md` |
| Working in this skill's source repository | `skills/instrument-ui-design/`, through a normal commit |
| Neither is reachable | output the observation in full and say it must be filed in the source repository; do not silently edit a local copy |

An observation without a destination is lost work. Route it by scope:

| Scope | Destination | Who decides |
| --- | --- | --- |
| One project, one workflow | that project's `docs/ui-design/pattern-observations.md` | project design owner |
| Proposed change to a pattern here | a pattern observation appended to this skill's repository, referencing the projects it came from | skill maintainer |
| Contradicts an existing pattern | recorded against that pattern before its maturity is changed | skill maintainer |
| Proposed core principle | `core-principles.md` admission rule applies; expect rejection without cross-project evidence | skill maintainer |

Rules for moving up a level:

- A project-level observation stays project-level until a **second independent project** produces consistent evidence. One project can create a `candidate`; it cannot create a `trial`.
- Promotion to `trial` requires a recorded acceptance check that a later reviewer could re-run.
- Promotion to `validated` requires evidence from projects that differ in workflow shape, risk profile, or operating conditions — not three runs of the same product line.
- Contrary evidence is never deleted when a pattern is promoted. It becomes an applicability condition.
- Demotion follows the same path in reverse and needs no extra ceremony; a pattern that failed in practice should be marked `deprecated` promptly.

When this skill's behaviour itself is being evaluated rather than a product UI, record the run in the project's `evals/benchmark-record.md` instead, following `docs/13-evaluation-records.md`. Design findings and skill-performance findings are different kinds of evidence and should not share a log.

