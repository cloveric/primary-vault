# 安装指南

primary-vault 由 3 部分组成 —— vault 模板、skill、（可选）外部工作目录。

## 前置依赖

- **Obsidian 1.7+**（推荐 1.9+ 用 Bases）
- **Claude Code CLI** 任意近期版本
- **Codex CLI**（可选）
- **macOS / Linux** 完全支持
- **Windows**：理论可用但 install.sh / new-deal.sh 需要 Git Bash 或 WSL；symlinks 行为不同（v1.0 会专门测）

## 一键安装（推荐）

```bash
git clone https://github.com/cloveric/primary-vault.git ~/projects/primary-vault
cd ~/projects/primary-vault
bash scripts/install.sh
```

`install.sh` 干 2 件事：

1. 把 `skills/deal-router/` symlink 到 `~/.claude/skills/`
2. 同样 symlink 到 `~/.codex/skills/`（如果你装了 Codex）

vault 部分**没自动装**——因为你需要决定放哪。见下面"vault 安装"。

## 手动安装

### Skill

```bash
ln -sf ~/projects/primary-vault/skills/deal-router ~/.claude/skills/deal-router
ln -sf ~/projects/primary-vault/skills/deal-router ~/.codex/skills/deal-router
```

### Vault

两种方式选一个：

#### A) 整个 vault-template 当成新 vault

把 `vault-template/` 整个文件夹在 Obsidian 里"作为 vault 打开"。适合一级投资单独搞一个 vault。

#### B) 拷进现有 vault

```bash
cp -r vault-template/. /path/to/your/existing-vault/
```

注意：会跟现有内容合并，如果你 vault 已经有同名文件夹会冲突——先备份。

### 工作目录

vault 是索引，原文件留外部。建议：

```bash
mkdir -p ~/work/{portfolio,pipeline,exited}
```

每家公司 / deal 一个子文件夹。Frontmatter 里的 `project_root` 指向这里。

## ⚠️ 强烈建议：给 vault 也用 git

skill 会大量改写 vault 笔记的 frontmatter 和 "近期操作"日志。如果改错了（或者你自己手滑），**没 git 你没 rollback 路径**。

```bash
cd /path/to/your/vault
git init
git add -A && git commit -m "initial vault snapshot"

# 之后每天 / 每周 commit 一次（手动或 cron）
git add -A && git commit -m "daily snapshot $(date +%Y-%m-%d)"
```

如果 vault 里有敏感信息（投资金额 / LP 信息 / 创始人个人信息），**用 private repo**，或者只本地 git（不 push）。

## ⚠️ 并发编辑警告

**Obsidian 在打开某个笔记时会持续 auto-save**。如果同时让 Claude Code 改这个笔记，可能：
- 你的未保存修改被 Claude 覆盖
- Claude 的写入被 Obsidian auto-save 覆盖

**安全做法**：

1. 让 Claude 改某个笔记前，先**在 Obsidian 关闭这个笔记** (Cmd+W) 或点别处让 Obsidian 保存
2. Claude 改完后再回 Obsidian 打开看
3. 给 vault 开 git，万一冲突可以 diff 看哪边对

deal-router skill v0.4 起会主动提醒你关闭笔记再操作。

## 验证

```bash
# 1. skill 装上了吗
ls -la ~/.claude/skills/deal-router

# 2. 在 vault 目录里启动 claude
cd /path/to/your/vault
claude

# 3. 问一句简单的问题
# > "按 deal-router 约定，列出我所有 portfolio 公司"
```

## Vault 健康度检查

任何时候想确认 vault 符合 v0.4 约定：

```bash
bash ~/projects/primary-vault/scripts/lint-vault.sh /path/to/your/vault
```

会检查：必填字段、日期格式、type 枚举值、v0.3 旧字段残留、frontmatter YAML 合法性。

## 升级

```bash
cd ~/projects/primary-vault
git pull
# Claude / Codex skill 都通过 symlink 自动更新
```

### 从 v0.3 升 v0.4（breaking change）

v0.4 把 frontmatter 字段名从中文带空格改成 snake_case 英文。如果你 v0.3 已有 portfolio 笔记，要批量改字段名。

完整 v0.3 → v0.4 字段映射见 [docs/CONVENTIONS.md](CONVENTIONS.md) 末尾。

如果只有少量笔记，手工改最稳。

## 卸载

```bash
bash ~/projects/primary-vault/scripts/uninstall.sh
```

或者手动：

```bash
# 移除 symlink（保留源码）
rm ~/.claude/skills/deal-router
rm ~/.codex/skills/deal-router

# 完全删除
rm -rf ~/projects/primary-vault
```

vault 内容（你已有的笔记）不会被这些命令影响。

## 故障排查

### Claude 不按 skill 行为做

- 重启 Claude session（skill 是 session 启动时加载的）
- 检查 `~/.claude/skills/deal-router/SKILL.md` 是否存在且 readable
- 用 symlink 时 `readlink` 解析路径正确

### Bases 视图不生效

- 确认 Obsidian 版本 1.9+
- Bases 是核心功能，无插件，但需要正确 YAML
- 如果某个 .base 报错，看 `bases/README.md` 里"已知未充分验证的语法"
- 极端情况：把 .base 文件用 Obsidian GUI 重建一份正常的，对比 YAML

### 路径找不到

- frontmatter `project_root` 必须是**绝对路径**，不能 `~/...`
- 用 `/Users/<you>/work/...` 或先 `echo ~` 看实际值

### v0.3 旧字段名残留

跑 `bash scripts/lint-vault.sh` 找出哪些笔记还有 v0.3 字段。手工或用 sed 批量改：

```bash
# 例：runway 月数 → runway_months
find /path/to/vault -name "*.md" -exec sed -i '' 's/^runway 月数:/runway_months:/g' {} \;
```
