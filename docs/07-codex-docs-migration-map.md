# codex_docs 拆分映射

本文件记录从 `D:\MyProjects\codex_docs` 拆到本仓库后的归属边界。

## 进入通用 Harness 规范

这些内容应抽象为语言无关规则：

| codex_docs 来源 | 新归属 |
| --- | --- |
| `AGENTS.md` 的入口、优先级、任务路由思想 | `templates/AGENTS.md`、`docs/04-file-contracts.md` |
| `docs/02-task-routing.md` | `docs/04-file-contracts.md`、后续可扩展为任务路由规范 |
| `docs/16-codex-evaluation.md` | `checklists/harness-audit-checklist.md`，后续可扩展为 benchmark 规范 |
| `docs/16-codex-evaluation.md` 的运行结果记录思想 | `docs/13-evaluation-records.md`、`templates/benchmark-record.md` |
| `docs/30-feature-verification-loop-guidelines.md` | `docs/05-verification-loop.md` |
| `docs/31-strictness-levels.md` | `docs/03-harness-maturity-levels.md` |
| `harness/*.md` 的命令契约 | `templates/harness-build.md`、`templates/harness-test.md` |
| `tasks/current-context.md`、`tasks/task-log.md` | `templates/progress.md`、`templates/session-handoff.md` |

## 进入 C# WinForms/WPF Skill

这些内容属于 C# 桌面或仪器软件专项，不应污染通用 harness 规范：

| codex_docs 来源 | 新归属 |
| --- | --- |
| `docs/05-csharp-desktop-guidelines.md` | `skills/csharp-winforms-wpf/references/solution-structure.md` |
| `docs/18-winform-wpf-ui-code-guidelines.md` | `references/designer-xaml-rules.md`、`references/winforms-mvp.md`、`references/wpf-mvvm.md` |
| `docs/19-responsive-ui-guidelines.md` | `references/ui-layout-state-charting.md` |
| `docs/20-ui-components-charting-guidelines.md` | `references/ui-layout-state-charting.md` |
| `docs/21-ui-state-guidelines.md` | `references/ui-layout-state-charting.md` |
| `docs/22-threading-performance-guidelines.md` | `references/threading-logging-release.md` |
| `docs/25-theme-design-tokens.md` | `references/theme-design-tokens.md` |
| `docs/27-csharp-project-setup-guidelines.md` | `references/solution-structure.md`、`references/project-setup-ci.md` |
| `docs/28-csharp-dependency-injection-guidelines.md` | `references/dependency-injection-startup.md` |
| `docs/29-csharp-logging-guidelines.md` | `references/threading-logging-release.md` |
| `docs/23-deployment-guidelines.md` | `references/configuration-data-release.md`、`references/threading-logging-release.md` |
| `docs/24-configuration-secrets-guidelines.md` | `references/configuration-data-release.md` |
| `docs/26-data-versioning-guidelines.md` | `references/configuration-data-release.md` |
| `checklists/device-communication-acceptance-checklist.md`、`checklists/data-processing-acceptance-checklist.md`、`checklists/workflow-control-acceptance-checklist.md` | `references/feature-validation-checklists.md` |
| `checklists/csharp-project-acceptance-checklist.md` | `references/csharp-acceptance-checklist.md` |
| `templates/csharp-solution-structure.md` | `assets/templates/csharp-solution-structure.md` |
| `templates/winforms-mvp-template.md` | `assets/templates/winforms-mvp-template.md` |
| `templates/wpf-mvvm-template.md` | `assets/templates/wpf-mvvm-template.md` |
| `templates/device-service-template.md` | `assets/templates/device-service-template.md` |
| `templates/device-protocol-template.md` | `assets/templates/device-protocol-template.md` |

## 仍建议保留在 codex_docs

`codex_docs` 可以继续作为一个实际应用模板存在，但它后续应依赖两类上游材料：

- 通用 harness spec：提供五子系统、文件契约、验证闭环和会话连续性。
- C# WinForms/WPF skill：提供桌面上位机专项工程规则。

这样 `codex_docs` 就不再同时承担“通用理论”“项目模板”“C# 专项规则”“仪器软件规范”四种职责。
