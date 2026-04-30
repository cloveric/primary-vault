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

## Vault structure (canonical)

```
<vault-root>/
├── _dashboard.md
├── _thesis.md
├── 0-pipeline/
│   ├── 1-初筛/, 2-meeting/, 3-DD中/, 4-IC/, 5-pass/
├── 1-portfolio/companies/   ← active portfolio
├── 2-exited/                ← IPO / M&A / write-off (永久保留复盘用)
├── 3-people/                ← founders, co-investors, LPs, advisors
├── 4-memos/                 ← investment memos (one per deal)
├── 5-updates/               ← quarterly portco updates
├── 6-board-notes/           ← board meeting prep + capture
├── 7-reviews/               ← weekly/monthly/quarterly/annual reviews + exit retros
└── bases/                   ← Bases views (.base files)
```

The vault root is the cwd when `claude` is started inside it, OR a configured path. Locate it with: `pwd` if there's `.obsidian/` in cwd or any parent, OR ask the user.

## Frontmatter schema (canonical)

### Portfolio company (in `1-portfolio/companies/`)

```yaml
---
type: portfolio-company
公司: 智能制造科技
行业: 高端制造
赛道: 工业机器人
我方轮次: A
我方角色: 领投
状态: active            # active / struggling / 融资中 / exited-ipo / exited-ma / 写零
首次投资日期: 2025-06-15
我方累计投资: 800
我方累计占股: 3.5
最新估值-投后: 5700
最近一轮日期: 2025-06-15
当前 MOIC: 1.4
runway 月数: 14
月烧钱: 80
最近 update: 2026-04-15
下次复盘截止: 2026-07-15
首席创始人: "[[李XX]]"
团队规模: 25
我的董事会角色: observer
最近董事会: 2026-04-10
下次董事会: 2026-07-10
董事会频率: 季           # 月 / 季 / 半年
当前融资轮: 无           # 无 / 已启动 / 投资人尽调中 / TS 谈判 / 已签
论点: "[[智能制造科技-论点]]"
project_root: /path/to/your/work/portfolio/智能制造科技
files:
  memo: ../../4-memos/智能制造科技-A轮-memo.md
  财务模型: financials/Q1-2026-model.xlsx
  pitch: decks/pitch-2026Q1.pdf
  DD笔记: DD/
  合同: contracts/
  会议纪要: meetings/
external:
  data_room: https://docsend.com/v/xxx
follow-on 优先级: 高
last_action: 2026-05-01 14:32 更新 Q1 财务模型
tags: [portfolio, sector/manufacturing, stage/a, lead]
---
```

### Pipeline deal (in `0-pipeline/<阶段>/`)

```yaml
---
type: pipeline-deal
公司: AI 芯片公司
来源: "[[张三-推荐]]"
首次接触: 2026-04-20
当前阶段: meeting        # 初筛 / meeting / DD中 / IC / pass
推荐金额: 300
推荐估值: 4000
预计投决日期: 2026-05-15
负责合伙人: 我
风险打分: 6
机会打分: 8
project_root: /path/to/your/work/pipeline/AI芯片公司
last_action: 2026-04-28 第一次见 founder
tags: [pipeline, sector/semi, stage/seed]
---
```

### Memo (in `4-memos/`)

```yaml
---
type: memo
deal: "[[智能制造科技]]"
轮次: A
推荐: 投
推荐金额: 200
推荐估值: 5500
date: 2026-04-15
作者: 我
状态: 通过IC             # 草稿 / 内部讨论 / 通过IC / 已投 / pass / 已退出-ipo / 已退出-ma / 已写零
tags: [memo, stage/a]
---
```

### Person (in `3-people/`)

```yaml
---
type: person
姓名: 李XX
角色: founder            # founder / co-investor / LP / advisor / lawyer
关联公司: ["[[智能制造科技]]"]
首次见面: 2025-05-01
最近联系: 2026-04-20
联系频率: 月
微信: lxx_wechat
邮箱: lxx@example.com
tags: [people, founder]
---
```

### Update (in `5-updates/`)

```yaml
---
type: update
公司: "[[]]"
period: 2026-Q1          # 季度 or YYYY-MM
update_date:
parsed_date:
tags: [update]
---
```

### Board meeting (in `6-board-notes/`)

```yaml
---
type: board-meeting
公司: "[[智能制造科技]]"
date: 2026-04-10
phase: 实开              # 准备 / 实开 / 已总结
我的角色: observer
出席: ["[[李XX-CEO]]", "[[红杉中国-合伙人]]", "[[我]]"]
prep_doc: ./<公司>-<date>-board-prep.md
next_meeting: 2026-07-10
tags: [board, portco]
---
```

### Exit (in `2-exited/`)

```yaml
---
type: exit
公司: "[[智能制造科技]]"
退出类型: ma             # ipo / ma / secondary / 写零 / 部分退出
退出日期: 2027-08-15
我方累计投资: 800
我方退出 proceeds: 4500
最终 MOIC: 5.625
持有月数: 26
退出方/买家: "[[XX 上市公司]]"
关键条款:
  - 现金 70% / 股票 30%
  - 6 个月 lockup
  - 5% 业绩 earnout 12 月
退出复盘: ./<公司>-exit-retrospective.md
tags: [exited, exit/ma]
---
```

## 14 Core actions

### Action 1 — Route from "company name" to real files

When user mentions a company name (in pipeline / portfolio / exited):

1. **Find the note**: `Glob` on `<vault>/{0-pipeline,1-portfolio,2-exited}/**/*<name>*.md`, OR `Grep` for `公司: <name>`
2. **Read frontmatter** to get `project_root` and `files.*`
3. **If `project_root` missing**: ask user "这个项目的工作目录在哪？"——得到答案后**写回 frontmatter**
4. Resolve work file path: `<project_root>/<files.<key>>`
5. Use `Read` / `Bash` / appropriate tool to operate
6. **After work**: see Action 14

### Action 2 — Add a new pipeline deal

When user says e.g. "今天见了 X 公司，A 轮，pre-money 4000 万":

1. Create `<vault>/0-pipeline/<stage>/<公司名>.md` (default stage: `2-meeting`)
2. Fill pipeline-deal frontmatter
3. If user mentioned a referrer, link to their `3-people/` note (create stub if missing)

### Action 3 — Move deal through pipeline stages

When user says "X 公司进 DD 了" / "X 公司 pass 了":

1. Find note in `0-pipeline/`
2. `mv` to right stage subfolder
3. Update frontmatter `当前阶段`
4. Append to "近期操作" + reason
5. If pass: ask + write "## Pass 原因" section

### Action 4 — Write/update an investment memo

When user says "写 X 公司 A 轮 memo" or "更新 X 公司 memo":

1. Locate or create `<vault>/4-memos/<公司>-<轮次>-memo.md`
2. Use canonical 14-section template (see examples)
3. **Force section 13 (12-24 月里程碑预测)** — refuse to skip
4. After invest: update memo `状态: 已投`, create / update portfolio-company note

### Action 5 — Parse incoming portco update

When user forwards/pastes a founder update (PDF / email / wechat screenshot):

1. Extract: month/quarter, key revenue/users/burn/runway, team changes, fundraising plans, requests
2. Create `<vault>/5-updates/<公司>-<period>-update.md`
3. **Update portfolio company frontmatter**: `runway 月数`, `月烧钱`, `团队规模`, `最近 update`
4. Link new update file from company note's "## Updates 时间线"
5. **Flag concerning trends**: runway < 6mo, burn 增 >30%, key team loss

### Action 6 — Periodic reviews

#### 每周 sweep ("周扫描")

1. List all `1-portfolio/companies/`
2. **🔴 Red**: runway < 6 月
3. **🟡 Yellow**: runway 6-9 月 OR 沉默 60-90 天 OR 下次复盘截止 < today
4. **🟢 Green**: 一切正常
5. Output table + 写到 `7-reviews/<YYYY>-W<##>-周扫描.md`

#### 季度 portfolio review ("Q<n> 复盘")

1. Walk every `1-portfolio/companies/*.md`
2. For each, ask 3 questions:
   - 论点还成立吗？
   - 关键变量进展？
   - 仓位决策（保持/加仓/减仓/退出）？
3. Write user's answer to "## 复盘 <YYYY-Q<n>>"
4. Update `下次复盘截止: +90 天`
5. Generate `7-reviews/<YYYY>-Q<n>-portfolio-review.md`

#### 月报 ("做月报")

1. Aggregate from `5-updates/` + pipeline transitions
2. Compute: 本月新进 pipeline / pass / 新投 / portfolio 关键变化
3. List 待回访的决策日志（30+ 天前）
4. Output `7-reviews/<YYYY>-<MM>-月报.md`

### Action 7 — Board meeting prep

When user says "下周 X 公司董事会，帮我准备" / "为 X 准备本月董事会":

1. Read company note + last board note (if exists)
2. Identify open action items from previous meeting
3. Pull recent updates from `5-updates/`
4. Pull current frontmatter (KPIs, runway, team size, milestone progress)
5. Generate `<vault>/6-board-notes/<公司>-<YYYY-MM-DD>-board-prep.md` with:
   - **议程建议**（finance / product / hiring / fundraise / strategic）
   - **上次开放项 follow-up**（done / open / 推迟 + 原因）
   - **关键 KPI 变化**（季度对比 + memo 预测对比）
   - **我要问的硬问题**（运营异常 / 论点变量恶化）
   - **我要 push 的事项**（add value 触达点）
   - **风险 / 警报**（runway, key person, 客户集中）
6. Set portfolio note frontmatter `下次董事会` 字段（如未填）

### Action 8 — Board meeting capture

When user says "刚开完 X 公司董事会":

1. 询问关键决议、行动项、争议点
2. Create `<vault>/6-board-notes/<公司>-<date>-board.md` with frontmatter + sections:
   - 关键决议
   - 行动项 / Action items（每条带 owner + due）
   - 财务 / 业务进展讨论
   - 战略问题
   - 风险讨论
   - 我观察到的（非正式）
   - 下次会议焦点
3. Update portfolio company `最近董事会` + `下次董事会`
4. Write back log

### Action 9 — Portfolio support tracking

When user says "我刚帮 X 公司介绍了 Y" 或 "founder 跟我说想要 X":

1. Find founder's `3-people/` note
2. Append to "## 互动记录": date + 内容 + status
3. In portfolio company note, append to "## 我帮过什么"
4. If unmet ask, add to "## 待跟进"

### Action 10 — Follow-on / down round 决策

When user says "X 公司要融下一轮" / "X 公司打算 down round":

1. Find portfolio note
2. **更新 frontmatter `当前融资轮`** 为对应阶段
3. **创建 decision log** at `7-reviews/decisions/<YYYY-MM-DD>-<公司>-follow-on.md`:
   - 当前 thesis 状态
   - 关键变量进展
   - 估值合理性
   - 是否 follow-on / 多少
   - 我可能错的地方
4. 设定 6 / 12 个月后回头看的预设回访点

### Action 11 — Exit recording (IPO / M&A / 二级 / 写零)

When user says "X 公司被收购了" / "X 上市了" / "X 做二级转让" / "X 公司停了":

1. **询问退出细节**：
   - 类型（ipo / ma / secondary / 写零 / 部分退出）
   - 日期
   - 退出估值 / 我方 proceeds
   - 关键条款（cash/stock 比例、lockup、earnout、escrow、tax）
2. **移动文件**: `mv 1-portfolio/companies/<公司>.md 2-exited/<公司>.md`
3. **更新 frontmatter**:
   - `状态: exited-<类型>`
   - 加 `退出日期`, `退出 proceeds`, `最终 MOIC`, `持有月数`
4. **创建退出记录** `2-exited/<公司>-exit-record.md`（用 exit type frontmatter）
5. **Mark memo** `状态: 已退出-<类型>`
6. **触发**：提醒用户写退出复盘（Action 12）—— "建议你 24 小时内 / 1 周内做退出复盘"
7. 在 `7-reviews/<YYYY>-<MM>-月报.md` 加一条退出 log

### Action 12 — Exit lessons retrospective

When user says "做 X 退出复盘":

1. Read all relevant context:
   - Original memo（特别是第 13 节 12-24 月里程碑预测）
   - 所有 updates
   - 所有 board notes
   - 所有 decision logs
2. Ask 5 retrospective questions:
   - **Thesis 校准**：当初投资 thesis 哪几条对了？哪几条错了？
   - **里程碑预测**：memo 第 13 节预测对比实际？
   - **关键决策回头看**：每次 follow-on / 不 follow-on / 抛售 时机正确吗？
   - **回报对比预期**：实际 MOIC vs 当时 expected case？
   - **下次类似 deal 我会改什么**？
3. Write to `<vault>/7-reviews/<公司>-exit-retrospective.md`
4. **重要**：将关键 lessons 提炼到 `_thesis.md` 的"已投回头看"或"反 thesis" section

### Action 13 — Exit pipeline / 退出准备追踪

When user says "X 公司开始上市辅导" / "X 公司有买家在谈":

1. 在 portfolio note frontmatter 加 `当前融资轮: 上市辅导中` 或 `M&A 谈判中`
2. 创建追踪笔记 `<vault>/2-exited/_pipeline/<公司>-exit-tracking.md`:
   - 关键时间表（上市辅导期 / 申报 / 上会 / 路演 / 上市；或 LOI / DD / SPA / closing）
   - 我方关心问题（lockup / 距 distribute LP 时间 / tax）
   - 我方 action items
3. 设定提醒：每 30 天主动追踪进展

### Action 14 — Write-back (after EVERY action)

**Mandatory** —— skill 的纪律性核心：

1. Append to note's `## 近期操作` section: `- YYYY-MM-DD HH:MM <动作>`
2. Update frontmatter `last_action: YYYY-MM-DD HH:MM <动作>`
3. 改了 frontmatter 关键字段后保留其他字段不动
4. 如果用户没说时间戳但你能推测，用 `date` 命令拿当前

例：

```markdown
## 近期操作

- 2026-05-01 14:32 解析 4 月 update，runway 14→11 月，已加警报
- 2026-04-28 09:15 IC 决定加仓 200 万
- 2026-04-15 10:00 准备本月董事会，列了 5 个硬问题
```

## Edge cases

- **同名公司**：列出来让用户挑
- **frontmatter 字段缺失**：不要假设，问用户；得答案后**写回**
- **vault 路径约定**：尊重 user-level overrides。Look in `<vault>/.claude/skills/deal-router/SKILL.md` for vault-specific overrides
- **跨 vault**：初见时让用户告知当前 cwd 是哪个
- **新公司没目录**：先 `mkdir -p <project_root>` 再建笔记
- **退出的公司被错误改回 active**：拒绝并要求用户解释（罕见情况，如 SPAC 解约）

## What NOT to do

- 不要把所有原始 PDF / Excel 拷进 vault
- 不要写 memo 时跳过"12-24 月里程碑预测"
- 不要忘记 write-back（每次 → "近期操作" + `last_action`）
- 不要瞎猜 frontmatter 字段值
- 不要在不告诉用户的情况下改 portfolio 公司的 frontmatter 关键字段
- 不要在没问明退出条款的情况下擅自归档退出公司
- 不要跳过退出复盘提醒（Action 12 触发）—— 这是基金学习曲线的关键

## Bases views (helper, optional)

- `runway-警报.base` — runway < 6 月
- `沉默90天.base` — 最近 update > 90 天
- `董事会due.base` — 下次董事会在未来 14 天内
- `follow-on-候选.base` — 当前融资轮 ≠ 无 AND follow-on 优先级 = 高
- `pipeline-漏斗.base` — pipeline 各阶段计数
- `复盘due.base` — 下次复盘截止 < today
- `退出追踪.base` — 当前融资轮 含 "退出" 或 "上市辅导" 或 "M&A"
