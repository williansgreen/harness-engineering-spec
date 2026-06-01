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

## 状态文件大小控制

- `session-handoff.md` 是滚动交接文件，不是聊天记录归档；下轮不再需要的旧细节应删除或覆盖。
- `progress.md` 记录当前状态和最近会话；历史会话过多时，应压缩成摘要，而不是无限追加。
- `feature_list.json` 的 evidence 记录命令、结果、日期和简短说明，不粘贴完整日志。

## 可选 Git checkpoint

默认不要求 agent 自动提交 Git。只有用户明确启用 Git checkpoint 工作流后，agent 才应在完成每个可独立验证的小功能或修复后创建本地 commit。

推荐通过项目内 helper 执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\harness\git-save-feature.ps1 -Message "<type(scope): summary>" -Paths <files...> -VerificationAlreadyRun
```

也可以把验证命令交给 helper 运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\harness\git-save-feature.ps1 -Message "fix(ui): prevent clipped controls" -Paths .\src\MainForm.cs .\src\MainForm.Designer.cs -VerifyCommand "dotnet build", "dotnet test"
```

如需同时记录 evidence：

```powershell
powershell -ExecutionPolicy Bypass -File .\harness\git-save-feature.ps1 -Message "fix(ui): prevent clipped controls" -Paths .\src\MainForm.cs .\src\MainForm.Designer.cs -VerificationAlreadyRun -EvidenceFeatureId feat-ui -EvidenceType review -RecordProgress
```

启用后，checkpoint 必须满足：

- 粒度是一个语义完整、可验证的功能或修复，不是每次编辑或每个文件。
- 提交前先检查 `git status`，区分本次任务修改和已有用户改动。
- 只暂存本次任务相关文件，避免 `git add .`。
- 运行相关构建、测试或替代验证。
- 不提交密钥、真实敏感配置、构建产物、日志或临时文件。
- 验证失败时默认不提交；只有用户明确要求 WIP commit 时才允许提交，并记录未通过项。
- 提交后在收尾说明、`progress.md` 或 `session-handoff.md` 中记录 commit hash 和验证结果。

## 好的交接记录

好的交接记录应短、准、可执行：

- 本轮目标。
- 已完成内容。
- 已验证证据。
- 未验证路径。
- 下一步。
- 不要改动的范围。

不要把聊天历史原样粘贴进交接文件。
