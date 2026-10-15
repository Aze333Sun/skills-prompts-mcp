# 仓库概览：skills-prompts-mcp

> 生成时间：2026-09-11
> 说明：本文件基于当前工作区实际文件扫描生成，用于补充已过时的 README。

## 1. 仓库定位

个人 AI 工具聚合仓库，统一收纳三类资产：
- **Skills**（Agent 技能，标准 `SKILL.md` 格式）
- **Prompts**（独立提示词，复制即用）
- **MCP**（Model Context Protocol 服务器配置）

遵循 [Agent Skills](https://agentskills.io) 开放标准，可被 Claude Code / Codex / Cursor / Gemini CLI 等加载。

## 2. 真实规模 vs README 声明

| 板块 | README 声明 | 实际扫描 | 差异 |
|---|---|---|---|
| Skills 总数 | 34 | **59**（自建 32 + collected 27） | +25 |
| Prompts | 80 条 / 9 文件 | 9 文件（一致） | — |
| MCP | 20 个 | 20 个（一致） | — |
| Agents | 未提及 | **新增板块**：5 个 agent 配置 | 新增 |
| Workflows | 未提及 | **新增板块**：1 个目录 | 新增 |

**结论：README 与现状严重脱节，建议更新。** 详见第 7 节。

## 3. 目录结构

```
skills-prompts-mcp/
├── skills/                    # 59 个 SKILL.md
│   ├── skills-collected/      # 27 个社区收集（只读，禁止直接修改）
│   └── [34 个自建目录]        # 含 platform-specific/ 子目录
├── prompts/                   # 9 个 .md（80+ 提示词）
├── mcp/                       # 20 个服务器配置 + README
├── agents/                    # 5 个 agent 配置（_template / fanqie-female / fanqie-male / frontend-designer / toutiao-ai-edu）
├── workflows/                 # agent-workflow-catalog.md
├── scripts/                   # validate-skills.ps1 门禁脚本
├── AGENTS.md                  # 仓库管理规范
├── README.md                  # 已过时
└── WORKLOG.md                 # 2026-05-26 初始化记录
```

## 4. Skills — 自建（32 个，按主题）

| 主题 | Skills |
|---|---|
| 代码审查/提交 | `code-review`、`code-review-workflow`、`mr-commit-template`、`github-triage` |
| Skill 管理 | `create-skill`、`skill-lookup`、`constraints-skills-builder` |
| 设计与 UI/UX | `frontend-ui-ux`、`platform-specific/ip-as-logo` |
| 文档/图表 | `MermaidToPNGSkills`、`docx`（自建版，与 collected 同名） |
| 卡兹克系（研究/写作/资讯） | `hv-analysis`、`khazix-writer`、`aihot` |
| 通用规划 | `writing-plans` |
| 小说创作 | `story-init`、`character-management`、`worldbuilding`、`plot-structure`、`chapter-writing`、`story-ideator`、`book-analyzer`、`bible-merger` |
| 自媒体/网文（README 未记） | `toutiao-ai-education`、`toutiao-writer`、`wechat-writer`、`novel-writer`、`fanqie-novel-writer`、`fanqie-male-writer`、`fanqie-female-writer`、`webnovel-writing`、`ocr-installation-guide` |

## 5. Skills — skills-collected（27 个，按来源）

| 来源 | Skills |
|---|---|
| Anthropic 官方 (9) | `skill-creator`、`mcp-builder`、`webapp-testing`、`frontend-design`、`pdf`、`docx`、`pptx`、`xlsx`、`brand-guidelines` |
| Superpowers 工作流 (6) | `brainstorming`、`test-driven-development`、`systematic-debugging`、`verification-before-completion`、`requesting-code-review`、`using-git-worktrees` |
| 社区热门 (4) | `find-skills`、`planning-with-files`、`caveman`、`ui-ux-pro-max` |
| 卡兹克 (1) | `neat-freak` |
| 小说 (1) | `perplexity-improver` |
| 新增未记录 (6) | `feature-forge`、`market-insight`、`plan-orchestrate`、`product-capability`、`product-lens`、`spec-miner` |

> ⚠️ 规范约束：`skills/skills-collected/` 下文件**禁止直接修改**，如需定制须创建自建 Skill 引用。

## 6. 其他板块

- **Prompts（9 文件）**：前端开发、后端开发、文档写作、代码审查与重构、调试与排错、AI 开发、DevOps、数据分析与 SQL、横纵分析法。
- **MCP（20 个）**：GitHub、Filesystem、Git、Playwright、Chrome DevTools、Figma、Context7、Brave Search、Firecrawl、Perplexity、Postgres Pro、Supabase、Stripe、Slack、Notion、Linear、Vercel、Sentry、Desktop Commander、Memory。每个含 README + `settings.json` 模板。
- **Agents（新增，README 未记）**：`_template/`（模板）、`fanqie-female-writer/`、`fanqie-male-writer/`、`frontend-designer/`、`toutiao-ai-edu/`，各含 `agent.md` + `config.yaml`；另有 `Awesome-design-md/DESIGN默认模板.md`、`暗黑风格UI提示词.md`。
- **Workflows（新增，README 未记）**：`agent-workflow-catalog.md`。

## 7. README 与现状差异清单（需更新）

1. Skills 总数 34 → **59**（新增 25 个，主要为小说/自媒体写作类）。
2. collected 新增 6 个未记录：`feature-forge`、`market-insight`、`plan-orchestrate`、`product-capability`、`product-lens`、`spec-miner`。
3. 新增 `agents/`、`workflows/` 两大板块，README 完全未提及。
4. README 提到的 `chinese-webnovel`、`opencode-review` 在当前目录中不存在（已被重命名/重构）。
5. 存在同名 `docx` Skill（自建 + collected 各一份），存在加载歧义风险。

## 8. 门禁与规范

- 格式检查：`scripts/validate-skills.ps1`（检查 YAML frontmatter、`description` 以 "Use when..." 开头、必含 When to Use / Quick Reference / Common Mistakes 章节）。
- 命名：`name` 仅允许 `a-z 0-9 -`；自建目录 `lowercase-hyphenated`。
- 提交规范：`<type>: <desc>`，type ∈ feat/fix/docs/refactor。
- 详细规范见 `AGENTS.md`。

---
*本概览为静态快照，仓库持续演进时请以实际文件为准。*
