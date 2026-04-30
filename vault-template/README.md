# vault-template

这是 vc-vault 的 Obsidian 骨架。两种用法：

## 用法 A：拷进你现有的 vault

```bash
cp -r vault-template/. /path/to/your/obsidian/vault/
```

跟你现有 vault 合并。

## 用法 B：作为独立 vault 打开

直接把 `vault-template/` 整个文件夹在 Obsidian 里"作为 vault 打开"。适合你想给一级投资单独搞一个 vault 的情况。

## 文件夹说明

| 路径 | 用途 |
|---|---|
| `_dashboard.md` | 总览面板，嵌 Bases 视图 |
| `_thesis.md` | 投资策略 / 宪法 |
| `0-pipeline/` | 在看的 deal，按阶段分子文件夹 |
| `1-portfolio/companies/` | 已投——每家公司一份笔记 |
| `2-exited/` | 退出（IPO / M&A / 写零）—— 留着复盘用 |
| `3-people/` | 人物（创始人 / 共投 / LP / 顾问） |
| `4-memos/` | 投资备忘录——每个 deal 一份 |
| `5-updates/` | 被投每季度 update 的结构化记录 |
| `6-board-notes/` | 董事会会议纪要 |
| `7-reviews/` | 周/月/季/年复盘 |
| `bases/` | Bases 视图文件 |

## 模板

每个文件夹里 `_template.md` 是该类笔记的模板。开新笔记时复制一份再改。

## 重要约定

- **每个 portfolio 公司**的 frontmatter 必须有 `project_root` —— 指向真实工作文件目录的绝对路径
- **每个 memo** 必须填到第 13 节"12-24 月里程碑预测"
- **每次操作**完都要写"近期操作"日志条目（Claude 会自动帮做）

完整约定见 [`docs/CONVENTIONS.md`](../docs/CONVENTIONS.md)
