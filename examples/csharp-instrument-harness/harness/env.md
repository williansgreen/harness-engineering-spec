# Environment

## System

- Development OS: Windows.
- Target OS: Windows.
- Requires administrator privileges: No for development; driver install may require it.

## Runtime

- Language/runtime: C# .NET desktop.
- SDK version: project-selected supported .NET SDK.
- Package manager: NuGet.
- Virtual environment: Not applicable.

## Dependencies

- UI framework: WPF or WinForms, choose one.
- Logging: Microsoft.Extensions.Logging or Serilog.
- Test framework: xUnit, NUnit, or MSTest.
- Device SDK or driver: planned, not integrated yet.

## External Devices Or Services

- Name: planned instrument device.
- Connection: serial, TCP, USB, or vendor SDK, to be decided.
- Simulation or mock strategy: `SimulatedDeviceService` required before real-only integration.

