---
name: opencode-review
description: "Use when installing, configuring, or troubleshooting OpenCodeReview (OCR) itself — npm install, provider/model config, delegation mode, rule files, or 'ocr: command not found'. For using OCR inside a commit flow use code-review-workflow; for reviewing code without commit flow use code-review."
effort: medium
---

# OpenCodeReview 集成指南

将阿里开源的 [OpenCodeReview](https://github.com/alibaba/open-code-review)（OCR）集成到 AI 编码助手，提供行级精准的代码审查能力。

## When to Use

- 用户要求「审查代码」「code review」「检查代码质量」
- 用户要求安装或配置 OCR
- 用户提到「OCR」「opencode review」「阿里代码审查」
- 准备提交/合并前用户要求做代码审查

## 硬约束（必须遵守）

1. **先验证环境**：调用 OCR 前必须确认 `git --version` ≥ 2.41 且 `ocr` 命令可用。
2. **审查范围明确**：每次审查必须明确范围（工作区 / 分支对比 / 单 commit），不得在无范围情况下执行审查。
3. **结果结构化**：OCR 输出必须解析为结构化结果（文件:行号:问题:级别），不得只输出原始文本。
4. **委托模式优先**：在 AI Agent 环境中优先使用 delegation mode（OCR 负责文件选择和规则，Agent 用自己的 LLM 审查），无需额外配置 API key。
5. **不编造审查意见**：所有审查结论必须来自 OCR 输出或 Agent 基于代码的真实分析，禁止凭推测生成。

## OCR 简介

OpenCodeReview 是阿里集团内部官方 AI 代码审查助手，过去两年服务数万开发者，识别百万级代码缺陷。核心特性：

- 读取 Git diff，生成行级精准的结构化审查意见
- 内置多语言规则集（NPE、线程安全、XSS、SQL 注入等）
- Agent 可读取完整文件、搜索代码库、检查关联文件获取上下文
- 支持 delegation mode：AI Agent 用自己的 LLM 跑审查，无需 OCR API key
- 支持 CI/CD 集成（GitHub Actions / GitLab CI / Gerrit）

## 安装

### 前置条件

- Git >= 2.41
- Node.js（npm 安装方式需要）

### 安装方式

```bash
# NPM（推荐）
npm install -g @alibaba-group/open-code-review

# 验证安装
ocr version
```

其他安装方式参考：[安装指南](https://open-codereview.ai/docs/installation)

## 配置

### 方式一：交互式配置（推荐）

```bash
ocr config provider   # 选择供应商（OpenAI / Anthropic / 自定义）
ocr config model      # 选择模型
```

### 方式二：环境变量

```bash
# OpenAI 兼容
export OCR_LLM_URL=https://api.openai.com/v1/chat/completions
export OCR_LLM_TOKEN=your-api-key
export OCR_LLM_MODEL=gpt-4o

# Anthropic
export OCR_LLM_URL=https://api.anthropic.com/v1/messages
export OCR_LLM_TOKEN=your-api-key
export OCR_LLM_MODEL=claude-sonnet-4-20250514
export OCR_USE_ANTHROPIC=true
```

### 方式三：委托模式（AI Agent 首选）

无需配置 LLM。OCR 负责文件选择和规则解析，审查由 AI Agent 自己的 LLM 执行：

```bash
ocr delegate preview                    # 预览待审查文件
ocr delegate rule src/main.go           # 指定文件生成审查规则
```

配置存储在 `~/.opencodereview/config.json`。

## 审查命令

### 工作区模式（审查所有变更）

```bash
cd your-project
ocr review
```

### 分支对比模式

```bash
ocr review --from main --to feature-branch
```

### 单个 Commit

```bash
ocr review --commit abc123
```

### 全量文件扫描（无需 git 历史）

```bash
ocr scan                        # 扫描整个仓库
ocr scan --path internal/agent  # 扫描指定目录
```

### 输出到文件

```bash
ocr review --format json --output result.json
```

### 恢复中断的审查

```bash
ocr session list
ocr review --resume <session-id>
```

## Agent 集成方式

### 作为 Skill 安装

```bash
npx skills add alibaba/open-code-review --skill open-code-review
```

### 作为 Claude Code Plugin

```
/plugin marketplace add alibaba/open-code-review
/plugin install open-code-review@open-code-review
```

### OpenCode 原生集成

安装原生 review 工具和斜杠命令，详见 [OpenCode 插件文档](https://github.com/alibaba/open-code-review/tree/main/plugins/open-code-review/opencode)。

## 审查规则

OCR 内置多语言规则集，可通过配置文件自定义：

- **项目级**：`<项目>/.opencodereview/rule.json`
- **用户级**：`~/.opencodereview/rule.json`
- **CLI 覆盖**：`--rule` 参数指定规则文件

规则优先级：CLI > 项目级 > 用户级。

详细规则定制参考：[评审规则文档](https://open-codereview.ai/docs/review-rules)

## 与其他工具对比

| 维度 | OCR | 通用 Agent + Skills | 人工审查 |
|------|-----|---------------------|---------|
| 审查精度 | 高（确定性工程 + Agent 混合） | 中（纯语言驱动，位置可能漂移） | 高 |
| Token 消耗 | 低（约 1/9） | 高 | 无 |
| 覆盖完整性 | 高（精准文件筛选，不遗漏） | 中（变更大时可能偷懒） | 取决于审查者 |
| 速度 | 快 | 慢 | 慢 |
| 可定制性 | 高（规则文件 + Agent 扩展） | 高（Prompt 驱动） | 高 |
| 适用场景 | CI/CD、日常提交审查 | 灵活场景 | 关键决策 |

## 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| `ocr: command not found` | 未安装或未加入 PATH | 重新安装或检查 PATH |
| Git 版本过低 | Git < 2.41 | 升级 Git |
| 审查结果为空 | 无 diff 变更 | 确认有暂存/未暂存的改动 |
| LLM 连接失败 | API key 或 URL 配置错误 | `ocr config provider` 重新配置 |
| 中文审查质量差 | 模型对中文支持弱 | 换用 Claude / GPT-4o 等多语言模型 |

## 参考链接

- GitHub：https://github.com/alibaba/open-code-review
- 官方文档：https://open-codereview.ai/docs
- AACR-Bench 数据集：https://huggingface.co/datasets/Alibaba-Aone/aacr-bench

## Quick Reference

| 操作 | 命令 |
|------|------|
| 安装 | `npm install -g @alibaba-group/open-code-review` |
| 验证 | `ocr version` |
| 配置 | `ocr config provider` + `ocr config model` |
| 工作区审查 | `ocr review` |
| 分支对比 | `ocr review --from main --to feature-branch` |
| 委托模式 | `ocr delegate rule <files>` |

## Common Mistakes

- ❌ 未验证环境就调用OCR → ✅ 先确认`ocr version`和`git --version`
- ❌ 审查范围不明确 → ✅ 每次审查必须明确范围
- ❌ 只输出原始文本 → ✅ 必须解析为结构化结果
- ❌ 不使用委托模式 → ✅ AI Agent环境优先用delegation mode
