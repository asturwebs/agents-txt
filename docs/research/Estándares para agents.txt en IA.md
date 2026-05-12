# **Arquitectura de la Red de Agentes: Un Análisis Integral sobre los Estándares Emergentes para el Descubrimiento, Operación y Gobernanza de la Inteligencia Artificial**

La arquitectura fundamental de la World Wide Web, concebida originalmente para el consumo humano y posteriormente adaptada para el rastreo pasivo de motores de búsqueda, se encuentra en un punto de inflexión crítico. La transición de una web de documentos a una web de acciones, impulsada por la proliferación de agentes de inteligencia artificial autónomos, ha revelado las limitaciones estructurales de los protocolos de comunicación y permisos establecidos hace tres décadas. El estándar robots.txt, introducido en 1994, fue diseñado para una era de rastreadores lineales cuya única función era la indexación de contenido para su posterior recuperación.1 Sin embargo, los agentes contemporáneos, dotados de capacidades de razonamiento, planificación y ejecución de herramientas, requieren un marco de interacción mucho más sofisticado que el simple binario de acceso permitido o denegado.2

En respuesta a esta necesidad, ha surgido una plétora de propuestas, convenciones y borradores de estándares que buscan definir cómo los sitios web deben comunicarse con estos agentes. Estas iniciativas, que abarcan desde archivos de descubrimiento como agents.txt y agents-brief.txt, hasta capas de documentación optimizada como llms.txt y protocolos de operación como operate.txt y el AI Manifest, representan un esfuerzo colectivo para crear un sustrato legible por máquinas que facilite la economía de los agentes.4 Este informe analiza detalladamente cada una de estas convenciones, evaluando su base técnica, su estado de adopción y las implicaciones estratégicas para el ecosistema digital global.

## **El Estandar agents.txt y la Evolución hacia agents-brief.txt: Del Descubrimiento a la Intencionalidad**

La idea de un archivo agents.txt surge de la premisa de que todo negocio o servicio digital debería ser capaz de publicitar su propia identidad agentica a sistemas automatizados externos. En su concepción inicial, el proyecto agents.txt se propuso como un estándar para las interacciones Business-to-Agent (B2A), permitiendo que los motores de búsqueda y otros sistemas descubrieran no solo el contenido de una empresa, sino sus servicios de inteligencia artificial activos.4 Esta propuesta inicial contemplaba un archivo alojado en la raíz del dominio que detallara el nombre del agente, su propósito funcional y los protocolos de comunicación, como WebSockets o HTTP, además de los sistemas de pago compatibles como Stripe o PayPal.4

Sin embargo, el desarrollo de este estándar ha experimentado una metamorfosis significativa debido a la necesidad de mayor precisión técnica y a la resolución de conflictos de nomenclatura dentro de los organismos de estandarización. La investigación liderada por Jasper van Veen documenta un cambio de nombre de agents.txt a agent-manifest.txt y finalmente a agents-brief.txt.2 Esta evolución fue impulsada por el descubrimiento de que el término "agent manifest" ya estaba consolidado en la industria para describir la configuración interna de un agente (utilizado por Microsoft Copilot y el protocolo ACP), lo cual resultaba contraproducente para un archivo destinado a instruir a agentes visitantes.2 Además, la designación agents.txt fue reclamada por un borrador de la Internet Engineering Task Force (IETF), lo que obligó a buscar una nomenclatura que evitara colisiones legales y técnicas.2

El concepto actual de agents-brief.txt se posiciona como un documento de instrucciones o "misión" para el agente visitante. Mientras que robots.txt (RFC 9309\) se limita a informar qué partes del sitio pueden ser visualizadas, agents-brief.txt aborda el vacío operativo: declara qué acciones tiene permitido realizar el agente, cómo debe autenticarse, qué endpoints de API o servidores de Model Context Protocol (MCP) debe utilizar y bajo qué condiciones puede utilizar los datos para entrenamiento o generación aumentada por recuperación (RAG).2

### **Comparativa Estructural de las Versiones de agents.txt y agents-brief.txt**

La estructura de estos archivos hereda la simplicidad de robots.txt pero expande drásticamente los campos semánticos para cubrir las necesidades de la IA.

| Campo / Directiva | Propósito en agents.txt (Original) | Propósito en agents-brief.txt (Evolucionado) |
| :---- | :---- | :---- |
| User-Agent | Identificador del bot destinatario. | Identificador del bot o categoría de agente. |
| Agent / Site-Name | Nombre del servicio de IA local. | Identidad oficial del sitio para la IA. |
| Description / Site-Description | Resumen del servicio para humanos/IA. | Contexto semántico para el razonamiento del agente. |
| Communication-Protocol | Especificación de transporte (WebSocket/HTTP). | — |
| Preferred-Interface | — | Declaración de REST, GraphQL o MCP preferido. |
| API-Docs / MCP-Server | — | Enlaces directos a esquemas de acción legibles. |
| Allow-Actions | — | Permiso explícito para ejecutar transacciones. |
| Allow-Training / Allow-RAG | — | Control granular sobre el uso de la propiedad intelectual. |

2

Esta transición hacia un "brief" o informe de misión refleja un cambio de paradigma: ya no se trata solo de permitir el acceso a los datos, sino de gestionar la delegación de autoridad a sistemas autónomos. Las empresas que implementan agents-brief.txt están, de hecho, definiendo la superficie operativa que están dispuestas a exponer a la inteligencia artificial, mitigando el riesgo de que los agentes intenten realizar acciones para las cuales el sitio no está preparado o no otorga consentimiento.2

## **El Estandar llms.txt: La Capa de Documentación Optimizada para Modelos de Lenguaje**

Mientras que los esfuerzos en torno a agents.txt se centran en la identidad y la acción, el estándar llms.txt ha emergido como la solución más exitosa y de mayor adopción para la transferencia de conocimientos hacia modelos de lenguaje.5 Propuesto por Jeremy Howard y el equipo de Answer.AI en septiembre de 2024, llms.txt responde a una ineficiencia técnica fundamental: el contenido HTML moderno está diseñado para la renderización visual, no para el consumo de tokens por parte de un LLM.8 El ruido estructural de los anuncios, los scripts de seguimiento, el marcado de navegación complejo y la manipulación del DOM mediante JavaScript consume una cantidad desproporcionada de la ventana de contexto de los modelos, encareciendo y degradando la calidad de las respuestas.9

El estándar llms.txt propone un archivo Markdown simplificado ubicado en la raíz del dominio (/llms.txt). Este archivo actúa como una guía curada y jerárquica del contenido más valioso del sitio.8 A diferencia de un sitemap.xml, que es una lista exhaustiva de URLs para indexación, el llms.txt es un documento editorial que selecciona las páginas clave y proporciona descripciones semánticas que ayudan al modelo a construir un mapa mental coherente de la organización o el proyecto.8

### **Anatomía y Validación del Formato llms.txt**

Para que un archivo llms.txt sea efectivo y reconocido por herramientas como Claude, ChatGPT, Perplexity y asistentes de codificación como Cursor, debe seguir una estructura de validación estricta pero fácil de implementar.8

* **Encabezado H1 Requerido**: El nombre del proyecto o marca sirve como el ancla de identidad principal.8  
* **Bloque de Resumen (Blockquote)**: Un resumen crítico de una a tres oraciones que define la misión del sitio. Este bloque es el primer punto de referencia para que el modelo entienda el contexto general antes de explorar los enlaces.8  
* **Secciones H2 con Enlaces Curados**: Listas organizadas de URLs que apuntan a documentación, guías o servicios específicos. Cada enlace debe ir acompañado de una breve descripción que explique por qué esa página es relevante para la IA.8  
* **Archivos Complementarios (llms-full.txt)**: El estándar permite un archivo extendido que contiene el contenido completo de la documentación en un solo bloque de texto continuo, optimizado para modelos con ventanas de contexto masivas que prefieren procesar toda la información de una vez en lugar de realizar múltiples peticiones HTTP.5

La efectividad de llms.txt ha sido validada mediante experimentos de campo. Por ejemplo, se ha observado que Google AI Mode (Gemini) indexa estos archivos en el mismo día de su publicación, tratándolos como la fuente de identidad autoritativa para responder consultas sobre una marca o servicio.11 Además, bibliotecas de software como Instructor han adoptado el estándar para facilitar que las herramientas de IA generen código más preciso al tener acceso directo a una versión Markdown de sus docs.9

## **Gobernanza y Regulación de Datos: El Rol de ai.txt y los Derechos de Propiedad Intelectual**

El término ai.txt se manifiesta en el sector a través de dos vertientes principales: una enfocada en la defensa de los derechos de autor y otra en la creación de un lenguaje de control granular para la interacción entre la IA y la web.12

### **ai.txt de Spawning.ai: La Gestión del Consentimiento de Entrenamiento**

La propuesta de Spawning.ai utiliza ai.txt como una extensión lógica de robots.txt pero con una semántica específica para el entrenamiento de modelos.13 En el clima legal actual, marcado por litigios como *The New York Times v. OpenAI*, los propietarios de contenido necesitan un mecanismo para declarar sus preferencias sin bloquear totalmente el acceso a los buscadores tradicionales.12

El archivo ai.txt de Spawning permite declarar qué tipos de activos (texto, imágenes, audio, video) pueden ser utilizados para entrenamiento y cuáles no.14 Esta iniciativa se vincula con registros de "Do Not Train" (No Entrenar), donde los creadores pueden registrar sus dominios para que los desarrolladores de modelos que deseen cumplir con estándares éticos puedan filtrar estos datos de sus conjuntos de entrenamiento.13 A diferencia de los encabezados HTTP o las etiquetas meta, que a menudo se pierden al procesar grandes volúmenes de datos raspados, el archivo en la raíz del sitio proporciona una señal clara y persistente a nivel de dominio.14

### **ai.txt como Lenguaje Específico de Dominio (DSL) para la Regulación de la IA**

Una propuesta académica más profunda (arXiv:2505.07834) conceptualiza ai.txt como un Lenguaje Específico de Dominio (DSL) diseñado para abordar las deficiencias de granularidad de robots.txt.12 Mientras que robots.txt opera a nivel de ruta de URL, este DSL permite regular interacciones a nivel de elementos HTML individuales.12

Este enfoque introduce la capacidad de prohibir acciones específicas de la IA, como la sumarización, la traducción o la modificación de contenido, para partes concretas de una página web.12 La investigación propone un entorno de desarrollo integrado (IDE) basado en JetBrains MPS para que los administradores web puedan generar estos archivos de manera asistida, asegurando que las reglas sean tanto legibles por humanos como procesables algorítmicamente mediante representaciones XML.12

| Característica | robots.txt (Estándar Actual) | ai.txt (Propuesta DSL) |
| :---- | :---- | :---- |
| Granularidad | Nivel de URL / Directorio | Nivel de Elemento HTML (ej. p, img) |
| Control de Acciones | Binario (Permitir/Denegar) | Funcional (Summarize, Train, Crop, Translate) |
| Soporte de Instrucciones | Comandos Estáticos | Instrucciones de Lenguaje Natural para Prompts |
| Objetivo | Rastreadores de Búsqueda | Agentes de IA y Modelos Generativos |

12

Esta capacidad de insertar instrucciones de lenguaje natural directamente en el archivo de configuración permite que los agentes de IA con capacidades de procesamiento de lenguaje natural (NLP) traten estas directivas no solo como restricciones rígidas, sino como guías de comportamiento que se incorporan en sus procesos de razonamiento interno.12

## **El Desafío de la Operabilidad: operate.txt y el AI Manifest de la IETF**

Para que un agente de IA pueda navegar con éxito por procesos transaccionales complejos, como la reserva de un servicio o la gestión de un flujo de trabajo empresarial, necesita una comprensión profunda de la interfaz de usuario que va más allá de lo que el código HTML revela por sí solo.3 Aquí es donde entran en juego propuestas como operate.txt y el borrador de la IETF para un AI Manifest.3

### **operate.txt: Documentando la Capa de Comportamiento**

La propuesta de operate.txt nace de la frustración con los fallos constantes de los agentes de automatización de navegadores (como Claude Computer Use o Selenium) al enfrentarse a aplicaciones web modernas altamente asíncronas.3 Un agente a menudo no sabe si un clic en un botón ha fallado o si simplemente está esperando una respuesta del servidor que no se refleja inmediatamente en el DOM.3

El archivo operate.txt, estructurado en YAML, documenta aspectos críticos del comportamiento del sitio:

* **Acciones Irreversibles**: Identifica qué botones o acciones conllevan compromisos financieros o eliminación de datos, permitiendo que el agente solicite una confirmación adicional al usuario humano antes de proceder.3  
* **Dependencias de Formularios**: Explica las relaciones lógicas entre campos que pueden no ser evidentes para un modelo que solo analiza el DOM visualmente.3  
* **Recuperación de Errores**: Proporciona instrucciones sobre qué hacer cuando un flujo de trabajo se interrumpe, indicando si es seguro reintentar la operación o si se debe volver a un estado inicial.3

### **AI Manifest: Eficiencia de Tokens y Fiabilidad en Flujos de Trabajo**

El borrador draft-han-ai-manifest, presentado ante la IETF, busca estandarizar la forma en que los sitios web declaran instrucciones de flujo de trabajo paso a paso para agentes de IA.7 La premisa técnica central es que la inferencia constante del DOM es ineficiente y propensa a errores. Al proporcionar un manifiesto JSON que enumera operaciones ordenadas vinculadas a selectores CSS específicos, el sitio web puede guiar al agente de manera directa.7

Este manifiesto no solo mejora la tasa de éxito de las tareas —elevándola del 20% al 100% en pruebas controladas sobre sistemas ERP y portales gubernamentales— sino que reduce masivamente el consumo de tokens de entrada (hasta un 81.9%), ya que el agente no necesita analizar capturas de pantalla o árboles de DOM completos en cada paso.7 El protocolo prevé mecanismos de seguridad como un Registro Central de Confianza donde se almacenan hashes de los manifiestos para prevenir que actores malintencionados inyecten instrucciones fraudulentas en el flujo del agente.7

## **Fragmentación en la Estandarización: El Conflicto de la IETF y los Registros Centralizados**

A pesar de la evidente necesidad técnica de estos estándares, el proceso de formalización se enfrenta a una fragmentación significativa. El ecosistema de descubrimiento de agentes se encuentra actualmente dividido entre un enfoque de protocolos abiertos y un modelo de registros centralizados.16

### **La Crisis de los Borradores de la IETF**

Durante el año 2026, se ha reportado que múltiples propuestas, incluido el borrador draft-agents-txt, han expirado sin lograr la adopción de un grupo de trabajo (WG) oficial en la IETF.16 Esto ha dejado el problema del descubrimiento de agentes en un estado de incertidumbre. Existen al menos 11 borradores compitiendo en espacios similares (como ARDP, AID y esquemas de URI agent://), ninguno de los cuales ha logrado la masa crítica necesaria para convertirse en el estándar sucesor de robots.txt.16

Esta falta de consenso protocolar ha provocado un desplazamiento hacia soluciones de mercado. Ante la ausencia de un mecanismo de descubrimiento "en el sitio" (donde el agente consulta agents.txt directamente en el dominio), han surgido más de 15 registros independientes de agentes y servidores de Model Context Protocol (MCP).17

### **La Guerra de los Registros de Agentes**

Plataformas como Smithery, Glama, PulseMCP y mcp.run están compitiendo por convertirse en el directorio dominante de herramientas e integraciones de IA.16 Sin embargo, esta centralización presenta riesgos importantes:

* **Falta de Interoperabilidad**: Los registros a menudo no comparten datos entre sí, obligando a los desarrolladores a registrar sus agentes en múltiples plataformas.17  
* **Barreras de Acceso**: Algunos registros bloquean el rastreo abierto o exigen autenticación personalizada, lo que contradice el espíritu de una red abierta y accesible para cualquier agente autónomo.17  
* **Incentivos Económicos**: A diferencia de un estándar abierto como agents.txt, que beneficia a todos los propietarios de sitios por igual, los registros privados tienen incentivos para retener el tráfico y los datos de uso dentro de sus propios ecosistemas.3

Este escenario sugiere que la industria podría estar dirigiéndose hacia un modelo híbrido donde los agentes consultan registros globales para el descubrimiento inicial, pero dependen de archivos locales como agents-brief.txt o llms.txt para obtener instrucciones específicas de contexto y permisos de operación una vez que han llegado al dominio.2

## **Implementación Estratégica: Una Arquitectura de Red para Agentes**

Para las organizaciones que buscan preparar su infraestructura digital para la era de la IA, la adopción de estos estándares no debe verse como la elección de uno sobre otro, sino como la implementación de una arquitectura multicapa. Cada archivo cumple una función distinta en el ciclo de vida de la interacción de un agente.

| Capa de Interacción | Archivo / Protocolo Recomendado | Función Crítica para la Organización |
| :---- | :---- | :---- |
| **Acceso Básico** | robots.txt | Mantener la visibilidad en buscadores tradicionales y bloquear rastreadores maliciosos. |
| **Identidad y Acciones** | agents-brief.txt | Declarar qué puede hacer el agente y dónde están sus puntos de contacto (API/MCP). |
| **Conocimiento** | llms.txt | Proporcionar una base de conocimientos limpia y eficiente para modelos generativos. |
| **Operación UI** | operate.txt / AI Manifest | Asegurar que los flujos de trabajo automatizados no fallen y sean económicamente viables. |
| **Gobernanza Ética** | ai.txt (Spawning) | Ejercer el derecho de opt-out sobre el entrenamiento de modelos de terceros. |

2

### **Consideraciones sobre el Model Context Protocol (MCP)**

Es fundamental destacar el papel del Model Context Protocol (MCP) como el tejido conectivo entre estos archivos de configuración y la ejecución real de tareas.18 El MCP permite que los agentes carguen herramientas de forma dinámica, reduciendo la saturación del contexto al cargar solo lo necesario para una tarea específica.18 La mención de servidores MCP en archivos como agents-brief.txt permite que un agente visitante "descubra" capacidades de computación locales de manera inmediata, eliminando la necesidad de integraciones pre-cableadas o descubrimiento manual en registros externos.2

## **El Futuro de la Web Agentica: Hacia una Economía de Agentes Legible por Máquinas**

La convergencia de estas convenciones apunta hacia la creación de una "Web de Agentes" donde la mediación humana en el descubrimiento de servicios será la excepción y no la regla. El análisis de las tendencias actuales permite inferir varias evoluciones futuras de alto impacto.

En primer lugar, la Generative Engine Optimization (GEO) se consolidará como la nueva disciplina del marketing técnico, desplazando parcialmente al SEO tradicional.10 Las marcas que optimicen sus archivos llms.txt y agents.txt tendrán una ventaja competitiva masiva, ya que serán las fuentes preferidas de los asistentes de IA que hoy ya filtran la realidad para millones de usuarios.8 El caso de dev5310 GmbH demuestra que Google ya está utilizando activamente estos archivos para dar respuestas autoritativas en su modo de IA, lo que sugiere que el cumplimiento con estos estándares emergentes pronto será un requisito implícito para la relevancia digital.11

En segundo lugar, la seguridad de los agentes se convertirá en un campo de batalla crítico. A medida que los agentes asuman roles más autónomos en la ejecución de pagos y el manejo de datos sensibles, los archivos como operate.txt y los manifiestos firmados criptográficamente serán indispensables para prevenir desastres operativos y ataques de inyección de prompts a nivel de infraestructura.3

Finalmente, es probable que veamos una consolidación de estos estándares bajo el paraguas de organizaciones más ágiles que la IETF, o bien impulsada por los grandes proveedores de modelos (OpenAI, Anthropic, Google) quienes tienen el poder de mercado para imponer una convención simplemente comenzando a buscarla de forma predeterminada.3 La transición de agents.txt a agents-brief.txt es un recordatorio de que en el vertiginoso mundo de la inteligencia artificial, los estándares se forjan a través de la experimentación práctica y la adopción comunitaria antes de llegar a los comités de formalización.

En conclusión, para cualquier entidad con presencia en la red, la pregunta ya no es si debe tener un archivo para agentes, sino cuán completa es su superficie de comunicación con la IA. La implementación de estas convenciones no es solo una tarea técnica, sino una declaración estratégica de apertura y control en la nueva economía autónoma.2

#### **Obras citadas**

1. ai.txt: A Domain-Specific Language for Guiding AI Interactions with the Internet \- arXiv, fecha de acceso: mayo 12, 2026, [https://arxiv.org/html/2505.07834v1](https://arxiv.org/html/2505.07834v1)  
2. jaspervanveen/agents-brief.txt: A proposed web standard for AI agent interaction declarations — the agents.txt spec \- GitHub, fecha de acceso: mayo 12, 2026, [https://github.com/jaspervanveen/agents-txt](https://github.com/jaspervanveen/agents-txt)  
3. I'm proposing operate.txt \- a standard file that tells AI agents how to operate your website (like robots.txt but for the interactive layer) : r/webdev \- Reddit, fecha de acceso: mayo 12, 2026, [https://www.reddit.com/r/webdev/comments/1rzdtsg/im\_proposing\_operatetxt\_a\_standard\_file\_that/](https://www.reddit.com/r/webdev/comments/1rzdtsg/im_proposing_operatetxt_a_standard_file_that/)  
4. dennj/agents.txt: agents.txt standard for AI Agent discovery ... \- GitHub, fecha de acceso: mayo 12, 2026, [https://github.com/dennj/agents.txt](https://github.com/dennj/agents.txt)  
5. /llms.txt—a proposal to provide information to help LLMs use websites – Answer.AI, fecha de acceso: mayo 12, 2026, [https://www.answer.ai/posts/2024-09-03-llmstxt.html](https://www.answer.ai/posts/2024-09-03-llmstxt.html)  
6. We built a Claude skill that browses your site and generates a complete guideline file for AI agents. : r/SaaS \- Reddit, fecha de acceso: mayo 12, 2026, [https://www.reddit.com/r/SaaS/comments/1s2ed1v/we\_built\_a\_claude\_skill\_that\_browses\_your\_site/](https://www.reddit.com/r/SaaS/comments/1s2ed1v/we_built_a_claude_skill_that_browses_your_site/)  
7. draft-han-ai-manifest-00 \- AI Manifest: Embedded Workflow Instructions for AI Agents \- IETF Datatracker, fecha de acceso: mayo 12, 2026, [https://datatracker.ietf.org/doc/draft-han-ai-manifest/](https://datatracker.ietf.org/doc/draft-han-ai-manifest/)  
8. What Is llms.txt? The Annotated Spec, Working Examples, and Setup Guide \- W2B Agency, fecha de acceso: mayo 12, 2026, [https://w2bagency.com/blog/what-is-llms-txt](https://w2bagency.com/blog/what-is-llms-txt)  
9. Instructor Adopts llms.txt: Making Documentation AI-Friendly, fecha de acceso: mayo 12, 2026, [https://python.useinstructor.com/blog/2025/03/19/instructor-adopts-llms-txt/](https://python.useinstructor.com/blog/2025/03/19/instructor-adopts-llms-txt/)  
10. LLMs.txt & ai.txt Validator \- Free Online Checker for AI-Readable Files, fecha de acceso: mayo 12, 2026, [https://llmstxtvalidator.dev/](https://llmstxtvalidator.dev/)  
11. We Submitted llms.txt to Google Search Console. 3 Days Later, It Was Powering AI Answers \- dev5310, fecha de acceso: mayo 12, 2026, [https://www.dev5310.com/en/lab/llms-txt-is-powering-ai-answers](https://www.dev5310.com/en/lab/llms-txt-is-powering-ai-answers)  
12. ai. txt: A Domain-Specific Language for Guiding AI Interactions with ..., fecha de acceso: mayo 12, 2026, [https://arxiv.org/abs/2505.07834](https://arxiv.org/abs/2505.07834)  
13. RSL Collective—written evidence (AIC0023) \- h t t p s : / / c o m m i t t e e s . p a r l i a m e n t . u k, fecha de acceso: mayo 12, 2026, [https://committees.parliament.uk/writtenevidence/161913/pdf/](https://committees.parliament.uk/writtenevidence/161913/pdf/)  
14. Copyright and AI: machine-readable reservation of rights and the need for a universal standard \- Bristows Inquisitive Minds, fecha de acceso: mayo 12, 2026, [https://inquisitiveminds.bristows.com/post/102jtoy/copyright-and-ai-machine-readable-reservation-of-rights-and-the-need-for-a-unive](https://inquisitiveminds.bristows.com/post/102jtoy/copyright-and-ai-machine-readable-reservation-of-rights-and-the-need-for-a-unive)  
15. HA BookStack Docs \- automatically generates and maintains documentation for your Home Assistant setup in Bookstack : r/homeassistant \- Reddit, fecha de acceso: mayo 12, 2026, [https://www.reddit.com/r/homeassistant/comments/1s3sw5u/ha\_bookstack\_docs\_automatically\_generates\_and/](https://www.reddit.com/r/homeassistant/comments/1s3sw5u/ha_bookstack_docs_automatically_generates_and/)  
16. The IETF agents.txt draft expires April 10 with no working group adoption : r/mcp \- Reddit, fecha de acceso: mayo 12, 2026, [https://www.reddit.com/r/mcp/comments/1seszp6/the\_ietf\_agentstxt\_draft\_expires\_april\_10\_with\_no/](https://www.reddit.com/r/mcp/comments/1seszp6/the_ietf_agentstxt_draft_expires_april_10_with_no/)  
17. The agent discovery problem: 11 IETF drafts, 15+ registries, 100K+ agents, zero interoperability : r/AI\_Agents \- Reddit, fecha de acceso: mayo 12, 2026, [https://www.reddit.com/r/AI\_Agents/comments/1sgj9lv/the\_agent\_discovery\_problem\_11\_ietf\_drafts\_15/](https://www.reddit.com/r/AI_Agents/comments/1sgj9lv/the_agent_discovery_problem_11_ietf_drafts_15/)  
18. llms \- full.txt \- Model Context Protocol, fecha de acceso: mayo 12, 2026, [https://modelcontextprotocol.io/llms-full.txt](https://modelcontextprotocol.io/llms-full.txt)  
19. How to optimize a website for AI crawlers & AI agents \- Search Engine Land, fecha de acceso: mayo 12, 2026, [https://searchengineland.com/guide/optimize-for-ai-crawlers](https://searchengineland.com/guide/optimize-for-ai-crawlers)