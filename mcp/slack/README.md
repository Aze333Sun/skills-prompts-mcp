# Slack MCP (Official)

将 Slack 变成可搜索的知识库——频道历史、线程摘要、消息发送。

**来源**: [@slack/mcp](https://github.com/slack/mcp) · Slack 官方

## 安装

```bash
claude mcp add slack -- npx -y @slack/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@slack/mcp"],
      "env": {
        "SLACK_BOT_TOKEN": "<your-slack-bot-token>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `SLACK_BOT_TOKEN` | Slack Bot User OAuth Token（需 `channels:history`、`chat:write` 等权限） |

## 主要能力

- 频道消息历史搜索
- 线程摘要生成
- 发送消息到指定频道
- 用户信息查询
