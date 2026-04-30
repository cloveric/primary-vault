---
type: dashboard
---

# 📊 Fund Dashboard

> 整体 portfolio 状态 · 周扫描入口 · 季度复盘锚点

---

## 🚨 Runway 警报（< 6 月）

> 替换为你的 Bases 视图：`bases/runway-警报.base`
> 在 Obsidian 里：右键 `bases/runway-警报.base` → "Embed in current note"

```base
SOURCE FROM "1-portfolio/companies"
WHERE type == "portfolio-company" AND status == "active" AND runway-月数 < 6
SORT BY runway-月数 ASC
```

---

## 😴 沉默超过 90 天

> 替换为你的 Bases 视图：`bases/沉默90天.base`

```base
SOURCE FROM "1-portfolio/companies"
WHERE type == "portfolio-company" AND status == "active"
  AND最近-update < (today() - 90)
SORT BY 最近-update ASC
```

---

## 🎯 Follow-on 候选

```base
SOURCE FROM "1-portfolio/companies"
WHERE type == "portfolio-company" AND follow-on-优先级 == "高"
SORT BY 下次复盘截止 ASC
```

---

## 📥 Pipeline 漏斗

```base
SOURCE FROM "0-pipeline"
WHERE type == "pipeline-deal"
GROUP BY 当前阶段
```

---

## ⏰ 本周/本月该复盘的

```base
SOURCE FROM "1-portfolio/companies"
WHERE type == "portfolio-company" AND 下次复盘截止 < (today() + 7)
SORT BY 下次复盘截止 ASC
```

---

## 🗒 操作面板（手动 link）

- [[_thesis|💭 我的投资策略]]
- [[7-reviews/最新月报]] · [[7-reviews/最新季报]]
- 周扫描：`tell claude "做周扫描"`
- 月报：`tell claude "生成本月月报"`
- 季度复盘：`tell claude "Q<n> 复盘"`
