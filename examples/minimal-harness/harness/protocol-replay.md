# Protocol Replay

Use this file for project-specific protocol replay, simulator, mock device, or virtual port verification.

## Scope

- Protocol:
- Transport:
- Replay tool:
- Fixture directory:
- Hardware substitute:

## Commands

```powershell
# project-specific replay command
```

## Required Scenarios

| Scenario | Input Or Fixture | Expected Result | Evidence |
| --- | --- | --- | --- |
| normal response | | command succeeds and state updates | |
| timeout | | timeout is reported, retried, or cancelled by policy | |
| error response | | user-readable error and log are produced | |
| split frame | | parser waits for complete frame | |
| sticky frame | | parser separates frames correctly | |
| bad checksum | | frame is rejected without state corruption | |
| disconnect | | resources are released and state becomes faulted or disconnected | |
| cancellation | | later workflow steps do not run after cancel or emergency stop | |

## Replay Evidence

- Record command, fixture names, result, and relevant log path.
- Keep fixtures deterministic and small.
- Do not depend on real hardware for replay tests.
- Keep real device timing assumptions separate from replay-only evidence.
