# SubAgent 调度模板

本文件定义主 Agent 构建 SubAgent query 的标准模板。主 Agent 只需按模板填入路径和 diff 命令，**不预读** agents/*.md 或 references/*.md 的内容。

## Query 构建模板

```
你是代码审查专家，负责【维度名称】审查。

1. 读取审查指令：<skill绝对路径>/agents/<维度>-reviewer.md
2. 读取输出格式：<skill绝对路径>/references/output-schema.md
3. 执行以下命令获取待审变更：
   <git diff 命令>
4. 根据审查指令完成审查，使用 read_file 读取变更文件上下文（±30 行），用 grep_content/codebase_search 搜索调用链和已有实现
5. 严格按输出格式返回 JSON。未发现问题时返回空 findings 数组

补充上下文：<与本次变更相关的业务规则摘要（如有，1-2 句话；无则省略此行）>
```

> **关键原则**：主 Agent 不预读 agents/*.md 和 references/*.md 的内容再注入 query。只需告知路径，SubAgent 有 read_file 能力，会自行加载。这大幅减少主 Agent 的准备工作和输出 token。

---

## 常规审查模式

发起一个 `delegate_subagent` 调用：

```
delegate_subagent(
  agent_type="Explore",
  description="Code review - 综合审查",
  query="""
你是代码审查专家，负责对当前变更进行综合审查（正确性、可靠性、风格、复用、自定义规则）。

1. 依次读取以下指令文件，理解各维度的审查要点：
   - {SKILL_DIR}/agents/correctness-reviewer.md
   - {SKILL_DIR}/agents/reliability-reviewer.md
   - {SKILL_DIR}/agents/style-reviewer.md
   - {SKILL_DIR}/agents/reuse-reviewer.md
   - {SKILL_DIR}/agents/custom-reviewer.md
2. 读取输出格式：{SKILL_DIR}/references/output-schema.md
3. 执行命令获取变更：{git diff 命令}
4. 审查覆盖度要求：
   - **风格维度（style）**：必须严格按 style-reviewer.md 的指令逐条扫描所有规则，不得遗漏任何一条。有规则文件时，必须输出规则覆盖确认表后再输出 JSON
   - **其他维度（正确性、可靠性、复用、自定义规则）**：各关注最核心的 2-3 个检查点完成审查
   - 自定义规则维度须严格按 custom-reviewer.md 指令加载仓库根目录 .code-review/rules/（兼容 .comate/custom-rules/）与用户级全局目录 ~/.code-review/rules/（兼容 ~/.comate/custom-rules/）下的规则文件，仅在存在有效规则文件时上报问题
5. 仅输出有证据的问题，不报纯风格偏好。未发现问题返回空 findings

{业务规则摘要（如有）}
"""
)
```

---

## 深度审查模式

在**同一轮响应**中，并行发起 5 个 `delegate_subagent`。主 Agent **不需要预读**任何 agents/*.md 或 references/*.md 文件，直接按模板构建 query：

```
1. delegate_subagent(
     agent_type="Explore",
     description="Code review - 复用审查",
     query="你是代码审查专家，负责复用审查。\n1. 读取审查指令：{SKILL_DIR}/agents/reuse-reviewer.md\n2. 读取输出格式：{SKILL_DIR}/references/output-schema.md\n3. 执行：{git diff 命令}\n4. 完成审查并返回 JSON\n{业务规则摘要}"
   )

2. delegate_subagent(
     agent_type="Explore",
     description="Code review - 风格审查",
     query="你是代码审查专家，负责风格审查。\n1. 读取审查指令：{SKILL_DIR}/agents/style-reviewer.md\n2. 读取输出格式：{SKILL_DIR}/references/output-schema.md\n3. 执行：{git diff 命令}\n4. 完成审查并返回 JSON\n{业务规则摘要}"
   )

3. delegate_subagent(
     agent_type="Explore",
     description="Code review - 可靠性审查",
     query="你是代码审查专家，负责可靠性审查（资源管理、并发安全、接口鉴权）。\n1. 读取审查指令：{SKILL_DIR}/agents/reliability-reviewer.md\n2. 读取输出格式：{SKILL_DIR}/references/output-schema.md\n3. 执行：{git diff 命令}\n4. 完成审查并返回 JSON\n{业务规则摘要}"
   )

4. delegate_subagent(
     agent_type="Explore",
     description="Code review - 正确性审查",
     query="你是代码审查专家，负责正确性审查。\n1. 读取审查指令：{SKILL_DIR}/agents/correctness-reviewer.md\n2. 读取输出格式：{SKILL_DIR}/references/output-schema.md\n3. 执行：{git diff 命令}\n4. 完成审查并返回 JSON\n{业务规则摘要}"
   )

5. delegate_subagent(
     agent_type="Explore",
     description="Code review - 自定义规则审查",
      query="你是代码审查专家，负责自定义规则审查。\n1. 读取审查指令：{SKILL_DIR}/agents/custom-reviewer.md\n2. 读取输出格式：{SKILL_DIR}/references/output-schema.md\n3. 执行：{git diff 命令}\n4. 按指令加载仓库根目录 .code-review/rules/（兼容 .comate/custom-rules/）与用户级全局目录 ~/.code-review/rules/（兼容 ~/.comate/custom-rules/）下的规则文件，若无有效规则文件则返回空 findings\n5. 完成审查并返回 JSON\n{业务规则摘要}"
   )
```

---

## Meta-Review 调用

当深度审查至少成功返回 2 个维度结果时，发起 Meta-Review：

```
delegate_subagent(
  agent_type="Explore",
  description="Code review - Meta Review",
  query="""
你是 Meta-Reviewer，负责审查其他 Agent 的 review 结果质量。

1. 读取审查指令：{SKILL_DIR}/agents/meta-reviewer.md
2. 读取输出格式：{SKILL_DIR}/references/output-schema.md（Meta-Reviewer 输出格式部分）
3. 执行：{git diff 命令}（用于验证 findings 的准确性）
4. 以下是待审的 findings JSON：

{所有 SubAgent 返回的 findings JSON}

按指令完成 Meta-Review，返回 actions 和 missed_findings。
"""
)
```

> 注意：Meta-Review 的 query 中**必须包含已有的 findings 结果（JSON）**，因为 Meta-Reviewer 需要这些内容来判断质量。这是唯一需要在 query 中传递较多内容的 SubAgent 调用。

---

## 超大变更处理

超大变更时，主 Agent 按以下规则拆分：

- **style SubAgent**：必须传入全部变更文件的 diff 命令，不做文件裁剪
- **correctness SubAgent**：query 中明确标注"[Critical] 规则必须扫描全部文件"，非 Critical 规则可按风险优先级抽样高风险文件
- **reliability / reuse SubAgent**：可按文件组拆分，优先审查高风险部分
- 每个 SubAgent 的 query 中需注明实际审查范围，便于报告标注覆盖情况

## 失败回退

- 某个 `delegate_subagent` 失败或超时：继续合并剩余结果，报告中注明"部分维度降级"
- 三个及以上失败：回退为单个综合审查（常规审查模式）
- `delegate_subagent` 工具不可用：主 Agent 直接执行审查，报告中注明"降级为单 Agent 审查"
- 上下文过大：缩小到高风险文件，必要时拆批执行
