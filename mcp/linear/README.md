# Linear MCP

高速度团队的项目管理——Issue 追踪、Sprint 周期、项目更新。

**来源**: [@linear/mcp](https://github.com/linear/linear-mcp) · Linear 官方

## 安装

```bash
claude mcp add linear -- npx -y @linear/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@linear/mcp"],
      "env": {
        "LINEAR_API_KEY": "<your-linear-api-key>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `LINEAR_API_KEY` | Linear Personal API Key |

## 主要能力

- 创建/搜索/更新 Issues
- 管理 Sprint Cycles
- 项目状态更新
- 团队工作负载查看
