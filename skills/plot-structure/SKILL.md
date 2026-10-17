---
name: plot-structure
description: "Use when the user asks to \"create a plot arc\", \"story structure\", \"add a plot point\", \"story timeline\", \"track foreshadowing\", \"pacing\", \"act structure\", \"story arc\", \"plot outline\", or wants to plan and manage the narrative structure of a story."
---

# Plot Structure

## Overview

Plan and manage story arcs, plot points, foreshadowing, and narrative timeline. Each arc is a markdown file in `plot/arcs/` with a chronological timeline maintained in `plot/timeline.md`. The plot index tracks all arcs, their status, and theme coverage.

## Prerequisites

A story project must already exist (created via the story-init skill). Verify by checking for `story.md` in the project root.

## When to Use

- 规划或管理故事的叙事结构（情节弧、节拍表）
- 新建情节弧（main / subplot / character / thematic）并写入 `plot/arcs/`
- 添加情节点、维护 `plot/timeline.md` 时间线
- 跟踪伏笔（planted → paid-off）
- 为故事选择/更换结构模型（三幕、英雄之旅、save the cat、起承转合、五幕等）
- 前提：项目已通过 story-init 初始化（根目录存在 `story.md`）

## Choosing a Story Structure

1. Read `story.md` for genre and themes
2. Consult `references/structure-models.md` for available structures
3. Recommend a structure based on genre (default to three-act if unclear)
4. Update `plot/_index.md` frontmatter `structure` field
5. Populate the story structure section with the beat sheet

## Creating an Arc

1. Read `story.md` for themes
2. Read `plot/_index.md` for existing arcs
3. Read `characters/_index.md` to understand available characters
4. Ask for:
   - Arc name
   - Type (main, subplot, character, thematic)
   - Which characters are involved
   - Which themes it serves
5. Build the arc through conversation: setup, escalations, climax, resolution
6. Write the file using `references/arc-template.md`
7. Save to `plot/arcs/{arc-name-kebab}.md`
8. Update `plot/_index.md` arcs table
9. Update theme tracking in `plot/_index.md`
10. If characters are referenced, verify they exist in `characters/`

## Managing Plot Points

Plot points live within arc files in the "Plot Points" table. When adding a plot point:

1. Read the relevant arc file
2. Add the plot point to the table with chapter reference (if known)
3. Add the event to `plot/timeline.md` in chronological order
4. If the plot point involves foreshadowing, add it to the arc's foreshadowing table

## Timeline Management

The timeline at `plot/timeline.md` is a chronological master list of all story events across all arcs.

When adding events:
- Insert in chronological order
- Link to the relevant arc and chapter
- Keep entries concise (one line per event)

When reviewing the timeline:
- Check for chronological consistency
- Identify pacing issues (too many events clustered, long gaps)
- Flag arcs that haven't progressed

## Foreshadowing Tracking

Each arc tracks its own foreshadowing in the "Foreshadowing" table:
- **Planted:** What hint or setup is placed
- **Payoff:** What the payoff will be
- **Chapter Planted / Chapter Payoff:** Where each occurs
- **Status:** `planted` or `paid-off`

During chapter writing, flag any `planted` items that haven't been paid off as reminders.

## Cross-Referencing

- Arcs reference characters via frontmatter `characters` field
- Arcs reference themes via frontmatter `themes` field
- Plot points reference chapters
- Timeline entries link arcs and chapters
- Theme tracking in `plot/_index.md` maps themes to arcs and chapters

## Reference Files

- **`references/arc-template.md`** - Template for arc files with frontmatter and sections
- **`references/structure-models.md`** - Story structure models (three-act, hero's journey, save the cat, kishotenketsu, five-act) with beat sheets

## Quick Reference

| 操作 | 说明 |
|------|------|
| 选择结构 | 读 `story.md` 与 `references/structure-models.md`，按类型推荐，默认三幕；更新 `plot/_index.md` 的 `structure` |
| 创建弧 | 10步流程：读上下文→问清名称/类型/角色/主题→对话构建→用 `references/arc-template.md` 存 `plot/arcs/{name}.md`→更新 `_index.md` |
| 管理情节点 | 加入弧文件 Plot Points 表，并同步 `plot/timeline.md`（按时间顺序）|
| 跟踪伏笔 | 在弧文件 Foreshadowing 表记 planted/payoff 与章节；写章节时提醒未回收项 |
| 时间线审查 | 检查时间一致性、节奏问题（事件扎堆/断层）、停滞的弧 |
| 交叉引用 | 弧经 frontmatter `characters`/`themes` 关联；情节点点章节；时间线链弧与章节 |

## Common Mistakes

- ❌ 项目还不存在就直接建弧 → ✅ 先确认根目录有 `story.md`（用 story-init 初始化）
- ❌ 弧里引用不存在的角色 → ✅ 建弧前核对 `characters/_index.md`，引用前确认角色已存在
- ❌ 伏笔只种不收 → ✅ 写章节时检查 `planted` 未 `paid-off` 的项并提醒回收
- ❌ 时间线事件乱序插入 → ✅ 严格按时间顺序写入 `plot/timeline.md`
- ❌ 改了弧不更新 `_index.md` → ✅ 每次新建/改动都同步 arcs 表与主题追踪
