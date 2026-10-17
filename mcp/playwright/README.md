# Playwright MCP (Microsoft)

多浏览器自动化测试，通过无障碍树（Accessibility Tree）操作，比截图模式更快更可靠。

**来源**: [@playwright/mcp](https://github.com/microsoft/playwright-mcp) · Microsoft + Anthropic 联合维护

## 安装

```bash
claude mcp add playwright -- npx -y @playwright/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp"],
      "env": {}
    }
  }
}
```

## 主要能力

- Chromium / Firefox / WebKit 三浏览器支持
- 页面导航、点击、填表、截图
- 端到端测试自动化
- 网页抓取和数据提取
- 无障碍树结构操作（比 DOM 快 3-5x）
