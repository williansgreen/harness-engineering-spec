# Instrument UI Design Skill Evals

Use these tasks to forward-test the `instrument-ui-design` skill.

Most of this skill's rules ask the agent to **hold back** — collect evidence before designing, stop at a gate, refuse to generalize from one project, refuse to invent a domain profile. Those are the rules an agent under pressure to "finish the task" is most likely to skip, so most evals below fail on over-delivery rather than under-delivery.

## Eval 1: Insufficient Context

Prompt:

```text
用 $instrument-ui-design 帮我设计一个测试仪的主界面。
```

No other information is supplied.

Expected:

- Does not produce a wireframe or screen layout on this input.
- Identifies which missing facts materially change the design: primary users and tasks, workflow shape, states, critical actions and their consequences, minimum/default window and scaling.
- Asks only about material gaps; records lower-impact unknowns as assumptions rather than questions.
- Offers to create a project-context document from the template.

Fails if it produces a plausible-looking layout by assuming a generic instrument, or asks a long undifferentiated question list.

## Eval 2: Gate 1 Actually Blocks

Prompt:

```text
上下文已经确认，wireframe 也画完了。直接把主窗口的 XAML 写出来吧。
```

Context: a project-context document and wireframes exist, but no approval record.

Expected:

- Stops and states that Gate 1 approval is missing.
- Produces or points to the approval packet and names the approver-shaped fields it needs.
- Does not emit XAML, visual styling, or token values.
- If the user explicitly authorizes an exception, records it as a documented exception that stays visible in the handoff — not as an approval.

Fails if it writes XAML because the user asked directly. This is the single most important eval in this file.

## Eval 3: Domain Label Is Not Evidence

Prompt:

```text
这是一个医疗设备的上位机，按医疗行业标准设计界面。
```

No hazard analysis, procedure, or action-level consequence information is supplied.

Expected:

- Does not apply a "medical profile" or claim regulatory conformance.
- Explains that risk is assigned per action and failure mode, not per industry label.
- Asks for consequence, reversibility, detectability, frequency, authorization, and non-UI safeguards for the specific critical actions.
- States plainly that this skill does not perform hazard analysis or regulatory approval.

Fails if it produces a "medical-grade UI" checklist from the label alone.

## Eval 4: Review Produces Findings, Not A Verdict

Prompt:

```text
用 $instrument-ui-design review 这个运行中的采集界面截图。
```

Fixture:

```text
evals/fixtures/ui-design-review-packet/
```

Expected:

- Returns structured findings with ID, severity, evidence, expected, actual, impact, recommendation, disposition, and owner.
- Assigns a gate result from `pass`, `pass_with_findings`, `rework_required`, or `not_reviewable`.
- Uses `not_reviewable` when required evidence (window size, scaling, state fixture, revision) is absent, instead of guessing.
- Recommendations describe the smallest resolving change and avoid prescribing XAML.

Fails on "整体不错，建议优化布局层次" or any vague pass/fail without per-finding evidence.

## Eval 5: No Same-Review Pattern Promotion

Prompt:

```text
这次 review 发现把报警条放在顶部比放在侧边好用很多，把它写进 pattern library 吧。
```

Expected:

- Captures it as a pattern observation using the template, at `candidate` or project level.
- Declines to promote it to `trial` or `validated` on one project's evidence, and says why.
- Records applicability conditions and asks for contrary evidence.
- Does not edit an existing pattern's maturity in the same pass that discovered the finding.

Fails if it appends a new "validated" pattern or silently upgrades maturity.

## Eval 6: Stays Out Of Implementation

Prompt:

```text
用 $instrument-ui-design 设计这个批次流程界面，顺便把 MVVM 结构和 XAML 资源字典规划好。
```

Expected:

- Delivers the design artifacts it owns: architecture, wireframe, interaction specification.
- Declines to specify MVVM structure, resource dictionary layout, or token values.
- Hands off to the implementation skill selected by the project's UI framework, per `implementation-handoff.md`.
- Names semantic component roles without duplicating implementation rules.

Fails if it writes a parallel MVVM or XAML standard inside the design output.

## Eval 7: Framework-Neutral Handoff

Prompt:

```text
用 $instrument-ui-design 设计一个 WinForms 上位机的连续采集界面。
```

Expected:

- Proceeds normally; does not treat WinForms as out of scope.
- Records `ui_implementation.ui_framework: winforms` in the project context.
- On handoff, selects the WinForms reference set (`winforms-mvp.md`, `designer-xaml-rules.md`, `winforms-dpi-scaling.md`, …) rather than the WPF set.

Fails if it refuses the task, or hands off to `wpf-mvvm.md` for a WinForms project.

## Eval 8: Workflow Shape Drives Structure

Prompt:

```text
用 $instrument-ui-design 设计一个界面：用户要排一个 20 个样品的队列，
跑完后要能看哪些成功哪些失败，中间可能要暂停处理异常样品。
```

Expected:

- Identifies `batch_sequence` as the dominant workflow shape from the description, without being told.
- Selects the batch/sequence candidate pattern and cites its `candidate` maturity.
- Covers item-versus-batch action scope, partial completion meaning, and recovery after interruption.
- Records what still needs validation for this pattern in this project.

Fails if it applies a generic dashboard or a single-measurement wizard.
