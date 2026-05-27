# Agents

子代理文件夹。每个子代理一个独立子文件夹，包含其 Playbook 定义和配置。

## 目录结构

```
agents/
  <agent-name>/
    agent.md     — 子代理 Prompt / Playbook 定义
    config.yaml  — 子代理运行配置（模型、工具、参数等）
```

## 约定

- 文件夹名使用 kebab-case（如 `code-reviewer`）
- `agent.md` 为子代理的系统指令 / 行为定义
- `config.yaml` 为运行时配置
