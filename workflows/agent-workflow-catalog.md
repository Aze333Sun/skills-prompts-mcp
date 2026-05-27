# Agent 工作流清单

> 收录全网已验证的 Agent 工作流模式，涵盖 Anthropic 官方模式、社区实践模式和本仓库 Skill 可编排的实战流水线。
> 更新日期：2025-07

---

## 一、Anthropic 官方六大基础模式

来源：[Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) (Dec 2024)

### 1. Prompt Chaining（提示链）

```
Step 1 → Gate? → Step 2 → Gate? → Step 3 → Output
```

**原理**：将任务分解为固定顺序的子任务，每步的输出作为下一步的输入。可在步骤间插入程序化检查（gate）。

**适用场景**：
- 营销文案生成 → 翻译成其他语言
- 写大纲 → 检查大纲 → 按大纲写正文
- 需求分析 → 技术方案 → 代码实现

**本仓库 Skill 链示例**：
```
brainstorming → writing-plans → chapter-writing → verification-before-completion
```

### 2. Routing（路由分发）

```
Input → Classifier → Route A (专用处理器)
                   → Route B (专用处理器)
                   → Route C (专用处理器)
```

**原理**：根据输入类型分发到不同的专用处理器，实现关注点分离。

**适用场景**：
- 客服：退款请求 / 技术问题 / 一般咨询 → 不同处理流程
- 简单问题用小模型、复杂问题用大模型
- 不同内容类型用不同写作 skill

**本仓库映射**：
```
用户输入 → 路由判断 →
  ├── 网文写作 → novel-writer / fanqie-novel-writer
  ├── 公众号写作 → wechat-writer / khazix-writer
  ├── 头条写作 → toutiao-writer / toutiao-ai-education
  └── 技术开发 → brainstorming → writing-plans → TDD
```

### 3. Parallelization（并行化）

```
                    ┌→ Worker A (子任务) ─┐
Input → Splitter ──┼→ Worker B (子任务) ─┼→ Aggregator → Output
                    └→ Worker C (子任务) ─┘
```

**两种变体**：
- **Sectioning（分段）**：独立子任务并行执行后聚合
- **Voting（投票）**：同一任务多次运行，取最佳/多数结果

**适用场景**：
- 代码审查：多个审查视角并行 → 聚合结果
- 内容安全检查：内容审查 + 核心响应并行
- Evals 自动化评测

### 4. Orchestrator-Workers（编排-工作者）

```
Input → Orchestrator → 动态分解任务 → Worker A ┐
                      → 动态分解任务 → Worker B ├→ Orchestrator 合成 → Output
                      → 动态分解任务 → Worker C ┘
```

**与 Parallelization 的区别**：子任务不是预定义的，而是由 Orchestrator 根据具体输入动态决定。

**适用场景**：
- 复杂代码改动（涉及多个文件，改动范围不可预知）
- 多源信息搜索与综合分析
- 本仓库 Subagent 模式

**本仓库映射**：
```
主 Agent (Orchestrator)
  ├── subagent: frontend-designer
  ├── subagent: fanqie-female-writer
  ├── subagent: fanqie-male-writer
  └── subagent: toutiao-ai-edu
```

### 5. Evaluator-Optimizer（评估-优化循环）

```
Generator → Output → Evaluator → 通过? → Final Output
    ↑                      ↓ 不通过
    └────── Feedback ──────┘
```

**原理**：一个 LLM 生成，另一个 LLM 评估并反馈，循环迭代直到满意。

**适用场景**：
- 文学翻译（评估捕捉细微差别）
- 复杂搜索（多轮搜索分析）
- 代码生成 + 审查迭代

**本仓库映射**：
```
chapter-writing → consistency_review → 不通过 → 修复 → 再审查
requesting-code-review → code-reviewer → 修改建议 → 代码改进 → 再审
```

### 6. Autonomous Agent（自主 Agent）

```
Human Input → Agent → Plan → Tool Use → Environment Feedback → ... → Checkpoint → Human → ... → Output
              ↑                                                        ↓
              └──────────── 自主循环（基于环境反馈） ──────────────────┘
```

**原理**：LLM 自主规划、使用工具、根据环境反馈调整，在检查点暂停等待人类确认。

**适用场景**：
- SWE-bench 自动修 Bug
- Computer Use 操控电脑
- 长时间自主任务

---

## 二、多 Agent 编排模式

### 7. Supervisor（监督者模式）

```
Supervisor Agent
  ├── Agent A (执行) → 汇报
  ├── Agent B (执行) → 汇报
  └── Agent C (执行) → 汇报
Supervisor 决策下一步 → 循环直到完成
```

**核心**：一个监督者 Agent 管理多个执行 Agent，根据汇报动态决策下一步调度谁。

**框架支持**：LangGraph Supervisor、CrewAI

**适用场景**：
- 复杂项目（多角色协作）
- 多步骤任务需要动态决策

### 8. Hierarchical（层级委派）

```
Level 1: Strategic Agent（战略层）
  ├── Level 2: Manager Agent A（管理层）
  │     ├── Level 3: Worker Agent A1
  │     └── Level 3: Worker Agent A2
  └── Level 2: Manager Agent B（管理层）
        ├── Level 3: Worker Agent B1
        └── Level 3: Worker Agent B2
```

**核心**：树状委派结构，上层分解任务、下层执行。信息自下而上汇总。

**适用场景**：
- 企业级多项目并行
- 大规模系统重构

### 9. Swarm / Collaborative（群体协作）

```
Agent A ←→ Agent B
  ↕         ↕
Agent C ←→ Agent D
```

**核心**：平级 Agent 之间直接通信协作，无中心调度者。基于 OpenAI Swarm 框架。

**适用场景**：
- 头脑风暴（多视角同时贡献）
- 多方谈判模拟
- 分布式决策

### 10. Sequential Handoff（接力传递）

```
Agent A →输出→ Agent B →输出→ Agent C →输出→ Output
```

**核心**：每个 Agent 完成自己的阶段后，将完整上下文传递给下一个。类似 Prompt Chaining，但每个阶段是不同的 Agent（有独立 prompt/工具）。

**本仓库映射**：
```
story-init → character-management → worldbuilding → plot-structure → chapter-writing
```

### 11. Debate / Deliberation（辩论审议）

```
Agent A (正方) ──→
                    ├→ Judge Agent → 裁决 → Output
Agent B (反方) ──→
```

**核心**：多个 Agent 从不同立场论证，由一个裁判 Agent 综合判断。

**适用场景**：
- 重大决策风险评估
- 技术方案选型
- 内容审核（多视角）

---

## 三、软件工程研发流水线

### 12. Full-Stack Development Pipeline（全栈开发流水线）

```
需求分析 ──→ 方案设计 ──→ 分步实施 ──→ 代码审查 ──→ 测试 ──→ 部署
   │            │           │           │          │        │
   v            v           v           v          v        v
brain-     writing-     TDD +      requesting systematic  deploy
storming   plans        implement  -code-     -debugging  scripts
                                     review
```

**完整链路**：
1. **Brainstorming** → 澄清需求、输出设计 spec
2. **Writing Plans** → 将 spec 分解为可执行计划
3. **TDD** → 先写测试、再写实现
4. **Code Review** → 提交前自动审查
5. **Systematic Debugging** → 测试失败时定位根因
6. **Verification** → 完成前最终验证

**本仓库 Skill 链**：
```
brainstorming → writing-plans → test-driven-development → requesting-code-review → systematic-debugging → verification-before-completion
```

### 13. Bug Fix Pipeline（修 Bug 流水线）

```
Bug Report → Reproduce → Root Cause → Fix → Test → Verify → Deploy
                │            │          │      │       │
                v            v          v      v       v
            systematic-  root-cause-  TDD   test     verification
            debugging    tracing
```

### 14. Feature Development Pipeline（功能开发流水线）

```
Feature Request → Spec Mining → Design Review → Plan → Implement → Review → Ship
                       │               │          │        │         │
                       v               v          v        v         v
                   spec-miner     brainstorming  plan-   TDD +     review +
                                               orchestrate review   deploy
```

### 15. Code Review Pipeline（代码审查流水线）

```
PR Opened → Auto Review → Human-like Feedback → Fix → Re-review → Merge
                │                │                │        │
                v                v                v        v
          requesting-code-  skill-creator    implement  requesting-code-
          review/analyzer   /comparator      fixes      review/grader
```

---

## 四、内容创作流水线

### 16. 网文创作全流程（本仓库核心）

```
选题构思 ──→ 人设搭建 ──→ 世界观 ──→ 情节规划 ──→ 逐章写作 ──→ 审查 ──→ 去AI味 ──→ 发布
   │            │           │          │           │          │        │
   v            v           v          v           v          v        v
novel-     character-  world-     plot-      chapter-   consistency anti_ai
writer     management  building   structure  writing    _review     _voice
```

**番茄平台分支**：
```
fanqie-novel-writer → fanqie-female-writer（女频）
                    → fanqie-male-writer（男频）
```

### 17. 公众号爆文创作流水线

```
热点选题 ──→ 素材收集 ──→ 大纲 ──→ 初稿 ──→ 标题优化 ──→ 排版 ──→ 多平台分发
   │            │          │        │          │          │          │
   v            v          v        v          v          v          v
wechat-     web_search  writing-  wechat-   wechat-    wechat-    toutiao-
writer                  plans     writer    writer     writer     writer
```

### 18. 多平台分发流水线

```
一稿多平台适配：
核心文章（wechat-writer）
  ├──→ 公众号版本（长文 + 排版）
  ├──→ 头条版本（标题重写 + 节奏调整 toutiao-writer）
  ├──→ 小红书版本（缩短 + 种草语气）
  └──→ 知乎版本（深度扩展 + 引用）
```

---

## 五、数据分析与调研流水线

### 19. Deep Research Pipeline（深度调研）

```
问题定义 → 广度搜索 → 深度阅读 → 交叉验证 → 综合报告
    │          │          │          │          │
    v          v          v          v          v
planning-  web_search  web_fetch  web_search  write
with-files (并行N次)  (并行N篇)  (补充搜索)  report
```

### 20. Market Analysis Pipeline（市场分析）

```
行业定义 → 竞品收集 → 能力对比 → 机会发现 → 策略建议
    │          │          │          │          │
    v          v          v          v          v
market-   web_search  product-    product-    write
insight   + scrape    capability  lens        report
```

---

## 六、知识管理流水线

### 21. Knowledge Sync Pipeline（知识同步）

```
代码变更 → 文档检查 → 记忆更新 → 索引同步 → 交叉验证
    │          │          │          │          │
    v          v          v          v          v
git diff   neat-freak  记忆系统   CLAUDE.md  docs/
                              README.md
```

### 22. Skill Creation Pipeline（技能创建）

```
需求分析 → 设计 Skill → 编写 SKILL.md → 评测 → 打包发布
    │           │            │           │        │
    v           v            v           v        v
find-skills  skill-      write_file  skill-    package_
             creator                  creator   skill.py
             /analyzer               /grader
```

---

## 七、决策框架

### 23. 何时用工作流 vs 何时用 Agent

| 场景 | 推荐模式 | 原因 |
|------|---------|------|
| 步骤固定、可预知 | Prompt Chaining / Workflow | 确定性高、成本低 |
| 需要动态决策 | Orchestrator-Workers | 灵活性 |
| 多视角提升信心 | Parallel-Voting | 冗余校验 |
| 需迭代优化 | Evaluator-Optimizer | 反馈循环 |
| 开放问题、不可预知步数 | Autonomous Agent | 自主规划 |
| 多角色协作 | Supervisor / Hierarchical | 分工明确 |

### 24. 复杂度决策树

```
你的任务适合单次 LLM 调用吗？
  ├── 是 → 用基础 prompt，不要加工作流
  └── 否 → 能分解为固定步骤吗？
            ├── 是 → Prompt Chaining
            └── 否 → 需要多个专业视角吗？
                      ├── 是 → Routing 或 Parallel
                      └── 否 → 需要动态决策吗？
                                ├── 是 → Orchestrator-Workers 或 Agent
                                └── 否 → Evaluator-Optimizer
```

---

## 八、框架速查

| 框架 | 核心模式 | 适合场景 |
|------|---------|---------|
| **LangGraph** | State Graph, Supervisor, Hierarchical | 复杂状态管理 |
| **CrewAI** | Role-based, Sequential, Hierarchical | 角色扮演协作 |
| **OpenAI Swarm** | Lightweight handoff, Routines | 轻量多 Agent |
| **AutoGen** | Conversation-driven, Group Chat | 对话式协作 |
| **Anthropic Agent SDK** | Subagent delegation, Tool use | 代码 Agent |
| **Claude Code** | Skill Chain, Subagent | IDE 内开发 |

---

## 九、本仓库 Skill 链路索引

### 软件开发链
```
brainstorming → writing-plans → test-driven-development → systematic-debugging → requesting-code-review → verification-before-completion
```

### 网文创作链
```
novel-writer → [fanqie-novel-writer] → [fanqie-female-writer / fanqie-male-writer]
story-init → character-management → worldbuilding → plot-structure → chapter-writing → chinese-webnovel（深度诊断）
```

### 内容创作链
```
[路由: 公众号/头条/AI教育] → wechat-writer / toutiao-writer / toutiao-ai-education / khazix-writer
```

### 知识管理链
```
neat-freak → verification-before-completion → planning-with-files
```

### 文档处理链
```
pdf / docx / pptx / xlsx → webapp-testing（如需前端展示）
```

### UI 开发链
```
brainstorming → frontend-design / ui-ux-pro-max → writing-plans → TDD
```

---

> **附录**：每个工作流都可以根据实际需求组合、裁剪。成功的关键不是构建最复杂的系统，而是构建最适合需求的系统。从简单开始，只在简单方案不够时增加复杂度。
