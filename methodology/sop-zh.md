# AI 开发单页速查

本页用于日常执行，尽量按步骤走。

## 0. 一次性准备（`wf-init`）

```bash
cd ~/ai-dev
./scripts/install-wf-init.sh
```

如有需要，先把 `~/.local/bin` 加到 PATH。

## 1. 启动会话

```bash
cd <目标仓库>
claude-codex
```

说明：

- 普通对话不需要选择工作流。
- 进入“实现任务”时，建议先声明工作流级别。

## 2. 可选初始化工作流

仅当当前目录还没准备好时才初始化。

```bash
wf-init l1 --confirm
wf-init l2 --confirm
wf-init l3 --confirm
```

安全规则：

- `wf-init` 是可选动作。
- `1/2/3` 不能触发初始化。
- 没有 `--confirm` 不执行。
- 初始化后会自动以 `.workflow/.workflow-level` 作为默认工作流。
- 除非你要覆盖，否则不需要再输入一次工作流级别。

## 3. 选择工作流

- `L1`：修 bug、小修补、参数/日志微调。
- `L2`（默认）：常规新功能、新 API、新模块。
- `L3`：影响架构或大子系统改造。

实现任务首条消息建议：

```text
Workflow Selection: L2
Reason: add new feature with API + service changes
```

## 4. 执行模式

目录规则（适用于所有级别）：

- 以当前项目目录结构为准。
- 不要强制使用 `src/`。
- 任务文件路径必须写真实仓库路径。

### L1

1. 明确范围。
2. 做最小改动。
3. 行为变化时补测试。
4. 输出风险和验证结论。

### L2

1. 将原始需求粘贴到 `.workflow/features/<id>/requirements.md` 的 `Raw Input`。
2. 提炼并规范化 `.workflow/features/<id>/requirements.md`。
3. 生成 `.workflow/features/<id>/design.md`。
4. 生成 `.workflow/features/<id>/tasks.md`。
5. 默认只实现下一个未完成任务。
6. 默认勾选一个任务后停止。
7. 如果用户明确要求“全部完成任务”，则按顺序连续执行直到全部完成或遇阻断。
8. 做评审。

### L3

1. 更新 `.workflow/docs/PRD.md`。
2. 更新 `.workflow/docs/ARCHITECTURE.md`。
3. 生成详细设计与详细任务。
4. 默认一次实现一个任务并停止。
5. 如果用户明确要求“全部完成任务”，则按顺序连续执行直到全部完成或遇阻断。
6. 跟踪迁移与回滚风险。

## 5. 中途切换工作流

范围变化时显式切换：

```text
Workflow Switch: from L2 to L1
Reason: reduced to one bugfix
Effective now. Re-plan from current state.
```

切换步骤：

1. 先停下当前实现。
2. 说明切换影响。
3. 按新级别补齐或移除产物。
4. 在新级别下继续。

## 6. 基于旧 Feature 做增量

不要覆盖旧的已完成 Feature 文档。

推荐：

1. 新建后续目录（如 `.workflow/features/004-...`）。
2. 新设计里引用旧 Feature。
3. 只生成增量任务。

## 7. 完成检查

### L1 完成

- 修复已实现
- 验证已完成
- 风险说明已给出

### L2 完成

- 已有 `requirements.md`、`design.md` 和 `tasks.md`
- 任务全部勾选
- 测试和评审通过

### L3 完成

- PRD 与架构已更新
- 详细任务已完成
- 迁移风险已处理

## 8. 快速排障

- 规则未生效：检查 `$CLAUDE_CONFIG_DIR/rules/*.md`。
- 目录不对：确认当前仓库有 `.workflow/AGENTS.md`。
- 初始化失败：使用显式命令 `wf-init lX --confirm`。
