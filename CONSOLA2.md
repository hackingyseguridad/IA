[![http://hackingyseguridad.com/](https://github.com/hackingyseguridad/ia/raw/main/banner.png)](https://github.com/hackingyseguridad/ia/blob/main/banner.png)

---

### Hacking ofensivo con IA en local: modelos y agentes especializados en programación y ciberseguridad

Esta guía recopila herramientas de **IA generativa/agéntica ejecutadas en local o en terminal (CLI)**, orientadas a dos usos complementarios en ciberseguridad:

1. **Detección e investigación de vulnerabilidades conocidas (CVE)** — análisis de código, identificación de patrones vulnerables, correlación con bases de datos públicas.
2. **Hacking ofensivo / explotación** — generación de *scripts* de explotación, *Proofs of Concept* (PoC) listos para copiar y pegar, o conexión directa de la IA con un sistema **Kali Linux** mediante *Function Calling*, permitiendo que el propio modelo ejecute comandos y herramientas del sistema operativo.

## Índice

- [Tabla resumen de herramientas](#tabla-resumen-de-herramientas)
- [Gemini-Cli](#gemini-cli)
- [OpenAI Codex CLI (GPT-5.6)](#openai-codex-cli-gpt-56)
- [Claude Code](#claude-code)
  - [Instalación](#instalación-de-claude-code)
  - [CLAUDE.md y Skills](#claudemd-y-skills)
  - [Claude Code Security (Mythos)](#claude-code-security-mythos)
- [DeepSeek Coder](#deepseek-coder)
- [Ollama](#ollama)
- [Mistral IA](#mistral-ia)
- [Qwen 3.6](#qwen-36)
- [Comparativa: IA local vs IA en la nube para hacking](#comparativa-ia-local-vs-ia-en-la-nube-para-hacking)
- [Referencias](#referencias)

---

### Tabla resumen de herramientas

| Herramienta | Tipo | Entorno / SO | Function Calling | Requisitos destacados | Enlace |
|---|---|---|---|---|---|
| **Gemini-Cli** | Agente IA (Google) en terminal | Kali Linux (paquete) | Sí — interactúa con dispositivos, comandos y conexión de red | Paquetes `gemini-cli`, `llm-tools-nmap`, `mcp-kali-server` | [kali.org/tools/gemini-cli](https://www.kali.org/tools/gemini-cli/) |
| **OpenAI Codex CLI (GPT-5.6)** | Agente IA (OpenAI) en terminal | Multiplataforma, sandbox propio | Sí — ejecuta comandos con sandbox y modos de aprobación | Node.js (`npm i -g @openai/codex`), cuenta OpenAI/ChatGPT o API key | [developers.openai.com/codex/cli](https://developers.openai.com/codex/cli) |
| **Claude Code** | Agente IA (Anthropic) en terminal | Multiplataforma | Sí — ejecuta scripts, analiza código y valida explotabilidad | Node.js, shell compatible (bash/zsh) | [code.claude.com/docs/es](https://code.claude.com/docs/es/overview/) |
| **DeepSeek Coder** | LLM especializado en programación | Local (CLI) | No nativo | Menos restrictivo en su versión base; útil para detección de bugs críticos | [deepseek2.sh](https://github.com/hackingyseguridad/IA/blob/main/deepseek2.sh) |
| **Ollama** | Gestor/ejecutor de LLMs local | CPU / GPU / NPU | Depende del modelo cargado | Descarga, ejecuta y gestiona modelos cuantizados en local | [ollama.com](https://ollama.com) |
| **Mistral IA** | LLM (chat/API) | Local vía Ollama o web | No nativo | Sin restricciones fuertes para detallar CVE, PoC y exploits | [chat.mistral.ai](https://chat.mistral.ai) |
| **Qwen 3.6** | LLM (Alibaba) | Local (CLI) | No nativo | Requiere ~23 GB de espacio en disco | [qwen3_6.sh](https://github.com/hackingyseguridad/IA/blob/main/qwen3_6.sh) |
| **OpenClaw** | Agente IA en terminal (TUI/gateway) | Kali Linux | Sí — interactúa con herramientas de Kali y la conexión disponible | Token de autenticación, gateway propio | [openclaw.ai](https://openclaw.ai/) |

---

### Gemini-Cli

[Gemini-Cli](https://www.kali.org/tools/gemini-cli/) es la IA de Google integrada como herramienta en la terminal (CLI) de **Kali Linux**, con capacidad de *Function Calling*: puede interactuar directamente sobre los dispositivos, ejecutar comandos y operar la conexión de la máquina.

**Paquetes relacionados:**
- `gemini-cli`
- `llm-tools-nmap`
- `mcp-kali-server`

[![hacking con IA Gemini-Cli](https://github.com/hackingyseguridad/ia/raw/main/gemini-cli.png)](https://github.com/hackingyseguridad/ia/blob/main/gemini-cli.png)

---

### OpenAI Codex CLI (GPT-5.6)

**OpenAI Codex CLI** es el agente de terminal de OpenAI, equivalente funcional a Claude Code y Gemini-Cli: inspecciona código, ejecuta comandos, modifica ficheros y automatiza tareas repetitivas sin salir de la consola. Es *open source* (licencia Apache-2.0, repositorio `openai/codex`, reescrito en Rust) y desde el **26 de junio de 2026** utiliza como modelo por defecto la familia **GPT-5.6**.

Es la primera vez que OpenAI lanza una familia de modelos en **tres niveles** en lugar de un único modelo insignia, pensados para equilibrar coste y capacidad según la tarea:

| Nivel | Enfoque | Precio (entrada / salida por millón de tokens) | Uso recomendado |
|---|---|---|---|
| **GPT-5.6 Sol** | Máxima capacidad de razonamiento (incluye modo *max reasoning effort*); orientado a programación compleja, ciberseguridad y tareas agénticas de largo horizonte | 5 $ / 30 $ | Auditoría de código, análisis de vulnerabilidades, cadenas de tareas largas |
| **GPT-5.6 Terra** | Rendimiento equivalente a GPT-5.5 a mitad de coste | 2,50 $ / 15 $ | Programación diaria, tests, revisión de código |
| **GPT-5.6 Luna** | Nivel de volumen: respuestas más rápidas y económicas | 1 $ / 6 $ | Automatización masiva, resúmenes, generación de código sencillo |

>  Según *benchmarks* de 2026, **GPT-5.6 Sol Ultra** lidera Terminal-Bench 2.1 con un 91,9 % de acierto, mientras que en SWE-Bench Verified el liderazgo lo mantienen modelos de la familia Mythos/Fable de Anthropic.

### Instalación de Codex CLI

```bash
# Instalar Codex CLI
npm install -g @openai/codex

# Autenticarse (cuenta ChatGPT/OpenAI o API key)
codex auth login

# Probar sobre un proyecto (modo con edición automática)
cd tu-proyecto
codex --auto-edit "Explica esta base de código y sugiere mejoras"

# Elegir modelo y nivel de razonamiento por tarea
codex --model gpt-5.6-sol "Analiza este binario en busca de vulnerabilidades"
codex --model gpt-5.6-luna "Añade comentarios JSDoc a las funciones exportadas"
```

**Gestión de skills y servidores MCP desde Codex CLI:**

```bash
# Instalar una skill
codex skills install @openai/web-search
codex skills install @openai/code-review

# Listar skills instaladas
codex skills list

# Añadir un servidor MCP (p. ej. para pruebas de navegador)
codex mcp add playwright -- npx -y @playwright/mcp

# Listar servidores MCP conectados
codex mcp list
```

Al igual que con `CLAUDE.md`, Codex CLI admite un fichero **`AGENTS.md`** en la raíz del proyecto con las convenciones e instrucciones del proyecto; este fichero es además compatible con otras herramientas del ecosistema (Cursor, Amp, etc.), por lo que basta con escribirlo una vez.

Punto fuerte diferencial de Codex CLI frente a otros agentes: su **sandbox de ejecución**, considerado uno de los entornos más seguros para la ejecución autónoma de código, con distintos modos de aprobación (`/permissions`) antes de dejar que el agente modifique ficheros o ejecute comandos.

---

### Claude Code

[Claude Code](https://code.claude.com/docs/es/overview/) es el agente de IA de **Anthropic** ejecutado desde terminal (CLI), con una alta capacidad de análisis de código. Admite **Skills** instalables (plugins) que especializan al agente en tareas concretas, por ejemplo el análisis de vulnerabilidades o flujos específicos de hacking.

### Instalación de Claude Code

```bash
# Instalar Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Añadir el binario al PATH
cd ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc

# Verificar instalación
claude --version

# Lanzar Claude Code
claude
```

[![hacking con IA Claude Code](https://github.com/hackingyseguridad/ia/raw/main/claudecode.png)](https://github.com/hackingyseguridad/ia/blob/main/claudecode.png)

### CLAUDE.md y Skills

Se puede crear un fichero [`CLAUDE.md`](https://github.com/hackingyseguridad/IA/blob/main/CLAUDE.md) con los requisitos y la preconfiguración específica de los parámetros deseados para cualquier automatización, aplicación web, API o aplicativo que se construya con Claude.

Las **Skills** son los requisitos específicos, o información adicional, que se le da a la IA para especializarla. Existen dos tipos:

| Tipo de Skill | Descripción |
|---|---|
| **Skills de capacidad** | Definen una tarea específica que la IA sabe ejecutar |
| **Skills secuenciales** | Definen una automatización, es decir, una secuencia de pasos encadenados |

**Estructura de ficheros típica:**

```
CLAUDE.md
.claude/skills/Vuln/
.claude/skills/poc/
.claude/skills/exploit/
```

### Claude Code Security (Mythos)

**Anthropic Claude Code Security (Mythos)** opera de forma **agéntica**: no es un simple emulador ni un sandbox aislado, sino que:

- Interactúa con herramientas reales y ejecuta scripts.
- Analiza código en busca de vulnerabilidades lógicas complejas.
- Detecta corrupción de memoria y fallos estructurales en sistemas operativos, navegadores (p. ej. Firefox) y protocolos de red.
- Simula el comportamiento de un atacante y analiza las respuestas del sistema objetivo para **validar si el fallo descubierto es realmente explotable**.

**Extensiones relacionadas:**
- [hackingtool — Claude Code plugin](https://github.com/AKCodez/hackingtool-plugin)

---

## DeepSeek Coder

[DeepSeek Coder](https://github.com/hackingyseguridad/IA/blob/main/deepseek2.sh) es un modelo de lenguaje especializado en programación. Suele ser **menos restrictivo en su versión base** cuando se ejecuta en la terminal (CLI) localmente, lo que lo hace útil para la detección de *bugs* críticos.

---

## Ollama

[Ollama](https://ollama.com) es una herramienta *open source* que permite **descargar, ejecutar y gestionar modelos de lenguaje (LLMs)** comprimidos, cuantizados y optimizados, en local, sobre CPU, GPU o NPU.

- Catálogo de modelos: <https://ollama.com/search>
- Integración con Claude Code: <https://docs.ollama.com/integrations/claude-code#recommended-models>

---

### Mistral IA

[Mistral IA](https://chat.mistral.ai) destaca por no aplicar restricciones fuertes a la hora de detallar el funcionamiento de vulnerabilidades CVE, PoC y exploits, incluyendo la generación de código para su explotación o enlaces relacionados.

**Ejecución local vía Ollama:**

```bash
ollama run mistral
```

[![hacking con Mistral IA](https://github.com/hackingyseguridad/IA/raw/main/mistral.png)](https://github.com/hackingyseguridad/IA/blob/main/mistral.png)

---

### Qwen 3.6

[Qwen 3.6](https://github.com/hackingyseguridad/IA/blob/main/qwen3_6.sh) es la IA de **Alibaba**. Requiere aproximadamente **23 GB de espacio en disco duro** para su instalación local.

---

## Comparativa: IA local vs IA en la nube para hacking

| Criterio | IA local (Ollama, DeepSeek, Qwen, Mistral-local) | IA en la nube / agente CLI conectado (Claude Code, Gemini-Cli, OpenClaw, Codex CLI) |
|---|---|---|
| Privacidad de los datos | Alta — no sale de la máquina | Depende del proveedor y su política de datos |
| Capacidad de ejecutar comandos (Function Calling) | Limitada, salvo integración manual | Nativa en varias de estas herramientas; Codex CLI destaca por su sandbox con modos de aprobación |
| Restricciones de contenido sensible (CVE/PoC/exploit) | Generalmente menores en modelos base | Varían según el proveedor y las políticas de seguridad aplicadas |
| Requisitos de hardware | Altos (disco, GPU/CPU/NPU) | Bajos en el cliente; el cómputo ocurre en la nube |
| Coste | Gratuito tras la descarga del modelo | Suscripción, créditos o token de API — p. ej. GPT-5.6 Sol: 5$/30$ por millón de tokens (entrada/salida); Terra: 2,50$/15$; Luna: 1$/6$ |
| Validación de explotabilidad real | Manual | Algunos agentes (p. ej. Claude Code Security) la automatizan |
| Fichero de instrucciones del proyecto | No aplica | `CLAUDE.md` (Claude Code) / `AGENTS.md` (Codex CLI, también leído por Cursor y Amp) |

---

## Referencias

| Recurso | Enlace |
|---|---|
| Ollama | <https://ollama.com/> |
| OpenAI Codex CLI (documentación oficial) | <https://developers.openai.com/codex/cli> |
| Repositorio OpenAI Codex (Apache-2.0, Rust) | <https://github.com/openai/codex> |
| Integración Ollama + Claude Code | <https://docs.ollama.com/integrations/claude-code#recommended-models> |
| DeepSeek-Coder (repositorio) | <https://github.com/deepseek-ai/DeepSeek-Coder/> |
| Anthropic knowledge-work-plugins | <https://github.com/anthropics/knowledge-work-plugins> |
| Claude Security (beta pública) | <https://claude.com/product/claude-security#public-beta> |
| OpenClaw — guía de inicio | <https://docs.openclaw.ai/start/getting-started> |
| Gemini-Cli en Kali Linux | <https://www.kali.org/tools/gemini-cli/> |
| Pentest-Copilot | <https://github.com/bugbasesecurity/pentest-copilot> |
| Offensive-Claude | <https://github.com/hypnguyen1209/offensive-claude> |
| OpenCode | <https://opencode.ai/> |
| Enlace adicional | <http://goo.gl/ID8XBX> |



#
http://www.hackingyseguridad.com/
#
