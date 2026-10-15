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

## agents 与 skills 的关系

- **Skill** 是 AI 可调用的能力入口（定义在 `skills/` 目录下），面向用户
- **Agent** 是同名 Skill 背后的子代理 Playbook（定义在 `agents/` 目录下），面向系统
- **规则**：禁止只在 `agents/` 放定义而不在 `skills/` 申明入口；每个 agent 必须有对应的 skill

## 当前 Agent 列表

| Agent | 对应 Skill | 说明 |
|-------|-----------|------|
| [_template](_template/) | — | Agent 模板 |
| [frontend-designer](frontend-designer/) | frontend-ui-ux | 前端设计师 Agent |
| [fanqie-female-writer](fanqie-female-writer/) | fanqie-female-writer | 番茄女频写手 Agent |
| [fanqie-male-writer](fanqie-male-writer/) | fanqie-male-writer | 番茄男频写手 Agent |
| [toutiao-ai-edu](toutiao-ai-edu/) | toutiao-ai-education | 头条 AI 教育创作 Agent |

> 注意：`暗黑风格UI提示词.md` 和 `Awesome-design-md/DESIGN默认模板.md` 已迁移至 `prompts/` 目录，它们不是 Agent 定义，不应放在此处。