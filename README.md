# Skills · Prompts · MCP

自己日常使用的 AI 技能、提示词和 MCP 配置的聚合仓库，收录社区 Top 20 最受欢迎的 Claude Code Skills。

---

## 目录结构

```
.
├── skills/          # 24 个 Agent Skills（SKILL.md 标准格式）
├── prompts/         # 独立提示词（复制粘贴即用）
├── mcp/             # MCP 服务器配置
└── README.md
```

---

## Skills

遵循 [Agent Skills](https://agentskills.io) 开放标准，Claude Code、Codex、Cursor、Gemini CLI 等均可加载。

### Anthropic 官方

| Skill | 说明 | 来源 |
|---|---|---|
| 🛠️ [skill-creator](skills/skill-creator/SKILL.md) | 元技能：创建、优化和评估新 Skill | [anthropics/skills](https://github.com/anthropics/skills) |
| 🔌 [mcp-builder](skills/mcp-builder/SKILL.md) | 构建 MCP 服务器，连接外部 API 和工具 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🧪 [webapp-testing](skills/webapp-testing/SKILL.md) | Playwright 驱动的 Web 应用测试与调试 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🎨 [frontend-design](skills/frontend-design/SKILL.md) | 生产级前端界面设计，告别"AI 味"审美 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📄 [pdf](skills/pdf/SKILL.md) | PDF 全能处理：读取、创建、合并、拆分、表单、OCR | [anthropics/skills](https://github.com/anthropics/skills) |
| 📝 [docx](skills/docx/SKILL.md) | Word 文档生成与编辑，支持目录、页眉、批注 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📊 [pptx](skills/pptx/SKILL.md) | PowerPoint 幻灯片创建与编辑 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📈 [xlsx](skills/xlsx/SKILL.md) | Excel 电子表格创建、编辑、清洗、图表 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🏷️ [brand-guidelines](skills/brand-guidelines/SKILL.md) | 品牌视觉规范：颜色、字体、风格一致性 | [anthropics/skills](https://github.com/anthropics/skills) |

### Superpowers 工程工作流

| Skill | 说明 | 来源 |
|---|---|---|
| 💡 [brainstorming](skills/brainstorming/SKILL.md) | 苏格拉底式需求审视与方案设计 | [obra/superpowers](https://github.com/obra/superpowers) |
| 🧪 [test-driven-development](skills/test-driven-development/SKILL.md) | 严格 TDD：RED → GREEN → REFACTOR | [obra/superpowers](https://github.com/obra/superpowers) |
| 🐛 [systematic-debugging](skills/systematic-debugging/SKILL.md) | 科学调试法：观察 → 假设 → 验证 → 修复 | [obra/superpowers](https://github.com/obra/superpowers) |
| ✅ [verification-before-completion](skills/verification-before-completion/SKILL.md) | 完成前强制验证，证据先于断言 | [obra/superpowers](https://github.com/obra/superpowers) |
| 📋 [writing-plans](skills/writing-plans/SKILL.md) | 将任务拆分为 2-5 分钟可执行步骤 | [obra/superpowers](https://github.com/obra/superpowers) |
| 👀 [requesting-code-review](skills/requesting-code-review/SKILL.md) | 提交前代码审查，按严重程度分类 | [obra/superpowers](https://github.com/obra/superpowers) |
| 🌿 [using-git-worktrees](skills/using-git-worktrees/SKILL.md) | Git Worktree 隔离开发，并行特性开发 | [obra/superpowers](https://github.com/obra/superpowers) |

### 社区热门

| Skill | 说明 | 来源 |
|---|---|---|
| 🔍 [find-skills](skills/find-skills/SKILL.md) | 技能发现引擎，帮你搜索和安装合适的 Skill | [vercel-labs/skills](https://github.com/vercel-labs/skills) |
| 📐 [planning-with-files](skills/planning-with-files/SKILL.md) | Manus 风格文件化任务规划，持久化工作记忆 | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) |
| 🪨 [caveman](skills/caveman/SKILL.md) | 山顶洞人模式：Token 用量直降 ~75%，三倍响应速度 | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |
| 🎯 [ui-ux-pro-max](skills/ui-ux-pro-max/SKILL.md) | UI/UX 设计智能体：50+ 风格、161 色板、57 字体组合 | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |

### 数字生命卡兹克

| Skill | 说明 | 来源 |
|---|---|---|
| 🧹 [neat-freak](skills/neat-freak/SKILL.md) | 会话结束后文档与记忆的洁癖级同步 | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |
| 🔭 [hv-analysis](skills/hv-analysis/SKILL.md) | 横纵分析法深度研究，产出万字 PDF 报告 | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |
| ✍️ [khazix-writer](skills/khazix-writer/SKILL.md) | 卡兹克公众号长文写作风格 | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |
| 🔥 [aihot](skills/aihot/SKILL.md) | AI HOT 中文 AI 资讯查询，无需 API Key | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |

---

## Prompts

80 个高质量提示词，覆盖 8 个方向，每个方向 10 个。复制粘贴到 ChatGPT / Claude / Gemini 等任意对话中即可使用。

| 分类 | 内容 | 提示词数 |
|---|---|---|
| 🖥️ [前端开发](prompts/前端开发.md) | React 组件、CSS 布局、性能优化、动画、测试 | 10 |
| ⚙️ [后端开发](prompts/后端开发.md) | API 设计、数据库、缓存、消息队列、认证授权 | 10 |
| 📝 [文档写作](prompts/文档写作.md) | README、API 文档、技术方案、复盘报告、周报 | 10 |
| 🔍 [代码审查与重构](prompts/代码审查与重构.md) | PR Review、坏味道识别、重构手法、测试重构 | 10 |
| 🐛 [调试与排错](prompts/调试与排错.md) | 日志分析、性能瓶颈、内存泄漏、生产事故 | 10 |
| 🤖 [AI 开发](prompts/AI开发.md) | Prompt 工程、RAG 调优、Agent 设计、模型迁移 | 10 |
| 🚀 [DevOps](prompts/DevOps.md) | Docker、CI/CD、K8s、监控告警、故障演练 | 10 |
| 📊 [数据分析与 SQL](prompts/数据分析与SQL.md) | SQL 优化、数据清洗、A/B 测试、指标体系 | 10 |
| 🔭 [横纵分析法](prompts/横纵分析法.md) | 深度研究 Prompt（轻量版），适用于 Deep Research 模型 | 独立 |

---

## MCP

MCP (Model Context Protocol) 服务器 — 扩展 Claude Code 的工具能力，连接外部服务和 API。

收录社区 Top 20 最受欢迎的 MCP 服务器，每个子目录包含安装命令和 settings.json 配置模板。

→ 详见 [mcp/README.md](mcp/README.md)

| # | MCP | 类别 | 来源 |
|---|---|---|---|
| 1 | [GitHub](mcp/github/) | 开发工具 | [官方](https://github.com/modelcontextprotocol/servers) |
| 2 | [Filesystem](mcp/filesystem/) | 开发工具 | [官方](https://github.com/modelcontextprotocol/servers) |
| 3 | [Git](mcp/git/) | 开发工具 | [idosal/git-mcp](https://github.com/idosal/git-mcp) |
| 4 | [Playwright](mcp/playwright/) | 浏览器测试 | [Microsoft](https://github.com/microsoft/playwright-mcp) |
| 5 | [Chrome DevTools](mcp/chrome-devtools/) | 浏览器调试 | [ChromeDevTools](https://github.com/ChromeDevTools/chrome-devtools-mcp) |
| 6 | [Figma](mcp/figma/) | 设计→代码 | [Figma](https://github.com/figma/figma-developer-mcp) |
| 7 | [Context7](mcp/context7/) | 实时文档 | [Upstash](https://github.com/upstash/context7) |
| 8 | [Brave Search](mcp/brave-search/) | 网页搜索 | [Anthropic](https://github.com/modelcontextprotocol/servers) |
| 9 | [Firecrawl](mcp/firecrawl/) | 网页抓取 | [Firecrawl](https://github.com/firecrawl/firecrawl-mcp) |
| 10 | [Perplexity](mcp/perplexity/) | 深度研究 | [Perplexity](https://docs.perplexity.ai/guides/mcp-server) |
| 11 | [Postgres Pro](mcp/postgres-pro/) | 数据库 | [Crystal DBA](https://github.com/crystaldba/postgres-mcp-pro) |
| 12 | [Supabase](mcp/supabase/) | 数据库 | [Supabase](https://github.com/supabase-community/mcp-server-supabase) |
| 13 | [Stripe](mcp/stripe/) | 支付 | [Stripe](https://github.com/stripe/mcp) |
| 14 | [Slack](mcp/slack/) | 沟通 | [Slack](https://github.com/slack/mcp) |
| 15 | [Notion](mcp/notion/) | 知识管理 | [Notion](https://github.com/notionhq/notion-mcp-server) |
| 16 | [Linear](mcp/linear/) | 项目管理 | [Linear](https://github.com/linear/linear-mcp) |
| 17 | [Vercel](mcp/vercel/) | 部署 | [Vercel](https://github.com/vercel/vercel-mcp) |
| 18 | [Sentry](mcp/sentry/) | 错误监控 | [Sentry](https://github.com/getsentry/sentry-mcp) |
| 19 | [Desktop Commander](mcp/desktop-commander/) | 系统控制 | [wonderwhy-er](https://github.com/wonderwhy-er/DesktopCommanderMCP) |
| 20 | [Memory](mcp/memory/) | 记忆系统 | [Anthropic](https://github.com/modelcontextprotocol/servers) |

---

## 安装方式

每个 Skill 的安装方式取决于你使用的 Agent 平台：

```bash
# Claude Code — 直接引用本地路径
claude skill add ./skills/skill-creator

# 通用方式 (skills.sh CLI)
npx skills add anthropics/skills --skill pdf

# Claude Code 插件市场
/plugin marketplace add anthropics/skills
```

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

本仓库仅做聚合整理，各 Skill 版权归原作者所有。
