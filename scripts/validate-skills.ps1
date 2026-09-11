# validate-skills.ps1
# Gate check: validate SKILL.md format compliance
# Usage: .\scripts\validate-skills.ps1 [-StagedOnly]

param(
    [switch]$StagedOnly
)

$ErrorActionPreference = "Continue"
$skillDir = Join-Path $PSScriptRoot "..\skills"
$errors = @()
$warnings = @()

# Get SKILL.md files to check
function Get-FilesToCheck {
    if ($StagedOnly) {
        $stagedFiles = git diff --cached --name-only --diff-filter=ACM 2>$null
        return $stagedFiles | Where-Object { $_ -match "skills/.*/SKILL\.md$" }
    } else {
        return Get-ChildItem -Path $skillDir -Filter "SKILL.md" -Recurse | Select-Object -ExpandProperty FullName
    }
}

# Validate single SKILL.md file
function Test-SkillFile {
    param([string]$FilePath)
    
    $relativePath = $FilePath.Replace((Get-Location).Path + "\", "")
    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
    $lines = $content -split "`n"
    
    # Check 1: YAML frontmatter exists
    if ($content -notmatch "^---`n") {
        $errors += "[$relativePath] Missing YAML frontmatter (file does not start with ---)"
        return
    }
    
    # Extract frontmatter
    $frontmatterMatch = [regex]::Match($content, "^---`n(.*?)`n---", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $frontmatterMatch.Success) {
        $errors += "[$relativePath] YAML frontmatter format error"
        return
    }
    
    $frontmatter = $frontmatterMatch.Groups[1].Value
    
    # Check 2: name field exists
    if ($frontmatter -notmatch "name:\s*(.+)") {
        $errors += "[$relativePath] Missing name field"
    } else {
        $name = $matches[1].Trim().Trim('"').Trim("'")
        # Check 3: name format (only letters, numbers, hyphens)
        if ($name -notmatch "^[a-zA-Z0-9\-]+$") {
            $errors += "[$relativePath] Invalid name format: '$name' (only letters, numbers, hyphens allowed)"
        }
    }
    
    # Check 4: description field exists
    if ($frontmatter -notmatch "description:\s*(.+)") {
        $errors += "[$relativePath] Missing description field"
    } else {
        $description = $matches[1].Trim().Trim('"').Trim("'")
        # Check 5: description starts with "Use when"
        if ($description -notmatch "^Use when") {
            $descPreview = $description.Substring(0, [Math]::Min(50, $description.Length))
            $errors += "[$relativePath] Description must start with 'Use when...' (current: '$descPreview...')"
        }
        # Check 6: description length
        if ($description.Length -gt 500) {
            $warnings += "[$relativePath] Description too long ($($description.Length) chars, recommend <500)"
        }
    }
    
    # Check 7: required sections exist
    $requiredSections = @("When to Use", "Quick Reference", "Common Mistakes")
    foreach ($section in $requiredSections) {
        if ($content -notmatch "(?m)^##\s+$section") {
            $warnings += "[$relativePath] Missing required section: '## $section'"
        }
    }
    
    # Check 8: no standalone when_to_use field
    if ($frontmatter -match "when_to_use:") {
        $warnings += "[$relativePath] when_to_use field should be merged into description"
    }
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

foreach ($file in $files) {
    if (Test-Path $file) {
        Test-SkillFile -FilePath $file
    }
}

# Output results
Write-Host "=== Results ===" -ForegroundColor Cyan
Write-Host ""

if ($errors.Count -gt 0) {
    Write-Host "ERRORS ($($errors.Count)):" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  $err" -ForegroundColor Red
    }
    Write-Host ""
}

if ($warnings.Count -gt 0) {
    Write-Host "WARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
    foreach ($warn in $warnings) {
        Write-Host "  $warn" -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "ALL CHECKS PASSED!" -ForegroundColor Green
    exit 0
} elseif ($errors.Count -gt 0) {
    Write-Host "ERRORS FOUND - commit blocked" -ForegroundColor Red
    exit 1
} else {
    Write-Host "WARNINGS FOUND - commit allowed" -ForegroundColor Yellow
    exit 0
}
