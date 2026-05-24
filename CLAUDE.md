# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

**agents.txt** is an open standard (not an application). The repo contains the spec, a JSON Schema, a validator, and example files. There is no build system, test suite, or runtime code.

## Repository Structure

- `README.md` / `README.es.md` / `README.zh.md` — The spec itself (English, Spanish, Chinese)
- `json-schema.json` — JSON Schema (draft 2020-12) for the `/api/agents` JSON endpoint
- `tools/validate.sh` — Bash script that validates a live `/api/agents` URL against the schema
- `examples/minimal.txt` — Minimal agents.txt example
- `docs/ecosystem.md` — Competitive landscape, positioning, adoption flywheel
- `docs/research/` — Background research on related standards

## Validation

```bash
# Validate a live endpoint against the schema
./tools/validate.sh https://example.com/api/agents

# Validate a local JSON file with ajv-cli
npx ajv-cli validate -s json-schema.json -d response.json

# The validator requires: bash, curl, python3, optionally npx (for full ajv validation)
```

## Schema Conventions

- Required top-level fields: `agents-txt` (must be `"2.0"`), `updated` (date), `identity`
- `identity` required fields: `name`, `owner`, `website`, `email`
- `terms.agents[].access` enum: `full`, `answer-engine`, `denied`
- `api_schema.type` enum: `openapi`, `mcp`
- `terms.data_usage` booleans: `training` (default false), `rag` (default true), `derivative` (default true)

## Dual Format

The standard defines two representations of the same data:
1. **Markdown** (`/agents.txt`) — YAML blocks inside `---yaml` ... `---` fences, human-readable
2. **JSON** (`/api/agents`) — Structured endpoint validated by `json-schema.json`

Changes to one format should be reflected in the other. The schema is the authoritative source for field names and types.

## Making Changes

- Spec edits go in all three README translations (EN, ES, ZH)
- Schema changes must keep `json-schema.json` in sync with README docs
- New sections or fields need: spec text in READMEs, schema properties, example in `examples/minimal.txt`
- Commit messages: conventional commits (`feat:`, `fix:`, `docs:`)

## Production Reference

AsturWebs runs the first production implementation:
- `https://asturwebs.es/agents.txt` — Markdown version
- `https://asturwebs.es/api/agents` — JSON version
- Source: `github.com/asturwebs/asturwebs-v2`
- Chatbot: `github.com/asturwebs/bytia-chat` (multi-tenant product using agents.txt as SSOT)
