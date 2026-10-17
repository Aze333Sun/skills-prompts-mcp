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

---

## 2026-10-12 重复 Skill 清理 + 门禁修复

### 概述

排查出重复 Skills 并全部处理，同时发现并修复门禁脚本的严重缺陷。

### 第一阶段：门禁脚本修复（根本原因）

- **作用域 bug**：`$errors += ...` 在函数内创建局部副本，外层永远读不到 → 门禁恒报 `ALL CHECKS PASSED`（塞入故意非法的测试文件验证确认）。这是 docx 重复能一路绿灯的根因
- **CRLF bug**：`^---` 锚点匹配不到 CRLF 行尾文件 → 全量误报"缺少 frontmatter"
- 新增 **name 唯一性检查**（ERROR 级，重复直接阻断提交）
- 新增 frontmatter 多行块标量（`|` / `>`）解析
- `skills-collected/` 为只读上游副本，跳过格式规范检查（不可修改）

### 第二阶段：重复项处理

| 重复项 | 处理 |
|---|---|
| `skills/docx` vs `skills/skills-collected/docx`（同名 `docx`） | 删除自建精简版，保留官方完整版（含 OOXML 校验器、schema、模板），README 改链 |
| `skills/create-skill` vs `skills/skills-collected/skill-creator` | 删除 Comate 本地化旧版派生（6 个共享文件哈希一致，上游版多 Claude.ai/Cowork 章节和 3 个脚本）；独有增量（存储路径表）并入 README 安装章节 |

### 第三阶段：4 个代码审查 Skill 划清触发边界

物理合并会产出 24KB 巨型 Skill 且二者流程互斥（OCR 自动 vs 手动 Checklist），故改为 description 互斥声明：

- `code-review-workflow`：OCR 已安装的提交流程
- `mr-commit-template`：无 OCR 的手动 Checklist 提交流程
- `code-review`：不带提交流程的独立代码审查
- `opencode-review`：OCR 安装/配置/排错

### 第四阶段：历史遗留 description 修复

门禁修复后暴露 19 个 description 不以 "Use when..." 开头（此前从未被真正检查），全部改写为规范格式并保留原触发词。

### 第五阶段：README 补全

- 补齐 14 个未列出的 Skill（novel-writer / fanqie-* 系列、wechat/toutiao 内容创作、collected 产品类 6 个）
- 新增「内容创作」「产品与需求」分类
- 修正目录结构（`skills-collected/` 实际位于 `skills/` 下）
- 验证：57 个链接全部有效，0 个 Skill 未被引用

### 结果

- ERROR：0（提交不再被阻断）
- WARNING：58 个章节缺失（不阻断，后续可补）
- Skill 总数：59 → 57

## 2026-10-17 分支结构：main 真源 + 内容分发分支

采用方案 A：`main` 保持全量真源不变，新增三个只读分发快照分支（`skills` / `prompts` / `mcp`），供下游按需单分支拉取（如 `git clone -b skills --single-branch`）。

- 新增 `scripts/sync-distribution-branches.ps1`：用 git plumbing（rev-parse / mktree / commit-tree）从 main 生成快照分支，不切工作区、不产生临时提交
- 分发分支结构：`<内容目录>/` + 自动生成的说明 README（标明只读、重建方式、快照基线）
- 修复两个坑：PS5.1 按 ANSI 读无 BOM UTF-8 脚本导致中文乱码（脚本加 BOM）；PowerShell 管道把 `\r` 混入 mktree 行尾导致 README.md 文件名带 `^\r`（改为临时文件 + cmd 重定向）
- 验证：skills 672 文件、prompts 10 文件、mcp 22 文件，根条目干净
