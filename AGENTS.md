# AGENTS.md

Guidance for any AI agent working in this repository (Codex, Gemini CLI, Cursor, opencode, Claude Code, ...). For the standard itself, read [README.md](./README.md).

## What This Is

**agents.txt** is an open standard (not an application): a human-readable, machine-parseable file that websites place at `/agents.txt` to declare identity, terms of use for AI agents, service catalog, and agentic endpoints. The repo contains the spec, a JSON Schema, validators, and example files. There is no build system, test suite, or runtime code.

## Repository Structure

- `README.md` / `README.es.md` / `README.zh.md` — the spec itself (EN / ES / ZH, kept in sync)
- `json-schema.json` — JSON Schema (draft 2020-12) for the `/api/agents` JSON endpoint; **authoritative source for field names and types**
- `tools/validate.sh` — validates a live JSON `/api/agents` URL against the schema
- `tools/validate-md.sh` — validates a Markdown `agents.txt` file or URL (the `---yaml` block half of the dual format)
- `examples/minimal.txt` — minimal starting template
- `examples/full.txt` — full-featured reference covering every section
- `agents.txt` — this repo's own file (dogfooding demo of the standard)
- `docs/ecosystem.md`, `docs/research/` — positioning and background research
- `HANDOFF.md` — local working state between sessions; gitignored, never commit it

## Dual Format

One dataset, two representations:

1. **Markdown** (`/agents.txt`) — YAML blocks inside `---yaml` ... `---` fences, human-readable
2. **JSON** (`/api/agents`) — structured endpoint validated by `json-schema.json`

A change to one format must be reflected in the other. The schema wins on field names and types.

## Conventions

- Spec edits go into **all three** README translations
- New sections or fields need: spec text in the READMEs ×3 + schema properties + example coverage in `examples/`
- Commit messages: conventional commits (`feat:`, `fix:`, `docs:`)

## Validation

```bash
# Markdown side (file or URL; no ajv needed)
./tools/validate-md.sh examples/full.txt

# JSON side (live endpoint)
./tools/validate.sh https://example.com/api/agents

# Direct schema validation
npx ajv-cli validate -s json-schema.json -d response.json
```

Requirements: bash, curl, python3 (PyYAML for Markdown validation), optionally npx (full ajv validation).

## Schema Quick Reference

- Required top-level: `agents-txt` (const `"2.0"`), `updated` (`YYYY-MM-DD`), `identity`
- `identity` required fields: `name`, `owner`, `website` (URI), `email`
- `terms` required (when present): `allowed[]`, `denied[]`
- `terms.agents[]` required: `agent`, `owner`, `access` — enum: `full` | `answer-engine` | `denied`
- `terms.data_usage` booleans: `training` (default false), `rag` (true), `derivative` (true); per-agent `data_usage` array values: `answer-engine`, `rag`, `training`, `derivative`
- `api_schema.type` enum: `openapi` | `mcp`
- `services[]` required: `id`, `name`, `description`, `url` (URI)

## Production Reference

AsturWebs runs the first production implementation:

- `https://asturwebs.es/agents.txt` — Markdown version
- `https://asturwebs.es/api/agents` — JSON version
- Source: `github.com/asturwebs/asturwebs-v2`
- Chatbot: `github.com/asturwebs/bytia-chat` (multi-tenant product using agents.txt as SSOT)
