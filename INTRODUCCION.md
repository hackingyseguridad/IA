
### lista ejemplo modelos de lenguaje de datos (LLM): habilidades por defecto (SKILs)



| # | Compañía | IA Modelo | Exploit | Skills básicas (versión gratuita / básica) |
|---|----------|-----------|---------|---------------------------------------------|
| 1 | OpenAI (EEUU) | [GPT-4](https://chatgpt.com) | No? | Programación (Python, JS, etc.), razonamiento, redacción, análisis de datos básico. Filtrado hacking ofensivo, codigo Exploit de CVE (si da enlaces de Github u otras paginas con codigo: POC / Exploit) |
| 2 | Google (EEUU) | [Gemini](https://gemini.google.com) | No? | Programación, redes generales, documentación técnica, asistencia en ciberseguridad teórica. No ofrece exploits, malware o POCs ofensivos. (si da enlaces de Github u otras paginas con codigo: POC / Exploit) |
| 3 | Anthropic (EEUU) | [Claude](https://claude.ai) | No | Programación, análisis de seguridad, blue team (detección de vulnerabilidades teórica). La versión gratuita filtra hacking ofensivo y codigo de POC / Exploit. |
| 4 | Meta (EEIU) | [Meta](https://llama.meta.com) | No | Modelo base abierto. Skills dependen del fine-tuning. Versión base: programación, scripts básicos, redes.  Filtra: enlaces para hacking ofensivo y codigo de POC / Exploit.. |
| 5 | Microsoft (EEUU) | [Copilot](https://copilot.microsoft.com) | No? | Programación (especialmente en entornos MS), depuración, asistencia en redes. Dfrece detalle del funcionamiento de POC / Exploit exploits, da enlaces de Github u otras paginas con codigo: POC / Exploit. |
| 6 | X (EEUU) | [Grok](https://grok.com) | Si | Programación, análisis de datos, redes, scripting general. Facilita información detallada de los CVE, codigo para hacer pruebas de concepto (POC) y ofrece codigo en distintos lenguajes para explotar vulnerabilidades (Exploit). |
| 7 | Mistral AI (UE) | [Mistral AI](https://chat.mistral.ai) | Sí | Modelo base. Programación, scripts, automatización. Sin hardcore filtering por defecto (el usuario puede ajustar para tareas ofensivas si se implementa localmente). |
| 8 | Alibaba (China) | [Qwen ](https://qwen.ai) | Si | Programación, redes, análisis de vulnerabilidades básico. Facilita información detallada de los CVE, codigo para hacer pruebas de concepto (POC) y ofrece codigo en distintos lenguajes para explotar vulnerabilidades (Exploit). |
| 9 | DeepSeek (China) | [DeepSeek](https://www.deepseek.com) | Si | Programación avanzada, razonamiento matemático, scripts, POCs educativos. Permite cierto nivel de scripts de prueba (ethical hacking), pero restringe malware explícito. |
| 10 | Perplexity AI (EEUU) | [Perplexity](https://www.perplexity.ai) | No | Búsqueda, resúmenes, investigación. No genera código ofensivo ni exploits. Capacidad de scripting muy limitada. |

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

```

### Glosario de acrónimos utilizados en IA + ciberseguridad

| Acrónimo | Término Original (Inglés) | Descripción en Castellano (Español) |
| :--- | :--- | :--- |
| **AI / IA** | Artificial Intelligence | **Inteligencia Artificial**: Campo de la informática dedicado al desarrollo de sistemas capaces de realizar tareas que requieren inteligencia humana, como el aprendizaje y el razonamiento. |
| **LLM** | Large Language Model | **Gran Modelo de Lenguaje**: Modelo de IA entrenado con enormes cantidades de texto para comprender, generar y traducir lenguaje humano de manera coherente. |
| **GenAI** | Generative Artificial Intelligence | **IA Generativa**: Rama de la IA enfocada en la creación de contenido nuevo y original (texto, imágenes, música, código) a partir de datos existentes. |
| **NLP / PLN** | Natural Language Processing | **Procesamiento del Lenguaje Natural**: Disciplina que permite a las computadoras entender, interpretar y manipular el lenguaje humano. |
| **ML** | Machine Learning | **Aprendizaje Automático**: Subcampo de la IA que permite a los sistemas aprender y mejorar de forma autónoma a partir de datos sin ser programados explícitamente. |
| **DL** | Deep Learning | **Aprendizaje Profundo**: Evolución del ML basada en redes neuronales artificiales de múltiples capas que imitan la estructura del cerebro humano para procesar datos complejos. |
| **ANN** | Artificial Neural Network | **Red Neuronal Artificial**: Modelo computacional inspirado en la estructura biológica del cerebro, compuesto por nodos conectados (neuronas) para procesar información. |
| **RAG** | Retrieval-Augmented Generation | **Generación Aumentada por Recuperación**: Técnica que optimiza la salida de un LLM consultando una base de conocimientos externa antes de generar una respuesta. |
| **RLHF** | Reinforcement Learning from Human Feedback | **Aprendizaje por Refuerzo a partir del Feedback Humano**: Método de entrenamiento que utiliza las preferencias de los usuarios para alinear el comportamiento de la IA con valores humanos. |
| **AGI** | Artificial General Intelligence | **Inteligencia Artificial General**: IA hipotética que posee la capacidad de comprender, aprender y aplicar conocimientos en cualquier tarea intelectual de la misma forma que un humano. |
| **CPU** | Central Processing Unit | **Unidad Central de Procesamiento**: El procesador principal de una computadora; maneja las tareas lógicas generales, pero es menos eficiente que las GPU para el entrenamiento masivo de IA. |
| **GPU** | Graphics Processing Unit | **Unidad de Procesamiento Gráfico**: Coprocesador especializado en el cálculo en paralelo, fundamental para acelerar el entrenamiento y la ejecución de modelos de IA. |
| **ClI** | Command Line Interface | **Interfaz de la línea de comandos**:  Consola de comandos, terminal de Linux o Windows. |
| **TPU** | Tensor Processing Unit | **Unidad de Procesamiento de Tensores**: Circuito integrado (ASIC) desarrollado específicamente por Google para acelerar las tareas de aprendizaje automático. |
| **API** | Application Programming Interface | **Interfaz de Programación de Aplicaciones**: Conjunto de reglas que permite a un software conectarse e integrar las funciones de un modelo de IA en otras aplicaciones. |
| **CV** | Computer Vision | **Visión por Computadora**: Campo de la IA que entrena a las computadoras para interpretar y comprender el contenido del mundo visual (imágenes y videos). |
| **Modelo** | Model | **Modelo**: Estructura matemática o algoritmo computacional que ha sido entrenado con datos para reconocer patrones y realizar predicciones o generar contenido. |
| **Prompt** | Prompt | **Instrucción / Consigna**: Texto o comando de entrada que se le proporciona a un modelo de IA para guiarlo y obtener una respuesta específica. |
| **Agente** | Agente IA | **Agente IA**: Capa de tomar decisiones y actuar de forma autónoma para alcanzar un objetivo específico, sin necesidad de supervisión humana constante. |
| **IPSec** | Internet Protocol Security | **Seguridad del Protocolo de Internet**: Conjunto de protocolos para asegurar las comunicaciones de red cifrando y autenticando cada paquete de datos. |
| **SSL** | Secure Sockets Layer | **Capa de Sockets Seguros**: Protocolo de seguridad antiguo (reemplazado por TLS) para establecer enlaces cifrados entre un servidor web y un navegador. |
| **TLS** | Transport Layer Security | **Seguridad de la Capa de Transporte**: Protocolo criptográfico seguro y moderno que sucede a SSL, utilizado para proteger las transferencias de datos en la web (HTTPS). |
| **DoS** | Denial of Service | **Denegación de Servicio**: Tipo de ataque informático que busca hacer que un recurso, red o máquina no esté disponible para sus usuarios legítimos. |
| **DDoS** | Distributed Denial of Service | **Denegación de Servicio Distribuida**: Ataque DoS que utiliza múltiples sistemas o computadoras conectadas a Internet (como botnets) para inundar el objetivo con tráfico masivo. |
| **MitM** | Man-in-the-Middle Attack | **Ataque de Hombre en el Medio**: Tipo de ataque donde el atacante intercepta y altera en secreto la comunicación entre dos partes que creen que se comunican directamente. |
| **XSS** | Cross Site Scripting | **Secuencias de Comandos en Sitios Cruzados**: Vulnerabilidad que permite a un atacante inyectar scripts maliciosos (normalmente código JavaScript) en sitios web legítimos. |
| **CSRF** | Cross Site Request Forgery | **Falsificación de Petición en Sitios Cruzados**: Ataque que obliga al navegador web de un usuario autenticado a enviar una solicitud falsa a una aplicación web vulnerable. |
| **SQLi** | SQL Injection | **Inyección SQL**: Técnica de infiltración de código malicioso que aprovecha una vulnerabilidad en la validación de las entradas para manipular una base de datos. |
| **AES** | Advanced Encryption System | **Sistema de Cifrado Avanzado**: Esquema de cifrado de bloques simétrico que se ha convertido en el estándar global para proteger información confidencial. |
| **DSA** | Digital Signature Algorithm | **Algoritmo de Firma Digital**: Estándar del gobierno federal de EE. UU. para firmas digitales, utilizado para verificar la autenticidad de un documento o mensaje electrónico. |
| **2FA** | Two Factor Authentication | **Autenticación de Dos Factores**: Método de seguridad informática que requiere dos formas diferentes de identificación antes de conceder acceso a una cuenta. |
| **MFA** | Multi Factor Authentication | **Autenticación Multifactor**: Sistema de verificación de identidad que requiere dos o más credenciales independientes pertenecientes a distintas categorías (saber, tener, ser). |
| **WAP** | Web Application Protection | **Protección de Aplicaciones Web**: Estrategia o herramientas de seguridad diseñadas específicamente para defender las aplicaciones que se ejecutan en navegadores web contra exploits. |
| **WAF** | Web Application Firewall | **Cortafuegos de Aplicaciones Web**: Cortafuegos específico que filtra, monitorea y bloquea el tráfico HTTP malicioso que viaja hacia y desde una aplicación web. |
| **CVE** | Common Vulnerabilities and Exposures | **Vulnerabilidades y Exposiciones Comunes**: Lista oficial y pública de fallos de seguridad informática identificados de forma única mediante un identificador estándar. |
| **CVSS** | Common Vulnerability Scoring System | **Sistema de Puntuación de Vulnerabilidades Comunes**: Sistema estandarizado de la industria para evaluar y clasificar la gravedad de las vulnerabilidades de seguridad de software. |



#
http://www.hackingyseguridad.com/
#

