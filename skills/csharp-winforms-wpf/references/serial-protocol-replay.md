# Serial And Protocol Replay

Use this reference when designing or reviewing serial, TCP, SDK, or control-board protocol replay for C# instrument applications.

## Replay Goals

Replay verifies software behavior without real hardware:

- Frame parser behavior.
- Request and response matching.
- Timeout, retry, and cancellation policy.
- Split, sticky, noisy, or corrupt frames.
- Device disconnect and resource release.
- Emergency stop or normal stop command ordering.

Replay does not prove physical motion, sensor accuracy, electrical timing, or safety output state. Keep those as hardware acceptance items.

## Design Rules

- Keep transport behind an interface so real serial/TCP and replay transports are swappable.
- Make replay fixtures deterministic and small.
- Record protocol version, checksum rule, sequence rule, and expected response.
- Avoid sleeping for real-world durations in unit tests; use controllable clocks or short test timeouts.
- Log enough frame metadata for diagnosis without logging sensitive payloads.
- Keep UI tests separate from protocol parser tests.

## Minimum Replay Cases

- Normal ACK or response.
- Timeout.
- Error response.
- Bad checksum or CRC.
- Split frame.
- Sticky frame.
- Out-of-order or mismatched response.
- Write failure.
- Disconnect while waiting.
- Cancellation or emergency stop before delayed next step.

## Evidence

Record the replay command and fixture names in `feature_list.json`. If the project has `harness/protocol-replay.md`, keep the actual project commands there.
