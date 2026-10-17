# Memory MCP

跨会话知识图谱——为 Claude 提供持久化的记忆系统。

**来源**: [@modelcontextprotocol/server-memory](https://github.com/modelcontextprotocol/servers) · Anthropic

## 安装

```bash
claude mcp add memory -- npx -y @modelcontextprotocol/server-memory
```

## settings.json

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {}
    }
  }
}
```

## 主要能力

- 跨会话知识图谱存储
- 实体和关系管理
- 自动记忆检索与注入
- 知识冲突检测
- 纯本地存储，数据不会外传
