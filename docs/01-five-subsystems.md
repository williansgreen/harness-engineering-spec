# 五子系统模型

每个 coding-agent harness 都应覆盖五个子系统。

## 1. Instructions

让 agent 知道项目规则、入口文件、架构边界和工作方式。

典型文件：

- `AGENTS.md`
- `CLAUDE.md`
- `docs/architecture.md`
- `docs/product.md`
- 专项规范和 prompt

判断标准：

- 新会话知道先读什么。
- 任务类型有路由规则。
- 详细规则不塞进一个巨型入口文件。

## 2. State

让 agent 知道当前项目和功能状态，而不是依赖聊天历史。

典型文件：

- `feature_list.json`
- `progress.md`
- `session-handoff.md`
- `tasks/current-context.md`

判断标准：

- 当前唯一进行中的功能明确。
- passing 必须有验证证据。
- 未验证、阻塞和下一步都被记录。

## 3. Verification

让 agent 不能只靠“代码写完”宣布完成。

典型文件：

- `harness/build.md`
- `harness/run.md`
- `harness/test.md`
- `harness/quality.md`
- `clean-state-checklist.md`

判断标准：

- 构建、运行、测试命令明确。
- 无法真实验证时有替代验证。
- 完成说明包含运行过的命令和剩余风险。

## 4. Scope

防止 agent 一次改太多、做偏题或留下半成品。

典型机制：

- 一次只允许一个 active feature。
- 每个 feature 有 Definition of Done。
- 不允许顺手重构无关模块。
- 未授权不修改架构边界。

判断标准：

- 当前任务边界清楚。
- 做完前不会悄悄扩大范围。
- 未完成内容被记录，而不是被掩盖。

## 5. Lifecycle

管理启动、中断、交接和收尾。

典型文件：

- `init.ps1` 或 `init.sh`
- `progress.md`
- `session-handoff.md`
- `clean-state-checklist.md`

判断标准：

- 新会话有标准启动路径。
- 长任务中断后能恢复。
- 每轮结束前留下可继续状态。

