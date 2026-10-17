# Desktop Commander MCP

「上帝模式」——终端全权限 + 进程管理 + ripgrep 搜索。

**来源**: [@wonderwhy-er/DesktopCommanderMCP](https://github.com/wonderwhy-er/DesktopCommanderMCP) · 4.4K+ Stars

## 安装

```bash
claude mcp add desktop-commander -- npx -y @wonderwhy-er/DesktopCommanderMCP
```

## settings.json

```json
{
  "mcpServers": {
    "desktop-commander": {
      "command": "npx",
      "args": ["-y", "@wonderwhy-er/DesktopCommanderMCP"],
      "env": {}
    }
  }
}
```

## 安全提示

- 此 MCP 提供完整的终端访问权限，谨慎使用
- 建议仅在本地开发环境配置
- 审查 Claude 执行的所有命令

## 主要能力

- 完整终端命令执行
- 进程管理（启动/停止/监控）
- ripgrep 高效文件搜索
- 文件系统批量操作
- 脚本自动化执行
