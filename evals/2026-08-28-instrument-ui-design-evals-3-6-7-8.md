# Instrument UI Design — Evals 3, 6, 7, and 8

Date: 2026-08-28

## Run environment

- Primary runner: Codex CLI `0.150.1`, model `gpt-5.6-sol`, high reasoning.
- Isolation: one fresh `--ephemeral` session and empty temporary working directory per run.
- Sandbox: read-only; no evaluated agent could change the fixture or skill.
- Baseline skill revision: repository commit `b29ced2`, with both installed copies hash-matching the repository source.
- Claude Code `2.1.250` with Opus was attempted first, but returned the account's monthly spend-limit message before producing a response. It was not scored. Codex CLI was used for all comparable runs below.

Common command shape:

```powershell
codex exec --ephemeral --skip-git-repo-check --sandbox read-only `
  --cd <fresh-empty-eval-directory> --color never '<eval-prompt>'
```

## Baseline results

| Eval | Result | Preserved response evidence | Finding |
| --- | --- | --- | --- |
| 3 — Domain Label Is Not Evidence | **fail** | The response said it would assume a single-measurement device, invented target windows, produced a patient/sample/QA/reagent main-screen wireframe, and cited medical standards. | Although it mentioned per-action risk and disclaimed regulatory approval, it still converted the `medical` label into a workflow and layout. This meets the eval's decisive failure condition. |
| 6 — Stays Out Of Implementation | **fail** | The response supplied `Views/`, `ViewModels/`, `Domain/`, `Application/`, and `Services/` trees, then a XAML resource-dictionary tree, merge order, binding/command guidance, and `DynamicResource` rules. | It created a parallel implementation standard inside the design output. |
| 7 — Framework-Neutral Handoff | **fail** | The response designed a plausible continuous-process screen and said the target was WinForms, but omitted the exact context key and all WinForms handoff references. | It did not record `ui_implementation.ui_framework: winforms` and gave no evidence that implementation would route to the WinForms rather than WPF reference set. |
| 8 — Workflow Shape Drives Structure | **pass** | The response selected `batch_sequence` and the `candidate` batch/sequence pattern; its wireframe separated item and batch actions and covered pause, retry, skip, termination, partial completion, restart recovery, and remaining validation questions. | All expected behaviors were present; it did not fall back to a generic dashboard or single-measurement wizard. |

Baseline score: **1/4**.

## Root-cause classification and smallest fixes

### Eval 3 — instruction/context boundary

The existing minimum-context list was advisory enough that the agent treated a domain label as a low-confidence assumption and continued. The fix adds a hard no-layout condition when there is no concrete task or defensible workflow shape. It also adds a domain-label response contract requiring the complete action-level evidence set and an explicit hazard-analysis/regulatory-approval disclaimer.

Changed:

- `skills/instrument-ui-design/SKILL.md`
- `skills/instrument-ui-design/references/project-context.md`

### Eval 6 — scope and lifecycle boundary

The skill said implementation belonged elsewhere, but did not prohibit implementation planning strongly enough when design and implementation appeared in the same prompt. The fix forbids folder/class/view-model/presenter/resource-dictionary/binding/command/token/control/code planning and limits pre-approval output to a non-executable routing note.

Changed:

- `skills/instrument-ui-design/SKILL.md`
- `skills/instrument-ui-design/references/implementation-handoff.md`

### Eval 7 — routing/verification contract

The framework field and implementation reference set were available in the source documents but were not mandatory output. The fix requires the exact context key whenever the framework is known and requires every such design packet to include the applicable reference filenames as routing metadata without loading those implementation references.

Changed:

- `skills/instrument-ui-design/SKILL.md`
- `skills/instrument-ui-design/references/implementation-handoff.md`

## First rerun: useful failed attempt

The first narrow fix corrected the original over-delivery but exposed two over-corrections and one incomplete contract:

- Eval 3 stopped before layout but compressed the risk questions, omitting reversibility, detectability, frequency, authorization, and non-UI safeguards from the final response: **fail**.
- Eval 6 rejected MVVM/XAML correctly but stopped before producing the candidate batch design it still owned: **fail**.
- Eval 7 recorded `ui_implementation.ui_framework: winforms`, but still omitted the WinForms reference filenames: **fail**.

This run prevented accepting a superficially improved skill. The second fix therefore:

- made all action-risk evidence fields mandatory in a domain-label-only response;
- required candidate design to proceed when a concrete workflow shape is supplied, while keeping consequential actions at `risk: unknown`;
- required an exact non-executable routing note for every known framework.

## Final rerun results

### Eval 3 — pass

The response produced no layout or medical profile. It requested the concrete workflow and, for each critical action, explicitly requested:

- consequence;
- reversibility and recovery;
- detectability before/after execution;
- frequency and time pressure;
- authorization and audit;
- hardware, firmware, and procedural safeguards.

It ended by stating that UI design cannot replace formal hazard analysis, regulatory determination, or registration approval.

### Eval 6 — pass

The response delivered the owned design material:

- `batch_sequence` candidate architecture and screen map;
- default and minimum-window wireframes;
- independent state axes and abnormal-state coverage;
- item/batch semantic action roles and state/action matrix;
- Gate 1 findings and approval record.

It explicitly refused ViewModel, Command, folder, XAML, and resource-dictionary planning. Because the prompt did not identify the concrete XAML framework, its routing note correctly remained `unresolved` instead of guessing WPF.

### Eval 7 — pass

The response proceeded with a `continuous_process` candidate design, recorded the framework, and ended with this non-executable routing note:

```text
ui_framework: winforms
implementation_skill: csharp-winforms-wpf
references/winforms-mvp.md
references/designer-xaml-rules.md
references/winforms-dpi-scaling.md
references/ui-layout-state-charting.md
references/theme-design-tokens.md
references/csharp-acceptance-checklist.md
```

It did not use `wpf-mvvm.md` or produce WinForms implementation details.

### Eval 8 — pass (baseline retained)

No skill change was needed for this behavior, so the passing baseline is the scored result and the eval was not rerun merely to inflate evidence.

Final score after fixes: **4/4**.

## Verification

- `scripts/check-spec.ps1`: passed after each fix round.
- `git diff --check`: passed; only the repository's existing CRLF normalization warning was printed.
- Repository source vs `C:\Users\28735\.codex\skills\instrument-ui-design`: all 10 files hash-match.
- Repository source vs `C:\Users\28735\.claude\skills\instrument-ui-design`: all 10 files hash-match.
- Missed issue after final rerun: none observed against these four eval rubrics.
- False positive after final rerun: none observed.
- Further update required for these four evals: none.
