# 架构 · vault-as-router

## 核心比喻

把 Obsidian vault 当成**机场塔台**：

- 飞机（你的工作文件 / PDF / Excel / DD 资料）停在停机坪上（`~/work/...`）
- 塔台不开飞机，**它知道每架飞机停在哪**
- 你跟塔台说"调度 23 号停机位的飞机做 X"——塔台告诉调度员（Claude）该去哪

vault 不存原始文件，**它存索引、状态、决策、关联**。这是它的核心设计原则。

## 为什么不把所有文件塞进 vault

很多人初次用 Obsidian 会冲动把所有 PDF / Excel 拖进 vault。后果：

1. **vault 越来越臃肿**——同步慢、备份大、Obsidian 启动慢
2. **二进制文件 vault 内不可搜**——失去 vault 的核心价值（全文检索）
3. **协作困难**——别的工具（律师、会计、共投人）拿不到原文件
4. **跟外部工作流脱节**——Excel 在 vault 里，但你 Mac 上的"最近文件"从来不到这里

vault 该装的：
- ✅ 公司笔记（结构化 frontmatter + 自由文本）
- ✅ Memo（思考记录）
- ✅ 决策日志
- ✅ 复盘 + thesis
- ✅ 人物笔记
- ❌ Pitch deck 原 PDF
- ❌ Excel 财务模型
- ❌ 法律合同原稿
- ❌ DD 收来的财报 PDF / 客户合同 etc.

## 数据流

```
                    ┌─────────────────────────────────┐
                    │         你的工作目录            │
                    │  ~/work/portfolio/<公司>/       │
                    │  • financial-model.xlsx         │
                    │  • pitch-deck.pdf               │
                    │  • DD/                          │
                    │  • contracts/                   │
                    │  • meetings/                    │
                    └────────────┬────────────────────┘
                                 │
                                 │  指针（frontmatter.files）
                                 │
                    ┌────────────▼────────────────────┐
                    │      Obsidian Vault             │
                    │  vault/1-portfolio/companies/   │
                    │  └─ <公司>.md                   │
                    │     frontmatter:                │
                    │       project_root: /work/...   │
                    │       files: { ... }            │
                    │     body:                       │
                    │       overview, status,         │
                    │       decisions, links          │
                    └────────────┬────────────────────┘
                                 │
                                 │  调度
                                 │
                    ┌────────────▼────────────────────┐
                    │    Claude Code / Codex          │
                    │  - 读 vault 笔记                │
                    │  - 解析 frontmatter             │
                    │  - 路由到 work 目录             │
                    │  - 干活                         │
                    │  - 写日志回 vault               │
                    └─────────────────────────────────┘
```

## 三层抽象

### 第 1 层：原始文件（你的工作目录）

最自然的状态——不强制任何结构。你的电脑里本来就有这些 PDF / Excel。

### 第 2 层：索引（vault）

一对一映射到第 1 层，但**只存元数据 + 决策 + 链接**：
- `公司`, `runway`, `估值`, `状态` 等结构化字段
- 投资逻辑、关键变量、退出条件等思考
- wikilinks 互相串联（人 ↔ 公司 ↔ memo ↔ 决策）

### 第 3 层：路由（skill）

定义 vault → 工作文件的映射规则。skill 让 Claude 知道：
- 看到公司名 → 怎么找笔记
- 看到笔记 → 怎么读 frontmatter
- 拿到路径 → 怎么进文件夹
- 干完活 → 怎么写回 vault

**第 3 层是这个仓库的核心 IP**——前两层人人都能搭，第 3 层让它从"笔记系统"变成"操作系统"。

## 为什么 frontmatter 是接口

frontmatter 是 vault 中**唯一三个角色都能读写的地方**：

1. **人类**：在 Obsidian 里直接看（property panel）
2. **Bases**：靠 frontmatter 字段做视图
3. **Claude/Codex**：通过 skill 教会读写规则

因此 frontmatter 字段名是**契约**——约定好了所有三方都遵守，就成立。

primary-vault 的 frontmatter 约定见 [`CONVENTIONS.md`](CONVENTIONS.md)。

## "近期操作"日志为什么强制

每次 Claude 操作完一个项目笔记，必须 append 一条到 `## 近期操作` section + 更新 `last_action` frontmatter。原因：

- **审计**：你过去 3 个月对每家公司做了什么，一目了然
- **诊断 self-deception**：你以为你在跟进，实际 last_action 是 4 个月前
- **复盘材料**：季度复盘时，自动有完整时间线
- **多人协作时**：合伙人 / 助理之间的交接记录

不写日志的 Claude 操作 = 静音操作 = 不存在的操作。这是非常重要的纪律。

## 决策日志 vs Memo 的区别

- **Memo**：投前的论点 + 假设 + 预测（这次为什么投）
- **决策日志**：每次重大决策的 5 分钟思考记录（加仓 / 减仓 / 不再投 / 退出 / 强参与下一轮）

Memo 一个 deal 一份。决策日志可能很多份——每次"动手"前先写一句。

很多 VC 只写 memo 不写决策日志，结果回头看不出"我什么时候开始觉得这家不行的"。

## 跟其他系统的对比

| 系统 | 优势 | 短板 |
|---|---|---|
| **Excel + 文件夹** | 谁都会用 | 没结构化思考、没关联、决策无痕 |
| **Notion** | 好看、协作 | 数据被锁、agent 接入难、本地不可控 |
| **Affinity / DealCloud** | 专业 VC CRM | 贵、定制差、AI 集成弱 |
| **primary-vault** | plaintext + AI 原生 + 完全可控 | 需要自己搭 / 学曲线 |

适合：**自己组合工具的人**、**不愿被 SaaS 锁定的人**、**重度使用 LLM 的人**。

不适合：**讨厌折腾的人**、**纯接受现成产品的人**。

## 设计原则总结

1. **plaintext first**：所有结构化数据 markdown + frontmatter，永远可读
2. **Vault 是索引，不是仓库**：原始文件留外面
3. **frontmatter 是契约**：人 / Bases / Claude 都靠它
4. **写回纪律**：每次动作 → "近期操作" + `last_action`
5. **思考留痕**：memo + 决策日志双重，self-reflection 强制
6. **Skill 是肌肉记忆**：约定写一次，agent 学一辈子
