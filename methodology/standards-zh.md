# AI 工程标准

## 一、概述

本文档定义一套面向 Claude Code 与 Codex 的 工作流原则。

目标：

- 让改动可增量执行
- 降低需求幻觉
- 提升执行可预测性
- 让评审与回滚更简单

协作模型：

- Claude Code：设计与评审
- Codex：代码实现
- Claude Code：最终评审

---

## 二、工作流级别

每个任务使用 `L1/L2/L3` 三种级别之一。

| 级别 | 适用场景 | 是否需要设计 | 是否需要任务拆解 |
|---|---|---|---|
| L1 Quick Task | 修 bug、小改动、参数调整 | 否 | 否 |
| L2 Feature Task（默认） | 新 API、新功能、新模块 | 是 | 是 |
| L3 System Design | 大子系统、架构重构、新服务 | 是（详细） | 是（详细） |

推荐选择规则：

- 局部小修补：L1
- 常规功能开发：L2
- 影响架构或跨多模块：L3

可选规模启发：

- 预估 < 1 个文件：L1
- 预估 < 500 行净改动：L2
- 预估 > 500 行或跨域改动：L3

---

## 三、任务开始建议

工作流选择是可选动作。

对“真正要实现”的请求，建议先声明工作流级别。

示例：

```text
Workflow Selection: L2
Reason: add new export feature with API + service updates
```

普通聊天、讨论、探索阶段不要求选择工作流。

---

## 四、L1（简单任务）

适用：

- Bug 修复
- 很小的行为调整
- 日志或参数的小改动

流程：

需求 -> Codex 实现 -> Claude 评审

L1 交付物：

- 最小必要代码改动
- 行为变化时补测试
- 简短风险与验证说明

默认不要求 `design.md` 与 `tasks.md`。

---

## 五、L2（默认功能开发）

适用：

- 新功能
- 新接口
- 新模块

流程：

Feature 需求 -> requirements.md -> design.md -> tasks.md -> 按任务逐个实现 -> 评审

L2 规则：

- 目标：每个任务修改 <= 4 个文件
- 目标：每个任务 <= 400 行代码
- 若超出目标，先拆分；若无法拆分，在 `tasks.md` 写一行原因
- 默认只实现下一个未完成任务
- 默认完成一个任务后勾选并停止
- 覆盖（仅用户明确要求）：按顺序连续完成全部未完成任务，直到完成或遇阻断

---

## 六、L3（系统级设计）

适用：

- 大范围且影响架构
- 服务拆分或大型重构

流程：

PRD 更新 -> 架构更新 -> 详细设计 -> 详细任务 -> 增量实现 -> 评审

L3 规则：

- 必须定义迁移与回滚策略
- 必须跟踪风险
- 默认仍然一轮只做一个任务
- 覆盖（仅用户明确要求）：按顺序连续完成全部未完成任务，直到完成或遇阻断

---

## 七、中途切换工作流

当范围变化时，显式切换工作流。

示例：

```text
Workflow Switch: from L2 to L1
Reason: reduced to one bugfix
Effective now. Re-plan from current state.
```

切换步骤：

1. 先停止当前实现
2. 说明切换影响
3. 按新级别补齐或移除产物
4. 再继续执行

---

## 八、基于历史任务做增量修改

如果是在已完成 Feature 上继续迭代，不要覆盖旧 Feature 文档。

推荐：

- 新建目录（如 `.workflow/features/004-payment-adjustment`）
- 在新设计中引用旧 Feature
- 只为增量部分生成新任务

旧 `tasks.md` 作为历史记录应保持不变。

---

## 九、推荐仓库结构

```text
repo/
  .workflow/
    AGENTS.md
    CLAUDE.md
    RULES.md
    .claude/rules/
    .ai/rules.md
    docs/
      PRD.md
      ARCHITECTURE.md
    features/
      001-xxx/
        requirements.md
        design.md
        tasks.md
  src/
  tests/
```

目录规则：

- 以当前仓库真实目录为准
- 如果项目使用 `faab/`、`app/` 等路径，不要强制改成 `src/`
- 任务文件里的路径必须使用当前仓库真实路径

---

## 十、规则层级

生效优先级：

1. 全局规则（工具级）
2. 用户偏好（工具级）
3. 项目规则（`.workflow/RULES.md`、`.workflow/AGENTS.md`、`.workflow/CLAUDE.md`、`.workflow/.claude/rules/*`、`.workflow/.ai/rules.md`）
4. Feature 需求（`.workflow/features/*/requirements.md`）
5. Feature 设计（`.workflow/features/*/design.md`）
6. Feature 任务（`.workflow/features/*/tasks.md`）

项目内读取顺序：

1. `.workflow/AGENTS.md`
2. `.workflow/RULES.md`（如存在）
3. `.workflow/docs/PRD.md`
4. `.workflow/docs/ARCHITECTURE.md`
5. `.workflow/features/*/requirements.md`
6. `.workflow/features/*/design.md`
7. `.workflow/features/*/tasks.md`

---

## 十一、安全初始化工作流

工作流初始化是可选动作，不是强制动作。

仅在用户显式命令时执行：

- `wf-init l1 --confirm`
- `wf-init l2 --confirm`
- `wf-init l3 --confirm`

安全规则：

- 不把模糊输入（`1`、`2`、`3`、`l1`）映射为初始化
- 普通对话阶段不自动初始化
- 初始化必须非破坏性（不覆盖已有文件）

初始化后的自动选择：

- `wf-init lX --confirm` 会写入 `.workflow/.workflow-level=lX`
- 在实现任务中默认自动采用 `.workflow/.workflow-level` 对应级别
- 除非你想覆盖，否则不需要再输入一次工作流级别

---

## 十二、提示词模板

L1 示例：

```text
Workflow Selection: L1
Task: <small fix>
Constraints: minimal changes, no refactor
```

L2 示例：

```text
Workflow Selection: L2
Feature: <name>
Step 1: 先把原始需求粘贴到 .workflow/features/<id>/requirements.md 的 Raw Input
Step 2: 提炼结构化 .workflow/features/<id>/requirements.md
Step 3: generate .workflow/features/<id>/design.md
Step 4: generate .workflow/features/<id>/tasks.md
Step 5: implement next unfinished task only
```

L3 示例：

```text
Workflow Selection: L3
Goal: <system-level objective>
Update PRD and architecture first, then generate detailed design/tasks.
Implement one task and stop.
```

---

## 十三、完成标准

L1 完成标准：

- 需求修复完成
- 验证通过
- 有风险说明

L2 完成标准：

- 已有 requirements、design 与 tasks
- 任务全部完成
- 测试与评审通过

L3 完成标准：

- PRD 与架构已更新
- 详细任务完成
- 迁移风险已处理
- 评审通过
