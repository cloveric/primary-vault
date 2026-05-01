#!/usr/bin/env bash
# new-deal.sh — 快速建一个新 deal 骨架
#
# 用法：
#   bash new-deal.sh <公司名> [stage]
#
# 例：
#   bash new-deal.sh 智能制造科技
#   bash new-deal.sh "AI 芯片公司" 3-DD中
#
# 默认 stage = 2-meeting

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法: bash new-deal.sh <公司名> [stage]"
  echo "  stage: 1-初筛 / 2-meeting / 3-DD中 / 4-IC / 5-pass (默认 2-meeting)"
  exit 1
fi

COMPANY_RAW="$1"
STAGE="${2:-2-meeting}"

# Sanitize 文件名：去掉文件系统不允许的字符 / : * ? " < > | \
COMPANY=$(echo "$COMPANY_RAW" | sed 's|[/:*?"<>|\\]|-|g')

if [ "$COMPANY" != "$COMPANY_RAW" ]; then
  echo "⚠️  公司名含特殊字符，已 sanitize: '$COMPANY_RAW' → '$COMPANY'"
fi

# 找 vault 根 (含 0-pipeline 的祖先目录)
VAULT_ROOT=$(pwd)
while [ "$VAULT_ROOT" != "/" ]; do
  if [ -d "$VAULT_ROOT/.obsidian" ] || [ -d "$VAULT_ROOT/0-pipeline" ]; then
    break
  fi
  VAULT_ROOT=$(dirname "$VAULT_ROOT")
done

if [ ! -d "$VAULT_ROOT/0-pipeline" ]; then
  echo "❌ 没找到 vault 根（应该有 0-pipeline/ 目录）"
  echo "   请在你 primary-vault 风格的 vault 里运行此脚本"
  exit 1
fi

PIPELINE_DIR="$VAULT_ROOT/0-pipeline/$STAGE"
DEAL_FILE="$PIPELINE_DIR/$COMPANY.md"

if [ ! -d "$PIPELINE_DIR" ]; then
  echo "❌ 阶段目录不存在: $PIPELINE_DIR"
  echo "   可选: $(ls $VAULT_ROOT/0-pipeline | tr '\n' ' ')"
  exit 1
fi

if [ -e "$DEAL_FILE" ]; then
  echo "⚠️  $DEAL_FILE 已存在，跳过"
  exit 0
fi

TODAY=$(date +%Y-%m-%d)
NOW=$(date +"%Y-%m-%d %H:%M")

# Stage name → enum value
case "$STAGE" in
  1-初筛) STAGE_VAL=screening ;;
  2-meeting) STAGE_VAL=meeting ;;
  3-DD中) STAGE_VAL=dd ;;
  4-IC) STAGE_VAL=ic ;;
  5-pass) STAGE_VAL=pass ;;
  *) STAGE_VAL=meeting ;;
esac

cat > "$DEAL_FILE" <<EOF
---
type: pipeline-deal
company: $COMPANY
source: "[[]]"
first_contact_date: $TODAY
current_stage: $STAGE_VAL
recommended_amount:
recommended_valuation:
expected_decision_date:
lead_partner: 我
risk_score:
opportunity_score:
project_root: ~/work/pipeline/$COMPANY
files:
  pitch:
  financial_model:
last_action: $NOW 创建 deal 骨架
tags: [pipeline, sector/, stage/]
---

# $COMPANY

## 公司在干嘛 (What)

## 创始团队 (Who)

## 市场 / Why Now

## 我的初步判断

- 机会：
- 风险：

## 下一步

- [ ] 拿到 pitch deck / 财务模型
- [ ] 见创始人
- [ ] 评估是否进 DD

## 近期操作

- $NOW 创建 deal 骨架
EOF

echo "✓ 已创建: $DEAL_FILE"
echo
echo "建议下一步："
echo "  1. cd $VAULT_ROOT && claude"
echo "  2. 跟 Claude 说：「$COMPANY 我刚见过创始人，主要内容是…」"
echo "     Claude 会按 deal-router skill 帮你填好关键字段"
