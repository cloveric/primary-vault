#!/usr/bin/env bash
# primary-vault uninstall — 卸载 skill symlinks
# 不会删 vault 内容、不会删源码

set -euo pipefail

echo "=== primary-vault uninstall ==="
echo
echo "这个脚本只删 skill symlinks，不会动："
echo "  - 你的 vault 内容"
echo "  - ~/projects/primary-vault/ 源码"
echo "  - GitHub 仓库"
echo
read -p "继续？(y/N) " confirm
[ "${confirm:-N}" = "y" ] || { echo "已取消"; exit 0; }

CLAUDE_TARGET="$HOME/.claude/skills/deal-router"
CODEX_TARGET="$HOME/.codex/skills/deal-router"

if [ -L "$CLAUDE_TARGET" ]; then
  rm "$CLAUDE_TARGET"
  echo "✓ 已删 $CLAUDE_TARGET"
elif [ -e "$CLAUDE_TARGET" ]; then
  echo "⚠️  $CLAUDE_TARGET 不是 symlink，跳过（请手动检查）"
else
  echo "⊘ $CLAUDE_TARGET 不存在"
fi

if [ -L "$CODEX_TARGET" ]; then
  rm "$CODEX_TARGET"
  echo "✓ 已删 $CODEX_TARGET"
elif [ -e "$CODEX_TARGET" ]; then
  echo "⚠️  $CODEX_TARGET 不是 symlink，跳过"
else
  echo "⊘ $CODEX_TARGET 不存在"
fi

echo
echo "如果要彻底删除源码："
echo "  rm -rf ~/projects/primary-vault"
