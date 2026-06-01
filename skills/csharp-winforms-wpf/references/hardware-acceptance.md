# Hardware Acceptance

Use this reference when C# desktop features depend on real devices, lab instruments, IPC machines, cameras, printers, locks, pumps, valves, lights, sensors, or vendor SDKs.

## Principle

Software build, unit tests, render probes, and replay tests are not enough for hardware-dependent completion. They can reduce risk, but real hardware or a documented substitute must provide final evidence.

## Hardware Acceptance Scope

Record:

- Device model, firmware, SDK, and driver versions.
- Host machine and OS.
- Platform target and process bitness.
- Connection type and port.
- Required operator role.
- Safety limits and stop procedure.
- Physical expected result.

## Required Paths

For touched behavior, verify:

- Startup or connection.
- Happy path.
- Timeout or no response.
- Disconnect.
- Stop or cancellation.
- Fault recovery.
- Application exit resource release.
- Emergency stop or safe-output path when applicable.

## Safety Rules

- Do not mark high-risk hardware features passing with build-only evidence.
- Do not run hazardous actions without documented operator approval.
- Keep manual hardware checks short, repeatable, and tied to a build or package.
- Record unverified physical behavior as a blocker.

## Project Harness

Put the actual commands, procedure, and evidence paths in `harness/hardware-test.md`.
