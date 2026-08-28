# Runtime Workflow Loop Engineering

Use this reference when a C# WinForms/WPF instrument application contains long-running experiments, cyclic acquisition, polling, schedulers, state machines, concurrent device tracks, pause/resume, safe stop, or crash recovery.

Do not introduce a workflow engine for a short, strictly sequential operation that is already clear and testable. Scale the design to physical risk, concurrency, recovery needs, and expected lifetime.

## Model The Contract

For each workflow define:

- Stable workflow, batch, job, and step identity.
- States and terminal states.
- Triggers or observations that advance the workflow.
- Guards and rejected transitions.
- Side effects and owned resources.
- Timeout and cancellation behavior.
- Stop, fault, compensation, and recovery policy.
- Evidence that proves a transition completed.

Keep device connection state, workflow state, acquisition state, persistence state, and UI display state separate. They may be correlated, but one enum should not pretend to be all of them.

## One Transition Authority

Prefer one explicit executor or transition authority as the only writer of workflow stage and plan state.

- UI handlers submit intents; they do not write runtime state directly.
- Device callbacks publish observations; they do not independently advance unrelated stages.
- Background tasks return results to the executor.
- Readers obtain one coherent immutable snapshot under the same synchronization boundary used by writers.
- Do not keep a recursive driver and a new explicit driver active at the same time.

Event-driven progression is preferred when hardware completions or operator actions already provide events. Polling is appropriate for sensor sampling, watchdogs, or time-based conditions, but each tick must be non-reentrant and must not start duplicate work.

## Stable Identity And Append

Slot number, sample name, channel, or list index are display attributes, not durable identity. Use stable identifiers such as:

```text
BatchId -> PlanItemId -> JobId -> StepExecutionId -> CommandId
```

When work can be appended during execution:

- Register it as pending first.
- Merge at an explicit safe point or mutate the plan atomically while preserving active item identity.
- Never rebuild identifiers for in-flight work.
- Completion means all plan items are terminal and no pending work remains.

## Resource Arbitration

When workflows share pumps, valves, reactors, serial buses, sample ports, files, or other exclusive resources, use one resource arbiter as the source of truth.

- Check and reserve atomically.
- Represent persistent occupancy separately from momentary command use.
- Hold a sequence lease across an indivisible macro, so another workflow cannot enter between its child commands.
- Acquire resources in a documented order.
- Do not hold a monitor lock across `await` or blocking I/O.
- Release in `finally`, but publish the next scheduling signal only after state and resource ownership are coherent.
- A cancellation request does not prove the old task has exited; safe-stop coordination must know when execution tracks are actually quiescent.

Prefer a conservative serial gate first. Relax it only after resource independence is proven by physical topology and concurrency tests.

## Commanded State Versus Physical State

The application records what it requested; device feedback establishes what the physical system actually did.

- An ACK may prove receipt, not actuator position or safe state.
- Use read-back, sensors, counters, or explicit completion frames when available.
- Track observation timestamp and freshness.
- If read-back is impossible, represent confidence such as `Confirmed`, `CommandedOnly`, or `Unknown`.
- Watchdogs must distinguish “request sent but no response” from “the application stopped sending”.
- Recovery and safety decisions must not treat stale cached values as current physical truth.

## Checkpoint And Recovery

Execution state is not measurement data. Persist them independently.

Useful execution records include:

- Prepared, Running, Completed, Failed, Cancelled, and RecoveryRequired status.
- Workflow, item, step, and command identifiers.
- Parameters needed to interpret or resume the step.
- Last confirmed device observation and timestamp.
- Resource ownership and checkpoint version.

For irreversible or non-idempotent operations, record intent before sending the command, then record acknowledgement and completion. Give each step an explicit recovery policy, for example:

```text
Continue
RestartStep
SkipIfConfirmedCompleted
ManualConfirm
AbortWorkflow
```

On restart:

1. Load the last consistent checkpoint.
2. Connect and query devices.
3. Reconcile persisted state with current physical observations.
4. Rebuild resource ownership from confirmed facts.
5. Choose the step recovery policy.
6. Require manual confirmation when an irreversible action cannot be proven.

Never resume solely because a database says a pump, valve, transfer, or exposure was running.

## Stop And Fault Lifecycle

Model stop as phases rather than one Boolean:

```text
StopRequested
DispatchBlocked
TracksCancelling
DangerousOutputsCut
OutputsReset
DataCommitted
Stopped or Faulted
```

Use one stop coordinator. Safety commands may be idempotently retried, but two independent full reset paths must not race each other. A watchdog should bound each phase and escalate to a latched fault when physical safety cannot be confirmed.

Software stop or emergency-stop commands do not replace an independent physical safety circuit when the risk assessment requires one.

## UI Projection

- Publish immutable workflow snapshots for current state.
- Use events as an audit timeline, not as the only source for reconstructing current state from a bounded list.
- Include stable identities and correlation fields in events.
- Show waiting reasons, estimated remaining time when reliable, and whether a state is confirmed or only commanded.
- Keep stop/fault latched until the defined recovery gate is satisfied.

## Observability

Log transitions and commands with correlation identifiers, old/new state, reason, duration, outcome, and device error details where safe. Rate-limit repeated polling and waiting messages without hiding the first occurrence or final outcome.

## Verification Matrix

At minimum cover relevant rows:

| Area | Normal | Boundary | Failure / Recovery |
| --- | --- | --- | --- |
| Transition | full happy path | repeated start/stop, illegal trigger | exception, timeout, cancellation |
| Scheduling | expected order | equal priority, append at boundary | no candidate, stale pending item |
| Resources | independent tracks run | simultaneous acquire | loser waits; lease releases after fault |
| Device command | request + confirmed completion | slow response, stale cache | timeout, late frame, disconnect, wrong read-back |
| Stop | orderly stop | stop during each macro phase | task ignores cancel, reset command fails |
| Recovery | clean restart | checkpoint at each step boundary | persisted/physical mismatch, corrupt checkpoint |
| UI | coherent snapshot | event truncation, repeated slot/channel | fault remains visible and actionable |

Use deterministic state-transition tests, fake time where practical, simulated devices, protocol replay, concurrency stress, failure injection, and real-hardware acceptance. Build-only evidence is insufficient for runtime loop behavior.

## Incremental Migration

For a legacy form-centered workflow:

1. Characterize current behavior with replay and scenario tests.
2. Extract stable state, identity, and device boundaries.
3. Introduce one explicit executor and snapshot API.
4. Route one coherent path through it while keeping rollback explicit.
5. Verify normal, append, stop, fault, and recovery paths.
6. Remove the old driver after cutover; do not leave two permanent state writers.

