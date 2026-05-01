#!/usr/bin/env bash
# lint-vault.sh — 检查 vault 是否符合 primary-vault v0.4 约定
#
# 用法（在 vault 根目录跑）：
#   bash /path/to/primary-vault/scripts/lint-vault.sh
#
# 检查：
#   1. type 字段是不是合法枚举
#   2. portfolio-company 必填字段是否齐全
#   3. memo 是否有第 13 节
#   4. 日期格式是不是 ISO

set -euo pipefail

VAULT_ROOT="${1:-$(pwd)}"

if [ ! -d "$VAULT_ROOT/0-pipeline" ] && [ ! -d "$VAULT_ROOT/1-portfolio" ]; then
  echo "❌ $VAULT_ROOT 看着不像 primary-vault 风格的 vault"
  echo "   应该有 0-pipeline/ 或 1-portfolio/ 目录"
  exit 1
fi

ISSUES=0
WARN=0

echo "=== Linting $VAULT_ROOT ==="
echo

# 检查 1：portfolio-company 缺必填字段
echo "📋 检查 1: portfolio-company 必填字段"
REQUIRED_PORTFOLIO=(company industry our_round our_role status first_investment_date total_invested next_review_due primary_founder project_root)

for f in "$VAULT_ROOT/1-portfolio/companies"/*.md; do
  [ -e "$f" ] || continue
  fname=$(basename "$f")
  [ "$fname" = "_template.md" ] && continue

  # 拿前 50 行前面（frontmatter 部分）
  fm=$(head -60 "$f")

  # 检查每个必填字段
  for field in "${REQUIRED_PORTFOLIO[@]}"; do
    if ! echo "$fm" | grep -qE "^${field}:"; then
      echo "  ⚠️  $fname 缺字段: $field"
      WARN=$((WARN+1))
    fi
  done

  # 检查 type 字段值
  type_val=$(echo "$fm" | grep "^type:" | head -1 | awk '{print $2}')
  if [ "$type_val" != "portfolio-company" ]; then
    echo "  ❌ $fname type 值错误：$type_val (应为 portfolio-company)"
    ISSUES=$((ISSUES+1))
  fi
done

# 检查 2：memo 是不是有第 13 节
echo
echo "📋 检查 2: memo 必备第 13 节 (12-24 月里程碑预测)"
for f in "$VAULT_ROOT/4-memos"/*.md; do
  [ -e "$f" ] || continue
  fname=$(basename "$f")
  [ "$fname" = "_template.md" ] && continue

  if ! grep -qE "^## 13\." "$f"; then
    echo "  ⚠️  $fname 缺第 13 节"
    WARN=$((WARN+1))
  fi
done

# 检查 3：日期格式
echo
echo "📋 检查 3: 日期格式应为 ISO YYYY-MM-DD"
BAD_DATES=$(grep -rEn "^[a-z_]+: [0-9]+/[0-9]+/[0-9]+" "$VAULT_ROOT" 2>/dev/null --include="*.md" | head -10 || true)
if [ -n "$BAD_DATES" ]; then
  echo "  ⚠️  发现非 ISO 日期格式："
  echo "$BAD_DATES" | sed 's/^/    /'
  WARN=$((WARN+1))
fi

# 检查 4：v0.3 旧字段名残留
echo
echo "📋 检查 4: v0.3 旧字段名残留（应该全改成 v0.4 snake_case）"
OLD_FIELDS=("公司:" "行业:" "赛道:" "我方轮次:" "状态:" "首次投资日期:" "我方累计投资:" "runway 月数:" "最近 update:" "下次复盘截止:" "首席创始人:" "我的董事会角色:" "follow-on 优先级:")
for old in "${OLD_FIELDS[@]}"; do
  hits=$(grep -rl "^$old" "$VAULT_ROOT" --include="*.md" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "  ⚠️  发现 v0.3 旧字段 '$old' 在："
    echo "$hits" | sed 's/^/    /'
    WARN=$((WARN+1))
  fi
done

# 检查 5：frontmatter 不是合法 YAML（可选 —— 需要 python3 + yaml 包）
echo
echo "📋 检查 5: frontmatter 是合法 YAML（需要 python3 + pyyaml）"
HAS_YAML=0
if command -v python3 >/dev/null 2>&1; then
  if python3 -c "import yaml" 2>/dev/null; then
    HAS_YAML=1
  fi
fi

if [ "$HAS_YAML" -eq 0 ]; then
  echo "  ⊘ python3 / pyyaml 不可用，跳过 YAML 校验"
  echo "  （装一下：pip3 install pyyaml）"
else
  for f in "$VAULT_ROOT"/{1-portfolio/companies,0-pipeline/*,2-exited,4-memos,5-updates,6-board-notes,7-reviews,3-people}/*.md; do
    [ -e "$f" ] || continue
    fname=$(basename "$f")
    [ "$fname" = "_template.md" ] && continue
    [ "$fname" = ".gitkeep" ] && continue

    python3 -c "
import yaml, sys
with open('$f') as fh:
    content = fh.read()
if not content.startswith('---'):
    sys.exit(0)
end = content.find('---', 3)
if end < 0:
    print('  ❌ $fname frontmatter 没闭合')
    sys.exit(1)
fm = content[3:end]
try:
    yaml.safe_load(fm)
except yaml.YAMLError as e:
    print(f'  ❌ $fname YAML 错误: {e}')
    sys.exit(1)
" || ISSUES=$((ISSUES+1))
  done
fi

echo
echo "============================="
echo "  Errors:   $ISSUES"
echo "  Warnings: $WARN"
echo "============================="

if [ "$ISSUES" -gt 0 ]; then
  exit 1
fi
