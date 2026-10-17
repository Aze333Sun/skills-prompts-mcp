---
name: story-ideator
description: "Use when creating original storylines from any universe bible without plagiarizing source material — new adventures using established characters, locations, and style. Triggers on \"invent a story\", \"create a new adventure\", \"generate synopsis\", \"brainstorm plot\"."
---

# Story Ideator Skill

Generate **original** storylines using an established universe bible. The goal is authentic stories that feel like they belong in the universe while being completely new.

## When to Use

- 基于已有 universe bible（角色/地点/风格）创作全新故事线
- 用既有 IP 头脑风暴新冒险、新谜题、新冲突
- 生成 synopsis（故事简介）或 chapter plan（分章计划）
- 触发词："invent a story"、"create a new adventure"、"generate synopsis"、"brainstorm plot"
- 前提：项目含 `bible/style.md`、`bible/structure.md`、`bible/characters/`、`bible/universe/`

## Core Principle: Originality Over Imitation

**NEVER:**
- Reuse plot structures from analyzed source books
- Copy specific scenes, events, or mysteries
- Recreate villain archetypes with minor changes
- Mirror chapter-by-chapter progression patterns

**ALWAYS:**
- Use only ELEMENTS (characters, locations, tone) from bible
- Generate plots through COMBINATORIAL techniques
- Verify originality against known source plots
- Create NEW mysteries, conflicts, and resolutions

## Input Requirements

Before ideation, verify these files exist:
- `bible/style.md` - Writing constraints
- `bible/structure.md` - Narrative arc patterns
- `bible/characters/*.md` - Character profiles
- `bible/universe/*.md` - Location files

If `analysis/output/*/structure.md` files exist, load them for anti-plagiarism checks.

## Ideation Workflow

### Phase 1: Load Universe Context

Read and extract from bible:

1. **Characters**: List all from `bible/characters/`, extract:
   - Name, core traits, usual role in stories
   - Relationships between characters
   - Capabilities and limitations

2. **Locations**: List all from `bible/universe/`, extract:
   - Name, atmosphere, typical story function
   - Connections between locations

3. **Structure constraints**: From `bible/structure.md`:
   - Expected chapter count/length
   - Arc patterns, pacing expectations
   - Genre-specific mechanics (mystery, adventure, etc.)

4. **Style constraints**: From `bible/style.md`:
   - Tone, vocabulary, forbidden elements
   - POV, tense, target audience

Output: Brief synthesis in `.work/universe-context.md`

### Phase 2: Brainstorm via Collision Techniques

Generate 10-15 story seeds using these methods. Apply them to the SPECIFIC characters and locations found in Phase 1:

**A. What-If Inversion**
Take a character's usual role and invert it:
- "What if [leader character] had to follow instead of lead?"
- "What if [protector character] needed protection?"
- "What if [cautious character] had to take the biggest risk?"

**B. Location Collision**
Combine two locations in unexpected ways:
- "[Safe location] becomes dangerous"
- "[Adventure location] becomes refuge"
- "Mystery connects [location A] to [location B] unexpectedly"

**C. External Pressure**
Introduce constraints the series hasn't explored:
- Time pressure (deadline creates urgency)
- Resource constraint (usual support unavailable)
- Information asymmetry (one character knows what others don't)

**D. Relationship Stress Test**
Create conflict BETWEEN protagonists:
- Disagreement on moral choice
- Competing loyalties
- Temporary separation forcing independent action

**E. Genre Blend**
Mix the series formula with adjacent elements:
- Add ecological/environmental stakes
- Add moral dilemma without clear villain
- Add rescue mission to mystery
- Add discovery that changes understanding of universe

Output: Numbered list of seeds in `.work/story-seeds.md`

### Phase 3: Seed Selection & Development

Present seeds to user. For selected seed:

1. **Expand to Logline** (1-2 sentences)
   - WHO wants WHAT but OBSTACLE leads to STAKES

2. **Define MICE Type** (Orson Scott Card)
   - **Milieu**: Story about exploring a place (ends when they leave/return)
   - **Idea**: Story about answering a question (ends when answered)
   - **Character**: Story about transformation (ends when character changes)
   - **Event**: Story about restoring order (ends when resolved)

3. **Map to Structure Template**
   Use patterns from `bible/structure.md`:
   - Opening hook
   - Discovery/catalyst
   - Investigation/adventure
   - False victory/setback
   - Climax
   - Resolution

Output: Expanded seed in `.work/selected-seed.md`

### Phase 4: Anti-Plagiarism Check

If `analysis/output/*/structure.md` files exist, compare generated plot:

**Extract from each source structure.md:**
- Mystery/conflict type
- Antagonist archetype
- Discovery method (how protagonists learn about problem)
- Resolution pattern (how it's solved)
- Key location usage

**Compare to generated plot:**
| Element | Generated | Source 1 | Source 2 | ... |
|---------|-----------|----------|----------|-----|
| Conflict type | | | | |
| Antagonist | | | | |
| Discovery | | | | |
| Resolution | | | | |
| Location role | | | | |

**Scoring:**
- 0-1 matches with any single source: ✅ Proceed
- 2-3 matches with any single source: ⚠️ Modify overlapping elements
- 4+ matches with any single source: ❌ Return to Phase 2, select different seed

Output: Comparison table in `.work/plagiarism-check.md`

### Phase 5: Synopsis Generation

Write synopsis following structure:
```markdown
# [Title]

## Logline
[1-2 sentences]

## Setup
[Initial situation, what triggers the adventure]

## Conflict
[Main obstacle, antagonist forces, stakes]

## Complications
[2-3 escalating problems]

## Climax
[Confrontation, how protagonists solve it]

## Resolution
[New equilibrium, character growth]

## Themes
[What the story explores beyond plot]
```

Output: `story/synopsis.md`

### Phase 6: Chapter Plan

Create detailed chapter plan matching structure from `bible/structure.md`:

```markdown
# Chapter Plan

## Chapter 1: [Title]
**Function**: [Setup/Catalyst/Development/Climax/Resolution]
**Location**: [From bible/universe/]
**POV focus**: [Which character(s)]
**Events**:
- [Beat 1]
- [Beat 2]
- [Beat 3]
**Ends with**: [Hook for next chapter]

[Repeat for all chapters per bible/structure.md chapter count]
```

Output: `story/plan.md`

## Output Language

Match language of `bible/style.md`.
Internal thinking/checks can be in English.

## Interaction Style

- Present options, don't decide alone
- After each phase, ask for validation before proceeding
- If user has specific ideas, integrate them as constraints
- Explain reasoning for anti-plagiarism flags

## Quick Reference

| 操作 | 说明 |
|------|------|
| `Ideate: [constraint]` | 带约束直接进入 Phase 2（碰撞脑暴）|
| `Develop seed N` | 将第 N 个 seed 直接送入 Phase 3（扩展为 logline/结构）|
| `Check plot: [description]` | 仅对描述运行 Phase 4（反抄袭检查）|

## Common Mistakes

- ❌ 直接复用原作剧情结构/场景/反派原型 → ✅ 只用 ELEMENTS（角色/地点/语气），用组合技法定制全新谜题与解决
- ❌ 跳过 Phase 4 反抄袭检查就交付 → ✅ 与原作 `structure.md` 对比，单源 0-1 匹配才放行，2-3 匹配需修改，4+ 重选 seed
- ❌ 没有 bible 文件就开脑暴 → ✅ 先确认 `bible/style.md`、`structure.md`、`characters/`、`universe/` 存在
- ❌ 替用户直接定方案 → ✅ 每阶段先给选项与理由，让用户确认后再推进
- ❌ 内部思考语言与 bible 风格不符 → ✅ 输出语言跟随 `bible/style.md`，思考可用英文
