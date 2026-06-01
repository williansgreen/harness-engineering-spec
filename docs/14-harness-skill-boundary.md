# Harness 与 Skill 边界

本仓库同时维护通用 harness 和 C# WinForms/WPF skill。二者必须分层，否则规范会变成某个项目的说明书。

## 放入 Harness

Harness 记录项目运行契约。内容应能回答“这个仓库现在怎么继续”。

应放入 harness 的内容：

- 项目实际 build、run、test、quality、release 命令。
- 当前 feature 状态、优先级、依赖、风险和 evidence。
- 当前项目的硬件验收步骤、协议 replay 命令、目标显示器、部署机器和数据策略。
- 本项目的真实路径、目标机器、工具版本、证据文件和阻塞项。
- 会话交接、Git checkpoint、状态文件压缩和 benchmark 记录。

不应放入 harness 的内容：

- C# 架构教程。
- WinForms/WPF 通用设计规则。
- 串口协议设计通用理论。
- 与当前项目无关的长篇背景知识。

## 放入 Skill

Skill 记录跨项目可复用的领域工程规则。内容应能回答“遇到这一类任务时 Codex 应怎么做”。

应放入 C# WinForms/WPF skill 的内容：

- `.sln`、`src/`、`tests/`、MVP/MVVM、DI、Domain/Application/Devices 边界。
- WinForms Designer-safe、WPF XAML/MVVM、DPI、固定 IPC UI、容器布局规则。
- C# 设备通信、串口 replay、硬件验收、打包部署、配置/数据/日志/敏感数据规则。
- 可复用脚手架、代码模板、review checklist 和 forward-test prompt。

不应放入 skill 的内容：

- 某个项目的真实 COM 口、机器名、医院名称、账号、路径或证据文件。
- 某次会话的进度流水账。
- 项目专属 build 输出、截图路径或临时目录。

## 放入 Examples 或 Evals

Examples 和 evals 用来测试规范是否有效，不承载真实项目状态。

适合放入 examples/evals 的内容：

- 从真实项目抽象出的任务场景。
- 期望 agent 读取哪些 reference。
- pass/fail criteria。
- 小型 fixture 或反例。

不适合放入 examples/evals 的内容：

- 真实生产数据。
- 真实硬件日志。
- 需要权限或安全审批才能运行的步骤。

## 判断规则

| 内容 | 归属 |
| --- | --- |
| 当前项目怎么构建、测试、打包 | Harness |
| 当前项目目标 IPC 是什么分辨率 | Harness |
| WinForms 固定 IPC 一般如何处理 DPI | C# Skill |
| 当前项目某次 UI 截图是否通过 | Harness evidence |
| 串口 replay 应覆盖哪些异常 | C# Skill |
| 当前项目 replay 命令和 fixture 路径 | Harness |
| 从宣武医院项目抽象出的测试 prompt | Evals |

## 修改流程

1. 先判断内容是项目状态、通用领域规则，还是评估场景。
2. 项目状态写入 `templates/` 或目标项目 `harness/`。
3. 通用 C# 规则写入 `skills/csharp-winforms-wpf/references/`。
4. 真实项目暴露的新问题，先抽象成 eval，再决定是否沉淀为 harness 模板或 skill reference。
5. 修改后运行 `scripts/check-spec.ps1`。
