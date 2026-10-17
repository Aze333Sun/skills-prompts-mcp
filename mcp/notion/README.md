# Notion MCP (Official)

语义搜索 Notion 工作区——将 Claude 连接到你的公司 Wiki 和文档库。

**来源**: [@notionhq/notion-mcp-server](https://github.com/notionhq/notion-mcp-server) · Notion 官方

## 安装

```bash
claude mcp add notion -- npx -y @notionhq/notion-mcp-server
```

## settings.json

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": {
        "NOTION_API_KEY": "<your-notion-integration-token>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `NOTION_API_KEY` | Notion Integration Token（需在 Notion 中创建 Integration 并授权对应页面） |

## 主要能力

- 语义搜索 Notion 页面和数据库
- 读取页面内容和数据库条目
- 创建和更新页面
- 管理评论
