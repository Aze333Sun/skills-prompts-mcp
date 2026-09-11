#!/bin/bash
# 通用项目分析脚本
# 用法：bash analyze-project.sh <项目路径> <输出路径>
#   --help  显示帮助信息

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "用法：bash analyze-project.sh <项目路径> <输出路径>"
    echo ""
    echo "分析项目并输出 10 类分析文件到 <输出路径>/ 目录："
    echo "  languages.txt          编程语言统计"
    echo "  build-files.txt        构建文件"
    echo "  directory-structure.txt 目录结构"
    echo "  config-files.txt       配置文件"
    echo "  entities.txt           实体类"
    echo "  datasource.txt         数据源配置"
    echo "  external-systems.txt   外部系统"
    echo "  response-format.txt    统一返回格式"
    echo "  exceptions.txt         异常类"
    echo "  tests.txt              测试文件"
    exit 0
fi

PROJECT_PATH=$1
OUTPUT_PATH=$2

if [ -z "$PROJECT_PATH" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "用法：bash analyze-project.sh <项目路径> <输出路径>"
    exit 1
fi

echo "=== 项目分析开始 ==="
echo "项目路径: $PROJECT_PATH"
echo "输出路径: $OUTPUT_PATH"

mkdir -p "$OUTPUT_PATH"

# 1. 编程语言识别
echo "[1/10] 分析编程语言..."
find "$PROJECT_PATH/src" -type f 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 > "$OUTPUT_PATH/languages.txt"
echo "  -> 保存到 languages.txt"

# 2. 依赖管理文件识别
echo "[2/10] 分析依赖管理..."
find "$PROJECT_PATH" -maxdepth 2 -type f \( -name "pom.xml" -o -name "build.gradle" -o -name "build.gradle.kts" -o -name "package.json" -o -name "go.mod" -o -name "requirements.txt" -o -name "Gemfile" -o -name "Cargo.toml" -o -name "pyproject.toml" \) > "$OUTPUT_PATH/build-files.txt" 2>/dev/null
echo "  -> 保存到 build-files.txt"

# 3. 目录结构分析
echo "[3/10] 分析目录结构..."
find "$PROJECT_PATH/src" -type d 2>/dev/null | head -50 > "$OUTPUT_PATH/directory-structure.txt"
echo "  -> 保存到 directory-structure.txt"

# 4. 配置文件分析
echo "[4/10] 分析配置文件..."
find "$PROJECT_PATH" -maxdepth 3 -type f \( -name "*.yml" -o -name "*.yaml" -o -name "*.properties" -o -name "*.json" -o -name "*.toml" -o -name "*.ini" -o -name "*.conf" \) > "$OUTPUT_PATH/config-files.txt" 2>/dev/null
echo "  -> 保存到 config-files.txt"

# 5. 实体类分析
echo "[5/10] 分析实体类..."
find "$PROJECT_PATH/src" -type f \( -name "*DTO.*" -o -name "*VO.*" -o -name "*DO.*" -o -name "*Model.*" -o -name "*Entity.*" -o -name "*Schema.*" \) > "$OUTPUT_PATH/entities.txt" 2>/dev/null
echo "  -> 保存到 entities.txt"

# 6. 数据源分析
echo "[6/10] 分析数据源..."
grep -r "datasource\|DataSource\|@DS\|DATABASE_URL\|db\.py\|database.yml" "$PROJECT_PATH/src" 2>/dev/null | head -20 > "$OUTPUT_PATH/datasource.txt" || echo "未找到数据源配置" > "$OUTPUT_PATH/datasource.txt"
echo "  -> 保存到 datasource.txt"

# 7. 外部系统分析
echo "[7/10] 分析外部系统..."
grep -rE "http://|https://|grpc://|amqp://|redis://|kafka://" "$PROJECT_PATH/src" 2>/dev/null | grep -v "localhost\|127.0.0.1\|swagger\|example" | head -30 > "$OUTPUT_PATH/external-systems.txt" || echo "未找到外部系统配置" > "$OUTPUT_PATH/external-systems.txt"
echo "  -> 保存到 external-systems.txt"

# 8. 统一返回格式分析
echo "[8/10] 分析返回格式..."
find "$PROJECT_PATH/src" -type f \( -name "*Rsp.*" -o -name "*Result.*" -o -name "*Response.*" -o -name "*ApiResponse.*" -o -name "*Res.*" \) > "$OUTPUT_PATH/response-format.txt" 2>/dev/null
echo "  -> 保存到 response-format.txt"

# 9. 异常类分析
echo "[9/10] 分析异常体系..."
find "$PROJECT_PATH/src" -type f -name "*Exception.*" -o -name "*Error.*" > "$OUTPUT_PATH/exceptions.txt" 2>/dev/null
echo "  -> 保存到 exceptions.txt"

# 10. 测试文件分析
echo "[10/10] 分析测试文件..."
find "$PROJECT_PATH" -path "*/test/*" -type f \( -name "*Test.*" -o -name "*_test.*" -o -name "test_*" \) | head -20 > "$OUTPUT_PATH/tests.txt" 2>/dev/null
echo "  -> 保存到 tests.txt"

# 生成分析摘要
echo ""
echo "=== 分析完成 ==="
echo "分析结果保存在: $OUTPUT_PATH"
echo ""
echo "文件清单:"
ls -la "$OUTPUT_PATH/"

echo ""
echo "=== 分析摘要 ==="
echo "编程语言:"
cat "$OUTPUT_PATH/languages.txt" | head -5
echo ""
echo "构建文件:"
cat "$OUTPUT_PATH/build-files.txt"
echo ""
echo "实体类数量:"
wc -l "$OUTPUT_PATH/entities.txt"
echo ""
echo "配置文件数量:"
wc -l "$OUTPUT_PATH/config-files.txt"
