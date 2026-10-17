# Stripe MCP (Official)

管理 Stripe 支付——客户搜索、Payment Intents、订阅、争议处理。

**来源**: [@stripe/mcp](https://github.com/stripe/mcp) · Stripe 官方

## 安装

```bash
claude mcp add stripe -- npx -y @stripe/mcp
```

## settings.json

```json
{
  "mcpServers": {
    "stripe": {
      "command": "npx",
      "args": ["-y", "@stripe/mcp"],
      "env": {
        "STRIPE_SECRET_KEY": "<your-stripe-secret-key>"
      }
    }
  }
}
```

## 环境变量

| 变量 | 说明 |
|---|---|
| `STRIPE_SECRET_KEY` | Stripe Secret Key（建议使用 Restricted Key，限定权限） |

## 主要能力

- 客户查询与管理
- Payment Intents 和退款
- 订阅生命周期管理
- 争议（Disputes）查看与处理
- 发票和账单数据
