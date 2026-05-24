# 现有项目接入指南

现有项目接入 harness 时，先补最小闭环，不要一次重写项目结构。

## 先做审计

检查：

- 是否有入口文件。
- 是否有真实构建命令。
- 是否有真实测试命令。
- 是否知道当前最高优先级功能。
- 是否有未完成、未验证或阻塞记录。

使用：

```text
checklists/harness-audit-checklist.md
```

## 推荐接入顺序

1. 复制 `templates/AGENTS.md` 到项目根目录并按项目修改。
2. 复制 `templates/feature_list.json` 并填入真实功能。
3. 复制 `templates/feature-list.schema.json`，保留为项目状态契约。
4. 复制 `templates/progress.md`。
5. 复制 `templates/session-handoff.md`。
6. 创建 `harness/` 并复制 build/run/test/quality/env 模板。
7. 复制 `templates/clean-state-checklist.md`。
8. 第一次让 agent 只检查上下文，不直接写代码。

## 首次检查提示

```text
请先阅读 AGENTS.md、feature_list.json、progress.md、session-handoff.md 和 harness/，检查当前项目 harness 是否足够。如果不足，请列出缺口，不要先修改代码。
```

## 不要做

- 不要在没有用户确认时重置 Git 历史。
- 不要用模板覆盖真实项目上下文。
- 不要把示例命令当成真实命令。
- 不要因为接入 harness 就顺手重构业务代码。

## 通过标准

接入后应能回答：

- 当前 active feature 是什么？
- 构建命令是什么？
- 测试命令是什么？
- passing 的结构化证据在哪里？
- 真实硬件不可用时的模拟或替代验证是什么？
- 下一轮会话从哪里继续？
