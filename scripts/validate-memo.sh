#!/usr/bin/env bash
# validate-memo.sh — 检查 memo 文件第 13 节有内容
# 这个 enforce "12-24 月里程碑预测必填" 的硬约束
#
# 用法：bash validate-memo.sh path/to/memo.md
# 或者作为 pre-commit hook（exit 1 阻止 commit）

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法: bash validate-memo.sh <memo.md>"
  exit 1
fi

MEMO="$1"

if [ ! -f "$MEMO" ]; then
  echo "❌ 文件不存在: $MEMO"
  exit 1
fi

# 检查第 13 节存在
if ! grep -qE "^## 13\." "$MEMO"; then
  echo "❌ $MEMO: 缺第 13 节 (12-24 月里程碑预测)"
  echo "   这是 self-reflection 锚点，不许跳过"
  exit 1
fi

# 提取第 13 节到第 14 节之间的内容
SECTION_13=$(awk '/^## 13\./,/^## 14\./' "$MEMO" | sed '/^## 14/d' | sed '/^## 13/d')

# 去掉空行 + 前缀注释，看实质内容
SUBSTANTIAL=$(echo "$SECTION_13" | grep -vE "^[[:space:]]*$|^[[:space:]]*>" | wc -l)

if [ "$SUBSTANTIAL" -lt 3 ]; then
  echo "❌ $MEMO: 第 13 节内容太空（实质内容 < 3 行）"
  echo "   要求至少写出："
  echo "   - 收入到 X"
  echo "   - 团队到 Y 人"
  echo "   - 关键产品里程碑"
  echo "   - 下一轮估值预期"
  echo "   - 最大不确定性"
  exit 1
fi

echo "✓ $MEMO 第 13 节合规"
