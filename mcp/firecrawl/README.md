# Firecrawl MCP

网页抓取与爬虫——将任意网页转换为 LLM 可用的 Markdown 格式。

**来源**: [firecrawl-mcp](https://github.com/firecrawl/firecrawl-mcp) · 11.3K+ Stars

## 安装

```bash
claude mcp add firecrawl -- npx -y firecrawl-mcp
```

## settings.json

```json
{
  "mcpServers": {
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "<your-firecrawl-api-key>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `FIRECRAWL_API_KEY` | Firecrawl API Key（免费额度：500 credits/月） |

## 主要能力

- 单页抓取转 Markdown
- 全站爬虫（支持深度控制）
- JavaScript 渲染页面支持
- 结构化数据提取（LLM-extract）
- 搜索结果抓取
