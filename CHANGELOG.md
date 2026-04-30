# Changelog

All notable changes to primary-vault.

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
