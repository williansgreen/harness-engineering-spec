# Instrument Devices And Validation

Use this reference for scientific, industrial, medical, or instrument-control desktop software.

## Device Boundary

Create an abstraction before integrating a real SDK:

```text
Application -> IDeviceService
Devices -> VendorDeviceService
Devices -> SimulatedDeviceService
```

Typical shape:

```csharp
public interface IDeviceConnection
{
    bool IsConnected { get; }
    Task ConnectAsync(CancellationToken cancellationToken);
    Task DisconnectAsync(CancellationToken cancellationToken);
}

public interface IMeasurementDevice
{
    Task ConfigureAsync(MeasurementSettings settings, CancellationToken cancellationToken);
    IAsyncEnumerable<MeasurementPoint> StartMeasurementAsync(CancellationToken cancellationToken);
    Task StopAsync(CancellationToken cancellationToken);
}
```

Device services should handle:

- Connect and disconnect.
- Status query.
- Connection state events.
- Command encoding and response parsing.
- Timeout.
- Cancellation.
- Retry policy.
- Error code mapping.
- Communication logging.
- Resource release.

Keep these four failure kinds distinguishable rather than collapsing them into one exception type:

- User cancellation.
- Device error.
- Protocol error.
- Data format error.

## Simulation

Every formal device integration should have one of:

- Simulated device implementation.
- Mock server.
- Protocol replay.
- Fixed data samples.

Simulation should cover:

- Normal response.
- Timeout.
- Device busy.
- Error response.
- Disconnect.
- User cancellation.

## Validation By Feature Type

Data processing:

- Fixed input/output samples.
- Empty, single-point, missing, and outlier data.
- Unit conversion and numerical tolerance.

Device communication:

- Encode/decode.
- Timeout.
- Retry.
- Disconnect.
- Cancellation.
- Logging.

Workflow/state machine:

- Legal and illegal transitions.
- Start, pause, resume, stop, cancel.
- Repeated clicks.
- Device failure and recovery.

Data saving:

- Save and reload.
- Schema/software version.
- Damaged or old files.
- Permission or missing-path failures.

## Completion

If real hardware is unavailable, do not skip verification. Record substitute verification and list the real-device checks still required.

