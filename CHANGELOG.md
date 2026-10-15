# CHANGELOG

本文件记录仓库的结构性变更：Skill deprecated、Prompt 迁移、目录调整等关键节点。日常 commit 不在此记录。

---

## 2026-09-28

### 新增
- `INDEX.md`：总导航索引，按场景组织所有 Skills 和 Prompts 的对应关系
- `CHANGELOG.md`：本文件
- prompts 文件头部统一添加 `<!-- 关联 Skill -->` 注释，建立 Prompts ↔ Skills 映射

### 变更
- 横纵分析法提示词从完整模板改为简短索引，指向 `hv-analysis` Skill
- README.md 精简：移除冗长的 Skills 全量列表，改为场景速览 + 指向 INDEX.md
- agents 目录清理：`暗黑风格UI提示词.md` 和 `Awesome-design-md/DESIGN默认模板.md` 移至 `prompts/`

### 管理改进
- `AGENTS.md` 新增 Skill 废弃规范（deprecated 标记方式）
- pre-commit hook 扩展：增加 prompts 头部注释检查、INDEX.md 路径有效性检查