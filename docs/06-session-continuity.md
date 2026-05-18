# 会话连续性

长任务失败常见原因不是模型不会写代码，而是新会话不知道上轮真实状态。

## 启动流程

新会话开始时应读取：

1. `AGENTS.md`
2. `feature_list.json`
3. `progress.md`
4. `session-handoff.md`
5. 当前任务相关 docs、harness 和 checklists

然后执行或检查标准启动命令，例如 `init.ps1`。

## 收尾流程

每轮结束前应更新：

- `feature_list.json`
- `progress.md`
- `session-handoff.md`
- 必要时更新 `harness/` 命令和决策记录

并运行 `clean-state-checklist.md`。

## 好的交接记录

好的交接记录应短、准、可执行：

- 本轮目标。
- 已完成内容。
- 已验证证据。
- 未验证路径。
- 下一步。
- 不要改动的范围。

不要把聊天历史原样粘贴进交接文件。

