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

COMPANY="$1"
STAGE="${2:-2-meeting}"

# 找 vault 根 (含 .obsidian 的祖先目录)
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

cat > "$DEAL_FILE" <<EOF
---
type: pipeline-deal
公司: $COMPANY
来源: "[[]]"
首次接触: $TODAY
当前阶段: ${STAGE#*-}
推荐金额:
推荐估值:
预计投决日期:
负责合伙人: 我
风险打分:
机会打分:
project_root: ~/work/pipeline/$COMPANY
files:
  pitch:
  财务:
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
