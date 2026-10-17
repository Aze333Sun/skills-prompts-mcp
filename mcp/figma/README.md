# Figma Dev Mode MCP

从 Figma 设计稿直接拉取设计 Token、组件和变量，实现 Design-to-Code。

**来源**: [figma-developer-mcp](https://github.com/figma/figma-developer-mcp) · 9.9K+ Stars

## 安装

```bash
claude mcp add figma -- npx -y figma-developer-mcp
```

## settings.json

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "<your-figma-token>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `FIGMA_ACCESS_TOKEN` | Figma Personal Access Token（需 Dev/Full 席位） |

## 主要能力

- 读取 Figma 设计稿中的颜色、字体、间距等 Design Tokens
- 提取组件结构和变体
- 自动生成 React / Tailwind 代码
- 支持 Figma Dev Mode 注释和规格
