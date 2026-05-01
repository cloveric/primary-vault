---
name: deal-router
description: "Use this skill whenever the user mentions a portfolio company, deal in pipeline, founder, memo, board meeting, exit/IPO/M&A, write-off, or asks for portfolio reviews / pipeline status / runway warnings / fund operations / post-investment management / exit retrospectives. Treats an Obsidian vault as the central index ('vault-as-router'): each project note's frontmatter maps to real working files (Excel models, PDF decks, DD folders) elsewhere on disk. Covers the full primary-market lifecycle: pipeline → memo → invest → board → updates → exit → retrospective. Applies to VC, PE, CVC, family office, search funds, angels, accelerators. After any work, append to the note's '近期操作' section and update relevant frontmatter fields. Do NOT trigger for generic Obsidian editing — use the obsidian-* skills for that."
metadata:
  short-description: Primary-market deal & portfolio operating system on Obsidian — vault-as-router for Claude Code / Codex
  trigger-aliases:
    - 一级投资管理
    - 私募项目管理
    - vc 项目管理
    - pe 项目管理
    - 投后管理
    - portfolio 复盘
    - pipeline 状态
    - runway 警报
    - 写 memo
    - 看 portfolio
    - 准备董事会
    - 项目退出
    - 退出复盘
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# deal-router

Operates a private-market fund's vault — Obsidian vault is the **index/router**, while real work files (Excel models, PDF decks, DD folders, contracts) live elsewhere on disk. Whenever the user mentions a portfolio company, deal, board meeting, or exit event, follow this skill's conventions to **route** to the right files, do the work, and **write back** an audit trail.

**Applies to:** VC, PE, CVC, family office direct investing, search funds, angels, accelerators — any **primary-market structured equity** workflow.

## ⚠️ Concurrent-edit safety (CRITICAL)

**If user has the same note open in Obsidian while you're editing it via Write/Edit, changes will collide.** Obsidian auto-saves on focus change and could overwrite your write, OR your write could overwrite their unsaved edits.

Before editing any vault note:

1. **Tell user**: "我要改 `<file>` —— 请先在 Obsidian 关闭这个笔记 (Cmd+W) 或点别处让 Obsidian 保存"
2. **Wait for user confirmation** before destructive Write
3. For minor frontmatter updates (`last_action`, `last_update` etc), low risk → can proceed but mention what you changed

**Strongly recommend** the user has `git init` in their vault — see `docs/INSTALL.md`. If something goes wrong, `git diff` shows what you wrote, `git checkout` reverts.

## Vault structure (canonical)

```
<vault-root>/
├── _dashboard.md
├── _thesis.md
├── _QUICKSTART.md
├── 0-pipeline/
│   ├── 1-初筛/, 2-meeting/, 3-DD中/, 4-IC/, 5-pass/
├── 1-portfolio/companies/   ← active portfolio
├── 2-exited/                ← IPO / M&A / write-off
├── 3-people/                ← founders, co-investors, LPs, advisors
├── 4-memos/                 ← investment memos (one per deal)
├── 5-updates/               ← quarterly portco updates
├── 6-board-notes/           ← board meeting prep + capture
├── 7-reviews/               ← weekly/monthly/quarterly/annual reviews
│   └── decisions/           ← decision logs (follow-on, write-off, etc)
└── bases/                   ← Bases views (.base files)
```

The vault root is the cwd when `claude` is started inside it, OR a configured path. Locate with `pwd` if `.obsidian/` exists in cwd or any parent, OR ask the user.

## Frontmatter schema (canonical, v0.4 snake_case English)

> 全部字段名详见 [docs/CONVENTIONS.md](../../docs/CONVENTIONS.md). 关键差异：
> - 字段名一律 **snake_case 英文**（v0.3 中文带空格已废弃）
> - 中文显示通过 Bases 的 `displayName` 实现

### Portfolio company (in `1-portfolio/companies/`)

```yaml
---
type: portfolio-company
company: 智能制造科技
industry: 高端制造
sector: 工业机器人
our_round: a                  # seed / angel / pre-a / a / b / buyout / growth
our_role: lead                # lead / follow / observer / safe
status: active                # active / struggling / fundraising / exited-ipo / exited-ma / written-off
first_investment_date: 2025-06-15
total_invested: 800           # 单位：万人民币
ownership_pct: 3.5
latest_post_money_valuation: 5700
latest_round_date: 2025-06-15
current_moic: 1.4
runway_months: 14
monthly_burn: 80
last_update: 2026-04-15
next_review_due: 2026-07-15
primary_founder: "[[李XX]]"
team_size: 25
my_board_role: observer       # director / observer / none
last_board_meeting: 2026-04-10
next_board_meeting: 2026-07-10
board_frequency: quarterly    # monthly / quarterly / semiannual
current_funding_round: none   # none / started / dd / ts-negotiation / signed / ipo-prep / ma-negotiation
thesis_link: "[[智能制造科技-论点]]"
project_root: /path/to/your/work/portfolio/智能制造科技
files:
  memo: ../../4-memos/智能制造科技-A轮-memo.md
  financial_model: financials/Q1-2026-model.xlsx
  pitch: decks/pitch-2026Q1.pdf
  dd_notes: DD/
external:
  data_room: https://docsend.com/v/xxx
follow_on_priority: high      # high / medium / low / never
last_action: 2026-05-01 14:32 更新 Q1 财务模型
tags: [portfolio, sector/manufacturing, stage/a, lead]
---
```

### Pipeline deal (in `0-pipeline/<阶段>/`)

```yaml
---
type: pipeline-deal
company: AI 芯片公司
source: "[[张三-推荐]]"
first_contact_date: 2026-04-20
current_stage: meeting        # screening / meeting / dd / ic / pass
recommended_amount: 300
recommended_valuation: 4000
expected_decision_date: 2026-05-15
lead_partner: 我
risk_score: 6
opportunity_score: 8
project_root: /path/to/your/work/pipeline/AI芯片公司
files:
  pitch: pitch-2026Q1.pdf
last_action: 2026-04-28 第一次见 founder
tags: [pipeline, sector/semi, stage/seed]
---
```

### Memo (in `4-memos/`)

```yaml
---
type: memo
deal: "[[智能制造科技]]"
round: a
recommendation: invest        # invest / watch / pass
recommended_amount: 200
recommended_valuation: 5500
date: 2026-04-15
author: 我
status: passed-ic             # draft / internal-discussion / passed-ic / invested / passed / exited-ipo / exited-ma / written-off
tags: [memo, stage/a]
---
```

### Person (in `3-people/`)

```yaml
---
type: person
name: 李XX
role: founder                 # founder / co-investor / lp / advisor / lawyer
related_companies: ["[[智能制造科技]]"]
first_met: 2025-05-01
last_contact: 2026-04-20
contact_frequency: monthly
wechat: lxx_wechat
email: lxx@example.com
tags: [people, founder]
---
```

### Update (in `5-updates/`)

```yaml
---
type: update
company: "[[]]"
period: 2026-Q1               # YYYY-Q? or YYYY-MM
update_date:
parsed_date:
tags: [update]
---
```

### Board meeting (in `6-board-notes/`)

```yaml
---
type: board-meeting
company: "[[智能制造科技]]"
date: 2026-04-10
phase: summarized             # preparing / met / summarized
my_role: observer
attendees: ["[[李XX-CEO]]", "[[红杉中国-合伙人]]", "[[我]]"]
prep_doc: ./<company>-<date>-board-prep.md
next_meeting: 2026-07-10
tags: [board, portco]
---
```

### Exit (in `2-exited/`)

```yaml
---
type: exit
company: "[[智能制造科技]]"
exit_type: ma                 # ipo / ma / secondary / written-off / partial
exit_date: 2027-08-15
total_invested: 800
exit_proceeds: 4500
final_moic: 5.625
holding_months: 26
buyer: "[[XX 上市公司]]"
key_terms:
  - 现金 70% / 股票 30%
  - 6 个月 lockup
retrospective_link: ./<company>-exit-retrospective.md
tags: [exited, exit/ma]
---
```

### Decision log (in `7-reviews/decisions/`)

```yaml
---
type: decision
company: "[[]]"
decision_type: follow-on      # follow-on / no-follow-on / exit / down-round / sell-secondary / write-off
date: 2026-05-01
revisit_6mo: 2026-11-01
revisit_12mo: 2027-05-01
tags: [decision]
---
```

## 14 Core actions

### Action 1 — Route from "company name" to real files

When user mentions a company name (in pipeline / portfolio / exited):

1. **Find the note**: `Glob` on `<vault>/{0-pipeline,1-portfolio,2-exited}/**/*<name>*.md`, OR `Grep` for `company: <name>`
2. **Read frontmatter** to get `project_root` and `files.*`
3. **If `project_root` missing**: ask user "这个项目的工作目录在哪？"——得到答案后**写回 frontmatter**
4. Resolve work file path: `<project_root>/<files.<key>>`
5. Use `Read` / `Bash` / appropriate tool
6. **After work**: see Action 14

### Action 2 — Add a new pipeline deal

When user says "今天见了 X 公司，A 轮，pre-money 4000 万":

1. Create `<vault>/0-pipeline/<stage>/<company>.md` (default stage: `2-meeting`)
2. Fill pipeline-deal frontmatter
3. If user mentioned a referrer, link to `3-people/` note (create stub if missing)

### Action 3 — Move deal through pipeline stages

When user says "X 公司进 DD 了" / "X 公司 pass 了":

1. Find note in `0-pipeline/`
2. `mv` to right stage subfolder
3. Update frontmatter `current_stage`
4. Append to "近期操作" + reason
5. If pass: ask + write "## Pass 原因"

### Action 4 — Write/update an investment memo

When user says "写 X 公司 A 轮 memo":

1. Locate or create `<vault>/4-memos/<company>-<round>-memo.md`
2. Use canonical 14-section template (see examples)
3. **Force section 13 (12-24 月里程碑预测)** —— refuse to skip; this is the self-reflection anchor
4. After invest: update memo `status: invested`, create / update portfolio-company note

### Action 5 — Parse incoming portco update

When user forwards/pastes a founder update:

1. Extract: month/quarter, key revenue/users/burn/runway, team changes, fundraising plans, requests
2. Create `<vault>/5-updates/<company>-<period>-update.md`
3. **Update portfolio company frontmatter**: `runway_months`, `monthly_burn`, `team_size`, `last_update`
4. Link new update from company note's "## Updates 时间线"
5. **Flag concerning trends**: runway < 6mo, burn 增 >30%, key team loss

### Action 6 — Periodic reviews

#### 每周 sweep ("周扫描")

1. List all `1-portfolio/companies/`
2. **🔴 Red**: `runway_months < 6`
3. **🟡 Yellow**: `runway_months` 6-9 OR `last_update` > 60 天 OR `next_review_due < today`
4. **🟢 Green**: 一切正常
5. Output table + 写到 `7-reviews/<YYYY>-W<##>-周扫描.md`

#### 季度 portfolio review ("Q<n> 复盘")

1. Walk every `1-portfolio/companies/*.md`
2. For each, ask 3 questions: 论点还成立吗 / 关键变量进展 / 仓位决策
3. Write to "## 复盘 <YYYY-Q<n>>"
4. Update `next_review_due: +90 天`
5. Generate `7-reviews/<YYYY>-Q<n>-portfolio-review.md`

#### 月报 ("做月报")

1. Aggregate from `5-updates/` + pipeline transitions
2. Compute: 本月新进 / pass / 新投 / portfolio 关键变化
3. List 待回访的决策日志（30+ 天前）
4. Output `7-reviews/<YYYY>-<MM>-月报.md`

### Action 7 — Board meeting prep

When user says "下周 X 公司董事会，帮我准备":

1. Read company note + last board note (if exists)
2. Identify open action items from previous meeting
3. Pull recent updates from `5-updates/`
4. Pull current frontmatter (KPIs, runway, team, milestones)
5. Generate `<vault>/6-board-notes/<company>-<YYYY-MM-DD>-board-prep.md` with:
   - 议程建议 / 上次开放项 follow-up / 关键 KPI 变化 / 我要问的硬问题 / 我要 push 的事项 / 风险警报 / 我之前 promise 的自查
6. Set portfolio note `next_board_meeting`（如未填）

### Action 8 — Board meeting capture

When user says "刚开完 X 公司董事会":

1. 询问关键决议、行动项、争议点
2. Create `<vault>/6-board-notes/<company>-<date>-board.md` with sections:
   - 关键决议 / 行动项（带 owner + due）/ 财务讨论 / 战略问题 / 风险讨论 / 我观察到的（非正式）/ 下次会议焦点
3. Update portfolio company `last_board_meeting` + `next_board_meeting`
4. Write back log

### Action 9 — Portfolio support tracking

When user says "我刚帮 X 介绍了 Y" 或 "founder 跟我说想要 X":

1. Find founder's `3-people/` note
2. Append to "## 互动记录": date + 内容 + status
3. In portfolio company note, append to "## 我帮过什么"
4. If unmet ask, add to "## 待跟进"

### Action 10 — Follow-on / down round 决策

When user says "X 公司要融下一轮" / "X 公司打算 down round":

1. Find portfolio note, update `current_funding_round`
2. **创建 decision log** at `7-reviews/decisions/<YYYY-MM-DD>-<company>-<decision_type>.md`:
   - 当前 thesis 状态 / 关键变量进展 / 估值合理性 / 是否 follow-on / 我可能错的地方
3. 设定 6 / 12 月后回访点（写进 frontmatter `revisit_6mo`, `revisit_12mo`）

### Action 11 — Exit recording (IPO / M&A / 二级 / 写零)

When user says "X 被收购了" / "X 上市" / "X 公司停了":

1. **询问退出细节**：类型 / 日期 / 退出估值 / 我方 proceeds / 关键条款（cash/stock 比例、lockup、earnout、escrow、tax）
2. **移动文件**: `mv 1-portfolio/companies/<company>.md 2-exited/<company>.md`
3. **更新 frontmatter**:
   - `status: exited-<type>` (or `written-off`)
   - 加 `exit_date`, `exit_proceeds`, `final_moic`, `holding_months`, `exit_type`
4. **创建退出记录** `2-exited/<company>-exit-record.md`
5. **Mark memo** `status: exited-<type>` (or `written-off`)
6. **触发**：提醒用户写退出复盘（Action 12）—— "建议你 24 小时-1 周内做退出复盘"
7. 在 `7-reviews/<YYYY>-<MM>-月报.md` 加一条退出 log

### Action 12 — Exit lessons retrospective

When user says "做 X 退出复盘":

1. Read all relevant context: memo（特别第 13 节）+ updates + board notes + decision logs
2. Ask 5 retrospective questions: thesis 校准 / 里程碑预测 / 关键决策 / 回报对比 / 下次改什么
3. Write to `<vault>/7-reviews/<company>-exit-retrospective.md`
4. **重要**：将关键 lessons 提炼到 `_thesis.md` 的"已投回头看"或"反 thesis"

### Action 13 — Exit pipeline / 退出准备追踪

When user says "X 公司开始上市辅导" / "X 公司有买家在谈":

1. 在 portfolio note 加 `current_funding_round: ipo-prep` 或 `ma-negotiation`
2. 创建追踪笔记 `<vault>/2-exited/_pipeline/<company>-exit-tracking.md`:
   - 关键时间表 / 我方关心问题 / 我方 action items
3. 设定提醒：每 30 天主动追踪进展

### Action 14 — Write-back (after EVERY action)

**Mandatory** —— skill 的纪律性核心：

1. Append to note's `## 近期操作` section: `- YYYY-MM-DD HH:MM <动作>`
2. Update frontmatter `last_action: YYYY-MM-DD HH:MM <动作>`
3. 改 frontmatter 关键字段后保留其他字段不动
4. 用 `date` 命令拿当前时间戳

## Edge cases

- **同名公司**：列出来让用户挑
- **frontmatter 字段缺失**：不要假设，问用户；得答案后**写回**
- **vault 路径约定**：尊重 user-level overrides。Look in `<vault>/.claude/skills/deal-router/SKILL.md` for vault-specific overrides
- **跨 vault**：初见时让用户告知当前 cwd 是哪个
- **新公司没目录**：先 `mkdir -p <project_root>` 再建笔记
- **退出的公司被错误改回 active**：拒绝并要求用户解释

## What NOT to do

- 不要把所有原始 PDF / Excel 拷进 vault
- 不要写 memo 时跳过"12-24 月里程碑预测"
- 不要忘记 write-back（每次 → "近期操作" + `last_action`）
- 不要瞎猜 frontmatter 字段值
- 不要在不告诉用户的情况下改 portfolio 公司的 frontmatter 关键字段
- 不要在没问明退出条款的情况下擅自归档退出公司
- 不要跳过退出复盘提醒（Action 12 触发）

## Bases views — 仅作 filter 规范参考

Vault `bases/` 目录下的 `.base` 文件**不能被 Claude 直接调用**（Bases 是 Obsidian UI 渲染，不是 query API）。但你可以：

- **读 .base 文件的 YAML** 当作 filter 规范——例如 `runway-警报.base` 告诉你 "runway < 9 月" 的过滤标准
- **用 Glob + Grep + 手动过滤** 复刻 Bases 的查询逻辑：

```bash
# 例子：复刻 runway-警报 视图
# 列出所有 1-portfolio/companies/*.md，frontmatter runway_months < 9，按 runway 升序
```

如果用户在 dashboard 看到的视图跟你给出的列表不一致，是因为 Bases 实时渲染 vs 你 Glob 时间不同，正常。
