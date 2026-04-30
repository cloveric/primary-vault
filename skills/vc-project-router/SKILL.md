---
name: vc-project-router
description: "Use this skill whenever the user mentions a portfolio company, deal in pipeline, founder, memo, or asks for portfolio reviews / pipeline status / runway warnings / fund operations. Treats an Obsidian vault as the central index ('vault-as-router'): each project note's frontmatter maps to real working files (Excel models, PDF decks, DD folders) elsewhere on disk. After any work, append to the note's '近期操作' section and update relevant frontmatter fields. Do NOT trigger for generic Obsidian editing — use the obsidian-* skills for that."
metadata:
  short-description: VC operating system on Obsidian — vault-as-router for Claude Code / Codex
  trigger-aliases:
    - 一级投资管理
    - vc 项目管理
    - portfolio 复盘
    - pipeline 状态
    - runway 警报
    - 写 memo
    - 看 portfolio
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# vc-project-router

This skill operates a VC fund's vault — the Obsidian vault is the **index/router**, while real work files (Excel models, PDF decks, DD folders, contracts) live elsewhere on disk. Whenever the user mentions a portfolio company or deal, follow this skill's conventions to **route** to the right files, do the work, and **write back** an audit trail.

## Vault structure (canonical)

```
<vault-root>/
├── _dashboard.md
├── _thesis.md
├── 0-pipeline/
│   ├── 1-初筛/, 2-meeting/, 3-DD中/, 4-IC/, 5-pass/
├── 1-portfolio/companies/   ← active portfolio
├── 2-exited/                ← IPO / M&A / write-off
├── 3-people/                ← founders, co-investors, LPs, advisors
├── 4-memos/                 ← investment memos (one per deal)
├── 5-updates/               ← quarterly portco updates
├── 6-board-notes/
├── 7-reviews/               ← weekly/monthly/quarterly/annual
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
我方角色: 领投          # 领投 / 跟投 / observer / SAFE
状态: active            # active / struggling / exited-ipo / exited-ma / 写零
首次投资日期: 2025-06-15
我方累计投资: 800        # 单位：万人民币
我方累计占股: 3.5        # 百分比
最新估值-投后: 5700      # 单位：万
最近一轮日期: 2025-06-15
当前 MOIC: 1.4
runway 月数: 14
月烧钱: 80
最近 update: 2026-04-15
下次复盘截止: 2026-07-15
首席创始人: "[[李XX]]"
团队规模: 25
我的董事会角色: observer  # 董事 / observer / 无
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
  notion: https://notion.so/xxx
follow-on 优先级: 高     # 高 / 中 / 低 / 不再投
last_action: 2026-05-01 14:32 更新 Q1 财务模型
tags: [portfolio, sector/manufacturing, stage/a, lead]
---
```

### Pipeline deal (in `0-pipeline/<阶段>/`)

```yaml
---
type: pipeline-deal
公司: AI 芯片公司
来源: "[[张三-推荐]]"     # 谁推过来的
首次接触: 2026-04-20
当前阶段: meeting        # 初筛 / meeting / DD中 / IC / pass
推荐金额: 300            # 单位：万
推荐估值: 4000
预计投决日期: 2026-05-15
负责合伙人: 我
风险打分: 6              # 1-10
机会打分: 8
project_root: /path/to/your/work/pipeline/AI芯片公司
files:
  pitch: pitch-2026Q1.pdf
  财务: financials/projections.xlsx
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
推荐: 投                 # 投 / 继续观察 / pass
推荐金额: 200            # 单位：万
推荐估值: 5500           # 投前
date: 2026-04-15
作者: 我
状态: 通过IC             # 草稿 / 内部讨论 / 通过IC / 已投 / pass
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
联系频率: 月             # 周 / 月 / 季 / 年
微信: lxx_wechat
邮箱: lxx@example.com
linkedin: https://linkedin.com/in/lxx
tags: [people, founder]
---
```

## Core action 1 — Route from "company name" to real files

When the user mentions a company name (in pipeline OR portfolio):

1. **Find the note**: `Glob` on `<vault>/{0-pipeline,1-portfolio,2-exited}/**/*<name>*.md`, OR `Grep` for `公司: <name>` if name is partial
2. **Read frontmatter** to get `project_root` and `files.*`
3. **If `project_root` is missing or unset**: ask the user "这个项目的工作目录在哪？" — **then write the answer back to the note's frontmatter** so next time it's automatic
4. Resolve work file path: `<project_root>/<files.<key>>`
5. Use `Read` / `Bash` / appropriate tool to operate on the file
6. **After the work**: see "Action 6 — Write-back" below

## Core action 2 — Add a new pipeline deal

When the user says e.g. "今天见了 X 公司，A 轮，pre-money 估值 4000 万":

1. Create new file at `<vault>/0-pipeline/<stage>/<公司名>.md` (default stage: `2-meeting`)
2. Fill the pipeline-deal frontmatter from what user said (ask only for fields user didn't mention)
3. If user mentioned a referrer, link to that person's note in `3-people/` (create stub if missing)
4. Confirm path back to user

## Core action 3 — Move a deal through pipeline stages

When user says "X 公司进 DD 了" or "X 公司 pass 了":

1. Find note in `0-pipeline/`
2. `mv` to the right stage subfolder
3. Update frontmatter `当前阶段` field
4. Append to "近期操作" with timestamp + reason
5. If pass: optionally write a one-line "为什么 pass" into the note's `## Pass 原因` section (ask user if not provided)

## Core action 4 — Write/update an investment memo

When user says "写 X 公司 A 轮 memo" or "更新 X 公司的 memo":

1. Locate or create at `<vault>/4-memos/<公司>-<轮次>-memo.md`
2. Use the canonical memo template (see `examples/智能制造科技-A轮-memo.md` in this repo for the structure: 13 sections including 一句话总结、What、Why Now、Why This Team、TAM、竞争、商业模式、Traction、估值条款、Risks Top 5、退出路径、We Add Value、12-24 月里程碑预测、下一步)
4. **Force section 13 (12-24 月里程碑预测)** — refuse to skip; this is the self-reflection anchor for future review

## Core action 5 — Parse incoming portco update

When user forwards/pastes an investor update (PDF / email / wechat screenshot text):

1. Extract: month, key revenue/users/burn/runway numbers, team changes, fundraising plans, requests
2. Create `<vault>/5-updates/<公司>-<YYYY-MM>-update.md` with the structured extract
3. **Update the portfolio company's frontmatter** with new numbers: `runway 月数`, `月烧钱`, `团队规模`, `最近 update`
4. Link the new update file from the company note's "## Updates 时间线" section
5. **Flag any concerning trends** in the response (runway < 6 months, burn 增加 > 30%, 团队减员, 等)

## Core action 6 — Write-back (after EVERY action)

This is mandatory:

1. Append to the note's `## 近期操作` section: `- YYYY-MM-DD HH:MM <动作描述>`
2. Update frontmatter `last_action: YYYY-MM-DD HH:MM <动作>`
3. If you changed any frontmatter (e.g. updated runway after parsing an update), keep the rest of the frontmatter intact — only modify the relevant fields

Example write-back snippet:

```markdown
## 近期操作

- 2026-05-01 14:32 解析 4 月 update，runway 从 14 月降到 11 月，已加警报
- 2026-04-28 09:15 IC 讨论决定加仓 200 万
- ...
```

## Core action 7 — Periodic reviews

### 每周 sweep
When user says "周扫描" or "本周 portfolio 状态":

1. List all `1-portfolio/companies/` notes
2. Flag those where `runway 月数` < 6 (red) or 6–9 (yellow)
3. Flag those where `最近 update` is > 60 days ago
4. Flag those where `下次复盘截止` < today
5. Output a markdown table sorted by urgency

### 季度 portfolio review
When user says "Q<n> 复盘":

1. Walk every `1-portfolio/companies/*.md`
2. For each, ask user 3 questions: 论点还成立吗 / 关键变量变了吗 / 仓位 (follow-on 优先级) 调整吗
3. Write user's answer into the company note's "## 复盘 <YYYY-Q<n>>" section
4. Update `下次复盘截止` to +90 days
5. After all companies done, generate `7-reviews/<YYYY>-Q<n>-portfolio-review.md` — a summary doc

### 月报
When user says "做月报":

1. Aggregate from `5-updates/` and pipeline transitions
2. Compute: 本月新进 pipeline 数 / 本月 pass 数 / 本月新投 / 本月 portfolio 关键变化（runway / burn / valuation 变动）
3. List 待回访的决策（30+ 天前的决策日志）
4. Output `7-reviews/<YYYY>-<MM>-月报.md`

## Edge cases

- **同名公司**：vault 里如果有两家同名公司，列出来让用户挑
- **frontmatter 字段缺失**：不要假设，问用户；得到答案后**写回 frontmatter**
- **用户改了 vault 路径约定**：尊重 user-level overrides。Look in `<vault>/.claude/skills/vc-project-router/SKILL.md` for vault-specific overrides
- **跨 vault**：如果用户有多个 vault（个人 + 工作 + 基金），在初次见面时让用户告知当前 cwd 是哪个 vault
- **新公司没目录**：用户说要建新 portfolio，先 `mkdir -p <project_root>` 再建笔记

## What NOT to do

- 不要把所有原始 PDF / Excel 拷进 vault — vault 是索引层，原文件留在 `project_root`
- 不要写 memo 时跳过"12-24 月里程碑预测"——这是 self-reflection 工具，必须留
- 不要忘记 write-back（每次动作都要更新"近期操作"+ `last_action`）
- 不要瞎猜 frontmatter 字段值——缺失就问，问到就写回
- 不要在不告诉用户的情况下改任何 portfolio 公司的 frontmatter 关键字段（估值、仓位、状态）——要 confirm

## Bases views (helper, optional)

If the vault has `bases/` directory with `.base` files, use them when generating reports — they're the user's pre-built filters. Common ones to expect:

- `runway-警报.base` — runway < 6 月的 portfolio
- `沉默90天.base` — 最近 update > 90 天
- `follow-on-候选.base` — follow-on 优先级 = 高
- `pipeline-漏斗.base` — pipeline 各阶段计数
- `复盘due.base` — 下次复盘截止 < today
