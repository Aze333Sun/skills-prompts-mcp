# Postgres MCP Pro (Crystal DBA)

工业级 PostgreSQL 数据库管理——Schema 智能分析、索引优化、EXPLAIN 解读。

**来源**: [@crystaldba/postgres-mcp-pro](https://github.com/crystaldba/postgres-mcp-pro) · MIT License

## 安装

```bash
claude mcp add postgres-pro -- npx -y @crystaldba/postgres-mcp-pro
```

## settings.json

```json
{
  "mcpServers": {
    "postgres-pro": {
      "command": "npx",
      "args": ["-y", "@crystaldba/postgres-mcp-pro"],
      "env": {
        "DATABASE_URL": "postgresql://user:password@localhost:5432/dbname"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `DATABASE_URL` | PostgreSQL 连接字符串（建议使用只读用户） |

## 安全提示

- 生产环境务必使用只读数据库用户
- 写入操作前让 Claude 确认 SQL 语句
- 替代 Anthropic 已归档的旧版 Postgres MCP

## 主要能力

- Schema 探索与 ER 关系分析
- SQL 查询、EXPLAIN 分析与索引建议
- 数据调试与样本提取
