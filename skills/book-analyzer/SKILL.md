---
name: book-analyzer
description: "Use when analyzing novels, stories, or narrative text to extract a reusable writing bible. Produces structured style, character, structure, and universe files with evidence-based quotes for style matching and story generation."
---

# Book Analyzer

Extract structured bible files from source books for the writing framework.

## When to Use

- 分析小说、故事或任何叙事文本以建立可复用的写作 bible
- 需要为风格仿写、故事生成提取结构化风格/角色/结构/世界观文件
- 已有 source 文本，希望产出带原文证据的分析文件

## Quick Start

```bash
# Analyze a single book
Analyze analysis/src/[book].txt
```

Output structure in `analysis/output/[book-slug]/`:
```
├── style.md
├── structure.md
├── characters/
│   └── [character].md
└── universe/
    └── [location].md
```

## Workflow

### 1. Read source completely
Load the full text, note overall structure and length.

### 2. Extract style
- Identify POV (first/third limited/omniscient)
- Identify tenses (primary, secondary)
- Sample 50 sentences for average length
- List 20-30 characteristic vocabulary items
- List dialogue tags used
- Estimate dialogue-to-prose ratio
- Note description techniques

### 3. Extract characters
For each significant character:
- Identity (name, age, role)
- Physical description
- 3-5 core personality traits with evidence
- 5-10 dialogue quotes showing voice
- Relationships mapped

### 4. Extract structure
- Map acts (setup/development/climax/resolution)
- Note chapter count and length range
- Analyze chapter openings and endings
- Identify recurring patterns
- Track mystery mechanics if applicable

### 5. Extract universe
For each significant location:
- Physical description with quotes
- Atmosphere and sensory details
- Story function

### 6. Generate files
Create all output files following templates in `bible/`.

## Evidence-Based Extraction

Every trait, pattern, or rule must be supported by:
- Direct quotes (with chapter reference)
- Quantitative data (averages, counts, percentages)

Bad: "Claude is stubborn"
Good: "Claude is stubborn (Ch.2: refuses to answer to 'Claudine'; Ch.5: insists on leading despite danger)"

## Output Format

Follow templates exactly:
- `bible/style.md` → `output/[book]/style.md`
- `bible/characters/_template.md` → `output/[book]/characters/[name].md`
- `bible/universe/_template.md` → `output/[book]/universe/[name].md`
- `bible/structure.md` → `output/[book]/structure.md`

For detailed extraction checklists, see [references/extraction-guide.md](references/extraction-guide.md).

## Output Language
French (for extracted content and quotes)
English (for metadata and structural annotations)

## Quick Reference

| 操作 | 说明 |
|------|------|
| 读取原文 | 完整加载文本，记录整体结构与长度 |
| 提取风格 style.md | 识别 POV/时态/平均句长/特征词/对话标签/对白占比 |
| 提取角色 | 身份、外貌、核心特质(带证据)、对话引用、关系 |
| 提取结构 | 幕结构、章节数与长度范围、开头结尾、重复模式 |
| 提取世界观 | 地点物理描述 + 氛围 + 故事功能 |
| 生成文件 | 按 bible/ 模板输出到 analysis/output/[book]/ |

## Common Mistakes

- ❌ 凭印象下结论（"角色很固执"） → ✅ 每条特质配原文引用 + 章节出处
- ❌ 混用法语内容与英文元数据 → ✅ 内容用法语，元数据/结构注记用英文
- ❌ 跳过定量采样 → ✅ 采样约 50 句算平均句长，列 20-30 个特征词
- ❌ 不参考提取清单 → ✅ 详细清单见 references/extraction-guide.md
