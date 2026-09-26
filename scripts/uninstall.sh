#!/usr/bin/env bash
# primary-vault uninstall — 卸载 skill symlinks
# 不会删 vault 内容、不会删源码；只删指向本仓库的 symlink

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SRC="$REPO_ROOT/skills/deal-router"

echo "=== primary-vault uninstall ==="
echo
echo "这个脚本只删指向 $SKILL_SRC 的 skill symlinks，不会动："
echo "  - 你的 vault 内容"
echo "  - $REPO_ROOT 源码"
echo "  - GitHub 仓库"
echo
read -r -p "继续？(y/N) " confirm || confirm=N
[ "${confirm:-N}" = "y" ] || { echo "已取消"; exit 0; }

remove_link() {
  local target="$1" dest
  if [ -L "$target" ]; then
    dest=$(readlink "$target")
    if [ "$dest" = "$SKILL_SRC" ]; then
      rm "$target"
      echo "✓ 已删 $target"
    else
      echo "⚠️  $target 指向 ${dest}（不是本仓库），跳过"
    fi
  elif [ -e "$target" ]; then
    echo "⚠️  $target 不是 symlink，跳过（请手动检查）"
  else
    echo "⊘ $target 不存在"
  fi
}

remove_link "$HOME/.claude/skills/deal-router"
remove_link "$HOME/.codex/skills/deal-router"

echo
echo "如果要彻底删除源码："
echo "  rm -rf \"$REPO_ROOT\""
