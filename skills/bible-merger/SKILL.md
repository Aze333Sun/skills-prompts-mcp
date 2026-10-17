---
name: bible-merger
description: "Use when merging multiple book analyses into a unified bible after analyzing several books from a series, to consolidate characters, style patterns, and structure into a single canonical reference."
---

# Bible Merger

Consolidate multiple book analyses into one canonical bible.

## Quick Start

```bash
# Merge all analyses
Merge analysis/output/*/ into bible/
```

## When to Use

After analyzing multiple books from the same series or author. The merger:
- Identifies consistent patterns (→ rules)
- Tracks character evolution
- Extracts the author's true voice

## Merge Process

### 1. Inventory sources
List all `analysis/output/*/` directories to merge.

### 2. Merge style
Compare `style.md` across all sources:
- **Keep**: patterns appearing in ALL books
- **Range**: metrics with variation (use min-max range)
- **Flag**: book-specific vocabulary (note but don't enforce)
- **Pick**: best reference excerpts from each

### 3. Merge characters folder
For each character appearing in multiple books:
- **Core traits**: keep only if demonstrated in ALL appearances
- **Evolution**: note changes across books
- **Speech**: merge dialogue examples, identify constants
- **Relationships**: note any evolution

For single-book characters:
- Include if significant
- Mark as "source: [book]"

### 4. Merge structure
Identify the formula:
- Chapter length range across all books
- Consistent act structure
- Patterns appearing in every book

### 5. Merge universe folder
- **Recurring locations**: full treatment, consolidate descriptions
- **Book-specific locations**: include with source note
- **Contradictions**: later books take precedence

## Conflict Resolution

| Conflict Type | Resolution |
|--------------|------------|
| Style patterns | Prefer most common |
| Character traits | Prefer shown-in-action over told |
| Facts | Prefer later books |
| All conflicts | Document: "Sources vary: book-1 says X, book-3 says Y" |

## Output

### Merge report
Generate `analysis/merge-report.md`:
```markdown
# Merge Report

## Sources
- [Book 1]: [path]
- [Book 2]: [path]

## Consistency Analysis
- Highly consistent: [list]
- Some variation: [list]  
- Book-specific: [list]

## Character Coverage
- [Character]: appears in [X/Y] books

## Conflicts Resolved
- [Description]: chose [resolution]
```

### Merged bible
Complete `bible/` directory with consolidated files.

## Output Language
French (for content)
English (for report and metadata)

## Quick Reference

| 操作 | 说明 |
|------|------|
| 合并风格 style.md | 跨书比较，仅保留所有书共有的模式；有差异的用 min-max 范围 |
| 合并角色 | 核心特征仅保留所有出场均证实的；记录跨书演变与关系变化 |
| 合并结构 | 识别章节长度范围、固定幕结构、每本都出现的模式 |
| 合并世界观 universe | 常现地点完整整合；单书地点标注来源；后书优先解决矛盾 |
| 生成 merge-report.md | 输出来源、一致性分析、角色覆盖、已解决冲突 |

## Common Mistakes

- ❌ 把只在单本书出现的模式当作通用规则 → ✅ 仅保留所有书共有的模式，变体用范围标注
- ❌ 角色特征保留未被行动证实的"听说" → ✅ 优先 shown-in-action over told
- ❌ 遇到矛盾随意取舍 → ✅ 事实以后书为准，并文档记录 "Sources vary: ..."
- ❌ 单书角色不标注来源 → ✅ 显著角色包含并标记 "source: [book]"
- ❌ 世界观地点矛盾不处理 → ✅ 后书优先，单书地点加注来源
