# 任务路由

Harness 应让 agent 在动手前识别任务类型。

## 规划类

触发：

- 设计一个系统。
- 规划软件。
- 这个项目怎么架构。
- 做一个 UI 方案。

默认动作：

- 先规划，不直接大量写代码。
- 明确用户、目标、流程、模块、数据、验证方式。
- 输出可实施的下一步。

## 实现类

触发：

- 实现。
- 添加。
- 修改。
- 接入。
- 完成这个功能。

默认动作：

- 阅读相关代码和 harness。
- 明确验收标准。
- 做最小可验证改动。
- 构建、测试、记录证据。

## Bug 修复类

触发：

- 修复。
- 报错。
- 崩溃。
- 不生效。

默认动作：

- 尽量复现。
- 定位根因。
- 最小修复。
- 增加或更新回归验证。

## Review 类

触发：

- review。
- 代码审查。
- 看看风险。

默认动作：

- 先列缺陷和风险。
- 按严重程度排序。
- 标明文件位置、影响和修复建议。
- 最后再给摘要。

## UI 类

触发：

- 界面。
- 布局。
- 高 DPI。
- 视觉检查。

默认动作：

- 先确认信息架构和状态表达。
- 修改后构建。
- 环境允许时运行并观察。
- 不能运行时说明视觉验收待确认。

## 硬件与协议类

触发：

- 串口。
- 控制板。
- 设备通信。
- 协议回放。
- 模拟器。
- 真实硬件验收。

默认动作：

- 区分软件 replay 证据和真实物理验收。
- 项目实际命令写入 `harness/protocol-replay.md` 或 `harness/hardware-test.md`。
- 语言或设备通信通用规则写入对应 skill reference。
- 不用 build-only evidence 标记硬件高风险功能 passing。

## 长运行流程与状态机类

触发：

- 实验流程、批次流程或循环采集。
- 状态机、调度器、轮询、暂停/继续。
- 运行中追加、资源互斥、停止、故障恢复或断点续作。

默认动作：

- 先区分 agent verification loop、产品 runtime loop 和设备 feedback loop。
- 通用执行闭环读取 `docs/15-loop-engineering.md` 与 `docs/05-verification-loop.md`。
- C# WinForms/WPF 仪器运行时读取 `skills/csharp-winforms-wpf/references/runtime-workflow-loop-engineering.md`。
- 项目实际 replay、故障注入、真机步骤和证据路径写入项目 harness。
- 不用事件列表、UI 控件值或命令 ACK 代替权威运行快照和物理状态确认。

## 打包与部署类

触发：

- 打包。
- 发布。
- 安装包。
- 部署。
- 目标机器验收。

默认动作：

- 项目实际打包命令和产物写入 `harness/release.md`。
- 目标机器启动、依赖、目录权限和回滚写入 `harness/deployment-acceptance.md`。
- C# 桌面打包通用规则放入 `skills/csharp-winforms-wpf/references/winforms-packaging-deployment.md`。

## 安全与数据类

触发：

- secrets。
- token。
- 患者/样品/客户数据。
- 生物特征。
- 报告。
- 审计日志。

默认动作：

- 项目实际数据分类写入 `harness/security-data.md`。
- 不提交真实敏感数据。
- 不把真实密钥、患者/样品数据或生物特征写入示例、eval 或日志。
- C# 医疗或敏感数据通用规则放入 `skills/csharp-winforms-wpf/references/medical-data-security.md`。
