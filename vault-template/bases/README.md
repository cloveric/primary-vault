# Bases 视图

7 个 `.base` 文件是 primary-vault 的核心仪表盘 —— 全部由 frontmatter 驱动，**无需任何插件**（Bases 是 Obsidian 1.9+ 自带核心功能）。

## 用法

1. 在 Obsidian 里点开任何一个 `.base` 文件就能看到表格
2. 也可以**嵌入到 `_dashboard.md` 笔记**里：在笔记里点 `+` → "Embed Base" → 选 `runway-警报`

## 7 个视图

| 文件 | 干嘛 | 触发条件 |
|---|---|---|
| `runway-警报.base` | 🚨 现金紧的 portfolio | `runway_months < 9`（红 < 6, 黄 6-9）|
| `沉默90天.base` | 😴 该 ping 创始人 | `last_update` > 90 天 |
| `董事会due.base` | 🏛️ 即将开会 | `next_board_meeting` 在未来 14 天内 |
| `follow-on-候选.base` | 🎯 该决定加仓的 | `follow_on_priority = high` AND `current_funding_round ≠ none` |
| `pipeline-漏斗.base` | 📥 在看的 deal | 全 pipeline 按阶段 group |
| `复盘due.base` | ⏰ 该季度走查的 | `next_review_due < today` |
| `退出追踪.base` | 🚪 退出流程中 | `current_funding_round ∈ {ipo-prep, ma-negotiation}` |

## 字段名约定（v0.4 起）

字段名一律 **snake_case 英文**（如 `runway_months`、`current_moic`、`follow_on_priority`），**显示中文**通过 Bases 的 `displayName` 实现：

```yaml
properties:
  note.runway_months:
    displayName: "Runway (月)"
```

人看到的是中文，YAML 写的是干净英文。跨工具迁移、SUM/AVG 公式、Bases 引用都更顺手。

## ⚠️ 已知未充分验证的语法

下面这几条**基于 Obsidian 公开 Bases 文档写的，但作者未在所有 Obsidian 版本测过**：

- **`today()` 函数** —— 返回当前日期。最新文档明确支持。
- **日期算术 `(today() - note.field) / 86400000`** —— 把日期当 Unix ms 算。如果你的 Obsidian 版本不支持，formula 会显示空值。
- **`formula.<name>` 在 filters 里被引用** —— 部分版本可能要求 formula 先在 view 中 declare。
- **`groupBy` 嵌套语法** —— `property: ... direction: ...`。

如果哪个 view 渲染不出来：

1. 在 Obsidian 里打开 .base 文件，看 console 报错
2. 用 Obsidian 的 GUI 编辑器复刻一份正常的 view，对比 YAML 结构
3. 把改动 PR 到 [primary-vault](https://github.com/cloveric/primary-vault) 让所有人受益

## 自定义

每个 `.base` 文件都很短（30-40 行），结构清晰：

```yaml
filters:        # 全局过滤（所有视图共用）
  and: [...]
formulas:       # 计算字段
  ...
properties:     # 字段显示名
  ...
views:          # 一个 .base 可以有多个 view
  - type: table
    name: ...
    filters: ...
    order: ...
```

直接编辑 YAML 改成你想要的过滤 / 列。
