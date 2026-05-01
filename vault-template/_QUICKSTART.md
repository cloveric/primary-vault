# 🚀 第一次打开 vault 看这里

> 你刚 clone 了 primary-vault 并把 vault-template/ 当 vault 打开。文件夹一脸懵？做下面 3 件事。

---

## 1️⃣ 先填你自己的 thesis（5 分钟）

打开 [[_thesis]]，填基本信息（投资范围 / 阶段 / 赛道偏好）。

不用一次填完，先有个 v1：

- **阶段**：你主投种子？A 轮？还是 PE 阶段？
- **赛道**：硬科技 / 消费 / SaaS / 跨赛道？
- **单笔金额**：min — max
- **目标 ownership**：% range

这是你的"宪法"。每次决策回到这里对照。

---

## 2️⃣ 录入 1-2 个真实 portfolio（15 分钟）

挑你已投的、最熟的 1-2 家公司，按 portfolio-company 模板录入：

1. 复制 `1-portfolio/companies/_template.md` 为 `1-portfolio/companies/<公司名>.md`
2. 填 frontmatter（必填：company、industry、our_round、our_role、status、first_investment_date、total_invested、next_review_due、primary_founder、project_root）
3. **`project_root` 是关键**：填你那家公司**在电脑上的工作文件目录绝对路径**（例如 `/Users/yourname/work/portfolio/X 公司`）
4. 写一段"## 关键变量监测"——3 条 checkbox 是你这家公司值得跟踪的

---

## 3️⃣ 创建一份创始人 person 笔记（5 分钟）

在 [[3-people/_template]] 复制一份给那家公司的 CEO。填好 wechat / email / 联系频率。

把 portfolio 笔记 frontmatter 的 `primary_founder: "[[<姓名>]]"` 链过去。

---

## 然后呢？接下来怎么用

### 立刻能干的 5 件事

1. **打开 [[_dashboard]]** —— 看你刚录入的 portfolio 在 Bases 视图里长什么样
2. **跟 Claude 说**："列出我所有 portfolio 公司"——它会按 deal-router skill 工作
3. **跟 Claude 说**："智能制造科技给我做个董事会准备"（或你刚录入的公司）——演示 Action 7
4. **看 [[bases/runway-警报]]** —— 如果你录入的某家 runway < 9，会出现在这里
5. **建一份 memo**：复制 `4-memos/_template.md`，写一份你最近一笔投资的回头 memo（即便已投，也值得回头梳理 thesis）

### 完整能干的事

读 `docs/DIALOGUES.md` —— 36 个真实场景对话，看 Claude 在 vault 里能干啥。

读 `docs/CADENCE.md` —— 日 / 周 / 月 / 季 / 年 节奏，怎么把这套流程嵌入你的工作。

---

## 常见问题

### Q: 必须把所有原始 PDF / Excel 拷进 vault 吗？

**不要！** 设计原则：vault 是**索引层**，原始文件留在 `~/work/...`。每个 portfolio 笔记的 frontmatter `project_root` + `files: {memo, financial_model, ...}` 指向真实文件位置。Claude 通过这个映射路由。

### Q: 我现有 portfolio 30 家，怎么 onboard？

**不要一次性迁完。** 两个建议：

1. **新 deal 从今天开始按这套来** —— 3 个月后 active portfolio 一半就在 vault 里了
2. **老 portfolio 季度复盘时录入** —— 下次季度复盘时每家**只录关键 frontmatter**（不用全部细节）

### Q: 这个 vault 我要不要用 git 管理？

**强烈建议。** 在 vault 根目录跑 `git init` + 每天 `git commit -am "daily snapshot"`。如果 Claude 改错了你能 `git checkout` 回滚。

### Q: 字段名为什么是英文？

v0.4 起字段名改成 snake_case 英文（`runway_months` 而不是 `runway 月数`）。**显示**仍是中文（通过 Bases 的 `displayName`）。这样跨工具迁移、SUM 公式、引用都顺。

### Q: 我不是 VC，是 PE / CVC / 家办，能用吗？

能。primary-vault v0.2 起 scope 已扩到全私募市场。skill 名字也叫 `deal-router` 不叫 `vc-router`。

---

接下来 30 分钟最有价值：跟 Claude 互动一遍上面 5 件事，找一两个你**最烦的工作流**让 skill 帮你跑。

跑顺了，就把它嵌入你的日常 cadence。三周后这套就成了"你做投资的方式"，不再是另一个工具。
