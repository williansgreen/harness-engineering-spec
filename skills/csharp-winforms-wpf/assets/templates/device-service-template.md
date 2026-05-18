# Device Service Template

```csharp
public interface IDeviceService : IAsyncDisposable
{
    Task ConnectAsync(CancellationToken cancellationToken);
    Task DisconnectAsync(CancellationToken cancellationToken);
    Task<DeviceStatus> GetStatusAsync(CancellationToken cancellationToken);
    Task StartAsync(DeviceCommand command, CancellationToken cancellationToken);
    Task StopAsync(CancellationToken cancellationToken);
}
```

Implementations:

- `VendorDeviceService`: wraps the real SDK or protocol.
- `SimulatedDeviceService`: deterministic simulation for tests and UI development.

Tests should cover normal response, timeout, error response, disconnect, and cancellation.

