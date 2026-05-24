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

规则：

- 命令必须能复制执行。
- 示例命令不能冒充项目真实命令。
- 环境缺口必须记录。
