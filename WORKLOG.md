# 工作记录

## 2026-05-26 — 仓库初始化与整合

### 概述

将 `skills-prompts-mcp` 仓库从空壳搭建为包含 Skills、Prompts、MCP 三大板块的个人工具库。

### 第一阶段：Skills 库搭建

- 整理原有 `khazix-skills` 仓库结构，将 4 个 Skill + 1 个 Prompt 归入对应目录
- 调研社区 Top 20 最受欢迎的 Claude Code Skills，按来源分类安装：
  - **Anthropic 官方 (9)**: skill-creator, mcp-builder, webapp-testing, frontend-design, pdf, docx, pptx, xlsx, brand-guidelines
  - **Superpowers 工作流 (7)**: brainstorming, test-driven-development, systematic-debugging, verification-before-completion, writing-plans, requesting-code-review, using-git-worktrees
  - **社区精选 (4)**: find-skills (Vercel), planning-with-files, caveman, ui-ux-pro-max
- 撰写 README.md，按来源分类展示，注明原作者和许可证

### 第二阶段：MCP 服务器配置

- 调研社区 Top 20 MCP 服务器，按类别整合：
  - **开发工具 (3)**: GitHub, Filesystem, Git
  - **浏览器测试 (2)**: Playwright, Chrome DevTools
  - **设计 (1)**: Figma
  - **文档搜索 (4)**: Context7, Brave Search, Firecrawl, Perplexity
  - **数据库 (2)**: Postgres Pro, Supabase
  - **业务 (1)**: Stripe
  - **协作 (3)**: Slack, Notion, Linear
  - **部署监控 (2)**: Vercel, Sentry
  - **系统记忆 (2)**: Desktop Commander, Memory
- 每个 MCP 创建独立目录，包含 README.md（简介、安装命令、settings.json 模板、环境变量说明）
- 创建 `mcp/README.md` 作为总目录

### 第三阶段：提示词库

- 搜集 8 个方向各 10 个高质量提示词，共 80 个：
  - 前端开发、后端开发、文档写作、代码审查与重构
  - 调试与排错、AI 开发、DevOps、数据分析与 SQL
- 保留原有「横纵分析法」独立 Prompt
- 每个方向为一个独立 markdown 文件，每个提示词包含完整 Prompt 文本和使用说明

### 第四阶段：小说写作 Skills

- 搜集社区最火的 10 个小说写作 Skill：
  - **story-skills (5)**: story-init, character-management, worldbuilding, plot-structure, chapter-writing
  - **Claude-Book (4)**: story-ideator, book-analyzer, bible-merger, perplexity-improver
  - **Chinese-WebNovel-Skill (1)**: chinese-webnovel（中文网文全流程）
- 覆盖小说创作完整链路：搭框架 → 建角色 → 造世界 → 构情节 → 写章节 → 降 AI 味

### 最终统计

| 板块 | 数量 | 格式 |
|---|---|---|
| Skills | 34 个 | SKILL.md 标准 |
| Prompts | 9 文件 / 81 条 | Markdown |
| MCP 配置 | 20 个 | README + settings.json 模板 |

### 数据来源

所有技能均来自社区开源仓库，已在 README 和各自文件中标注出处。主要来源：

- [anthropics/skills](https://github.com/anthropics/skills)
- [obra/superpowers](https://github.com/obra/superpowers)
- [vercel-labs/skills](https://github.com/vercel-labs/skills)
- [danjdewhurst/story-skills](https://github.com/danjdewhurst/story-skills)
- [ThomasHoussin/Claude-Book](https://github.com/ThomasHoussin/Claude-Book)
- [Tomsawyerhu/Chinese-WebNovel-Skill](https://github.com/Tomsawyerhu/Chinese-WebNovel-Skill)
- [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)
- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)
- [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- [KKKKhazix/khazix-skills](https://github.com/KKKKhazix/khazix-skills)

### Git 提交记录

```
637c175 Add Top 10 community novel/story writing Skills
2eef9bb Add 80 curated prompts across 8 categories
f4cbcfd Add Top 20 community MCP server configuration docs
872c82e Add Top 20 community-recommended Claude Code Skills
33197fe 完成合并并整合 Skills 库
```

---

> 仓库地址: https://github.com/Aze333Sun/skills-prompts-mcp
