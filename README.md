# Harness Engineering Spec

本仓库把 harness engineering 拆成两层：

1. 通用规范：适用于 Codex、Claude Code、Cursor、Trae 等 coding agent，不绑定语言和框架。
2. 专项 skill：把领域规则做成可触发的 Codex skill，例如 C# WinForms/WPF 桌面上位机。

## 目标

Harness 的目标不是让模型“更聪明”，而是让 agent 在真实项目中可恢复、可验证、可审计、可继续。

一个合格 harness 应让新会话可以只依赖仓库内文件回答：

- 这个项目是什么？
- 当前应该做哪个功能？
- 哪些规则不能违反？
- 如何构建、运行和测试？
- 什么证据才算完成？
- 如果中断，下一轮如何继续？

## 目录

```text
docs/        通用 harness engineering 规范
templates/   可复制到项目中的最小 harness 文件
checklists/  审计和接入检查清单
scripts/     安装和自检脚本
examples/    可参考的 harness 示例
evals/       skill 和 harness 评估任务
skills/      专项 Codex skills 草案
```

## 建议阅读顺序

1. `docs/01-five-subsystems.md`
2. `docs/02-minimum-viable-harness.md`
3. `docs/04-file-contracts.md`
4. `docs/05-verification-loop.md`
5. `docs/15-loop-engineering.md`
6. `docs/14-harness-skill-boundary.md`
7. `checklists/harness-audit-checklist.md`

如果要把现有项目接入 harness，继续看：

- `docs/08-adoption-guide.md`
- `docs/09-task-routing.md`
- `docs/10-benchmarking.md`
- `docs/11-skill-installation.md`
- `docs/12-forward-testing.md`
- `docs/13-evaluation-records.md`
- `docs/14-harness-skill-boundary.md`
- `docs/15-loop-engineering.md`

## 快速使用

### 前置条件

通用 harness 安装需要：

- Windows PowerShell 5.1（默认兼容桌面 .NET Framework 场景）或 PowerShell 7.6（优先用于 .NET 运行时场景）。
- Git，只有从 GitHub clone 时需要。
- 目标项目目录的写入权限。

安装 Codex skill 还需要：

- Codex 能读取本机 skills 目录。
- 可写入 `$CODEX_HOME\skills`，或在未设置 `CODEX_HOME` 时可写入 `%USERPROFILE%\.codex\skills`。

创建 C# WinForms/WPF 仪器项目起点还需要：

- .NET SDK。
- Windows 环境。WPF/WinForms 项目和 CI 建议在 Windows 上构建验证。
- 明确目标框架和平台位数，例如 `net8.0`、`x64`、`x86` 或 `AnyCPU`。真实设备 SDK 的位数优先级高于模板默认值。

### 让 AI 根据 Git 链接安装到目标项目

可以。在目标项目里给 AI 这样的提示：

```text
请根据 https://github.com/williansgreen/harness-engineering-spec 为当前项目安装 harness 和 C# WinForms/WPF skill。

要求：
1. 先 clone 或读取该仓库的 README.md。
2. 不要覆盖我已有文件，除非我明确允许。
3. 运行 install-harness.ps1，把 harness 安装到当前项目根目录。
4. 运行 install-codex-skill.ps1，把 csharp-winforms-wpf skill 安装到本机 Codex skills 目录。
5. 把 harness/build.md、harness/test.md、harness/run.md 里的占位命令替换成当前项目真实命令。
6. 运行 check-harness.ps1 检查安装结果。
7. 最后说明改了哪些文件、哪些命令已验证、哪些地方仍需要我确认。
```

AI 可以按这个链接自动安装的前提是：它能访问网络、能写入目标项目文件、能执行 PowerShell，并且有权限写入本机 Codex skills 目录。不能指望 README 自动越权执行；README 的作用是提供稳定、可复制的安装流程。

### 从 GitHub 安装到目标项目

把仓库 clone 到任意临时或工具目录：

```powershell
git clone https://github.com/williansgreen/harness-engineering-spec.git
cd harness-engineering-spec
```

先预览复制内容：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 -TargetPath "D:\path\to\project" -DryRun
```

确认后安装到目标项目：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 -TargetPath "D:\path\to\project"
```

默认不会覆盖目标项目中已经存在的同名文件。如需覆盖，先 review 目标文件，再显式使用 `-Force`：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 -TargetPath "D:\path\to\project" -Force
```

检查目标项目 harness：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-harness.ps1 -TargetPath "D:\path\to\project"
```

安装后，目标项目通常会新增：

```text
AGENTS.md
feature_list.json
feature-list.schema.json
progress.md
session-handoff.md
clean-state-checklist.md
quality-document.md
evaluator-rubric.md
harness/env.md
harness/build.md
harness/run.md
harness/test.md
harness/quality.md
harness/release.md
harness/hardware-test.md
harness/protocol-replay.md
harness/ui-acceptance.md
harness/deployment-acceptance.md
harness/security-data.md
harness/git-save-feature.ps1
harness/update-evidence.ps1
evals/benchmark-record.md
```

安装后必须把 `harness/*.md` 里的占位命令替换成目标项目的真实命令。`check-harness.ps1` 对占位符给出 warning 是正常的，表示还没有完成项目化配置。

通用约定是：项目实际命令、目标机器、证据路径和阻塞项写进 `harness/`；C# WinForms/WPF 的通用工程规则写进 `skills/csharp-winforms-wpf/references/`。

### Git checkpoint 小工具

Harness 默认不会自动提交 Git。要启用这个工作流，需要在任务里明确说明，例如：

```text
本轮启用 Git checkpoint：每完成一个可独立验证的小功能后，用 harness/git-save-feature.ps1 创建本地 commit。
```

手动执行方式：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\harness\git-save-feature.ps1 -Message "feat(scope): summary" -Paths .\src\File.cs .\tests\FileTests.cs -VerifyCommand "dotnet build", "dotnet test"
```

如果验证已经刚刚运行过，可以改用 `-VerificationAlreadyRun`。默认应传明确的 `-Paths`，只在人工检查过所有 dirty files 后才使用 `-All`。

如需同时写入 `feature_list.json` evidence：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\harness\git-save-feature.ps1 -Message "feat(scope): summary" -Paths .\src\File.cs -VerificationAlreadyRun -EvidenceFeatureId feat-001 -EvidenceType review -RecordProgress
```

单独追加 evidence：

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\harness\update-evidence.ps1 -FeatureId feat-001 -Type test -Result passed -Command "dotnet test" -Notes "Unit tests passed."
```

### Harness 升级差异扫描

对已经安装过 harness 的项目，先查看模板和目标项目的差异，不直接覆盖：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\upgrade-harness.ps1 -TargetPath "D:\path\to\project" -ShowDiff
```

只补齐缺失文件：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\upgrade-harness.ps1 -TargetPath "D:\path\to\project" -ApplyMissing
```

### 安装 Codex Skill

先预览安装：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skill.ps1 -DryRun
```

确认后安装 `csharp-winforms-wpf`：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skill.ps1
```

默认安装到：

```text
$CODEX_HOME\skills
```

如果未设置 `CODEX_HOME`，则安装到：

```text
%USERPROFILE%\.codex\skills
```

安装后启动新的 Codex 会话，并用类似提示触发：

```text
Use $csharp-winforms-wpf to review this C# WinForms/WPF instrument project.
```

### 创建 C# 仪器软件起点

创建 C# 仪器软件起点时，可先安装/引用 `skills/csharp-winforms-wpf`，再使用脚手架脚本。正式项目建议显式指定目标框架：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\csharp-winforms-wpf\scripts\new-instrument-solution.ps1 -ProductName InstrumentControl -TargetPath "D:\path\to\InstrumentControl" -UiFramework Wpf -TargetFramework net8.0 -Platform x64 -RunVerification
```

脚本会创建分层 `.sln`，包括 UI、Application、Domain、Devices、Infrastructure、测试项目、模拟设备和基础测试。真实项目接入厂商 SDK 前，应先补充设备协议或 SDK 约束文档，可从 `skills/csharp-winforms-wpf/assets/templates/device-protocol-template.md` 开始。

C# 上位机项目常用的专项规则位于：

```text
skills/csharp-winforms-wpf/references/winforms-dpi-scaling.md
skills/csharp-winforms-wpf/references/winforms-ipc-ui-acceptance.md
skills/csharp-winforms-wpf/references/serial-protocol-replay.md
skills/csharp-winforms-wpf/references/hardware-acceptance.md
skills/csharp-winforms-wpf/references/winforms-packaging-deployment.md
skills/csharp-winforms-wpf/references/medical-data-security.md
```

### 验证本仓库

检查本规范库：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-spec.ps1
```

查看示例：

- `examples/minimal-harness`
- `examples/csharp-instrument-harness`

评估和 forward-test 结果建议记录到项目的 `evals/benchmark-record.md`，模板来自 `templates/benchmark-record.md`。

### 常见问题

PowerShell 执行策略阻止脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-spec.ps1
```

找不到 `dotnet`：

```powershell
dotnet --list-sdks
```

如果命令失败，先安装 .NET SDK，再运行 C# 脚手架或构建命令。

skill 安装后没有触发：

```text
确认 skill 位于 $CODEX_HOME\skills\csharp-winforms-wpf 或 %USERPROFILE%\.codex\skills\csharp-winforms-wpf。
重新启动 Codex 会话。
明确使用 $csharp-winforms-wpf 触发。
```

`check-harness.ps1` 提示 placeholder：

```text
这是新安装模板的正常状态。把 harness/build.md、harness/test.md、harness/run.md 等文件中的示例命令替换成目标项目真实命令后再检查。
```

### 适用范围和 License

本仓库适用于 coding-agent 项目 harness 和 C# WinForms/WPF 上位机软件协作流程，不是 NI TestStand、硬件在环测试平台或通用测试框架的替代品。

本项目采用 [MIT License](LICENSE)。

## 和 codex_docs 的关系

`codex_docs` 是一个偏 C# 仪器软件的项目级 Codex 模板。

本仓库负责抽象通用 harness 规范，并把 C# WinForms/WPF 的专项经验迁移成 skill。后续可以让 `codex_docs` 成为“应用了通用 harness + C# skill 的参考模板”。
