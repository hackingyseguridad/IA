
### lista ejemplo modelos de lenguaje de datos (LLM): habilidades por defecto (SKILs)



| # | Compañía | IA Modelo | Exploit | Skills básicas (versión gratuita / básica) |
|---|----------|-----------|---------|---------------------------------------------|
| 1 | OpenAI | GPT | No? | Programación (Python, JS, etc.), razonamiento, redacción, análisis de datos básico. Filtrado hacking ofensivo, codigo Exploit de CVE (si da enlaces de Github u otras paginas con codigo: POC / Exploit) |
| 2 | Google | Gemini | No? | Programación, redes generales, documentación técnica, asistencia en ciberseguridad teórica. No ofrece exploits, malware o POCs ofensivos. (si da enlaces de Github u otras paginas con codigo: POC / Exploit) |
| 3 | Anthropic | Claude | No | Programación, análisis de seguridad, blue team (detección de vulnerabilidades teórica). La versión gratuita filtra hacking ofensivo y codigo de POC / Exploit. |
| 4 | Meta | Llama | No | Modelo base abierto. Skills dependen del fine-tuning. Versión base: programación, scripts básicos, redes.  Filtra: enlaces para hacking ofensivo y codigo de POC / Exploit.. |
| 5 | Microsoft | Copilot | No? | Programación (especialmente en entornos MS), depuración, asistencia en redes. Dfrece detalle del funcionamiento de POC / Exploit exploits, da enlaces de Github u otras paginas con codigo: POC / Exploit. |
| 6 | X | Grok | Si | Programación, análisis de datos, redes, scripting general. Facilita información detallada de los CVE, codigo para hacer pruebas de concepto (POC) y ofrece codigo en distintos lenguajes para explotar vulnerabilidades (Exploit). |
| 7 | Mistral AI | Mistral | Sí | Modelo base. Programación, scripts, automatización. Sin hardcore filtering por defecto (el usuario puede ajustar para tareas ofensivas si se implementa localmente). |
| 8 | Alibaba (China) | Qwen | Si | Programación, redes, análisis de vulnerabilidades básico. Facilita información detallada de los CVE, codigo para hacer pruebas de concepto (POC) y ofrece codigo en distintos lenguajes para explotar vulnerabilidades (Exploit). |
| 9 | DeepSeek (China) | DeepSeek | Si | Programación avanzada, razonamiento matemático, scripts, POCs educativos. Permite cierto nivel de scripts de prueba (ethical hacking), pero restringe malware explícito. |
| 10 | Perplexity AI | Perplexity Pages | No | Búsqueda, resúmenes, investigación. No genera código ofensivo ni exploits. Capacidad de scripting muy limitada. |

### Privacidad de los datos del usuario IA: #modos

1º.- **MODELO NUBE ONLINE** modelos LLM en internet: formulario WEB [(chatboot)](https://github.com/hackingyseguridad/IA/blob/main/chatboot.md) de IA o IA conversacional /API o consola (Cli), los datos del usuario se suben a la nube y la información es procesada por la compañia de la IA en centros de datos formados por granjas de GPUs con gran agilidad de proceso.

2º.- **MODELO LOCAL PC** modelo LLM instalado en localhost: por API/web (Chatboot) o por terminal [consola Cli)](https://github.com/hackingyseguridad/IA/blob/main/consola.md); , procesa la inforamción en la CPU/GPU del sistema local sin subir la informacón del usuario a la nube a la compañia de la IA - solo  para autenticar y facturacion tokens consumidos.

(Local / Self-hosted) herramientas como Ollama, LM Studio o bibliotecas de Python. Se descarga el modelo (el "archivo" del cerebro de la IA) y lo ejecuta en un PC ene local, usando tu tarjeta gráfica (GPU) o procesador (CPU).  Tiene ventajas: seleccionar modo local o en la nube, trabajo desde la terminal (Cli), privacidad, suscripciones, filtros y personalización













