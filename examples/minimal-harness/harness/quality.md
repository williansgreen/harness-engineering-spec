# Quality

## Actual Commands

```powershell
powershell -NoProfile -Command "Get-Content .\feature_list.json -Raw | ConvertFrom-Json | Out-Null"
```

## Checks

- JSON parses.
- Harness audit passes.

