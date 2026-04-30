# 操作节奏 · Cadence Playbook

> 一份给一级市场投资人的"操作时钟"——日 / 周 / 月 / 季 / 年五个节奏，每一档都说清"什么时候做、做什么、Claude 怎么帮"。

## 总览

```
─── 每天 ──── 每周 ──── 每月 ──── 每季 ──── 每年 ───
 │              │            │           │          │
 │              │            │           │          └─ Fund review + LP letter
 │              │            │           │
 │              │            │           └────── Portfolio 全复盘 + 估值更新 + 季报
 │              │            │
 │              │            └──────── Update 解析 + 月报 + 决策日志回访
 │              │
 │              └──────── Runway 扫描 + 沉默检查 + 董事会准备
 │
 └──── Pipeline 进展 + 见人 + 写 memo + 实时操作日志
```

---

## 🌅 每天 · Daily

### 早上（5-10 分钟）

**做什么 · What you do:**
- 打开 vault，扫一眼 `_dashboard.md`
- 看今日的 calendar：今天有几个 deal meeting / 几个 portfolio 1-on-1 / 几个 LP 沟通
- 今日"必处理"：red 区 portfolio（runway < 6 月）有动态吗？

**Claude 怎么帮 · How Claude helps:**

```
> 今天有什么紧迫的？

Claude:
- 红区 portfolio 跟今天日历无交集 ✓
- 但 [[XX 公司]] 上次 update 已 92 天，建议今天 ping
- Pipeline 里 [[YY 公司]] 已经在 DD 中 21 天，超过你 30 天目标——决策窗口要关了
```

### 白天（碎片化）

**触发场景：见人、收消息、做决定**

| 场景 | 你说 | Claude 干 |
|---|---|---|
| 见了新创始人 | "今天见了 X 公司，A 轮 pre-money 4000 万" | 建 `0-pipeline/2-meeting/X.md` 笔记 |
| 收到创始人微信汇报 | "智能制造科技刚说他们月度大客户进了立讯" | 在该公司笔记的"近期操作"加一行；如有 KPI 影响，问要不要更新 frontmatter |
| 做了决定 | "我决定加仓 XX 200 万" | 创建 decision log + 设定 6/12 月回访 |
| 帮了 portfolio | "我刚把 [[李 X]] 介绍给 [[张 Y]]" | 两个 people note 各加互动记录；对应 portco 笔记加 "我帮过什么" 一行 |

### 晚上（5 分钟）

**做什么:**
- 检查今天的 vault commit（如果你 vault 用 git 管理）
- 简单扫一眼有没有忘记记录的事

**Claude 怎么帮:**

```
> 今天我跟你聊过哪些项目？哪些没在 vault 里留痕？

Claude:
今天对话中提到了 5 家公司：
- 智能制造科技（已记录到 5-updates/）✓
- AI 芯片公司（已建 pipeline）✓
- BB 公司（你提了一句但没记，要补吗？）⚠️
- ...
```

---

## 📊 每周一 · Weekly Sweep

### 30 分钟 · 雷打不动的 portfolio 巡视

**做什么 · What you do:**

```
> 周扫描

Claude:
红区 (runway < 6 月)：
🔴 [[A 公司]] 5 月 — 创始人 4 月底 update 说 6 月有 bridge，要追

黄区 (runway 6-9 月 / 沉默 60-90 天)：
🟡 [[B 公司]] 7 月 — 这周没动静
🟡 [[C 公司]] 沉默 73 天

复盘 due (下次复盘截止 < today)：
⏰ [[D 公司]] 超期 12 天
⏰ [[E 公司]] 超期 5 天

董事会 due (未来 14 天)：
🏛️ [[F 公司]] 周五开会 — 你已有 prep 笔记
🏛️ [[G 公司]] 下下周二
```

**对应 action：**

- 红区：今天就 ping，问最新进展
- 黄区：本周内 ping
- 复盘 due：本周抽时间走完
- 董事会 due：开会前 2 天起 prep（用 Action 7）

### Pipeline 漏斗扫一眼

```
> 看 pipeline 状态

Claude (用 pipeline-漏斗.base):
1-初筛: 8 家
2-meeting: 5 家
3-DD中: 3 家 (其中 [[X]] 在 DD 22 天，超目标)
4-IC: 1 家
5-pass: 14 家 (本周新加 2)
```

**对应 action：**
- DD 中超 30 天的：决策窗口要关，要么进 IC 要么进 pass
- pass 增多本周：思考下"为啥这周看的多但 pass 多" — 是 deal flow 质量问题还是我标准变严？

### 周扫描产出

`7-reviews/2026-W18-周扫描.md` 自动生成，包含：
- 红黄绿区列表
- 本周 pipeline 移动
- 我承诺的 follow-up 待办
- 下周关注点

---

## 📨 每月 · Monthly

### 月初第一周

**1. Portfolio update review (主事项)**

每月头 1-2 周创始人会陆续发月度 / 季度 update。每收到一份：

```
> 智能制造科技刚发来 4 月 update PDF，在 ~/work/portfolio/智能制造科技/updates/2026-04.pdf

Claude (Action 5):
1. 解析 PDF，提取关键数字
2. 创建 5-updates/智能制造科技-2026-04-update.md
3. 更新 portfolio 笔记 frontmatter (runway, burn, 团队)
4. 警报触发：runway 14 → 11，进入预警区
5. 建议：本月找一次 1-on-1 聊融资节奏
```

**节奏：每收到一份 update 当天就处理。** 拖一周后细节就忘了。

**2. 决策日志回访**

每月初看 `7-reviews/decisions/` 下 30 天前的决策日志：

```
> 哪些决策日志该回访了？

Claude:
30+ 天前的决策（5 条）：
- 2026-04-01 加仓 [[X 公司]] —— 当时论点 Y，现在看 Y 还成立吗？
- 2026-04-15 不 follow-on [[Z 公司]] —— 现在 Z 估值变化？
- ...
```

逐条回填"现在看怎么样"——这是 self-deception 的检测器。

**3. 月报**

```
> 做 4 月月报

Claude (Action 6):
聚合本月 pipeline / portfolio / exits / decisions：

📥 Pipeline
- 新进：12 家 (初筛 9 / meeting 3)
- pass：5 家
- 进 IC：2 家
- 已投：1 家 (XX 公司 A 轮)

📊 Portfolio
- Runway 红区：1 → 2 (新增 [[X]])
- 团队规模总和：258 → 271 (+13)
- 总估值变化：8.4 亿 → 8.7 亿
- 关键事件：[[Y]] 拿到大客户，[[Z]] CTO 离职

🚪 Exits 本月：无

💰 决策回访 (30 天前)
- 列出 X 条该回访的决策

输出到 7-reviews/2026-04-月报.md
```

---

## 🔍 每季度 · Quarterly

季度复盘是**节奏最重要的一档**——没做季度复盘，前面所有日 / 周 / 月的努力都是流水账。

### Q-end 月（3/6/9/12 月）的最后 1 周

**1. Full portfolio review (Action 6)**

```
> Q2 复盘

Claude:
开始走每家 portfolio。先讲 [[智能制造科技]]：

1. 论点还成立吗？
   memo 投资逻辑：3C 工厂自动化 ROI 缩短 + 国产替代日系
   - ROI 论点：✓ 实际客户 POC 时间 6.5 月，跟预期吻合
   - 国产替代：✓ 富士康 / 立讯进入
   你怎么看？

[你回答 "都成立，且新看到 b 客户开始砍日系预算"]

2. 关键变量进展？
   [Claude 列出 4 个 checkbox 和实际数字]
   你回答...

3. 仓位决策？
   当前：800 万 累计 / 3.5% / follow-on 优先级 高
   - 保持？
   - 加仓 (B 轮预计今年下半年)？
   - 减仓？
   你回答...

→ Claude 写到该公司笔记的 ## 复盘 2026-Q2 section
→ 更新 下次复盘截止 = 2026-09-30
→ 进入下一家
```

**全部走完后**，自动生成 `7-reviews/2026-Q2-portfolio-review.md` 总览：
- portfolio 每家本季关键变化
- 行业 / 阶段分布
- 总 MOIC 变化
- 我自己的 thesis 学到了什么

### 同时：估值更新

每季度走一遍**所有 portfolio 的最新估值**（更新 `最新估值-投后`、`当前 MOIC`、`最近一轮日期`）。

来源：
- 新一轮融资 → 直接更新
- 没新轮 → 用 409A / mark-to-market 估算
- 显著业务变化 → 内部估算（保守原则）

### LP 季度沟通材料草稿

如果你跑 fund：

```
> 给 Q2 LP 季报起个草稿

Claude:
基于 7-reviews/2026-Q2-portfolio-review.md 提取：
- 本季新投 / 退出 / 估值变化
- 关键里程碑（portfolio 公司层）
- 重大风险事项
- 募投比与计划对比

输出到 7-reviews/2026-Q2-LP-letter-draft.md
```

---

## 📑 每年 · Annual

### 年末 / 年初

**1. Fund 整体 review (4-8 小时)**

```
> 做 2026 年度 fund review

Claude:
聚合全年数据：
- IRR / TVPI / DPI / RVPI 计算（基于 portfolio 当前估值 + 已 distribute）
- 全年新投 / 退出明细
- Pipeline 漏斗全年统计 (看了多少 / 投了多少 / 转化率)
- 行业 / 阶段分布演化
- 每家 portfolio 关键时间线

输出到 7-reviews/2026-年报.md (草稿)
```

**2. Thesis 更新**

```
> 帮我更新 _thesis.md

Claude:
读今年所有：
- 新投 deal 的 memo
- 退出复盘的 lessons
- pass 决策的理由
- 决策日志中验证的判断

提炼到 _thesis.md：
- "本年度学到的" section
- "已投回头看" 更新（特别是表现 outliers）
- "反 thesis" 列表更新
```

**3. LP 年度信草稿**

正式版 LP letter 草稿，覆盖：
- 全年回报指标
- 重大成就 / 里程碑
- 主要 portfolio 介绍
- 我们的 thesis 演化
- 下一年展望

### 个人复盘（独立投资人 / 天使）

如果你不是 fund，没 LP，这一年照样要做：

```
> 个人投资年度复盘

Claude:
- 投资金额总和 / 当前账面价值
- 我的"投资风格"是否漂移？(行业 / 阶段 / check size)
- 最值得记的 5 个学习
- 明年要修正的 3 个习惯
```

---

## ⚡ 异常时刻 · Off-cadence triggers

不在常规节奏里，但触发了就立刻处理：

| 触发 | 立刻做 |
|---|---|
| 创始人微信发"想找时间聊一下" | 加到 today 的"待跟进" + 当天 ping 约时间；担心重要事就直接打电话 |
| 创始人离职 / CTO 走 | 创建紧急决策日志：是否触发减仓？团队风险评级升级？ |
| Portfolio 公司收到 LOI（要被收购） | 立即建 exit-tracking 笔记 + 通知合伙人 |
| 我自己换电脑 | 检查所有 portfolio frontmatter 的 `project_root` 路径还对不对 |
| 同业 fund 投了我没看的 deal | 把这 deal 加到 0-pipeline 然后再决定要不要看 |
| portfolio 拿了大客户 | 当天更新该公司笔记关键变量 + 在月报里高亮 |

---

## 怎么形成习惯

最常见失败模式 ≠ "工具不够好"，是 **"用了 3 周就忘了"**。

3 个保活技巧：

1. **早上 10 分钟先开 vault**——把它当 email 之前的第一件事
2. **手机装 Obsidian + 配 cc-telegram-bridge / 类似机制**——出门见人时用语音速记到 inbox，回来再整理（[Telegram → Obsidian inbox 模式](https://github.com/cloveric/cc-telegram-bridge)）
3. **每周一固定 30 分钟做 weekly sweep**——其他都可以浮动，这一档不能动

3 周后这个 cadence 就成了你"投资工作方式的一部分"——不再是"另一个工具"。
