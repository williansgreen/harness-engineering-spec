# 文件契约

Harness 文件不是普通说明文档，它们是 agent 的运行契约。

## AGENTS.md

职责：

- 总入口。
- 启动顺序。
- 任务路由。
- 工作边界。
- 完成标准。

不应包含：

- 大量框架细节。
- 长篇教程。
- 过期命令。
- 与项目无关的通用知识。

## feature_list.json

职责：

- 功能状态。
- 优先级。
- 风险级别。
- 是否依赖真实硬件。
- 模拟、mock 或协议回放策略。
- 验证要求。
- 验证证据。
- 依赖关系。

规则：

- 同时只能有一个 `in_progress`，除非项目明确支持并行工作。
- `passing` 必须有 evidence。
- `blocked` 必须说明 blocker 和下一步。
- evidence 优先使用结构化对象，至少包含 `type`、`result` 和 `notes`。
- evidence 应通过 `harness/update-evidence.ps1` 或同等结构化流程追加，避免粘贴长日志或手写 JSON 破坏格式。
- C# 仪器功能应记录 `hardware_required`、`simulation_strategy`、`platform_bitness` 和数据留存影响。

## feature-list.schema.json

职责：

- 约束 `feature_list.json` 的基本结构。
- 固定 feature 状态、风险级别和 evidence 结果枚举。
- 给 `check-harness.ps1`、编辑器和其他工具提供机器可读契约。

规则：

- schema 应跟随 `feature_list.json` 一起复制到项目根目录。
- 修改 feature 字段时，同步更新 schema 和 harness 检查脚本。
- 不要把项目进度写进 schema。

## progress.md

职责：

- 会话历史。
- 当前仓库状态。
- 已运行验证。
- 已知风险。
- 下一步建议。

规则：

- 只记录对未来会话有用的信息。
- 不写流水账。
- 不把未验证内容写成完成。

## session-handoff.md

职责：

- 让下一轮会话从中断点恢复。
- 明确下一步最高价值动作。
- 说明哪些文件或范围不要动。

## harness/

职责：

- 记录真实环境和命令。
- 区分构建、运行、测试、质量检查和发布。
- 说明不能执行时的替代验证。
- 提供可选工具脚本，例如 evidence 追加、Git checkpoint 或 harness 升级差异扫描。
- 对硬件、协议回放、UI、部署和敏感数据等高风险项目，提供项目级验收文件。

规则：

- 命令必须能复制执行。
- 示例命令不能冒充项目真实命令。
- 环境缺口必须记录。

## 专项 harness 文件

职责：

- `harness/hardware-test.md`: 记录真实硬件验收范围、前置条件、步骤、安全限制和证据。
- `harness/protocol-replay.md`: 记录 replay/simulator/mock 的命令、fixture 和错误场景。
- `harness/ui-acceptance.md`: 记录目标显示器、DPI、字体、必测窗体和截图证据。
- `harness/deployment-acceptance.md`: 记录安装包或部署目录在目标机器上的验收。
- `harness/security-data.md`: 记录 secrets、个人/患者/样品/生物特征/报告数据的项目策略。

规则：

- 这些文件记录项目实际路径、命令、目标机器和证据，不承载语言框架通用教程。
- 对应的语言或领域通用规则应放入 skill references。
