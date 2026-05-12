# agents.txt — AI 智能体发现开放标准

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

| Agent | Owner | Allowed usage | Conditions |
|-------|-------|---------------|------------|
| Googlebot | Google | Full indexing | — |
| GPTBot | OpenAI | Answer-engine only | Attribute source |

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
  type: openapi
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

## JSON API

在 `/api/agents` 以结构化 JSON 提供相同数据。使用 [json-schema.json](./json-schema.json) 进行验证。

## 生产环境实现

**AsturWebs** — 首个生产环境实现：
- [agents.txt](https://asturwebs.es/agents.txt) — Markdown 版本
- [/api/agents](https://asturwebs.es/api/agents) — JSON 版本
- [openapi.json](https://asturwebs.es/openapi.json) — OpenAPI 3.1.0 规范

源代码：[github.com/asturwebs/asturwebs-v2](https://github.com/asturwebs/asturwebs-v2)

## 采用者

| 网站 | agents.txt | JSON API | OpenAPI |
|------|-----------|----------|---------|
| [asturwebs.es](https://asturwebs.es/agents.txt) | ✅ | ✅ | ✅ |

*如需添加你的网站，请提交 PR 编辑此表格。*

## 贡献

1. 提交 issue 说明你的用例或反馈
2. 提交 PR 改进规范或添加翻译
3. 将你的实现添加到采用者表格

## 许可证

MIT — 自由复制、改编、集成到任何商业或开源项目中。
