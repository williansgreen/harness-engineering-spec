# Device Protocol Template

Use this template when a project integrates a serial, TCP, USB, HTTP, SDK, or driver-based device.

## Device

- Device name:
- Vendor:
- SDK or protocol version:
- Required platform: AnyCPU / x86 / x64
- Driver or runtime dependency:

## Connection

- Transport:
- Endpoint or port:
- Baud rate or network settings:
- Authentication or license requirement:
- Timeout:
- Retry policy:

## Commands

| Command | Request | Response | Timeout | Notes |
| --- | --- | --- | --- | --- |
| Connect/status |  |  |  |  |
| Start |  |  |  |  |
| Stop |  |  |  |  |

## States

```text
Disconnected
Connecting
Connected
Ready
Running
Paused
Stopping
Faulted
```

## Errors

| Code or condition | Meaning | User message | Recovery |
| --- | --- | --- | --- |
| Timeout |  |  |  |
| Busy |  |  |  |
| Disconnect |  |  |  |

## Simulation

- Normal response:
- Timeout:
- Error response:
- Disconnect:
- Cancellation:

## Verification

- Unit tests:
- Simulator/mock/replay tests:
- Real-device manual checks:
- Unverified paths:

