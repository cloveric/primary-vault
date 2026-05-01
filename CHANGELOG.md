# Changelog

All notable changes to primary-vault.

## [0.4.0] — 2026-05-01 · BREAKING + 17-issue fix-up

### 🚨 Breaking changes

- **Frontmatter 字段名从中文带空格改成 snake_case 英文**（详见 v0.3 → v0.4 字段映射表 in `docs/CONVENTIONS.md`）。
  - 例：`runway 月数` → `runway_months`，`当前 MOIC` → `current_moic`，`follow-on 优先级` → `follow_on_priority`
  - 中文显示通过 Bases 的 `displayName` 实现 —— UI 上还是中文
  - v0.3 的笔记需要批量 sed 改字段名才能用 v0.4 skill / Bases

### 🔴 Critical bugs fixed

- **#1**: `_dashboard.md` 之前用了**伪 Bases 语法**（SQL/DQL 风格），渲染不出来。重写为真 Bases 嵌入 (`![[bases/<name>]]`)。
- **#2**: 创建缺失的 `vault-template/7-reviews/decisions/` 目录（带 `.gitkeep`），SKILL 反复引用但 v0.3 没建。
- **#3**: 4 个 portfolio 样例的 `project_root` 写死了作者真实 home 路径 (`/Users/cloveric/work/...`)，全部改成 `/path/to/your/work/...`。
- **#4**: Bases 文件用了**未充分验证**的语法。bases/README.md 加了"已知未验证"小节，列出 today() / 日期算术 / formula 在 filter 中引用 / groupBy 嵌套等存疑点 —— 用户调试时知道往哪看。

### 🟡 Medium issues fixed

- **#6**: SKILL.md 之前称"use Bases views"——实际 Claude 不能调 Bases。改成"读 .base 文件 YAML 当 filter 规范，Glob+Grep 复刻查询"。
- **#7**: INSTALL.md 加 "强烈建议给 vault 也用 git" section + 命令示例。
- **#8**: 新增 `scripts/lint-vault.sh` —— 校验 frontmatter 必填字段、type 枚举值、日期 ISO 格式、v0.3 旧字段残留、YAML 合法性。
- **#9**: CADENCE.md "每天早上 5 分钟" 改成 "任意稳定时段" + 解释为什么早上不现实。
- **#10**: SKILL.md 顶部加 **CRITICAL Concurrent-edit safety** section，明确指示 Claude 改笔记前先让用户在 Obsidian 关闭。INSTALL.md 也补"并发编辑警告"。

### 🟢 Low priority improvements

- **#11**: lint-vault.sh 提供基础"测试"——5 类检查（必填 / 第 13 节 / 日期 / v0.3 残留 / YAML）。
- **#12**: 新增 `scripts/uninstall.sh` —— 一键拆 symlink，确认 prompt 防误操。
- **#13**: 新增 `vault-template/_QUICKSTART.md` —— 第一次打开 vault 的 3 步 onboarding + 5 个立刻能干的事 + 5 个 FAQ。
- **#14**: `new-deal.sh` 加 sanitize：公司名含 `/ : * ? " < > | \` 自动替换为 `-`，并提示用户。
- **#15**: 新增 `scripts/validate-memo.sh` —— 检查 memo 第 13 节存在且实质内容 ≥ 3 行；可作为 git pre-commit hook 强制 enforcement。
- **#16**: README + INSTALL 明确 Windows 兼容性（理论可用 Git Bash / WSL，符号链接行为不同；v1.0 会专门测试）。
- **#17**: 新增 `.gitattributes` 强制 UTF-8 处理多字节文件名。

### Added

- `vault-template/_QUICKSTART.md`
- `vault-template/7-reviews/decisions/.gitkeep`
- `scripts/uninstall.sh`
- `scripts/lint-vault.sh`
- `scripts/validate-memo.sh`
- `.gitattributes`

### Changed

- 所有 vault-template/ 模板：字段名 snake_case 化
- 所有 7 个 .base 文件：字段名 snake_case 化 + properties displayName 加中文
- 所有 5 个 examples：字段名 + project_root → placeholder
- `_dashboard.md` 重写（真 Bases embed）
- `vault-template/bases/README.md` 加"已知未充分验证的语法"section
- `skills/deal-router/SKILL.md`：加并发警告 + 修 Bases wording bug + 全 schema 改 snake_case
- `docs/CONVENTIONS.md` 大改：完整 v0.4 schema + v0.3→v0.4 映射表
- `docs/INSTALL.md` 加 git init + 并发警告 + Windows 兼容性 + lint 用法
- `docs/CADENCE.md` 把"早上"改成"任意稳定时段"
- `scripts/new-deal.sh` 加 filename sanitize + 用 v0.4 字段名生成

## [0.3.0] — 2026-05-01

### Polished release · v0.2 → v0.3

把 v0.2 的"功能"包成"产品"——添加文档、视图、样例、脚手架。
Turning v0.2 features into a polished package — docs, views, examples, scaffolding.

### Added: 7 Bases 视图

- `bases/runway-警报.base` — runway < 9 月（红 < 6, 黄 6-9）
- `bases/沉默90天.base` — 最近 update > 90 天
- `bases/董事会due.base` — 下次董事会在未来 14 天内
- `bases/follow-on-候选.base` — follow-on 优先级=高 AND 当前融资轮≠无
- `bases/pipeline-漏斗.base` — pipeline 各阶段 group + 排序
- `bases/复盘due.base` — 下次复盘截止 < today
- `bases/退出追踪.base` — 当前融资轮 ∈ {上市辅导中, M&A 谈判中, IPO 申报中, 二级转让中}
- `bases/README.md` — 视图说明 + 字段名兼容指引

### Added: docs/CADENCE.md

完整的操作节奏 playbook：
- 每天 (早上 5 分钟扫面板 / 白天碎片操作 / 晚上 5 分钟检查)
- 每周一 (30 分钟雷打不动的 portfolio 巡视 + pipeline 漏斗扫一眼)
- 每月 (portfolio update review + 决策日志回访 + 月报)
- 每季 (full portfolio review + 估值更新 + LP 季度沟通)
- 每年 (fund review + thesis 更新 + LP 年度信)
- 异常时刻 (off-cadence triggers)
- 怎么形成习惯（3 个保活技巧）

### Added: docs/DIALOGUES.md

36 个真实场景 "你说什么 → Claude 干什么" 对话，9 个分类：

- Pipeline (5 个)：加 deal / 阶段流转 / pass / 复活 / 周扫描
- Memo (4 个)：起草 / 更新某节 / 状态流转 / 6 个月后回头看
- Updates (4 个)：微信语音 / PDF / 邮件 / 紧急
- 董事会 (5 个)：准备 / 捕获 / 我之前 promise 的 / 多家日历 / 1-on-1
- 决策 (3 个)：加仓 / down round / 30 天回访
- 复盘 (4 个)：周扫描 / 月报 / 季度复盘 / 跨季度模式查找
- 退出 (4 个)：M&A / IPO / 写零 / 退出复盘
- 人物 (3 个)：加新人 / 联系频率提醒 / 互动汇总
- 工具类 (4 个)：找文件路由 / 跨公司搜索 / 论点对照 / 全 vault 健康度

### Added: 4 新 portfolio 样例 (合成数据)

覆盖不同生命周期状态 + 不同退出场景：

- `examples/AI芯片公司-portfolio.md` — active 健康成长，跟投，半导体
- `examples/SaaS公司-portfolio-struggling.md` — struggling，runway 4 月，论点已破
- `examples/光储一体公司-exit-ipo.md` — IPO 退出 (MOIC 7x, IRR 95%)
- `examples/电商Saas-portfolio-写零.md` — 写零案例 (MOIC 0)，含教训提炼

加上 v0.1 的智能制造科技（active normal）+ memo 样例 = 5 portfolio + 1 memo 样例。

### Added: scripts/new-deal.sh

快速建新 deal 骨架的 bash 脚本：
- 自动找 vault 根（含 `0-pipeline/` 的祖先目录）
- 创建 pipeline-deal frontmatter 完整模板
- 默认 stage `2-meeting`，可指定其他阶段
- 提示用户接下来怎么用 Claude 继续填

### Enhanced: vault-template/_thesis.md

从 8 节扩到 10 节，加 3 个关键板块：

- **第 4 节 Anti-thesis 拆细**：行业 / 创始团队 / 商业模式 / 估值条款 4 维度
- **第 7 节"已投回头看"加 4 个子板块**：表现 outliers / 表现底部 / 写零 lessons / 退出 outliers
- **第 8 节"Lessons by deal"**：按 deal 维护的判断校准（退出复盘 + 季度复盘的产物）
- **第 9 节"下次更新触发"**：常规 vs 触发性 vs 半年大版本
- **第 10 节"历史版本"**：thesis 演化记录

### Updated: README

- Roadmap：v0.3 移到"当前"，v0.4 / v1.0 计划细化
- Status badge：v0.2.0 → v0.3.0

## [0.2.0] — 2026-05-01

### Renamed: vc-vault → primary-vault

- Repository renamed from `vc-vault` to `primary-vault` to reflect broader scope (VC + PE + CVC + family office + search funds + angels + accelerators)
- Skill renamed from `vc-project-router` to `deal-router`
- All internal references updated; symlinks rebuilt

### Added: Full deal lifecycle coverage (post-investment + exits)

**New skill actions** (now 14 total, was 7):

- **Action 7 — Board meeting prep**: read company state + last board note + recent updates → generate prep doc with agenda, KPI deltas, open items, hard questions, add-value items, self-promised follow-ups
- **Action 8 — Board meeting capture**: turn one-line "刚开完 X 的董事会" into structured board note with decisions / action items / strategic discussion / risks / informal observations
- **Action 9 — Portfolio support tracking**: log every value-add introduction / advice as interaction record on founder note + portfolio company "我帮过什么" section
- **Action 10 — Follow-on / down round 决策**: trigger decision log with thesis status + key variables + valuation reasonableness + 6/12-month revisit anchors
- **Action 11 — Exit recording**: ask exit details → mv portfolio file to `2-exited/` → update frontmatter + create exit record + mark memo + trigger retrospective reminder
- **Action 12 — Exit lessons retrospective**: read all context → 5 retrospective questions → write retro note → distill lessons back into `_thesis.md`
- **Action 13 — Exit pipeline tracking**: track companies in IPO process or M&A negotiation with timeline + my action items + 30-day check-ins

**New frontmatter fields on `portfolio-company`:**

- `最近董事会`, `下次董事会`, `董事会频率`
- `当前融资轮` (无 / 已启动 / 投资人尽调中 / TS 谈判 / 已签 / 上市辅导中 / M&A 谈判中)

**New note types** documented in CONVENTIONS.md:

- `type: board-meeting`
- `type: board-prep`
- `type: exit`
- `type: exit-retrospective`

**New templates in vault-template/:**

- `6-board-notes/_board-template.md` — board meeting capture
- `6-board-notes/_board-prep-template.md` — board meeting prep with KPI delta table + hard-questions section + self-promised checklist
- `2-exited/_exit-template.md` — exit record with terms / proceeds / timeline / LP impact
- `2-exited/_exit-retrospective-template.md` — 7-section retrospective forcing thesis recalibration

**README expansions:**

- Header now states "全生命周期" (full lifecycle) explicitly
- Audience broadened to VC + PE + CVC + family office + search fund + angel + accelerator
- 2 new workflow examples (board prep, exit recording + retrospective)
- Operating cadence table updated with board prep, board capture, follow-on decision, exit handling rows

### Migration notes

If you installed v0.1.0:

```bash
# Local repo
mv ~/projects/vc-vault ~/projects/primary-vault
cd ~/projects/primary-vault
git remote set-url origin https://github.com/cloveric/primary-vault.git
git pull

# Symlinks
rm ~/.claude/skills/vc-project-router ~/.codex/skills/vc-project-router
ln -sf ~/projects/primary-vault/skills/deal-router ~/.claude/skills/deal-router
ln -sf ~/projects/primary-vault/skills/deal-router ~/.codex/skills/deal-router
```

Old GitHub URL `cloveric/vc-vault` redirects to `cloveric/primary-vault` automatically for ~6 months.

## [0.1.0] — 2026-05-01

### Initial release · MVP

- README + architecture diagram (vault-as-router)
- vault-template skeleton (8 templates: dashboard, thesis, portfolio company, memo with mandatory 12-24mo prediction, person, update, review)
- skills/vc-project-router/SKILL.md — core convention skill teaching Claude/Codex how to navigate the vault (7 actions: route / new pipeline / move stage / write memo / parse update / write-back log / periodic reviews)
- examples/ — 1 portfolio company + 1 full A-round memo (synthetic data)
- docs/INSTALL.md, docs/ARCHITECTURE.md, docs/CONVENTIONS.md
- scripts/install.sh — one-shot symlink to ~/.claude/skills + ~/.codex/skills
