# codex_docs 拆分映射

本文件记录从 `D:\MyProjects\codex_docs` 拆到本仓库后的归属边界。

## 迁移状态

C# 专项规则的迁移**已执行完成**。codex_docs 的以下 13 篇 `docs/` 已改为指针，规则内容只存在于本仓库 skill：

```text
docs/05  docs/18  docs/19  docs/20  docs/21  docs/22
docs/23  docs/24  docs/25  docs/26  docs/27  docs/28  docs/29
```

迁移是**双向合并**，不是单向删除。合并中发现两库互有强弱：

- codex_docs 更强、已补入本仓库的内容包括：启动时配置校验、校准参数字段与危险操作、平台位数决策规则、厂商依赖记录项、数据留存字段、算法与报告溯源、向后兼容要求、线程与长跑验收项、日志分类/级别/目录/滚动/审计、参数控件与提示控件分工、状态展示表、空状态与错误级别、`LicenseManager` 设计时保护、第三方控件隔离、View 接口形态、事件生命周期与退订、UI 视觉迭代上限表。
- 本仓库更强、已让 codex_docs 旧版作废的内容包括：流程控制的单写者/稳定标识/资源仲裁/停止阶段/checkpoint 恢复、打包方案决策矩阵、状态模型（13 状态）、图表刷新规则。

### 已裁决的规则冲突

| 主题 | 两方主张 | 裁决 |
| --- | --- | --- |
| WinForms 缩放策略 | codex_docs：默认 `AutoScaleMode = Dpi` + `SetHighDpiMode(PerMonitorV2)`；本仓库旧版：固定工控屏用 `Font` + System/SystemAware | **采用 codex_docs 主张，本仓库已改为 `Dpi` + PerMonitorV2** |

裁决依据是实际项目经验，不是文档偏好。Designer 按属性名顺序序列化 `InitializeComponent()`，`AutoScaleDimensions` 和 `AutoScaleMode` 都排在 `Font` 之前：

```csharp
this.AutoScaleDimensions = new SizeF(7F, 17F);   // 基准，来自旧字体
this.AutoScaleMode = AutoScaleMode.Font;
this.Font = new Font("Microsoft YaHei UI", 10F); // 之后才赋值
```

`Font` 模式的缩放因子 = 当前字体尺寸 / `AutoScaleDimensions`。基准在字体被改之前就写死了，因此只要项目改过默认字体，基准就不再描述实际字体，缩放要么不生效要么按错误因子进行；继承窗体和嵌套 `UserControl` 各自带基准，问题更明显。`Dpi` 模式按设备 DPI 缩放，不依赖字体基准，没有这个失效路径。

本仓库因此同步修改了 `references/winforms-dpi-scaling.md`、`winforms-ipc-ui-acceptance.md`、`csharp-acceptance-checklist.md`、`assets/templates/winforms-mainform-layout.md`、`SKILL.md` 和 `evals/csharp-winforms-wpf-evals.md`。

### 映射表的三处修正

下方原始映射有三条在执行中被证明不准确：

| 原映射 | 实际处理 | 原因 |
| --- | --- | --- |
| `docs/31-strictness-levels.md` → `docs/03-harness-maturity-levels.md` | **不迁移，保留并加交叉引用** | 两者是不同维度：`docs/31` 是任务执行强度，`docs/03` 是仓库 harness 完备度。仅"UI 视觉迭代上限"迁入 `references/designer-xaml-rules.md` |
| `docs/02-task-routing.md` → 本仓库 | **不迁移，保留并加交叉引用** | 它是 codex_docs 模板的内部导航表，指向自身 `prompts/` 和 `docs/`。通用路由原则在 `docs/09-task-routing.md`，且覆盖面更广 |
| `checklists/*` 与 `templates/*` → skill | **不迁移，保留并加交叉引用** | checklists 是带勾选框的验收工具（88-111 项/篇），templates 是可复制的代码骨架；二者是工作用具与资产，与 skill 中供 agent 阅读的散文式规则性质不同 |

`docs/16-codex-evaluation.md` 部分迁移：记录格式归 `docs/13-evaluation-records.md`，任务定义归 `evals/`，6 个模板自身的评估用例保留在 codex_docs。

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
| 固定 IPC、高 DPI、窗口验收经验 | `references/winforms-dpi-scaling.md`、`references/winforms-ipc-ui-acceptance.md` |
| 串口 replay、设备模拟、硬件验收经验 | `references/serial-protocol-replay.md`、`references/hardware-acceptance.md` |
| C# 桌面打包部署经验 | `references/winforms-packaging-deployment.md` |
| 医疗、账号、报告、生物特征和敏感数据经验 | `references/medical-data-security.md` |
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

## 分层维护规则

当真实项目暴露新问题时：

- 如果问题是当前项目路径、命令、目标机器或 evidence，写入 harness。
- 如果问题是 C# WinForms/WPF 上位机的可复用规则，写入 skill reference。
- 如果问题适合作为回归任务，写入 evals。
