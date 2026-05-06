# Limex MCP

Public MCP server shim for Limex.

This package exposes MCP tools and forwards requests to the hosted Limex backing API. Provider
routing, billing, budget enforcement, metering, and paid data integrations stay on the hosted
Limex service.

## Install

Create a Limex account first and generate a Claude Code key from
`https://getlimex.com/account`. The key is shown once.

Claude Code config:

```json
{
  "mcpServers": {
    "limex": {
      "command": "uvx",
      "args": ["limex-mcp"],
      "env": {
        "LIMEX_API_KEY": "your_claude_code_key",
        "LIMEX_API_BASE_URL": "https://api.getlimex.com"
      }
    }
  }
}
```

## Tools

- `research(intent, target, questions=None, max_budget_cents=1000, freshness=None, constraints=None)`
- `get_usage_summary()`
- `get_billing_account()`
- `get_prices()`
