#!/bin/bash
# Skills 生成脚本（通用）
# 用法：bash generate-skills.sh <项目路径> <配置文件路径或JSON字符串> [提取结果路径]
#   --help  显示帮助信息
#
# 功能：
#   1. 读取 skills-config.json（支持文件路径或内联 JSON 字符串）
#   2. 读取 extract-constraints.sh 生成的 detected-facts.env（如存在）
#   3. 根据检测结果动态生成 Core Skills + Detailed Skills + 索引文件
#
# 生成的 Skills 是"骨架 + 已检测事实"，标注 [待确认] 的条目需人工 + AI 完善。
# 环境：Windows 下请在 Git Bash / WSL 中运行。

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "用法：bash generate-skills.sh <项目路径> <配置文件路径或JSON字符串> [提取结果路径]"
    echo ""
    echo "根据检测事实动态生成分层 Skills 体系："
    echo "  core/              Core Skills（核心约束，常驻上下文）"
    echo "  detailed/          Detailed Skills（详细规范，按需加载）"
    echo "  SKILL_CORE_README.md  Core Skills 总览"
    echo "  README.md          知识体系说明"
    echo ""
    echo "参数："
    echo "  配置文件路径    skills-config.json 文件路径，或内联 JSON 字符串"
    echo "  提取结果路径    extract-constraints.sh 输出目录（含 detected-facts.env），"
    echo "                  可选，脚本也会自动搜索默认路径"
    exit 0
fi

PROJECT_PATH=$1
PROJECT_CONFIG=$2
FACTS_DIR=$3

if [ -z "$PROJECT_PATH" ] || [ -z "$PROJECT_CONFIG" ]; then
    echo "用法：bash generate-skills.sh <项目路径> <配置文件路径或JSON字符串> [提取结果路径]"
    exit 1
fi

# ---------- 解析配置 ----------
CONFIG_TEXT=""
if [ -f "$PROJECT_CONFIG" ]; then
    CONFIG_TEXT=$(cat "$PROJECT_CONFIG")
    echo "配置文件: $PROJECT_CONFIG"
else
    CONFIG_TEXT="$PROJECT_CONFIG"
    echo "配置来源: 命令行内联 JSON"
fi

get_config() {
    echo "$CONFIG_TEXT" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -1 | sed -E 's/.*:[[:space:]]*"([^"]*)".*/\1/'
}

PROJECT_NAME=$(get_config projectName)
LANGUAGE=$(get_config language)
FRAMEWORK=$(get_config framework)
DATABASE=$(get_config database)
ARCHITECTURE=$(get_config architecture)
DEPLOYMENT=$(get_config deployment)
OUTPUT_PATH=$(get_config outputPath)

[ -z "$PROJECT_NAME" ] && PROJECT_NAME=$(basename "$(cd "$PROJECT_PATH" && pwd)")
[ -z "$LANGUAGE" ] && LANGUAGE="java"
[ -z "$OUTPUT_PATH" ] && OUTPUT_PATH="$PROJECT_PATH/docs/skills-layered"
# 相对路径基于项目路径解析
case "$OUTPUT_PATH" in
    /*|?:*) ;;
    *) OUTPUT_PATH="$PROJECT_PATH/$OUTPUT_PATH" ;;
esac

echo ""
echo "=== Skills 生成开始 ==="
echo "项目名称: $PROJECT_NAME"
echo "语言: $LANGUAGE | 框架: $FRAMEWORK | 数据库: $DATABASE"
echo "输出路径: $OUTPUT_PATH"

# ---------- 读取提取结果 ----------
FACTS_FILE=""
if [ -n "$FACTS_DIR" ] && [ -f "$FACTS_DIR/detected-facts.env" ]; then
    FACTS_FILE="$FACTS_DIR/detected-facts.env"
else
    for candidate in \
        "$PROJECT_PATH/docs/skills-analysis/constraints/detected-facts.env" \
        "$PROJECT_PATH/.skills-analysis/constraints/detected-facts.env"; do
        [ -f "$candidate" ] && FACTS_FILE="$candidate" && break
    done
fi

get_fact() {
    if [ -n "$FACTS_FILE" ]; then
        sed -n "s/^$1=//p" "$FACTS_FILE" | head -1
    fi
}

if [ -n "$FACTS_FILE" ]; then
    echo "提取结果: $FACTS_FILE"
    # 事实优先于配置文件
    F_LANGUAGE=$(get_fact LANGUAGE)
    F_FRAMEWORK=$(get_fact FRAMEWORK)
    F_DATABASE=$(get_fact DATABASE)
    [ -n "$F_LANGUAGE" ] && [ "$F_LANGUAGE" != "unknown" ] && LANGUAGE=$F_LANGUAGE
    [ -n "$F_FRAMEWORK" ] && [ "$F_FRAMEWORK" != "未检测到" ] && FRAMEWORK=$F_FRAMEWORK
    [ -n "$F_DATABASE" ] && [ "$F_DATABASE" != "未检测到" ] && DATABASE=$F_DATABASE
    BUILD_TOOL=$(get_fact BUILD_TOOL)
    SPRING_BOOT_VERSION=$(get_fact SPRING_BOOT_VERSION)
    JAVA_VERSION=$(get_fact JAVA_VERSION)
    KEY_DEPS=$(get_fact KEY_DEPS)
    LAYERS_FOUND=$(get_fact LAYERS_FOUND)
    BASE_PACKAGE=$(get_fact BASE_PACKAGE)
    UNIFIED_RESPONSE_CLASS=$(get_fact UNIFIED_RESPONSE_CLASS)
    EXCEPTION_CLASSES=$(get_fact EXCEPTION_CLASSES)
    DATASOURCE_MODE=$(get_fact DATASOURCE_MODE)
    DS_COUNT=$(get_fact DS_COUNT)
    ENTITY_SUFFIXES=$(get_fact ENTITY_SUFFIXES)
    LOGGING_FRAMEWORK=$(get_fact LOGGING_FRAMEWORK)
    DEPLOYMENT_FACT=$(get_fact DEPLOYMENT)
else
    echo "提取结果: 未找到（建议先运行 analyze-project.sh + extract-constraints.sh）"
    LAYERS_FOUND=""
fi
[ -z "$DEPLOYMENT" ] && DEPLOYMENT="${DEPLOYMENT_FACT:-未确认}"

mkdir -p "$OUTPUT_PATH/core" "$OUTPUT_PATH/detailed"

# ---------- 规划 Skills 清单 ----------
CORE_COUNT=0
DETAILED_COUNT=0
declare -a CORE_FILES DETAILED_FILES CORE_NAMES DETAILED_NAMES

# CORE_001 / DETAILED_001 恒有
CORE_COUNT=1; DETAILED_COUNT=1
CORE_FILES[1]="SKILL_CORE_001_技术栈.md"; CORE_NAMES[1]="技术栈核心约束"
DETAILED_FILES[1]="SKILL_DETAILED_001_项目技术栈与约束.md"; DETAILED_NAMES[1]="项目技术栈与约束"

# 分层 -> CORE_002 + DETAILED_002
if [ -n "$LAYERS_FOUND" ]; then
    CORE_COUNT=$((CORE_COUNT + 1))
    CORE_FILES[$CORE_COUNT]="SKILL_CORE_002_分层架构.md"; CORE_NAMES[$CORE_COUNT]="分层架构核心约束"
    DETAILED_COUNT=$((DETAILED_COUNT + 1))
    DETAILED_FILES[$DETAILED_COUNT]="SKILL_DETAILED_002_代码分层与包结构.md"; DETAILED_NAMES[$DETAILED_COUNT]="代码分层与包结构"
    HAS_LAYERING=1
fi

# 统一返回 -> CORE_003 + DETAILED_003
if [ -n "$UNIFIED_RESPONSE_CLASS" ]; then
    CORE_COUNT=$((CORE_COUNT + 1))
    CORE_FILES[$CORE_COUNT]="SKILL_CORE_003_返回格式.md"; CORE_NAMES[$CORE_COUNT]="返回格式核心约束"
    DETAILED_COUNT=$((DETAILED_COUNT + 1))
    DETAILED_FILES[$DETAILED_COUNT]="SKILL_DETAILED_003_统一返回格式.md"; DETAILED_NAMES[$DETAILED_COUNT]="统一返回格式"
    HAS_RESPONSE=1
fi

# 多数据源 -> CORE_004 + DETAILED_009
if [ "$DATASOURCE_MODE" = "dynamic-multi" ]; then
    CORE_COUNT=$((CORE_COUNT + 1))
    CORE_FILES[$CORE_COUNT]="SKILL_CORE_004_数据源与表.md"; CORE_NAMES[$CORE_COUNT]="数据源与表核心约束"
    DETAILED_COUNT=$((DETAILED_COUNT + 1))
    DETAILED_FILES[$DETAILED_COUNT]="SKILL_DETAILED_009_多数据源使用规范.md"; DETAILED_NAMES[$DETAILED_COUNT]="多数据源使用规范"
    HAS_MULTI_DS=1
fi

echo ""
echo "规划：Core Skills $CORE_COUNT 个，Detailed Skills $DETAILED_COUNT 个"

# ---------- 生成 Core Skills ----------
echo ""
echo "[1/4] 生成 Core Skills..."

# CORE_001 技术栈
cat > "$OUTPUT_PATH/core/SKILL_CORE_001_技术栈.md" << EOF
---
skill_id: CORE_001
skill_name: 技术栈核心约束
layer: core
force_level: mandatory
tags:
  - 技术栈
  - 约束
---

# SKILL_CORE_001：技术栈核心约束

## 核心规则（必须遵守）

| 规则ID | 规则名称 | 约束内容 | 验证方法 |
|--------|----------|----------|----------|
| C001_001 | 语言 | 必须使用 $LANGUAGE$( [ -n "$JAVA_VERSION" ] && echo " $JAVA_VERSION" ) | 检查构建配置 |
| C001_002 | 框架 | 必须使用 $FRAMEWORK$( [ -n "$SPRING_BOOT_VERSION" ] && echo " $SPRING_BOOT_VERSION" ) | 检查依赖版本 |
| C001_003 | 数据库 | 必须使用 $DATABASE | 检查驱动依赖 |
| C001_004 | 关键依赖 | 已使用依赖：${KEY_DEPS:-待梳理}，禁止擅自更换 | 检查依赖清单 |
| C001_005 | 新依赖 | 禁止引入未评审的新依赖 | 依赖变更评审 |

## 快速验证命令

\`\`\`bash
$( [ "$BUILD_TOOL" = "maven" ] && echo "grep -E '<(artifactId|version)>' pom.xml | head -30" )
$( [ "$BUILD_TOOL" = "gradle" ] && echo "grep -E 'implementation|api' build.gradle" )
$( [ "$BUILD_TOOL" = "pip" ] && echo "cat requirements.txt" )
$( [ "$BUILD_TOOL" = "go-modules" ] && echo "cat go.mod" )
$( [ "$BUILD_TOOL" = "npm" ] && echo "grep -A 20 '\"dependencies\"' package.json" )
\`\`\`

## 关联 Skills

- [DETAILED_001](../detailed/SKILL_DETAILED_001_项目技术栈与约束.md)
EOF
echo "  -> core/SKILL_CORE_001_技术栈.md"

# CORE_002 分层架构
if [ "$HAS_LAYERING" = 1 ]; then
cat > "$OUTPUT_PATH/core/SKILL_CORE_002_分层架构.md" << EOF
---
skill_id: CORE_002
skill_name: 分层架构核心约束
layer: core
force_level: mandatory
tags:
  - 分层
  - 架构
---

# SKILL_CORE_002：分层架构核心约束

## 核心规则（必须遵守）

| 规则ID | 规则名称 | 约束内容 | 验证方法 |
|--------|----------|----------|----------|
| C002_001 | 分层结构 | 项目分层：$LAYERS_FOUND | 检查目录结构 |
| C002_002 | 禁止跨层 | 禁止跨层调用（上层只调用相邻下层）[待确认] | 代码审查 |
| C002_003 | 包路径 | $( [ -n "$BASE_PACKAGE" ] && echo "基础包：$BASE_PACKAGE" || echo "基础包：[待确认]" ) | 检查 package 声明 |
| C002_004 | 职责边界 | 各层职责：[待确认，按项目实际补充] | 代码审查 |

## 快速验证命令

\`\`\`bash
$( [ "$LANGUAGE" = "java" ] && echo "find src/main/java -type d | grep -E '($(echo "$LAYERS_FOUND" | tr ' ' '|'))' | sort" )
\`\`\`

## 关联 Skills

- [DETAILED_002](../detailed/SKILL_DETAILED_002_代码分层与包结构.md)
EOF
echo "  -> core/SKILL_CORE_002_分层架构.md"
fi

# CORE_003 返回格式
if [ "$HAS_RESPONSE" = 1 ]; then
cat > "$OUTPUT_PATH/core/SKILL_CORE_003_返回格式.md" << EOF
---
skill_id: CORE_003
skill_name: 返回格式核心约束
layer: core
force_level: mandatory
tags:
  - 返回格式
  - 接口
---

# SKILL_CORE_003：返回格式核心约束

## 核心规则（必须遵守）

| 规则ID | 规则名称 | 约束内容 | 验证方法 |
|--------|----------|----------|----------|
| C003_001 | 统一返回 | 所有接口必须返回 $UNIFIED_RESPONSE_CLASS 对象 | 检查接口签名 |
| C003_002 | 成功码 | 成功时 code 定义：[待确认，阅读返回类后填写] | 检查返回类 |
| C003_003 | 失败码 | 失败时 code 定义：[待确认] | 检查返回类 |
| C003_004 | 禁止裸返回 | 禁止直接返回 Map/字符串/实体裸对象 | 代码审查 |

## 快速验证命令

\`\`\`bash
grep -r "$UNIFIED_RESPONSE_CLASS" src/ | wc -l
\`\`\`

## 关联 Skills

- [DETAILED_003](../detailed/SKILL_DETAILED_003_统一返回格式.md)
EOF
echo "  -> core/SKILL_CORE_003_返回格式.md"
fi

# CORE_004 数据源
if [ "$HAS_MULTI_DS" = 1 ]; then
cat > "$OUTPUT_PATH/core/SKILL_CORE_004_数据源与表.md" << EOF
---
skill_id: CORE_004
skill_name: 数据源与表核心约束
layer: core
force_level: mandatory
tags:
  - 数据源
  - $DATABASE
---

# SKILL_CORE_004：数据源与表核心约束

## 核心规则（必须遵守）

| 规则ID | 规则名称 | 约束内容 | 验证方法 |
|--------|----------|----------|----------|
| C004_001 | 多数据源 | 必须使用 @DS 注解切换数据源（当前出现 $DS_COUNT 次） | 检查 @DS 注解 |
| C004_002 | 数据源清单 | 数据源清单与用途：[待确认] | 检查配置文件 |
| C004_003 | 事务一致 | 同一事务内使用相同数据源 | 代码审查 |
| C004_004 | SQL注入防护 | 查询条件必须参数化，禁止字符串拼接 | 检查 SQL |

## 快速验证命令

\`\`\`bash
grep -r "@DS(" src/ | wc -l
\`\`\`

## 关联 Skills

- [DETAILED_009](../detailed/SKILL_DETAILED_009_多数据源使用规范.md)
EOF
echo "  -> core/SKILL_CORE_004_数据源与表.md"
fi

# ---------- 生成 Detailed Skills ----------
echo ""
echo "[2/4] 生成 Detailed Skills..."

# DETAILED_001 技术栈
cat > "$OUTPUT_PATH/detailed/SKILL_DETAILED_001_项目技术栈与约束.md" << EOF
---
skill_id: DETAILED_001
skill_name: 项目技术栈与约束
layer: detailed
force_level: mandatory
related_core:
  - CORE_001
tags:
  - 技术栈
  - 约束
---

# SKILL_DETAILED_001：项目技术栈与约束

## 说明
本文档为详细规范层，包含完整的约束规则、代码模板和验证命令。

## 核心约束摘要

| 规则ID | 规则名称 | 约束内容 |
|--------|----------|----------|
| C001_001 | 语言 | $LANGUAGE$( [ -n "$JAVA_VERSION" ] && echo " $JAVA_VERSION" ) |
| C001_002 | 框架 | $FRAMEWORK$( [ -n "$SPRING_BOOT_VERSION" ] && echo " $SPRING_BOOT_VERSION" ) |
| C001_003 | 数据库 | $DATABASE |
| C001_004 | 构建工具 | $BUILD_TOOL |
| C001_005 | 关键依赖 | ${KEY_DEPS:-待梳理} |

## 详细内容

### 依赖版本清单

> [待确认] 以下为自动检测到的依赖，请人工核实完整版本清单：

| 组件 | 检测版本 | 说明 |
|------|----------|------|
| 语言 | ${JAVA_VERSION:-待确认} | $LANGUAGE |
| 框架 | ${SPRING_BOOT_VERSION:-待确认} | $FRAMEWORK |
| 数据库 | 待确认 | $DATABASE |

### 禁止事项

| 禁止项 | 说明 |
|--------|------|
| ❌ 引入未评审依赖 | 新依赖需团队评审后方可引入 |
| ❌ 擅自升级版本 | 版本升级需评估兼容性影响 |

### 验证检查清单

- [ ] 构建配置中语言版本与本文档一致
- [ ] 框架版本与本文档一致
- [ ] 无未经评审的新依赖

## 关联 Core Skills

- [CORE_001_技术栈](../core/SKILL_CORE_001_技术栈.md)
EOF
echo "  -> detailed/SKILL_DETAILED_001_项目技术栈与约束.md"

# DETAILED_002 分层
if [ "$HAS_LAYERING" = 1 ]; then
cat > "$OUTPUT_PATH/detailed/SKILL_DETAILED_002_代码分层与包结构.md" << EOF
---
skill_id: DETAILED_002
skill_name: 代码分层与包结构
layer: detailed
force_level: mandatory
related_core:
  - CORE_002
tags:
  - 分层
  - 包结构
---

# SKILL_DETAILED_002：代码分层与包结构

## 核心约束摘要

| 规则ID | 规则名称 | 约束内容 |
|--------|----------|----------|
| C002_001 | 分层结构 | 项目分层：$LAYERS_FOUND |
| C002_003 | 基础包 | $( [ -n "$BASE_PACKAGE" ] && echo "$BASE_PACKAGE" || echo "[待确认]" ) |

## 详细内容

### 目录结构（自动检测）

\`\`\`
$( [ "$LANGUAGE" = "java" ] && echo "$BASE_PACKAGE" | sed 's/\./\//g' | xargs -I{} echo "src/main/java/{}/" )
$( for l in $LAYERS_FOUND; do echo "├── $l/"; done )
\`\`\`

### 约束规则

| 规则ID | 约束类型 | 规则描述 | 验证方法 |
|--------|----------|----------|----------|
| C002_002 | mandatory | 禁止跨层调用 [待确认层级关系] | 代码审查 |
| R002_001 | mandatory | 新增代码放入对应分层目录 | 检查路径 |
| R002_002 | recommended | 类命名与所在层一致 | 检查类名 |

### 验证检查清单

- [ ] 新增文件位于正确的分层目录
- [ ] package 声明与目录一致
- [ ] 无跨层调用

## 关联 Core Skills

- [CORE_002_分层架构](../core/SKILL_CORE_002_分层架构.md)
EOF
echo "  -> detailed/SKILL_DETAILED_002_代码分层与包结构.md"
fi

# DETAILED_003 返回格式
if [ "$HAS_RESPONSE" = 1 ]; then
cat > "$OUTPUT_PATH/detailed/SKILL_DETAILED_003_统一返回格式.md" << EOF
---
skill_id: DETAILED_003
skill_name: 统一返回格式
layer: detailed
force_level: mandatory
related_core:
  - CORE_003
tags:
  - 返回格式
  - 接口
---

# SKILL_DETAILED_003：统一返回格式

## 核心约束摘要

| 规则ID | 规则名称 | 约束内容 |
|--------|----------|----------|
| C003_001 | 统一返回 | 所有接口必须返回 $UNIFIED_RESPONSE_CLASS |
| C003_002 | 成功码 | [待确认] |
| C003_003 | 失败码 | [待确认] |

## 详细内容

> [待确认] 请阅读 $UNIFIED_RESPONSE_CLASS 源码，补充以下内容：
> 1. 成功/失败码定义
> 2. 字段结构（如 code/msg/data）
> 3. 标准使用模板

### 验证检查清单

- [ ] 所有对外接口返回 $UNIFIED_RESPONSE_CLASS
- [ ] 无裸 Map/字符串返回

## 关联 Core Skills

- [CORE_003_返回格式](../core/SKILL_CORE_003_返回格式.md)
EOF
echo "  -> detailed/SKILL_DETAILED_003_统一返回格式.md"
fi

# DETAILED_009 多数据源
if [ "$HAS_MULTI_DS" = 1 ]; then
cat > "$OUTPUT_PATH/detailed/SKILL_DETAILED_009_多数据源使用规范.md" << EOF
---
skill_id: DETAILED_009
skill_name: 多数据源使用规范
layer: detailed
force_level: mandatory
related_core:
  - CORE_004
tags:
  - 多数据源
  - $DATABASE
---

# SKILL_DETAILED_009：多数据源使用规范

## 核心约束摘要

| 规则ID | 规则名称 | 约束内容 |
|--------|----------|----------|
| C004_001 | 多数据源 | 必须使用 @DS 注解切换数据源 |
| C004_003 | 事务一致 | 同一事务内使用相同数据源 |

## 详细内容

### 数据源清单

> [待确认] 请从配置文件核实数据源清单与用途：

\`\`\`bash
grep -A 10 "datasource" src/main/resources/application*.yml
\`\`\`

### 代码模板

\`\`\`java
@Mapper
@DS("数据源名")
public interface XxxDao {
    List<XxxDO> queryList();
}
\`\`\`

### 验证检查清单

- [ ] 数据访问类有 @DS 注解
- [ ] 数据源名称与配置一致
- [ ] 同一事务内数据源一致

## 关联 Core Skills

- [CORE_004_数据源与表](../core/SKILL_CORE_004_数据源与表.md)
EOF
echo "  -> detailed/SKILL_DETAILED_009_多数据源使用规范.md"
fi

# ---------- 生成索引 ----------
echo ""
echo "[3/4] 生成 SKILL_CORE_README.md..."

{
cat << EOF
---
skill_id: CORE_README
skill_name: 核心约束总览
layer: core
version: 1.0.0
force_level: mandatory
tags:
  - 核心约束
  - 总览
  - 索引
---

# Skills 核心约束总览

> 由 generate-skills.sh 基于项目自动检测结果生成。项目名称：$PROJECT_NAME（$LANGUAGE / $FRAMEWORK / $DATABASE）。

## 概述

Core层包含项目最核心的约束规则，**必须始终加载**。

## Core Skills清单

| ID | 名称 | 核心内容 | 关联Detailed Skills |
|----|------|----------|---------------------|
| CORE_001 | 技术栈核心约束 | $LANGUAGE、$FRAMEWORK、$DATABASE | DETAILED_001 |
EOF
[ "$HAS_LAYERING" = 1 ] && echo "| CORE_002 | 分层架构核心约束 | 分层：$LAYERS_FOUND | DETAILED_002 |"
[ "$HAS_RESPONSE" = 1 ] && echo "| CORE_003 | 返回格式核心约束 | 统一返回 $UNIFIED_RESPONSE_CLASS | DETAILED_003 |"
[ "$HAS_MULTI_DS" = 1 ] && echo "| CORE_004 | 数据源与表核心约束 | @DS 切换多数据源 | DETAILED_009 |"
cat << EOF

## 任务类型映射

| 任务类型 | 必读Core Skills | 必读Detailed Skills |
|----------|-----------------|---------------------|
| **新增接口** | CORE_001$( [ "$HAS_LAYERING" = 1 ] && echo ", CORE_002" )$( [ "$HAS_RESPONSE" = 1 ] && echo ", CORE_003" ) | DETAILED_001$( [ "$HAS_LAYERING" = 1 ] && echo ", DETAILED_002" )$( [ "$HAS_RESPONSE" = 1 ] && echo ", DETAILED_003" ) |
| **数据访问** | CORE_001$( [ "$HAS_MULTI_DS" = 1 ] && echo ", CORE_004" ) | DETAILED_001$( [ "$HAS_MULTI_DS" = 1 ] && echo ", DETAILED_009" ) |

## 使用说明

1. **常驻加载**：始终加载本文件和所有Core Skills
2. **按需加载**：根据任务类型，加载对应的Detailed Skills
3. **完善标注**：标注 [待确认] 的条目需人工 + AI 核实后补充
EOF
} > "$OUTPUT_PATH/SKILL_CORE_README.md"
echo "  -> SKILL_CORE_README.md"

# ---------- 生成 README ----------
echo ""
echo "[4/4] 生成 README.md..."

{
cat << EOF
# Skills 体系（$PROJECT_NAME）

> 由通用Skills沉淀工程自动生成（$(date '+%Y-%m-%d')）。标注 [待确认] 的条目需人工 + AI 完善。

## 目录结构

\`\`\`
$(basename "$OUTPUT_PATH")/
├── README.md                    # 本文件
├── SKILL_CORE_README.md         # Core Skills 总览
├── core/                        # 核心约束层（常驻上下文）
EOF
for f in "${CORE_FILES[@]}"; do [ -n "$f" ] && echo "│   ├── $f"; done
echo "└── detailed/                    # 详细规范层（按需加载）"
LAST_IDX=$((DETAILED_COUNT))
i=0
for f in "${DETAILED_FILES[@]}"; do
    i=$((i + 1))
    if [ -n "$f" ]; then
        if [ $i -eq $LAST_IDX ]; then echo "    └── $f"; else echo "    ├── $f"; fi
    fi
done
cat << EOF
\`\`\`

## 使用说明

1. **常驻加载**：始终加载 core/ 下所有文件
2. **按需加载**：根据任务类型加载对应 detailed/ 文件
3. **生成代码**：严格按规范生成
4. **自检**：对照规则验证检查清单

## 生成信息

| 项目 | 值 |
|------|-----|
| 语言 | $LANGUAGE |
| 框架 | $FRAMEWORK |
| 数据库 | $DATABASE |
| 部署 | $DEPLOYMENT |
| Core Skills | $CORE_COUNT 个 |
| Detailed Skills | $DETAILED_COUNT 个 |
EOF
} > "$OUTPUT_PATH/README.md"
echo "  -> README.md"

echo ""
echo "=== Skills 生成完成 ==="
echo "输出路径: $OUTPUT_PATH"
echo ""
echo "文件清单:"
find "$OUTPUT_PATH" -type f | sort
echo ""
echo "下一步：人工 + AI 审阅各文件中的 [待确认] 条目并补充完善。"
