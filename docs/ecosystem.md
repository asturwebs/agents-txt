# agents.txt — Ecosystem & Competitive Landscape

**Updated:** 2026-05-15 | **Status:** Living document

## Overview

agents.txt operates in a growing ecosystem of machine-readable web standards for AI. This document maps the landscape, identifies related projects, and defines our positioning strategy.

## The Three-Layer Stack

```
Layer 1 — CLASSIC (1994)
  robots.txt + sitemap.xml
  → Who can crawl what

Layer 2 — CONTEXT (2024)
  llms.txt + llms-full.txt
  → What the site means (semantic understanding)

Layer 3 — AGENTIC (2026)
  agents.txt + openapi.json
  → Who you are + what agents can do + how to interact
```

Each layer **adds capability without replacing the previous one**. All three coexist.

## Related Projects & Standards

### Direct competitors (same name or concept)

| Project | Format | Scope | Production | Product | Status |
|---------|--------|-------|-----------|---------|--------|
| **agents.txt** (this) | Markdown + YAML | Identity + permissions + services + API | Yes (asturwebs.es) | Yes (bytia-chat) | v2.0 |
| [dennj/agents.txt](https://github.com/dennj/agents.txt) | Key: Value (robots.txt style) | Agent discovery only | No | Landing page (agentstxt.dev, Nuxt 3) | Conceptual |
| [kaylacar/agents-txt](https://github.com/kaylacar/agents-txt) | — | Endpoint discovery layer | No | No | Early |
| [jaspervanveen/agents-brief.txt](https://github.com/jaspervanveen/agents-brief.txt) | Text | Agent interaction permissions | No | No | Renamed to agent-manifest.txt |

### Adjacent standards (different scope, same ecosystem)

| Standard | Purpose | Scope |
|----------|---------|-------|
| [robots.txt](https://datatracker.ietf.org/doc/html/rfc9309) (RFC 9309) | Crawler access control | Network level |
| [llms.txt](https://llmstxt.org/) | LLM context provider | Knowledge |
| [AGENT.md](https://gist.github.com/0xdevalias/f40bc5a6f84c4c5ad862e314894b2fa6) | Coding agent instructions | Repository-level |
| [ai.txt](https://spawning.ai/ai-txt) (Spawning) | Training consent | Opt-in/opt-out |
| [operate.txt](https://www.reddit.com/r/webdev/comments/1jln4dp/) | UI operation guide | Browser automation |
| [AI Manifest](https://datatracker.ietf.org/doc/html/draft-han-ai-manifest/) (IETF draft) | Workflow instructions | Task execution |
| [Model Context Protocol](https://modelcontextprotocol.io/) | Tool discovery & execution | Runtime tool loading |

## Our Differentiation

### vs dennj/agents.txt

dennj uses flat `Key: Value` directives (like robots.txt). Simple but cannot represent structure — no per-agent permissions, no service catalogs, no nested conditions.

**Our advantage:** YAML blocks enable granular data (`terms.data_usage.training`, per-agent overrides, service arrays). JSON Schema provides formal validation. Production-proven at asturwebs.es.

**Their advantage:** Lower barrier to entry. A flat file is easier to write for non-technical users. Their landing page (agentstxt.dev) has better marketing presence.

### vs jaspervanveen/agents-brief.txt

Started as `agents.txt`, renamed to `agent-manifest.txt`. Reached Hacker News. Focused on interaction permissions only.

**Our advantage:** Broader scope (identity + voice + services + API endpoints). JSON API mirror. OpenAPI/MCP integration. Real production implementation.

**Their advantage:** Earlier public visibility (HN post). Cleaner naming (avoids `robots.txt` confusion).

### vs kaylacar/agents-txt

Focused on endpoint discovery — a subset of what agents.txt covers.

**Our advantage:** Discovery is just one section. We add identity, terms, voice, services, and tool calling.

## Positioning Strategy

**agents.txt is the only standard that combines all four capabilities:**

1. **Identity** — who runs the business
2. **Permissions** — what agents can/cannot do with data
3. **Services** — what the business offers
4. **Execution** — programmatic interaction via OpenAPI/MCP

No competitor covers all four. This is the core differentiator.

### Strategy options

1. **Complement** — position as "if you use dennj for discovery, add agents.txt for the full picture"
2. **Converge** — contact dennj/kaylacar and explore merging specs
3. **Out-adopt** — focus on real implementations. Each production deployment = one new adopter

**Recommended: Option 3 (out-adopt).** Standards win by usage, not committees. The flywheel is:

```
Production deployment
  → site gets agents.txt + /api/agents
    → each site = new adopter in the table
      → more adopters → more visibility
        → frameworks take notice
```

## Adoption Tracking

| Site | agents.txt | JSON API | OpenAPI | Via |
|------|-----------|----------|---------|-----|
| [asturwebs.es](https://asturwebs.es/agents.txt) | Yes | Yes | Yes | Direct implementation |
| _Your site here_ | — | — | — | Open a PR |

## Production Reference

The agents.txt standard is documented and running in production:

**Blog posts:**
- [agents.txt: el estándar que creé para que la IA sepa quién eres y qué puede hacer](https://asturwebs.es/blog/agents-txt-openapi-descubrimiento-agentes-ia-2026/) — what agents.txt is, the three-layer stack (HTML `<link>` discovery → llms.txt → agents.txt), OpenAPI 3.1.0 tool calling, SSOT architecture, and how it connects to the chatbot.
- [BytIA: el chatbot que sabe dónde estás y cómo te sientes](https://asturwebs.es/blog/chatbot-ia-consciente-pagina-emociones-lead-scoring-2026/) — production chatbot powered by agents.txt data: page context, emotional adaptation, lead scoring, returning visitor recognition.

**Technical implementation details (from the posts):**
- **3-layer system prompt:** behavior (static) → business data (from agents.txt SSOT) → page context (dynamic per request)
- **Emotional adaptation:** 5 visitor states (curious, enthusiastic, frustrated, anxious, skeptical) with distinct response strategies
- **Lead scoring:** post-conversation AI analysis extracts temperature, intent, urgency, sentiment — stored in DB, sent via email/webhook, never shown to visitor
- **Returning visitor recognition:** cross-session continuity via sessionId in localStorage, identity-validated lookup
- **Security:** 8 layers (anti-prompt injection, DOMPurify, parameterized queries, rate limiting, CORS, identity validation, data separation, GDPR consent)
- **Performance:** Docker container with 128 MB RAM, ~5 KiB static facade via Facade pattern (React 40+ KB hydrates on click)

**Source repos:**
- [asturwebs/agents-txt](https://github.com/asturwebs/agents-txt) — the standard (this repo)
- [asturwebs/asturwebs-v2](https://github.com/asturwebs/asturwebs-v2) — production website (Astro + Hono)

## Key Observations

- The IETF has 11 drafts in this space. None has achieved adoption.
- jaspervanveen renamed from `agents.txt` to `agent-manifest.txt` — the name `agents.txt` is available but contested.
- The `data_usage` section (training/rag/derivative) addresses a real and growing concern among content creators.
- OpenAPI 3.1.0 integration for tool calling is unique to agents.txt. This is the strongest technical differentiator — frameworks like LangChain and AutoGen can consume it directly.
- The SSOT pattern (agents.txt → chatbot context) provides immediate value independent of third-party adoption.
