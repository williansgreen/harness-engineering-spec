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

## Secret Handling

Prefer:

- Environment variables.
- Machine-level secure storage.
- User config directory outside source control.
- A committed `.env.example` template that documents required keys without real values.

Never:

- Hard-code secrets.
- Write secrets into logs.
- Commit real keys.

## Startup Validation

Validate configuration at application startup, before device connection or workflow start:

- The config file exists.
- The format parses.
- Required fields are present.
- Device parameters are within legal ranges.
- Target paths are writable.
- The schema version is compatible with this build.

A configuration error must produce an actionable message that names the file, the field, and the expected value. Do not fail silently and do not fall back to defaults for device or calibration parameters without telling the user.

## Calibration Parameters

Calibration records should carry:

- Calibration ID.
- Device ID.
- Calibration timestamp.
- Operator.
- Calibration data.
- Applicable range.
- Expiry or validity state.

These operations are dangerous and require an explicit permission check or user confirmation:

- Overwriting calibration parameters.
- Deleting a calibration record.
- Importing an unknown calibration file.

## What Retained Data Must Carry

A saved experiment record should be interpretable years later without the original session. Capture:

- Experiment parameters.
- Sample information.
- Raw data.
- Processed data.
- Software version.
- Device information.
- Calibration information.
- Operation timestamp.
- Operator.

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

Adding an optional field may stay a PATCH or MINOR change.

Do not silently overwrite old algorithm results after algorithm changes.

## Algorithm And Report Provenance

Retained algorithm output should record:

- Algorithm name.
- Algorithm version.
- Input data file.
- Parameters.
- Output timestamp.
- Error or quality metric.

Generated reports should record:

- Report template version.
- Producing software version.
- Generation timestamp.
- Data source.

After a template change, an old report must still be traceable to the template that produced it.

## Backward Compatibility

The software should keep the ability to:

- Open old experiments.
- Re-export old reports.
- View old raw data.
- Identify results produced by an old algorithm version.

When results cannot be recomputed under the current version, say so explicitly instead of silently recomputing or hiding the data, for example: "This experiment was produced by an older algorithm version; this build can only display the original result."

## Migration

Data migration flow:

1. Read old data.
2. Validate integrity.
3. Back up old data.
4. Migrate.
5. Write new version.
6. Record migration log.

Migration failure must not damage original data.

Configuration migration on upgrade must preserve:

- Config file version.
- Compatibility with the previous config.
- Defaults filled in for newly added fields.
- Calibration parameters.
- User preferences.
- Experiment data paths.

## Acceptance

Configuration and data version work is not done until:

- Sample data from the previous version opens.
- Data saved by the new version reloads.
- Configuration migrates.
- Algorithm version is traceable.
- Report template version is traceable.
- A failed migration leaves the original data intact.

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

Record with the build:

- Software version, as `MAJOR.MINOR.PATCH`.
- Build timestamp.
- Git commit.
- Algorithm version.
- Data format version.
