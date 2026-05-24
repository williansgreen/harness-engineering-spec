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
5. `checklists/harness-audit-checklist.md`

如果要把现有项目接入 harness，继续看：

- `docs/08-adoption-guide.md`
- `docs/09-task-routing.md`
- `docs/10-benchmarking.md`
- `docs/11-skill-installation.md`
- `docs/12-forward-testing.md`
- `docs/13-evaluation-records.md`

## 快速使用

### 让 AI 根据 Git 链接安装到目标项目

可以。把本仓库设为 public 后，在目标项目里给 AI 这样的提示：

```text
请根据 https://github.com/williansgreen/harness-engineering-spec 为当前项目安装 harness 和 C# WinForms/WPF skill。

要求：
1. 先 clone 或读取该仓库的 README.md。
2. 不要覆盖我已有文件，除非我明确允许。
3. 运行 scripts/install-harness.ps1，把 harness 安装到当前项目根目录。
4. 运行 scripts/install-codex-skill.ps1，把 csharp-winforms-wpf skill 安装到本机 Codex skills 目录。
5. 把 harness/build.md、harness/test.md、harness/run.md 里的占位命令替换成当前项目真实命令。
6. 运行 scripts/check-harness.ps1 检查安装结果。
7. 最后说明改了哪些文件、哪些命令已验证、哪些地方仍需要我确认。
```

AI 可以按这个链接自动安装的前提是：它能访问网络、能写入目标项目文件、能执行 PowerShell，并且有权限写入本机 Codex skills 目录。不能指望 README 自动越权执行；README 的作用是提供稳定、可复制的安装流程。

预览复制：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 -TargetPath "D:\path\to\project" -DryRun
```

复制到项目：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 -TargetPath "D:\path\to\project"
```

检查项目 harness：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-harness.ps1 -TargetPath "D:\path\to\project"
```

检查本规范库：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-spec.ps1
```

预览安装 Codex skill：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skill.ps1 -DryRun
```

查看示例：

- `examples/minimal-harness`
- `examples/csharp-instrument-harness`

创建 C# 仪器软件起点时，可先安装/引用 `skills/csharp-winforms-wpf`，再使用脚手架脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\csharp-winforms-wpf\scripts\new-instrument-solution.ps1 -ProductName InstrumentControl -TargetPath "D:\path\to\InstrumentControl" -UiFramework Wpf -Platform x64 -RunVerification
```

评估和 forward-test 结果建议记录到项目的 `evals/benchmark-record.md`，模板来自 `templates/benchmark-record.md`。

## 和 codex_docs 的关系

`codex_docs` 是一个偏 C# 仪器软件的项目级 Codex 模板。

本仓库负责抽象通用 harness 规范，并把 C# WinForms/WPF 的专项经验迁移成 skill。后续可以让 `codex_docs` 成为“应用了通用 harness + C# skill 的参考模板”。
