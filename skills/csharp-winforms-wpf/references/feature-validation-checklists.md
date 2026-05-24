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
- Fixed input samples and expected outputs exist.
- Numerical tolerance, rounding, and significant digits are explicit.
- Empty, single-point, missing-value, `NaN`, infinity, outlier, and invalid-range cases are covered when relevant.
- Algorithm name, version, parameters, input source, and processing time are recorded when output is retained.
- Old results are not silently overwritten after algorithm changes.
- Large data paths run outside the UI thread and expose progress or cancellation when needed.

## Workflow Control

Check:

- Device state and experiment/workflow state are separate.
- Legal and illegal transitions are defined.
- Start, pause, resume, stop, cancel, complete, and fault paths are covered when relevant.
- Repeated clicks do not start duplicate workflows.
- Device disconnect, timeout, command failure, save failure, and user cancel produce explicit states.
- Stop, cancel, fault, and application exit release background tasks, timers, files, and device handles.
- State changes are logged.

## Data Saving And Export

Check:

- Saved data includes raw data when required by the domain.
- Saved data includes metadata, schema version, software version, algorithm version, and report template version when long-lived.
- Save and reload are tested.
- Damaged, missing, old, and permission-denied files are handled.
- Exports do not block the UI thread for large data.

## Completion Evidence

Do not mark high-risk C# features complete unless the response or project records include:

- Build result.
- Relevant automated tests or substitute checks.
- Manual or real-device checks still pending.
- Known unverified paths.
- Remaining release or safety blockers.

