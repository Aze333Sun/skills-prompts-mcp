---
name: worldbuilding
description: "Use when the user wants to create or expand a story's world and setting — locations, or systems like magic, politics, technology, religion, economy, culture, or world history. Stores elements as cross-referenced markdown files."
---

# Worldbuilding

## Overview

Create and manage world elements for a story project. Locations and systems (magic, politics, technology, etc.) are stored as markdown files in the `worldbuilding/` directory with YAML frontmatter. All elements cross-reference characters and other story elements.

## Prerequisites

A story project must already exist (created via the story-init skill). Verify by checking for `story.md` in the project root.

## Creating a Location

1. Read `story.md` for genre, era, and tone context
2. Read `worldbuilding/_index.md` for existing locations and systems
3. Ask for the location's name and type (city, fortress, wilderness, etc.)
4. Build the location through conversation, covering:
   - Physical description and atmosphere
   - History relevant to the story
   - Culture and customs of inhabitants
   - Notable features characters will interact with
   - Current state at story's timeline
5. Write the file using `references/location-template.md`
6. Save to `worldbuilding/locations/{name-kebab}.md`
7. Update `worldbuilding/_index.md` locations table
8. If notable characters are listed, verify those character files exist and add location references to them

## Creating a System

1. Read `story.md` for genre and themes context
2. Read `worldbuilding/_index.md` for existing systems
3. Identify the system type and consult `references/world-element-types.md` for the relevant prompts
4. Build the system through conversation, addressing the key questions for that type
5. Write the file using `references/system-template.md`
6. Save to `worldbuilding/systems/{name-kebab}.md`
7. Update `worldbuilding/_index.md` systems table
8. Cross-reference with characters who interact with the system (e.g., magic-users for a magic system)

## Updating World Elements

1. Read the existing file
2. Make the requested changes
3. If cross-references changed, update the linked files
4. Update `worldbuilding/_index.md` if name, type, or status changed

## Cross-Referencing

- Locations reference characters via `notable-characters` in frontmatter
- Systems reference practitioners via character tags
- When a location is used in a chapter, the chapter's frontmatter `locations` field links back
- Keep the `worldbuilding/_index.md` world overview section current as elements are added

## Reference Files

- **`references/location-template.md`** - Template for location files
- **`references/system-template.md`** - Template for system files
- **`references/world-element-types.md`** - Detailed prompts for each system type (magic, political, technology, religion, economic, military, social)

## When to Use

- 用户要创建或扩展故事的地点（location）
- 用户要创建魔法 / 政治 / 科技 / 宗教 / 经济 / 军事 / 社会等系统（system）
- 用户要添加文化、世界历史等世界设定（world history / culture）
- 用户要更新已有世界元素，或与角色做交叉引用
- 前提：story 项目已存在（根目录含 `story.md`，通常由 story-init 创建）

## Quick Reference

| 操作 | 说明 |
|------|------|
| 创建地点 | 读 `story.md` 与 `_index.md` → 对话构建 → 存 `worldbuilding/locations/{name-kebab}.md` → 更新 `_index.md` |
| 创建系统 | 读 `references/world-element-types.md` 提示 → 存 `worldbuilding/systems/{name-kebab}.md` |
| 更新元素 | 读原文件改 → 同步交叉引用与 `_index.md` |
| 交叉引用 | 地点 via `notable-characters`；系统 via character tags；章节 frontmatter `locations` 回链 |

## Common Mistakes

- ❌ story 项目尚未创建就直接建世界 → ✅ 先确认根目录 `story.md` 存在（经 story-init）
- ❌ 只建元素却不同步 `_index.md` → ✅ 每次新增 / 改名 / 改状态都更新索引表
- ❌ 世界元素不与角色交叉引用 → ✅ 用 `notable-characters` / character tags 互链
- ❌ 套模板却跳过对话挖掘细节 → ✅ 先通过对话覆盖物理 / 历史 / 文化 / 特征 / 时间线状态
