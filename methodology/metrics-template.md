# Metrics Template (EN + ZH)

## 1) Task Log (Per Task)

Use one row per completed task.

| Date | Repo | Workflow | Feature/Task ID | Start Time | End Time | Cycle Time (min) | First Pass (Y/N) | Rework (Y/N) | Blocking Findings (#) | Notes |
|---|---|---|---|---|---|---:|---|---|---:|---|
| 2026-03-17 | order-system | L2 | 003-payment / Task 1 | 10:00 | 11:10 | 70 | Y | N | 0 | Added service + unit test |
| 2026-03-17 | order-system | L2 | 003-payment / Task 2 | 11:30 | 13:00 | 90 | N | Y | 2 | Fixed review findings |

---

## 2) Weekly Summary

Fill once per week.

| Week | Tasks Completed | Throughput vs Baseline (%) | First-Pass Success Rate (%) | Rework Rate (%) | Avg Cycle Time (min) | Review Defect Density | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| 2026-W12 | 18 | +28 | 72 | 17 | 78 | 0.39 | Stable L2 execution |

---

## 3) Metric Definitions

- Tasks Completed = number of tasks checked in `tasks.md` (or L1 tasks closed).
- Throughput vs Baseline (%) = `(current - baseline) / baseline * 100`.
- First-Pass Success Rate (%) = `first_pass_tasks / total_tasks * 100`.
- Rework Rate (%) = `rework_tasks / total_tasks * 100`.
- Avg Cycle Time (min) = average of per-task cycle time.
- Review Defect Density = `blocking_findings / total_tasks`.

---

## 4) Two-Week Evaluation Gate

Recommend "effective" if all are true:

- Throughput vs Baseline >= +20%
- Rework Rate <= baseline - 30%
- Review Defect Density trending down

---

## 5) 中文版（同一模板）

### 5.1 任务明细（每个任务一行）

| 日期 | 仓库 | 工作流 | Feature/Task ID | 开始时间 | 结束时间 | 周期时长（分钟） | 一次通过（Y/N） | 是否返工（Y/N） | 阻断问题数 | 备注 |
|---|---|---|---|---|---|---:|---|---|---:|---|
| 2026-03-17 | order-system | L2 | 003-payment / Task 1 | 10:00 | 11:10 | 70 | Y | N | 0 | 增加服务与单测 |
| 2026-03-17 | order-system | L2 | 003-payment / Task 2 | 11:30 | 13:00 | 90 | N | Y | 2 | 修复评审问题 |

### 5.2 周汇总（每周填写）

| 周次 | 完成任务数 | 相比基线吞吐变化（%） | 一次通过率（%） | 返工率（%） | 平均周期（分钟） | 评审缺陷密度 | 备注 |
|---|---:|---:|---:|---:|---:|---:|---|
| 2026-W12 | 18 | +28 | 72 | 17 | 78 | 0.39 | L2 执行稳定 |

### 5.3 指标定义

- 完成任务数：`tasks.md` 勾选完成的任务数（L1 为关闭的小任务数）。
- 吞吐变化（%）：`(本期 - 基线) / 基线 * 100`。
- 一次通过率（%）：`一次通过任务数 / 总任务数 * 100`。
- 返工率（%）：`返工任务数 / 总任务数 * 100`。
- 平均周期（分钟）：任务周期时长的平均值。
- 评审缺陷密度：`阻断问题总数 / 总任务数`。

### 5.4 两周验收门槛

推荐满足以下条件时判断“方法有效”：

- 吞吐变化 >= +20%
- 返工率较基线下降 >= 30%
- 评审缺陷密度呈下降趋势
