# 约定

> 这份文档是 vc-vault 的"宪法"——所有 frontmatter 字段、文件夹规则、命名约定。
> 改动 = 可能让 skill 失效，谨慎。

## 文件夹

```
<vault-root>/
├── _dashboard.md
├── _thesis.md
├── 0-pipeline/
│   ├── 1-初筛/, 2-meeting/, 3-DD中/, 4-IC/, 5-pass/
├── 1-portfolio/companies/
├── 2-exited/
├── 3-people/
├── 4-memos/
├── 5-updates/
├── 6-board-notes/
├── 7-reviews/
└── bases/
```

数字前缀**强制**——它们决定 Obsidian 排序，且 skill 用它们做导航。

## 文件命名

- **portfolio 公司**：`<公司名>.md`，放在 `1-portfolio/companies/`
- **pipeline deal**：`<公司名>.md`，放在 `0-pipeline/<阶段>/`
- **memo**：`<公司>-<轮次>-memo.md`，放在 `4-memos/`
- **update**：`<公司>-<YYYY-Q?>-update.md` 或 `<公司>-<YYYY-MM>-update.md`，放在 `5-updates/`
- **人物**：`<姓名>.md`，放在 `3-people/`
- **复盘**：
  - 周：`<YYYY>-W<##>-review.md`
  - 月：`<YYYY>-<MM>-月报.md`
  - 季：`<YYYY>-Q<#>-portfolio-review.md`
  - 年：`<YYYY>-年报.md`

## frontmatter 字段总览

### 通用字段（所有笔记可选）

| 字段 | 类型 | 说明 |
|---|---|---|
| `type` | string | **必须**——决定笔记类型，skill 据此分流 |
| `tags` | list | Obsidian tags，前缀分类用 |
| `last_action` | string `YYYY-MM-DD HH:MM <动作>` | Claude 写回字段——**不要手动改** |

### `type: portfolio-company`

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `公司` | string | ✓ | 公司名 |
| `行业` | string | ✓ | 大类（如：高端制造）|
| `赛道` | string |   | 细分（如：工业机器人）|
| `我方轮次` | string | ✓ | 我们投的那一轮（A / B / 种子...）|
| `我方角色` | enum | ✓ | 领投 / 跟投 / observer / SAFE |
| `状态` | enum | ✓ | active / struggling / exited-ipo / exited-ma / 写零 |
| `首次投资日期` | date | ✓ | YYYY-MM-DD |
| `我方累计投资` | number | ✓ | 单位：万人民币 |
| `我方累计占股` | number |   | 百分比 |
| `最新估值-投后` | number |   | 单位：万 |
| `最近一轮日期` | date |   |  |
| `当前 MOIC` | number |   | 估值 / 累计成本 |
| `runway 月数` | number |   |  |
| `月烧钱` | number |   | 单位：万 |
| `最近 update` | date |   | 上次创始人发 update 的日期 |
| `下次复盘截止` | date | ✓ | 自己设的内部 deadline |
| `首席创始人` | wikilink | ✓ | 链 `3-people/` 下的笔记 |
| `团队规模` | number |   |  |
| `我的董事会角色` | enum |   | 董事 / observer / 无 |
| `论点` | wikilink |   | 链关联的论点笔记 |
| `project_root` | path | ✓ | **绝对路径**——工作文件目录根 |
| `files` | object |   | key→相对路径，相对于 `project_root` |
| `external` | object |   | key→URL（data room / Notion 等） |
| `follow-on 优先级` | enum |   | 高 / 中 / 低 / 不再投 |

### `type: pipeline-deal`

| 字段 | 必填 | 说明 |
|---|---|---|
| `公司` | ✓ |  |
| `来源` | ✓ | 链人物（谁推过来的） |
| `首次接触` | ✓ |  |
| `当前阶段` | ✓ | 初筛 / meeting / DD中 / IC / pass |
| `推荐金额` |   | 单位：万 |
| `推荐估值` |   | 投前估值 |
| `预计投决日期` |   |  |
| `负责合伙人` |   |  |
| `风险打分` |   | 1-10 |
| `机会打分` |   | 1-10 |
| `project_root`, `files`, `external` |   | 同 portfolio-company |

### `type: memo`

| 字段 | 必填 | 说明 |
|---|---|---|
| `deal` | ✓ | 链 portfolio 或 pipeline 笔记 |
| `轮次` | ✓ |  |
| `推荐` | ✓ | 投 / 继续观察 / pass |
| `推荐金额` |   |  |
| `推荐估值` |   | 投前 |
| `date` | ✓ |  |
| `作者` |   |  |
| `状态` | ✓ | 草稿 / 内部讨论 / 通过IC / 已投 / pass |

### `type: person`

| 字段 | 必填 | 说明 |
|---|---|---|
| `姓名` | ✓ |  |
| `角色` | ✓ | founder / co-investor / LP / advisor / lawyer / ex-founder |
| `关联公司` |   | 链 list |
| `首次见面` |   |  |
| `最近联系` |   |  |
| `联系频率` |   | 周 / 月 / 季 / 年 |
| `微信`, `邮箱`, `linkedin`, `所在城市` |   |  |

### `type: update`

| 字段 | 必填 | 说明 |
|---|---|---|
| `公司` | ✓ | 链 portfolio 笔记 |
| `period` | ✓ | YYYY-Q? 或 YYYY-MM |
| `update_date` |   | 创始人发出日期 |
| `parsed_date` |   | 我整理进 vault 的日期 |

### `type: review`

| 字段 | 必填 | 说明 |
|---|---|---|
| `period` | ✓ | YYYY-W## / YYYY-MM / YYYY-Q? / YYYY |
| `date` | ✓ |  |

## tags 命名

- `portfolio` / `pipeline` / `exited` —— 大类
- `sector/<行业>` —— 行业细分（用 slug，如 `sector/manufacturing`）
- `stage/<阶段>` —— 轮次（如 `stage/a`, `stage/seed`）
- `lead` / `follow` —— 我方角色
- `flag/red` / `flag/yellow` —— 主动标记需要关注的

## 时间格式

- 日期：**强制 ISO**——`YYYY-MM-DD`
- 时间戳：`YYYY-MM-DD HH:MM`（24h）
- **不允许**：`2026/4/15`、`2026年4月15日`、`Apr 15, 2026`——会让 Bases 排序混乱

## 数字单位

- 金额：**万人民币**（统一这一种）
- 占股：百分数（直接写 `3.5`，不写 `3.5%`，避免变成 string）
- runway：月数

## "近期操作" 日志

放在每个项目笔记的最末（在复盘 section 之后）。每条一行：

```
- 2026-05-01 14:32 解析 4 月 update，runway 14→11 月
```

格式：`- <YYYY-MM-DD HH:MM> <一句话动作>`

## frontmatter 写回原则（给 Claude 的硬约束）

1. **不要瞎猜值**：缺数据问用户
2. **不要默默改用户已有值**：改 estim 字段（估值 / 仓位 / 状态）必须 confirm
3. **改了一定写到日志**：去 `## 近期操作` 加一行
4. **保持其他字段原状**：只改你要改的，别"顺手整理"全文 frontmatter

## 不变量

下面这些**永远不允许改**（除非明示版本升级）：

- 文件夹的数字前缀（0/1/2/3/4/5/6/7）
- `type` 枚举值
- 日期 ISO 格式
- 金额单位（万）

破坏不变量 = skill 行为不可预测。
