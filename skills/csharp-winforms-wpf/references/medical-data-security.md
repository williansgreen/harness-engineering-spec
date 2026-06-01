# Medical And Sensitive Data Security

Use this reference for C# desktop applications that handle patient, sample, operator, biometric, report, audit, or hospital integration data.

## Treat As Sensitive

- Patient identifiers and medical records.
- Sample identifiers and test results.
- Operator accounts, roles, and audit trails.
- Face images, face embeddings, fingerprints, or other biometric templates.
- API keys, upload credentials, certificates, and private endpoints.
- Generated reports and exported archives.

## Code And Git Rules

- Do not commit real sensitive data.
- Keep synthetic fixtures small and clearly marked.
- Do not log passwords, tokens, private keys, raw biometric vectors, or full sensitive records.
- Keep secrets out of app config committed to source control.
- Do not embed production endpoints or credentials in installer scripts unless the project explicitly permits it.

## Storage Rules

- Store app defaults with the installation.
- Store user or machine config in AppData or ProgramData as appropriate.
- Store logs and reports in documented writable directories.
- Store biometric features and reports with access controls appropriate to the deployment.
- Version long-lived records so migrations are explicit.

## Review Questions

- What data is retained after workflow completion?
- Can exported reports be traced and audited?
- Are failed uploads, retry queues, and logs sensitive?
- Is deletion or re-enrollment audited?
- Does the package include only approved fixtures and assets?

Project-specific policy belongs in `harness/security-data.md`.
