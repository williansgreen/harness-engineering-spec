# Deployment Acceptance

Use this file to verify that an installed or copied deployment works on the target machine, not only on the developer machine.

## Deployment Target

- Target machine:
- OS version:
- CPU architecture:
- Required runtimes:
- Offline install requirements:
- Operator account:

## Artifacts

- Build or package:
- Installer:
- Checksums:
- Release notes:
- Config template:

## Acceptance Checklist

- [ ] Application starts from the deployed location.
- [ ] No development-only absolute paths are required.
- [ ] Required models, assets, reports, templates, and native DLLs are present.
- [ ] Required drivers, SDK runtimes, and VC++ runtimes are installed or packaged.
- [ ] Config directory is writable.
- [ ] Log directory is writable.
- [ ] Data directory is writable and not under the install directory unless approved.
- [ ] Device detection works or a blocker is recorded.
- [ ] Main workflow runs with simulator, replay, or real hardware.
- [ ] Uninstall or rollback path is documented.

## Evidence

- Install log:
- Startup screenshot:
- Runtime log:
- Device or simulator evidence:
- Blockers:
