---
name: skill-lookup
description: "Use when searching for skills, browsing skill catalogs, installing a skill, or extending capabilities with reusable AI agent components from the prompts.chat registry."
license: MIT
---

## When to Use

- 用户要求查找技能
- 浏览技能目录
- 安装技能
- 扩展 AI 代理能力

## Workflow

1. Search for skills matching the user's request using `search_skills`
2. Present results with title, description, author, and file list
3. If the user picks a skill, retrieve it with `get_skill` to get all files
4. Install by saving files to `.claude/skills/{slug}/` and verify the SKILL.md exists
5. Confirm installation and explain what the skill does and when it activates

## Example

```
search_skills({"query": "code review", "limit": 5, "category": "coding"})
get_skill({"id": "abc123"})
```

## Available Tools

Use these prompts.chat MCP tools:

- `search_skills` - Search for skills by keyword
- `get_skill` - Get a specific skill by ID with all its files

## How to Search for Skills

Call `search_skills` with:

- `query`: The search keywords from the user's request
- `limit`: Number of results (default 10, max 50)
- `category`: Filter by category slug (e.g., "coding", "automation")
- `tag`: Filter by tag slug

Present results showing:
- Title and description
- Author name
- File list (SKILL.md, reference docs, scripts)
- Category and tags
- Link to the skill

## How to Get a Skill

Call `get_skill` with:

- `id`: The skill ID

Returns the skill metadata and all file contents:
- SKILL.md (main instructions)
- Reference documentation
- Helper scripts
- Configuration files

## How to Install a Skill

When the user asks to install a skill:

1. Call `get_skill` to retrieve all files
2. Create the directory `.claude/skills/{slug}/`
3. Save each file to the appropriate location:
   - `SKILL.md` → `.claude/skills/{slug}/SKILL.md`
   - Other files → `.claude/skills/{slug}/{filename}`
4. Read back `SKILL.md` to verify the frontmatter is intact

## Guidelines

- Always search before suggesting the user create their own skill
- Present search results in a readable format with file counts
- When installing, confirm the skill was saved successfully
- Explain what the skill does and when it activates

## Quick Reference

| 操作 | MCP工具 |
|------|---------|
| 搜索技能 | `search_skills({"query": "...", "limit": 5, "category": "coding"})` |
| 获取技能 | `get_skill({"id": "abc123"})` |
| 安装技能 | 保存到 `.claude/skills/{slug}/` |

## Common Mistakes

- ❌ 不搜索就建议用户创建 → ✅ 先搜索现有技能
- ❌ 安装后不验证 → ✅ 读回SKILL.md确认frontmatter完整
- ❌ 不解释技能用途 → ✅ 确认安装后解释技能功能和触发条件
