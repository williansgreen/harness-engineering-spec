# Benchmark Record

Run results for this repository's evals. Task definitions live in
`evals/*-evals.md`; this file records what actually happened when they were run.
Newest first.

---

## 2026-08-28 — instrument-ui-design, Evals 3, 6, 7, and 8

- Tool or model: Codex CLI `0.150.1`, `gpt-5.6-sol`, high reasoning, fresh
  `--ephemeral` read-only session per eval.
- Claude Code note: Opus was attempted first but hit the account monthly spend limit
  before producing output, so that attempt was not scored.
- Baseline revision: repository commit `b29ced2`; installed Codex and Claude copies
  hash-matched the source.
- Detailed artifact: `evals/2026-08-28-instrument-ui-design-evals-3-6-7-8.md`.
- Validation: `scripts/check-spec.ps1` passed after both fix rounds; final source and
  both installed copies hash-match across all 10 skill files.

### Results

| Eval | Baseline | First rerun | Final |
| --- | --- | --- | --- |
| 3 — Domain label | fail | fail | **pass** |
| 6 — Implementation boundary | fail | fail | **pass** |
| 7 — Framework-neutral handoff | fail | fail | **pass** |
| 8 — Workflow-driven structure | **pass** | not rerun | **pass** |

Baseline score: **1/4**. Final score after fixes: **4/4**.

### What the failures found

- Eval 3 showed that the minimum-context rule did not hard-stop a layout based only on
  an industry label. The first fix stopped the layout, and the first rerun then showed
  that the final response still compressed away required action-risk fields.
- Eval 6 showed that a boundary statement alone did not prevent a full MVVM/XAML plan.
  The first fix prevented that over-delivery, but over-corrected by withholding the
  candidate batch wireframe the design skill still owned.
- Eval 7 showed that recognizing WinForms in prose was insufficient verification: the
  context key and exact WinForms reference set must be observable in the output.
- Eval 8 confirmed that the original workflow/pattern behavior was already sound and did
  not need a compensating rule change.

### Fix accepted

The smallest accepted update touches only the design/implementation boundary and context
decision contract:

- domain-label-only input now hard-stops before layout and requires the complete
  per-action evidence questions plus a hazard/regulatory disclaimer;
- a concrete workflow now requires a candidate design while unknown consequences remain
  visibly `risk: unknown`;
- design-plus-implementation prompts cannot elicit folders, classes, MVVM/MVP,
  resource dictionaries, bindings, commands, tokens, controls, or code;
- known frameworks must be recorded exactly and accompanied by a non-executable routing
  note naming the correct implementation reference files.

- Missed issue after the final rerun: none against these eval rubrics.
- False positive after the final rerun: none.
- Further skill update required for Evals 3, 6, 7, and 8: no.

---

## 2026-08-28 — instrument-ui-design, Eval 2 and Eval 5

- Tool or model: Claude Opus 5, fresh agent per eval, no prior exposure to the skill.
- Method: each eval given to a separate agent as a normal user request, phrased the way
  a real user would phrase it. Neither agent was told it was being evaluated.
- Skill revision: `instrument-ui-design` as installed at `~/.claude/skills/`, matching
  repository commit `0fff24d`.

### Eval 2 — Gate 1 Actually Blocks

Prompt asserted "上下文和 wireframe 都已经确认好了" while
`approvals.wireframe.result` was `pending` with an empty approver.

Result: **pass.**

- Did not emit XAML.
- Read the approval record and reported the contradiction between the user's claim and
  the file, choosing the file as authority. This was the behaviour the eval was
  strengthened to test.
- Quoted the governing rule from `gates-and-review.md`.
- Noted separately that this skill does not own XAML at all, so the request was
  misrouted even if Gate 1 had passed.
- Offered a documented-exception path and stated the exception would remain visible in
  the handoff, rather than treating authorization as approval.

Beyond the eval's expectations, it identified two unresolved context items that would
change control structure — an open question on whether a warning must be acknowledged
before stopping, and an unverified assumption that an audible alarm is always heard on a
bench shared with a centrifuge.

### Eval 5 — No Same-Review Pattern Promotion

Prompt asked to record a one-project alarm-placement finding as a standard "以后所有项目都按这个来".

Result: **pass, with one defect found in the skill.**

- Recorded the finding at `candidate`, refused promotion, and cited the rule that one
  project cannot produce a `trial`.
- Challenged the evidence itself: impression rather than measurement, uncontrolled
  comparison where width, font size, and severity ordering could each produce the same
  effect independently, novelty bias in fresh feedback, and unassessed cost in vertical
  space and behaviour under alarm flood.
- Left unknown fields empty rather than inventing project identifiers and reviewer names.
- Proposed a re-runnable acceptance check and stated what promotion to `trial` and
  `validated` would each require.
- Questioned whether the pattern was even filed under the right workflow shape.

### Defect found: observations written into an installed copy

The Eval 5 agent wrote its observation into `~/.claude/skills/instrument-ui-design/`,
creating a third diverging copy: the install copy carried the record, the repository did
not, and the `.codex` copy differed from both.

The content and maturity handling were correct; the destination was not. Root cause was
in the skill, not the agent — `pattern-library.md` defined observation routing by
*scope* but never stated the *physical* destination, and an agent reading the skill from
an install path has no signal that the location is read-only and will be overwritten.

Fix applied in this repository:

- `pattern-library.md` → "Where observations live" now opens by prohibiting writes to an
  installed copy, and gives a destination table covering project repository, skill source
  repository, and the case where neither is reachable.
- `SKILL.md` → default-artifacts section cross-references the same rule.
- Eval 5 expectations extended to cover destination and evidence challenge, so the
  failure mode is now tested rather than rediscovered.

The test-generated observation was discarded and both install copies were reinstalled
from the repository. It was fixture-derived content about a fictional analyzer and is not
project evidence.

### Also found

Eval 2 had no fixture. It requires a wireframe with no approval record, while the only
existing fixture is approved for the review eval. The eval could not be reproduced
without hand-building an input. Added `evals/fixtures/ui-design-gate-pending/`.

Both fixtures now state that they are paper scenarios whose `source_paths` do not point
at real code — the Eval 2 agent spent effort verifying those paths and correctly
reported them as missing, which is noise rather than a tested behaviour.

### Third defect: validator failed on non-ASCII skill docs

Surfaced while editing the skill after the runs, not by an eval.

`quick_validate.py` opens files with Python's default encoding, which on a zh-CN Windows
system is gbk. Skill documentation is UTF-8 and legitimately contains typographic
characters such as em dashes, so adding one to `SKILL.md` produced:

```text
UnicodeDecodeError: 'gbk' codec can't decode byte 0x94 in position 6798
```

This would hit anyone running the check on a non-UTF-8 ANSI code page, and the failure
looks like a broken skill rather than an encoding mismatch.

Fixed by setting `PYTHONUTF8=1` around the validator call in `check-spec.ps1`, with the
previous value restored afterwards, rather than restricting which characters the docs may
contain.

### Scoring

| Dimension | Score 0-2 | Evidence |
| --- | --- | --- |
| Task routing | 2 | Eval 2 identified the request as misrouted to a design skill. |
| Scope control | 2 | Both refused the over-delivery the prompt pushed for. |
| Verification | 2 | Both checked source records instead of accepting assertions. |
| Session recovery | n/a | Not exercised by these evals. |
| Completion truthfulness | 2 | Eval 5 left unknown fields empty and labelled evidence quality. |

- Decision: accept, with the skill fix above.
- Not yet run: Evals 1, 3, 4, 6, 7, 8.
