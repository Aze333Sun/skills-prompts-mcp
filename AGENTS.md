# Repository Agent Configuration

本文件定义 skills-prompts-mcp 仓库的管理规范，供 AI 智能体在进行库管理时遵循。

---

## 仓库概览

```
skills-prompts-mcp/
├── skills/                    # 94 个 Skills（自建 57 + collected 37）
│   ├── skills-collected/      # 37 个社区收集的 Skills（只读，不修改）
│   └── [skill-name]/         # 各自建 Skill 目录
├── agents/                    # Agent 配置与模板
├── prompts/                   # 独立提示词（80个）
├── mcp/                       # MCP 服务器配置（20个）
├── scripts/                   # 门禁检查脚本
├── workflows/                 # 工作流定义
└── README.md                  # 仓库说明文档
```

---

## 核心原则

### 1. SKILL.md 是唯一的 Skill 入口

每个 Skill 必须包含 `SKILL.md` 文件作为主入口。其他文件（脚本、参考文档、资源）是可选的辅助文件。

### 2. skills-collected/ 是只读的

`skills/skills-collected/` 下的文件来自社区，**禁止直接修改**。如需定制，应创建新的自建 Skill。

### 3. 格式门禁必须通过（仅自建）

**自建** `skills/` 目录下的 `SKILL.md` 必须通过格式检查才能提交。`skills/skills-collected/` 为社区标准原样保留，门禁脚本（`scripts/validate-skills.ps1`）自动排除，**不参与检查**。

### 4. 同名冲突处理

若自建 Skill 与 collected 同名，须加后缀区分以避免加载歧义。示例：自建 Word 文档处理 Skill 命名为 `docx-simple`（collected 为 `docx`）。

---

## SKILL.md 格式规范

### YAML Frontmatter（必须）

```yaml
---
name: skill-name-with-hyphens
description: "Use when [specific triggering conditions]. [What it does]."
effort: low|medium|high
---
```

**规则：**
- `name`：仅允许字母、数字、连字符（`a-z`, `A-Z`, `0-9`, `-`）
- `description`：**必须以 "Use when..." 开头**，描述触发条件而非功能
- `description`：长度 < 500 字符
- 禁止出现 `when_to_use` 字段（已合并到 description）

### 标准章节（必须）

每个 SKILL.md 必须包含以下章节：

```markdown
# Skill Title

Brief overview (1-3 sentences)

## When to Use

- 触发条件 1
- 触发条件 2

## Quick Reference

| 操作 | 命令/说明 |
|------|----------|
| ... | ... |

## Common Mistakes

- ❌ 错误做法 → ✅ 正确做法
```

### 完整结构模板

```markdown
---
name: my-skill-name
description: "Use when [triggering conditions]. [Brief capability description]."
effort: medium
---

# Skill Title

[Overview: what this skill does in 1-3 sentences]

## When to Use

- [Trigger condition 1]
- [Trigger condition 2]
- [Trigger condition 3]

## Core Pattern / Implementation

[Main workflow or approach]

## Quick Reference

| 操作 | 命令/说明 |
|------|----------|
| ... | ... |

## Common Mistakes

- ❌ [Wrong approach] → ✅ [Correct approach]

## [Additional sections as needed]
```

---

## 命名规范

### Skill 目录命名

| 类型 | 格式 | 示例 |
|------|------|------|
| 自建 Skill | `lowercase-hyphenated` | `code-review-workflow` |
| 社区收集 | 保持原名 | `skill-creator` |
| 平台特定 | `platform-specific/[name]` | `platform-specific/ip-as-logo` |

### 文件命名

| 文件 | 规则 |
|------|------|
| `SKILL.md` | 必须大写，Skill 入口 |
| `*.sh` / `*.py` | 小写+连字符，可执行脚本 |
| `*.md` | 小写+连字符，参考文档 |

---

## 添加新 Skill 的流程

### 步骤 1：创建目录

```bash
mkdir skills/new-skill-name
```

### 步骤 2：创建 SKILL.md

按格式规范编写，确保：
- [ ] YAML frontmatter 包含 `name` 和 `description`
- [ ] `description` 以 "Use when..." 开头
- [ ] 包含 When to Use 章节
- [ ] 包含 Quick Reference 章节
- [ ] 包含 Common Mistakes 章节

### 步骤 3：添加辅助文件（可选）

```
new-skill-name/
├── SKILL.md              # 必须
├── scripts/              # 可选：可执行脚本
├── references/           # 可选：参考文档
└── assets/               # 可选：资源文件
```

### 步骤 4：运行格式检查

```powershell
.\scripts\validate-skills.ps1
```

### 步骤 5：更新 README.md

在 README.md 的相应分类中添加新 Skill 的链接。

### 步骤 6：提交

```bash
git add skills/new-skill-name/
git commit -m "feat: add new-skill-name skill"
```

---

## 格式检查规则

运行 `.\scripts\validate-skills.ps1` 检查以下规则：

| 规则 | 级别 | 说明 |
|------|------|------|
| YAML frontmatter 存在 | ERROR | 文件必须以 `---` 开头 |
| `name` 字段存在 | ERROR | frontmatter 必须包含 name |
| `name` 格式正确 | ERROR | 仅允许字母/数字/连字符 |
| `description` 存在 | ERROR | frontmatter 必须包含 description |
| `description` 以 "Use when..." 开头 | ERROR | 触发条件格式 |
| `description` 长度 < 500 | WARNING | 建议保持简洁 |
| When to Use 章节存在 | WARNING | 标准章节 |
| Quick Reference 章节存在 | WARNING | 标准章节 |
| Common Mistakes 章存 | WARNING | 标准章节 |
| 无 when_to_use 字段 | WARNING | 已合并到 description |

---

## 常见错误

### ❌ 错误 1：description 不以 "Use when..." 开头

```yaml
# 错误
description: "多Agent并行代码审查系统"

# 正确
description: "Use when reviewing code changes, checking for bugs, security risks, or performance issues."
```

### ❌ 错误 2：使用 when_to_use 字段

```yaml
# 错误
description: "代码审查系统"
when_to_use: "用户要求审查代码时使用"

# 正确
description: "Use when reviewing code changes, checking for bugs, or performing code review."
```

### ❌ 错误 3：缺少标准章节

```markdown
# 错误：缺少 When to Use、Quick Reference、Common Mistakes

# 正确：包含所有标准章节
## When to Use
...
## Quick Reference
...
## Common Mistakes
...
```

### ❌ 错误 4：name 包含特殊字符

```yaml
# 错误
name: my-skill (v2)
name: my_skill
name: MySkill

# 正确
name: my-skill
name: my-skill-v2
```

---

## 修改现有 Skill

### 允许的修改

- 更新 description 格式（以 "Use when..." 开头）
- 添加/更新标准章节
- 修复格式问题
- 更新内容

### 禁止的修改

- 修改 `skills-collected/` 下的任何文件
- 删除 SKILL.md 的 YAML frontmatter
- 移除标准章节

---

## Scripts 说明

| 脚本 | 用途 |
|------|------|
| `scripts/validate-skills.ps1` | SKILL.md 格式检查 |

### 运行方式

```powershell
# 检查所有 SKILL.md
.\scripts\validate-skills.ps1

# 仅检查暂存区的 SKILL.md
.\scripts\validate-skills.ps1 -StagedOnly
```

---

## Skill 废弃规范

对确定要废弃的自建 Skill：

1. 在 `SKILL.md` 的 `description` 末尾追加 ` [DEPRECATED: use xxx instead]`
2. 目录最少保留 1 个版本周期后再归档删除
3. 在 [CHANGELOG.md](CHANGELOG.md) 中记录废弃原因和替代方案
4. 同步更新 INDEX.md 中的导航条目

**注意**：`skills-collected/` 下的 Skill 不能修改，无法标记 deprecated。如有重叠，在自建 Skill 的 description 中注明与 collected 版本的关系即可。

---

## Prompts 管理规范

### 头部注释（必须）

每个 `prompts/` 目录下的 `.md` 文件必须在文件第一行包含关联注释：

```markdown
<!-- 关联 Skill：xxx（推荐直接使用 Skill） -->
```

三种状态：
- `无` — 暂无对应 Skill，保留为独立模板
- `→ xxx` — 有对应 Skill，推荐优先使用
- `已升级为 Skill` — 已被 Skill 完全覆盖，仅保留索引

新增 Prompt 文件时必须同步添加头部注释，并更新 INDEX.md。

---

## Git 规范

### Commit Message 格式

```
<type>: <description>

[optional body]
```

### 类型

| 类型 | 说明 |
|------|------|
| `feat` | 新增 Skill 或功能 |
| `fix` | 修复格式或内容问题 |
| `docs` | 更新文档 |
| `refactor` | 重构（如重命名目录） |

### 示例

```bash
git commit -m "feat: add code-review-workflow skill"
git commit -m "fix: update description format in mermaid-to-png"
git commit -m "docs: update README with new skill categories"
```

---

## 工作流

### 日常维护

1. 检查新提交的 SKILL.md 是否通过格式检查
2. 更新 INDEX.md 中的 Skill 列表和导航
3. 新增 Prompt 时添加头部关联注释
4. 废弃 Skill 时更新 CHANGELOG.md
5. 结构性变更后更新 README.md（如数量变化）

### 添加社区 Skill

1. 将 Skill 复制到 `skills/skills-collected/`
2. **不要修改原文件**
3. 如需定制，创建新的自建 Skill 并引用原 Skill

### 批量更新

1. 运行格式检查确认所有 Skill 合规
2. 批量修改时逐个验证
3. 提交前再次运行格式检查

---

## 联系方式

如有疑问或建议，请查看 README.md 或提交 Issue。
