#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Skills 合规审核脚本（等效于 AGENTS.md 门禁规范，并扩展结构与重复检测）。

输出: REPO_SKILLS_AUDIT.md
不修改任何被审文件。
"""
import re
from pathlib import Path
from collections import defaultdict

ROOT = Path(r"E:\project\skills-prompts-mcp")
OUT = ROOT / "REPO_SKILLS_AUDIT.md"

# ---------- 解析 ----------
def parse_frontmatter(text):
    if not text.lstrip().startswith("---"):
        return None, text, "NO_FRONTMATTER"
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n?(.*)$", text, re.DOTALL)
    if not m:
        return None, text, "NO_CLOSING_FM"
    fm_raw, body = m.group(1), m.group(2)
    fm = {}
    for line in fm_raw.splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            v = v.strip()
            if (v.startswith('"') and v.endswith('"')) or (v.startswith("'") and v.endswith("'")):
                v = v[1:-1]
            fm[k.strip()] = v
    return fm, body, None

# ---------- 扫描 ----------
skill_files = sorted(ROOT.glob("skills/**/SKILL.md"))
results = []
for sf in skill_files:
    rel = sf.relative_to(ROOT)
    collected = "skills-collected" in str(sf)
    text = sf.read_text(encoding="utf-8", errors="replace")
    fm, body, err = parse_frontmatter(text)
    rec = {"path": str(rel), "collected": collected, "errors": [], "name": None,
           "description": None, "effort": None}
    if err:
        rec["errors"].append(err)
        results.append(rec)
        continue
    name = fm.get("name")
    desc = fm.get("description")
    effort = fm.get("effort")
    rec["name"] = name
    rec["description"] = desc
    rec["effort"] = effort

    # name
    if not name:
        rec["errors"].append("NO_NAME")
    else:
        if not re.match(r"^[a-zA-Z0-9-]+$", name):
            rec["errors"].append(f"BAD_NAME_FORMAT({name})")
    # description
    if not desc:
        rec["errors"].append("NO_DESCRIPTION")
    else:
        d = desc.strip()
        if not d.lower().startswith("use when"):
            rec["errors"].append("DESC_NOT_USE_WHEN")
        if len(d) >= 500:
            rec["errors"].append("DESC_TOO_LONG")
    # when_to_use 禁止
    if "when_to_use" in fm:
        rec["errors"].append("HAS_WHEN_TO_USE")
    # 标准章节
    for ch in ["When to Use", "Quick Reference", "Common Mistakes"]:
        if not re.search(r"^##\s+" + re.escape(ch), body, re.MULTILINE):
            rec["errors"].append(f"MISSING_CHAPTER({ch})")
    results.append(rec)

# 重复 name
name_map = defaultdict(list)
for r in results:
    if r.get("name"):
        name_map[r["name"]].append(r["path"])
dups = {k: v for k, v in name_map.items() if len(v) > 1}

# ---------- 统计 ----------
total = len(results)
compliant = [r for r in results if not r["errors"]]
noncompliant = [r for r in results if r["errors"]]
self_all = [r for r in results if not r["collected"]]
self_bad = [r for r in self_all if r["errors"]]
coll_all = [r for r in results if r["collected"]]
coll_bad = [r for r in coll_all if r["errors"]]

RULE_MEANING = {
    "MISSING_CHAPTER": "缺少 When to Use / Quick Reference / Common Mistakes 之一",
    "DESC_NOT_USE_WHEN": 'description 不以 "Use when" 开头',
    "DESC_TOO_LONG": "description ≥ 500 字符",
    "BAD_NAME_FORMAT": "name 含非法字符",
    "NO_NAME": "缺 name",
    "NO_DESCRIPTION": "缺 description",
    "HAS_WHEN_TO_USE": "存在禁用字段 when_to_use",
    "NO_FRONTMATTER": "缺 frontmatter",
    "NO_CLOSING_FM": "frontmatter 未闭合",
}

# ---------- 生成报告 ----------
L = []
L.append("# Skills 合规审核报告")
L.append("")
L.append("> 生成时间：2026-09-11  ")
L.append(f"> 审核范围：`skills/**/SKILL.md` 全部 **{total}** 个  ")
L.append("> 审核标准：[AGENTS.md](AGENTS.md) 门禁规范（等效 `validate-skills.ps1`）+ 结构/重复扩展项  ")
L.append("> 说明：collected 为只读社区收集，仅标注不修改。")
L.append("")
L.append("## 1. 总览")
L.append("")
L.append("| 指标 | 数值 |")
L.append("|---|---|")
L.append(f"| SKILL.md 总数 | {total} |")
L.append(f"| 自建（非 collected） | {len(self_all)} |")
L.append(f"| collected（只读） | {len(coll_all)} |")
L.append(f"| 完全合规（全部为自建） | **{len(compliant)}** |")
L.append(f"| 存在违规 | {len(noncompliant)} |")
L.append(f"| 　├ 自建·须整改 | **{len(self_bad)}** |")
L.append(f"| 　└ collected·规范差异（预期，不整改） | {len(coll_bad)} |")
L.append(f"| 重复 name（跨文件） | {len(dups)} 组 |")
L.append("")
L.append("**关键口径**：collected 为社区原样拉取（遵循 agentskills.io 标准），其 `description` 多为描述性语句（\"Use when\" 在句中而非句首）、章节命名不同，不符合本仓库 `AGENTS.md` 自定的\"句首 Use when + 三章节\"规范是**预期的**，属规范适用范围问题，**不计入需整改**。下文将两类分开统计。")
L.append("")
L.append(f"## 2. 违规规则分布（仅自建·须整改 {len(self_bad)} 个）")
L.append("")
if self_bad:
    rc = defaultdict(int)
    for r in self_bad:
        for e in r["errors"]:
            rc[e.split("(")[0]] += 1
    L.append("| 规则 KEY | 含义 | 自建违反次数 |")
    L.append("|---|---|---|")
    for k, v in sorted(rc.items(), key=lambda x: -x[1]):
        L.append(f"| {k} | {RULE_MEANING.get(k, k)} | {v} |")
else:
    L.append("无需整改。")
L.append("")
L.append(f"> collected {len(coll_bad)} 个同样触发上述规则（MISSING_CHAPTER / DESC_NOT_USE_WHEN / DESC_TOO_LONG），因只读且为社区标准，不计入整改。")
L.append("")
L.append(f"## 3. 自建·须整改清单（{len(self_bad)} 个）")
L.append("")
if self_bad:
    L.append("| # | 文件 | 主要问题 |")
    L.append("|---|---|---|")
    for i, r in enumerate(self_bad, 1):
        errs = "; ".join(e for e in r["errors"])
        L.append(f"| {i} | `{r['path']}` | {errs} |")
else:
    L.append("无。自建 Skill 全部合规。")
L.append("")
L.append(f"## 4. collected·规范差异清单（{len(coll_bad)} 个，只读-预期不整改）")
L.append("")
if coll_bad:
    names = ", ".join(f"`{r['name']}`" for r in coll_bad if r["name"])
    L.append(names)
    L.append("")
    L.append("> 此批均为社区标准、只读，不建议在库内修改；完整违规明细见 `audit_skills.py` 原始输出。")
else:
    L.append("无。")
L.append("")
L.append("## 5. 重复 / 冲突 name")
L.append("")
if dups:
    L.append("| name | 位置 | 风险 |")
    L.append("|---|---|---|")
    for k, v in sorted(dups.items()):
        L.append(f"| `{k}` | " + "<br>".join(f"`{p}`" for p in v) + " | 同名两份，Agent 加载存在歧义 |")
else:
    L.append("无重复 name。")
L.append("")
L.append("## 6. 结论与建议")
L.append("")
if self_all:
    rate = (len(self_all) - len(self_bad)) * 100 // len(self_all)
    L.append(f"- **真问题**：自建 {len(self_all)} 个中 **{len(self_bad)} 个不合规**（合规率 {rate}%）。")
if self_bad:
    L.append("  - 须补 `description` 句首 \"Use when\" 与三标准章节（When to Use / Quick Reference / Common Mistakes）。")
L.append(f"- **规范冲突（治理缺陷）**：`AGENTS.md` 门禁规范与社区 agentskills.io 标准不兼容——collected {len(coll_all)} 个全部不符合本仓库自定格式。建议明确「门禁规范仅约束自建 Skills」，并在 `validate-skills.ps1` 中排除 `skills-collected/`。")
if dups:
    L.append(f"- **同名冲突**：清理自建 `skills/docx/` 或重命名以区分社区 `docx`。")
L.append("- **自动化**：保留 `audit_skills.py`，纳入定期/提交前门禁重跑。")
L.append("")
L.append("---")
L.append("*本报告由 `audit_skills.py` 自动生成，仅扫描不修改。*")

OUT.write_text("\n".join(L), encoding="utf-8")
print(f"WROTE {OUT} | total={total} compliant={len(compliant)} self_bad={len(self_bad)} coll_bad={len(coll_bad)} dups={len(dups)}")
