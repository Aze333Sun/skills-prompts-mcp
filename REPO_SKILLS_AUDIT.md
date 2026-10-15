# Skills 合规审核报告

> 生成时间：2026-09-11  
> 审核范围：`skills/**/SKILL.md` 全部 **59** 个  
> 审核标准：[AGENTS.md](AGENTS.md) 门禁规范（等效 `validate-skills.ps1`）+ 结构/重复扩展项  
> 说明：collected 为只读社区收集，仅标注不修改。

## 1. 总览

| 指标 | 数值 |
|---|---|
| SKILL.md 总数 | 59 |
| 自建（非 collected） | 32 |
| collected（只读） | 27 |
| 完全合规（全部为自建） | **32** |
| 存在违规 | 27 |
| 　├ 自建·须整改 | **0** |
| 　└ collected·规范差异（预期，不整改） | 27 |
| 重复 name（跨文件） | 0 组 |

**关键口径**：collected 为社区原样拉取（遵循 agentskills.io 标准），其 `description` 多为描述性语句（"Use when" 在句中而非句首）、章节命名不同，不符合本仓库 `AGENTS.md` 自定的"句首 Use when + 三章节"规范是**预期的**，属规范适用范围问题，**不计入需整改**。下文将两类分开统计。

## 2. 违规规则分布（仅自建·须整改 0 个）

无需整改。

> collected 27 个同样触发上述规则（MISSING_CHAPTER / DESC_NOT_USE_WHEN / DESC_TOO_LONG），因只读且为社区标准，不计入整改。

## 3. 自建·须整改清单（0 个）

无。自建 Skill 全部合规。

## 4. collected·规范差异清单（27 个，只读-预期不整改）

`brainstorming`, `brand-guidelines`, `caveman`, `docx`, `feature-forge`, `find-skills`, `frontend-design`, `insight`, `mcp-builder`, `neat-freak`, `pdf`, `perplexity-improver`, `plan-orchestrate`, `planning-with-files`, `pptx`, `product-capability`, `product-lens`, `requesting-code-review`, `skill-creator`, `spec-miner`, `systematic-debugging`, `test-driven-development`, `ui-ux-pro-max`, `using-git-worktrees`, `verification-before-completion`, `webapp-testing`, `xlsx`

> 此批均为社区标准、只读，不建议在库内修改；完整违规明细见 `audit_skills.py` 原始输出。

## 5. 重复 / 冲突 name

无重复 name。

## 6. 结论与建议

- **真问题**：自建 32 个中 **0 个不合规**（合规率 100%）。
- **规范冲突（治理缺陷）**：`AGENTS.md` 门禁规范与社区 agentskills.io 标准不兼容——collected 27 个全部不符合本仓库自定格式。建议明确「门禁规范仅约束自建 Skills」，并在 `validate-skills.ps1` 中排除 `skills-collected/`。
- **自动化**：保留 `audit_skills.py`，纳入定期/提交前门禁重跑。

---
*本报告由 `audit_skills.py` 自动生成，仅扫描不修改。*