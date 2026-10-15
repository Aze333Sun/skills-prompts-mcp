# Skills & Prompts 导航索引

按"我想做什么"快速定位该用的工具——Skill 优先，Prompt 作为补充。

---

## 写代码

### 审查代码
- **推荐** → Skill: `code-review`（多 Agent 并行审查）
- 提交前审查 → Skill: `code-review-workflow`（集成 OCR 自动化审查）
- 手动模板 → Prompt: [代码审查与重构.md](<E:\project\skills-prompts-mcp\prompts\代码审查与重构.md>)

### 调试排错
- **推荐** → Skill: `systematic-debugging`（根因优先的系统性调试）
- 专项场景模板 → Prompt: [调试与排错.md](<E:\project\skills-prompts-mcp\prompts\调试与排错.md>)

### 前端开发
- 界面实现推荐 → Skill: `frontend-ui-ux` / `ui-ux-pro-max` / `frontend-design`
- 工程化/安全/测试等模板 → Prompt: [前端开发.md](<E:\project\skills-prompts-mcp\prompts\前端开发.md>)

### 后端开发
- API 设计/数据库/微服务等模板 → Prompt: [后端开发.md](<E:\project\skills-prompts-mcp\prompts\后端开发.md>)

### AI / LLM 开发
- Prompt 工程/RAG/Agent 设计等模板 → Prompt: [AI开发.md](<E:\project\skills-prompts-mcp\prompts\AI开发.md>)

### 测试驱动开发
- Skill: `test-driven-development`（先写测试再写代码）

---

## 数据处理

### 数据分析与 SQL
- 查询生成/慢查询/数据清洗等模板 → Prompt: [数据分析与SQL.md](<E:\project\skills-prompts-mcp\prompts\数据分析与SQL.md>)

### Excel / 表格处理
- Skill: `xlsx`（Excel/CSV 全场景处理）

---

## 写文档

### Word 文档
- **推荐** → Skill: `docx-simple`（创建/编辑 .docx）
- 高级功能 → Skill: `docx`（表格/图片/目录等）
- Markdown 转 Word → Skill: `markdownToWord`
- 文档内容模板 → Prompt: [文档写作.md](<E:\project\skills-prompts-mcp\prompts\文档写作.md>)

### PPT 演示文稿
- Skill: `pptx`（创建/编辑 .pptx）

### PDF 处理
- Skill: `pdf`（创建/合并/拆分/水印/表单）

### 深度研究报告
- **推荐** → Skill: `hv-analysis`（横纵分析法，产出排版 PDF 报告）
- 原模板已升级为索引 → Prompt: [横纵分析法.md](<E:\project\skills-prompts-mcp\prompts\横纵分析法.md>)

---

## 运维部署

### DevOps / CI/CD
- Dockerfile/CI Pipeline/K8s 等模板 → Prompt: [DevOps.md](<E:\project\skills-prompts-mcp\prompts\DevOps.md>)

---

## 内容创作

### 网文小说
- 番茄小说 → `fanqie-novel-writer`（通用）/ `fanqie-male-writer`（男频）/ `fanqie-female-writer`（女频）
- 通用网文 → `novel-writer` / `webnovel-writing`
- 故事初始化 → `story-init`（创建项目结构）
- 角色管理 → `character-management`
- 情节结构 → `plot-structure`
- 世界观构建 → `worldbuilding`
- 章节写作 → `chapter-writing`
- 故事创意 → `story-ideator`
- 书籍分析 → `book-analyzer` / `bible-merger`

### 公众号/自媒体
- 微信公众号 → `wechat-writer`
- 今日头条 → `toutiao-writer` / `toutiao-ai-education`
- 公众号长文（卡兹克风格） → `khazix-writer`

---

## 工具与效率

### GitHub 管理
- Issue/PR 批量处理 → `github-triage`
- 提交模板与记录 → `mr-commit-template`

### Skill 管理
- 搜索已安装 Skill → `skill-lookup`
- 创建新 Skill → `create-skill`

### 项目开发约束
- 提取项目规范 → `constraints-skills-builder`

### Git 工作树
- `using-git-worktrees`（多分支并行开发）

### AI 热点新闻
- `aihot`（AI/LLM 行业日报）

### 设计参考
- 暗黑风 UI 配色规范 → Prompt: [暗黑风格UI提示词.md](<E:\project\skills-prompts-mcp\prompts\暗黑风格UI提示词.md>)
- 前端设计规范模板（DESIGN.md） → Prompt: [DESIGN默认模板.md](<E:\project\skills-prompts-mcp\prompts\DESIGN默认模板.md>)

---

## 社区 Skills（collected）

以下为 `skills-collected/` 目录中的社区贡献 Skill，保持原样，如需定制请创建独立自建 Skill。

| Skill | 用途 |
|-------|------|
| `brainstorming` | 头脑风暴与创意生成 |
| `brand-guidelines` | 品牌视觉规范应用 |
| `caveman` | 代码简化与复杂度降低 |
| `feature-forge` | 功能规格与设计文档 |
| `find-skills` | Skill 搜索与发现 |
| `market-insight` | 市场洞察分析 |
| `mcp-builder` | MCP 服务器构建 |
| `neat-freak` | 代码整洁度检查 |
| `perplexity-improver` | 查询优化与澄清 |
| `plan-orchestrate` | 多步骤任务编排 |
| `planning-with-files` | 基于文件的任务规划 |
| `product-capability` | 产品能力建模 |
| `product-lens` | 产品视角分析 |
| `requesting-code-review` | 按需代码审查调度 |
| `skill-creator` | 社区 Skill 创建器 |
| `spec-miner` | 从代码提取规格 |
| `test-driven-development` | TDD 测试驱动开发 |
| `ui-ux-pro-max` | 前端 UI 设计资产库 |
| `verification-before-completion` | 完成前自验证 |
| `webapp-testing` | Web 应用测试 |
| `ponytail` 系列 | 技术债务管理（audit/debt/gain/help/review） |
| `grill-me` / `grilling` / `grill-with-docs` | 代码问答与审查 |
| `to-questionnaire` | 内容转问卷 |
| `frontend-design` | 高质量前端界面设计（避免 AI 套路化美学） |
| `systematic-debugging` | 根因优先的系统性调试 |
| `using-git-worktrees` | 多分支并行开发 Git 工作树 |
| `ponytail` | 极简工程：技术债务管理（纯入口，配合 audit/debt/gain/help/review） |

---

## 使用原则

1. **Skill 优先**：同一场景有 Skill 时优先用 Skill（自动化程度更高）
2. **Prompt 补充**：Skill 未覆盖的专项场景用 Prompt 模板
3. **同名冲突**：自建 Skill 与 collected 同名时，自建版加了后缀（如 `docx-simple` vs `docx`），按需选择