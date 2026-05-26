# Chrome DevTools MCP

实时查看浏览器 Console、Network 请求和 Performance 面板，实现「实现 → 验证 → 修复」的自主闭环。

**来源**: [@chrome-devtools/mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp)

## 安装

```bash
claude mcp add chrome-devtools -- npx -y @chrome-devtools/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@chrome-devtools/mcp"],
      "env": {}
    }
  }
}
```

## 主要能力

- Console 日志实时查看与过滤
- Network 请求监控与性能分析
- DOM 检查与操作
- Performance Profiler 集成
- 前端 Bug 的快速定位与修复验证
