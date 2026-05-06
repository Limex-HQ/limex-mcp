# Limex MCP

Public MCP server shim for Limex.

This package exposes MCP tools and forwards requests to the hosted Limex backing API. Provider
routing, billing, metering, and paid data integrations stay on the hosted
Limex service.

## Install

Create a Limex account first and generate a Limex API key from
`https://getlimex.com/account`. The key is shown once.

Run the MCP server directly with `uvx`:

```bash
uvx limex-mcp
```

Then run:

```bash
curl -fsSL https://raw.githubusercontent.com/Limex-HQ/limex-mcp/main/scripts/install.sh | bash
```

Claude Code config:

```json
{
  "mcpServers": {
    "limex": {
      "command": "uvx",
      "args": ["limex-mcp"],
      "env": {
        "LIMEX_API_KEY": "your_limex_api_key",
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

## Publishing

PyPI package name: `limex-mcp`.

1. Create a PyPI project or pending trusted publisher for `limex-mcp`.
2. In PyPI, configure a GitHub trusted publisher:
   - Owner: `Limex-HQ`
   - Repository: `limex-mcp`
   - Workflow: `publish.yml`
   - Environment: `pypi`
3. In GitHub, create an environment named `pypi`. Add a required reviewer if you want a human
   approval gate before publication.
4. Bump `version` in `pyproject.toml`.
5. Create and publish a GitHub Release for a tag like `v0.1.0`.

The release workflow builds the package, runs tests and lint, then publishes to PyPI through
trusted publishing. After the first successful release, users can run `uvx limex-mcp`.
