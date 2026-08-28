# Project Setup And CI

Use this reference when creating or changing `.sln`, `.csproj`, shared build props, package versions, platform targets, or CI for C# WinForms/WPF desktop apps.

## Target Framework

New formal desktop projects should use the current supported .NET Windows desktop target, or the target explicitly required by the project. Prefer the current LTS. Check the official support policy before choosing:

- <https://learn.microsoft.com/dotnet/core/releases-and-support>
- <https://dotnet.microsoft.com/platform/support/policy/dotnet-core>

When lab machines, Visual Studio, vendor SDKs, drivers, or deployment targets cannot yet run the current LTS, staying on an older still-supported LTS is acceptable — but record the reason and the upgrade plan in project docs or a decision record.

Before selecting or changing the target framework:

- Check installed SDKs with `dotnet --list-sdks` when possible.
- Confirm Visual Studio or Build Tools support the chosen WPF/WinForms designer experience.
- Confirm vendor SDKs, drivers, P/Invoke dependencies, deployment machines, and test machines support the target.
- Do not force a template framework when the project has a documented supported target.

Typical defaults:

```text
WPF UI: netX.0-windows with <UseWPF>true</UseWPF>
WinForms UI: netX.0-windows with <UseWindowsForms>true</UseWindowsForms>
Domain/Application: netX.0 unless Windows-only APIs are required
Devices/Infrastructure: netX.0 or netX.0-windows depending on SDK requirements
```

## Platform Strategy

State one platform strategy explicitly:

```text
AnyCPU
x86
x64
```

Rules:

- x64 vendor SDKs usually require x64 projects and release output.
- x86 vendor SDKs usually require x86 projects and release output.
- With no vendor bitness constraint, prefer AnyCPU or x64.
- If SDK bitness is unknown, do not casually choose AnyCPU.
- Record the reason in project docs, release docs, or harness notes.

## Shared Build Files

Formal projects should consider:

```text
.editorconfig
Directory.Build.props
Directory.Packages.props
.github/workflows/dotnet-ci.yml
```

Recommended shared settings:

- `Nullable`
- `ImplicitUsings`
- `LangVersion`
- `AnalysisLevel`
- deterministic builds
- Release warning policy

Package rules:

- Pin package versions.
- Avoid floating `*` versions in formal projects.
- Treat package upgrades as explicit tasks.
- Run build and tests after package upgrades.

## CI

Windows desktop CI should run on Windows. For GitHub Actions that means a workflow at `.github/workflows/dotnet-ci.yml` with `runs-on: windows-latest`.

Minimum CI commands:

```powershell
dotnet restore
dotnet build --configuration Release
dotnet test --configuration Release
```

CI must not depend on real hardware. Use simulated devices, mock servers, protocol replay, or fixed samples.

## Editing Rules

When modifying project files:

- Preserve existing target frameworks unless there is a clear reason to change them.
- Keep XML readable.
- Explain new package dependencies.
- Do not add UI framework references to Domain.
- Do not add concrete vendor SDK references to Domain.
- Re-run build and relevant tests.

