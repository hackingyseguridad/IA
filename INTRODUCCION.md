
### lista ejemplo modelos de lenguaje de datos (LLM): habilidades por defecto (SKILs)



| # | Compañía | IA Modelo | Exploit | Skills básicas (versión gratuita / básica) |
|---|----------|-----------|---------|---------------------------------------------|
| 1 | OpenAI (EEUU) | [GPT-4](https://chatgpt.com) | No? | Programación (Python, JS, etc.), razonamiento, redacción, análisis de datos básico. Filtrado hacking ofensivo, codigo Exploit de CVE (si da enlaces de Github u otras paginas con codigo: POC / Exploit) |
| 2 | Google (EEUU) | [Gemini](https://gemini.google.com) | No? | Programación, redes generales, documentación técnica, asistencia en ciberseguridad teórica. No ofrece exploits, malware o POCs ofensivos. (si da enlaces de Github u otras paginas con codigo: POC / Exploit) |
| 3 | Anthropic (EEUU) | [Claude](https://https://claude.ai) | No | Programación, análisis de seguridad, blue team (detección de vulnerabilidades teórica). La versión gratuita filtra hacking ofensivo y codigo de POC / Exploit. |
| 4 | Meta (EEIU) | [Meta](https://llama.meta.com) | No | Modelo base abierto. Skills dependen del fine-tuning. Versión base: programación, scripts básicos, redes.  Filtra: enlaces para hacking ofensivo y codigo de POC / Exploit.. |
| 5 | Microsoft (EEUU) | [Copilot](https://copilot.microsoft.com) | No? | Programación (especialmente en entornos MS), depuración, asistencia en redes. Dfrece detalle del funcionamiento de POC / Exploit exploits, da enlaces de Github u otras paginas con codigo: POC / Exploit. |
| 6 | X (EEUU) | [Grok](https://x.com) | Si | Programación, análisis de datos, redes, scripting general. Facilita información detallada de los CVE, codigo para hacer pruebas de concepto (POC) y ofrece codigo en distintos lenguajes para explotar vulnerabilidades (Exploit). |
| 7 | Mistral AI (UE) | [Mistral AI](https://chat.mistral.ai) | Sí | Modelo base. Programación, scripts, automatización. Sin hardcore filtering por defecto (el usuario puede ajustar para tareas ofensivas si se implementa localmente). |
| 8 | Alibaba (China) | [Qwen ](https://qwen.ai) | Si | Programación, redes, análisis de vulnerabilidades básico. Facilita información detallada de los CVE, codigo para hacer pruebas de concepto (POC) y ofrece codigo en distintos lenguajes para explotar vulnerabilidades (Exploit). |
| 9 | DeepSeek (China) | [DeepSeek](https://www.deepseek.com) | Si | Programación avanzada, razonamiento matemático, scripts, POCs educativos. Permite cierto nivel de scripts de prueba (ethical hacking), pero restringe malware explícito. |
| 10 | Perplexity AI | [Perplexity AI](https://www.perplexity.ai) | No | Búsqueda, resúmenes, investigación. No genera código ofensivo ni exploits. Capacidad de scripting muy limitada. |

### Privacidad de los datos del usuario IA: #modos

1º.- **MODELO NUBE ONLINE** modelos LLM en internet: formulario WEB [(chatboot)](https://github.com/hackingyseguridad/IA/blob/main/chatboot.md) de IA o IA conversacional /API o por consola terminal (Cli), **los datos del usuario se suben a la nube y la información es procesada por la compañia de la IA en centros de datos formados por granjas de GPUs con gran agilidad de proceso** y son utilizados para entrenamiento. 

En los accesos por API o versiones corporativas (Enterprise),  "se suele estipular que los datos están protegidos y no se usan para entrenamiento", aunque se sigan procesando en sus granjas de GPUs, en los centros de datos en la nube.


2º.- **MODELO LOCAL PC** modelo LLM instalado totalmente en localhost: por API/web (Chatboot) o por terminal [consola Cli)](https://github.com/hackingyseguridad/IA/blob/main/consola.md); , **procesa la inforamción en la CPU/GPU/NPU del sistema local, sin subir informacón del usuario a la nube a la compañia de la IA.**  P.ej. el modelo Llama3 o Mistral se descarga e instala por completo en el ordenador en local, sin requerir conexión a internet!

(Local / Self-hosted) herramientas como Ollama, LM Studio o bibliotecas de Python. Se descarga el modelo (el "archivo" del cerebro de la IA) y lo ejecuta en un PC ene local, usando tu tarjeta gráfica (GPU) o procesador (CPU).  Tiene ventajas: seleccionar modo local o en la nube, trabajo desde la terminal (Cli), privacidad, suscripciones, filtros y personalización


En modelos hibridos, la interfaz es localhost (terminal(Cli), api o web), pero el procesamiento de la información del usuario, la autenticación y la facturación de tokens siguen en la nube. No es un modelo local real, es un cliente local conectado a la nube. El nombre del fichero del modelo descargado suele llevar el sufijo **:cloud**.



```text
+-----------------------------------------------------------------------------------+
|                            1º.- MODELO NUBE ONLINE                                |
+-----------------------------------------------------------------------------------+
  [ Usuario ]                                            [ Centros de Datos / Nube ]
       |                                                              |
       |  -- (1) Envía consulta por Web / API / CLI ----------------> |  Recibe datos
       |                                                              |  del usuario
       |                                                              |       |
       |                                                              v       v
       |                                                         [ Granjas de GPUs ]
       |                                                         Proceso ultra veloz
       |                                                              |
       |  <-- (2) Devuelve respuesta procesada -----------------------+
       |
       v
+-----------------------------------------------------------------------------------+
|                             2º.- MODELO LOCAL PC                                  |
+-----------------------------------------------------------------------------------+
  [ Usuario ]           [ Sistema Local (Tu PC) ]               [ Servidor IA Nube ]
       |                            |                                     |
       |  -- (1) Envía consulta --> |                                     |
       |                            | -- (2) Autentica y Factura -------> | Comprueba
       |                            | <--- (Tokens consumidos) ---------- | y registra
       |                            |                                     |
       |                            | [ CPU / GPU Local ]                 |
       |                            | Procesa la información             |
       |                            | de forma privada                    |
       |                            |                                     |
       |  <-- (3) Devuelve rpta ----+                                     |


