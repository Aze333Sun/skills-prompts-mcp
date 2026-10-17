---
name: story-init
description: "Use when the user asks to \"start a new story\", \"initialize a story project\", \"create a story\", \"new book\", \"set up a story\", or wants to begin a new fiction writing project from scratch."
---

# Story Initialization

## Overview

Initialize a new story project with a structured markdown folder layout. Creates the story bible, character registry, worldbuilding index, plot structure, and chapter tracker - all as cross-referenced markdown files with YAML frontmatter.

## When to Use

- Starting a new story, book, or fiction project
- Setting up the folder structure for an existing story idea
- NOT for adding to an existing story project (use the domain-specific skills instead)

## Workflow

1. Ask for basic story information:
   - Title
   - Genre and sub-genre
   - Brief synopsis (2-3 sentences)
   - Setting era/time period
   - Key themes (2-4)
   - POV style (first-person, third-person-limited, third-person-omniscient)
   - Tense (past, present)

2. Create the folder structure at the current working directory:

```
{story-title-kebab}/
├── story.md
├── characters/
│   └── _index.md
├── worldbuilding/
│   ├── _index.md
│   ├── locations/
│   └── systems/
├── plot/
│   ├── _index.md
│   ├── arcs/
│   └── timeline.md
└── chapters/
    └── _index.md
```

3. Populate `story.md` with the story bible:

```yaml
---
title: "{Title}"
genre: {genre}
sub-genre: {sub-genre}
setting-era: {era}
status: planning
themes:
  - {theme-1}
  - {theme-2}
pov: {pov-style}
tense: {tense}
---
```

Below the frontmatter, include sections:
- **Synopsis** - the 2-3 sentence synopsis provided
- **Tone & Style** - brief notes on the story's voice (derive from genre/themes)
- **Notes** - empty section for the user to fill in

4. Populate each `_index.md` with an empty registry:

**`characters/_index.md`:**
```markdown
---
type: character-registry
story: {story-title-kebab}
---

# Characters

## Registry

| Name | Role | Status | File |
|------|------|--------|------|
| *No characters yet* | | | |

## Family Trees

*No family trees defined yet.*

## Relationship Map

*No relationships defined yet.*
```

**`worldbuilding/_index.md`:**
```markdown
---
type: world-registry
story: {story-title-kebab}
---

# Worldbuilding

## World Overview

*Describe the world at a high level here.*

## Locations

| Name | Type | Region | File |
|------|------|--------|------|
| *No locations yet* | | | |

## Systems

| Name | Type | File |
|------|------|------|
| *No systems yet* | | |
```

**`plot/_index.md`:**
```markdown
---
type: plot-registry
story: {story-title-kebab}
structure: three-act
---

# Plot Structure

## Story Structure

**Model:** Three-Act Structure (adjust as needed)

## Arcs

| Name | Type | Status | File |
|------|------|--------|------|
| *No arcs yet* | | | |

## Theme Tracking

| Theme | Arcs | Chapters |
|-------|------|----------|
| *No themes tracked yet* | | |
```

**`plot/timeline.md`:**
```markdown
---
type: timeline
story: {story-title-kebab}
---

# Story Timeline

| When | Event | Arc | Chapter |
|------|-------|-----|---------|
| *No events yet* | | | |
```

**`chapters/_index.md`:**
```markdown
---
type: chapter-registry
story: {story-title-kebab}
---

# Chapters

## Registry

| # | Title | POV | Status | Word Count | File |
|---|-------|-----|--------|------------|------|
| *No chapters yet* | | | | | |

## Total Word Count: 0
```

5. Present a summary of what was created and suggest next steps:
   - "Add your first character" (triggers character-management skill)
   - "Start worldbuilding" (triggers worldbuilding skill)
   - "Define your plot structure" (triggers plot-structure skill)

## Conventions

These conventions apply across ALL story skills:

- **Kebab-case filenames** for all entity files (e.g., `sera-voss.md`, `ashen-citadel.md`)
- **YAML frontmatter** on every file for structured metadata
- **`_index.md`** files are authoritative registries for each domain
- **`story.md`** is the top-level bible read by all skills for context
- **Bidirectional cross-links** - when referencing another entity, update both files
- **Character identifiers** use the kebab-case filename without extension (e.g., `sera-voss`)

## Quick Reference

| 操作 | 说明 |
|------|------|
| 收集故事信息 | 标题 / 类型与子类型 / 2-3句简介 / 时代 / 2-4主题 / POV / 时态 |
| 创建目录结构 | `{story-title-kebab}/` 含 `story.md`、`characters/`、`worldbuilding/`、`plot/`、`chapters/`，各带 `_index.md` |
| 填充 story.md | 写 YAML frontmatter（title/genre/sub-genre/setting-era/themes/pov/tense）+ Synopsis / Tone&Style / Notes |
| 初始化注册表 | `characters/_index.md`、`worldbuilding/_index.md`、`plot/_index.md`、`plot/timeline.md`、`chapters/_index.md` 写入空注册表 |
| 建议下一步 | 加角色（character-management）/ 世界观（worldbuilding）/ 情节结构（plot-structure）|

## Common Mistakes

- ❌ 在已有项目里用本 Skill 新增内容 → ✅ 已存在的项目改用对应领域 Skill（character-management、worldbuilding、plot-structure 等）
- ❌ 实体文件名不用 kebab-case → ✅ 所有实体文件一律 kebab-case（如 `sera-voss.md`），ID 用不带扩展名的文件名
- ❌ 文件缺少 YAML frontmatter → ✅ 每个文件都带 frontmatter 元数据
- ❌ 引用实体不更新双向链接 → ✅ 引用另一实体时同步更新双方文件
- ❌ 把 `_index.md` 当成普通笔记 → ✅ `_index.md` 是各领域权威注册表，保持为空注册表模板待填
