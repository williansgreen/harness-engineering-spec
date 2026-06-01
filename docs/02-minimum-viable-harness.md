# 最小可用 Harness

最小可用 harness 不追求文件多，而是保证 agent 不会失去上下文、跳过验证或越界。

## 必备文件

```text
AGENTS.md
feature_list.json
feature-list.schema.json
progress.md
session-handoff.md
clean-state-checklist.md
harness/build.md
harness/test.md
harness/update-evidence.ps1
```

生产项目或正在调整 agent 规则的项目，建议额外加入：

```text
evals/benchmark-record.md
harness/hardware-test.md
harness/protocol-replay.md
harness/ui-acceptance.md
harness/deployment-acceptance.md
harness/security-data.md
```

## AGENTS.md 最小职责

- 说明项目目标。
- 说明启动顺序。
- 说明任务边界。
- 说明完成标准。
- 指向详细文档和验证命令。

不要把所有规范都塞进 `AGENTS.md`。入口文件应负责路由，细节放到 `docs/`、`harness/`、`checklists/` 或 skill references。

## feature_list.json 最小职责

- 记录功能列表。
- 标记唯一 active feature。
- 记录每个功能的风险级别、硬件需求、模拟策略、验证要求和证据。

passing 状态必须有结构化证据，例如测试命令、截图、日志、人工验证记录或替代验证说明。证据至少应说明类型、结果和备注；执行过命令时记录命令。

推荐用 `harness/update-evidence.ps1` 追加 evidence，减少手写 JSON 出错。

## feature-list.schema.json 最小职责

- 固定 `feature_list.json` 的基本字段和状态枚举。
- 让 agent 和脚本能检查 evidence、risk、hardware、simulation 等字段是否缺失。
- 作为项目内状态文件的机器可读契约，而不是另一个说明文档。

## progress.md 最小职责

- 记录仓库当前可启动状态。
- 记录最近一轮做了什么。
- 记录运行过哪些验证。
- 记录下一步最佳动作。

## session-handoff.md 最小职责

用于长任务中断或交接。它应回答：

- 当前已验证什么？
- 本轮改了什么？
- 仍损坏或未验证什么？
- 下一步先做什么？
- 哪些文件不要碰？

## clean-state-checklist.md 最小职责

每轮结束前检查：

- 标准启动路径可用。
- 标准验证路径可运行或阻塞已记录。
- 当前进度已更新。
- 功能状态没有虚假 passing。
- 下一轮能继续。

## evals/benchmark-record.md 推荐职责

- 记录 harness 或 skill 修改后的 forward-test 结果。
- 记录失败、漏报、误报和下一步修正规则。
- 区分任务定义和实际运行结果。

## 专项验收 Harness 推荐职责

- `harness/hardware-test.md`: 真实硬件、目标机器、物理安全状态和人工验收。
- `harness/protocol-replay.md`: 协议回放、模拟器、虚拟串口、错误帧和取消路径。
- `harness/ui-acceptance.md`: 目标分辨率、DPI、字体、截图和视觉验收。
- `harness/deployment-acceptance.md`: 安装后启动、依赖、目录权限和目标机验收。
- `harness/security-data.md`: secrets、患者/样品/客户数据、日志、报告和敏感 artifact 策略。
