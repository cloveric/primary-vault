#!/usr/bin/env bash
# vc-vault one-shot install
# - symlink skill into ~/.claude/skills/
# - symlink skill into ~/.codex/skills/ (if it exists)
# - print next steps for vault setup

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SRC="$REPO_ROOT/skills/vc-project-router"

echo "=== vc-vault install ==="
echo "Source: $SKILL_SRC"
echo

# 1. Claude Code
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
if [ -d "$HOME/.claude" ]; then
  mkdir -p "$CLAUDE_SKILLS_DIR"
  CLAUDE_TARGET="$CLAUDE_SKILLS_DIR/vc-project-router"
  if [ -e "$CLAUDE_TARGET" ] && [ ! -L "$CLAUDE_TARGET" ]; then
    echo "⚠️  $CLAUDE_TARGET 已存在且不是 symlink，跳过（手动检查）"
  else
    ln -sfn "$SKILL_SRC" "$CLAUDE_TARGET"
    echo "✓ Claude Code: $CLAUDE_TARGET → $(readlink "$CLAUDE_TARGET")"
  fi
else
  echo "⊘ ~/.claude 不存在，跳过 Claude Code"
fi

# 2. Codex
CODEX_SKILLS_DIR="$HOME/.codex/skills"
if [ -d "$HOME/.codex" ]; then
  mkdir -p "$CODEX_SKILLS_DIR"
  CODEX_TARGET="$CODEX_SKILLS_DIR/vc-project-router"
  if [ -e "$CODEX_TARGET" ] && [ ! -L "$CODEX_TARGET" ]; then
    echo "⚠️  $CODEX_TARGET 已存在且不是 symlink，跳过"
  else
    ln -sfn "$SKILL_SRC" "$CODEX_TARGET"
    echo "✓ Codex CLI: $CODEX_TARGET → $(readlink "$CODEX_TARGET")"
  fi
else
  echo "⊘ ~/.codex 不存在，跳过 Codex"
fi

echo
echo "=== Skill 装好了 ==="
echo
echo "下一步：vault 设置（手动）"
echo "  方式 A — 整个 vault-template 当独立 vault："
echo "    在 Obsidian 里 Open vault → 选 $REPO_ROOT/vault-template/"
echo
echo "  方式 B — 拷进现有 vault："
echo "    cp -r $REPO_ROOT/vault-template/. /path/to/your/vault/"
echo
echo "工作目录建议结构（vault 之外）："
echo "  mkdir -p ~/work/{portfolio,pipeline,exited}"
echo
echo "完整文档：$REPO_ROOT/docs/INSTALL.md"
