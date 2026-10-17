# 方法论：从源码提炼开发约束的完整指南

本文件是 `constraints-skills-builder` 技能的详细方法论参考。SKILL.md 是执行流程，本文件提供各步骤的判断标准、模板字段说明与清单。

## 1. 适配性评估详解

### 1.1 五项检查清单的判断依据

| 检查项 | 源码信号 | 文档信号 |
|--------|----------|----------|
| 明确的架构分层 | controller/service/dao（或 handler/usecase/repo 等）目录并存 | 架构文档描述分层职责 |
| 统一返回格式 | 存在 Rsp/Result/ApiResponse 等类且被接口广泛使用 | 接口文档约定统一响应结构 |
| 数据源/多租户需求 | @DS 注解、多数据源配置、租户字段 | 部署文档提及多库 |
| 外部系统集成 | HTTP/gRPC/MQ 客户端调用、第三方 SDK | 集成文档 |
| 异常处理规范 | 自定义异常类、全局异常处理器（@ControllerAdvice 等） | 错误码文档 |

### 1.2 评分后的处理策略

| 评分 | 策略 |
|------|------|
| 高度适配（5项） | 完整执行五步流程，可生成 15-25 个 Detailed Skills |
| 中度适配（3-4项） | 完整执行，Detailed Skills 取 8-15 个，缺项对应的 Skills 跳过 |
| 低度适配（1-2项） | 只沉淀最小 Core Skills（技术栈 + 已有的一两项约束），告知用户体系收益有限 |
| 不适用（0项） | 不建议建立体系，向用户说明原因（如原型项目需求频繁变化） |

## 2. 四步约束提取法

自动检测覆盖"可观测事实"，以下四步用于人工 + AI 补充业务语义约束：

**步骤1 技术栈约束**：语言版本、框架版本、数据库、中间件、构建工具。禁止事项示例：禁止引入未评审依赖、禁止使用低于某版本的组件。

**步骤2 架构规则**：分层模式（MVC/DDD/六边形）、包路径规范、层间调用规则（哪层可调用哪层、禁止跨层）。

**步骤3 数据规则**：返回格式（统一响应对象的字段与成功/失败码）、数据源模式（单库/多库/分库分表）、表名规范。

**步骤4 安全规则**：异常处理（全局处理器、业务异常码）、日志规范（操作日志/异常日志/脱敏）、权限控制（RBAC/OAuth2/JWT）。

每条约束必须包含：规则 ID、规则名称、约束内容、验证方法。强制（mandatory）与 建议（recommended）的区分标准：违反会导致系统故障、安全风险、不兼容的标强制；仅影响代码质量的标建议。

## 3. skills-config.json 字段说明

```json
{
  "projectName": "项目名称",
  "language": "java|python|go|nodejs|typescript|rust",
  "framework": "spring-boot|django|gin|express|nestjs 等",
  "database": "mysql|oceanbase|postgresql|mongodb 等",
  "dataSource": "single|dynamic-multi",
  "architecture": "mvc|ddd|hexagonal 等",
  "deployment": "docker|k8s|vm",
  "externalSystems": ["外部系统列表"],
  "outputPath": "docs/skills-layered"
}
```

- `outputPath` 支持相对路径（相对项目根目录）或绝对路径。
- `language` 决定 extract/generate 的检测分支与生成模板。
- `dataSource=dynamic-multi` 会触发 CORE_004/DETAILED_009 的生成。

> **detected-facts.env 格式说明**：该文件使用 `KEY=VALUE` 格式，值不加引号。如果值中包含空格（如 KEY_DEPS 多个依赖用空格分隔），`generate-skills.sh` 的 `get_fact()` 函数通过 `sed -n "s/^KEY=//p"` 读取整行，可以正确处理。但如果值中包含换行符则会截断，当前脚本输出的值均不包含换行符，因此无此问题。

## 4. Detailed Skills 领域清单（按项目复杂度选取）

| 项目类型 | 建议数量 | 典型 Skills |
|----------|----------|-------------|
| 复杂企业级 | 15-25 个 | 技术栈、分层、返回格式、实体类、DAO、Service、Controller、XML/SQL、多数据源、配置、工具类、定时任务、异常、日志、Excel导出、外部系统、批处理、权限、命名、测试、部署 |
| 中等复杂度 | 8-15 个 | 技术栈、分层、返回格式、实体类、DAO、Service、Controller、配置、异常、日志、部署 |
| 简单项目 | 4-8 个 | 技术栈、分层、返回格式、实体类、数据访问、异常处理 |

选取原则：只为检测到的特性或用户明确提到的领域创建；自动生成的骨架（技术栈/分层/返回格式/多数据源）优先完善，其余按需补充。

## 5. 分层加载策略（交付时必须写入生成的 README）

| 加载级别 | 内容 | 大小 | 适用场景 |
|----------|------|------|----------|
| 最小加载 | INDEX + GLOSSARY | ~10KB | 简单查询、任务分类 |
| 标准加载 | 最小 + CORE Skills | ~20KB | 常规开发（覆盖 80% 任务） |
| 完整加载 | 标准 + 1-2 个领域 Detailed | ~25KB | 复杂开发、深度审查 |

禁止项：一次性加载所有 DETAILED Skills（30KB+）；Core 与 Detailed 混合加载。

任务映射表（INDEX.md 核心）：每种任务类型列出必读 CORE 与 DETAILED 编号，示例：

| 任务类型 | 必读 CORE | 必读 DETAILED |
|----------|-----------|----------------|
| 新增 Controller | 分层、返回格式、包路径 | Controller 规范 |
| 新增 Service | 分层、安全异常 | Service 规范、异常日志 |
| 新增 DAO | 分层、数据源 | DAO 规范、SQL 规范 |

## 6. 维护与更新

### 6.1 更新触发条件

| 变化类型 | 更新内容 |
|----------|----------|
| 技术栈升级 | CORE_001 + DETAILED_001 版本号 |
| 新增分层/包路径规则 | 分层架构 Skill |
| 新增数据源 | 数据源 Skill |
| 新增外部系统 | 对应领域 Detailed Skill |
| 发现新的共性问题 | 新增规则或 Skill |

### 6.2 版本号规则

v[主].[次].[修订]：主版本=架构变更；次版本=新增规则或 Skills；修订=修正错误或优化表述。每次更新在更新日志表记录日期、版本、内容、更新人。

### 6.3 质量保证

1. **源码健康度基线检查**：`scripts/check-compliance.sh`（检查项目结构、返回格式、日志、异常处理、敏感信息等源码层面的基本规范）
2. **Skills 合规性 AI 审查**：使用生成的 `review-prompt.md` 配合 AI 审查代码是否符合 Skills 规范
3. 人工抽查：核心文件（CORE Skills）人工 review
4. 度量目标：合规率 >90%（AI 生成代码一次通过审查的比例）、上下文效率 <25KB/任务

## 7. 智能体对接方式（交付时告知用户）

让其他 AI 智能体使用生成的体系：

```yaml
智能体配置:
  system_prompt: "加载 SKILLS/CORE/ 下所有文件作为强制约束"
  任务触发: "按 INDEX.md 任务映射表加载对应 DETAILED Skills"
  审查机制: "生成代码后用 review-prompt.md 自审"
```

三层约束机制：System Prompt 约束（Core 常驻）→ 任务触发约束（Detailed 按需）→ 审查约束（事后核验）。

## 8. Skills 与文档的区别（向用户解释时用）

- **Skills**：约束性文档，告诉 AI"必须做什么/不能做什么"，用于生成代码——是"法律"。
- **项目文档**：说明性文档，解释"项目是什么/如何工作"，用于理解项目——是"历史书"。

两者互补：文档帮助理解背景，Skills 约束执行行为。

## 9. 各语言检测覆盖度矩阵

`extract-constraints.sh` 和 `check-compliance.sh` 对不同语言的检测深度不同：

### extract-constraints.sh 检测覆盖度

| 检测项 | Java | Python | Go | Node.js/TS |
|--------|------|--------|-----|------------|
| 语言/构建工具 | ✅ 完整 | ✅ 完整 | ✅ 完整 | ✅ 完整 |
| 框架检测 | ✅ Spring Boot/Cloud | ✅ Django/FastAPI/Flask | ✅ Gin/Echo | ✅ Express/NestJS |
| 数据库检测 | ✅ 完整 | ✅ 基础 | ⚠️ 仅 go.mod 依赖 | ⚠️ 仅 package.json 依赖 |
| 架构分层 | ✅ controller/service/dao 目录 | ⚠️ views/models/urls | ✅ handler/service/repo 目录 | ❌ 无自动检测 |
| 统一返回格式 | ✅ 文件名匹配 | ⚠️ 文件名匹配 | ⚠️ 文件名匹配 | ⚠️ 文件名匹配 |
| 异常体系 | ✅ 全局处理器+吞异常检测 | ✅ exception_handler+pass 检测 | ❌ 无自动检测 | ❌ 无自动检测 |
| 数据访问 | ✅ @DS 注解+实体后缀 | ⚠️ 仅配置文件 | ⚠️ 仅配置文件 | ⚠️ 仅配置文件 |
| 日志框架 | ✅ @Slf4j 统计 | ✅ logging 统计 | ⚠️ 关键词匹配 | ❌ 无自动检测 |
| 安全扫描 | ✅ 完整 | ✅ 完整 | ⚠️ 基础 | ⚠️ 基础 |
| 部署形态 | ✅ 完整 | ✅ 完整 | ✅ 完整 | ✅ 完整 |

### check-compliance.sh 检测覆盖度

| 检查项 | Java | Python | Go |
|--------|------|--------|-----|
| 项目结构 | ✅ .java 文件存在 | ✅ .py 文件存在 | ✅ go.mod 存在 |
| 返回格式 | ✅ RSP_PATTERN | ⚠️ 需 AI 审查 | ⚠️ 需 AI 审查 |
| 日志规范 | ✅ LOG_PATTERN | ✅ logging 统计 | ✅ log/zap/logrus |
| 异常处理 | ✅ 空 catch 块 | ✅ except:pass | ⚠️ 返回值忽略 |
| 敏感信息 | ✅ 完整 | ✅ 完整 | ⚠️ 基础 |
| 配置文件 | ✅ 完整 | ✅ 完整 | ✅ 完整 |

> **使用建议**：对于 Python/Go/Node.js 项目，自动生成的 Skills 骨架可能缺少部分维度（如异常体系、架构分层），需在步骤 3 的领域 Detailed Skills 补充阶段重点关注缺失项。
