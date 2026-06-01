# Hardware Test

Use this file for project-specific hardware verification. Keep it concrete enough that a later session can repeat the same checks.

## Scope

- Hardware under test:
- Firmware or SDK version:
- Host machine:
- Required operator role:
- Safety constraints:

## Preconditions

- Application build:
- Device connection:
- Calibration or setup:
- Sample, fixture, or load:
- Emergency stop path:

## Commands Or Procedure

```powershell
# project-specific hardware test command or manual procedure launcher
```

## Test Matrix

| Area | Scenario | Expected Result | Evidence |
| --- | --- | --- | --- |
| connection | startup device detection | selected device is identified and logged | |
| safety | stop or emergency stop | outputs reach documented safe state | |
| workflow | main happy path | physical device behavior matches software state | |
| fault | timeout or disconnect | user-visible fault and log are produced | |

## Evidence Rules

- Record build or release artifact used for the test.
- Record device identifiers only when the project allows it.
- Record screenshots, logs, serial traces, photos, or signed manual notes as artifacts.
- Do not store patient, customer, sample, or secret data unless the project explicitly permits it.
- Add concise structured evidence to `feature_list.json`.

## Blockers

- Missing hardware:
- Unsafe test condition:
- Missing operator approval:
- Missing replay or simulator substitute:
