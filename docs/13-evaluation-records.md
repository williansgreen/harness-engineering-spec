# Evaluation Records

Harness evaluation should leave reusable evidence, not only a chat summary.

Use evaluation records for:

- Harness adoption dry runs.
- Forward tests for skills.
- Benchmark runs before and after changing harness rules.
- Regression checks after changing templates, scripts, or skill references.

## Record Location

Recommended project location:

```text
evals/benchmark-record.md
```

For this spec repository, shared task definitions stay in:

```text
evals/harness-evals.json
evals/csharp-winforms-wpf-evals.md
```

Actual run results should be appended to a dated record instead of editing the task definition into a result log.

## Minimum Record

Each run should include:

- Date.
- Tool or model used.
- Prompt.
- Artifact path.
- Expected references.
- Commands or checks run.
- Result summary.
- Missed issue.
- False positive.
- Harness or skill update needed.

## Pass Criteria

A harness or skill change should not be treated as improved unless the record shows at least one of:

- Better task routing.
- Better scope control.
- More complete verification evidence.
- Better session recovery.
- Fewer false passing claims.
- Fewer missed high-risk issues.

## Failure Handling

When a forward test fails:

1. Keep the failed output or summary.
2. Identify whether the failure belongs to instructions, state, verification, scope, or lifecycle.
3. Update the smallest relevant doc, template, script, or skill reference.
4. Rerun the same task and record the new result.

