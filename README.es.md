# agents.txt — Estándar Abierto para el Descubrimiento de Agentes IA

[![Standard: agents.txt](https://img.shields.io/badge/Standard-agents.txt_v2.0-blue?style=flat-square&logo=ai&logoColor=orange)](https://github.com/asturwebs/agents-txt)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)

**Versión:** 2.0 | **Licencia:** MIT | **Estado:** Borrador

🌐 **Español** | [English](./README.md) | [中文](./README.zh.md)

---

## ¿Qué es agents.txt?

Un archivo **legible por humanos, analizable por máquinas** que los sitios web colocan en su raíz (`/agents.txt`) para declarar su identidad, condiciones de uso para agentes IA, catálogo de servicios y endpoints agénticos.

Rellena el hueco entre:
- **`robots.txt`** — dice a los crawlers *si* pueden acceder a las páginas (nivel de red)
- **`llms.txt`** — da a los LLMs *contexto* sobre el sitio (solo lectura)
- **`agents.txt`** — dice a los agentes IA *quién eres, qué ofreces y qué pueden hacer* (identidad + permisos + ejecución)

## Ejemplo Rápido

```markdown
# agents.txt — ejemplo.com
# Version: 2.0
# Updated: 2026-05-12
# License: MIT

## Identity

---yaml
identity:
  name: Negocio Ejemplo
  owner: María García
  website: https://ejemplo.com
  email: info@ejemplo.com
---

## Condiciones de uso

| Agent | Owner | Allowed usage | Conditions |
|-------|-------|---------------|------------|
| Googlebot | Google | Full indexing | — |
| GPTBot | OpenAI | Answer-engine only | Attribute source |

## Services

---yaml
services:
  - id: consultoria
    name: "Consultoría"
    starting_price: "200€/hora"
    url: https://ejemplo.com/consultoria/
---

## Agentic Endpoints

---yaml
api_schema:
  type: openapi
  version: 3.1.0
  url: https://ejemplo.com/openapi.json
---
```

## ¿Por qué agents.txt?

Cuando un agente IA autónomo visita tu web, necesita responder:
- **"¿Quién dirige este negocio?"** → Sección Identity
- **"¿Puedo usar estos datos?"** → Sección Condiciones de uso
- **"¿Qué ofrecen?"** → Sección Services
- **"¿Puedo interactuar programáticamente?"** → Sección Agentic Endpoints (OpenAPI)

Ningún otro estándar proporciona las cuatro cosas.

## Secciones

| Sección | Propósito | Requerida |
|----------|-----------|-----------|
| **Header** | Versión, fecha, licencia | Sí |
| **Discovery** | Referencias cruzadas a robots.txt, llms.txt, openapi.json | Recomendada |
| **Condiciones de uso** | Qué pueden/no pueden hacer los agentes IA con tus datos | Sí |
| **Identity** | Nombre del negocio, propietario, contacto, ubicación | Sí |
| **Brand Voice** | Cómo deben representar tu marca los agentes | Opcional |
| **Services** | Qué ofreces, precios, URLs | Recomendada |
| **Agentic Endpoints** | Spec OpenAPI para tool calling | Opcional |

## Formato

- **Markdown** con bloques **YAML** embebidos (`---yaml` ... `---`)
- Legible por humanos primero, analizable por máquinas segundo
- Los bloques YAML contienen todos los datos estructurados; el resto es prosa

## Integración con robots.txt

Añade punteros de discovery para que los agentes encuentren tu `agents.txt`:

```text
User-agent: *
Allow: /

# AI Agent Discovery
Agent-discovery: https://ejemplo.com/agents.txt
LLM-context: https://ejemplo.com/llms.txt

Sitemap: https://ejemplo.com/sitemap.xml
```

## API JSON y Esquema

Sirve los mismos datos como JSON estructurado en `/api/agents`. El esquema [json-schema.json](./json-schema.json) define la estructura:

| Objeto | Descripción | Requerido |
|--------|-------------|-----------|
| `identity` | Propietario, contacto, presencia web | **Sí** |
| `terms` | Permisos de agentes (allowed/denied) y condiciones | No |
| `voice` | Directivas de comportamiento para agentes IA | No |
| `services` | Catálogo de servicios con precios y URLs | No |
| `api_schema` | Referencia al spec OpenAPI para tool calling | No |

### Validación de datos

| Campo | Formato | Ejemplo |
|-------|---------|---------|
| `website`, `url`, `contact` | URI | `https://ejemplo.com` |
| `identity.email` | Email (RFC 5322) | `info@ejemplo.com` |
| `agents[].access` | Enum: `full`, `answer-engine`, `denied` | `answer-engine` |
| `updated` | Fecha (`YYYY-MM-DD`) | `2026-05-12` |

### Valida tu implementación

```bash
# Con ajv-cli
npx ajv-cli validate -s json-schema.json -d tu-respuesta-api.json

# Con el script incluido
./tools/validate.sh https://ejemplo.com/api/agents
```

## Implementación en Producción

**AsturWebs** — la primera implementación en producción:
- [agents.txt](https://asturwebs.es/agents.txt) — Versión Markdown
- [/api/agents](https://asturwebs.es/api/agents) — Versión JSON
- [openapi.json](https://asturwebs.es/openapi.json) — Spec OpenAPI 3.1.0

Código fuente: [github.com/asturwebs/asturwebs-v2](https://github.com/asturwebs/asturwebs-v2)

## Adoptantes

| Sitio | agents.txt | JSON API | OpenAPI |
|-------|-----------|----------|---------|
| [asturwebs.es](https://asturwebs.es/agents.txt) | ✅ | ✅ | ✅ |

*Para añadir tu sitio, abre un PR editando esta tabla.*

## Contribuir

1. Abre un issue con tu caso de uso o feedback
2. Envía un PR con mejoras al spec o traducciones
3. Añade tu implementación a la tabla de Adoptantes

## Insignia de adoptante

Si tu sitio implementa el estándar, muéstralo:

```markdown
[![agents.txt compliant](https://img.shields.io/badge/Standard-agents.txt_v2.0-blue?style=flat-square&logo=ai&logoColor=orange)](https://github.com/asturwebs/agents-txt)
```

## Licencia

MIT — copia, adapta, integra en cualquier proyecto comercial o de código abierto.
