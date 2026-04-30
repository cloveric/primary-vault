# Changelog

All notable changes to vc-vault.

## [0.1.0] — 2026-05-01

### Initial release · MVP

- README + architecture diagram (vault-as-router)
- vault-template skeleton with 4 templates (portfolio company / memo / person / update / review)
- skills/vc-project-router/SKILL.md — core convention skill teaching Claude/Codex how to navigate the vault
- examples/ — 1 portfolio company + 1 memo (synthetic data)
- docs/INSTALL.md, docs/ARCHITECTURE.md, docs/CONVENTIONS.md
- scripts/install.sh — one-shot symlink to ~/.claude/skills + ~/.codex/skills

### Known gaps (planned for v0.2)

- Bases files (5 core views: runway warning / silent 90-day / follow-on candidates / pipeline funnel / review-due)
- docs/CADENCE.md (daily/weekly/monthly/quarterly/yearly playbook)
- docs/DIALOGUES.md (sample user→Claude conversation library)
- More example data (5+ portfolio companies covering different stages and outcomes)
- scripts/new-deal.sh (scaffold a new deal/portfolio entry)
