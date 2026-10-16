# Skills 仓库盘点报告

日期：2026-10-15

## 结论

仓库 Skill 数量已大幅扩充，但**文档与门禁状态脱节**：实际共 96 个 Skill（自建 59 + collected 37），较 AGENTS.md 记录的「自建 32 + collected 27 = 59」净增 37 个。格式门禁 59/59 全通过，但 README / INDEX / AGENTS.md 均未同步，且存在 2 处同名冲突、1 处命名不规范。

## 1. 数量对比

| 维度 | 文档记录 | 实际目录 | 差值 |
|------|---------|---------|------|
| 自建 Skill | 32 | 59 | +27 |
| collected | 27 | 37 | +10 |
| 合计 | 59 | 96 | +37 |

## 2. 文档未覆盖的自建 Skill（28 个）

> 以下目录已存在且通过门禁，但未出现在 README 自建速览表 / INDEX 中。

`adapt`, `agent-mr-commit-template`, `algorithmic-art`, `animate`, `audit`, `bolder`, `byted-seedance-video-generate`, `clarify`, `colorize`, `critique`, `delight`, `distill`, `docx`*, `frontend-design`*, `harden`, `impeccable`, `layout`, `obsidian-bases`, `obsidian-cli`, `obsidian-markdown`, `optimize`, `overdrive`, `platform-specific/ip-as-logo`, `polish`, `quieter`, `shape`, `typeset`, `writing-plans`

（* 与 collected 同名，见第 4 节）

按主题粗略归类：

- **写作 / 文风处理（批量引入）**：adapt, bolder, clarify, colorize, critique, delight, distill, harden, impeccable, optimize, overdrive, polish, quieter, shape, typeset, writing-plans, algorithmic-art, animate, audit
- **Obsidian 套件**：obsidian-bases, obsidian-cli, obsidian-markdown
- **视频生成**：byted-seedance-video-generate
- **提交模板**：agent-mr-commit-template
- **排版 / 布局**：layout
- **平台特定**：platform-specific/ip-as-logo
- **文档（与 collected 冲突）**：docx
- **前端设计（与 collected 冲突）**：frontend-design

## 3. 文档未覆盖的 collected（4 个）

`frontend-design`(collected)、`systematic-debugging`、`using-git-worktrees`、`ponytail`(纯)

## 4. 格式门禁

运行 `scripts/validate-skills.ps1`：检查 59 个自建 SKILL.md，**ALL CHECKS PASSED**（YAML frontmatter / `Use when...` description / 标准章节齐全）。

## 5. 需处理的问题

- ⚠️ **同名冲突**：
  - `docx`：自建 `skills/docx` 与 collected `skills-collected/docx` 同名。
  - `frontend-design`：自建 `skills/frontend-design` 与 collected `skills-collected/frontend-design` 同名。
  - 违反 AGENTS.md「同名冲突处理」规则（自建同名应加后缀，参考 `docx-simple`），会导致加载歧义。
- ⚠️ **命名不规范**：目录 `MermaidToPNGSkills`（驼峰）不符合「lowercase-hyphenated」规范；README 速览表已用 `mermaid-to-png`，应改名并同步 SKILL.md 内 `name`。

## 6. 建议下一步（待确认后执行）

1. **同步文档**：更新 README（collected 27→37、自建速览表补全 28 个）、INDEX.md、AGENTS.md（32→59 / 27→37）。
2. **解决冲突**：重命名或明确分工 `docx`、`frontend-design` 两套同名 Skill。
3. **规范命名**：`MermaidToPNGSkills` → `mermaid-to-png`，同步 SKILL.md 内 `name`。

## 7. 执行记录（2026-10-15，已确认执行）

- **剔除冗余（删除 2 个）**：
  - `skills/docx`（自建，anthropics 原版）— 与 `skills-collected/docx`（Proprietary 详尽版）同名冲突，且功能已被自建 `docx-simple` 覆盖。
  - `skills/frontend-design`（自建）— 与 `skills-collected/frontend-design` 逐行完全相同（100% 副本）。
- **重命名（1 个）**：`MermaidToPNGSkills` → `mermaid-to-png`，并同步 SKILL.md `name` 字段。
- **保留判定**：写作/前端套件（adapt/bolder/clarify/…/audit/algorithmic-art）为互补功能，非重复，全部保留；`impeccable` 虽与 frontend-design 能力重叠，但为增强变体（含 craft/teach/extract 模式）且 name 不冲突，保留。
- **门禁**：`validate-skills.ps1` 检查 57 个自建 SKILL.md，全部通过。
- **文档同步**：README（collected 27→37、自建速览表补全 26 个）、INDEX.md（社区表补 4 个）、AGENTS.md（57+37=94）已更新。
- **可恢复性**：删除经 git 暂存（`git rm`），可用 `git restore` / `git checkout` 恢复。

## 8. 提交状态（2026-10-15，已本地提交）

- **本地提交**：`bcca642` — `chore: add new skills batch and deduplicate repo`（82 files changed, +8621/-507）。
- **内容**：本次清理 + 文档同步 + 新增技能批次一并入库；`.workbuddy/`（内部记忆目录）已加入 `.gitignore` 并排除出暂存区。
- **钩子修复**：pre-commit 钩子此前在沙箱环境下多次挂死（根因：`grep -q` 管道 SIGPIPE、`rm` 沙箱拦截、PCRE 路径提取异常），已修复为 bash 内建判定 + 进程替换 + ERE 提取，现可正常退出（退出码 0）。
- **未推送**：按用户要求仅本地提交，未 `git push`。本地领先 `origin/main` 4 个 commit（含本次 1 个 + 之前会话 3 个），待用户决定何时推送。
