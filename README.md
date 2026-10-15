# Skills · Prompts · MCP

自己日常使用的 AI 技能、提示词和 MCP 配置的聚合仓库。收录社区优质 Skills 与自制 Skills，统一收纳，便于跨 Agent 平台复用。

> **快速导航**：不知道用哪个？先看 [INDEX.md](INDEX.md) —— 按场景组织，Skill 优先、Prompt 补充。

---

## 目录结构

```
.
├── INDEX.md                          # ⭐ 总导航（按场景找 Skill / Prompt）
├── skills/                           # Skills（自建 + 社区收集）
│   ├── <自建 Skill 目录>/
│   ├── platform-specific/            # 平台特定
│   └── skills-collected/             # 社区收集（只读，不修改）
├── agents/                           # Agent 配置（子代理 Playbook）
├── prompts/                          # 独立提示词模板
├── mcp/                              # MCP 服务器配置
├── scripts/                          # 门禁检查脚本
├── workflows/                        # 工作流定义
├── AGENTS.md                         # 仓库管理规范
├── INDEX.md                          # 总导航索引
└── CHANGELOG.md                      # 变更记录
```

---

## 门禁系统

本仓库对**自建 Skills**（`skills/` 下除 `skills-collected/` 外的 `SKILL.md`）使用格式门禁检查，提交前需通过 `AGENTS.md` 定义的规范。`skills-collected/` 为社区标准原样保留，**豁免门禁、只读不修改**。

```bash
# 手动运行检查（仅扫描自建 Skills）
.\scripts\validate-skills.ps1

# 仅检查暂存区
.\scripts\validate-skills.ps1 -StagedOnly
```

pre-commit hook 已挂载，`git commit` 时自动检查暂存区中的 SKILL.md 文件。

---

## 使用指南

### 我要做什么？

1. **看 [INDEX.md](INDEX.md)** —— 按场景查找对应的 Skill 或 Prompt
2. 有 Skill 的场景：直接让 AI 调用对应 Skill（自动化程度更高）
3. 暂无 Skill 的场景：复制 prompts/ 中的模板到对话中使用

### Prompts 与 Skills 的对应关系

每个 Prompt 文件头部标注了与其关联的 Skill：

```
<!-- 关联 Skill：code-review（代码审查场景推荐直接使用 Skill） -->
```

- **"无对应 Skill"** → 该 Prompt 暂无 Skill 覆盖，保留为独立模板
- **"推荐直接使用 Skill"** → 该场景已有 Skill 实现，优先用 Skill
- **"已升级为 Skill"** → 原 Prompt 已被 Skill 完全覆盖，仅保留索引

---

## Skills 快速速览

### 社区收集（skills-collected）

来自 Anthropic 官方、Superpowers、Vercel、社区热门等，共 37 个。包含：

- Office 文档处理：`docx`、`pptx`、`xlsx`、`pdf`
- 工程工作流：`brainstorming`、`test-driven-development`、`systematic-debugging`、`verification-before-completion`
- UI/UX 设计：`frontend-design`、`ui-ux-pro-max`
- 代码审查：`requesting-code-review`
- 极简工程：`ponytail` 系列（audit / debt / gain / help / review）
- 代码问答：`grill-me` / `grilling` / `grill-with-docs`
- 更多：`skill-creator`、`mcp-builder`、`webapp-testing`、`caveman`、`neat-freak` 等

### 自建 Skills

按应用场景分类：

| 场景 | Skills |
|------|--------|
| 代码审查 | `code-review`、`code-review-workflow`、`mr-commit-template`、`github-triage`、`agent-mr-commit-template` |
| UI/UX 设计 | `frontend-ui-ux`、`impeccable`、`adapt`、`bolder`、`clarify`、`colorize`、`critique`、`delight`、`distill`、`harden`、`optimize`、`overdrive`、`polish`、`quieter`、`shape`、`typeset`、`animate`、`audit`、`algorithmic-art` |
| 文档处理 | `docx-simple`、`markdownToWord` |
| 深度研究 | `hv-analysis` |
| 网文写作 | `story-init`、`character-management`、`worldbuilding`、`plot-structure`、`chapter-writing`、`story-ideator`、`book-analyzer`、`bible-merger`、`novel-writer`、`webnovel-writing` |
| 自媒体 | `fanqie-novel-writer`、`fanqie-female-writer`、`fanqie-male-writer`、`toutiao-writer`、`toutiao-ai-education`、`wechat-writer`、`khazix-writer` |
| AI 资讯 | `aihot` |
| Skill 管理 | `create-skill`、`skill-lookup`、`constraints-skills-builder` |
| 工具 | `ocr-installation-guide`、`mermaid-to-png`、`byted-seedance-video-generate`、`layout` |
| Obsidian | `obsidian-bases`、`obsidian-cli`、`obsidian-markdown` |
| 平台特定 | `platform-specific/ip-as-logo` |
| 计划/写作规划 | `writing-plans` |

→ 完整列表见 [INDEX.md](INDEX.md)

---

## Prompts 快速速览

9 个方向，覆盖 AI 开发、前后端、DevOps、数据分析、文档写作等场景。

| 分类 | 关联 Skill |
|------|-----------|
| [AI开发](prompts/AI开发.md) | 无 |
| [DevOps](prompts/DevOps.md) | 无 |
| [后端开发](prompts/后端开发.md) | 无 |
| [数据分析与SQL](prompts/数据分析与SQL.md) | 无 |
| [代码审查与重构](prompts/代码审查与重构.md) | → `code-review` |
| [前端开发](prompts/前端开发.md) | → `frontend-ui-ux` / `ui-ux-pro-max` |
| [文档写作](prompts/文档写作.md) | → `docx-simple` |
| [调试与排错](prompts/调试与排错.md) | → `systematic-debugging` |
| [横纵分析法](prompts/横纵分析法.md) | → `hv-analysis`（已升级为 Skill） |

---

## Agents

`agents/` 收录可复用的 Agent 配置（每个含 `agent.md` + `config.yaml`）。

> agents 和 skills 的关系：skill 是 AI 可调用的能力入口，agent 是同名 skill 背后的子代理 Playbook 定义。禁止只在 agents/ 放定义而不在 skills/ 申明入口。

| Agent | 说明 |
|-------|------|
| [_template](agents/_template/) | Agent 模板 |
| [frontend-designer](agents/frontend-designer/) | 前端设计师 Agent |
| [fanqie-female-writer](agents/fanqie-female-writer/) | 番茄女频写手 Agent |
| [fanqie-male-writer](agents/fanqie-male-writer/) | 番茄男频写手 Agent |
| [toutiao-ai-edu](agents/toutiao-ai-edu/) | 头条 AI 教育创作 Agent |

---

## MCP

20 个社区主流 MCP 服务器配置，每个子目录包含安装指南。

→ 详见 [mcp/README.md](mcp/README.md)

---

## 致谢

所有技能均来自其各自作者的辛勤开源贡献：

- [anthropics/skills](https://github.com/anthropics/skills) — Anthropic 官方，MIT License
- [obra/superpowers](https://github.com/obra/superpowers) — Jesse Vincent，MIT License
- [vercel-labs/skills](https://github.com/vercel-labs/skills) — Vercel，Apache 2.0
- [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) — MIT License
- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) — MIT License
- [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) — MIT License
- [KKKKhazix/khazix-skills](https://github.com/KKKKhazix/khazix-skills) — 数字生命卡兹克，MIT License
- [danjdewhurst/story-skills](https://github.com/danjdewhurst/story-skills) — MIT License
- [ThomasHoussin/Claude-Book](https://github.com/ThomasHoussin/Claude-Book) — MIT License
- Jeffallan（feature-forge、spec-miner）— MIT License
- ECC（plan-orchestrate、product-capability、product-lens）— 社区收集
- [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) — Ponytail 极简工程，MIT License
- [mattpocock/skills](https://github.com/mattpocock/skills) — Skills for Real Engineers，MIT License

本仓库仅做聚合整理，各 Skill 版权归原作者所有；自建部分遵循本仓库 `AGENTS.md` 规范。