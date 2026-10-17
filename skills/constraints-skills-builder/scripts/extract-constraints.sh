#!/bin/bash
# 约束提取脚本（通用）
# 用法：bash extract-constraints.sh <项目路径> <输出路径> [分析结果路径] [语言]
#   --help  显示帮助信息
#
# 功能：
#   1. 自动检测项目的语言、框架、数据库、构建工具
#   2. 消费 analyze-project.sh 的分析输出（如提供），并直接扫描源码补充检测
#   3. 按 7 个维度输出"已检测 + 待人工确认"的约束清单
#   4. 输出 detected-facts.env（KEY=VALUE），供 generate-skills.sh 消费
#
# 说明：自动检测能覆盖"可观测事实"（技术栈、分层、返回类、异常体系等），
#       业务语义类约束仍需人工 + AI 审阅补充（各文件中的 [待确认] 项）。
# 环境：Windows 下请在 Git Bash / WSL 中运行。

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "用法：bash extract-constraints.sh <项目路径> <输出路径> [分析结果路径] [语言]"
    echo ""
    echo "从项目源码提取开发约束，输出到 <输出路径>/ 目录："
    echo "  detected-facts.env         机器可读事实（供 generate-skills.sh 消费）"
    echo "  tech-stack-constraints.md  技术栈约束"
    echo "  architecture-constraints.md 架构约束"
    echo "  response-constraints.md    返回格式约束"
    echo "  security-constraints.md    安全约束"
    echo "  data-access-constraints.md 数据访问约束"
    echo "  coding-constraints.md      编码规范约束"
    echo "  deployment-constraints.md  部署约束"
    echo ""
    echo "参数："
    echo "  分析结果路径  analyze-project.sh 的输出目录（可选）"
    echo "  语言          手动指定语言（可选，自动检测优先）"
    exit 0
fi

PROJECT_PATH=$1
OUTPUT_PATH=$2
ANALYSIS_PATH=$3
LANGUAGE=$4

if [ -z "$PROJECT_PATH" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "用法：bash extract-constraints.sh <项目路径> <输出路径> [分析结果路径] [语言]"
    exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
    echo "错误：项目路径不存在：$PROJECT_PATH"
    exit 2
fi

mkdir -p "$OUTPUT_PATH"

echo "=== 约束提取开始 ==="
echo "项目路径: $PROJECT_PATH"
echo "输出路径: $OUTPUT_PATH"
[ -n "$ANALYSIS_PATH" ] && echo "分析结果: $ANALYSIS_PATH"
echo ""

# ---------- 工具函数 ----------

# 读取分析输出文件（不存在时返回空）
read_analysis() {
    local f="$ANALYSIS_PATH/$1"
    if [ -n "$ANALYSIS_PATH" ] && [ -f "$f" ]; then
        cat "$f"
    fi
}

# 计数
count_lines() {
    if [ -z "$1" ]; then echo 0; else echo "$1" | grep -c .; fi
}

# ---------- 0. 语言与构建工具检测 ----------
echo "[0/9] 检测语言与构建工具..."

BUILD_TOOL="未检测到"
if [ -f "$PROJECT_PATH/pom.xml" ]; then
    BUILD_TOOL="maven"
elif ls "$PROJECT_PATH"/build.gradle* >/dev/null 2>&1; then
    BUILD_TOOL="gradle"
elif [ -f "$PROJECT_PATH/go.mod" ]; then
    BUILD_TOOL="go-modules"
elif [ -f "$PROJECT_PATH/package.json" ]; then
    BUILD_TOOL="npm"
elif [ -f "$PROJECT_PATH/requirements.txt" ] || [ -f "$PROJECT_PATH/pyproject.toml" ] || [ -f "$PROJECT_PATH/setup.py" ]; then
    BUILD_TOOL="pip"
elif [ -f "$PROJECT_PATH/Cargo.toml" ]; then
    BUILD_TOOL="cargo"
fi

if [ -z "$LANGUAGE" ]; then
    case "$BUILD_TOOL" in
        maven|gradle) LANGUAGE="java" ;;
        go-modules) LANGUAGE="go" ;;
        npm)
            LANGUAGE="nodejs"
            if grep -q '"typescript"' "$PROJECT_PATH/package.json" 2>/dev/null; then
                LANGUAGE="typescript"
            fi
            ;;
        pip) LANGUAGE="python" ;;
        cargo) LANGUAGE="rust" ;;
    esac
fi

# 兜底：从 analyze 的 languages.txt 推断
if [ -z "$LANGUAGE" ]; then
    TOP_EXT=$(read_analysis "languages.txt" | head -1 | awk '{print $2}')
    case "$TOP_EXT" in
        java) LANGUAGE="java" ;;
        py) LANGUAGE="python" ;;
        go) LANGUAGE="go" ;;
        js) LANGUAGE="nodejs" ;;
        ts) LANGUAGE="typescript" ;;
        *) LANGUAGE="unknown" ;;
    esac
fi
echo "  语言: $LANGUAGE | 构建工具: $BUILD_TOOL"

# 源码根目录
case "$LANGUAGE" in
    java) SRC_DIR="$PROJECT_PATH/src/main/java" ;;
    *)    SRC_DIR="$PROJECT_PATH" ;;
esac

# ---------- 1. 框架与数据库检测 ----------
echo "[1/9] 检测框架与数据库..."

FRAMEWORK="未检测到"
DATABASE="未检测到"
KEY_DEPS=""

if [ "$LANGUAGE" = "java" ]; then
    DEP_FILE=""
    [ -f "$PROJECT_PATH/pom.xml" ] && DEP_FILE="$PROJECT_PATH/pom.xml"
    [ -z "$DEP_FILE" ] && DEP_FILE=$(ls "$PROJECT_PATH"/build.gradle* 2>/dev/null | head -1)
    if [ -n "$DEP_FILE" ]; then
        grep -q "spring-boot" "$DEP_FILE" && FRAMEWORK="spring-boot"
        grep -q "spring-cloud" "$DEP_FILE" && FRAMEWORK="$FRAMEWORK+spring-cloud"
        grep -q "mybatis" "$DEP_FILE" && KEY_DEPS="$KEY_DEPS mybatis"
        grep -q "druid" "$DEP_FILE" && KEY_DEPS="$KEY_DEPS druid"
        grep -q "dynamic-datasource" "$DEP_FILE" && KEY_DEPS="$KEY_DEPS dynamic-datasource"
        grep -qi "oceanbase" "$DEP_FILE" && DATABASE="oceanbase"
        grep -qi "mysql" "$DEP_FILE" && [ "$DATABASE" = "未检测到" ] && DATABASE="mysql"
        grep -qi "postgresql" "$DEP_FILE" && [ "$DATABASE" = "未检测到" ] && DATABASE="postgresql"
        grep -qi "oracle" "$DEP_FILE" && [ "$DATABASE" = "未检测到" ] && DATABASE="oracle"
    fi
    SPRING_BOOT_VERSION=$(grep -A2 "spring-boot-starter-parent" "$PROJECT_PATH/pom.xml" 2>/dev/null | grep -oE "<version>[^<]+" | head -1 | sed 's/<version>//')
    JAVA_VERSION=$(grep -oE "<java.version>[^<]+" "$PROJECT_PATH/pom.xml" 2>/dev/null | head -1 | sed 's/<java.version>//')
elif [ "$LANGUAGE" = "python" ]; then
    REQ_FILE=""
    [ -f "$PROJECT_PATH/requirements.txt" ] && REQ_FILE="$PROJECT_PATH/requirements.txt"
    [ -z "$REQ_FILE" ] && [ -f "$PROJECT_PATH/pyproject.toml" ] && REQ_FILE="$PROJECT_PATH/pyproject.toml"
    if [ -n "$REQ_FILE" ]; then
        grep -qi "django" "$REQ_FILE" && FRAMEWORK="django"
        grep -qi "fastapi" "$REQ_FILE" && [ "$FRAMEWORK" = "未检测到" ] && FRAMEWORK="fastapi"
        grep -qi "flask" "$REQ_FILE" && [ "$FRAMEWORK" = "未检测到" ] && FRAMEWORK="flask"
        grep -qi "sqlalchemy" "$REQ_FILE" && KEY_DEPS="$KEY_DEPS sqlalchemy"
        grep -qi "psycopg" "$REQ_FILE" && DATABASE="postgresql"
        grep -qi "mysqlclient\|pymysql" "$REQ_FILE" && [ "$DATABASE" = "未检测到" ] && DATABASE="mysql"
    fi
elif [ "$LANGUAGE" = "go" ]; then
    if [ -f "$PROJECT_PATH/go.mod" ]; then
        grep -q "gin-gonic/gin" "$PROJECT_PATH/go.mod" && FRAMEWORK="gin"
        grep -q "labstack/echo" "$PROJECT_PATH/go.mod" && [ "$FRAMEWORK" = "未检测到" ] && FRAMEWORK="echo"
        grep -q "gorm.io/gorm" "$PROJECT_PATH/go.mod" && KEY_DEPS="$KEY_DEPS gorm"
    fi
elif [ "$LANGUAGE" = "nodejs" ] || [ "$LANGUAGE" = "typescript" ]; then
    if [ -f "$PROJECT_PATH/package.json" ]; then
        grep -q '"express"' "$PROJECT_PATH/package.json" && FRAMEWORK="express"
        grep -q '"@nestjs/core"' "$PROJECT_PATH/package.json" && [ "$FRAMEWORK" = "未检测到" ] && FRAMEWORK="nestjs"
        grep -q '"vue"' "$PROJECT_PATH/package.json" && FRAMEWORK="$FRAMEWORK+vue"
        grep -q '"react"' "$PROJECT_PATH/package.json" && FRAMEWORK="$FRAMEWORK+react"
    fi
fi

# 从配置文件兜底检测数据库
if [ "$DATABASE" = "未检测到" ]; then
    DB_HINT=$(grep -rhoE "jdbc:(mysql|oracle|postgresql|oceanbase)" "$PROJECT_PATH/src" 2>/dev/null | head -1 | sed 's/jdbc://')
    [ -n "$DB_HINT" ] && DATABASE="$DB_HINT"
fi

echo "  框架: $FRAMEWORK | 数据库: $DATABASE | 关键依赖:$KEY_DEPS"

# ---------- 2. 架构分层检测 ----------
echo "[2/9] 检测架构分层..."

LAYERS_FOUND=""
if [ "$LANGUAGE" = "java" ]; then
    for layer in controller service dao mapper repository entity; do
        if find "$SRC_DIR" -type d -name "$layer" 2>/dev/null | head -1 | grep -q .; then
            LAYERS_FOUND="$LAYERS_FOUND $layer"
        fi
    done
elif [ "$LANGUAGE" = "python" ] && [ "$FRAMEWORK" = "django" ]; then
    [ -f "$PROJECT_PATH/manage.py" ] && LAYERS_FOUND=" views models urls"
elif [ "$LANGUAGE" = "go" ]; then
    for layer in handler handler controller service repo repository dao; do
        if find "$PROJECT_PATH" -type d -name "$layer" -not -path "*/vendor/*" 2>/dev/null | head -1 | grep -q .; then
            LAYERS_FOUND="$LAYERS_FOUND $layer"
        fi
    done
    LAYERS_FOUND=$(echo "$LAYERS_FOUND" | tr ' ' '\n' | sort -u | tr '\n' ' ')
fi
LAYERS_FOUND=$(echo "$LAYERS_FOUND" | sed 's/^ //; s/ $//')

BASE_PACKAGE=""
if [ "$LANGUAGE" = "java" ]; then
    APP_FILE=$(grep -rl "@SpringBootApplication" "$SRC_DIR" 2>/dev/null | head -1)
    if [ -n "$APP_FILE" ]; then
        # 不使用 ^ 锚定，兼容带 BOM 的源文件
        BASE_PACKAGE=$(grep -oE "package [a-zA-Z0-9_.]+" "$APP_FILE" | head -1 | sed 's/^package //')
    fi
fi
echo "  分层:$LAYERS_FOUND | 基础包: ${BASE_PACKAGE:-未检测到}"

# ---------- 3. 统一返回格式检测 ----------
echo "[3/9] 检测统一返回格式..."

UNIFIED_RESPONSE_CLASS=""
RESP_CANDIDATES=$(read_analysis "response-format.txt")
if [ -z "$RESP_CANDIDATES" ]; then
    RESP_CANDIDATES=$(find "$SRC_DIR" -type f \( -name "*Rsp.*" -o -name "*Result.*" -o -name "*ApiResponse.*" -o -name "*Response.*" \) 2>/dev/null)
fi
if [ -n "$RESP_CANDIDATES" ]; then
    FIRST_RESP=$(echo "$RESP_CANDIDATES" | head -1)
    UNIFIED_RESPONSE_CLASS=$(basename "$FIRST_RESP" | sed -E 's/\.(java|py|go|ts|js)$//')
fi
RESP_FILE_COUNT=$(count_lines "$RESP_CANDIDATES")
echo "  候选返回类: $RESP_FILE_COUNT 个，首选: ${UNIFIED_RESPONSE_CLASS:-未检测到}"

# ---------- 4. 异常体系检测 ----------
echo "[4/9] 检测异常体系..."

EXCEPTION_CLASSES=$(read_analysis "exceptions.txt")
[ -z "$EXCEPTION_CLASSES" ] && EXCEPTION_CLASSES=$(find "$SRC_DIR" -type f -name "*Exception.*" 2>/dev/null)
EXCEPTION_COUNT=$(count_lines "$EXCEPTION_CLASSES")
CUSTOM_EXCEPTION_NAMES=$(echo "$EXCEPTION_CLASSES" | while read -r f; do [ -n "$f" ] && basename "$f" | sed -E 's/\.(java|py|go|ts|js)$//'; done | tr '\n' ',' | sed 's/,$//')

HAS_GLOBAL_HANDLER="false"
if [ "$LANGUAGE" = "java" ]; then
    grep -rq "@RestControllerAdvice\|@ControllerAdvice" "$SRC_DIR" 2>/dev/null && HAS_GLOBAL_HANDLER="true"
elif [ "$LANGUAGE" = "python" ]; then
    grep -rq "exception_handler\|@app.exception" "$SRC_DIR" --include="*.py" 2>/dev/null && HAS_GLOBAL_HANDLER="true"
fi
SWALLOW_COUNT=0
if [ "$LANGUAGE" = "java" ]; then
    SWALLOW_COUNT=$(grep -rE "catch\s*\([^)]*\)\s*\{\s*\}" "$SRC_DIR" 2>/dev/null | wc -l | tr -d ' ')
elif [ "$LANGUAGE" = "python" ]; then
    SWALLOW_COUNT=$(grep -rE "except[^:]*:\s*pass\s*$" "$SRC_DIR" --include="*.py" 2>/dev/null | wc -l | tr -d ' ')
fi
echo "  自定义异常: $EXCEPTION_COUNT 个 | 全局处理器: $HAS_GLOBAL_HANDLER | 吞异常: $SWALLOW_COUNT 处"

# ---------- 5. 数据访问检测 ----------
echo "[5/9] 检测数据访问模式..."

DATASOURCE_MODE="unknown"
DS_COUNT=0
if [ "$LANGUAGE" = "java" ]; then
    DS_COUNT=$(grep -r "@DS(" "$SRC_DIR" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$DS_COUNT" -gt 0 ] || echo "$KEY_DEPS" | grep -q "dynamic-datasource"; then
        DATASOURCE_MODE="dynamic-multi"
    fi
fi
DS_HINTS=$(read_analysis "datasource.txt")
if [ "$DATASOURCE_MODE" = "unknown" ] && [ -n "$DS_HINTS" ] && ! echo "$DS_HINTS" | grep -q "未找到"; then
    DATASOURCE_MODE="configured"
fi

ENTITY_FILES=$(read_analysis "entities.txt")
[ -z "$ENTITY_FILES" ] && ENTITY_FILES=$(find "$SRC_DIR" -type f \( -name "*DTO.*" -o -name "*VO.*" -o -name "*DO.*" -o -name "*Entity.*" -o -name "*Model.*" \) 2>/dev/null)
ENTITY_COUNT=$(count_lines "$ENTITY_FILES")
ENTITY_SUFFIXES=$(echo "$ENTITY_FILES" | grep -oE '(DO|DTO|VO|PO|Entity|Model|Schema)\.(java|py|go|ts|js)$' | sed -E 's/\.(java|py|go|ts|js)$//' | sort -u | tr '\n' ',' | sed 's/,$//')
echo "  数据源模式: $DATASOURCE_MODE（@DS 出现 $DS_COUNT 次）| 实体: $ENTITY_COUNT 个，后缀: ${ENTITY_SUFFIXES:-无}"

# ---------- 6. 编码规范信号检测 ----------
echo "[6/9] 检测编码规范信号..."

LOGGING_FRAMEWORK="未检测到"
if [ "$LANGUAGE" = "java" ]; then
    SLF4J_COUNT=$(grep -r "@Slf4j" "$SRC_DIR" 2>/dev/null | wc -l | tr -d ' ')
    [ "$SLF4J_COUNT" -gt 0 ] && LOGGING_FRAMEWORK="slf4j+lombok(@Slf4j x$SLF4J_COUNT)"
elif [ "$LANGUAGE" = "python" ]; then
    grep -rq "logging.getLogger\|import logging" "$SRC_DIR" --include="*.py" 2>/dev/null && LOGGING_FRAMEWORK="logging"
elif [ "$LANGUAGE" = "go" ]; then
    grep -rqE "zap\.|logrus\.|log\." "$SRC_DIR" --include="*.go" 2>/dev/null && LOGGING_FRAMEWORK="go-log/zap/logrus"
fi

HAS_SCHEDULED_TASKS="false"
SCHEDULED_COUNT=0
if [ "$LANGUAGE" = "java" ]; then
    SCHEDULED_COUNT=$(grep -r "@Scheduled\|@XxlJob" "$SRC_DIR" 2>/dev/null | wc -l | tr -d ' ')
    [ "$SCHEDULED_COUNT" -gt 0 ] && HAS_SCHEDULED_TASKS="true"
fi

TEST_FILES=$(read_analysis "tests.txt")
[ -z "$TEST_FILES" ] && TEST_FILES=$(find "$PROJECT_PATH" -path "*/test/*" -type f \( -name "*Test.*" -o -name "*_test.*" -o -name "test_*" \) 2>/dev/null | head -20)
TEST_COUNT=$(count_lines "$TEST_FILES")
echo "  日志: $LOGGING_FRAMEWORK | 定时任务: $SCHEDULED_COUNT 处 | 测试文件: $TEST_COUNT 个"

# ---------- 7. 安全扫描 ----------
echo "[7/9] 安全扫描..."

SECRET_COUNT=$(grep -rE "(password|secret|key|token)\s*=\s*['\"][^'\"]+['\"]" "$SRC_DIR" 2>/dev/null | grep -v "test\|Test\|example\|Example" | wc -l | tr -d ' ')
HAS_AUTH_ANNOTATION="false"
if [ "$LANGUAGE" = "java" ]; then
    grep -rq "@PreAuthorize\|@Secured\|@RequiresPermissions" "$SRC_DIR" 2>/dev/null && HAS_AUTH_ANNOTATION="true"
fi
echo "  硬编码敏感信息: $SECRET_COUNT 处 | 权限注解: $HAS_AUTH_ANNOTATION"

# ---------- 8. 部署形态检测 ----------
echo "[8/9] 检测部署形态..."

DEPLOYMENT="unknown"
[ -f "$PROJECT_PATH/Dockerfile" ] && DEPLOYMENT="docker"
if find "$PROJECT_PATH" -maxdepth 3 -type d \( -name "k8s" -o -name "kubernetes" -o -name "deploy" -o -name "helm" \) 2>/dev/null | head -1 | grep -q .; then
    DEPLOYMENT="$DEPLOYMENT+k8s"
fi
PROFILE_COUNT=$(find "$PROJECT_PATH" -maxdepth 4 -type f -name "application-*.yml" -o -maxdepth 4 -type f -name "application-*.properties" 2>/dev/null | wc -l | tr -d ' ')
echo "  部署: $DEPLOYMENT | 环境 Profile: $PROFILE_COUNT 个"

# ---------- 9. 外部系统检测 ----------
echo "[9/9] 检测外部系统..."

EXTERNAL_HOSTS=$(read_analysis "external-systems.txt" | grep -oE "https?://[a-zA-Z0-9.-]+" | sort -u | tr '\n' ',' | sed 's/,$//')
if [ -z "$EXTERNAL_HOSTS" ]; then
    EXTERNAL_HOSTS=$(grep -rhoE "https?://[a-zA-Z0-9.-]+" "$SRC_DIR" 2>/dev/null | grep -v "localhost\|127.0.0.1\|example" | sort -u | head -20 | tr '\n' ',' | sed 's/,$//')
fi
EXTERNAL_COUNT=$(echo "$EXTERNAL_HOSTS" | tr ',' '\n' | grep -c .)
echo "  外部系统主机: $EXTERNAL_COUNT 个"

# ---------- 输出 detected-facts.env ----------
PROJECT_NAME=$(basename "$(cd "$PROJECT_PATH" && pwd)")
cat > "$OUTPUT_PATH/detected-facts.env" << EOF
# 由 extract-constraints.sh 自动生成，供 generate-skills.sh 消费
PROJECT_NAME=$PROJECT_NAME
LANGUAGE=$LANGUAGE
BUILD_TOOL=$BUILD_TOOL
FRAMEWORK=$FRAMEWORK
DATABASE=$DATABASE
SPRING_BOOT_VERSION=${SPRING_BOOT_VERSION:-}
JAVA_VERSION=${JAVA_VERSION:-}
KEY_DEPS=$(echo "$KEY_DEPS" | sed 's/^ //')
LAYERS_FOUND=$LAYERS_FOUND
BASE_PACKAGE=$BASE_PACKAGE
UNIFIED_RESPONSE_CLASS=$UNIFIED_RESPONSE_CLASS
EXCEPTION_CLASSES=$CUSTOM_EXCEPTION_NAMES
HAS_GLOBAL_EXCEPTION_HANDLER=$HAS_GLOBAL_HANDLER
SWALLOW_COUNT=$SWALLOW_COUNT
DATASOURCE_MODE=$DATASOURCE_MODE
DS_COUNT=$DS_COUNT
ENTITY_COUNT=$ENTITY_COUNT
ENTITY_SUFFIXES=$ENTITY_SUFFIXES
LOGGING_FRAMEWORK=$LOGGING_FRAMEWORK
HAS_SCHEDULED_TASKS=$HAS_SCHEDULED_TASKS
SCHEDULED_COUNT=$SCHEDULED_COUNT
TEST_COUNT=$TEST_COUNT
SECRET_COUNT=$SECRET_COUNT
HAS_AUTH_ANNOTATION=$HAS_AUTH_ANNOTATION
DEPLOYMENT=$DEPLOYMENT
PROFILE_COUNT=$PROFILE_COUNT
EXTERNAL_HOSTS=$EXTERNAL_HOSTS
EXTERNAL_COUNT=$EXTERNAL_COUNT
EOF
echo ""
echo "  -> detected-facts.env 已生成"

# ---------- 生成约束清单文件 ----------
NOT_DETECTED="未检测到，需人工确认"

cat > "$OUTPUT_PATH/tech-stack-constraints.md" << EOF
# 技术栈约束

> 检测来源：extract-constraints.sh 自动扫描。标注 [待确认] 的条目需人工 + AI 核实后定稿。

## 强制约束

- [x] 必须使用语言：$LANGUAGE [已检测]
- [x] 构建工具：$BUILD_TOOL [已检测]
- [x] 框架：$FRAMEWORK [已检测]
- [x] 数据库：$DATABASE [已检测]
$( [ -n "$SPRING_BOOT_VERSION" ] && echo "- [x] Spring Boot 版本：$SPRING_BOOT_VERSION [已检测]" )
$( [ -n "$JAVA_VERSION" ] && echo "- [x] Java 版本：$JAVA_VERSION [已检测]" )
- [ ] 关键依赖锁定版本：${KEY_DEPS:-$NOT_DETECTED} [待确认]
- [ ] 禁止引入未列出的新依赖 [建议采纳]

## 验证命令

\`\`\`bash
# 核对依赖清单与版本
$( [ "$BUILD_TOOL" = "maven" ] && echo "grep -E '<(groupId|artifactId|version)>' pom.xml" )
$( [ "$BUILD_TOOL" = "gradle" ] && echo "grep -E 'implementation|api' build.gradle" )
$( [ "$BUILD_TOOL" = "pip" ] && echo "cat requirements.txt" )
$( [ "$BUILD_TOOL" = "go-modules" ] && echo "cat go.mod" )
$( [ "$BUILD_TOOL" = "npm" ] && echo "cat package.json" )
\`\`\`
EOF

cat > "$OUTPUT_PATH/architecture-constraints.md" << EOF
# 架构约束

## 检测结果

- 发现的分层目录：${LAYERS_FOUND:-未发现明确分层目录}
- 基础包路径：${BASE_PACKAGE:-$NOT_DETECTED}

## 强制约束

$( if [ -n "$LAYERS_FOUND" ]; then
echo "- [x] 项目采用分层架构，目录：$LAYERS_FOUND [已检测]"
echo "- [ ] 禁止跨层调用（如 Controller 直接调 DAO）[建议采纳，需按项目实际确认]"
else
echo "- [ ] 分层结构：$NOT_DETECTED"
fi )
- [ ] 各层职责边界：[待确认，需人工 + AI 按项目实际填写]

## 验证命令

\`\`\`bash
# 查看分层目录
find . -type d \( -name "controller" -o -name "service" -o -name "dao" \) -not -path "*/target/*"
\`\`\`
EOF

cat > "$OUTPUT_PATH/response-constraints.md" << EOF
# 返回格式约束

## 检测结果

- 统一返回类候选：$RESP_FILE_COUNT 个，首选：${UNIFIED_RESPONSE_CLASS:-未发现}

## 强制约束

$( if [ -n "$UNIFIED_RESPONSE_CLASS" ]; then
echo "- [x] 所有接口必须返回统一对象：$UNIFIED_RESPONSE_CLASS [已检测]"
else
echo "- [ ] 统一返回对象：$NOT_DETECTED"
fi )
- [ ] 成功/失败码定义：[待确认，需人工阅读返回类源码后填写]

## 验证命令

\`\`\`bash
$( [ -n "$UNIFIED_RESPONSE_CLASS" ] && echo "grep -r \"$UNIFIED_RESPONSE_CLASS\" src/ | wc -l" || echo "# 先确认统一返回类，再补充验证命令" )
\`\`\`
EOF

cat > "$OUTPUT_PATH/security-constraints.md" << EOF
# 安全约束

## 检测结果

- 硬编码敏感信息：$SECRET_COUNT 处
- 自定义异常类：${CUSTOM_EXCEPTION_NAMES:-无}
- 全局异常处理器：$HAS_GLOBAL_EXCEPTION_HANDLER
- 吞异常（空 catch / except pass）：$SWALLOW_COUNT 处
- 权限注解：$HAS_AUTH_ANNOTATION

## 强制约束

- [ ] 禁止吞异常 [建议采纳]
$( [ "$HAS_GLOBAL_HANDLER" = "true" ] && echo "- [x] 已存在全局异常处理器，异常必须经其统一处理 [已检测]" )
- [ ] 禁止在日志中打印敏感信息 [建议采纳]
- [ ] 禁止返回错误堆栈给前端 [建议采纳]
$( [ "$SECRET_COUNT" -gt 0 ] && echo "- [ ] ⚠️ 检测到 $SECRET_COUNT 处硬编码敏感信息，必须迁移到配置中心/环境变量 [需立即处理]" )

## 验证命令

\`\`\`bash
grep -rE "(password|secret|key|token)\s*=\s*['\"][^'\"]+['\"]" src/ | grep -v test
\`\`\`
EOF

cat > "$OUTPUT_PATH/data-access-constraints.md" << EOF
# 数据访问约束

## 检测结果

- 数据源模式：$DATASOURCE_MODE（@DS 出现 $DS_COUNT 次）
- 数据库：$DATABASE
- 实体文件：$ENTITY_COUNT 个，命名后缀：${ENTITY_SUFFIXES:-无明显规律}

## 强制约束

$( if [ "$DATASOURCE_MODE" = "dynamic-multi" ]; then
echo "- [x] 多数据源项目，数据源切换必须使用 @DS 注解 [已检测]"
echo "- [ ] 数据源清单与用途：[待确认]"
else
echo "- [ ] 数据源使用方式：$NOT_DETECTED"
fi )
$( if [ -n "$ENTITY_SUFFIXES" ]; then
echo "- [x] 实体命名遵循后缀约定：$ENTITY_SUFFIXES [已检测]"
fi )
- [ ] ORM/SQL 编写规范：[待确认，需人工 + AI 按项目实际填写]

## 验证命令

\`\`\`bash
$( [ "$DATASOURCE_MODE" = "dynamic-multi" ] && echo "grep -r '@DS(' src/ | wc -l" || echo "# 按项目实际补充" )
\`\`\`
EOF

cat > "$OUTPUT_PATH/coding-constraints.md" << EOF
# 编码规范约束

## 检测结果

- 日志框架：$LOGGING_FRAMEWORK
- 定时任务：$SCHEDULED_COUNT 处（@Scheduled/@XxlJob）
- 测试文件：$TEST_COUNT 个

## 强制约束

$( [ "$LOGGING_FRAMEWORK" != "未检测到" ] && echo "- [x] 日志统一使用：$LOGGING_FRAMEWORK [已检测]" )
- [ ] 命名规范：[待确认]
- [ ] 注释要求：[待确认]
$( [ "$TEST_COUNT" -eq 0 ] && echo "- [ ] ⚠️ 未发现测试文件，建议补充测试基线约束 [建议采纳]" )

## 验证命令

\`\`\`bash
$( [ "$LANGUAGE" = "java" ] && echo "grep -r '@Slf4j' src/ | wc -l" )
$( [ "$LANGUAGE" = "python" ] && echo "grep -r 'logging.getLogger' . --include='*.py' | wc -l" )
\`\`\`
EOF

cat > "$OUTPUT_PATH/deployment-constraints.md" << EOF
# 部署约束

## 检测结果

- 部署形态：$DEPLOYMENT
- 环境 Profile：$PROFILE_COUNT 个

## 强制约束

$( [ "$DEPLOYMENT" != "unknown" ] && echo "- [x] 部署方式：$DEPLOYMENT [已检测]" )
$( [ "$PROFILE_COUNT" -gt 0 ] && echo "- [x] 环境配置通过 Profile 分离（共 $PROFILE_COUNT 个）[已检测]" )
- [ ] 健康检查接口：[待确认]
- [ ] 环境清单（如 dev/test/prod）：[待确认]
- [ ] 禁止硬编码环境配置 [建议采纳]
EOF

# ---------- 汇总 ----------
TODO_COUNT=$(grep -rh "\[待确认\]" "$OUTPUT_PATH"/*.md 2>/dev/null | wc -l | tr -d ' ')
cat > "$OUTPUT_PATH/EXTRACTION_SUMMARY.md" << EOF
# 约束提取汇总

> 生成时间：$(date '+%Y-%m-%d %H:%M') | 项目：$PROJECT_NAME | 语言：$LANGUAGE

## 检测结论速览

| 维度 | 检测结果 |
|------|----------|
| 语言/构建 | $LANGUAGE / $BUILD_TOOL |
| 框架 | $FRAMEWORK |
| 数据库 | $DATABASE |
| 分层 | ${LAYERS_FOUND:-未发现} |
| 基础包 | ${BASE_PACKAGE:-未检测到} |
| 统一返回类 | ${UNIFIED_RESPONSE_CLASS:-未发现} |
| 自定义异常 | ${CUSTOM_EXCEPTION_NAMES:-无} |
| 全局异常处理器 | $HAS_GLOBAL_EXCEPTION_HANDLER |
| 数据源模式 | $DATASOURCE_MODE |
| 日志 | $LOGGING_FRAMEWORK |
| 定时任务 | $SCHEDULED_COUNT 处 |
| 测试文件 | $TEST_COUNT 个 |
| 硬编码敏感信息 | $SECRET_COUNT 处 |
| 部署形态 | $DEPLOYMENT |
| 外部系统 | $EXTERNAL_COUNT 个 |

## 输出文件

| 文件 | 内容 |
|------|------|
| detected-facts.env | 机器可读事实（供 generate-skills.sh 消费） |
| tech-stack-constraints.md | 技术栈约束 |
| architecture-constraints.md | 架构约束 |
| response-constraints.md | 返回格式约束 |
| security-constraints.md | 安全约束 |
| data-access-constraints.md | 数据访问约束 |
| coding-constraints.md | 编码规范约束 |
| deployment-constraints.md | 部署约束 |

## 下一步

1. 人工 + AI 审阅各约束文件，处理全部 **[待确认]** 条目（共 $TODO_COUNT 处）
2. 确认后运行 generate-skills.sh 生成 Skills 体系
3. 安全扫描发现的 $SECRET_COUNT 处硬编码敏感信息需优先处理
EOF

echo ""
echo "=== 约束提取完成 ==="
echo "约束文件保存在: $OUTPUT_PATH"
echo "自动检测已完成，剩余 $TODO_COUNT 处 [待确认] 条目需人工 + AI 审阅。"
