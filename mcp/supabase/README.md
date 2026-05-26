# Supabase MCP

Postgres + Auth + Storage + Edge Functions 一站式后端管理，完全感知 Row Level Security。

**来源**: [@supabase/mcp-server-supabase](https://github.com/supabase-community/mcp-server-supabase)

## 安装

```bash
claude mcp add supabase -- npx -y @supabase/mcp-server-supabase
```

## settings.json

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server-supabase"],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "<your-supabase-access-token>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `SUPABASE_ACCESS_TOKEN` | Supabase Personal Access Token |

## 主要能力

- 数据库表结构管理与查询
- Auth 用户管理
- Storage 文件管理
- Edge Functions 部署与调试
- RLS 策略感知
