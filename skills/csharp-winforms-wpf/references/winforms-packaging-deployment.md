# WinForms/WPF Packaging And Deployment

Use this reference when packaging, publishing, installing, or reviewing release readiness for C# desktop applications.

## Packaging Choice

Pick the packaging path from project constraints:

- Simple internal copy deployment: acceptable for controlled lab or IPC machines when dependencies are documented.
- Inno Setup or WiX: useful for formal installers, shortcuts, install directory, uninstall, and bundled prerequisites.
- ClickOnce: useful for simple managed desktop deployment when its update model fits the environment.
- MSIX: useful only when the target OS, permissions, drivers, and file-system assumptions fit MSIX constraints.

Do not select an installer format before checking target machines, offline install needs, drivers, native DLLs, and update policy.

## Required Release Inputs

- Target framework and runtime requirement.
- Platform target: x86, x64, or AnyCPU.
- Vendor SDK DLLs, native dependencies, drivers, and licenses.
- Config templates and default settings.
- Model files, report templates, images, fonts, and other content assets.
- App config, binding redirects, DPI policy, and startup behavior.
- Log, data, cache, model, and report directories.
- Upgrade, rollback, and uninstall expectations.

## C# Desktop Checks

- Build Release configuration, not only Debug.
- Confirm copied or published output starts on a clean target machine.
- Confirm native DLLs load from the deployed location.
- Confirm app config is beside the executable when required by .NET Framework.
- Confirm `CopyToOutputDirectory` or packaging rules include required assets.
- Confirm model and large binary assets are versioned or fetched through the documented mechanism.
- Confirm no real secrets, patient data, sample data, or local machine paths are embedded in the package.

## Evidence

Record in project `harness/release.md` and `harness/deployment-acceptance.md`:

- Release command.
- Package or installer path.
- Checksums.
- Target machine tested.
- Startup and main workflow evidence.
- Known blockers.
