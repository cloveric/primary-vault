#!/usr/bin/env bash
# validate-memo.sh — 检查 memo 第 13 节（12-24 月里程碑预测）真的填了
# 这个 enforce "12-24 月里程碑预测必填" 的硬约束
#
# 用法：
#   bash validate-memo.sh <memo.md> [更多 memo.md ...]
#   bash validate-memo.sh --staged     # git pre-commit 用：只查暂存区里新增/修改的 4-memos/*.md
#
# 判定：第 13 节（到下一个 "## " 标题为止）去掉下面这些行之后，至少还要剩 3 行：
#   - 空行、引用（>）、HTML 注释
#   - 跟模板第 13 节一字不差的行（没动过的占位，如 "- 收入到 X"）
#   - "- 标签：" 这种冒号后面没内容的占位行、空列表项
# 模板优先用 memo 同目录的 _template.md，没有就用本仓库的 vault-template/4-memos/_template.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_TEMPLATE="$SCRIPT_DIR/../vault-template/4-memos/_template.md"
MIN_LINES=3

usage() {
  echo "用法: bash validate-memo.sh <memo.md> [更多 memo.md ...]"
  echo "      bash validate-memo.sh --staged   (git pre-commit hook 用)"
}

# 数第 13 节里的实质内容行数
# $1 = 要检查的文件，$2 = 模板文件（可以不存在）
count_substantive() {
  awk -v tpl="$2" '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t\r]+$/, "", s); return s }
    function is_13(s) { return s ~ /^##[ \t]*13(\.|、)/ }
    function is_h2(s) { return s ~ /^##[ \t]/ }
    BEGIN {
      if (tpl != "" && (getline line < tpl) > 0) {
        do {
          if (is_13(line)) { in13 = 1; continue }
          if (in13 && is_h2(line)) break
          if (in13) { t = trim(line); if (t != "") skip[t] = 1 }
        } while ((getline line < tpl) > 0)
        close(tpl)
      }
    }
    is_13($0) { f = 1; next }
    f && is_h2($0) { exit }
    f {
      t = trim($0)
      if (t == "") next
      if (t ~ /^>/) next                                    # 引用 / 说明
      if (t ~ /^<!--/) next                                 # HTML 注释
      if (t in skip) next                                   # 模板原文，没动过
      if (t ~ /^([-*+]|[0-9]+[.)])$/) next                  # 空列表项 "-" / "1."
      if (t ~ /^([-*+]|[0-9]+[.)])[ \t]/ && t ~ /(：|:)$/) next   # "- 标签：" 空占位
      n++
    }
    END { print n + 0 }
  ' "$1"
}

# $1 = 显示用的名字，$2 = 实际读取的文件，$3 = 模板
check_one() {
  local name="$1" file="$2" tpl="$3"

  if ! grep -qE "^##[[:space:]]*13(\.|、)" "$file"; then
    echo "❌ $name: 缺第 13 节 (12-24 月里程碑预测)"
    echo "   这是 self-reflection 锚点，不许跳过"
    return 1
  fi

  local n
  n=$(count_substantive "$file" "$tpl")
  if [ "$n" -lt "$MIN_LINES" ]; then
    echo "❌ $name: 第 13 节还没填（实质内容 $n 行 < $MIN_LINES 行；模板占位不算）"
    echo "   要求至少写出："
    echo "   - 收入到 X"
    echo "   - 团队到 Y 人"
    echo "   - 关键产品里程碑"
    echo "   - 下一轮估值预期"
    echo "   - 最大不确定性"
    return 1
  fi

  echo "✓ $name 第 13 节合规"
}

template_for() {
  local sibling
  sibling="$(dirname "$1")/_template.md"
  if [ -f "$sibling" ]; then echo "$sibling"
  elif [ -f "$REPO_TEMPLATE" ]; then echo "$REPO_TEMPLATE"
  else echo ""
  fi
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

FAILED=0

if [ "$1" = "--staged" ]; then
  # -z：路径原样输出，中文文件名不会被 git 转义成 "\346..."
  # --diff-filter=ACMR：删除的 memo 不查
  TMP=$(mktemp)
  trap 'rm -f "$TMP"' EXIT
  while IFS= read -r -d '' path; do
    case "$path" in
      4-memos/*.md|*/4-memos/*.md) ;;
      *) continue ;;
    esac
    case "$(basename "$path")" in _*) continue ;; esac
    git show ":$path" > "$TMP"          # 查暂存区里的版本，不是工作区
    check_one "$path" "$TMP" "$(template_for "$path")" || FAILED=1
  done < <(git diff --cached --name-only --diff-filter=ACMR -z)
  exit "$FAILED"
fi

for memo in "$@"; do
  if [ ! -f "$memo" ]; then
    echo "❌ 文件不存在: $memo"
    FAILED=1
    continue
  fi
  check_one "$memo" "$memo" "$(template_for "$memo")" || FAILED=1
done

exit "$FAILED"
