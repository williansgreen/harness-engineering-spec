# C# Solution Structure Template

```text
<Product>.sln
  src/
    <Product>.UI.Wpf/ or <Product>.UI.WinForms/
    <Product>.Application/
    <Product>.Domain/
    <Product>.Devices/
    <Product>.Infrastructure/
  tests/
    <Product>.Domain.Tests/
    <Product>.Application.Tests/
    <Product>.Devices.Tests/
```

## Rules

- UI references Application.
- Application references Domain and device abstractions.
- Devices wraps real and simulated implementations.
- Infrastructure contains persistence, config, logging, and OS integration.
- Tests cover domain, application workflows, and device behavior.

