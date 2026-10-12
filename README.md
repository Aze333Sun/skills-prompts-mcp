# Skills · Prompts · MCP

自己日常使用的 AI 技能、提示词和 MCP 配置的聚合仓库，收录社区 Top 20 最受欢迎的 Claude Code Skills。

---

## 目录结构

```
.
├── skills/          # 30 个 Agent Skills（SKILL.md 标准格式）
├── skills/skills-collected/ # 27 个社区收集的 Skills
├── prompts/         # 独立提示词（复制粘贴即用）
├── mcp/             # MCP 服务器配置
├── scripts/         # 门禁检查脚本
└── README.md
```

---

## 门禁系统

本仓库使用 Git pre-commit hook 自动检查 SKILL.md 格式规范：

```bash
# 手动运行检查
.\scripts\validate-skills.ps1

# Git commit 时自动检查
# 安装 hook：复制 .git/hooks/pre-commit 到 .git/hooks/
```

**检查规则：**
- YAML frontmatter 必须存在
- `name` 字段格式正确（仅字母/数字/连字符）
- `name` 全仓库唯一（重复会导致 Skill 加载冲突，直接阻断提交）
- `description` 以 "Use when..." 开头（`skills-collected/` 为只读上游副本，跳过格式规则）
- 包含 When to Use、Quick Reference、Common Mistakes 标准章节

---

## Skills

遵循 [Agent Skills](https://agentskills.io) 开放标准，Claude Code、Codex、Cursor、Gemini CLI 等均可加载。

### Anthropic 官方

| Skill | 说明 | 来源 |
|---|---|---|
| 🛠️ [skill-creator](skills/skills-collected/skill-creator/SKILL.md) | 元技能：创建、优化和评估新 Skill | [anthropics/skills](https://github.com/anthropics/skills) |
| 🔌 [mcp-builder](skills/skills-collected/mcp-builder/SKILL.md) | 构建 MCP 服务器，连接外部 API 和工具 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🧪 [webapp-testing](skills/skills-collected/webapp-testing/SKILL.md) | Playwright 驱动的 Web 应用测试与调试 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🎨 [frontend-design](skills/skills-collected/frontend-design/SKILL.md) | 生产级前端界面设计，告别"AI 味"审美 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📄 [pdf](skills/skills-collected/pdf/SKILL.md) | PDF 全能处理：读取、创建、合并、拆分、表单、OCR | [anthropics/skills](https://github.com/anthropics/skills) |
| 📝 [docx](skills/skills-collected/docx/SKILL.md) | Word 文档生成与编辑，支持修订、批注、格式保留 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📊 [pptx](skills/skills-collected/pptx/SKILL.md) | PowerPoint 幻灯片创建与编辑 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📈 [xlsx](skills/skills-collected/xlsx/SKILL.md) | Excel 电子表格创建、编辑、清洗、图表 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🏷️ [brand-guidelines](skills/skills-collected/brand-guidelines/SKILL.md) | 品牌视觉规范：颜色、字体、风格一致性 | [anthropics/skills](https://github.com/anthropics/skills) |

### Superpowers 工程工作流

| Skill | 说明 | 来源 |
|---|---|---|
| 💡 [brainstorming](skills/skills-collected/brainstorming/SKILL.md) | 苏格拉底式需求审视与方案设计 | [obra/superpowers](https://github.com/obra/superpowers) |
| 🧪 [test-driven-development](skills/skills-collected/test-driven-development/SKILL.md) | 严格 TDD：RED → GREEN → REFACTOR | [obra/superpowers](https://github.com/obra/superpowers) |
| 🐛 [systematic-debugging](skills/skills-collected/systematic-debugging/SKILL.md) | 科学调试法：观察 → 假设 → 验证 → 修复 | [obra/superpowers](https://github.com/obra/superpowers) |
| ✅ [verification-before-completion](skills/skills-collected/verification-before-completion/SKILL.md) | 完成前强制验证，证据先于断言 | [obra/superpowers](https://github.com/obra/superpowers) |
| 📋 [writing-plans](skills/writing-plans/SKILL.md) | 将任务拆分为 2-5 分钟可执行步骤 | [obra/superpowers](https://github.com/obra/superpowers) |
| 👀 [requesting-code-review](skills/skills-collected/requesting-code-review/SKILL.md) | 提交前代码审查，按严重程度分类 | [obra/superpowers](https://github.com/obra/superpowers) |
| 🌿 [using-git-worktrees](skills/skills-collected/using-git-worktrees/SKILL.md) | Git Worktree 隔离开发，并行特性开发 | [obra/superpowers](https://github.com/obra/superpowers) |

### 社区热门

| Skill | 说明 | 来源 |
|---|---|---|
| 🔍 [find-skills](skills/skills-collected/find-skills/SKILL.md) | 技能发现引擎，帮你搜索和安装合适的 Skill | [vercel-labs/skills](https://github.com/vercel-labs/skills) |
| 📐 [planning-with-files](skills/skills-collected/planning-with-files/SKILL.md) | Manus 风格文件化任务规划，持久化工作记忆 | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) |
| 🪨 [caveman](skills/skills-collected/caveman/SKILL.md) | 山顶洞人模式：Token 用量直降 ~75%，三倍响应速度 | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |
| 🎯 [ui-ux-pro-max](skills/skills-collected/ui-ux-pro-max/SKILL.md) | UI/UX 设计智能体：50+ 风格、161 色板、57 字体组合 | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |

### 数字生命卡兹克

| Skill | 说明 | 来源 |
|---|---|---|
| 🧹 [neat-freak](skills/skills-collected/neat-freak/SKILL.md) | 会话结束后文档与记忆的洁癖级同步 | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |
| 🔭 [hv-analysis](skills/hv-analysis/SKILL.md) | 横纵分析法深度研究，产出万字 PDF 报告 | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |
| ✍️ [khazix-writer](skills/khazix-writer/SKILL.md) | 卡兹克公众号长文写作风格 | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |
| 🔥 [aihot](skills/aihot/SKILL.md) | AI HOT 中文 AI 资讯查询，无需 API Key | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |

### 小说写作

| Skill | 说明 | 来源 |
|---|---|---|
| 📖 [story-init](skills/story-init/SKILL.md) | 故事脚手架搭建：圣经、角色/世界观注册表 | [story-skills](https://github.com/danjdewhurst/story-skills) |
| 👤 [character-management](skills/character-management/SKILL.md) | 角色档案：关系、特征、人物弧光、家族树 | [story-skills](https://github.com/danjdewhurst/story-skills) |
| 🌍 [worldbuilding](skills/worldbuilding/SKILL.md) | 世界观构建：魔法/政治/科技/宗教系统 | [story-skills](https://github.com/danjdewhurst/story-skills) |
| 📐 [plot-structure](skills/plot-structure/SKILL.md) | 情节规划（三幕式、英雄之旅、起承转合） | [story-skills](https://github.com/danjdewhurst/story-skills) |
| ✍️ [chapter-writing](skills/chapter-writing/SKILL.md) | 大纲优先的章节写作，自动拉取上下文保持一致 | [story-skills](https://github.com/danjdewhurst/story-skills) |
| 💡 [story-ideator](skills/story-ideator/SKILL.md) | 从宇宙圣经生成原创故事线，不抄袭源材料 | [Claude-Book](https://github.com/ThomasHoussin/Claude-Book) |
| 🔍 [book-analyzer](skills/book-analyzer/SKILL.md) | 分析已有书籍提取风格指纹、结构模式 | [Claude-Book](https://github.com/ThomasHoussin/Claude-Book) |
| 📚 [bible-merger](skills/bible-merger/SKILL.md) | 合并多源设定文件为统一的故事圣经 | [Claude-Book](https://github.com/ThomasHoussin/Claude-Book) |
| 🎨 [perplexity-improver](skills/skills-collected/perplexity-improver/SKILL.md) | 降低 AI 痕迹，提升文风自然度 | [Claude-Book](https://github.com/ThomasHoussin/Claude-Book) |
| 🇨🇳 [chinese-webnovel](skills/chinese-webnovel/SKILL.md) | 中文网文全流程：选材/构思/分卷/章纲/去AI味 | [Chinese-WebNovel-Skill](https://github.com/Tomsawyerhu/Chinese-WebNovel-Skill) |
| 📖 [novel-writer](skills/novel-writer/SKILL.md) | 长篇网文通用框架：选题→黄金三章→章纲→逐章→去AI味 | 自建 |
| 🍅 [fanqie-novel-writer](skills/fanqie-novel-writer/SKILL.md) | 番茄平台特化：推荐机制/爽点密度/广告变现 | 自建 |
| 🍅 [fanqie-male-writer](skills/fanqie-male-writer/SKILL.md) | 番茄男频：玄幻/都市重生/系统流/赘婿流 | 自建 |
| 🍅 [fanqie-female-writer](skills/fanqie-female-writer/SKILL.md) | 番茄女频：言情/古言/重生复仇/甜宠总裁 | 自建 |

### 内容创作（公众号 / 头条）

| Skill | 说明 | 来源 |
|---|---|---|
| 📱 [wechat-writer](skills/wechat-writer/SKILL.md) | 微信公众号通用写作：推文/长文/排版/标题优化 | 自建 |
| 📰 [toutiao-writer](skills/toutiao-writer/SKILL.md) | 今日头条信息流写作：头条体/微头条/爆款标题 | 自建 |
| 🤖 [toutiao-ai-education](skills/toutiao-ai-education/SKILL.md) | 头条 AI 教育赛道：AI教程/工具测评/AI副业 | 自建 |

### 代码审查与工作流

| Skill | 说明 | 来源 |
|---|---|---|
| 🔍 [code-review](skills/code-review/SKILL.md) | 多Agent并行代码审查：bug/安全/性能/质量 | 自建 |
| 🔍 [code-review-workflow](skills/code-review-workflow/SKILL.md) | 基于OCR的提交前代码审查工作流 | 自建 |
| 📝 [mr-commit-template](skills/mr-commit-template/SKILL.md) | 提交前MR描述生成+代码评审+提交记录归档 | 自建 |
| 🔍 [opencode-review](skills/opencode-review/SKILL.md) | OpenCodeReview(OCR)集成指南 | 自建 |
| 🐙 [github-triage](skills/github-triage/SKILL.md) | GitHub Issue/PR统一处理，并行后台执行 | 自建 |

### Skill 创建与管理

| Skill | 说明 | 来源 |
|---|---|---|
| 🔍 [skill-lookup](skills/skill-lookup/SKILL.md) | 从prompts.chat注册表搜索安装Skills | 自建 |
| 📐 [constraints-skills-builder](skills/constraints-skills-builder/SKILL.md) | 从源码提取约束生成分层Skills知识体系 | 自建 |

> Skill 创建/评估功能见上方 Anthropic 官方 [skill-creator](skills/skills-collected/skill-creator/SKILL.md)（原 `create-skill` 为其本地化副本，已合并去重）。

### 设计与UI/UX

| Skill | 说明 | 来源 |
|---|---|---|
| 🎨 [frontend-ui-ux](skills/frontend-ui-ux/SKILL.md) | 设计师转开发角色，无设计稿下的UI/UX设计 | 自建 |
| 🖼️ [ip-as-logo](skills/platform-specific/ip-as-logo/SKILL.md) | 极简IP角色方形图片生成 | 自建 |

### 文档处理

| Skill | 说明 | 来源 |
|---|---|---|
| 📊 [mermaid-to-png](skills/MermaidToPNGSkills/SKILL.md) | Mermaid代码块批量渲染为PNG图片 | 自建 |

### 产品与需求（社区收集）

| Skill | 说明 | 来源 |
|---|---|---|
| 🔨 [feature-forge](skills/skills-collected/feature-forge/SKILL.md) | 需求工作坊：EARS格式需求/用户故事/验收标准 | 社区收集 |
| 🔍 [spec-miner](skills/skills-collected/spec-miner/SKILL.md) | 从遗留/无文档代码库逆向提取规格与架构文档 | 社区收集 |
| 🧭 [product-lens](skills/skills-collected/product-lens/SKILL.md) | 构建前验证"为什么"：产品诊断与方向压力测试 | 社区收集 |
| 🧩 [product-capability](skills/skills-collected/product-capability/SKILL.md) | PRD意图转实现级能力计划：约束/接口/未决项 | 社区收集 |
| 💡 [market-insight](skills/skills-collected/market-insight/SKILL.md) | 用户需求洞察与产品机会分析 | 社区收集 |
| 🎼 [plan-orchestrate](skills/skills-collected/plan-orchestrate/SKILL.md) | 读取计划文档，按步骤生成 agent 编排链提示词 | 社区收集 |

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

**存储路径**（按你使用的 AI 编码助手选择对应路径）：

| Type | Comate | Claude Code | OpenCode | Scope |
|------|--------|-------------|----------|-------|
| Personal | `~/.comate/skills/skill-name/` | `~/.claude/skills/skill-name/` | `~/.config/opencode/skills/skill-name/` | 所有项目可用 |
| Project | `.comate/skills/skill-name/` | `.claude/skills/skill-name/` | `.opencode/skills/skill-name/` | 仅当前仓库共享 |

> 新增 Skill 必须是所选 skills 根目录的直接子目录——嵌套在其他 Skill 目录内的 Skill 会被视为父 Skill 的资源文件，不会作为已安装 Skill 出现。

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
- [Tomsawyerhu/Chinese-WebNovel-Skill](https://github.com/Tomsawyerhu/Chinese-WebNovel-Skill) — MIT License

本仓库仅做聚合整理，各 Skill 版权归原作者所有。
