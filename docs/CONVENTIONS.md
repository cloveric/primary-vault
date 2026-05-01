# 约定 · Conventions

> 这份文档是 primary-vault 的"宪法"——所有 frontmatter 字段、文件夹规则、命名约定。
> 改动 = 可能让 skill 失效，谨慎。
>
> **v0.4 重要变更**：frontmatter 字段名全部改成 **snake_case 英文**（v0.3 是中文带空格）。
> 中文显示通过 Bases 的 `displayName` 实现——人看到中文，机器读到干净英文。
> 升级见 [docs/MIGRATION-v0.3-to-v0.4.md](MIGRATION-v0.3-to-v0.4.md)。

## 文件夹

```
<vault-root>/
├── _dashboard.md
├── _thesis.md
├── _QUICKSTART.md
├── 0-pipeline/
│   ├── 1-初筛/, 2-meeting/, 3-DD中/, 4-IC/, 5-pass/
├── 1-portfolio/companies/
├── 2-exited/
├── 3-people/
├── 4-memos/
├── 5-updates/
├── 6-board-notes/
├── 7-reviews/
│   └── decisions/         ← decision logs
└── bases/
```

数字前缀**强制**——它们决定 Obsidian 排序，且 skill 用它们做导航。

## 文件命名

- **portfolio 公司**：`<公司名>.md`，放在 `1-portfolio/companies/`
- **pipeline deal**：`<公司名>.md`，放在 `0-pipeline/<阶段>/`
- **memo**：`<公司>-<轮次>-memo.md`，放在 `4-memos/`
- **update**：`<公司>-<period>-update.md`（period 用 YYYY-Q? 或 YYYY-MM）
- **人物**：`<姓名>.md`，放在 `3-people/`
- **board meeting**：`<公司>-<YYYY-MM-DD>-board.md`，prep 同名加 `-prep`
- **exit record**：`<公司>-exit-record.md` 在 `2-exited/`
- **exit retrospective**：`<公司>-exit-retrospective.md` 在 `7-reviews/`
- **decision log**：`<YYYY-MM-DD>-<公司>-<动作>.md` 在 `7-reviews/decisions/`
- **复盘**：
  - 周：`<YYYY>-W<##>-周扫描.md`
  - 月：`<YYYY>-<MM>-月报.md`
  - 季：`<YYYY>-Q<#>-portfolio-review.md`
  - 年：`<YYYY>-年报.md`

## frontmatter 字段总览

### 通用字段（所有笔记）

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `type` | string | ✓ | 决定笔记类型，skill 据此分流 |
| `tags` | list |   | Obsidian tags |
| `last_action` | string `YYYY-MM-DD HH:MM <动作>` |   | Claude 写回字段——**不要手动改** |

### `type: portfolio-company`

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `company` | string | ✓ | 公司名（中文 / 英文都行）|
| `industry` | string | ✓ | 行业大类 |
| `sector` | string |   | 细分赛道 |
| `our_round` | string | ✓ | 我们投的轮次（A / B / 种子 / Buyout / Growth）|
| `our_role` | enum | ✓ | lead / follow / observer / SAFE |
| `status` | enum | ✓ | active / struggling / fundraising / exited-ipo / exited-ma / written-off |
| `first_investment_date` | date | ✓ | YYYY-MM-DD |
| `total_invested` | number | ✓ | 累计投入，单位：万人民币 |
| `ownership_pct` | number |   | 占股百分比 |
| `latest_post_money_valuation` | number |   | 最新轮投后估值，万 |
| `latest_round_date` | date |   | 最新轮日期 |
| `current_moic` | number |   | 估值 / 累计成本 |
| `runway_months` | number |   | 月数 |
| `monthly_burn` | number |   | 月烧，万 |
| `last_update` | date |   | 上次创始人发 update |
| `next_review_due` | date | ✓ | 自己设的下次复盘 deadline |
| `primary_founder` | wikilink | ✓ | 链 `3-people/` 笔记 |
| `team_size` | number |   |  |
| `my_board_role` | enum |   | director / observer / none |
| `last_board_meeting` | date |   |  |
| `next_board_meeting` | date |   |  |
| `board_frequency` | enum |   | monthly / quarterly / semiannual |
| `current_funding_round` | enum |   | none / started / dd / ts-negotiation / signed / ipo-prep / ma-negotiation |
| `thesis_link` | wikilink |   | 链关联的论点笔记 |
| `project_root` | path | ✓ | **绝对路径**——工作文件目录根 |
| `files` | object |   | key→相对路径，相对于 `project_root` |
| `external` | object |   | key→URL（data room / Notion 等） |
| `follow_on_priority` | enum |   | high / medium / low / never |

### `type: pipeline-deal`

| 字段 | 必填 | 说明 |
|---|---|---|
| `company` | ✓ |  |
| `source` | ✓ | 链人物（谁推过来的） |
| `first_contact_date` | ✓ |  |
| `current_stage` | ✓ | screening / meeting / dd / ic / pass |
| `recommended_amount` |   | 单位：万 |
| `recommended_valuation` |   | 投前估值 |
| `expected_decision_date` |   |  |
| `lead_partner` |   |  |
| `risk_score` |   | 1-10 |
| `opportunity_score` |   | 1-10 |
| `project_root`, `files`, `external` |   | 同 portfolio-company |

### `type: memo`

| 字段 | 必填 | 说明 |
|---|---|---|
| `deal` | ✓ | 链 portfolio 或 pipeline 笔记 |
| `round` | ✓ |  |
| `recommendation` | ✓ | invest / watch / pass |
| `recommended_amount` |   |  |
| `recommended_valuation` |   | 投前 |
| `date` | ✓ |  |
| `author` |   |  |
| `status` | ✓ | draft / internal-discussion / passed-ic / invested / passed / exited-ipo / exited-ma / written-off |

### `type: person`

| 字段 | 必填 | 说明 |
|---|---|---|
| `name` | ✓ |  |
| `role` | ✓ | founder / co-investor / lp / advisor / lawyer / ex-founder |
| `related_companies` |   | 链 list |
| `first_met` |   |  |
| `last_contact` |   |  |
| `contact_frequency` |   | weekly / monthly / quarterly / yearly |
| `wechat`, `email`, `linkedin`, `city` |   |  |

### `type: update`

| 字段 | 必填 | 说明 |
|---|---|---|
| `company` | ✓ | 链 portfolio 笔记 |
| `period` | ✓ | YYYY-Q? 或 YYYY-MM |
| `update_date` |   | 创始人发出日期 |
| `parsed_date` |   | 我整理进 vault 的日期 |

### `type: board-meeting` / `type: board-prep`

| 字段 | 必填 | 说明 |
|---|---|---|
| `company` | ✓ |  |
| `date` | ✓ |  |
| `phase` | ✓ (board-meeting) | preparing / met / summarized |
| `my_role` |   | director / observer / sit-in |
| `attendees` |   | wikilink list |
| `prep_doc` |   |  |
| `next_meeting` |   |  |

### `type: exit`

| 字段 | 必填 | 说明 |
|---|---|---|
| `company` | ✓ |  |
| `exit_type` | ✓ | ipo / ma / secondary / written-off / partial |
| `exit_date` | ✓ |  |
| `total_invested` | ✓ | 单位：万 |
| `exit_proceeds` | ✓ | 单位：万 |
| `final_moic` |   | proceeds / invested |
| `holding_months` |   |  |
| `irr` |   | 年化（如算过）|
| `buyer` |   | 链 |
| `key_terms` |   | list |
| `retrospective_link` |   | 链复盘笔记 |

### `type: exit-retrospective`

| 字段 | 必填 | 说明 |
|---|---|---|
| `company` | ✓ |  |
| `exit_record_link` | ✓ | 链对应 exit 笔记 |
| `original_memo_link` | ✓ | 链 memo |
| `date` | ✓ | 复盘日期 |
| `author` |   |  |

### `type: review`

| 字段 | 必填 | 说明 |
|---|---|---|
| `period` | ✓ | YYYY-W## / YYYY-MM / YYYY-Q? / YYYY |
| `date` | ✓ |  |

### `type: decision`

| 字段 | 必填 | 说明 |
|---|---|---|
| `company` | ✓ | 链 portfolio 或 pipeline |
| `decision_type` | ✓ | follow-on / no-follow-on / exit / down-round / sell-secondary / write-off |
| `date` | ✓ |  |
| `revisit_6mo` |   | 6 月后回访目标日期 |
| `revisit_12mo` |   | 12 月后回访目标日期 |

## 中英显示策略

字段名（key）一律 snake_case 英文。**显示中文**通过 Bases 视图的 `displayName` 实现：

```yaml
# bases/<view>.base
properties:
  note.runway_months:
    displayName: "Runway (月)"
  note.status:
    displayName: 状态
```

所以你在 Obsidian 里看到的列名仍是中文，但 YAML 里写的、Claude 解析的、跨工具迁移用的——都是干净英文。

## tags 命名

- `portfolio` / `pipeline` / `exited` —— 大类
- `sector/<行业-slug>` —— 行业（`sector/manufacturing`, `sector/saas`）
- `stage/<阶段>` —— 轮次（`stage/a`, `stage/seed`, `stage/buyout`）
- `lead` / `follow` —— 我方角色
- `flag/red` / `flag/yellow` —— 主动标记需关注

## 时间格式

- 日期：**ISO 强制**——`YYYY-MM-DD`
- 时间戳：`YYYY-MM-DD HH:MM`（24h）
- **不允许**：`2026/4/15`、`2026年4月15日`、`Apr 15, 2026`——会让 Bases 排序混乱

## 数字单位

- 金额：**万人民币**（统一）
- 占股：百分数（写 `3.5`，不写 `3.5%`，避免变 string）
- runway：月数

## "近期操作" 日志

放在每个项目笔记的最末（在复盘 section 之后）。每条一行：

```
- 2026-05-01 14:32 解析 4 月 update，runway 14→11 月
```

格式：`- <YYYY-MM-DD HH:MM> <一句话动作>`

## frontmatter 写回原则（Claude 硬约束）

1. 不要瞎猜值：缺数据问用户
2. 不要默默改用户已有值：改 estim 字段（估值 / 仓位 / 状态）必须 confirm
3. 改了一定写到日志：`## 近期操作` 加一行
4. 保持其他字段原状：只改要改的，别"顺手整理"

## 不变量

下面这些**永远不允许改**：

- 文件夹的数字前缀（0/1/2/3/4/5/6/7）
- `type` 枚举值（小写英文）
- 日期 ISO 格式
- 金额单位（万）
- frontmatter key 的 snake_case 风格

破坏不变量 = skill 行为不可预测。

## v0.3 → v0.4 字段名映射

| v0.3 (中文带空格) | v0.4 (snake_case 英文) |
|---|---|
| `公司` | `company` |
| `行业` | `industry` |
| `赛道` | `sector` |
| `我方轮次` | `our_round` |
| `我方角色` | `our_role` |
| `状态` | `status` |
| `首次投资日期` | `first_investment_date` |
| `我方累计投资` | `total_invested` |
| `我方累计占股` | `ownership_pct` |
| `最新估值-投后` | `latest_post_money_valuation` |
| `最近一轮日期` | `latest_round_date` |
| `当前 MOIC` | `current_moic` |
| `runway 月数` | `runway_months` |
| `月烧钱` | `monthly_burn` |
| `最近 update` | `last_update` |
| `下次复盘截止` | `next_review_due` |
| `首席创始人` | `primary_founder` |
| `团队规模` | `team_size` |
| `我的董事会角色` | `my_board_role` |
| `最近董事会` | `last_board_meeting` |
| `下次董事会` | `next_board_meeting` |
| `董事会频率` | `board_frequency` |
| `当前融资轮` | `current_funding_round` |
| `论点` | `thesis_link` |
| `follow-on 优先级` | `follow_on_priority` |
| `来源` (pipeline) | `source` |
| `首次接触` | `first_contact_date` |
| `当前阶段` | `current_stage` |
| `推荐金额` | `recommended_amount` |
| `推荐估值` | `recommended_valuation` |
| `预计投决日期` | `expected_decision_date` |
| `负责合伙人` | `lead_partner` |
| `风险打分` | `risk_score` |
| `机会打分` | `opportunity_score` |
| `轮次` (memo) | `round` |
| `推荐` (memo) | `recommendation` |
| `作者` | `author` |
| `姓名` | `name` |
| `角色` | `role` |
| `关联公司` | `related_companies` |
| `首次见面` | `first_met` |
| `最近联系` | `last_contact` |
| `联系频率` | `contact_frequency` |
| `邮箱` | `email` |
| `所在城市` | `city` |
| `我的角色` (board) | `my_role` |
| `出席` | `attendees` |
| `退出类型` | `exit_type` |
| `退出日期` | `exit_date` |
| `我方退出 proceeds` | `exit_proceeds` |
| `最终 MOIC` | `final_moic` |
| `持有月数` | `holding_months` |
| `IRR` | `irr` |
| `退出方/买家` | `buyer` |
| `关键条款` | `key_terms` |
| `退出复盘` | `retrospective_link` |
