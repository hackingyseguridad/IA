# SKILL.md: Fase de Reconocimiento y OSINT sobre Activos

Este módulo define las capacidades y el flujo de trabajo sistemático para la recolección de información, análisis de reputación y descubrimiento de exposición (OSINT) sobre un activo inicial (**IP, Dominio o FQDN**) antes de proceder a fases operativas de explotación.

## 🎯 Objetivo
Identificar la superficie de ataque, determinar la propiedad legal del activo, evaluar su reputación histórica y localizar fugas de información, credenciales o datos sensibles expuestos en fuentes abiertas.

---

## 🛠️ Flujo de Trabajo y Tareas

### 1. Atribución, Registro y Criptografía
El objetivo es delimitar el alcance legal y descubrir la infraestructura asociada al activo.

* **Identificación del Propietario (Whois / ASN):**
    * Determinar el ASN (Autonomous System Number), rango de red IP, registrador del dominio y datos de contacto (si no están bajo privacidad).
    * *Herramientas:* `whois`, `dig`, `nslookup`, IPinfo, Hurricane Electric (bgp.he.net).
* **Análisis de Certificados Digitales (X.509):**
    * Extracción de nombres alternativos del sujeto (SAN) para descubrir subdominios ocultos o dominios relacionados.
    * *Herramientas / Fuentes:* `openssl`, crt.sh, Censys, Shodan.
* **Enumeración y Descubrimiento de Subdominios:**
    * Mapeo de la estructura del FQDN mediante técnicas pasivas y activas.
    * *Herramientas:* `subfinder`, `amass`, `assetfinder`, `gobuster` (fuzzing DNS).

### 2. Reputación e Historial de Compromisos
Evaluación del comportamiento histórico del activo para identificar si ha sido utilizado en campañas maliciosas o si ha sido vulnerado previamente.

* **Listas Negras y Reputación de Red:**
    * Verificación de la presencia de la IP/Dominio en listas de spam, malware o redes de comando y control (C2).
    * *Fuentes:* VirusTotal, AlienVault OTX, Talos Intelligence, AbuseIPDB.
* **Historial de Brechas de Seguridad (Leaks):**
    * Validación de si el dominio o activos relacionados aparecen en bases de datos filtradas (Data Breaches).
    * *Fuentes:* HaveIBeenPwned, DeHashed, IntelligenceX.

### 3. Inteligencia de Fuentes Abiertas (OSINT) y Google Dorking
Localización de información sensible expuesta de forma indexada o residual en la web.

* **Hacking con Buscadores (Google / Bing / DuckDuckGo Dorks):**
    * Filtros avanzados para encontrar archivos expuestos (`filetype:pdf,xml,log,env`), directorios indexados (`intitle:"index of"`) o subdominios específicos.
* **Metadatos y Fugas Documentales:**
    * Extracción de documentos públicos del dominio para analizar metadatos (nombres de usuario, software utilizado, rutas de red).
    * *Herramientas:* `foca`, `exiftool`.
* **Motores de Búsqueda de Infraestructura:**
    * Identificación de puertos abiertos y servicios expuestos históricamente sin realizar escaneo directo.
    * *Fuentes:* Shodan, Censys, Zoomeye.

---

## 🤖 Capacidades del Modelo IA de Soporte

Para acelerar esta fase, este modelo está capacitado para:

* **Automatización:** Generación de scripts en **Bash** y **Python** para la automatización de consultas `whois`, resoluciones DNS masivas y parsing de JSONs de APIs (VirusTotal, Shodan, crt.sh).
* **Mapeo de Vulnerabilidades (CVE):** Correlación de banners de servicios detectados de forma pasiva con identificadores de vulnerabilidades conocidos.
* **Pruebas de Concepto (PoC):** Suministro de estructuras de scripts y referencias a exploits públicos con fines de validación técnica y fundamentación de hallazgos.
