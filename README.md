# primary-vault

> **一级市场投资项目管理 OS · 全生命周期：pipeline → memo → 投后 → 退出**
>
> A private-market operating system covering the **full deal lifecycle**: pipeline → memo → invest → board management → portfolio updates → exit → retrospective. Driven by Claude Code / Codex CLI through the **vault-as-router** pattern on your Obsidian vault.
>
> 适用 · Applies to: **VC · PE · CVC · 家族办公室 · search fund · angel · accelerator** —— 任何一级市场结构化股权投资

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Obsidian](https://img.shields.io/badge/Obsidian-Bases-7c3aed)](https://obsidian.md)
[![Skill compatible](https://img.shields.io/badge/skill-Claude%20Code%20%2B%20Codex-blueviolet)](skills/deal-router/SKILL.md)
[![Status](https://img.shields.io/badge/status-v0.4.0-brightgreen)](CHANGELOG.md)

---

## 🌟 这是什么 · What is this?

一套给 **一级市场投资人**（VC / PE / CVC / 家族办公室 / 天使 / search fund / 创业孵化器）用的 **全生命周期项目管理操作系统**。

A full-lifecycle project-management operating system for **primary-market investors** (VC, PE, CVC, family office, angel, search funds, accelerators).

**核心特点 · Key features:**

- 📂 **Vault-as-router**——Obsidian vault 当中央索引（不是仓库），vault 存元数据 + 决策思考，原始文件（Excel / PDF / DD 资料）留在你工作目录里
  Obsidian as **central index** (not file repo). Vault stores metadata + thinking; raw files stay in your work directory.

- 🤖 **Claude Code / Codex 当智能调度员**——你说一句话，agent 通过 frontmatter 自动路由到真实文件干活
  AI as **intelligent dispatcher**. Say what you want; agent routes via frontmatter map.

- 🎯 **全生命周期 14 个核心动作 · Full deal lifecycle (14 core actions):**
  - **投前**：pipeline 录入 / 阶段流转 / memo 起草（13 节强制结构）
  - **投中**：投决记录 / 条款追踪 / 决策日志
  - **投后**：update 解析 / 董事会准备 / 董事会捕获 / 投后支持追踪 / follow-on 决策
  - **退出**：IPO / M&A / 二级 / 写零 全场景 + 退出复盘 + lesson 回写 thesis
  
  Pipeline / memo / invest / **board mgmt / updates / exit / retro** — covered end-to-end.

- 📝 **Memo + 决策日志 + 退出复盘三重记录**——投前 thesis 落字、每次重大决策 5 分钟反省、退出后强制回头校准 thesis
  **Triple-record discipline**: pre-investment thesis, decision logs at every major call, mandatory exit retrospective that updates your fund thesis.

- 🏛️ **董事会准备 / 捕获自动化**——开会前自动收集议程 / KPI 变化 / 上次开放项 / 我要问的硬问题；开完一句话变结构化 board note
  **Automated board prep + capture**: agenda + KPI deltas + open items + your hard questions before; structured action items + decisions captured after.

- 📊 **Bases 视图自动复盘**——runway 警报 / 沉默 90 天 / 董事会 due / follow-on 候选 / pipeline 漏斗 / 退出追踪，全部 frontmatter-driven
  **Bases-driven reviews:** all key alerts driven by frontmatter, zero plugins.

- 🔓 **完全自主可控**——plaintext markdown，没有 SaaS 锁定，不依赖任何托管服务
  **Fully self-owned:** plaintext markdown, no SaaS lock-in.

---

## 🎯 适合谁 · Who is this for?

✅ **强烈推荐**给：

- 已经在用 **Obsidian** 做笔记的投资人 / 投资经理 / 分析师
- 已经习惯用 **Claude Code 或 Codex CLI** 处理工作的 power user
- 不想被 **Notion / Affinity / DealCloud / SaaS** 锁住数据的独立投资人
- VC / PE / CVC / 家办 / search fund / 天使，**任何阶段、任何规模**的私募投资人
- 一年看 50+ 项目、投 5-15 个、需要**纪律性思考记录**而不是花式 dashboard 的人
- 喜欢 **plaintext + 命令行 + AI 原生**工作流的人

❌ **不适合**：

- 完全不用命令行、只想点鼠标的用户（这套需要至少能复制粘贴 shell 命令）
- 团队 5+ 人、需要实时协作 + 权限管理（Notion / DealCloud 更合适）
- 投后管理重视频会议而不是结构化数据的（这套帮不上忙）
- 觉得"配置工具花时间"是浪费、宁愿用现成 SaaS 凑合的（请用 Affinity）

---

## 🧠 核心设计：vault-as-router · Core Design

### 一句话比喻 · The metaphor in one sentence

把 Obsidian vault 当 **机场塔台**：

Think of your Obsidian vault as **an airport control tower**:

- ✈️ **飞机**（你的 Excel 模型 / PDF 路演 / DD 资料）停在停机坪上 ←→ stored in `~/work/portfolio/<公司>/`
- 🗼 **塔台**（vault）**不开飞机**——它只知道每架飞机停在哪 ← stores metadata + pointers
- 🎙️ 你跟塔台说 "调度 23 号停机位的飞机做 X" → 塔台告诉调度员（Claude）该去哪 → Claude 自动飞过去干活

vault 不存原始文件，**它存索引、状态、决策、关联**—— 这是给 Claude Code 看的导航地图。

The vault doesn't store raw files. It stores **the index, status, decisions, and relations** — a navigation map that Claude Code reads.

### 为什么不直接把所有文件塞进 vault · Why not just dump everything into the vault?

很多人初次用 Obsidian 会冲动把所有 PDF / Excel 拖进 vault。后果：

A common mistake — dumping all PDFs and Excels into the vault. Consequences:

| 问题 · Problem | 后果 · Consequence |
|---|---|
| Vault 越来越臃肿 | 同步慢、备份大、Obsidian 启动慢 |
| 二进制文件不可全文搜 | Vault 失去核心价值 |
| 协作困难 | 律师 / 会计 / 共投人拿不到原文件 |
| 跟外部工作流脱节 | Mac "最近文件"列表里看不到 vault 里的 Excel |

vault 该装什么 vs 不该装什么 · What goes in / what doesn't:

**✅ 进 vault · Goes IN the vault:**
- 公司笔记（结构化 frontmatter + 自由文本思考）
- Investment memo（投资备忘录，含 13 节强制结构）
- 决策日志（每次买/加仓/退出前 5 分钟的思考）
- 季度 / 年度复盘
- 投资 thesis（你的"宪法"）
- 人物笔记（创始人 / 共投 / LP）

**❌ 不进 vault · Stays OUT of the vault (in `~/work/`):**
- Pitch deck 原 PDF
- 财务模型 Excel
- 法律合同原稿
- DD 收来的财报 / 客户合同
- 公司发来的 monthly update PDF（解析后的结构化笔记进 vault，原文件留外）

### 三层抽象 · Three-layer architecture

```
┌─────────────────────────────────────────────────┐
│   Layer 1: Raw files · 原始文件                 │
│   ~/work/portfolio/<公司>/                      │
│   • financial-model.xlsx                        │
│   • pitch-deck.pdf                              │
│   • DD/, contracts/, meetings/                  │
└─────────────────────┬───────────────────────────┘
                      │ pointed to by frontmatter
                      │
┌─────────────────────▼───────────────────────────┐
│   Layer 2: Index · 索引层（vault）              │
│   vault/1-portfolio/companies/<公司>.md         │
│   • frontmatter: project_root, files, status   │
│   • body: thesis, key vars, decisions, log     │
└─────────────────────┬───────────────────────────┘
                      │ navigated by skill
                      │
┌─────────────────────▼───────────────────────────┐
│   Layer 3: Operator · 操作层                    │
│   Claude Code / Codex + deal-router skill │
│   • reads vault → resolves paths → does work    │
│   • writes back log + frontmatter updates       │
└─────────────────────────────────────────────────┘
```

每一层都很简单——但**三层一起就是新的范式**。

Each layer alone is simple — but the **three layers together form a new paradigm**.

---

## 🎬 实际工作流 · Real workflows

下面是真实的"你说一句话 → Claude 干什么"的对话样例，演示这套系统怎么用。

Below are real "you say something → Claude does X" conversations showing how the system actually operates.

### 工作流 1：解析创始人发来的月度 update · Parsing a founder's monthly update

**你**（在你 vault 目录里起的 claude session）:

> "智能制造科技刚发来 4 月 update PDF，在 ~/work/portfolio/智能制造科技/updates/2026-04.pdf。帮我整理一下。"

**Claude**（自动按 deal-router 流程）:

1. Read `vault/1-portfolio/companies/智能制造科技.md`
2. 拿到 `project_root: ~/work/portfolio/智能制造科技`
3. 打开 `updates/2026-04.pdf`，提取关键数字
4. 创建 `vault/5-updates/智能制造科技-2026-04-update.md`，带结构化 frontmatter（runway, burn, 团队规模, 风险信号）
5. **更新** portfolio 笔记 frontmatter：`runway 月数` 14 → 11，`月烧钱` 60 → 80，`团队规模` 22 → 25
6. **追加**到 portfolio 笔记的"## 近期操作"：`- 2026-05-01 14:32 解析 4 月 update，runway 14→11 月`
7. **追加**到 portfolio 笔记的"## Updates 时间线"：`[[5-updates/智能制造科技-2026-04-update]]`
8. **警告你**：⚠️ Runway 从 14 降到 11，已进入预警区（< 12 月）。建议本月找一次创始人聊融资节奏。

**结果**：你只说了一句话，4 处文件被一致更新，警报浮出来。

### 工作流 2：写新 deal 的 memo 草稿 · Drafting a memo for a new deal

**你**:

> "今天见了 AI 芯片公司，A 轮 pre-money 4000 万。创始人是华为海思出身，团队 8 人。市场是边缘 AI 推理芯片。我想给个 600 万的 commitment。帮我起 memo 草稿。"

**Claude**:

1. 创建 `vault/4-memos/AI芯片公司-A轮-memo.md`，套 primary-vault 的 13 节模板
2. 把你说的内容填进对应位置（团队、估值、推荐金额）
3. 留**待补字段**（Why Now / Risks Top 5 / 退出路径 / **第 13 节 12-24 月里程碑预测**）让你接着写
4. 在`0-pipeline/3-DD中/AI芯片公司.md` 创建 pipeline 条目，关联 memo
5. 提示你：**第 13 节强制不许跳过**——这是 12 个月后回头看的 self-reflection 锚点

**结果**：30 分钟的对话变成结构化 memo，你只补思考密度高的几节。

### 工作流 3：周扫描 · Weekly portfolio sweep

**你**:

> "周一早上，做这周 portfolio sweep。"

**Claude**:

1. Glob 所有 `1-portfolio/companies/*.md`
2. 计算每家：runway 余量、上次 update 距今天数、最近一次操作
3. **红区**：runway < 6 月 → "🔴 这 2 家本周必须联系"
4. **黄区**：runway 6-9 月 / 沉默 60-90 天 → "🟡 这 4 家关注一下"
5. **复盘 due**：`下次复盘截止 < 今天` 的 → "⏰ 这 3 家该季度复盘了"
6. 生成 markdown 表格输出
7. **追加**到 `7-reviews/2026-W18-周扫描.md`

**结果**：早上 5 分钟的对话给你本周 portfolio 注意力分配。

### 工作流 4：季度全 portfolio 复盘 · Quarterly full review

**你**:

> "Q2 复盘。"

**Claude**:

1. 列出全部 portfolio 公司
2. 逐家走完，每家问你 3 个问题：
   - 论点还成立吗？
   - 关键变量进展？
   - 仓位决策（保持 / 加仓 / 减仓 / 退出）？
3. 你回答，Claude 写到每家笔记的"## 复盘 2026-Q2" section
4. 更新各家的 `下次复盘截止: +90 天`
5. 全部走完后，生成 `vault/7-reviews/2026-Q2-portfolio-review.md` 总览

**结果**：3 小时的复盘动作变成结构化产出 + 每家公司笔记同时更新。

### 工作流 5：投后董事会准备 · Board meeting prep（v0.2 新增）

**你**（开会前 2 天）:

> "下周三智能制造科技董事会，帮我准备。"

**Claude**:

1. 读 `1-portfolio/companies/智能制造科技.md` 当前状态
2. 找到上次 board note `6-board-notes/智能制造科技-2026-01-15-board.md`，提取**未完成 action items**
3. 拉最近 2 个季度 update（5-updates/）
4. 对比当前 KPI vs **memo 第 13 节"12-24 月预测"**
5. 生成 `6-board-notes/智能制造科技-2026-04-10-board-prep.md`：
   - **议程建议**（5 个标准 section + 公司特异议题）
   - **上次开放项 follow-up 表格**（done / open / 推迟）
   - **关键 KPI 变化表格**（memo 预测 vs 实际）
   - **我要问的 5 个硬问题**（基于异常和 memo 偏差）
   - **我要 push 的 add value 事项**
   - **我之前 promise 的自查清单**
6. 提示你：⚠️ 团队规模季度增 30% 但收入只增 12%，建议追问"招了什么人 / 提前预算开支了吗"

**结果**：开会前 30 分钟"我要说什么"焦虑 → Claude 给你完整 brief，你只需读一遍 + 改几处。

### 工作流 6：项目退出 · Exit recording（v0.2 新增）

**你**:

> "智能制造科技被某上市公司收购了，2.4 亿，现金 70% 股票 30%，6 个月 lockup。"

**Claude**:

1. **询问缺失细节**：买家名字？我方 proceeds？escrow？earnout？
2. 你补完
3. **移动文件**：`mv 1-portfolio/companies/智能制造科技.md 2-exited/`
4. **更新 portfolio frontmatter**：
   - `状态: exited-ma`
   - 加 `退出日期`、`退出 proceeds`、`最终 MOIC`、`持有月数`
5. **创建退出记录** `2-exited/智能制造科技-exit-record.md`：完整 frontmatter + 时间线 + 我方回报 + LP 影响
6. **Mark memo** `状态: 已退出-ma`
7. **触发提醒**：建议你 1 周内做退出复盘（Action 12）
8. 在本月月报追加退出 log

**第二步——你接受退出复盘**:

> "做智能制造科技退出复盘"

**Claude**:

1. 读 memo（特别第 13 节预测）+ 所有 updates + 所有 board notes + decision logs
2. 问你 5 个反省问题（thesis 校准 / 里程碑预测 / 关键决策 / 回报对比 / 下次会改什么）
3. 写到 `7-reviews/智能制造科技-exit-retrospective.md`
4. **关键**：把 lessons 提炼回 `_thesis.md` 的"已投回头看"或"反 thesis"段——下次类似 deal 自动避坑

**结果**：每一笔退出都强制变成基金学习曲线的一格台阶，不是发完信就忘。

---

## 📦 仓库内容 · Repository layout

```
primary-vault/
│
├── README.md                      ← 你正在读的这份
├── LICENSE                        ← MIT
├── CHANGELOG.md                   ← 版本历史
│
├── docs/                          ← 详细文档（**强烈建议读完**）
│   ├── INSTALL.md                 ← 一步步安装
│   ├── ARCHITECTURE.md            ← vault-as-router 模式设计哲学
│   └── CONVENTIONS.md             ← frontmatter / 文件夹 / 命名约定（"宪法"）
│
├── vault-template/                ← Obsidian vault 完整骨架
│   ├── _dashboard.md              ← 总览面板（嵌 Bases 视图）
│   ├── _thesis.md                 ← 投资策略宪法模板
│   ├── README.md                  ← 这个 vault 怎么用
│   │
│   ├── 0-pipeline/                ← 在看的 deal
│   │   ├── 1-初筛/, 2-meeting/, 3-DD中/, 4-IC/, 5-pass/
│   │
│   ├── 1-portfolio/companies/     ← 已投
│   │   └── _template.md           ← portfolio 公司模板（完整 frontmatter）
│   │
│   ├── 2-exited/                  ← IPO / M&A / 写零（保留复盘用）
│   ├── 3-people/_template.md      ← 创始人 / 共投 / LP 模板
│   ├── 4-memos/_template.md       ← Memo 模板（13 节结构）
│   ├── 5-updates/_template.md     ← 季度 update 模板
│   ├── 6-board-notes/             ← 董事会会议
│   ├── 7-reviews/_template.md     ← 周/月/季/年复盘模板
│   └── bases/                     ← Bases 视图文件（v0.2 补全）
│
├── skills/
│   └── deal-router/
│       └── SKILL.md               ← 核心 skill（教 Claude/Codex 这套约定）
│
├── examples/                      ← 合成数据样例（克隆即可看完整一遍）
│   ├── 智能制造科技-portfolio.md
│   └── 智能制造科技-A轮-memo.md   ← 完整 13 节 memo + 6 月回访已回填
│
└── scripts/
    └── install.sh                 ← 一键 symlink skill 到 ~/.claude + ~/.codex
```

---

## 🚀 Quick Start · 五分钟上手

### 1. Clone 仓库 · Clone the repo

```bash
git clone https://github.com/cloveric/primary-vault.git ~/projects/primary-vault
cd ~/projects/primary-vault
```

### 2. 装 Skill · Install the skill

```bash
bash scripts/install.sh
```

会做两件事：
1. Symlink `skills/deal-router/` → `~/.claude/skills/deal-router`
2. 同样 symlink → `~/.codex/skills/deal-router`（如果你装了 Codex）

> **更新只 git pull 一次，三处通过 symlink 同时生效。**
> Update once via `git pull`; three locations stay in sync via symlinks.

### 3. 设置 vault · Set up your vault

两种姿势选一个 · Pick one:

**姿势 A**：`vault-template/` 当独立 vault

```bash
# 在 Obsidian 里 → Open vault → 选 ~/projects/primary-vault/vault-template/
```

适合：一级投资单独搞一个 vault，跟个人笔记 / 工作笔记分离。

**姿势 B**：合并进现有 vault

```bash
cp -r ~/projects/primary-vault/vault-template/. /path/to/your/existing-vault/
```

适合：你已经有 Obsidian vault 想接入。注意检查同名冲突。

### 4. 准备工作目录 · Prepare work directory

```bash
mkdir -p ~/work/{portfolio,pipeline,exited}
```

vault 是索引，原始文件留这里。每家公司一个子文件夹（如 `~/work/portfolio/智能制造科技/`）。

### 5. 验证 · Verify

```bash
cd /path/to/your/vault
claude
# 在 claude prompt 里问：
# > "按 deal-router 约定，列出我所有 portfolio 公司"
# 应该能看到它 glob 1-portfolio/companies/ 给你列表
```

---

## 🎬 操作节奏 · Operating cadence

| 频率 · Frequency | 你做什么 · You do | Claude 怎么帮 · Claude helps |
|---|---|---|
| 🔄 **每次 deal** | 写 memo（强制） | 口述 30 分钟 → 套 13 节模板生成草稿 |
| 📅 **每天** | pipeline 进展 / 见人 | 加 deal、移阶段、链人物笔记、记互动 |
| 📊 **每周一** | runway 警报 + 沉默检查 | Bases 视图扫一遍，给红/黄/绿区 |
| 🏛️ **每次董事会前** | 准备 brief | 自动整合上次 action / KPI 变化 / 我要问的硬问题 |
| 🏛️ **每次董事会后** | 捕获决议 + 行动项 | 一句话 → 结构化 board note + 更新 frontmatter |
| 📨 **每月** | portfolio update review | 解析创始人 PDF/邮件 → 结构化 update + 更新 runway / burn |
| 💰 **follow-on 决策时** | 决策日志 | 强制 5 分钟反省 + 设 6/12 月回访点 |
| 🔍 **每季度** | full portfolio 复盘 + 估值更新 | 一家家走过 → 自动生成 fund report 草稿 |
| 🚪 **退出时** | 录退出条款 + 1 周内复盘 | 移动文件 + 触发复盘提醒 + lessons 回写 thesis |
| 📑 **每年** | fund review + LP letter | 算 IRR / TVPI / DPI / DPI → LP 信草稿 |

详细 playbook 见 [docs/CADENCE.md](docs/CADENCE.md)（v0.2 补全中）。

---

## 🆚 跟其他方案对比 · How it compares

| 方案 | 优势 · Pros | 短板 · Cons | 适合 · Best for |
|---|---|---|---|
| **Excel + 文件夹** | 谁都会用、零成本 | 没结构化思考、没关联、决策无痕 | 1-3 个 deal 的散户 |
| **Notion** | 好看、协作、模板多 | 数据被锁、agent 接入难、本地不可控 | 5-50 人团队、重协作 |
| **Affinity** | 专业 VC CRM、关系图谱 | 贵（$2000+/年）、定制差、AI 弱 | 100M+ AUM 机构 |
| **DealCloud** | 企业级、合规完整 | 巨贵、配置复杂、agent 集成几乎没有 | 10亿+ AUM 大基金 |
| **primary-vault** | plaintext + AI 原生 + 完全可控 + 0 月费 | 需要自己搭、有学习曲线 | 独立投资人 / 小团队 / power user |

---

## ❓ FAQ

### Q1: 我必须用 Claude Code 吗？只用 Obsidian 行不行？

**A**: vault 模板 + Bases 视图 + memo 模板**单独都有用**——你光用 Obsidian 也能受益。但 60% 的价值来自 skill 自动化（自动解析 update、自动写日志、自动复盘）——光手动操作很快会因为"懒得记录"而中途放弃。

### Q2: 我可以把 primary-vault 当 SaaS 用吗？

**A**: 不能。这是本地工具。**这是优点**——你的投资数据 100% 在你电脑里，不上任何云（除非你自己用 iCloud / Dropbox 做 vault 同步）。

### Q3: Bases 是什么？要不要花钱？

**A**: Bases 是 Obsidian 自带的核心功能（2025 年从 beta 转正）—— **完全免费**，不需要任何插件。它让你把 frontmatter 当数据库字段，建视图、过滤、排序。Notion database 那套体验，本地、plaintext。

### Q4: 跟 kepano/obsidian-skills 有什么关系？

**A**: 兼容。`kepano/obsidian-skills` 教 Claude 写 Obsidian 方言（wikilinks / properties / Bases / Canvas），是**通用 Obsidian skill**。`primary-vault/skills/deal-router/` 是**领域 skill**（VC 工作流约定）。两个一起装最强 —— Claude 既懂 Obsidian 怎么写，又懂 VC 怎么管。

### Q5: 我已经投了 50 家公司，怎么 onboard？

**A**: 不用一次性迁完。**两个建议**：

1. **新 deal 从今天开始按这套来**——以后每个新 deal 走 vault-template 的流程，3 个月后你 active portfolio 一半就在 vault 里了
2. **老 portfolio 季度复盘时录入**——下次季度复盘时，每家公司**只录关键 frontmatter 字段**（不用全部细节），3 个季度后老的也都进来了

### Q6: 团队 3-5 人能用吗？

**A**: 能。把 vault 放共享 git repo（私有），每人本地 clone。冲突靠 git merge 解决。**真实痛点**：实时协作不强（不像 Notion 你看我打字）。如果团队需要实时多人编辑，去用 Notion / Affinity。

### Q7: vault 和工作目录分开，文件链接会不会断？

**A**: 不会，因为 vault 里只存**绝对路径**（`project_root: /Users/cloveric/work/portfolio/智能制造科技`）。换电脑时改一遍 `project_root` 就行（写个 sed 脚本批量改也快）。

### Q8: Claude Code 不会乱改我笔记吧？

**A**: SKILL.md 里写了硬约束："不要默默改用户已有值——改 estim 字段必须 confirm"。但**最稳的姿势**是：vault 也用 git 管理，每天 commit 一次，错了能回滚。

---

## 🗺️ Roadmap

### v0.1.0 · Initial MVP

- [x] vault-template 骨架 + 8 份模板
- [x] deal-router skill（7 个核心动作）
- [x] 1 个完整 portfolio 公司样例 + 完整 13 节 memo 样例
- [x] docs: README / INSTALL / ARCHITECTURE / CONVENTIONS
- [x] scripts/install.sh 一键装

### v0.2.0 · Full lifecycle

- [x] **重命名 vc-vault → primary-vault**（覆盖 VC + PE + CVC + 家办）
- [x] **重命名 skill `vc-project-router` → `deal-router`**
- [x] **新增投后管理动作**（Action 7-10）：董事会准备 / 董事会捕获 / portfolio support / follow-on 决策
- [x] **新增退出动作**（Action 11-13）：退出录入（IPO / M&A / 二级 / 写零）/ 退出复盘 / 退出 pipeline 追踪
- [x] **新增模板**：board meeting / board prep / exit / exit retrospective
- [x] **frontmatter 扩展**：最近董事会 / 下次董事会 / 当前融资轮 / 退出条款
- [x] **CONVENTIONS 加 4 种新 type**：board-meeting / board-prep / exit / exit-retrospective
- [x] README 加 6 个 workflow 示例（v0.1 4 个 + v0.2 新增板块 + 退出）

### v0.3.0 · Polished

- [x] **Bases 视图文件**（7 个 .base）
- [x] **docs/CADENCE.md** 完整 playbook
- [x] **docs/DIALOGUES.md** 36 个对话
- [x] **5 家 portfolio 样例**（active 主角 / active 跟投 / struggling / exited-ipo / 写零）
- [x] **scripts/new-deal.sh** 脚手架
- [x] **增强 _thesis.md**（10 节）

### v0.4.0 · Self-audit fix-up + breaking schema refactor（**当前**）

针对 v0.3 自检发现的 17 个 bug / 设计缺陷一次性清完，并把 frontmatter 字段名重构为 snake_case 英文（breaking change）。

- [x] **🚨 Breaking**: frontmatter 字段全部 snake_case 英文（`runway 月数` → `runway_months`），中文显示通过 Bases displayName
- [x] 修 `_dashboard.md` 假 Bases 语法（用真 `![[bases/...]]` embed）
- [x] 创建缺失的 `7-reviews/decisions/` 目录
- [x] 4 个 examples `project_root` 改 placeholder（不再硬编码作者 home 路径）
- [x] Bases 文件加"已知未验证语法" section（today() / 日期算术等）
- [x] SKILL.md 加 **Concurrent-edit safety** critical section
- [x] SKILL.md 改 "use Bases views" wording bug
- [x] 新增 `scripts/uninstall.sh` / `lint-vault.sh` / `validate-memo.sh`
- [x] 新增 `vault-template/_QUICKSTART.md`
- [x] 新增 `.gitattributes`（中文文件名 UTF-8）
- [x] `new-deal.sh` 加 filename sanitize
- [x] INSTALL.md 加 vault `git init` 推荐 + 并发警告 + Windows 兼容性说明
- [x] CADENCE.md "早上" → "任意稳定时段"

### v0.5.0 · Advanced（计划）

- [ ] LP report 自动生成 skill（季度 / 年度）
- [ ] 财务模型校验 skill（读 Excel 验证 update 数据）
- [ ] 多 vault / 多基金支持
- [ ] 移动端工作流（Telegram → vault inbox）

### v1.0.0 · Production-grade

- [ ] 真实使用 12 个月的 case study
- [ ] Windows 测试 + 修复
- [ ] 跟 Affinity / Notion / DealCloud 的迁移工具
- [ ] 团队协作模式（git 共享 vault）


---

## 🤝 Contributing

欢迎 issue / PR · Issues and PRs welcome:

- **Bug** / **建议**：开 issue 描述
- **新模板** / **新 skill 动作**：开 PR
- **使用案例分享**：在 Discussions 里发，我们会精选进 docs/CASE-STUDIES.md

如果你也是一级市场从业者，欢迎在 issue 里讨论你的工作流痛点 —— v0.1 是我自己的实验，迭代靠社区。

---

## 🙏 致谢 · Acknowledgments

- 灵感来自 [`kepano/obsidian-skills`](https://github.com/kepano/obsidian-skills)（Obsidian CEO Steph Ango 的 Agent Skills 规范）—— 同一份 SKILL.md 同时被 Claude Code 和 Codex CLI 加载
- Memo 13 节结构改编自 USV / Sequoia / a16z 多家公开 memo 模板
- 决策日志的 6/12 个月回访强制设计参考 Howard Marks《The Most Important Thing》和 Annie Duke《Thinking in Bets》

---

## 📜 License

MIT — 拿去随便改、商用、fork。看 [LICENSE](LICENSE)。

MIT licensed — modify, fork, or use commercially as you wish.

---

## 👤 作者 · Author

[@cloveric](https://github.com/cloveric)

> "投资是少数几个**纪律性记录**回报远超**纪律性行动**的领域。这套工具就是想让记录变得不那么累。"
>
> "Investing is one of the few fields where **disciplined recording** beats **disciplined action**. This toolkit aims to make recording less painful."
