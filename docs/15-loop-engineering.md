# Loop Engineering

Loop engineering 不是第六个独立子系统，也不建议单独建立 `loop-engineering-spec` 仓库。它是把 Instructions、State、Verification、Scope 和 Lifecycle 串成可持续执行闭环的方法。

单独建库会重复维护 `AGENTS.md`、skill、evidence、状态文件、harness 命令和验收规则。只有当未来的 loop 运行时、工具链和发布生命周期能够脱离 harness 独立使用时，才重新评估仓库拆分。

## 先区分四种 Loop

| Loop | 解决的问题 | 归属 |
| --- | --- | --- |
| Agent execution loop | agent 下一步做什么、何时继续、何时停止 | 本文和通用 harness |
| Verification loop | 一次改动如何用证据证明正确 | `docs/05-verification-loop.md` |
| Product runtime loop | 应用中的状态机、轮询、调度、暂停/恢复 | 领域 skill；C# 仪器软件见 `skills/csharp-winforms-wpf/references/runtime-workflow-loop-engineering.md` |
| Device feedback loop | 命令是否在物理世界生效 | 项目硬件契约 + 领域 skill + 真实硬件验收 |

不能把四者混成一个“循环”。例如：测试通过只能证明 agent verification loop 完成；串口 ACK 也不等于设备已经到达物理安全态。

## Agent Loop Contract

一个可工程化的 agent loop 必须显式包含：

1. **Outcome**：目标结果，而不只是“继续开发”一类活动描述。
2. **Constraints**：授权边界、兼容性、风险、禁止事项和写入范围。
3. **State**：当前事实、已完成项、未验证项、证据和阻塞项。
4. **Next action**：能带来新信息或可验证增量的最小动作。
5. **Observation**：命令输出、测试结果、截图、日志、diff 或人工确认。
6. **Decision**：通过、调整假设、修复、请求决策或停止。
7. **Checkpoint**：把结果写回 feature、progress、handoff 或 decision record。

推荐循环：

```text
读取目标与当前状态
  -> 选择最小高价值动作
  -> 执行动作
  -> 观察新证据
  -> 比较验收标准
  -> 更新状态与假设
  -> 决定继续、完成或升级
```

每一轮必须至少产生一种增量：新证据、已验证改动、被排除的假设、明确的新阻塞或可恢复 checkpoint。重复同一动作却没有新信息，不算进展。

## 进入条件

开始循环前应能回答：

- 目标结果和 Definition of Done 是什么？
- 当前允许修改哪些文件、系统或外部对象？
- 有哪些真实 build、test、run 或替代验证命令？
- 风险最高的未知量是什么？
- 当前工作树、外部环境和状态文件是否可信？

信息不足但可通过只读检查获得时，先检查。缺少的选择会实质改变产品、安全或数据结果时，请求用户决策，不要用循环掩盖需求不明确。

## 继续、完成与停止条件

### 继续

同时满足以下条件时继续：

- 仍有未满足的验收标准。
- 下一动作在授权和安全边界内。
- 下一动作预计会产生新信息或可验证进展。
- 当前状态足以支持该动作。

### 完成

只有同时满足以下条件才完成：

- 要求的结果已经存在。
- 相关验收标准有当前改动对应的新鲜证据。
- 高风险路径完成了相称的验证，或明确记录真实环境 blocker。
- 状态、证据和必要交接已更新。
- 没有仍属本任务范围的必做项。

### 停止或升级

出现以下任一情况时停止自动推进并说明所需输入：

- 需要新的权限、外部协调或不可逆操作授权。
- 缺少会改变产品行为或安全结论的用户选择。
- 真实硬件、部署环境或人工审批是剩余唯一证据源。
- 同一阻塞或同一失败重复出现，且没有新的可检验假设。
- 继续尝试的时间、成本或风险已超过任务价值。

不要对所有任务规定统一的“最多 N 轮”。重试上限应与动作成本、可逆性、风险和新信息量相称。一次危险外部写入可能不应自动重试；低成本的确定性测试修复可以多轮迭代。关键不是轮数，而是每一轮是否基于新证据改变了决策。

## Evidence Rules

- 证据必须能关联到当前代码、配置、环境和命令。
- 只构建通过不能证明运行时、硬件、UI 或部署行为通过。
- 旧日志、旧截图和旧测试只能作为历史背景，不能自动证明当前版本。
- 替代验证必须标明它替代了什么，以及仍缺哪一层真实验证。
- 高风险功能应记录失败注入、恢复结果和最终安全状态，而不只记录快乐路径。

## Checkpoint 与恢复

长任务的 checkpoint 应保留：

- 当前 outcome、约束和 active feature。
- 已修改文件和未提交工作树状态。
- 最近一次有效验证及产物位置。
- 被排除的假设、当前 blocker 和下一安全动作。
- 需要用户或真实环境确认的事项。

`session-handoff.md` 应保存可恢复状态，不应堆积聊天记录。恢复时先核对仓库和外部环境是否仍与 checkpoint 一致，再继续执行。

## 并行 Loop

只有任务能够独立产出、写集合不重叠、验收可以分别完成时才并行。多个 agent 或 chat 不应同时修改同一工作树中的同一文件；需要并行代码修改时使用独立 worktree，并在合并前重新验证组合结果。

## 常见反模式

- 没有 Definition of Done，只靠“继续优化”驱动无限循环。
- 每轮做大批量改动，失败后无法定位哪一步引入回归。
- 测试失败后原样重跑，没有形成新假设。
- 用状态文件中的 `passing` 代替真实证据。
- 把 mock/replay 结果写成真实硬件已验收。
- 为了保持循环运行而越过授权、安全或数据边界。
- 同时保留两个生产驱动路径，导致双写者和双重状态真相源。

## 文件映射

| Loop 元素 | 推荐文件 |
| --- | --- |
| Outcome / Constraints | `feature_list.json`、`tasks/current-context.md`、用户当前要求 |
| Project instructions | `AGENTS.md`、项目 `docs/` |
| Executable actions | `harness/build.md`、`run.md`、`test.md`、`quality.md` |
| Evidence | feature evidence、测试报告、截图、日志、benchmark record |
| Checkpoint | `progress.md`、`session-handoff.md` |
| Completion gate | Definition of Done、验收 checklist、`clean-state-checklist.md` |

## 与 Codex 官方工作方式的对齐

- `AGENTS.md` 用于分层提供项目级指令，入口文件保持路由职责。
- Skill 用于可复用、任务特定的工作流和领域知识；每个 skill 应聚焦一个清晰任务边界。
- 长任务应明确 outcome、constraints 和 verification，并保持可恢复状态。

参考：

- <https://learn.chatgpt.com/docs/agent-configuration/agents-md>
- <https://learn.chatgpt.com/docs/build-skills>
- <https://learn.chatgpt.com/docs/long-running-work>
