# Configuration, Data, And Release

Use this reference for configuration files, secrets, experiment data, schema versions, and deployment.

## Configuration Types

Separate:

- Application defaults.
- Project config.
- User preferences.
- Device connection config.
- Calibration parameters.
- Experiment templates.
- Runtime state.
- Secrets and sensitive config.

Do not mix everything into one file.

## Storage

Typical locations:

- Defaults: app distribution.
- User preferences: user AppData.
- Device config: project config or ProgramData.
- Calibration: controlled directory with version and audit.
- Experiment data: user-selected data root.
- Runtime temp: temp or state directory.

Do not save experiment data into the installation directory by default.

## Git Rules

Commit:

- Templates.
- Non-sensitive defaults.
- Example config.
- Schemas.

Do not commit:

- Real secrets.
- Real database passwords.
- Patient/customer/sample sensitive data.
- Real access tokens.
- Private server addresses unless the project allows it.

## Versioned Data

Long-lived experiment data should include:

```json
{
  "schemaVersion": "1.0.0",
  "softwareVersion": "0.1.0",
  "algorithmVersion": "0.1.0",
  "reportTemplateVersion": "0.1.0"
}
```

Version when changing:

- Required fields.
- Units.
- Field meaning.
- Algorithm output structure.
- Report template fields.

Do not silently overwrite old algorithm results after algorithm changes.

## Migration

Migration flow:

1. Read old data.
2. Validate integrity.
3. Back up old data.
4. Migrate.
5. Write new version.
6. Record migration log.

Migration failure must not damage original data.

## Release

Before release:

- Build Release.
- Run automated tests.
- Verify simulator or real device main flow.
- Confirm x86/x64 target.
- List vendor DLLs, drivers, SDK versions, and licenses.
- Confirm config, log, and data directories.
- Confirm offline install requirements.
- Record manual checks and blockers.

