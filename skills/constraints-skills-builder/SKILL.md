---
name: constraints-skills-builder
description: "Use when extracting development constraints from project source code and documentation to generate layered Skills knowledge system, establishing AI development standards for new projects, or evaluating whether a project is suitable for Skills knowledge system."
effort: high
---

# Constraints Skills Builder：从源码提炼开发约束并生成分层 Skills

将任意项目的隐性开发规范（源码模式、文档约定）转化为 AI 可执行的分层约束体系。产出物为一套"基础索引 + CORE 常驻约束 + DETAILED 按需规范 + 审查 Prompt"的知识体系，供后续 AI 开发按规范生成代码。

## When to Use

- 用户要求为某个项目沉淀开发规范
- 提取项目约束
- 建立 AI 开发约束体系
- 评估项目能否复用 Skills 知识体系

## 硬约束（必须遵守）

1. **约束优先**：先定义"不能做什么"（禁止事项），再定义"应该怎么做"（代码模板）。
2. **分层加载**：CORE Skills 常驻（合计 ≤15KB），DETAILED Skills 按需加载（每个 1-2KB）。禁止把所有规范一次性塞进上下文。
3. **一个项目只维护一套体系**：多套并存会导致规则冲突和审查混乱。发现已有体系时先询问用户是更新还是新建。
4. **只沉淀反复出现的模式**：一次性写法不提取；违反会导致故障的才标强制（mandatory），其余标建议（recommended）。
5. **不编造约束**：自动检测未覆盖、文档未写明的业务语义约束，一律标 `[待确认]` 交用户定稿，禁止凭推测填充。
6. **规则聚焦架构与约束**：不规定缩进风格之类的过细规则，细节留给开发者。

## 工作流

### 步骤 0：确认输入

向用户确认：目标项目路径（必需）、知识体系输出路径（默认 `<项目路径>/docs/skills-layered`）。项目路径不存在或无源码时停止并说明。

### 步骤 1：适配性评估

对照以下 5 项清单评估（详见 `references/methodology.md` 第 1 节）：

- 有明确的架构分层（Controller/Service/DAO 或等价物）
- 有统一的返回格式规范
- 有数据源/多租户需求
- 有外部系统集成
- 有明确的异常处理规范

评分：5 项全有=高度适配（可直接复用方法论 80%+）；3-4 项=中度适配（需调整约 50%）；1-2 项=低度适配（建议只沉淀最小 Core Skills）；0 项=不适用。低度及以下必须告知用户评估结果，由用户决定是否继续。

### 步骤 2：自动分析与约束提取

脚本为 bash，Windows 上需 Git Bash / WSL 环境：

```bash
bash scripts/analyze-project.sh <项目路径> <输出路径>/analysis
bash scripts/extract-constraints.sh <项目路径> <输出路径>/constraints <输出路径>/analysis [语言]
```

- analyze 输出 10 类分析文件（语言、依赖、目录、实体、数据源、外部系统、返回格式、异常、测试等）。
- extract 完成 9 项检测（语言/构建工具、框架/数据库、架构分层、统一返回、异常体系、数据访问、编码规范信号、安全扫描、部署形态），输出 7 份约束清单 + `detected-facts.env`（机器可读事实）。
- 逐份审阅约束清单，处理全部 `[待确认]` 条目：能从源码核实的直接核实（如读统一返回类源码确认成功/失败码），不能核实的保留标注交用户定稿。安全扫描发现的硬编码敏感信息必须单独向用户报告。

### 步骤 3：生成分层 Skills 体系

1. 在项目根创建 `skills-config.json`（字段见 `references/methodology.md` 第 3 节）。
2. 运行：

```bash
bash scripts/generate-skills.sh <项目路径> <项目路径>/skills-config.json <输出路径>/constraints
# 第 3 个参数为 detected-facts.env 所在目录（即 extract 输出的 constraints 目录）
# Skills 文件的实际输出路径由 skills-config.json 的 outputPath 字段指定
```

脚本按检测事实动态生成 Core/Detailed Skills、`SKILL_CORE_README.md` 与 `README.md`——只生成检测到对应特性的文件，不生成空壳。

3. 自动生成的只是骨架（4 个基础项）。**领域 Detailed Skills 需按 `assets/detailed-skill-template.md` 人工 + AI 补充**，数量按复杂度定：简单项目 4-8 个、中等 8-15 个、复杂企业级 15-25 个（清单见 `references/methodology.md` 第 4 节）。
4. 生成基础索引：按 `assets/index-template.md` 创建 `INDEX.md`（含任务映射表）与 `GLOSSARY.md`。
5. 回填全部 `[待确认]` 条目后，全库搜索确认无 `[待确认]` 残留再交付。

### 步骤 4：生成审查 Prompt

按 `assets/review-prompt-template.md` 填充项目信息与审查规则，保存为 `review-prompt.md`。强制规则必须 100% 通过，建议规则不通过可放行但需记录。

### 步骤 5：验证与交付

1. 运行源码健康度基线检查（检查项目结构、返回格式、日志、异常处理、敏感信息等）：

```bash
bash scripts/check-compliance.sh <项目路径> <语言>
```

> **注意**：此脚本检查的是源码本身是否符合基本规范，而非"是否符合生成的 Skills 规范"。Skills 合规性审查由步骤 4 生成的 `review-prompt.md` 配合 AI 完成。

2. 抽样自检：按新生成的 Skills 模拟生成一段典型代码（如一个 Controller 或一个接口），对照 Detailed Skills 的验证检查清单逐条核验，确认约束可执行、无歧义。
3. 向用户交付：知识体系目录结构、文件清单、`[待确认]` 遗留清单（如有）、后续维护建议（更新触发条件见 `references/methodology.md` 第 6 节）。

## 常见陷阱

- ❌ 一开始就编写 20+ 个 Detailed Skills / 全部扩展图谱 → ✅ 按需创建，遇到问题再补充
- ❌ 把 Core 和 Detailed 混在一起全量加载 → ✅ 严格分层，CORE 常驻、DETAILED 按需
- ❌ 规则不允许任何例外、过于细节 → ✅ 聚焦架构与约束
- ❌ 创建后不再维护 → ✅ 交付时说明更新触发条件与版本规则

## Quick Reference

| 步骤 | 操作 |
|------|------|
| 确认输入 | 项目路径 + 输出路径 |
| 适配性评估 | 5项清单评分（高度/中度/低度/不适用） |
| 自动分析 | `analyze-project.sh` + `extract-constraints.sh` |
| 生成Skills | `generate-skills.sh` + 人工补充Detailed Skills |
| 审查Prompt | `review-prompt.md` 生成 |
| 验证交付 | `check-compliance.sh` + 抽样自检 |

## Common Mistakes

- ❌ 一次性生成所有Skills → ✅ 按需创建，遇到问题再补充
- ❌ Core和Detailed混在一起 → ✅ 严格分层，CORE常驻、DETAILED按需
- ❌ 规则过于细节 → ✅ 聚焦架构与约束，细节留给开发者
- ❌ 不维护 → ✅ 交付时说明更新触发条件
