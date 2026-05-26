# Sentry MCP

拉取实时错误堆栈、关联 Release 版本、建议修复方案——不用离开编辑器。

**来源**: [@sentry/mcp](https://github.com/getsentry/sentry-mcp) · Sentry 官方

## 安装

```bash
claude mcp add sentry -- npx -y @sentry/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "sentry": {
      "command": "npx",
      "args": ["-y", "@sentry/mcp"],
      "env": {
        "SENTRY_AUTH_TOKEN": "<your-sentry-auth-token>",
        "SENTRY_ORG": "<your-org-slug>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `SENTRY_AUTH_TOKEN` | Sentry Auth Token |
| `SENTRY_ORG` | Sentry 组织 Slug |

## 主要能力

- 读取错误详情和堆栈跟踪
- 关联 Release 版本定位问题引入点
- 分析错误频率和影响范围
- AI 辅助修复建议
