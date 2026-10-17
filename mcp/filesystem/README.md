# Filesystem MCP (Official)

安全的本地文件系统读写操作，限定在指定目录范围内。

**来源**: [@modelcontextprotocol/server-filesystem](https://github.com/modelcontextprotocol/servers)

## 安装

```bash
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/dir
```

## settings.json

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/projects"],
      "env": {}
    }
  }
}
```

## 安全提示

- **不要** 将目录范围设为 `$HOME`，会暴露 SSH 密钥和 `.env` 文件
- 确保使用 `>= 2025.7.1` 版本（修复 CVE-2025-53109/53110）
- 建议按项目分别配置，最小化权限范围

## 主要能力

- 读取/写入/搜索文件
- 目录列表和遍历
- 批量文件操作
