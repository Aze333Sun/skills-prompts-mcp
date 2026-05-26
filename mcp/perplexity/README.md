# Perplexity MCP

基于引用的深度网页研究——每次回答附带真实来源链接。

**来源**: [Perplexity MCP](https://docs.perplexity.ai/guides/mcp-server) · Perplexity 官方

## 安装

```bash
claude mcp add perplexity -- npx -y @perplexity-ai/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@perplexity-ai/mcp"],
      "env": {
        "PERPLEXITY_API_KEY": "<your-perplexity-api-key>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `PERPLEXITY_API_KEY` | Perplexity API Key |

## 主要能力

- 带引用的深度研究搜索
- Sonar / Sonar Pro 模型选择
- 实时信息查询
- 学术和技术问题研究
- 每次回答附带来源 URL
