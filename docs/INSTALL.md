# 安装指南

vc-vault 由 3 部分组成 —— vault 模板、skill、（可选）外部工作目录。

## 前置依赖

- Obsidian 1.7+（推荐 1.9+ 以用 Bases）
- Claude Code CLI 任意近期版本
- Codex CLI（可选，如果你也用 OpenAI Codex）
- macOS / Linux（Windows 没测，应该可用）

## 一键安装（推荐）

```bash
git clone https://github.com/cloveric/vc-vault.git ~/projects/vc-vault
cd ~/projects/vc-vault
bash scripts/install.sh
```

`install.sh` 干 2 件事：

1. 把 `skills/vc-project-router/` symlink 到 `~/.claude/skills/`
2. 同样 symlink 到 `~/.codex/skills/`（如果存在 `~/.codex/skills/`）

vault 部分**没自动装**——因为你需要决定放哪。见下面"vault 安装"。

## 手动安装

### Skill

```bash
ln -sf ~/projects/vc-vault/skills/vc-project-router ~/.claude/skills/vc-project-router
ln -sf ~/projects/vc-vault/skills/vc-project-router ~/.codex/skills/vc-project-router
```

### Vault

两种方式选一个：

#### A) 整个 vault-template 当成新 vault

把 `vault-template/` 整个文件夹在 Obsidian 里"作为 vault 打开"。适合一级投资单独搞一个 vault。

#### B) 拷进现有 vault

```bash
cp -r vault-template/. /path/to/your/existing-vault/
```

注意：会跟现有内容合并，如果你 vault 已经有同名文件夹（如 `4-memos/`）会造成冲突——先备份。

### 工作目录

vault 是索引，原文件留外部。建议：

```bash
mkdir -p ~/work/portfolio    # 已投公司
mkdir -p ~/work/pipeline     # 在看 deal
mkdir -p ~/work/exited       # 已退出
```

每家公司 / deal 一个子文件夹。Frontmatter 里的 `project_root` 指向这里。

## 验证

```bash
# 1. skill 装上了吗
ls -la ~/.claude/skills/vc-project-router

# 2. 在 vault 目录里启动 claude
cd /path/to/your/vault
claude

# 3. 问一句简单的问题
# > "列出我的 portfolio 里所有公司"
# Claude 应该按 vc-project-router 的约定，glob 1-portfolio/companies/ 列给你
```

## 升级

```bash
cd ~/projects/vc-vault
git pull
# Claude / Codex skill 都通过 symlink 自动更新
```

## 卸载

```bash
# 移除 symlink（保留源码）
rm ~/.claude/skills/vc-project-router
rm ~/.codex/skills/vc-project-router

# 完全删除
rm -rf ~/projects/vc-vault
```

vault 内容（你已有的笔记）不会被这些命令影响。

## 故障排查

### Claude 不按 skill 行为做

- 重启 Claude session（skill 是 session 启动时加载的）
- 检查 `~/.claude/skills/vc-project-router/SKILL.md` 是否存在且 readable
- 如果用 symlink，检查 `readlink ~/.claude/skills/vc-project-router/SKILL.md` 解析正确

### Bases 视图不生效

- 确认 Obsidian 版本 1.9+
- Bases 是核心功能，不需要插件，但需要正确的 yaml 文件结构
- 检查 vault `bases/` 目录下 `.base` 文件语法

### 路径找不到

- 项目笔记的 frontmatter `project_root` 必须是**绝对路径**，不能是 `~/...`（除非 skill 帮你扩展）
- 用 `/Users/<you>/work/...` 或先 `echo ~` 看实际值
