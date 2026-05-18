# Threading, Logging, And Release

Use this reference for long-running operations, real-time UI, diagnostics, and release readiness.

## Threading

Rules:

- Do not block the UI thread with device reads, file exports, network calls, or large algorithms.
- Use async workflows or background workers with cancellation.
- Marshal UI updates back to the UI thread.
- Rate-limit high-frequency chart or table updates.
- Release device handles on stop, cancel, error, and application exit.

## Logging

Log:

- App startup and shutdown.
- Device connect/disconnect.
- Commands and error codes where safe.
- Workflow start, pause, resume, stop, cancel.
- Data save/export results.
- Unexpected exceptions.

Do not log:

- Passwords.
- Access tokens.
- Private keys.
- Sensitive patient/customer/sample information unless the project explicitly allows it.

## Release Readiness

Before release or handoff:

- Build Release configuration.
- Run tests.
- Verify startup without development-only paths.
- Confirm config, log, and data directories.
- Verify simulated or real-device main path.
- Record known manual checks and blockers.

