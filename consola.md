### Hacking ofensivo con code IA en local: modelos especializados en programación y ciberseguridad

para ayudar a identificar vulnerabilidades conocidas CVE, como para hacking ofensivo (explotar vulnerabilidades o hacer pruebas de concepto PoC), **ambos sirven**, facilitaran darán Script con Exploit, listos  para copiar y pegar! o **conectar la IA con Kali Linux** (Function Calling), para ejecutar comandos o Script con las herramientas del SO Kali Linux (Distribución Linux Pentesting) 

[Gemini-Cli](https://www.kali.org/tools/gemini-cli/) IA Google, en el terminal (Cli) integrada en Kali Linux (Function Calling), con interacción sobre los dispositivos, comandos y conexion de la maquina;  Paquetes:  gemini-cli, llm-tools-nmap, mcp-kali-server.

<img style="float:left" alt="hacking con IA Gemini-Cli" src="https://github.com/hackingyseguridad/ia/blob/main/gemini-cli.png">
  
[Claude Code ](https://github.com/hackingyseguridad/IA/blob/main/claudecode.sh) ; la IA de Anthropic desde la terminal (CLI) tiene una alta capacidad de análisis, hay que "engañarlo" un poco o pedirle que analice el código por "razones de auditoría de calidad".- si haces más de 50 comandos en la terminal, algunos de sus filtros de seguridad "se saltan" por el coste de tokens. este fallo se esta  usando para forzar al modelo a ejecutar acciones que normalmente estarían bloqueadas! Claude Code tiene Skils instalables o plugins, para hacer la IA mas  especialista, p.ej en analizar vulnerabilidades o p.ej skils especificos de hacking.

<img style="float:left" alt="hacking con IA Claude Code" src="https://github.com/hackingyseguridad/ia/blob/main/claudecode.png">

[hackingtool - Claude Code plugin](https://github.com/AKCodez/hackingtool-plugin)

[DeepSeek Coder ](https://github.com/hackingyseguridad/IA/blob/main/deepseek2.sh) ; modelo de lenguaje (especializado en programacion), 
suele ser menos restrictivo en su versión base (ejecutado en la terminal (CLI) localmente) o para detección de bugs críticos

[Ollama](https://ollama.com) es una herramienta open source que permite descargar, ejecutar y gestionar modelos de lenguaje (LLMs) comprimidos, cuantizados y optimizados en local en un ordenador, CPU/GPU/MPU:  https://ollama.com/search 

[Mistral IA](https://chat.mistral.ai) sin restricciones para dar detalle del funcionamiento de vulnerabilidades CVE, POC, Exploit, facilitar codigo para la explotacion o enlaces. ollama run mistral

<img style="float:left" alt="hacking con Mistral IA" src="https://github.com/hackingyseguridad/IA/blob/main/mistral.png">

[Qween3.6](https://github.com/hackingyseguridad/IA/blob/main/qwen3_6.sh) ; Qwen3.6 la IA de Alibaba, requiere 23GB de epacio en disco duro

[OpenClaw](https://openclaw.ai/) ; OpenClaw, permite instalarse en Kali Linux en modo (Cli) e interactuar con las herramientas de Kali Linux y la xonexión disponible!  https://docs.openclaw.ai/start/getting-started 

<img style="float:left" alt="hacking con IA OpenClaw" src="https://github.com/hackingyseguridad/ia/blob/main/openclaw.png">

En consola (Cli):

Ver token: cat /usuario/.openclaw/openclaw.json

Aplicar token: openclaw config set gateway.auth.token "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

openclaw gateway run

openclaw tui --local

<img style="float:left" alt="hacking con IA OpenClaw" src="https://github.com/hackingyseguridad/ia/blob/main/openclaw2.png">

openclaw onboard

openrouter  - gemini.genma4:free 

ollama run comanderanch/Linux-Buster

#

Referencias:

https://ollama.com/

https://docs.ollama.com/integrations/claude-code#recommended-models

https://github.com/deepseek-ai/DeepSeek-Coder/

https://github.com/anthropics/knowledge-work-plugins

https://claude.com/product/claude-security#public-beta

https://docs.openclaw.ai/start/getting-started

https://www.kali.org/tools/gemini-cli/

https://github.com/bugbasesecurity/pentest-copilot

https://github.com/hypnguyen1209/offensive-claude

#
http://goo.gl/ID8XBX 
#
