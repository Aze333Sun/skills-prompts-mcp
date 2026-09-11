---
name: code-review-workflow
description: "Use when committing code, creating PRs, or performing pre-commit code reviews. Integrates OCR automated review with MR description generation and commit record archiving."
effort: high
---

# 基于 OCR 的提交前代码审查工作流

将 OpenCodeReview（OCR）集成到提交前审查流程，替代手动 Checklist，实现自动化代码审查 + MR 描述生成 + 提交记录归档。

## When to Use

- 用户说「提交」「commit」「提 MR」「合并请求」「push」等提交意图
- 准备执行 `git commit`、`git push`、`gh pr create` 等提交类命令之前
- 用户要求「提交前审查」「commit review」「pre-commit review」
- 用户明确提到「MR 描述」「提交说明」

## 硬约束（必须遵守）

1. **审查先行**：代码审查必须在填写 MR 描述之前完成，审查结论作为 MR 描述的输入。
2. **OCR 优先**：环境中已安装 OCR 时必须使用 OCR 审查，不得回退到手动 Checklist。
3. **审查范围 = 提交范围**：OCR 审查的文件范围必须与本次提交范围一致，不得审查无关文件。
4. **结果回填**：OCR 输出的审查结论必须逐条回填到 MR 描述的评审结果中，不得摘要概括。
5. **阻断规则**：OCR 输出 blocking 级问题时，默认阻断提交，修复后重新审查。
6. **禁止覆盖**：提交记录文件不得覆盖已有记录，当日重复提交按序号递增。
7. **git add 精确**：只 `git add` 明确的文件路径，禁止 `git add -A` / `git add .`。

## 执行流程

### 步骤 1：环境检查

```bash
ocr version        # 确认 OCR 已安装
git --version      # 确认 Git >= 2.41
```

OCR 未安装时告知用户，提供安装命令后停止：

```bash
npm install -g @alibaba-group/open-code-review
```

### 步骤 2：收集事实与圈定范围

```bash
git status
git diff --staged    # 已暂存
git diff             # 未暂存
git log --oneline -5 # 近期提交风格
git config user.name # 提交者
```

列出工作区改动文件清单，请用户确认哪些纳入本次提交，**不得默认全量纳入**。

### 步骤 3：OCR 代码审查

按圈定范围执行审查：

```bash
# 方式一：工作区模式（审查所有变更）
ocr review

# 方式二：指定文件（委托模式，无需 OCR API key）
ocr delegate rule <文件路径列表>

# 方式三：输出到文件（推荐）
ocr review --format json --output /tmp/ocr-result.json
```

审查完成后解析 OCR 输出：

- **blocking** 级问题 → 必须修复，阻断提交
- **suggestion** 级问题 → 随 MR 描述公示，不阻断
- **nit** 级问题 → 记录即可

### 步骤 4：填写 MR 描述模板

根据 OCR 审查结果 + diff 内容填写：

```markdown
## 变更背景
（关联需求/缺陷号：#XXXX，为什么改）

## 变更内容
- 改动模块：
- 核心逻辑：
- 影响范围（调用方清单）：

## AI 使用情况
- [ ] 未使用 AI
- [ ] [AI-assisted] 工具：___ 提示词摘要：___
- [ ] [AI-generated] 工具：___ 提示词摘要：___

## 代码审查结果（OCR）
- 审查工具：OpenCodeReview
- 审查模式：{ocr review / ocr delegate}
- blocking 问题：{N} 个
- suggestion 问题：{N} 个
- nit 问题：{N} 个

### 详细审查意见
| 文件 | 行号 | 级别 | 问题描述 | 修复建议 |
|------|------|------|----------|----------|

## 自检清单
- [ ] 已逐行阅读并理解全部改动
- [ ] OCR 审查 blocking 问题已全部修复
- [ ] 公共方法/接口/数据结构变更已列出全部调用方
- [ ] 无硬编码密钥/配置
- [ ] 本地已通过流水线同套命令验证
- [ ] 单 MR 规模 ≤ 400 行（超出请说明原因）

## 验证方式
（如何验证：步骤、环境、预期结果）

## 回滚方案
（出问题时如何恢复）
```

### 步骤 5：追问缺项

盘点必填信息（变更类型、需求号、验证方式、回滚方案），缺失项一次性集中追问。

### 步骤 6：输出确认

输出完整 MR 描述 + OCR 审查结果汇总，等待用户确认或修正。

### 步骤 7：生成提交记录文件

MR 描述确认后、git commit 之前，生成提交记录文件：

- **目录**：`提交记录/`（不存在则创建）
- **命名**：`{类型}_{提交者}_{YYYYMMDD}_{序号}.md`
- **文件内容**：MR 描述全文 + OCR 审查明细

```markdown
# 提交记录：{一句话标题}

| 项 | 内容 |
| --- | --- |
| 提交者 | {git user.name} |
| 日期 | {YYYY-MM-DD} |
| 变更类型 | 需求 / 缺陷 / 其他 |
| 关联编号 | #XXXX 或 无 |
| 变更规模 | {N 个文件，+x -y 行} |
| OCR 审查 | blocking: {N} / suggestion: {N} / nit: {N} |

## MR 描述
（模板填写全文）

## OCR 审查结果
（完整审查意见）
```

### 步骤 8：执行提交

按用户选择的方式提交：

**方式一：AI 代提**

```bash
git add <明确路径>    # 逐文件添加，禁止 -A
git commit -m "..."
```

**方式二：用户自提**

输出提交指引（文件清单 + commit message），用户在 IDE 中操作。

提交后校验提交记录文件是否入库。

## 与 mr-commit-template 的关系

| 维度 | mr-commit-template | code-review-workflow |
|------|-------------------|---------------------|
| 代码审查 | 手动 Checklist（14 项） | OCR 自动审查 |
| 审查深度 | AI 自己核查 | OCR Agent 读全文、搜代码库、关联上下文 |
| 规则集 | 自建通用 + AI 专项 | OCR 内置多语言规则集（NPE/SQL注入/XSS等） |
| Token 消耗 | 高 | 低（约 1/9） |
| 适用场景 | 无 OCR 环境 | 已安装 OCR 的环境 |
| MR 模板 | 相同 | 相同 |
| 提交记录 | 相同 | 相同 |

## Quick Reference

| 操作 | 命令/说明 |
|------|----------|
| 环境检查 | `ocr version` + `git --version` |
| 收集事实 | `git status` + `git diff --staged` + `git log --oneline -5` |
| OCR 审查 | `ocr review` 或 `ocr delegate rule <files>` |
| 问题分级 | blocking（阻断）/ suggestion（公示）/ nit（记录） |
| MR 模板 | 变更背景 → 变更内容 → AI使用情况 → 代码审查结果 → 自检清单 |
| 提交记录 | `提交记录/{类型}_{提交者}_{YYYYMMDD}_{序号}.md` |

## Common Mistakes

- ❌ OCR 未安装时回退到手动 Checklist → ✅ 必须安装 OCR 后再执行
- ❌ 审查范围与提交范围不一致 → ✅ 审查范围 = 提交范围
- ❌ 使用 `git add -A` 或 `git add .` → ✅ 逐文件精确添加
- ❌ 跳过 OCR 审查直接填写 MR 描述 → ✅ 审查先行，结论作为 MR 描述输入

## 安装方式

将 `code-review-workflow/` 复制到目标仓库的 skills 目录（如 `.trae/skills/`、`.claude/skills/`、`.opencode/skills/`）。

依赖：OCR 已安装且可执行（`ocr version` 正常输出）。
