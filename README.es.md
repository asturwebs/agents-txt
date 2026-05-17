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

| Agent | Owner | Allowed usage | Conditions | Data usage |
|-------|-------|---------------|------------|------------|
| Googlebot | Google | Full indexing | — | — |
| GPTBot | OpenAI | Answer-engine | Attribute source | rag, answer-engine |
| Bytespider | ByteDance | Denied | — | — |

### Uso de datos por defecto

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
  - id: consultoria
    name: "Consultoría"
    starting_price: "200€/hora"
    url: https://ejemplo.com/consultoria/
---

## Agentic Endpoints

---yaml
api_schema:
  type: openapi  # o "mcp" para Model Context Protocol
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
| **Discovery** | Referencias cruzadas a llms.txt, openapi.json via etiquetas HTML `<link>` | Recomendada |
| **Condiciones de uso** | Qué pueden/no pueden hacer los agentes IA con tus datos | Sí |
| **Identity** | Nombre del negocio, propietario, contacto, ubicación | Sí |
| **Brand Voice** | Cómo deben representar tu marca los agentes | Opcional |
| **Services** | Qué ofreces, precios, URLs | Recomendada |
| **Agentic Endpoints** | Spec OpenAPI para tool calling | Opcional |

## Formato

- **Markdown** con bloques **YAML** embebidos (`---yaml` ... `---`)
- Legible por humanos primero, analizable por máquinas segundo
- Los bloques YAML contienen todos los datos estructurados; el resto es prosa

## Discovery via HTML

Añade etiquetas `<link>` en el `<head>` de tu HTML para que los agentes descubran tus archivos de IA. Esto sigue la semántica HTML estándar (como `<link rel="icon">`) y es compatible con RFC 9309 — sin directivas inventadas en `robots.txt`:

```html
<link rel="agent" href="/agents.txt" />
<link rel="llms" href="/llms.txt" />
```

Cualquier crawler o LLM que parsee HTML los encontrará. `robots.txt` solo debe contener directivas estándar (User-agent, Allow, Disallow, Sitemap).

## API JSON y Esquema

Sirve los mismos datos como JSON estructurado en `/api/agents`. El esquema [json-schema.json](./json-schema.json) define la estructura:

| Objeto | Descripción | Requerido |
|--------|-------------|-----------|
| `identity` | Propietario, contacto, presencia web | **Sí** |
| `terms` | Permisos de agentes (allowed/denied) y condiciones | No |
| `voice` | Directivas de comportamiento para agentes IA | No |
| `services` | Catálogo de servicios con precios y URLs | No |
| `api_schema` | Referencia a OpenAPI o MCP para tool calling | No |

### Controles de uso de datos

El objeto `terms.data_usage` proporciona control granular sobre cómo los agentes usan tu contenido:

| Permiso | Descripción | Por defecto |
|---------|-------------|-------------|
| `training` | Permitir contenido para entrenar modelos fundacionales | `false` |
| `rag` | Permitir contenido en generación aumentada por recuperación | `true` |
| `derivative` | Permitir obras derivadas (traducciones, resúmenes) | `true` |

Se pueden hacer sobreescripciones por agente mediante el array `agents[].data_usage` (valores: `answer-engine`, `rag`, `training`, `derivative`).

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

**Artículos:**
- [agents.txt: el estándar que creé para que la IA sepa quién eres y qué puede hacer](https://asturwebs.es/blog/agents-txt-openapi-descubrimiento-agentes-ia-2026/) — qué es, por qué, arquitectura SSOT, las tres capas
- [BytIA: el chatbot que sabe dónde estás y cómo te sientes](https://asturwebs.es/blog/chatbot-ia-consciente-pagina-emociones-lead-scoring-2026/) — chatbot en producción alimentado por datos de agents.txt

Código fuente: [github.com/asturwebs/asturwebs-v2](https://github.com/asturwebs/asturwebs-v2)

## Usar agents.txt en tu chatbot

agents.txt no es solo para agentes IA externos — tu propio chatbot debería usarlo como **Fuente Única de Verdad (SSOT)**.

### ¿Por qué?

La mayoría de los chatbots tienen los datos del negocio (precios, servicios, contacto) hardcodeados en el prompt del sistema. Esto crea duplicación: cambias un precio y tienes que actualizar la web y el prompt por separado. agents.txt elimina eso.

### Cómo funciona

1. **Define** tus datos de negocio una vez en agents.txt (identidad, servicios, voz, términos)
2. **Sírvelos** programáticamente vía `/api/agents` (endpoint JSON)
3. **Inyéctalos** como contexto en el prompt de sistema de tu chatbot

### Ejemplo

```typescript
// 1. Obtén los datos de agents (o impórtalos desde tu módulo SSOT)
const agentsData = await fetch('https://asturwebs.es/api/agents').then(r => r.json());

// 2. Construye el contexto de negocio desde los datos
const businessContext = `
## Identidad
${agentsData.identity.name} — ${agentsData.identity.description}
Contacto: ${agentsData.identity.email} | ${agentsData.identity.phone}

## Servicios
${agentsData.services.map(s => `- ${s.name}: ${s.description}`).join('\n')}
`;

// 3. Inyecta como mensaje system, separado del comportamiento
const messages = [
  { role: 'system', content: systemPrompt },      // comportamiento
  { role: 'system', content: businessContext },    // datos desde agents.txt
  { role: 'user', content: userMessage },
];
```

### Beneficios

- **Fuente única de verdad** — cambias datos en agents.txt, tu chatbot lo refleja al instante
- **Prompts más limpios** — separas instrucciones de comportamiento de los datos de negocio
- **Reutilizable entre clientes** — en chatbots multi-tenant, cada cliente usa su propio agents.txt
- **A prueba de futuro** — al evolucionar tu negocio, tanto agentes externos como tu chatbot interno se mantienen sincronizados

> **Implementación real:** AsturWebs usa este patrón. El chatbot BytIA (asturwebs.es) obtiene su contexto de negocio del mismo `/api/agents` que sirve a agentes IA externos. Ver el [código fuente de asturwebs-v2](https://github.com/asturwebs/asturwebs-v2).

## Adoptantes

| Sitio | agents.txt | JSON API | OpenAPI |
|-------|-----------|----------|---------|
| [asturwebs.es](https://asturwebs.es/agents.txt) | ✅ | ✅ | ✅ |

*Para añadir tu sitio, abre un PR editando esta tabla.*

## Documentación

| Archivo | Propósito |
|---------|-----------|
| [docs/ecosystem.md](./docs/ecosystem.md) | Ecosistema competitivo, estrategia de posicionamiento, flywheel de adopción |
| [docs/research/](./docs/research/) | Investigación sobre estándares web para IA |

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

## Estándares relacionados

agents.txt es parte de un ecosistema creciente de estándares web legibles por máquinas para IA:

| Estándar | Propósito | Alcance |
|----------|-----------|---------|
| [robots.txt](https://datatracker.ietf.org/doc/html/rfc9309) (RFC 9309) | Control de acceso a crawlers | Nivel de red — qué rastrear |
| [llms.txt](https://llmstxt.org/) | Proveedor de contexto para LLMs | Conocimiento — qué entender |
| **agents.txt** (este) | Descubrimiento + permisos de agentes | Identidad + acciones + ejecución |
| [agents-brief.txt](https://github.com/jaspervanveen/agents-brief.txt) | Brief de misión del agente | Enfoque alternativo para instrucciones |
| [ai.txt](https://spawning.ai/ai-txt) (Spawning) | Consentimiento de entrenamiento | Opt-in/opt-out para entrenamiento |
| [ai.txt](https://arxiv.org/abs/2505.07834) (paper DSL) | Control granular de IA | Control por elemento HTML |
| [operate.txt](https://www.reddit.com/r/webdev/comments/1jln4dp/) | Guía de operación UI | Comportamiento de automatización |
| [AI Manifest](https://datatracker.ietf.org/doc/draft-han-ai-manifest/) (borrador IETF) | Instrucciones de flujo de trabajo | Ejecución de tareas paso a paso |
| [Model Context Protocol](https://modelcontextprotocol.io/) | Descubrimiento y ejecución de herramientas | Carga dinámica de herramientas |
