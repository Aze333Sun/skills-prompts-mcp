# Skills · Prompts · MCP

自己日常使用的 AI 技能、提示词和 MCP 配置的聚合仓库。收录社区优质 Skills 与自制 Skills，统一收纳，便于跨 Agent 平台复用。

**规模总览**：Skills 59 个（自建 32 + 社区收集 27）、Agents 7 个、Prompts 9 方向 80+ 条、MCP 20 个。

---

## 目录结构

```
.
├── skills/                          # 全部 59 个 Skills
│   ├── <32 个自建 Skill 目录>/        # 自建，遵循 AGENTS.md 门禁规范
│   ├── platform-specific/           # 平台特定（ip-as-logo）
│   └── skills-collected/            # 27 个社区收集，只读（见下方说明）
├── agents/                          # Agent 配置与模板（7 个）
├── prompts/                         # 独立提示词（9 方向，80+ 条）
├── mcp/                             # 20 个 MCP 服务器配置
├── scripts/                         # 门禁检查脚本（validate-skills.ps1）
├── workflows/                       # 工作流定义
└── README.md
```

---

## 门禁系统

本仓库对**自建 Skills**（`skills/` 下除 `skills-collected/` 外的 `SKILL.md`）使用格式门禁检查，提交前需通过 `AGENTS.md` 定义的规范（YAML frontmatter + `Use when` 开头 description + 三标准章节）。`skills-collected/` 为社区标准原样保留，**豁免门禁、只读不修改**。

```bash
# 手动运行检查（仅扫描自建 Skills）
.\scripts\validate-skills.ps1

# 仅检查暂存区
.\scripts\validate-skills.ps1 -StagedOnly
```

**检查规则（自建适用）：**
- YAML frontmatter 必须存在，含 `name`、`description`
- `name` 格式正确（仅字母/数字/连字符）
- `description` 以 "Use when..." 开头，长度 < 500 字符
- 包含 `When to Use`、`Quick Reference`、`Common Mistakes` 标准章节

---

## Skills

遵循 [Agent Skills](https://agentskills.io) 开放标准，Claude Code、Codex、Cursor、Gemini CLI 等均可加载。

> 目录约定：`skills/skills-collected/` 为社区收集（只读，来源见各文件 frontmatter）；其余为自建。

### 社区收集 · Anthropic 官方（skills-collected）

| Skill | 说明 | 来源 |
|---|---|---|
| 🛠️ [skill-creator](skills/skills-collected/skill-creator/SKILL.md) | 元技能：创建、优化和评估新 Skill | [anthropics/skills](https://github.com/anthropics/skills) |
| 🔌 [mcp-builder](skills/skills-collected/mcp-builder/SKILL.md) | 构建 MCP 服务器，连接外部 API 和工具 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🧪 [webapp-testing](skills/skills-collected/webapp-testing/SKILL.md) | Playwright 驱动的 Web 应用测试与调试 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🎨 [frontend-design](skills/skills-collected/frontend-design/SKILL.md) | 生产级前端界面设计，告别"AI 味"审美 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📄 [pdf](skills/skills-collected/pdf/SKILL.md) | PDF 全能处理：读取、创建、合并、拆分、表单、OCR | [anthropics/skills](https://github.com/anthropics/skills) |
| 📝 [docx](skills/skills-collected/docx/SKILL.md) | Word 文档生成与编辑，支持修订、批注、格式保留（完整版） | [anthropics/skills](https://github.com/anthropics/skills) |
| 📊 [pptx](skills/skills-collected/pptx/SKILL.md) | PowerPoint 幻灯片创建与编辑 | [anthropics/skills](https://github.com/anthropics/skills) |
| 📈 [xlsx](skills/skills-collected/xlsx/SKILL.md) | Excel 电子表格创建、编辑、清洗、图表 | [anthropics/skills](https://github.com/anthropics/skills) |
| 🏷️ [brand-guidelines](skills/skills-collected/brand-guidelines/SKILL.md) | 品牌视觉规范：颜色、字体、风格一致性 | [anthropics/skills](https://github.com/anthropics/skills) |

### 社区收集 · Superpowers 工程工作流（skills-collected）

| Skill | 说明 | 来源 |
|---|---|---|
| 💡 [brainstorming](skills/skills-collected/brainstorming/SKILL.md) | 苏格拉底式需求审视与方案设计 | [obra/superpowers](https://github.com/obra/superpowers) |
| 🧪 [test-driven-development](skills/skills-collected/test-driven-development/SKILL.md) | 严格 TDD：RED → GREEN → REFACTOR | [obra/superpowers](https://github.com/obra/superpowers) |
| 🐛 [systematic-debugging](skills/skills-collected/systematic-debugging/SKILL.md) | 科学调试法：观察 → 假设 → 验证 → 修复 | [obra/superpowers](https://github.com/obra/superpowers) |
| ✅ [verification-before-completion](skills/skills-collected/verification-before-completion/SKILL.md) | 完成前强制验证，证据先于断言 | [obra/superpowers](https://github.com/obra/superpowers) |
| 📋 [requesting-code-review](skills/skills-collected/requesting-code-review/SKILL.md) | 提交前代码审查，按严重程度分类 | [obra/superpowers](https://github.com/obra/superpowers) |
| 🌿 [using-git-worktrees](skills/skills-collected/using-git-worktrees/SKILL.md) | Git Worktree 隔离开发，并行特性开发 | [obra/superpowers](https://github.com/obra/superpowers) |

### 社区收集 · 社区热门（skills-collected）

| Skill | 说明 | 来源 |
|---|---|---|
| 🔍 [find-skills](skills/skills-collected/find-skills/SKILL.md) | 技能发现引擎，帮你搜索和安装合适的 Skill | [vercel-labs/skills](https://github.com/vercel-labs/skills) |
| 📐 [planning-with-files](skills/skills-collected/planning-with-files/SKILL.md) | Manus 风格文件化任务规划，持久化工作记忆 | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) |
| 🪨 [caveman](skills/skills-collected/caveman/SKILL.md) | 山顶洞人模式：Token 用量直降 ~75%，三倍响应速度 | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |
| 🎯 [ui-ux-pro-max](skills/skills-collected/ui-ux-pro-max/SKILL.md) | UI/UX 设计智能体：50+ 风格、161 色板、57 字体组合 | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| 🐎 [ponytail](skills/skills-collected/ponytail/SKILL.md) | 懒人极简工程：只写最少的代码，优先复用/标准库/原生能力 | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 🔍 [ponytail-review](skills/skills-collected/ponytail-review/SKILL.md) | 只审查“过度设计”：删除/替换可简化代码，一行一个发现 | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 📦 [ponytail-audit](skills/skills-collected/ponytail-audit/SKILL.md) | 全仓审计过度工程：按削减收益排序，输出可删减清单 | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 🧾 [ponytail-debt](skills/skills-collected/ponytail-debt/SKILL.md) | 收集 `ponytail:` 注释到技术债台账，防止“以后再说”腐烂 | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 📊 [ponytail-gain](skills/skills-collected/ponytail-gain/SKILL.md) | 展示 ponytail 的量化收益：更少代码、更少依赖、更快交付 | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| ❓ [ponytail-help](skills/skills-collected/ponytail-help/SKILL.md) | 所有 ponytail 模式与命令的快速参考卡 | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 🎤 [grill-me](skills/skills-collected/grill-me/SKILL.md) |  relentless interview：围绕计划/设计追问到双方理解一致 | [mattpocock/skills](https://github.com/mattpocock/skills) |
| 🎙️ [grilling](skills/skills-collected/grilling/SKILL.md) | 底层追问原语：把设计树的分支逐一追问清楚 | [mattpocock/skills](https://github.com/mattpocock/skills) |
| 📄 [grill-with-docs](skills/skills-collected/grill-with-docs/SKILL.md) | 追问并同步产出 ADR + 术语表，打磨共享语言 | [mattpocock/skills](https://github.com/mattpocock/skills) |
| 📋 [to-questionnaire](skills/skills-collected/to-questionnaire/SKILL.md) | 把无法独自回答的决策转为异步问卷 | [mattpocock/skills](https://github.com/mattpocock/skills) |

### 社区收集 · 数字生命卡兹克（skills-collected）

| Skill | 说明 | 来源 |
|---|---|---|
| 🧹 [neat-freak](skills/skills-collected/neat-freak/SKILL.md) | 会话结束后文档与记忆的洁癖级同步 | [khazix-skills](https://github.com/KKKKhazix/khazix-skills) |

### 社区收集 · 小说写作（skills-collected）

| Skill | 说明 | 来源 |
|---|---|---|
| 🔍 [perplexity-improver](skills/skills-collected/perplexity-improver/SKILL.md) | 降低 AI 痕迹，提升文风自然度 | [Claude-Book](https://github.com/ThomasHoussin/Claude-Book) |

### 社区收集 · 产品与规格（skills-collected，新增）

| Skill | 说明 | 来源 |
|---|---|---|
| 🔧 [feature-forge](skills/skills-collected/feature-forge/SKILL.md) | 结构化需求工作坊，产出功能规格/用户故事/EARS/验收标准 | Jeffallan |
| 🔭 [market-insight](skills/skills-collected/market-insight/SKILL.md) | 用户需求洞察与产品机会分析（insight） | 社区收集 |
| 🧭 [plan-orchestrate](skills/skills-collected/plan-orchestrate/SKILL.md) | 将计划文档拆解为步骤并生成 /orchestrate 调用链 | ECC |
| 🧩 [product-capability](skills/skills-collected/product-capability/SKILL.md) | 将 PRD/路线图转为可实施的能力规划（约束/不变量/接口） | ECC |
| 🔍 [product-lens](skills/skills-collected/product-lens/SKILL.md) | 构建前验证"为什么"，对产品方向做压力测试 | ECC |
| ⛏️ [spec-miner](skills/skills-collected/spec-miner/SKILL.md) | 从既有代码库反向提取规格/API/架构文档 | Jeffallan |

---

### 自建 · 代码审查与工作流

| Skill | 说明 | 来源 |
|---|---|---|
| 🔍 [code-review](skills/code-review/SKILL.md) | 多Agent并行代码审查：bug/安全/性能/质量 | 自建 |
| 🔍 [code-review-workflow](skills/code-review-workflow/SKILL.md) | 基于OCR的提交前代码审查工作流 | 自建 |
| 📝 [mr-commit-template](skills/mr-commit-template/SKILL.md) | 提交前MR描述生成+代码评审+提交记录归档 | 自建 |
| 🐙 [github-triage](skills/github-triage/SKILL.md) | GitHub Issue/PR统一处理，并行后台执行 | 自建 |
| 📦 [ocr-installation-guide](skills/ocr-installation-guide/SKILL.md) | OpenCodeReview(OCR)安装配置指南（非审查工具） | 自建 |

### 自建 · Skill 创建与管理

| Skill | 说明 | 来源 |
|---|---|---|
| 🛠️ [create-skill](skills/create-skill/SKILL.md) | Skill创建/改进/评估工具包，支持基准测试 | 自建 |
| 🔍 [skill-lookup](skills/skill-lookup/SKILL.md) | 从prompts.chat注册表搜索安装Skills | 自建 |
| 📐 [constraints-skills-builder](skills/constraints-skills-builder/SKILL.md) | 从源码提取约束生成分层Skills知识体系 | 自建 |

### 自建 · 设计与 UI/UX

| Skill | 说明 | 来源 |
|---|---|---|
| 🎨 [frontend-ui-ux](skills/frontend-ui-ux/SKILL.md) | 设计师转开发角色，无设计稿下的UI/UX设计 | 自建 |
| 🖼️ [ip-as-logo](skills/platform-specific/ip-as-logo/SKILL.md) | 极简IP角色方形图片生成 | 自建 |

### 自建 · 文档处理

| Skill | 说明 | 来源 |
|---|---|---|
| 📝 [docx-simple](skills/docx-simple/SKILL.md) | Word 文档生成与编辑（简化版；完整版见 collected `docx`） | 自建 |

### 自建 · 工程/通用

| Skill | 说明 | 来源 |
|---|---|---|
| 📋 [writing-plans](skills/writing-plans/SKILL.md) | 将任务拆分为 2-5 分钟可执行步骤（源自 Superpowers） | 自建 |
| 📊 [mermaid-to-png](skills/MermaidToPNGSkills/SKILL.md) | Mermaid代码块批量渲染为PNG图片 | 自建 |

### 自建 · 数字生命卡兹克（本地副本）

| Skill | 说明 | 来源 |
|---|---|---|
| 🔭 [hv-analysis](skills/hv-analysis/SKILL.md) | 横纵分析法深度研究，产出万字 PDF 报告 | 自建 |
| ✍️ [khazix-writer](skills/khazix-writer/SKILL.md) | 卡兹克公众号长文写作风格 | 自建 |
| 🔥 [aihot](skills/aihot/SKILL.md) | AI HOT 中文 AI 资讯查询，无需 API Key | 自建 |

### 自建 · 小说/网文写作

| Skill | 说明 | 来源 |
|---|---|---|
| 📖 [story-init](skills/story-init/SKILL.md) | 故事脚手架搭建：圣经、角色/世界观注册表 | 自建 |
| 👤 [character-management](skills/character-management/SKILL.md) | 角色档案：关系、特征、人物弧光、家族树 | 自建 |
| 🌍 [worldbuilding](skills/worldbuilding/SKILL.md) | 世界观构建：魔法/政治/科技/宗教系统 | 自建 |
| 📐 [plot-structure](skills/plot-structure/SKILL.md) | 情节规划（三幕式、英雄之旅、起承转合） | 自建 |
| ✍️ [chapter-writing](skills/chapter-writing/SKILL.md) | 大纲优先的章节写作，自动拉取上下文保持一致 | 自建 |
| 💡 [story-ideator](skills/story-ideator/SKILL.md) | 从宇宙圣经生成原创故事线，不抄袭源材料 | 自建 |
| 🔍 [book-analyzer](skills/book-analyzer/SKILL.md) | 分析已有书籍提取风格指纹、结构模式 | 自建 |
| 📚 [bible-merger](skills/bible-merger/SKILL.md) | 合并多源设定文件为统一的故事圣经 | 自建 |
| 📝 [novel-writer](skills/novel-writer/SKILL.md) | 中文长篇网文写作全流程：选题→章纲→写作→审查 | 自建 |
| 🌐 [webnovel-writing](skills/webnovel-writing/SKILL.md) | 中文网文写作：选题/结构/章纲/节奏/去AI味 | 自建 |

### 自建 · 自媒体写作

| Skill | 说明 | 来源 |
|---|---|---|
| 🍅 [fanqie-novel-writer](skills/fanqie-novel-writer/SKILL.md) | 番茄小说平台写作（推荐算法/广告变现策略） | 自建 |
| 🌸 [fanqie-female-writer](skills/fanqie-female-writer/SKILL.md) | 番茄女频写作（言情/古言/重生复仇/种田） | 自建 |
| 🔥 [fanqie-male-writer](skills/fanqie-male-writer/SKILL.md) | 番茄男频写作（都市重生/玄幻/游戏/科幻/系统） | 自建 |
| 📰 [toutiao-writer](skills/toutiao-writer/SKILL.md) | 今日头条内容创作（标题SMH/开头/四层自检） | 自建 |
| 🤖 [toutiao-ai-education](skills/toutiao-ai-education/SKILL.md) | 今日头条 AI 教育赛道内容创作 | 自建 |
| 💬 [wechat-writer](skills/wechat-writer/SKILL.md) | 微信公众号通用写作（选题/标题/排版/自检） | 自建 |

---

## Agents

`agents/` 收录可复用的 Agent 配置（每个含 `agent.md` + `config.yaml`），并附 `_template` 模板与若干提示词文档。

| Agent / 文档 | 说明 |
|---|---|
| 📁 [_template](agents/_template/) | Agent 模板（agent.md + config.yaml） |
| 🎨 [frontend-designer](agents/frontend-designer/) | 前端设计师 Agent |
| 🌸 [fanqie-female-writer](agents/fanqie-female-writer/) | 番茄女频写手 Agent |
| 🔥 [fanqie-male-writer](agents/fanqie-male-writer/) | 番茄男频写手 Agent |
| 🤖 [toutiao-ai-edu](agents/toutiao-ai-edu/) | 头条 AI 教育创作 Agent |
| 🖤 [暗黑风格UI提示词.md](agents/暗黑风格UI提示词.md) | 暗黑风 UI 提示词 |
| 📐 [Awesome-design-md/DESIGN默认模板.md](agents/Awesome-design-md/DESIGN默认模板.md) | Awesome design.md 默认模板 |

→ 详见 [agents/README.md](agents/README.md)

---

## Workflows

| 文件 | 说明 |
|---|---|
| 📋 [agent-workflow-catalog.md](workflows/agent-workflow-catalog.md) | Agent 工作流目录与说明 |

---

## Prompts

80+ 个高质量提示词，覆盖 9 个方向。复制粘贴到 ChatGPT / Claude / Gemini 等任意对话中即可使用。

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

MCP (Model Context Protocol) 服务器 — 扩展 Agent 的工具能力，连接外部服务和 API。

收录 20 个社区主流 MCP 服务器，每个子目录包含安装命令和 settings.json 配置模板。

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
- [danjdewhurst/story-skills](https://github.com/danjdewhurst/story-skills) — MIT License
- [ThomasHoussin/Claude-Book](https://github.com/ThomasHoussin/Claude-Book) — MIT License
- Jeffallan（feature-forge、spec-miner）— MIT License
- ECC（plan-orchestrate、product-capability、product-lens）— 社区收集
- [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) — Ponytail 极简工程，MIT License
- [mattpocock/skills](https://github.com/mattpocock/skills) — Skills for Real Engineers，MIT License

本仓库仅做聚合整理，各 Skill 版权归原作者所有；自建部分遵循本仓库 `AGENTS.md` 规范。
