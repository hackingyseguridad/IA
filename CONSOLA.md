<img style="float:left" alt="http://hackingyseguridad.com/" src="https://github.com/hackingyseguridad/ia/blob/main/banner.png">

---

# Hacking Ofensivo con IA en Consola (CLI)

> Modelos especializados en programación y ciberseguridad para identificar vulnerabilidades conocidas (CVE), realizar hacking ofensivo (explotar vulnerabilidades o generar pruebas de concepto PoC) y **conectar la IA con Kali Linux** (Function Calling) para ejecutar comandos y scripts con las herramientas del sistema operativo.

---

## Índice

1. [Gemini CLI](#gemini-cli)
2. [Claude Code](#claude-code)
3. [DeepSeek Coder](#deepseek-coder)
4. [Ollama](#ollama)
5. [Mistral IA](#mistral-ia)
6. [Qwen 3.6](#qwen-36)
7. [OpenClaw](#openclaw)
8. [Referencias](#referencias)

---

## Gemini CLI

<img style="float:left" alt="hacking con IA Gemini-Cli" src="https://github.com/hackingyseguridad/ia/blob/main/gemini-cli.png">

**[Gemini CLI](https://www.kali.org/tools/gemini-cli/)** — IA de Google integrada de forma nativa en Kali Linux como herramienta de terminal (CLI) con **Function Calling**, lo que permite interacción directa con los dispositivos, comandos y conexión de la máquina.

**Paquetes disponibles en Kali:**

| Paquete | Descripción |
|---|---|
| `gemini-cli` | Cliente CLI principal de Gemini |
| `llm-tools-nmap` | Integración de Nmap con LLM |
| `mcp-kali-server` | Servidor MCP para herramientas Kali |

```bash
# Instalar paquetes en Kali Linux
sudo apt install gemini-cli llm-tools-nmap mcp-kali-server
```

---

## Claude Code:

<img style="float:left" alt="hacking con IA Claude Code" src="https://github.com/hackingyseguridad/ia/blob/main/claudecode.png">

**[Claude Code](https://code.claude.com/docs/es/overview/)** — IA de Anthropic disponible desde la terminal (CLI) con alta capacidad de análisis. Opera de forma **agéntica**: no es un simple emulador o sandbox, sino que interactúa con herramientas, ejecuta scripts, analiza código, vulnerabilidades lógicas complejas, corrupción de memoria y fallos estructurales en sistemas operativos, navegadores (como Firefox) y protocolos de red. Simula el comportamiento de un atacante y analiza las respuestas del sistema para validar si un fallo descubierto es realmente explotable.

Claude Code tiene **Skills** instalables (plugins) para especializar la IA, por ejemplo en análisis de vulnerabilidades o hacking ofensivo.

> También disponible: **Claude Code Security** y **Claude Mythos** (modelo de frontera avanzado).

<img style="float:left" alt="hacking con IA Claude Code" src="https://github.com/hackingyseguridad/ia/blob/main/claudecode0.png">


### Instalación de Claude Code

```bash
# Instalar Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Añadir al PATH (zsh)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc

# Verificar versión
claude --version

# Iniciar
claude
```

### Archivo CLAUDE.md — Preconfiguración

- **CLAUDE.md**, archivo de configuración en la raíz del proyecto. Rige a Claude Code cómo comportarse en ese proyecto: reglas, contexto, convenciones de código, comandos comunes, etc. Actúa como "instrucciones permanentes" que Claude lee automáticamente.

Se puede crear un fichero **[CLAUDE.md](https://github.com/hackingyseguridad/IA/blob/main/CLAUDE.md)** con los requisitos y parámetros de configuración específicos para la automatización, web, API o aplicativo que se quiera construir con Claude.

### SKILLS ( habilidades ) 

- **SKILL.md** (habilidades), capacidades especializadas y herramientas que Claude Code puede ejecutar bajo demanda. Se añade inforamción adicional, conexto y se establece los requisitos y especificaciones previas Son como plugins o herramientas que extienden lo que Claude puede hacer más allá de solo conversar.

el tamaño del contexto y del Prompt de un formulario Web de un portal de Inteligencia artificial, **tiene un tamaño limitado**, por eso es mejor usar SKILL.md, que permite mayor escalabilidad, instrucción bajo demanda, ahorro de tokens en el prompt, mantenimiento, Recuperación inteligente (RAG) fragmentos necesarios, ..


Las Skills son los requisitos específicos o información adicional que se dota a la IA. Hay dos tipos:

| Tipo | Descripción |
|---|---|
| **Skills de capacidad** | Tarea específica y concreta |
| **Skills secuenciales** | Automatización encadenada de pasos |

**Estructura de Skills recomendada para pentesting:**

```
IA/
└── .claude/
    ├── README.md
    └── skills/
        ├── recon/
        │   └── SKILL.md       # Reconocimiento y enumeración
        ├── Vuln/
        │   └── SKILL.md       # Detección de vulnerabilidades
        ├── POC/
        │   └── SKILL.md       # Pruebas de concepto
        ├── Exploit/
        │   └── SKILL.md       # Explotación
        └── report/
            └── SKILL.md       # Generación de informes
```

**Cómo usar una Skill en Claude Code:**

```
usa la SKILL /home/antonio/IA/.claude/README.md
usa la SKILL /home/antonio/IA/.claude/skills/recon/SKILL.md
usa la SKILL /home/antonio/IA/.claude/skills/Vuln/SKILL.md
usa la SKILL /home/antonio/IA/.claude/skills/POC/SKILL.md
usa la SKILL /home/antonio/IA/.claude/skills/Exploit/SKILL.md
usa la SKILL /home/antonio/IA/.claude/skills/report/SKILL.md
```

En la ventan de conexto podemos poner un PROMPT con una limitación de caracteres , para dar mas especificaciones / requisitos previos e instruccion muy detalladas de mucha potencia usaremos CLAUDE.md y  SKILLs, P .ej.: 

carga / lee el  fichero resultado.xml en la carpeta /home/antonio/IA y usa las SKILL:
 /home/antonio/IA/.claude/README.md
 /home/antonio/IA/.claude/skills/recon/SKILL.md
 /home/antonio/IA/.claude/skills/Vuln/SKILL.md 

Vulnerabilidades

<img style="float:left" alt="hacking con IA Claude Code" src="https://github.com/hackingyseguridad/ia/blob/main/claudecode1.png">

POC

<img style="float:left" alt="hacking con IA Claude Code" src="https://github.com/hackingyseguridad/ia/blob/main/claudecode2.png">

Ecploits:

<img style="float:left" alt="hacking con IA Claude Code" src="https://github.com/hackingyseguridad/ia/blob/main/claudecode3.png">

## AGENTS

- **AGENTS.md** es el modo de funcionamiento autónomo donde Claude no solo responde preguntas, sino que ejecuta tareas complejas de principio a fin; instancias o roles que Claude adopta para tareas específicas. P.ej.:  "actúa como experto en seguridad", "como revisor de código", "como arquitecto de software". Cada agente tiene un propósito, un contexto y un estilo de respuesta particular.


---

## DeepSeek Coder

**[DeepSeek Coder](https://github.com/hackingyseguridad/IA/blob/main/deepseek2.sh)** — Modelo de lenguaje especializado en programación. En su versión base ejecutada localmente en terminal (CLI), suele ser menos restrictivo para generación de exploits o detección de bugs críticos.

```bash
# Ejecutar via Ollama
ollama run deepseek-coder
```

---

## Ollama

**[Ollama](https://ollama.com)** — Herramienta open source para descargar, ejecutar y gestionar modelos de lenguaje (LLMs) comprimidos, cuantizados y optimizados para ejecutar en local (CPU / GPU / MPU).

Catálogo de modelos disponibles: [https://ollama.com/search](https://ollama.com/search)

```bash
# Instalar Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Ejecutar un modelo
ollama run mistral
ollama run deepseek-coder
ollama run qwen3:latest
ollama run comanderanch/Linux-Buster
```

---

## Mistral IA

<img style="float:left" alt="hacking con Mistral IA" src="https://github.com/hackingyseguridad/IA/blob/main/mistral.png">

**[Mistral IA](https://chat.mistral.ai)** — Modelo sin restricciones para dar detalle del funcionamiento de vulnerabilidades CVE, PoC, Exploits y facilitar código para la explotación o enlaces a recursos.

```bash
# Ejecutar Mistral en local con Ollama
ollama run mistral
```

---

## Qwen 3.6

**[Qwen 3.6](https://github.com/hackingyseguridad/IA/blob/main/qwen3_6.sh)** — IA de Alibaba, especializada en programación y análisis de código.

> ⚠️ Requiere aproximadamente **23 GB** de espacio en disco.

```bash
# Ejecutar Qwen3 con Ollama
ollama run qwen3:latest
```

---

## OpenClaw

<img style="float:left" alt="hacking con IA OpenClaw" src="https://github.com/hackingyseguridad/ia/blob/main/openclaw.png">

**[OpenClaw](https://openclaw.ai/)** — Permite instalarse en Kali Linux en modo CLI e interactuar con las herramientas de Kali Linux y la conexión disponible.

Documentación: [https://docs.openclaw.ai/start/getting-started](https://docs.openclaw.ai/start/getting-started)

### Instalación y configuración

```bash
# Ver token actual
cat /usuario/.openclaw/openclaw.json

# Aplicar token de autenticación
openclaw config set gateway.auth.token "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# Iniciar gateway
openclaw gateway run

# Iniciar interfaz TUI en local
openclaw tui --local
```

<img style="float:left" alt="hacking con IA OpenClaw TUI" src="https://github.com/hackingyseguridad/ia/blob/main/openclaw2.png">

```bash
# Configuración inicial guiada
openclaw onboard

# Usar modelo gratuito de OpenRouter
# openrouter - gemini/gemma4:free
```

---

## Comparativa de Herramientas

| Herramienta | Tipo | Restricciones | Function Calling | Especialización |
|---|---|---|---|---|
| Gemini CLI | Cloud/Local | Media | ✅ Kali nativo | General + seguridad |
| Claude Code | Cloud | Alta | ✅ Agéntico | Análisis + Skills |
| DeepSeek Coder | Local | Baja | ❌ | Programación |
| Mistral (Ollama) | Local | Muy baja | ❌ | General |
| Qwen 3.6 | Local | Baja | ❌ | Programación |
| OpenClaw | Local/Cloud | Baja | ✅ Kali | Pentesting |

---

## Referencias

- [https://ollama.com/](https://ollama.com/)
- [https://docs.ollama.com/integrations/claude-code#recommended-models](https://docs.ollama.com/integrations/claude-code#recommended-models)
- [https://github.com/deepseek-ai/DeepSeek-Coder/](https://github.com/deepseek-ai/DeepSeek-Coder/)
- [https://github.com/anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins)
- [https://claude.com/product/claude-security#public-beta](https://claude.com/product/claude-security#public-beta)
- [https://docs.openclaw.ai/start/getting-started](https://docs.openclaw.ai/start/getting-started)
- [https://www.kali.org/tools/gemini-cli/](https://www.kali.org/tools/gemini-cli/)
- [https://github.com/bugbasesecurity/pentest-copilot](https://github.com/bugbasesecurity/pentest-copilot)
- [https://github.com/hypnguyen1209/offensive-claude](https://github.com/hypnguyen1209/offensive-claude)
- [https://opencode.ai/](https://opencode.ai/)

---

*hackingyseguridad.com — [http://goo.gl/ID8XBX](http://goo.gl/ID8XBX)*
