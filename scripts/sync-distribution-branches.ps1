<#
.SYNOPSIS
    从 main 生成/更新内容分发分支（skills、prompts、mcp）。

.DESCRIPTION
    方案 A：main 是唯一真源（全量），分发分支是只读快照，随时可重新生成。

    每个分发分支的结构：
        <内容目录>/   <- main 中对应目录的完整内容
        README.md     <- 说明该分支为分发快照，禁止直接修改

    分支使用 git plumbing（rev-parse / mktree / commit-tree）构建，
    不需要切换工作区、不产生临时提交，且对 main 历史无任何写入。

    更新流程（改完 main 提交后执行）：
        git checkout main
        .\scripts\sync-distribution-branches.ps1
        git push origin main skills prompts mcp   # 分发分支为快照，重推需 --force

.PARAMETER Branches
    要同步的 [分支名:目录名] 列表，默认三项：
        skills:skills  prompts:prompts  mcp:mcp

.EXAMPLE
    .\scripts\sync-distribution-branches.ps1
    # 重新生成三个分发分支（本地）

.EXAMPLE
    .\scripts\sync-distribution-branches.ps1 -Push
    # 生成并推送（分发分支带 --force，因快照历史会被覆盖）
#>
[CmdletBinding()]
param(
    [string[]]$Branches = @('skills:skills', 'prompts:prompts', 'mcp:mcp'),
    [string]$Source = 'main',
    [switch]$Push
)

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

# ---- 前置校验 ----
$srcSha = (git rev-parse $Source).Trim()
if ($LASTEXITCODE -ne 0) { throw "无法解析源分支 $Source" }

$dirty = git status --porcelain
if ($dirty) { Write-Warning "工作区有未提交改动，分发分支将基于已提交的 $Source（$($srcSha.Substring(0,7))）生成" }

Write-Host "源分支 $Source = $($srcSha.Substring(0,7))"

foreach ($spec in $Branches) {
    $name, $dir = $spec.Split(':', 2)

    # 1) 取 main 中该目录的子树对象
    $subTree = (git rev-parse "${srcSha}:${dir}").Trim()
    if ($LASTEXITCODE -ne 0) { throw "$Source 中不存在目录 $dir" }

    # 2) 生成分发分支根 README（告知用途与再生成方式）
    $readme = @"
# $dir 分发分支

本分支是 ``$Source`` 分支中 ``$dir/`` 目录的**只读快照**，由脚本自动生成。

- 真源仓库：在 ``$Source`` 分支修改，**不要**直接提交到本分支
- 重新生成：``$Source`` 分支上执行 ``.\scripts\sync-distribution-branches.ps1 -Push``

快照基线：``$($srcSha.Substring(0,7))``
"@
    $tmp = Join-Path ([IO.Path]::GetTempPath()) "dist-readme-$name.md"
    # 无 BOM UTF-8（PS5.1 的 Set-Content -Encoding utf8 会写 BOM）
    [IO.File]::WriteAllText($tmp, $readme, (New-Object Text.UTF8Encoding $false))
    $readmeBlob = (git hash-object -w $tmp).Trim()
    Remove-Item $tmp

    # 3) 组装根树：<dir>/ + README.md
    # 注意：不能走 PowerShell 管道（会把 \r 混入行尾，导致 README.md 文件名带 \r），
    # 改为写入临时文件后用 cmd 重定向喂给 mktree。
    $mktreeInput = @(
        "040000 tree $subTree`t$dir",
        "100644 blob $readmeBlob`tREADME.md"
    ) -join "`n"
    $treeFile = Join-Path ([IO.Path]::GetTempPath()) "dist-mktree-$name.txt"
    # ASCII 安全：路径均为仓库内已知 ASCII 名
    [IO.File]::WriteAllText($treeFile, $mktreeInput, (New-Object Text.UTF8Encoding $false))
    $rootTree = (cmd /c "git mktree < `"$treeFile`"").Trim()
    Remove-Item $treeFile
    if ($LASTEXITCODE -ne 0 -or -not $rootTree) { throw "mktree 失败（$name）" }

    # 4) 生成快照提交（父提交留空：每次都是可覆盖的独立快照）
    $msg = "snapshot: $dir/ from $Source@$($srcSha.Substring(0,7))"
    $commit = (git commit-tree $rootTree -m $msg).Trim()
    if ($LASTEXITCODE -ne 0) { throw "commit-tree 失败（$name）" }

    # 5) 更新本地分支引用
    git branch -f $name $commit
    Write-Host ("{0,-8} -> {1}  ({2})" -f $name, $commit.Substring(0,7), $msg)
}

if ($Push) {
    foreach ($spec in $Branches) {
        $name = $spec.Split(':', 2)[0]
        # 快照分支历史会被整体覆盖，必须 --force
        git push --force origin $name
        if ($LASTEXITCODE -ne 0) { throw "推送 $name 失败（检查网络/代理，如 WattToolkit 未启动）" }
    }
    Write-Host "已推送分发分支。"
} else {
    Write-Host "仅更新本地。推送请加 -Push（快照分支需 --force），或手动："
    Write-Host "  git push --force origin $($Branches | ForEach-Object { $_.Split(':',2)[0] })"
}
