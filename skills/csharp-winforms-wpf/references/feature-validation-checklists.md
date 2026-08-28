# Feature Validation Checklists

Use this reference when implementing or reviewing device communication, data processing, workflow control, data saving, or other high-risk instrument features.

## Device Communication

Check:

- Communication type, endpoint, protocol version, SDK version, and platform bitness are explicit.
- Command and response formats are documented.
- Connect, disconnect, status query, command send, and response parsing are covered.
- Timeout, retry, cancellation, and resource release policies are explicit.
- Error codes become user-readable errors and logs.
- Serial half frames, sticky frames, bad checksums, network disconnects, refused connections, and reset connections are handled when relevant.
- Repeated connect/disconnect does not leak resources.
- Simulated, mock, or replay coverage exists when real devices are unavailable.

Minimum substitute coverage:

- Normal response.
- Timeout.
- Error response.
- Disconnect.
- Cancellation.

## Data Processing

Check:

- Input and output formats, units, and field meanings are explicit.
- Golden samples exist with expected output or an explicit error band.
- Fixed input samples and expected outputs exist.
- Numerical tolerance, rounding, and significant digits are explicit.
- Empty, single-point, missing-value, `NaN`, infinity, outlier, and invalid-range cases are covered when relevant.
- Algorithm name, version, parameters, input source, and processing time are recorded when output is retained.
- Old results are not silently overwritten after algorithm changes.
- Large data paths run outside the UI thread and expose progress or cancellation when needed.
- Large-input performance and algorithmic complexity risk are checked, not assumed.

## Workflow Control

Check:

- Device state and experiment/workflow state are separate.
- Legal and illegal transitions are defined.
- Start, pause, resume, stop, cancel, complete, and fault paths are covered when relevant.
- Repeated clicks do not start duplicate workflows.
- Device disconnect, timeout, command failure, save failure, and user cancel produce explicit states.
- Stop, cancel, fault, and application exit release background tasks, timers, files, and device handles.
- State changes are logged.
- One explicit transition authority owns workflow stage and plan writes.
- Runtime events include stable batch/item/job/step identifiers; slot, channel, or display name is not used as durable identity.
- Current UI state comes from one coherent snapshot; a bounded event list is used only as a timeline.
- Shared physical resources are checked and reserved atomically; indivisible command macros cannot be interleaved.
- Runtime append or plan changes occur at a safe point and preserve in-flight identity.
- Command acknowledgement is distinguished from confirmed physical state and observation freshness.
- Stop has bounded phases and does not publish a safe terminal state before execution tracks and dangerous outputs reach the required condition.
- Persisted execution checkpoint and measurement data are separate; restart reconciles checkpoint with physical device state before resume.
- Irreversible steps have an explicit resume policy and are not automatically repeated when completion is uncertain.

## Data Saving And Export

Check:

- Saved data includes raw data when required by the domain.
- Saved data includes metadata, schema version, software version, algorithm version, and report template version when long-lived.
- Save and reload are tested.
- Damaged, missing, old, and permission-denied files are handled.
- Missing paths, insufficient permissions, and low disk space produce explicit errors.
- A failed save does not corrupt data that was already stored.
- Exports do not block the UI thread for large data.

## Logging And Exceptions

Check:

- Key events are logged.
- Failure paths are logged, not only happy paths.
- User-facing messages are understandable without reading the log.
- Logs do not leak keys, passwords, tokens, or sensitive records.
- Long-running sessions do not grow logs without bound.

## Completion Evidence

Do not mark high-risk C# features complete unless the response or project records include:

- Build result.
- Relevant automated tests or substitute checks.
- Manual or real-device checks still pending.
- Known unverified paths.
- Remaining release or safety blockers.
