# Forward Testing

Forward testing checks whether a skill works from realistic user prompts, not whether it looks complete.

## Rules

- Pass the skill and raw task artifact.
- Do not pass expected answers.
- Do not explain the suspected failure to the evaluator.
- Record outputs and gaps.
- Update the skill only after reviewing failures.

## C# Skill Test Set

Use:

```text
evals/csharp-winforms-wpf-evals.md
evals/fixtures/winforms-designer-unsafe/
```

## Suggested Prompt

```text
Use $csharp-winforms-wpf at D:\MyProjects\harness-engineering-spec\skills\csharp-winforms-wpf to review the WinForms files in D:\MyProjects\harness-engineering-spec\evals\fixtures\winforms-designer-unsafe.
```

Expected behavior:

- Findings first.
- Identify Designer safety problems.
- Identify MVP boundary violations.
- Recommend small corrections.
- Avoid rewriting unrelated application architecture.

## Recording Results

For each forward test, record:

- Date.
- Prompt.
- Artifact path.
- Result summary.
- Missed issue.
- False positive.
- Skill/reference update needed.

Use `templates/benchmark-record.md` or an equivalent project record. Keep task definitions in `evals/`, and keep dated run results separate.
