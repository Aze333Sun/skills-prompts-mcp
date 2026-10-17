# Brave Search MCP

通过 Brave Search API 进行实时网页搜索，用于事实核查和竞品研究。

**来源**: [@modelcontextprotocol/server-brave-search](https://github.com/modelcontextprotocol/servers) · Anthropic

## 安装

```bash
claude mcp add brave-search -- npx -y @modelcontextprotocol/server-brave-search
```

## settings.json

```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "<your-brave-api-key>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `BRAVE_API_KEY` | Brave Search API Key（免费额度：2,000 queries/月） |

## 主要能力

- 实时网页搜索
- 新闻搜索
- 图片/视频搜索
- 安全搜索过滤
