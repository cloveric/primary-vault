# Bases 视图

这 7 个 `.base` 文件是 primary-vault 的核心仪表盘 —— 全部由 frontmatter 驱动，**无需任何插件**（Bases 是 Obsidian 1.9+ 自带核心功能）。

## 用法

1. 在你的 vault 里把这些文件复制到 `bases/` 目录
2. 在 Obsidian 里点开任何一个 `.base` 文件就能看到表格
3. 也可以**嵌入到 `_dashboard.md` 笔记**里：
   - 在笔记里点 `+` → "Embed Base" → 选 `runway-警报`

## 7 个视图

| 文件 | 干嘛 | 触发条件 |
|---|---|---|
| `runway-警报.base` | 🚨 现金紧的 portfolio | `runway 月数 < 9` （红 < 6, 黄 6-9）|
| `沉默90天.base` | 😴 该 ping 创始人 | `最近 update` > 90 天 |
| `董事会due.base` | 🏛️ 即将开会 | `下次董事会` 在未来 14 天内 |
| `follow-on-候选.base` | 🎯 该决定加仓的 | `follow-on 优先级 = 高` AND `当前融资轮 ≠ 无` |
| `pipeline-漏斗.base` | 📥 在看的 deal | 全 pipeline 按阶段 group |
| `复盘due.base` | ⏰ 该季度走查的 | `下次复盘截止 < today` |
| `退出追踪.base` | 🚪 退出流程中 | `当前融资轮` 含 "上市辅导/IPO 申报/M&A 谈判/二级转让" |

## ⚠️ 字段名兼容说明

我们 frontmatter 用了**带空格的中文字段名**（如 `runway 月数`、`当前 MOIC`、`最新估值-投后`、`我方累计投资`、`follow-on 优先级`），Bases 里通过 **bracket 语法**引用：

```yaml
note["runway 月数"]
note["当前 MOIC"]
```

这套语法在 Obsidian 1.9+ 应该正常。如果你版本旧或 Bases 引擎有 bug，建议把 frontmatter 字段改成无空格英文版（比如 `runway_months`），然后批量改这 7 个 `.base` 文件 —— 用 `sed -i '' 's/note\["runway 月数"\]/note.runway_months/g' *.base` 即可。

## 自定义

每个 `.base` 文件都很短（30-40 行），结构清晰：

```yaml
filters:        # 全局过滤（所有视图共用）
  and: [...]
formulas:       # 计算字段（如：超期天数）
  ...
properties:     # 字段显示名
  ...
views:          # 一个 .base 可以有多个 view
  - type: table
    name: ...
    filters: ...   # 视图特异过滤
    order: ...     # 列顺序
```

直接编辑 YAML 改成你想要的过滤 / 列。
