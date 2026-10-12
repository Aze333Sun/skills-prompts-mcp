# validate-skills.ps1
# Gate check: validate SKILL.md format compliance
# Usage: .\scripts\validate-skills.ps1 [-StagedOnly]

param(
    [switch]$StagedOnly
)

$ErrorActionPreference = "Continue"
$skillDir = Join-Path $PSScriptRoot "..\skills"
# MUST use script scope: "$errors += ..." inside a function creates a local
# copy, outer scope never sees it -> gate always passed (historical bug).
$script:errors = @()
$script:warnings = @()
# skills-collected/ is a read-only upstream copy: format rules are skipped there.
$script:collectedPattern = "[\\/]skills-collected[\\/]"

# Get SKILL.md files to check
function Get-FilesToCheck {
    if ($StagedOnly) {
        $stagedFiles = git diff --cached --name-only --diff-filter=ACM 2>$null
        return $stagedFiles | Where-Object { $_ -match "skills/.*/SKILL\.md$" }
    } else {
        return Get-ChildItem -Path $skillDir -Filter "SKILL.md" -Recurse | Select-Object -ExpandProperty FullName
    }
}

# Extract a frontmatter field, handling "|" / ">" block scalars
function Get-FrontmatterField {
    param([string]$Frontmatter, [string]$FieldName)

    $single = [regex]::Match($Frontmatter, "(?m)^${FieldName}:\s*(.+)$")
    if ($single.Success) {
        $value = $single.Groups[1].Value.Trim()
        if ($value -eq "|" -or $value -eq ">" -or $value -match "^[|>][+-]?$") {
            # Block scalar: join the indented lines that follow
            $lines = $Frontmatter -split "`n"
            $startIdx = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match "^\s*${FieldName}:\s*[|>][+-]?\s*$") { $startIdx = $i; break }
            }
            if ($startIdx -ge 0) {
                $buf = @()
                for ($j = $startIdx + 1; $j -lt $lines.Count; $j++) {
                    if ($lines[$j] -match "^\s+\S") { $buf += $lines[$j].Trim() } else { break }
                }
                return ($buf -join " ").Trim()
            }
            return ""
        }
        return $value.Trim('"').Trim("'")
    }
    return $null
}

# Validate single SKILL.md file; returns the skill name (or $null)
function Test-SkillFile {
    param([string]$FilePath)

    $relativePath = $FilePath.Replace((Get-Location).Path + "\", "")
    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
    # Normalize CRLF -> LF so ^--- anchors work regardless of file line endings
    $content = $content -replace "`r`n", "`n"

    # Check 1: YAML frontmatter exists
    if ($content -notmatch "^---`n") {
        $script:errors += "[$relativePath] Missing YAML frontmatter (file does not start with ---)"
        return $null
    }

    # Extract frontmatter
    $frontmatterMatch = [regex]::Match($content, "^---`n(.*?)`n---", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $frontmatterMatch.Success) {
        $script:errors += "[$relativePath] YAML frontmatter format error"
        return $null
    }

    $frontmatter = $frontmatterMatch.Groups[1].Value
    $isCollected = $relativePath -match $script:collectedPattern

    # Check 2: name field exists
    $name = Get-FrontmatterField -Frontmatter $frontmatter -FieldName "name"
    if ($null -eq $name -or $name -eq "") {
        $script:errors += "[$relativePath] Missing name field"
    } else {
        # Check 3: name format (only letters, numbers, hyphens)
        if ($name -notmatch "^[a-zA-Z0-9\-]+$") {
            $script:errors += "[$relativePath] Invalid name format: '$name' (only letters, numbers, hyphens allowed)"
        }
    }

    # Check 4: description field exists
    $description = Get-FrontmatterField -Frontmatter $frontmatter -FieldName "description"
    if ($null -eq $description -or $description -eq "") {
        $script:errors += "[$relativePath] Missing description field"
    } elseif (-not $isCollected) {
        # Check 5: description starts with "Use when" (skipped for read-only collected)
        if ($description -notmatch "^Use when") {
            $descPreview = $description.Substring(0, [Math]::Min(50, $description.Length))
            $script:errors += "[$relativePath] Description must start with 'Use when...' (current: '$descPreview...')"
        }
        # Check 6: description length
        if ($description.Length -gt 500) {
            $script:warnings += "[$relativePath] Description too long ($($description.Length) chars, recommend <500)"
        }
    }

    if ($isCollected) { return $name }

    # Check 7: required sections exist
    $requiredSections = @("When to Use", "Quick Reference", "Common Mistakes")
    foreach ($section in $requiredSections) {
        if ($content -notmatch "(?m)^##\s+$section") {
            $script:warnings += "[$relativePath] Missing required section: '## $section'"
        }
    }

    # Check 8: no standalone when_to_use field
    if ($frontmatter -match "when_to_use:") {
        $script:warnings += "[$relativePath] when_to_use field should be merged into description"
    }

    return $name
}

# Main flow
Write-Host "=== Skill Format Gate Check ===" -ForegroundColor Cyan
Write-Host ""

$files = Get-FilesToCheck

if (-not $files -or $files.Count -eq 0) {
    Write-Host "No SKILL.md files to check" -ForegroundColor Yellow
    exit 0
}

Write-Host "Checking $($files.Count) files..." -ForegroundColor Gray
Write-Host ""

# name -> path map for uniqueness (duplicate names collide on skill load)
$nameMap = @{}
foreach ($file in $files) {
    if (Test-Path $file) {
        $n = Test-SkillFile -FilePath $file
        if ($n) {
            $rel = $file.Replace((Get-Location).Path + "\", "")
            if ($nameMap.ContainsKey($n)) {
                $script:errors += "[name uniqueness] Duplicate skill name '$n': $($nameMap[$n]) AND $rel"
            } else {
                $nameMap[$n] = $rel
            }
        }
    }
}

# Output results
Write-Host "=== Results ===" -ForegroundColor Cyan
Write-Host ""

if ($script:errors.Count -gt 0) {
    Write-Host "ERRORS ($($script:errors.Count)):" -ForegroundColor Red
    foreach ($err in $script:errors) {
        Write-Host "  $err" -ForegroundColor Red
    }
    Write-Host ""
}

if ($script:warnings.Count -gt 0) {
    Write-Host "WARNINGS ($($script:warnings.Count)):" -ForegroundColor Yellow
    foreach ($warn in $script:warnings) {
        Write-Host "  $warn" -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($script:errors.Count -eq 0 -and $script:warnings.Count -eq 0) {
    Write-Host "ALL CHECKS PASSED!" -ForegroundColor Green
    exit 0
} elseif ($script:errors.Count -gt 0) {
    Write-Host "ERRORS FOUND - commit blocked" -ForegroundColor Red
    exit 1
} else {
    Write-Host "WARNINGS FOUND - commit allowed" -ForegroundColor Yellow
    exit 0
}
