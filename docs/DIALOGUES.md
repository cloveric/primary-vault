# 实例对话 · Dialogue Library

> 30+ 个 "你说什么 → Claude 怎么干" 真实场景对话——按工作流分类。
> 这是 deal-router skill 实际行为的视觉化清单。

## 索引

- [📥 Pipeline (5 个)](#-pipeline-管理)
- [📝 Memo (4 个)](#-memo-写作)
- [📨 Updates (4 个)](#-update-解析)
- [🏛️ 董事会 (5 个)](#-董事会管理)
- [💰 决策 (3 个)](#-决策日志)
- [🔍 复盘 (4 个)](#-周期复盘)
- [🚪 退出 (4 个)](#-退出管理)
- [👥 人物 (3 个)](#-人物-crm)
- [🛠️ 工具类 (4 个)](#️-工具类)

---

## 📥 Pipeline 管理

### 1. 加新 deal

> **你**：今天见了 AI 芯片公司，A 轮 pre-money 4000 万，创始人海思出身。负责合伙人是我。

**Claude**：
1. 创建 `0-pipeline/2-meeting/AI芯片公司.md`
2. Frontmatter 填：`type: pipeline-deal`、`公司: AI芯片公司`、`首次接触: 2026-05-01`、`当前阶段: meeting`、`推荐估值: 4000`、`负责合伙人: 我`
3. 笔记正文留 stub：## 公司在干嘛、## 创始团队、## 我的初步判断（待你接着写）
4. 问你：来源是谁推过来的？要建对应 person 笔记吗？

### 2. 阶段流转：进 DD

> **你**：AI 芯片公司进 DD 了。

**Claude**：
1. `mv 0-pipeline/2-meeting/AI芯片公司.md 0-pipeline/3-DD中/`
2. Frontmatter 改 `当前阶段: DD中`
3. 追加"近期操作"：`- 2026-05-08 14:00 进入 DD 阶段`
4. 提示：DD 中默认 30 天目标，6 月 8 日前要做决定

### 3. Pass 一个 deal

> **你**：AI 芯片公司 pass 吧，技术看不太懂。

**Claude**：
1. `mv ... 0-pipeline/5-pass/`
2. Frontmatter 改 `当前阶段: pass`
3. 在笔记加一段 `## Pass 原因`
4. 问你：能多写一句吗？比如"pass 因为技术评估超出我们能力圈"——这样 6 个月后你能记得"我为什么没投"，避免后悔型 pass

### 4. 从 pass 区复活

> **你**：去年 pass 的智驾公司刚拿了 B 轮估值翻 3 倍，我想重新看。

**Claude**：
1. `mv 0-pipeline/5-pass/智驾公司.md 0-pipeline/2-meeting/`
2. 追加"近期操作"：`- 2026-05-01 14:00 复活：B 轮估值翻 3 倍，重新评估`
3. 在笔记加 ## 复活原因 + ## 当时为什么 pass（让你回头看，警惕"FOMO 复活"）
4. 提示：建议你 24 小时内决定到底重新认真看还是只是看着热闹

### 5. 周扫描 pipeline 状态

> **你**：本周 pipeline 状态？

**Claude**（用 `bases/pipeline-漏斗.base`）：
- 1-初筛：8 家（本周新加 3 家）
- 2-meeting：5 家（[[X]] 在这停 18 天，决策窗口要关）
- 3-DD中：3 家（[[Y]] 已 22 天，超过 30 天目标）
- 4-IC：1 家（本月底要给答复）
- 5-pass：14 家（本周新 pass 2 家）

提示：DD 中超 30 天的项目，要么进 IC 要么进 pass。

---

## 📝 Memo 写作

### 6. 起 memo 草稿

> **你**：写 AI 芯片公司 A 轮 memo。我今天跟创始人聊了 2 小时，主要内容是：边缘 AI 推理芯片，Tesla 智驾对标，团队 8 人海思出身……（接着说 30 分钟）

**Claude**：
1. 创建 `4-memos/AI芯片公司-A轮-memo.md` 套 14 节模板
2. 把你说的内容填进 1（一句话总结）/ 2（What）/ 3（Why Now，从你提的"边缘推理需求爆发"提炼）/ 4（Why This Team）/ 5（市场，请你补 TAM 数字）
3. 留 stub 在 8（Traction）/ 9（估值条款）/ 10（Risks Top 5）等需要更多 DD 信息的章
4. **强制提醒**：第 13 节 12-24 月里程碑预测必填——这是 self-reflection 锚点

### 7. 更新 memo 的某一节

> **你**：在 AI 芯片公司 memo 第 10 节再加一条 risk：竞争对手寒武纪也在招相关人员。

**Claude**：
1. 读 memo 第 10 节
2. 加 risk #6（如果已有 5 条则提醒：建议保持 Top 5 优先级——如果新加这条更重要，要不要替换某条？）
3. Confirm 后改

### 8. Memo 状态流转

> **你**：AI 芯片公司 IC 通过了，决定投。

**Claude**：
1. Memo frontmatter 改 `状态: 通过IC` → `已投`
2. **触发 portfolio 公司创建流程**：
   - `mv 0-pipeline/4-IC/AI芯片公司.md 1-portfolio/companies/`（如适用）
   - 或新建 portfolio 笔记套 portfolio-company 模板
3. Portfolio 笔记 frontmatter 关联回 memo（`论点: [[AI芯片公司-A轮-memo]]`）
4. 问你：投资金额 / 占股 / 投资日期？协议签了吗？工作目录在哪 (`project_root`)?

### 9. 6 个月后回头看 memo

> **你**：智能制造科技投了半年了，回头看下 memo。

**Claude**：
1. 读 `4-memos/智能制造科技-A轮-memo.md`
2. 特别拿出第 13 节 12-24 月里程碑预测
3. 对比当前实际：
   - 收入预测 5000-7000 万 → 实际 3500 万（差 30-50%）
   - 团队预测 35-40 人 → 实际 22 人（不到位）
   - SaaS 工厂数预测 200 → 实际 130（不到位）
4. 在 memo 末尾的"### 6 个月后回头看"section 写：当时我系统性高估了商业开拓速度，下次默认打 7 折
5. 提示：把这条 lesson 加到 `_thesis.md` 的"已投回头看"section？

---

## 📨 Update 解析

### 10. 微信收到的语音 update

> **你**：（粘贴文本）"老李刚发来语音，说 4 月营收 580 万比 3 月涨 12%，团队加了 3 个产品经理，现在 28 人，runway 11 个月，下个月有 2 家头部 POC 谈到收尾。"

**Claude**（Action 5）：
1. 创建 `5-updates/智能制造科技-2026-04-update.md`
2. 提取数字：runway 11、月烧 80→根据团队规模推算（你 confirm 数）、营收 580 万、团队 28
3. 更新 portfolio 笔记 frontmatter：runway 14→11、团队规模 25→28、最近 update: 2026-04-15
4. **警报**：runway 14→11 月，已进入预警区（< 12）；月烧增了 30%（如核实），需关注
5. 关联：把这条 update 链到 portfolio 笔记的 ## Updates 时间线

### 11. PDF 解析

> **你**：智能制造科技 4 月报告在 `~/work/portfolio/智能制造科技/updates/2026-04.pdf`，帮我整理。

**Claude**：
1. 用 Bash 读 PDF（如有 PDF 解析工具）或转文本
2. 提取数字、风险信号、创始人 ask
3. 同 Action 10 流程

### 12. 邮件 forward

> **你**：（粘贴邮件）From: 创始人，Subject: 4 月 update。正文是结构化的数字 + 几段说明 + 一些 "ask"。

**Claude**：
1. 解析邮件文本
2. 创建 update 笔记（Action 5）
3. **提取 ask**：把 "ask" 部分提到 portfolio 笔记的 "## 待跟进" section + 加一条 founder 的 person 笔记互动记录
4. 警报本月有什么需要主动反馈给创始人的（比如他想要的资源）

### 13. 警报式提示

> **你**：（粘贴文本）"runway 还剩 5 月"

**Claude**：
1. 解析这个简短信息，明确这是 update
2. 自动创建 update 笔记
3. **强警报**：🔴 runway 5 月（红区），建议 24-48 小时内 1-on-1
4. 帮你建议讨论框架：bridge 可能性 / 团队精简 / 客户加速

---

## 🏛️ 董事会管理

### 14. 准备本月董事会

> **你**：下周三智能制造科技董事会，帮我准备。

**Claude**（Action 7）：
1. 读 portfolio 笔记当前状态
2. 找上次 board note `6-board-notes/智能制造科技-2026-01-15-board.md` 提取 open action items
3. 拉 Q1、Q2 update（5-updates/）
4. 对比当前 KPI vs memo 第 13 节预测
5. 生成 `6-board-notes/智能制造科技-2026-04-10-board-prep.md`：
   - 议程建议
   - 上次 action items 5 项 follow-up 表（你 promise 的有 1 项还没做：⚠️ 引荐 [[XX 律师]]）
   - KPI 变化表（收入对比 memo 预测偏 -30%）
   - 我要问的 5 个硬问题
   - 我要 push 的 add-value 事项
   - 风险 / 警报：团队 +30% 但收入只增 12%

### 15. 开完会后捕获

> **你**：刚开完智能制造科技董事会，主要决议：B 轮启动、CTO 加 stock；行动项：李 X 月底前要给我 B 轮 deck，王 X Q3 前完成产品上线；争议：是否做硬件 vs 全 SaaS。

**Claude**（Action 8）：
1. 创建 `6-board-notes/智能制造科技-2026-04-10-board.md` 套模板
2. 填关键决议、行动项（带 owner + due）、战略问题（硬件 vs SaaS）、风险讨论
3. 更新 portfolio 笔记：`最近董事会: 2026-04-10`、`下次董事会: 2026-07-10`
4. 我观察到的（非正式）section 留空让你晚上回家后补
5. 追加"近期操作"

### 16. 我之前 promise 的事

> **你**：智能制造科技 4 月董事会前我答应介绍律师，做了吗？

**Claude**：
1. 读 portfolio 笔记和 founder 的 person 笔记
2. 在 `## 待跟进` 找 / 在 person 笔记互动记录里找
3. 答：没做（last seen 2026-03-20，你说 "下周给"，但 4 周过去没记录介绍）。建议本周做掉。

### 17. 多家董事会日历视图

> **你**：未来一个月我有几个董事会？

**Claude**（用 `bases/董事会due.base`）：
- 5 月 8 日：[[A 公司]] (你是 observer)
- 5 月 15 日：[[B 公司]] (你是董事)
- 5 月 22 日：[[C 公司]] (observer)
- 6 月 1 日：[[D 公司]] (董事)

提示：5/15 那个你是董事，建议提前 5 天准备。

### 18. 记录 1-on-1（非正式董事会）

> **你**：今天跟智能制造科技李 X 喝了咖啡，他说想招个海归 VP 工程，市场上靠谱的有谁？

**Claude**：
1. 在 `3-people/李X.md` 加互动记录：`2026-05-01 喝咖啡，他想找 VP Eng`
2. 在 portfolio 笔记 `## 我帮过什么` 加待办：寻找 VP Eng 推荐人选
3. **主动建议**：可以查你 vault 里所有 person 笔记，看谁的角色 / 关联背景匹配；要现在跑吗？

---

## 💰 决策日志

### 19. 加仓决策

> **你**：决定智能制造科技 B 轮跟投 500 万。

**Claude**（Action 10）：
1. 创建 `7-reviews/decisions/2026-05-01-智能制造科技-follow-on.md`
2. Prompt 你回答 5 件事：
   - 当前 thesis 状态（哪几条还成立 / 哪条破了）
   - 关键变量进展
   - 估值合理性（B 轮估值 vs 当时 A 轮 5x）
   - 是否 follow-on / 多少
   - 我可能错的地方（写 3 条）
3. 写到 decision log
4. **关键**：设定 6 月后回访点（2026-11-01）+ 12 月后回访点（2027-05-01）
5. 更新 portfolio 笔记：`当前融资轮: 投资人尽调中`、`我方累计投资` 800→1300

### 20. Down round 决策

> **你**：智能制造科技融不到了，估值要 down 30%。我犹豫要不要 follow。

**Claude**：
1. 创建 decision log，但**预警**：down round 是关键节点，可能是论点破灭信号
2. 引导你回答：
   - 论点破灭了吗？还是只是市场环境？
   - 反稀释保护是否触发？
   - 这次不投是不是承认前期判断错了？
3. **特别强调**：不管投不投，一定要在 6 个月后回访这条决策。down round 后的判断最容易看走眼。

### 21. 决策回访

> **你**：30 天前的决策日志该回访的列出来。

**Claude**：
1. 扫 `7-reviews/decisions/` 30 天前文件
2. 列出来，对每条问"现在看怎么样？"
3. 你回答，Claude 在每条 decision log 末尾加 ## 30 天后回访

---

## 🔍 周期复盘

### 22. 周扫描

> **你**：周扫描

**Claude**（Action 6）：
（输出红黄绿区 + pipeline 漏斗 + 复盘 due + 董事会 due，详见 [CADENCE.md](CADENCE.md)）

### 23. 月报

> **你**：做 4 月月报

**Claude**：
（聚合本月 pipeline / portfolio / exits / decisions，输出到 `7-reviews/2026-04-月报.md`，详见 CADENCE.md）

### 24. 季度复盘

> **你**：Q2 复盘

**Claude**：
（逐家走 portfolio，每家 3 个问题，输出到 `7-reviews/2026-Q2-portfolio-review.md`，详见 CADENCE.md）

### 25. 跨季度模式查找

> **你**：过去 3 个季度我有什么"判断对了"的 portfolio？

**Claude**：
1. 扫所有 portfolio 笔记的复盘 section（## 复盘 2026-Q1, ## 复盘 2026-Q2, ## 复盘 2026-Q3）
2. 找到"论点都成立 + KPI 进展超预期"的 deal
3. 列出来，并提取共同模式（行业、阶段、创始人特征）
4. 回写到 `_thesis.md` 的"我们看重的（必须满足）"——把验证过的 pattern 加进去

---

## 🚪 退出管理

### 26. M&A 录入

> **你**：智能制造科技被 XX 上市公司收购了，2.4 亿，现金 70% 股票 30%，6 个月 lockup，5% 业绩 earnout。

**Claude**（Action 11）：
1. 询问缺失：买家全名 / 我方 proceeds / closing 日期 / escrow？
2. 你补完
3. `mv 1-portfolio/companies/智能制造科技.md 2-exited/`
4. 更新 frontmatter：`状态: exited-ma`、`退出日期`、`退出 proceeds`、`最终 MOIC`、`持有月数`
5. 创建 `2-exited/智能制造科技-exit-record.md` 套退出模板
6. Memo 状态改 `已退出-ma`
7. 月报追加退出 log
8. **强提醒**：1 周内做退出复盘

### 27. IPO 录入

> **你**：智能制造科技下周科创板上市，发行价 38 块。

**Claude**：
1. 这是退出准备阶段（不是已退出）→ 用 Action 13
2. 创建 `2-exited/_pipeline/智能制造科技-exit-tracking.md`
3. 时间线：
   - 上市日：YYYY-MM-DD
   - lockup 6 个月到期：YYYY-MM-DD
   - 第一次 distribute LP：lockup 后
4. 我方关心问题：lockup 后股价 / tax / distribute 时机
5. portfolio 笔记 `当前融资轮: 上市辅导中` → IPO 后改 `已上市`
6. 设定提醒：每月追踪股价 + lockup 倒计时

### 28. 写零

> **你**：AA 公司停业了，我们的钱没了。

**Claude**：
1. 询问：什么原因？是否触发反稀释 / 优先清算？还有 residual value 吗（剩余资产 / 知识产权 / 转让）？
2. 移到 `2-exited/`，状态改 `写零`
3. 创建 exit-record，proceeds = 0
4. **强烈建议**：48 小时内做退出复盘（写零的 lesson 最值钱，也最容易自我安慰说"运气不好"）
5. 退出复盘问的最关键：**这家在 6 个月前我有没有看到信号？为什么没动？**

### 29. 退出复盘

> **你**：做智能制造科技退出复盘

**Claude**（Action 12）：
1. 读 memo（第 13 节预测）+ 全部 updates + 全部 board notes + 全部 decisions
2. 套 7 节模板，引导你回答：
   - Thesis 校准（哪几条对、哪几条错、盲点）
   - 里程碑预测对比
   - 关键决策回头看
   - 回报对比预期 (实际 5.6x MOIC vs 当时 expected case 4-6x — 中位数命中)
   - 下次类似 deal 改什么（具体行为，不是"以后小心")
3. 写到 `7-reviews/智能制造科技-exit-retrospective.md`
4. **触发 thesis 更新**：把关键 lessons 提到 `_thesis.md` 的"已投回头看"

---

## 👥 人物 CRM

### 30. 加新人

> **你**：今天见了红杉的张三，未来可能联合投资。

**Claude**：
1. 创建 `3-people/张三-红杉.md` 套 person 模板
2. 角色: co-investor、首次见面: today、联系频率: 季
3. 留 stub：## 怎么认识的、## 我对他的看法、## 我能帮他什么 / 他能帮我什么
4. 问：他主投哪个赛道？我们有重叠吗？

### 31. 联系频率提醒

> **你**：哪些 co-investor / LP 我超过 3 个月没联系了？

**Claude**：
1. 扫 `3-people/` 笔记
2. 过滤角色 ≠ founder（founder 单独管）
3. 过滤 `最近联系` < today - 90
4. 列出来按"按你设定的联系频率超期程度"排序

### 32. 互动汇总

> **你**：过去半年我跟红杉的张三都聊了什么？

**Claude**：
1. 读 `3-people/张三-红杉.md` 的 ## 互动记录
2. 列出过去 6 个月每条互动
3. 提取主题（哪些 deal 共同看了、有什么共识、有什么分歧）

---

## 🛠️ 工具类

### 33. 找文件路由

> **你**：智能制造科技的 4 月财务模型在哪？

**Claude**（Action 1）：
1. 读 portfolio 笔记 frontmatter
2. `project_root: /Users/cloveric/work/portfolio/智能制造科技`
3. `files.财务模型: financials/Q1-2026-model.xlsx`（按你 v0.1 设的）
4. 答：完整路径 `/Users/cloveric/work/portfolio/智能制造科技/financials/Q1-2026-model.xlsx`
5. 问：要现在打开看吗？

### 34. 跨公司搜索

> **你**：所有 portfolio 里跟"工业机器人"赛道的公司

**Claude**：
1. Grep `1-portfolio/companies/` 里 `赛道: 工业机器人`
2. 列出来
3. 顺手列出 pipeline 里同赛道的也（如有）

### 35. 论点对照

> **你**：我所有"thesis 已经破灭"的 portfolio 是哪几家？

**Claude**：
1. 扫所有 portfolio 笔记最近的复盘 section
2. 找包含"论点破灭" / "thesis 不成立" / "假设错了" 的
3. 列出来 + 当前状态（active 还是已退出）+ 我当时的反应

### 36. 全 vault 健康度

> **你**：vault 健康度报告。

**Claude**：
- 总 portfolio 公司数：N
- 缺失关键 frontmatter 的：M（如 `runway 月数` 没填）
- 沉默 > 90 天：X
- 复盘 due：Y
- 投后 30 天内没"近期操作"日志的：Z（说明你没在跟）

---

## 怎么用这份文档

- **Onboarding 时**：读一遍这 36 个对话，对 skill 能干啥有直观感觉
- **遇到新场景**：搜这份文档，看有没有类似的；没有就跟我说"加进 v0.4 dialogue 库"
- **教合伙人**：让他们读这份比读 SKILL.md 快，更接地气

如果你有真实使用场景这里没覆盖到，欢迎在 [issue](https://github.com/cloveric/primary-vault/issues) 提，我们集体补充。
