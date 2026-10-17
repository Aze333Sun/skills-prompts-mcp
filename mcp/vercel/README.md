# Vercel MCP

管理 Vercel 部署——创建项目、环境变量、监控生产与预览部署。

**来源**: [@vercel/mcp](https://github.com/vercel/vercel-mcp) · Vercel 官方

## 安装

```bash
claude mcp add vercel -- npx -y @vercel/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "vercel": {
      "command": "npx",
      "args": ["-y", "@vercel/mcp"],
      "env": {
        "VERCEL_API_TOKEN": "<your-vercel-token>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `VERCEL_API_TOKEN` | Vercel API Token（在 Vercel Dashboard → Settings → Tokens 创建） |

## 主要能力

- 创建和管理 Vercel 项目
- 环境变量配置
- 部署状态监控
- 生产 vs 预览部署对比
- 域名和 DNS 管理
- Next.js 项目深度集成
