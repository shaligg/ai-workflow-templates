# L2 实战脚本（Claude 设计 + Codex 实现）

本文是可直接复制执行的 L2 工作流脚本，覆盖从启动到收尾的完整流程。

## 1. 目标与分工

- Claude：设计与任务拆解、最终评审。
- Codex：按任务清单逐个实现代码。

## 2. 启动阶段

```bash
cd <目标仓库>
claude-codex
```

在 Claude 中检查记忆加载：

```text
/memory
```

可选初始化（项目首次使用时）：

```bash
wf-init l2 --confirm
```

## 3. Claude 阶段（只做设计与任务）

把下面模板发给 Claude：

```text
Workflow Selection: L2
Reason: <为什么这是 L2 功能开发>
Feature: <功能名>
Acceptance criteria:
1) <验收项1>
2) <验收项2>
3) <验收项3>
Raw requirements:
<粘贴产品/策划原文>

请只输出：
1. .workflow/features/<id>-<feature>/requirements.md
2. .workflow/features/<id>-<feature>/design.md
3. .workflow/features/<id>-<feature>/tasks.md

要求：
- 先将 Raw requirements 提炼并写入 requirements.md 标准章节
- 不要发明原文没有的业务规则；不确定项标记 TODO
不要写实现代码。
```

输出产物应至少包含：

- `requirements.md`：本次需求背景、范围、验收条件、约束。
- `design.md`：目标、接口、组件、数据、风险。
- `tasks.md`：可执行任务清单，按顺序勾选。

## 4. Codex 阶段（只做实现）

把下面模板发给 Codex：

```text
基于 .workflow/features/<id>-<feature>/requirements.md + .workflow/features/<id>-<feature>/design.md + .workflow/features/<id>-<feature>/tasks.md：
1) 只实现下一个未完成任务
2) 完成后勾选该任务并停止
3) 不要实现多个任务
4) 行为变化必须补测试
```

每轮执行完成后，重复同一条指令，直到任务清单全部完成。

如需一次性连续完成全部任务，可改用：

```text
基于 .workflow/features/<id>-<feature>/requirements.md + .workflow/features/<id>-<feature>/design.md + .workflow/features/<id>-<feature>/tasks.md：
请按顺序实现全部未完成任务，直到全部完成或遇阻断。
每完成一个任务就更新 tasks.md 勾选状态。
行为变化必须补测试；若测试失败或有阻断，立即停止并说明原因。
```

## 5. Claude 阶段（最终评审）

任务全部勾选后，回到 Claude 发：

```text
请基于当前代码和 .workflow/features/<id>-<feature>/requirements.md + .workflow/features/<id>-<feature>/design.md + .workflow/features/<id>-<feature>/tasks.md 做最终评审：
1) 是否满足验收标准
2) 是否有行为回归风险
3) 测试覆盖是否充分
4) 是否存在阻断问题
```

若有阻断问题：

- 回到 Codex 按问题逐条修复（仍一次只修一个点）。
- 修复后再回 Claude 复审。

## 6. 完成标准（L2）

同时满足以下条件才算完成：

1. `requirements.md`、`design.md` 与 `tasks.md` 已存在。
2. `tasks.md` 全部勾选。
3. 测试通过。
4. Claude 评审无阻断项。

## 7. 常见错误（避免）

1. 让 Claude 直接写实现代码（应先产出 requirements/design/tasks）。
2. Codex 一次实现多个任务（应一次一个）。
3. 完成任务后不勾选 `tasks.md`。
4. 跳过最终评审，直接结束。
