[![http://hackingyseguridad.com/](https://github.com/hackingyseguridad/ia/raw/main/banner.png)](https://github.com/hackingyseguridad/ia/blob/main/banner.png)

---

# Hacking ofensivo con IA en local: modelos y agentes especializados en programación y ciberseguridad

Esta guía recopila herramientas de **IA generativa/agéntica ejecutadas en local o en terminal (CLI)**, orientadas a dos usos complementarios en ciberseguridad:

1. **Detección e investigación de vulnerabilidades conocidas (CVE)** — análisis de código, identificación de patrones vulnerables, correlación con bases de datos públicas.
2. **Hacking ofensivo / explotación** — generación de *scripts* de explotación, *Proofs of Concept* (PoC) listos para copiar y pegar, o conexión directa de la IA con un sistema **Kali Linux** mediante *Function Calling*, permitiendo que el propio modelo ejecute comandos y herramientas del sistema operativo.

> ⚠️ **Uso responsable:** todas las herramientas descritas deben emplearse únicamente en entornos propios, laboratorios controlados o con autorización explícita (pentesting autorizado, CTF, formación). El uso contra sistemas de terceros sin permiso es ilegal.

## Índice

- [Tabla resumen de herramientas](#tabla-resumen-de-herramientas)
- [Gemini-Cli](#gemini-cli)
- [Claude Code](#claude-code)
  - [Instalación](#instalación-de-claude-code)
  - [CLAUDE.md y Skills](#claudemd-y-skills)
  - [Claude Code Security (Mythos)](#claude-code-security-mythos)
- [DeepSeek Coder](#deepseek-coder)
- [Ollama](#ollama)
- [Mistral IA](#mistral-ia)
- [Qwen 3.6](#qwen-36)
- [OpenClaw](#openclaw)
  - [Comandos de consola](#comandos-de-consola-openclaw)
- [Comparativa: IA local vs IA en la nube para hacking](#comparativa-ia-local-vs-ia-en-la-nube-para-hacking)
- [Referencias](#referencias)

---

## Tabla resumen de herramientas

| Herramienta | Tipo | Entorno / SO | Function Calling | Requisitos destacados | Enlace |
|---|---|---|---|---|---|
| **Gemini-Cli** | Agente IA (Google) en terminal | Kali Linux (paquete) | Sí — interactúa con dispositivos, comandos y conexión de red | Paquetes `gemini-cli`, `llm-tools-nmap`, `mcp-kali-server` | [kali.org/tools/gemini-cli](https://www.kali.org/tools/gemini-cli/) |
| **Claude Code** | Agente IA (Anthropic) en terminal | Multiplataforma | Sí — ejecuta scripts, analiza código y valida explotabilidad | Node.js, shell compatible (bash/zsh) | [code.claude.com/docs/es](https://code.claude.com/docs/es/overview/) |
| **DeepSeek Coder** | LLM especializado en programación | Local (CLI) | No nativo | Menos restrictivo en su versión base; útil para detección de bugs críticos | [deepseek2.sh](https://github.com/hackingyseguridad/IA/blob/main/deepseek2.sh) |
| **Ollama** | Gestor/ejecutor de LLMs local | CPU / GPU / NPU | Depende del modelo cargado | Descarga, ejecuta y gestiona modelos cuantizados en local | [ollama.com](https://ollama.com) |
| **Mistral IA** | LLM (chat/API) | Local vía Ollama o web | No nativo | Sin restricciones fuertes para detallar CVE, PoC y exploits | [chat.mistral.ai](https://chat.mistral.ai) |
| **Qwen 3.6** | LLM (Alibaba) | Local (CLI) | No nativo | Requiere ~23 GB de espacio en disco | [qwen3_6.sh](https://github.com/hackingyseguridad/IA/blob/main/qwen3_6.sh) |
| **OpenClaw** | Agente IA en terminal (TUI/gateway) | Kali Linux | Sí — interactúa con herramientas de Kali y la conexión disponible | Token de autenticación, gateway propio | [openclaw.ai](https://openclaw.ai/) |

---

## Gemini-Cli

[Gemini-Cli](https://www.kali.org/tools/gemini-cli/) es la IA de Google integrada como herramienta en la terminal (CLI) de **Kali Linux**, con capacidad de *Function Calling*: puede interactuar directamente sobre los dispositivos, ejecutar comandos y operar la conexión de la máquina.

**Paquetes relacionados:**
- `gemini-cli`
- `llm-tools-nmap`
- `mcp-kali-server`

[![hacking con IA Gemini-Cli](https://github.com/hackingyseguridad/ia/raw/main/gemini-cli.png)](https://github.com/hackingyseguridad/ia/blob/main/gemini-cli.png)

---

## Claude Code

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

## Mistral IA

[Mistral IA](https://chat.mistral.ai) destaca por no aplicar restricciones fuertes a la hora de detallar el funcionamiento de vulnerabilidades CVE, PoC y exploits, incluyendo la generación de código para su explotación o enlaces relacionados.

**Ejecución local vía Ollama:**

```bash
ollama run mistral
```

[![hacking con Mistral IA](https://github.com/hackingyseguridad/IA/raw/main/mistral.png)](https://github.com/hackingyseguridad/IA/blob/main/mistral.png)

---

## Qwen 3.6

[Qwen 3.6](https://github.com/hackingyseguridad/IA/blob/main/qwen3_6.sh) es la IA de **Alibaba**. Requiere aproximadamente **23 GB de espacio en disco duro** para su instalación local.

---

## OpenClaw

[OpenClaw](https://openclaw.ai/) permite instalarse en Kali Linux en modo consola (CLI) e interactuar con las herramientas de Kali Linux y con la conexión de red disponible.

- Guía oficial de inicio: <https://docs.openclaw.ai/start/getting-started>

[![hacking con IA OpenClaw](https://github.com/hackingyseguridad/ia/raw/main/openclaw.png)](https://github.com/hackingyseguridad/ia/blob/main/openclaw.png)

### Comandos de consola (OpenClaw)

```bash
# Ver token de configuración
cat /usuario/.openclaw/openclaw.json

# Aplicar token
openclaw config set gateway.auth.token "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# Lanzar el gateway
openclaw gateway run

# Interfaz TUI en modo local
openclaw tui --local

# Asistente de configuración inicial
openclaw onboard
```

[![hacking con IA OpenClaw](https://github.com/hackingyseguridad/ia/raw/main/openclaw2.png)](https://github.com/hackingyseguridad/ia/blob/main/openclaw2.png)

**Modelos/proveedores adicionales usados con OpenClaw:**

```bash
# OpenRouter - modelo gratuito
openrouter - gemini.genma4:free

# Modelo Linux Buster vía Ollama
ollama run comanderanch/Linux-Buster
```

---

## Comparativa: IA local vs IA en la nube para hacking

| Criterio | IA local (Ollama, DeepSeek, Qwen, Mistral-local) | IA en la nube / agente CLI conectado (Claude Code, Gemini-Cli, OpenClaw) |
|---|---|---|
| Privacidad de los datos | Alta — no sale de la máquina | Depende del proveedor y su política de datos |
| Capacidad de ejecutar comandos (Function Calling) | Limitada, salvo integración manual | Nativa en varias de estas herramientas |
| Restricciones de contenido sensible (CVE/PoC/exploit) | Generalmente menores en modelos base | Varían según el proveedor y las políticas de seguridad aplicadas |
| Requisitos de hardware | Altos (disco, GPU/CPU/NPU) | Bajos en el cliente; el cómputo ocurre en la nube |
| Coste | Gratuito tras la descarga del modelo | Puede requerir suscripción, créditos o token de API |
| Validación de explotabilidad real | Manual | Algunos agentes (p. ej. Claude Code Security) la automatizan |

---

## Referencias

| Recurso | Enlace |
|---|---|
| Ollama | <https://ollama.com/> |
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
