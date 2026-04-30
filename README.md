# vc-vault

> **一级市场投资项目管理 · Claude Code + Codex + Obsidian + Bases**
>
> A VC operating system: portfolio + pipeline + memo + decision-log + auto-routing, powered by your existing Claude Code / Codex CLI and Obsidian vault.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Obsidian](https://img.shields.io/badge/Obsidian-Bases-7c3aed)](https://obsidian.md)
[![Skill compatible](https://img.shields.io/badge/skill-Claude%20Code%20%2B%20Codex-blueviolet)](skills/vc-project-router/SKILL.md)

---

## 这是什么

一套给一级市场投资人（VC / 天使 / FA / GP）用的 **项目管理 OS**，核心是把 **Obsidian vault 当作 Claude Code 的中央调度台（vault-as-router）**：

> 你跟 Claude Code 说一句 "看一下智能制造科技 Q1 财务"
> → Claude 先读 vault 里这家公司的笔记
> → 笔记 frontmatter 里有指向真实工作文件的"地图"
> → Claude 自动进对应文件夹打开 Q1 模型干活
> → 干完回头把日志写回 Obsidian 笔记

vault 不存所有原始文件（PDF / Excel / 决策文件留在工作目录），它**只存索引、状态、元数据、决策**——这是 Claude Code 的导航地图。

## 架构

```
你 ──说一句话──→  Claude Code / Codex
                        │
                        ▼
              [先读 Obsidian vault 项目笔记]
                        │
                        ▼
            [frontmatter 里的 files: 映射表]
                        │
              ┌─────────┴─────────┐
              ▼                   ▼
       /work/项目A/        /work/项目B/
       • memo.md           • model.xlsx
       • pitch.pdf         • DD/...
                        │
                        ▼
              [Claude Code 实际干活]
                        │
                        ▼
        [日志写回 Obsidian → frontmatter 更新]
```

vault 是**轻量索引层**，工作文件留在自己的目录里（比如 `~/work/portfolio/<公司>/`），互不污染。

## 内容总览

| 部分 | 干什么 |
|---|---|
| `vault-template/` | Obsidian vault 的完整骨架——文件夹、模板、Bases 视图 |
| `skills/vc-project-router/` | 核心 skill——教 Claude/Codex 这套约定怎么用 |
| `examples/` | 合成数据样例（智能制造、AI 芯片各 1 家），克隆即可看到完整一遍 |
| `docs/` | 安装、约定、操作节奏、对话样例 |
| `scripts/` | 一键安装到 `~/.claude/skills/` 和 `~/.codex/skills/` |

## Quick Start

```bash
# 1. clone
git clone https://github.com/cloveric/vc-vault.git ~/projects/vc-vault
cd ~/projects/vc-vault

# 2. 把 vault 模板拷到你的 Obsidian vault 根目录（按需）
#    或者：把整个 vault-template/ 当成一个新 vault 在 Obsidian 里打开
cp -r vault-template/. /path/to/your/obsidian/vault/

# 3. 安装 skill 到 Claude Code 和 Codex（symlink，更新只 git pull 一次）
bash scripts/install.sh

# 4. 在 vault 目录里启动 claude
cd /path/to/your/obsidian/vault
claude
# 然后问："列出我所有 portfolio 公司"——agent 会按 vc-project-router 的约定干活
```

详细装机：[`docs/INSTALL.md`](docs/INSTALL.md)

## 设计哲学（精简版）

1. **Vault 是索引，工作文件在外面**——避免 vault 越用越臃肿
2. **frontmatter 是接口**——人类、Claude、Bases 都通过它对话
3. **决策日志强制留痕**——12 个月后回头看 self-deception
4. **memo 是灵魂**——投资 thesis、关键变量、退出路径都在 memo 里，不在脑子里
5. **复盘有节奏**——日 / 周 / 月 / 季 / 年 五个时间尺度对应五种动作
6. **Skill 是肌肉记忆**——你说一次 Claude 学会一辈子

完整版：[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)

## 操作节奏

| 频率 | 你做什么 | Claude 怎么帮 |
|---|---|---|
| 每次 deal | 写 memo（强制） | 你口述 30 分钟 → 套模板生成结构化 memo 草稿 |
| 每天 | pipeline 进展 | 加 deal、移阶段、链人物 |
| 每周 | runway 警报 + sentiment check | Bases 视图，列出该联系的创始人 |
| 每月 | portfolio update review | 解析创始人发来的 PDF/邮件成结构化 update |
| 每季 | full portfolio 复盘 + 估值更新 | 一家家走过 → 自动产 fund report 草稿 |
| 每年 | fund review + LP letter | 算 IRR / TVPI / DPI → LP 信草稿 |

## 兼容栈

- **Obsidian** ≥ 1.7（Bases 在 1.9+ 转正）
- **Claude Code** 任意近期版本
- **Codex CLI** 任意近期版本
- **macOS / Linux**（Windows 没测，理论可用）

可选锦上添花：
- [`kepano/obsidian-skills`](https://github.com/kepano/obsidian-skills)（让 Claude 写 Obsidian 方言更准）
- [`obsidian-claude-code-plugin`](https://github.com/deivid11/obsidian-claude-code-plugin)（在 Obsidian 侧边栏跑 Claude Code）

## License

MIT — 拿去随便改、商用、fork。看 [LICENSE](LICENSE)。

## 作者

[@cloveric](https://github.com/cloveric)

如果你也是一级市场从业者，欢迎在 issue 里讨论你的工作流痛点——这套 v0.1 是我自己的实验，我们一起迭代。
