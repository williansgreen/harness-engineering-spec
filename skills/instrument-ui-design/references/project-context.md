# Project Context

Project differences are data, not rewritten prompts. Use `assets/project-context.template.yaml` as the starting point and keep evidence beside each material claim.

## Minimum context before wireframing

The context is sufficient for Gate 1 only when it identifies:

- Product scope and the workflow being designed.
- Primary users and their highest-frequency or highest-consequence tasks.
- Workflow shape and stages.
- Device, workflow, data, connection, alarm, and persistence states that affect the UI.
- Critical actions and plausible consequences.
- Minimum/default window, scaling, language, and input constraints.
- Existing design-system and UI-framework implementation sources of truth.
- Assumptions, unresolved questions, evidence owners, and confidence.

Do not invent a medical, optical, chemical, or industrial profile. Record domain nouns under terminology, parameters, data, devices, and procedures.

## Risk scale

Use this as a conversation aid, not as a substitute for formal hazard analysis:

| Level | Working meaning |
| --- | --- |
| `R0` | Read-only or readily reversible; no meaningful loss expected. |
| `R1` | Recoverable loss of time, a run, or low-value material; no safety consequence identified. |
| `R2` | Irreversible or costly sample, equipment, data, or operational loss is plausible. |
| `R3` | Personal, environmental, regulatory, or similarly severe harm is plausible. |

Assign risk per action and failure mode. Record uncertainty. An overall `risk_ceiling` is only a summary and must not drive every control identically.

For each critical action, capture:

- Preconditions and valid states.
- Consequence if wrong, repeated, late, or interrupted.
- Reversibility and recovery path.
- Detectability before and after commitment.
- Frequency and time pressure.
- Authorization, reason capture, and audit expectations.
- Hardware, firmware, procedural, or organizational safeguards outside the UI.

## Workflow shape

Choose the dominant shape and record hybrids explicitly:

- `single_measurement`: configure, acquire once, assess result, save/export or repeat.
- `continuous_process`: persistent process state, trends, alarms, interventions, and recovery dominate.
- `batch_sequence`: queue, scheduling, item/batch progress, exceptions, and partial completion dominate.
- `exploratory_live_tuning`: visualization and reversible parameter changes form a tight feedback loop.
- `hybrid`: name the dominant shape per task or operating mode; do not flatten unlike workflows into one page.

## Evidence discipline

Use evidence types such as operator interview, procedure, risk analysis, requirement, telemetry, support issue, screenshot, existing code, or observed task. Mark unsupported statements as assumptions. Missing material facts become open questions with an owner; they do not silently become design rules.

## Context change control

When context changes after Gate 1:

1. Record the changed fact and source.
2. Identify affected tasks, states, actions, screens, and acceptance criteria.
3. Revise the wireframe or interaction specification.
4. Re-run the affected gate; preserve the prior approval record.

