# GitHub MCP (Official)

管理 GitHub 仓库、Issues、PRs、Actions 和代码搜索——让 Claude 直接参与你的开发工作流。

**来源**: [@modelcontextprotocol/server-github](https://github.com/modelcontextprotocol/servers)

## 安装

```bash
claude mcp add github -- npx -y @modelcontextprotocol/server-github
```

## settings.json

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-github-token>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `GITHUB_PERSONAL_ACCESS_TOKEN` | GitHub Personal Access Token（需 `repo`、`read:org` 权限） |

## 主要能力

- 创建/搜索/管理 Issues 和 Pull Requests
- 代码搜索与仓库浏览
- 查看 CI/CD 状态
- 管理 Release 和 Tag
