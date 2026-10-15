---
name: mermaid-to-png
description: "将 Markdown 中的 Mermaid 代码块批量渲染为 PNG 图片"
when_to_use: "用户要求将 Mermaid 图表渲染为图片、从 Markdown 提取图表生成 PNG、或批量导出架构图/流程图时使用"
effort: medium
---

# Mermaid 图表渲染 PNG 技能

将 Markdown 文件中的 Mermaid 代码块解析并渲染为 PNG 图片。支持流程图、时序图、状态图、类图、ER 图、甘特图、饼图。

## 硬约束（必须遵守）

1. **输入校验**：渲染前必须检查输入文件是否存在、Mermaid 语法是否合法，不合法时停止并告知用户。
2. **编码固定**：文件读写统一使用 `utf-8` 编码，脚本开头必须设置 `sys.stdout.reconfigure(encoding='utf-8')`。
3. **错误不吞没**：单个图表渲染失败时记录错误并继续下一个，最终汇总 OK/FAIL 数量，不得静默跳过。
4. **禁止覆盖已有文件**：输出文件名冲突时追加序号或报错，不得直接覆盖。
5. **不编造图表类型**：只渲染 Mermaid 语法支持的图表类型，不支持的类型停止并说明。

## 触发条件（必须调用）

- 用户要求将 Mermaid 图表渲染为 PNG/SVG 图片
- 用户要求从 Markdown 文件批量提取并导出图表
- 用户提到「渲染图表」「导出流程图」「生成架构图」
- 用户要求处理 `.mmd` 或包含 Mermaid 代码块的文件

## 执行流程

### 步骤 1：确认输入

向用户确认：
- 输入文件路径（必需）：`.md` 文件或 `.mmd` Mermaid 源文件
- 输出目录（默认：输入文件同级 `output_images/`）
- 图表筛选（可选）：全部渲染或指定某几个

### 步骤 2：提取 Mermaid 代码块

```bash
python render_mermaid.py <输入文件> <输出目录>
```

脚本自动完成：
1. 检查输入文件是否存在
2. 从 Markdown 中用正则提取 ` ```mermaid ` 代码块（`.mmd` 文件整体作为单个代码块）
3. 逐个渲染为 PNG
4. 输出结果统计

### 步骤 3：结果确认

- 检查输出目录中的 PNG 文件
- 如有 FAIL 项，查看错误原因并告知用户：
  - 语法错误 → 指出具体 Mermaid 代码问题
  - 中文乱码 → 提示安装中文字体
  - 渲染超时 → 建议简化图表或分批渲染

## 支持的图表类型

| 类型 | 语法关键字 | 示例 |
|------|-----------|------|
| 流程图 | `graph TB` / `graph LR` | `graph TB A-->B` |
| 时序图 | `sequenceDiagram` | `sequenceDiagram A->>B: Hello` |
| 状态图 | `stateDiagram-v2` | `stateDiagram-v2 [*] --> State1` |
| 类图 | `classDiagram` | `classDiagram Class01 <\|-- Class02` |
| ER 图 | `erDiagram` | `erDiagram CUSTOMER \|--o{ ORDER` |
| 甘特图 | `gantt` | `gantt title Project` |
| 饼图 | `pie` | `pie title Stats` |

## 脚本说明

`render_mermaid.py` 位于技能目录下，用法：

```bash
python render_mermaid.py <输入.md> <输出目录> [-p 前缀] [-q]
```

**参数**：

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `input_md` | 输入 Markdown 文件 | 必填 |
| `output_dir` | 输出目录 | 必填 |
| `-p` / `--prefix` | 输出文件名前缀 | `chart` |
| `-q` / `--quiet` | 静默模式，只输出失败信息 | 关闭 |

**特性**：

- 同时支持 ` ``` ` 和 `~~~` 围栏语法，容忍 CRLF 换行
- 输出文件命名：`chart_1.png`、`chart_2.png`...
- 渲染完成后输出统计：`完成：成功 N，失败 M`
- 失败信息输出到 stderr，成功信息输出到 stdout
- 非零退出码表示有渲染失败

## 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| 中文显示为方块 | 系统缺少中文字体 | 安装中文字体（如微软雅黑、思源黑体） |
| SyntaxError | Mermaid 语法错误 | 检查语法，参考 Mermaid 官方文档 |
| 渲染超时 | 图表过于复杂 | 简化图表或拆分为多个小图 |
| 图片模糊 | mermaid-py 默认 DPI | 如需高清可改用 mmdc（Mermaid CLI） |

## 依赖安装

```bash
pip install mermaid-py
```

验证：

```python
import mermaid as md
from mermaid.graph import Graph
print("mermaid-py installed OK")
```
