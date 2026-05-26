# DevOps / CI/CD 提示词

## 1. Dockerfile 优化

```
请帮我审查和优化以下 Dockerfile：

```dockerfile
{粘贴 Dockerfile}
```

优化维度：
1. 镜像大小（多阶段构建、清理缓存、选对 base image）
2. 层缓存利用（COPY 顺序、依赖先装）
3. 安全性（非 root 用户运行、固定版本号而非 latest）
4. 构建速度（.dockerignore、并行构建）
5. 运行时配置（信号处理、健康检查、资源限制）
6. 遵守 Dockerfile 最佳实践

输出优化后的 Dockerfile + 每项改动理由 + 预估镜像大小变化。
```

## 2. CI/CD Pipeline 设计

```
请为以下项目设计 CI/CD Pipeline：

项目信息：
- 类型：{Web 应用 / 微服务 / 库 / 移动端}
- 技术栈：{语言/框架/数据库}
- 部署方式：{Docker / Kubernetes / Serverless / VPS}
- 当前 Git 工作流：{GitFlow / GitHub Flow / Trunk-Based}

请设计 Pipeline 的每个阶段：
1. **Check**：代码规范检查、类型检查
2. **Test**：单元测试 → 集成测试 → E2E 测试（并行策略）
3. **Build**：编译/打包/构建镜像
4. **Security Scan**：依赖漏洞扫描、SAST
5. **Deploy Staging**：自动部署到测试环境
6. **Smoke Test**：冒烟测试验证基本功能
7. **Deploy Production**：蓝绿/金丝雀/滚动发布策略

输出 GitHub Actions / GitLab CI 的完整 YAML 配置。
```

## 3. Kubernetes 部署配置

```
请为以下应用生成 Kubernetes 部署清单：

应用信息：
- 服务数量：{N 个微服务}
- 端口：{列出端口}
- 环境变量：{列出关键配置}
- 资源需求：{CPU/Memory}
- 持久化需求：{数据库/文件存储}

输出：
1. Deployment（replicas、资源限制、健康检查、滚动更新策略）
2. Service（ClusterIP / NodePort / LoadBalancer，按需选）
3. ConfigMap（非敏感配置）
4. Secret（敏感配置，用 Sealed Secrets 或 External Secrets）
5. Ingress（域名和 TLS 配置）
6. HPA（水平自动扩缩容规则）
7. Pod Disruption Budget
8. NetworkPolicy（最小网络访问权限）

每个资源输出完整的 YAML，并加简要注释。
```

## 4. 监控告警配置

```
请为以下系统设计监控和告警方案：

系统描述：{架构简述、关键组件}
监控栈：{Prometheus + Grafana / Datadog / 其他}

请输出：
1. **黄金信号**（延迟、流量、错误、饱和度）对应的具体指标
2. 各指标的采集方式（Metrics Endpoint / Exporter / APM）
3. 关键告警规则（P0/P1/P2 分级，含阈值和持续时间）
4. Grafana Dashboard 布局建议（4 个关键面板描述）
5. 日志采集与查询方案
6. On-call 轮值建议
7. 告警收敛与降噪策略

输出 Prometheus Rules 配置 + Dashboard JSON 骨架。
```

## 5. 数据库备份与恢复

```
请设计以下数据库的备份和灾难恢复方案：

数据库：{PostgreSQL / MySQL / MongoDB}
数据量：{大小}
RPO（恢复点目标）：{允许丢失多长时间的数据}
RTO（恢复时间目标）：{多长时间内必须恢复}

请输出：
1. 备份策略（全量备份周期 + 增量/WAL 备份频率）
2. 备份存储（本地 / S3 / 异地，保留策略）
3. 备份验证（定期恢复测试机制）
4. Point-in-Time Recovery 步骤
5. 灾难恢复完整操作手册（从检测到恢复的每一步）
6. 备份加密与访问控制
```

## 6. 日志系统设计

```
请设计一套应用日志系统：

应用类型：{微服务 / 单体 / Serverless}
日志量级：{每天约 X GB}
查询需求：{实时 / 近实时 / 离线}

请输出：
1. 日志格式规范（JSON 结构化日志，统一字段命名）
2. 链路追踪 ID 传递机制（OpenTelemetry / 自定义 Header）
3. 日志采集管道（Filebeat → Kafka → Logstash → Elasticsearch / Loki）
4. 日志保留与归档策略（热/温/冷数据分级）
5. 敏感信息脱敏方案
6. 常用查询模板（Top 5 运维日志查询场景）
7. 各语言/框架的日志库推荐
```

## 7. 安全合规检查

```
请为我的项目添加安全合规自动化检查：

项目类型：{Web 应用 / API / 数据处理}
合规要求：{GDPR / SOC 2 / ISO 27001 / 等保}

请设计：
1. 依赖漏洞扫描（Snyk / Dependabot / Trivy 集成到 CI）
2. SAST 静态代码安全分析（SonarQube / Semgrep 规则配置）
3. 容器镜像扫描（Trivy / Grype）
4. Secret 检测（GitLeaks / TruffleHog pre-commit hook）
5. IaC 安全扫描（tfsec / Checkov）
6. 动态安全测试（DAST）每周定时执行
7. 合规检查清单自动化（如：所有 PR 必须通过安全扫描）

输出 CI 集成配置 + pre-commit hook 脚本。
```

## 8. 多环境管理

```
请帮我设计规范化的多环境管理方案：

环境列表：local → dev → staging → production

要求：
1. 每个环境的配置管理策略（环境变量 vs 配置文件 vs 配置中心）
2. 敏感信息管理（开发用 .env.local / 生产用 Vault/ Secrets Manager）
3. Staging 与 Production 差异控制（如何保证 Staging 可信）
4. 环境隔离（数据库/缓存/消息队列是否需要独立实例）
5. Feature Flag 的使用场景
6. 环境销毁与重建的自动化
7. 数据库在各环境间的数据脱敏策略

输出环境配置模板 + Feature Flag 接入方案。
```

## 9. 故障演练方案

```
请为我的系统设计 Chaos Engineering 故障演练方案：

系统描述：{架构、关键组件、依赖}
目标：验证系统在各种故障下的韧性

请设计：
1. 演练场景清单（网络延迟、服务宕机、数据库主从切换、磁盘满、DNS 故障）
2. 每个场景的注入方式（用什么工具、什么命令）
3. 爆炸半径控制（如何确保只影响指定范围）
4. 回滚方案（如何立即终止演练）
5. 监控验证（演练期间观察什么指标判断系统反应是否符合预期）
6. 演练报告模板
7. 渐进式演练路线（从低风险场景开始逐步升级）
```

## 10. 开发环境搭建

```
请帮我生成一套完整的本地开发环境搭建文档：

项目技术栈：{语言/框架/数据库/中间件}
团队规模：{N 人}
操作系统：{macOS/Linux/Windows 都支持}

请包含：
1. 必需工具安装（版本要求精确到 minor version）
2. 一键启动脚本（docker-compose / Makefile / Taskfile）
3. 本地 hosts 和证书配置
4. 数据库初始化（Schema + 种子数据）
5. 环境变量模板
6. 常见问题 FAQ（Top 5 新手遇到的问题及解决方法）
7. IDE 插件和配置推荐
8. Git Hooks 配置（pre-commit 检查）

目标：新人入职 30 分钟内能跑起完整开发环境。
```
