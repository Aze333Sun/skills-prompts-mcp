# Context7 MCP (Upstash)

实时获取最新版本的库文档和代码示例，防止 Claude 使用过时的 API。

**来源**: [@upstash/context7-mcp](https://github.com/upstash/context7) · 48K+ Stars · 240K 周下载

## 安装

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

## settings.json

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "env": {}
    }
  }
}
```

## 环境变量

无需 API Key 即可使用基础功能。高级功能可配置 Context7 API Key。

## 主要能力

- 拉取指定库的最新文档（支持版本锁定）
- 代码示例搜索
- 消除 AI 使用废弃 API 的问题
- 支持 npm、PyPI、Go 等主流生态
