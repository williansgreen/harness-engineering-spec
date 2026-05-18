# 最小可用 Harness

最小可用 harness 不追求文件多，而是保证 agent 不会失去上下文、跳过验证或越界。

## 必备文件

```text
AGENTS.md
feature_list.json
progress.md
session-handoff.md
clean-state-checklist.md
harness/build.md
harness/test.md
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
- 记录每个功能的验证要求和证据。

passing 状态必须有证据，例如测试命令、截图、日志、人工验证记录或替代验证说明。

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

