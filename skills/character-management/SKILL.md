---
name: character-management
description: "Use when the user asks to create, update, or manage characters in a story project. Builds rich character profiles with YAML frontmatter, family trees, relationship maps, and cross-references with other story elements."
---

# Character Management

## When to Use

- 用户要求创建、更新或管理故事项目中的角色
- 用户要建家谱、角色关系图、角色时间线或角色弧
- 故事项目已通过 story-init 创建（存在 story.md）

## Overview

Create and manage rich character profiles for a story project. Each character is a markdown file with YAML frontmatter in the `characters/` directory. Characters are cross-referenced with other story elements through kebab-case identifiers.

## Prerequisites

A story project must already exist (created via the story-init skill). Verify by checking for `story.md` in the project root.

## Creating a Character

1. Read `story.md` for genre, themes, and tone context
2. Read `characters/_index.md` for existing characters
3. Ask for the character's name and role (protagonist, antagonist, supporting, minor)
4. Build the profile through conversation, exploring:
   - Appearance and distinguishing features
   - Personality, traits, and quirks
   - Backstory and formative events
   - Motivations (external wants vs internal needs)
   - Voice and speech patterns (ask for example dialogue)
   - Character arc (starting state, turning points, ending state)
   - Key life events for the timeline
5. Write the character file using the template in `references/character-template.md`
6. Save to `characters/{name-kebab}.md`
7. Update `characters/_index.md` registry table
8. If relationships reference existing characters, update those character files too

## Updating a Character

1. Read the existing character file
2. Read `characters/_index.md` for context on other characters
3. Make the requested changes
4. If relationships changed, update the other character's file (bidirectional)
5. Update `characters/_index.md` if role or status changed

## Managing Relationships

Reference `references/relationship-types.md` for the full list of relationship types and inverse pairs.

When adding a relationship:
- Add the relationship entry to the character's frontmatter
- Add the inverse relationship to the other character's frontmatter
- Update the Relationship Map section in `characters/_index.md`

## Family Trees

Family trees are maintained in the `characters/_index.md` under the "Family Trees" section. Format:

```markdown
## Family Trees

### {Family Name}
- **{Character Name}** ({status}) - [{name-kebab}.md]
  - **{Child Name}** - [{name-kebab}.md]
  - **{Child Name}** - [{name-kebab}.md]
```

Indent children under parents. Note marriages/partnerships inline.

## Cross-Referencing

- When a character is referenced in worldbuilding (e.g., a location's `notable-characters`), ensure the link exists both ways
- When a character appears in a plot arc, ensure they're listed in the arc's `characters` frontmatter
- Character tags should be consistent across the project (e.g., if `magic-user` is used, always use that exact tag)

## Reference Files

- **`references/character-template.md`** - Full blank template for character profiles
- **`references/relationship-types.md`** - Complete relationship type reference with inverse pairs

## Quick Reference

| 操作 | 说明 |
|------|------|
| 创建角色 | 读 story.md + _index.md，对话补全档案，写入 characters/{name-kebab}.md |
| 更新角色 | 改文件 + 双向更新关系 + 更新 _index 注册表 |
| 管理关系 | 加关系条目到双方 frontmatter + 更新 Relationship Map |
| 家谱 | 在 _index.md 的 Family Trees 下按父子缩进维护 |
| 交叉引用 | 角色在 worldbuilding/plot 中被引用时双向链接 |

## Common Mistakes

- ❌ 关系只写在单方 frontmatter → ✅ 双向添加 inverse 关系到双方 + 更新 Relationship Map
- ❌ 不先确认 story.md 存在就建角色 → ✅ 先验证项目已通过 story-init 创建
- ❌ 家谱不标来源/婚姻 → ✅ 在 Family Trees 内联标注婚姻/伴侣，子级缩进父级下
- ❌ 跨项目标签不统一（如 magic-user） → ✅ 全项目用完全一致的角色标签
- ❌ 改关系后忘更新 _index → ✅ 角色/状态变化时同步更新 _index.md 注册表
