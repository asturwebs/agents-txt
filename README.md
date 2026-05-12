# agents.txt — Open Standard for AI Agent Discovery

[![Standard: agents.txt](https://img.shields.io/badge/Standard-agents.txt_v2.0-blue?style=flat-square&logo=ai&logoColor=orange)](https://github.com/asturwebs/agents-txt)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)

**Version:** 2.0 | **License:** MIT | **Status:** Draft

🌐 [Español](./README.es.md) | **English** | [中文](./README.zh.md)

---

## What is agents.txt?

A **human-readable, machine-parseable** file that websites place at their root (`/agents.txt`) to declare their identity, terms of use for AI agents, service catalog, and agentic endpoints.

It fills the gap between:
- **`robots.txt`** — tells crawlers *whether* they can access pages (network level)
- **`llms.txt`** — gives LLMs *context* about the site (read-only)
- **`agents.txt`** — tells AI agents *who you are, what you offer, and what they can do* (identity + permissions + execution)

## Quick Example

```markdown
# agents.txt — example.com
# Version: 2.0
# Updated: 2026-05-12
# License: MIT

## Identity

---yaml
identity:
  name: Example Business
  owner: Jane Doe
  website: https://example.com
  email: info@example.com
---

## Terms of Use

| Agent | Owner | Allowed usage | Conditions | Data usage |
|-------|-------|---------------|------------|------------|
| Googlebot | Google | Full indexing | — | — |
| GPTBot | OpenAI | Answer-engine | Attribute source | rag, answer-engine |
| Bytespider | ByteDance | Denied | — | — |

### Data usage defaults

---yaml
terms:
  data_usage:
    training: false
    rag: true
    derivative: true
---

## Services

---yaml
services:
  - id: consulting
    name: "Consulting"
    starting_price: "$200/hour"
    url: https://example.com/consulting/
---

## Agentic Endpoints

---yaml
api_schema:
  type: openapi  # or "mcp" for Model Context Protocol
  version: 3.1.0
  url: https://example.com/openapi.json
---
```

## Why agents.txt?

When an autonomous AI agent visits your website, it needs to answer:
- **"Who runs this business?"** → Identity section
- **"Can I use this data?"** → Terms of Use section
- **"What do they offer?"** → Services section
- **"Can I interact programmatically?"** → Agentic Endpoints (OpenAPI)

No other standard provides all four.

## Sections

| Section | Purpose | Required |
|---------|---------|----------|
| **Header** | Version, date, license | Yes |
| **Discovery** | Cross-references to robots.txt, llms.txt, openapi.json | Recommended |
| **Terms of Use** | What AI agents can/cannot do with your data | Yes |
| **Identity** | Business name, owner, contact, location | Yes |
| **Brand Voice** | How agents should represent your brand | Optional |
| **Services** | What you offer, pricing, URLs | Recommended |
| **Agentic Endpoints** | OpenAPI spec for tool calling | Optional |

## Format

- **Markdown** with embedded **YAML blocks** (`---yaml` ... `---`)
- Human-readable first, machine-parseable second
- YAML blocks contain all structured data; everything else is prose

## Integration with robots.txt

Add discovery pointers so agents can find your `agents.txt`:

```text
User-agent: *
Allow: /

# AI Agent Discovery (Proposed Directives)
Agent-discovery: https://example.com/agents.txt
LLM-context: https://example.com/llms.txt

Sitemap: https://example.com/sitemap.xml
```

## JSON API & Schema

Serve the same data as structured JSON at `/api/agents`. The [json-schema.json](./json-schema.json) defines the structure:

| Object | Description | Required |
|--------|-------------|----------|
| `identity` | Business owner, contact, web presence | **Yes** |
| `terms` | Agent permissions (allowed/denied) and conditions | No |
| `voice` | Behavioral directives for AI agents | No |
| `services` | Service catalog with pricing and URLs | No |
| `api_schema` | OpenAPI or MCP reference for tool calling | No |

### Data usage controls

The `terms.data_usage` object provides granular control over how agents use your content:

| Permission | Description | Default |
|------------|-------------|---------|
| `training` | Allow content to train foundation models | `false` |
| `rag` | Allow content in retrieval-augmented generation | `true` |
| `derivative` | Allow derivative works (translations, summaries) | `true` |

Per-agent overrides are available via `agents[].data_usage` array (values: `answer-engine`, `rag`, `training`, `derivative`).

### Data validation

| Field | Format | Example |
|-------|--------|---------|
| `website`, `url`, `contact` | URI | `https://example.com` |
| `identity.email` | Email (RFC 5322) | `info@example.com` |
| `agents[].access` | Enum: `full`, `answer-engine`, `denied` | `answer-engine` |
| `updated` | Date (`YYYY-MM-DD`) | `2026-05-12` |

### Validate your implementation

```bash
# Using ajv-cli
npx ajv-cli validate -s json-schema.json -d your-api-response.json

# Using the included validator script
./tools/validate.sh https://example.com/api/agents
```

## Production Implementation

**AsturWebs** — the first production implementation:
- [agents.txt](https://asturwebs.es/agents.txt) — Markdown version
- [/api/agents](https://asturwebs.es/api/agents) — JSON version
- [openapi.json](https://asturwebs.es/openapi.json) — OpenAPI 3.1.0 spec

Source: [github.com/asturwebs/asturwebs-v2](https://github.com/asturwebs/asturwebs-v2)

## Adopters

| Site | agents.txt | JSON API | OpenAPI |
|------|-----------|----------|---------|
| [asturwebs.es](https://asturwebs.es/agents.txt) | ✅ | ✅ | ✅ |

*To add your site, open a PR editing this table.*

## Contributing

1. Open an issue with your use case or feedback
2. Submit a PR with spec improvements or translations
3. Add your implementation to the Adopters table

## Adopter Badge

If your site implements the standard, show it:

```markdown
[![agents.txt compliant](https://img.shields.io/badge/Standard-agents.txt_v2.0-blue?style=flat-square&logo=ai&logoColor=orange)](https://github.com/asturwebs/agents-txt)
```

## License

MIT — copy, adapt, integrate into any commercial or open-source project.

## Related Standards

agents.txt is part of a growing ecosystem of machine-readable web standards for AI:

| Standard | Purpose | Scope |
|----------|---------|-------|
| [robots.txt](https://datatracker.ietf.org/doc/html/rfc9309) (RFC 9309) | Crawler access control | Network level — what to crawl |
| [llms.txt](https://llmstxt.org/) | LLM context provider | Knowledge — what to understand |
| **agents.txt** (this) | Agent discovery + permissions | Identity + actions + execution |
| [agents-brief.txt](https://github.com/jaspervanveen/agents-brief.txt) | Agent mission brief | Alternative approach to agent instructions |
| [ai.txt](https://spawning.ai/ai-txt) (Spawning) | Training consent | Opt-in/opt-out for model training |
| [ai.txt](https://arxiv.org/abs/2505.07834) (DSL paper) | Granular AI control | Per-element HTML control |
| [operate.txt](https://www.reddit.com/r/webdev/comments/1jln4dp/) | UI operation guide | Browser automation behavior |
| [AI Manifest](https://datatracker.ietf.org/doc/draft-han-ai-manifest/) (IETF draft) | Workflow instructions | Step-by-step task execution |
| [Model Context Protocol](https://modelcontextprotocol.io/) | Tool discovery & execution | Runtime tool loading for agents |
