# MCP 服务器目录

MCP (Model Context Protocol) 服务器——扩展 Claude Code 的工具能力，连接外部服务和 API。

> 收录社区 Top 20 最受欢迎的 MCP 服务器，每个子目录包含安装命令和 settings.json 配置模板。

---

## 目录

### 开发工具

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 1 | [GitHub](github/) | 仓库管理、Issues/PRs、代码搜索 | [@modelcontextprotocol/server-github](https://github.com/modelcontextprotocol/servers) |
| 2 | [Filesystem](filesystem/) | 安全的本地文件读写 | [@modelcontextprotocol/server-filesystem](https://github.com/modelcontextprotocol/servers) |
| 3 | [Git](git/) | Git 仓库操作与历史浏览 | [idosal/git-mcp](https://github.com/idosal/git-mcp) |

### 浏览器与测试

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 4 | [Playwright](playwright/) | 多浏览器自动化测试 | [@playwright/mcp](https://github.com/microsoft/playwright-mcp) |
| 5 | [Chrome DevTools](chrome-devtools/) | 实时 Console/Network/Performance | [@chrome-devtools/mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) |

### 设计

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 6 | [Figma](figma/) | 设计稿 → 代码，提取 Design Tokens | [figma-developer-mcp](https://github.com/figma/figma-developer-mcp) |

### 文档与搜索

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 7 | [Context7](context7/) | 实时最新库文档，防止过期 API | [@upstash/context7-mcp](https://github.com/upstash/context7) |
| 8 | [Brave Search](brave-search/) | 实时网页搜索与事实核查 | [@modelcontextprotocol/server-brave-search](https://github.com/modelcontextprotocol/servers) |
| 9 | [Firecrawl](firecrawl/) | 网页抓取与爬虫转 Markdown | [firecrawl-mcp](https://github.com/firecrawl/firecrawl-mcp) |
| 10 | [Perplexity](perplexity/) | 带引用的深度网页研究 | [Perplexity MCP](https://docs.perplexity.ai/guides/mcp-server) |

### 数据库

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 11 | [Postgres Pro](postgres-pro/) | PostgreSQL Schema 分析 + 索引优化 | [@crystaldba/postgres-mcp-pro](https://github.com/crystaldba/postgres-mcp-pro) |
| 12 | [Supabase](supabase/) | Postgres + Auth + Storage + Edge | [@supabase/mcp-server-supabase](https://github.com/supabase-community/mcp-server-supabase) |

### 支付与业务

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 13 | [Stripe](stripe/) | 支付、订阅、争议管理 | [@stripe/mcp](https://github.com/stripe/mcp) |

### 沟通与协作

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 14 | [Slack](slack/) | 频道消息搜索与摘要 | [@slack/mcp](https://github.com/slack/mcp) |
| 15 | [Notion](notion/) | 语义搜索公司 Wiki 和文档 | [@notionhq/notion-mcp-server](https://github.com/notionhq/notion-mcp-server) |
| 16 | [Linear](linear/) | Issue 追踪与 Sprint 管理 | [@linear/mcp](https://github.com/linear/linear-mcp) |

### 部署与监控

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 17 | [Vercel](vercel/) | 项目管理、部署、环境变量 | [@vercel/mcp](https://github.com/vercel/vercel-mcp) |
| 18 | [Sentry](sentry/) | 实时错误堆栈与修复建议 | [@sentry/mcp](https://github.com/getsentry/sentry-mcp) |

### 系统与记忆

| # | MCP 服务器 | 一句话 | 来源 |
|---|---|---|---|
| 19 | [Desktop Commander](desktop-commander/) | 终端全权限 + 进程管理 | [@wonderwhy-er/DesktopCommanderMCP](https://github.com/wonderwhy-er/DesktopCommanderMCP) |
| 20 | [Memory](memory/) | 跨会话知识图谱持久化 | [@modelcontextprotocol/server-memory](https://github.com/modelcontextprotocol/servers) |

---

## 快速安装

每个 MCP 服务器的详细配置见对应子目录。以下是最推荐的「核心五件套」：

```bash
# GitHub — Issues/PRs/代码
claude mcp add github -- npx -y @modelcontextprotocol/server-github

# Context7 — 实时文档
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest

# Figma — 设计稿转代码（可选）
claude mcp add figma -- npx -y figma-developer-mcp

# Chrome DevTools — 前端调试
claude mcp add chrome-devtools -- npx -y @chrome-devtools/mcp

# 数据库（选一个）
claude mcp add postgres-pro -- npx -y @crystaldba/postgres-mcp-pro
```

---

## 安全提示

- **不要**一次性安装超过 4-5 个 MCP 服务器——会严重消耗上下文窗口
- **不要**将 Filesystem MCP 范围设为 `$HOME`
- 生产数据库使用**只读**用户
- 定期更新 MCP 服务器版本
- Anthropic 已弃用旧版 Postgres、Slack、Brave Search 参考服务器，请使用以上替代版本

---

## 致谢

所有 MCP 服务器均来自各自作者的贡献。本仓库仅提供配置文档与安装指南。
