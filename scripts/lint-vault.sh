#!/usr/bin/env bash
# lint-vault.sh — 检查 vault 是否符合 primary-vault v0.4 约定
#
# 用法（在 vault 根目录跑，或者把 vault 路径当参数）：
#   bash /path/to/primary-vault/scripts/lint-vault.sh [vault 根目录]
#
# 检查：
#   1. type 字段：缺失 → 警告；不在合法枚举里 → 错误
#   2. portfolio-company：必填字段齐全、Bases 用到的枚举值合法、project_root 是绝对路径
#   3. pipeline-deal：current_stage 跟所在阶段文件夹一致
#   4. memo 有第 13 节
#   5. 日期格式是 ISO（YYYY-MM-DD）
#   6. v0.3 旧中文字段名残留
#   7. frontmatter 是合法 YAML（需要 python3 + pyyaml，没有就跳过）
#
# 以 _ 开头的文件（_template.md 等模板）一律跳过。
# 有错误时 exit 1；只有警告时 exit 0。

set -euo pipefail

VAULT_ROOT="${1:-$(pwd)}"

if [ ! -d "$VAULT_ROOT/0-pipeline" ] && [ ! -d "$VAULT_ROOT/1-portfolio" ]; then
  echo "❌ $VAULT_ROOT 看着不像 primary-vault 风格的 vault"
  echo "   应该有 0-pipeline/ 或 1-portfolio/ 目录"
  exit 1
fi

NOTE_DIRS=(0-pipeline 1-portfolio 2-exited 3-people 4-memos 5-updates 6-board-notes 7-reviews)
VALID_TYPES=(portfolio-company pipeline-deal memo person update board-meeting board-prep exit exit-retrospective exit-tracking review decision dashboard)
REQUIRED_PORTFOLIO=(company industry our_round our_role status first_investment_date total_invested next_review_due primary_founder project_root)

ISSUES=0
WARN=0

err()  { echo "  ❌ $*"; ISSUES=$((ISSUES+1)); }
warn() { echo "  ⚠️  $*"; WARN=$((WARN+1)); }

# 打印 frontmatter（第一行 --- 到下一行 --- 之间）；没有 frontmatter 就什么都不打
frontmatter() {
  awk 'NR == 1 { if ($0 ~ /^---[ \t\r]*$/) { f = 1; next } else exit }
       f && /^---[ \t\r]*$/ { exit }
       f' "$1"
}

# 取 frontmatter 里一个顶层字段的值：去掉行尾注释和外层引号
# $1 = frontmatter 文本，$2 = 字段名
fm_get() {
  awk -v k="$2" '
    index($0, k ":") == 1 {
      v = substr($0, length(k) + 2)
      sub(/[ \t]+#.*$/, "", v); sub(/^[ \t]+/, "", v); sub(/[ \t\r]+$/, "", v)
      if (v ~ /^".*"$/ || v ~ /^\047.*\047$/) v = substr(v, 2, length(v) - 2)
      print v; exit
    }' <<<"$1"
}

has_field() { grep -q "^$2:" <<<"$1"; }

in_list() {  # in_list <值> <合法值...>
  local v="$1" x; shift
  for x in "$@"; do [ "$v" = "$x" ] && return 0; done
  return 1
}

# 枚举值检查：空值不报（必填另查）
# $1 = 文件显示名，$2 = frontmatter，$3 = 字段，其余 = 合法值
check_enum() {
  local name="$1" fm="$2" field="$3" val; shift 3
  val=$(fm_get "$fm" "$field")
  [ -z "$val" ] && return 0
  in_list "$val" "$@" || err "$name: $field 值「${val}」不合法（应为：$*）—— Bases 视图会漏掉它"
}

# 收集所有笔记（跳过 _ 开头的模板）
NOTES=()
for d in "${NOTE_DIRS[@]}"; do
  [ -d "$VAULT_ROOT/$d" ] || continue
  while IFS= read -r -d '' f; do
    NOTES+=("$f")
  done < <(find "$VAULT_ROOT/$d" -type f -name '*.md' ! -name '_*' -print0)
done

echo "=== Linting $VAULT_ROOT (${#NOTES[@]} 份笔记) ==="
echo

# 检查 1-4：逐文件看 frontmatter
echo "📋 检查 1-4: type / portfolio 必填 + 枚举 / pipeline 阶段 / memo 第 13 节"
for f in ${NOTES[@]+"${NOTES[@]}"}; do
  rel="${f#"$VAULT_ROOT"/}"
  fm=$(frontmatter "$f")

  if ! has_field "$fm" type; then
    warn "$rel 没有 type 字段（skill 靠 type 分流）"
    continue
  fi
  type_val=$(fm_get "$fm" type)
  if ! in_list "$type_val" "${VALID_TYPES[@]}"; then
    err "$rel type 值「${type_val}」不在合法枚举里"
    continue
  fi

  case "$type_val" in
    portfolio-company)
      for field in "${REQUIRED_PORTFOLIO[@]}"; do
        has_field "$fm" "$field" || warn "$rel 缺字段: $field"
      done
      check_enum "$rel" "$fm" status active struggling fundraising exited-ipo exited-ma written-off
      check_enum "$rel" "$fm" current_funding_round none started dd ts-negotiation signed ipo-prep ma-negotiation
      check_enum "$rel" "$fm" follow_on_priority high medium low never
      check_enum "$rel" "$fm" my_board_role director observer none
      root=$(fm_get "$fm" project_root)
      case "$root" in
        "") ;;
        /path/to/*) warn "$rel project_root 还是占位符: $root" ;;
        /*) ;;
        *) warn "$rel project_root 不是绝对路径: ${root}（不能用 ~ 或相对路径）" ;;
      esac
      ;;
    pipeline-deal)
      stage=$(fm_get "$fm" current_stage)
      check_enum "$rel" "$fm" current_stage screening meeting dd ic pass
      case "$rel" in
        0-pipeline/1-初筛/*)   expect=screening ;;
        0-pipeline/2-meeting/*) expect=meeting ;;
        0-pipeline/3-DD中/*)   expect=dd ;;
        0-pipeline/4-IC/*)     expect=ic ;;
        0-pipeline/5-pass/*)   expect=pass ;;
        *) expect="" ;;
      esac
      if [ -n "$expect" ] && [ -n "$stage" ] && [ "$stage" != "$expect" ]; then
        warn "$rel 在 ${rel%/*}/ 里，但 current_stage 是「${stage}」（应为 ${expect}）"
      fi
      ;;
    memo)
      grep -qE "^##[[:space:]]*13(\.|、)" "$f" || warn "$rel 缺第 13 节 (12-24 月里程碑预测)"
      ;;
  esac
done

# 检查 5：日期格式
echo
echo "📋 检查 5: 日期格式应为 ISO YYYY-MM-DD"
BAD_DATES=$(grep -rEn --include='*.md' '^[a-z_]+: *"?([0-9]+/[0-9]+/[0-9]+|[0-9]{4}年)' "$VAULT_ROOT" 2>/dev/null | head -10 || true)
if [ -n "$BAD_DATES" ]; then
  warn "发现非 ISO 日期格式："
  echo "$BAD_DATES" | sed 's/^/    /'
fi

# 检查 6：v0.3 旧字段名残留
echo
echo "📋 检查 6: v0.3 旧字段名残留（应该全改成 v0.4 snake_case）"
OLD_FIELDS=("公司:" "行业:" "赛道:" "我方轮次:" "状态:" "首次投资日期:" "我方累计投资:" "runway 月数:" "最近 update:" "下次复盘截止:" "首席创始人:" "我的董事会角色:" "follow-on 优先级:")
for old in "${OLD_FIELDS[@]}"; do
  hits=$(grep -rl --include='*.md' "^$old" "$VAULT_ROOT" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    warn "发现 v0.3 旧字段 '$old' 在："
    echo "$hits" | sed 's/^/    /'
  fi
done

# 检查 7：frontmatter 是合法 YAML（可选 —— 需要 python3 + pyyaml）
echo
echo "📋 检查 7: frontmatter 是合法 YAML（需要 python3 + pyyaml）"
if ! command -v python3 >/dev/null 2>&1 || ! python3 -c "import yaml" 2>/dev/null; then
  echo "  ⊘ python3 / pyyaml 不可用，跳过 YAML 校验"
  echo "  （装一下：pip3 install pyyaml）"
elif [ ${#NOTES[@]} -gt 0 ]; then
  # 文件路径走 argv，不拼进 Python 源码（文件名带引号也不会炸）
  # 退出码 = 出错的文件数
  set +e
  python3 - "$VAULT_ROOT" "${NOTES[@]}" <<'PY'
import os, sys, yaml

root, paths = sys.argv[1], sys.argv[2:]
bad = 0
for path in paths:
    rel = os.path.relpath(path, root)
    with open(path, encoding='utf-8') as fh:
        lines = fh.read().splitlines()
    if not lines or lines[0].strip() != '---':
        continue
    # 闭合的 --- 必须独占一行；值里出现 "a---b" 不算
    end = next((i for i in range(1, len(lines)) if lines[i].strip() == '---'), None)
    if end is None:
        print(f'  ❌ {rel}: frontmatter 没闭合')
        bad += 1
        continue
    try:
        yaml.safe_load('\n'.join(lines[1:end]))
    except yaml.YAMLError as e:
        print(f'  ❌ {rel}: YAML 错误: {e}')
        bad += 1
sys.exit(min(bad, 125))
PY
  bad=$?
  set -e
  ISSUES=$((ISSUES+bad))
fi

echo
echo "============================="
echo "  Errors:   $ISSUES"
echo "  Warnings: $WARN"
echo "============================="

if [ "$ISSUES" -gt 0 ]; then
  exit 1
fi
