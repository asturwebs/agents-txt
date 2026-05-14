# agents.txt — AI 智能体发现开放标准

[![Standard: agents.txt](https://img.shields.io/badge/Standard-agents.txt_v2.0-blue?style=flat-square&logo=ai&logoColor=orange)](https://github.com/asturwebs/agents-txt)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)

**版本：** 2.0 | **许可证：** MIT | **状态：** 草案

🌐 [Español](./README.es.md) | [English](./README.md) | **中文**

---

## 什么是 agents.txt？

一个**人类可读、机器可解析**的文件，网站放置在其根目录（`/agents.txt`）中，用于声明其身份、AI 智能体使用条款、服务目录和智能体端点。

它填补了以下标准之间的空白：
- **`robots.txt`** — 告诉爬虫*是否*可以访问页面（网络层面）
- **`llms.txt`** — 为 LLM 提供*上下文*信息（只读）
- **`agents.txt`** — 告诉 AI 智能体*你是谁、你提供什么、它们可以做什么*（身份 + 权限 + 执行）

## 快速示例

```markdown
# agents.txt — example.com
# Version: 2.0
# Updated: 2026-05-12
# License: MIT

## Identity

---yaml
identity:
  name: 示例企业
  owner: 张伟
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
    name: "咨询服务"
    starting_price: "¥1500/小时"
    url: https://example.com/consulting/
---

## Agentic Endpoints

---yaml
api_schema:
  type: openapi  # 或 "mcp" 用于 Model Context Protocol
  version: 3.1.0
  url: https://example.com/openapi.json
---
```

## 为什么需要 agents.txt？

当自主 AI 智能体访问你的网站时，它需要回答：
- **"谁在经营这个业务？"** → Identity 部分
- **"我可以使用这些数据吗？"** → 数据使用协议 (Terms of Use) 部分
- **"他们提供什么？"** → Services 部分
- **"我可以编程方式交互吗？"** → Agentic Endpoints（OpenAPI）

没有其他标准同时提供这四项功能。

## 各部分说明

| 部分 | 用途 | 是否必需 |
|------|------|----------|
| **Header** | 版本、日期、许可证 | 是 |
| **Discovery** | 交叉引用 robots.txt、llms.txt、openapi.json | 推荐 |
| **Terms of Use** | AI 智能体可以使用/不可以使用你的数据做什么 | 是 |
| **Identity** | 企业名称、所有者、联系方式、位置 | 是 |
| **Brand Voice** | 品牌基调 (System Prompt) — 智能体应如何代表你的品牌 | 可选 |
| **Services** | 你提供什么、价格、URL | 推荐 |
| **Agentic Endpoints** | Agent 调用端点 (Tool Calling) — OpenAPI 规范 | 可选 |

## 格式

- **Markdown**，嵌入 **YAML 块**（`---yaml` ... `---`）
- 人类可读优先，机器可解析其次
- YAML 块包含所有结构化数据；其余部分为散文文本

## 与 robots.txt 集成

在 `robots.txt` 中添加发现指针，以便智能体找到你的 `agents.txt`：

```text
User-agent: *
Allow: /

# AI Agent Discovery
Agent-discovery: https://example.com/agents.txt
LLM-context: https://example.com/llms.txt

Sitemap: https://example.com/sitemap.xml
```

## JSON API 和模式

在 `/api/agents` 以结构化 JSON 提供相同数据。[json-schema.json](./json-schema.json) 定义结构：

| 对象 | 描述 | 必需 |
|------|------|------|
| `identity` | 业务所有者、联系方式、网站 | **是** |
| `terms` | 智能体权限（allowed/denied）和条件 | 否 |
| `voice` | AI 智能体的行为指令 | 否 |
| `services` | 服务目录、定价和 URL | 否 |
| `api_schema` | OpenAPI 或 MCP 规范引用（用于工具调用） | 否 |

### 数据使用控制

`terms.data_usage` 对象提供对代理如何使用你内容的精细控制：

| 权限 | 描述 | 默认值 |
|------|------|--------|
| `training` | 允许内容用于训练基础模型 | `false` |
| `rag` | 允许内容用于检索增强生成 | `true` |
| `derivative` | 允许衍生作品（翻译、摘要） | `true` |

可通过 `agents[].data_usage` 数组按代理覆盖（值：`answer-engine`、`rag`、`training`、`derivative`）。

### 验证你的实现

```bash
# 使用 ajv-cli
npx ajv-cli validate -s json-schema.json -d your-api-response.json

# 使用内置验证脚本
./tools/validate.sh https://example.com/api/agents
```

## 生产环境实现

**AsturWebs** — 首个生产环境实现：
- [agents.txt](https://asturwebs.es/agents.txt) — Markdown 版本
- [/api/agents](https://asturwebs.es/api/agents) — JSON 版本
- [openapi.json](https://asturwebs.es/openapi.json) — OpenAPI 3.1.0 规范

源代码：[github.com/asturwebs/asturwebs-v2](https://github.com/asturwebs/asturwebs-v2)

## 在你的聊天机器人中使用 agents.txt

agents.txt 不仅适用于外部 AI 代理 — 你自己的聊天机器人也应将其用作**唯一真实来源 (SSOT)**。

### 为什么？

大多数聊天机器人将业务数据（价格、服务、联系方式）硬编码在系统提示词中。这会造成重复：修改价格时，你必须同时更新网站和提示词。agents.txt 消除了这个问题。

### 工作原理

1. **定义** — 在 agents.txt 中一次性定义你的业务数据（身份、服务、品牌声音、条款）
2. **提供** — 通过 `/api/agents`（JSON 端点）以编程方式提供数据
3. **注入** — 在运行时将数据作为上下文注入聊天机器人的系统提示词

### 示例

```typescript
// 1. 获取 agents 数据（或从你的 SSOT 模块导入）
const agentsData = await fetch('https://asturwebs.es/api/agents').then(r => r.json());

// 2. 从数据构建业务上下文
const businessContext = `
## 身份
${agentsData.identity.name} — ${agentsData.identity.description}
联系方式：${agentsData.identity.email} | ${agentsData.identity.phone}

## 服务
${agentsData.services.map(s => `- ${s.name}: ${s.description}`).join('\n')}
`;

// 3. 作为系统消息注入，与行为指令分开
const messages = [
  { role: 'system', content: systemPrompt },      // 仅行为指令
  { role: 'system', content: businessContext },    // 来自 agents.txt 的数据
  { role: 'user', content: userMessage },
];
```

### 优势

- **唯一真实来源** — 修改 agents.txt 中的数据，聊天机器人即时反映
- **更简洁的提示词** — 将行为指令与业务数据分离
- **跨客户端可复用** — 对于多租户聊天机器人，每个客户端使用自己的 agents.txt
- **面向未来** — 随着业务发展，外部代理和内部聊天机器人保持同步

> **实际应用案例：** AsturWebs 使用此模式。其聊天机器人 BytIA (asturwebs.es) 从同一 `/api/agents` 获取业务上下文，该端点也为外部 AI 代理提供服务。查看 [asturwebs-v2 源代码](https://github.com/asturwebs/asturwebs-v2)。

## 采用者

| 网站 | agents.txt | JSON API | OpenAPI |
|------|-----------|----------|---------|
| [asturwebs.es](https://asturwebs.es/agents.txt) | ✅ | ✅ | ✅ |

*如需添加你的网站，请提交 PR 编辑此表格。*

## 贡献

1. 提交 issue 说明你的用例或反馈
2. 提交 PR 改进规范或添加翻译
3. 将你的实现添加到采用者表格

## 采用者徽章

如果你的网站已实现此标准，请展示：

```markdown
[![agents.txt compliant](https://img.shields.io/badge/Standard-agents.txt_v2.0-blue?style=flat-square&logo=ai&logoColor=orange)](https://github.com/asturwebs/agents-txt)
```

## 许可证

MIT — 自由复制、改编、集成到任何商业或开源项目中。

## 相关标准

agents.txt 是不断增长的 AI 机器可读 Web 标准生态系统的一部分：

| 标准 | 用途 | 范围 |
|------|------|------|
| [robots.txt](https://datatracker.ietf.org/doc/html/rfc9309) (RFC 9309) | 爬虫访问控制 | 网络层 — 允许抓取什么 |
| [llms.txt](https://llmstxt.org/) | LLM 上下文提供 | 知识 — 理解什么 |
| **agents.txt**（本标准） | 代理发现 + 权限 | 身份 + 操作 + 执行 |
| [agents-brief.txt](https://github.com/jaspervanveen/agents-brief.txt) | 代理任务简报 | 代理指令的替代方案 |
| [ai.txt](https://spawning.ai/ai-txt) (Spawning) | 训练同意 | 模型训练的选择加入/退出 |
| [ai.txt](https://arxiv.org/abs/2505.07834) (DSL 论文) | 精细化 AI 控制 | 按 HTML 元素控制 |
| [operate.txt](https://www.reddit.com/r/webdev/comments/1jln4dp/) | UI 操作指南 | 浏览器自动化行为 |
| [AI Manifest](https://datatracker.ietf.org/doc/draft-han-ai-manifest/) (IETF 草案) | 工作流指令 | 分步任务执行 |
| [Model Context Protocol](https://modelcontextprotocol.io/) | 工具发现和执行 | 代理的运行时工具加载 |
