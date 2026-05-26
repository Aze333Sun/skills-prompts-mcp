# Git MCP

完整的 Git 操作——仓库管理、差异查看、分支操作、提交历史。

**来源**: [idosal/git-mcp](https://github.com/idosal/git-mcp) · 6K+ Stars

## 安装

```bash
claude mcp add git -- npx -y idosal/git-mcp
```

## settings.json

```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "idosal/git-mcp"],
      "env": {}
    }
  }
}
```

## 主要能力

- Git 状态查看与差异对比
- 分支创建、切换、合并
- 提交历史浏览与搜索
- Stash 管理
- Blame 追溯
- Tag 管理
