# C# Solution Structure Template

```text
<Product>.sln
  .editorconfig
  Directory.Build.props
  Directory.Packages.props  (when useful)
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

- For new formal projects, prefer `scripts/new-instrument-solution.ps1` and then adapt the generated structure to project constraints.
- UI references Application.
- Application references Domain and device abstractions.
- Devices wraps real and simulated implementations.
- Infrastructure contains persistence, config, logging, and OS integration.
- Tests cover domain, application workflows, and device behavior.
- Target framework and platform bitness must match project, tooling, and vendor SDK constraints.
- CI should build and test on Windows without real hardware.
