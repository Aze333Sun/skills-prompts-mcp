#!/bin/bash
# 通用合规性检查脚本（源码健康度基线检查）
# 用法：bash check-compliance.sh <项目路径> [语言类型]
#   --help  显示帮助信息
# 语言类型：java（默认）/ python / go
#
# 可通过环境变量定制检查规则：
#   RSP_PATTERN  返回格式检查正则（Java 默认 "public Rsp"）
#   LOG_PATTERN  日志规范检查正则（Java 默认 "@Slf4j"）
#
# 注意：此脚本检查的是源码本身的基本规范（结构、返回格式、日志、异常、敏感信息），
#       而非"是否符合生成的 Skills 规范"。Skills 合规性审查需使用 review-prompt.md 配合 AI。
# Windows 下需在 Git Bash 或 WSL 中运行。

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "用法：bash check-compliance.sh <项目路径> [java|python|go]"
    echo ""
    echo "源码健康度基线检查，覆盖 6 项："
    echo "  1. 项目结构（源文件是否存在）"
    echo "  2. 返回格式（统一响应对象使用情况）"
    echo "  3. 日志规范（日志框架使用情况）"
    echo "  4. 异常处理（空 catch 块 / except:pass 检测）"
    echo "  5. 敏感信息（硬编码密码/密钥检测）"
    echo "  6. 配置文件（是否存在配置文件）"
    echo ""
    echo "环境变量："
    echo "  RSP_PATTERN  返回格式检查正则（Java 默认 'public Rsp'）"
    echo "  LOG_PATTERN  日志规范检查正则（Java 默认 '@Slf4j'）"
    exit 0
fi

PROJECT_PATH=$1
LANGUAGE=${2:-java}

if [ -z "$PROJECT_PATH" ]; then
    echo "用法：bash check-compliance.sh <项目路径> [java|python|go]"
    exit 2
fi

echo "=== Skills 合规性自动检查 ==="
echo "项目路径: $PROJECT_PATH"
echo "语言类型: $LANGUAGE"
echo ""

ERROR_COUNT=0
WARNING_COUNT=0

# 源码根目录（按语言区分）
case "$LANGUAGE" in
    java)   SRC_DIR="$PROJECT_PATH/src/main/java" ;;
    python) SRC_DIR="$PROJECT_PATH" ;;
    go)     SRC_DIR="$PROJECT_PATH" ;;
    *)      SRC_DIR="$PROJECT_PATH" ;;
esac

# 1. 检查项目结构
echo "[1/6] 检查项目结构..."
if [ "$LANGUAGE" = "java" ]; then
    if find "$SRC_DIR" -name "*.java" 2>/dev/null | head -1 | grep -q "."; then
        echo "  ✅ Java 源文件存在"
    else
        echo "  ❌ 未找到 Java 源文件"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
elif [ "$LANGUAGE" = "python" ]; then
    if find "$PROJECT_PATH" -name "*.py" 2>/dev/null | head -1 | grep -q "."; then
        echo "  ✅ Python 源文件存在"
    else
        echo "  ❌ 未找到 Python 源文件"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
elif [ "$LANGUAGE" = "go" ]; then
    if [ -f "$PROJECT_PATH/go.mod" ]; then
        echo "  ✅ Go 模块文件存在"
    else
        echo "  ❌ 未找到 go.mod"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
fi

# 2. 检查返回格式
echo "[2/6] 检查返回格式..."
if [ "$LANGUAGE" = "java" ]; then
    RSP_PATTERN=${RSP_PATTERN:-"public Rsp"}
    RSP_COUNT=$(grep -r "$RSP_PATTERN" "$SRC_DIR" 2>/dev/null | wc -l)
    if [ "$RSP_COUNT" -gt 0 ]; then
        echo "  ✅ 发现 $RSP_COUNT 处统一返回格式（$RSP_PATTERN）"
    else
        echo "  ⚠️  未发现统一返回格式（可用 RSP_PATTERN 环境变量定制）"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
else
    echo "  ℹ️  $LANGUAGE 项目无内置统一返回格式检查，请在项目 Skills 中定义并用 AI 审查"
fi

# 3. 检查日志规范
echo "[3/6] 检查日志规范..."
if [ "$LANGUAGE" = "java" ]; then
    LOG_PATTERN=${LOG_PATTERN:-"@Slf4j"}
    LOG_COUNT=$(grep -r "$LOG_PATTERN" "$SRC_DIR" 2>/dev/null | wc -l)
    if [ "$LOG_COUNT" -gt 0 ]; then
        echo "  ✅ 发现 $LOG_COUNT 处日志注解（$LOG_PATTERN）"
    else
        echo "  ⚠️  未发现日志注解（可用 LOG_PATTERN 环境变量定制）"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
elif [ "$LANGUAGE" = "python" ]; then
    LOG_COUNT=$(grep -rE "logging\.getLogger|logger\.(info|error|warning|debug)" "$SRC_DIR" --include="*.py" 2>/dev/null | wc -l)
    if [ "$LOG_COUNT" -gt 0 ]; then
        echo "  ✅ 发现 $LOG_COUNT 处 logging 使用"
    else
        echo "  ⚠️  未发现 logging 使用"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
elif [ "$LANGUAGE" = "go" ]; then
    LOG_COUNT=$(grep -rE "log\.|zap\.|logrus\." "$SRC_DIR" --include="*.go" 2>/dev/null | wc -l)
    if [ "$LOG_COUNT" -gt 0 ]; then
        echo "  ✅ 发现 $LOG_COUNT 处日志调用"
    else
        echo "  ⚠️  未发现日志调用"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
fi

# 4. 检查异常处理（禁止吞异常）
echo "[4/6] 检查异常处理..."
if [ "$LANGUAGE" = "java" ]; then
    SWALLOW_COUNT=$(grep -rE "catch\s*\([^)]*\)\s*\{\s*\}" "$SRC_DIR" 2>/dev/null | wc -l)
    if [ "$SWALLOW_COUNT" -eq 0 ]; then
        echo "  ✅ 无空 catch 块（吞异常）"
    else
        echo "  ❌ 发现 $SWALLOW_COUNT 处吞异常（空 catch 块）"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
elif [ "$LANGUAGE" = "python" ]; then
    SWALLOW_COUNT=$(grep -rE "except[^:]*:\s*pass\s*$" "$SRC_DIR" --include="*.py" 2>/dev/null | wc -l)
    if [ "$SWALLOW_COUNT" -eq 0 ]; then
        echo "  ✅ 无 except: pass（吞异常）"
    else
        echo "  ❌ 发现 $SWALLOW_COUNT 处 except: pass"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
elif [ "$LANGUAGE" = "go" ]; then
    IGNORE_COUNT=$(grep -rE "^\s*_\s*=\s*[a-zA-Z_]+[a-zA-Z0-9_.]*\(" "$SRC_DIR" --include="*.go" 2>/dev/null | wc -l)
    if [ "$IGNORE_COUNT" -eq 0 ]; then
        echo "  ✅ 未发现显式忽略返回值（_ = func(...)）"
    else
        echo "  ⚠️  发现 $IGNORE_COUNT 处 _ = 赋值，请人工确认是否忽略错误"
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi
fi

# 5. 检查敏感信息
echo "[5/6] 检查敏感信息..."
SENSITIVE_COUNT=$(grep -rE "(password|secret|key|token)\s*=\s*['\"][^'\"]+['\"]" "$SRC_DIR" 2>/dev/null | grep -v "test\|Test\|example\|Example" | wc -l)
if [ "$SENSITIVE_COUNT" -eq 0 ]; then
    echo "  ✅ 未发现硬编码敏感信息"
else
    echo "  ❌ 发现 $SENSITIVE_COUNT 处硬编码敏感信息"
    grep -rE "(password|secret|key|token)\s*=\s*['\"][^'\"]+['\"]" "$SRC_DIR" 2>/dev/null | grep -v "test\|Test\|example\|Example" | head -5
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# 6. 检查配置文件
echo "[6/6] 检查配置文件..."
CONFIG_COUNT=$(find "$PROJECT_PATH" -maxdepth 3 -type f \( -name "*.yml" -o -name "*.yaml" -o -name "*.properties" -o -name "*.json" -o -name "*.toml" -o -name "*.ini" \) 2>/dev/null | wc -l)
if [ "$CONFIG_COUNT" -gt 0 ]; then
    echo "  ✅ 发现 $CONFIG_COUNT 个配置文件"
else
    echo "  ⚠️  未找到配置文件"
    WARNING_COUNT=$((WARNING_COUNT + 1))
fi

echo ""
echo "=== 检查完成 ==="
echo "错误数: $ERROR_COUNT"
echo "警告数: $WARNING_COUNT"

if [ $ERROR_COUNT -eq 0 ]; then
    echo "✅ 基本检查通过（警告项请结合 工具/review-prompt.md 做 AI 深度审查）"
    exit 0
else
    echo "❌ 发现 $ERROR_COUNT 个问题，请检查"
    exit 1
fi
