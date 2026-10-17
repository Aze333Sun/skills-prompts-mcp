# mcp 分发分支

本分支是 `main` 分支中 `mcp/` 目录的**只读快照**，由脚本自动生成。

- 真源仓库：在 `main` 分支修改，**不要**直接提交到本分支
- 重新生成：`main` 分支上执行 `.\scripts\sync-distribution-branches.ps1 -Push`

快照基线：`999f932`