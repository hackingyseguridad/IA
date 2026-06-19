---
name: vuln-classifier
description: >
  Skill de pentesting para análisis y clasificación de vulnerabilidades a partir de ficheros
  de escaneo (Nmap XML/texto, Nessus .nessus, OpenVAS XML, Nikto, Masscan, etc.).
  Úsala siempre que el usuario proporcione o mencione un fichero de escaneo de red/web,
  resultados de Nmap, Nessus, OpenVAS, Nikto, un informe de auditoría, o pida clasificar,
  priorizar o resumir vulnerabilidades. También activa si el usuario pide una tabla de CVEs,
  resumen ejecutivo de seguridad, o análisis de puertos/servicios con riesgo asociado.
  Diseñada para hackers éticos, pentesters y equipos Red Team.
---

# Skill: Vulnerability Classifier (Escáner → Informe Ejecutivo)

## Objetivo

Analizar ficheros de escaneo de seguridad (Nmap, Nessus, OpenVAS, Nikto, Masscan, etc.)
y producir un informe ejecutivo técnico con las vulnerabilidades explotables priorizadas
por CVSS Score, con referencias a exploits públicos (Metasploit, ExploitDB, GitHub PoC).

---

## Inputs Soportados

resultado.xml con inforamción de escaneo previo, con distintas utilziadades 

---

## Proceso de Análisis

### PASO 1 — Extracción de Puertos y Servicios

Extrae de forma exhaustiva:
- Host/IP
- Puerto / Protocolo (TCP/UDP)
- Estado (open/filtered)
- Servicio detectado
- Versión / Banner / Fingerprint
- OS detection si disponible

### PASO 2 — Identificación de CVEs Explotables

**Criterios de inclusión (los tres deben cumplirse):**
1. CVSS Score >= 7.0 (Alta o Crítica)
2. Exploit conocido y público: Metasploit module, ExploitDB entry, GitHub PoC activo
3. Marcada como explotable o con PoC funcional confirmado

**Fuentes de referencia para búsqueda:**
- NVD: https://nvd.nist.gov/vuln/detail/{CVE}
- ExploitDB: https://www.exploit-db.com/search?cve={CVE}
- Metasploit: https://www.rapid7.com/db/?q={CVE}
- GitHub PoC: https://github.com/search?q={CVE}
- VulhHub: https://vulhub.org/
- Sploitus: https://sploitus.com/?query={CVE}

**Si el fichero no incluye CVEs directamente** (ej: Nmap básico), Claude debe:
1. Identificar el servicio + versión exacta
2. Inferir CVEs conocidas para esa combinación producto/versión desde su conocimiento
3. Marcar con `[INFERIDO]` las CVEs no presentes explícitamente en el fichero
4. Recomendar validación con: `searchsploit <producto> <versión>` o Shodan

### PASO 3 — Tabla Resumen Ejecutivo

Generar tabla ordenada por CVSS Score descendente:

```
| Puerto/Proto | Servicio | Versión | CVE | CVSS | Severidad | Exploit Disponible | Explotable | Vector de Ataque |
```

**Valores de Severidad:**
- CRÍTICA: CVSS >= 9.0
- ALTA: CVSS 7.0–8.9
- MEDIA: CVSS 4.0–6.9 (incluir solo si hay exploit público)
- BAJA: < 4.0 (no incluir salvo excepción justificada)

**Columna "Exploit Disponible":** formato `Metasploit / EDB-XXXXX / GitHub`

**Columna "Vector de Ataque":** usar notación CVSS:
`Red` / `Adyacente` / `Local` / `Físico`

### PASO 4 — Resumen Ejecutivo

Bloque final con:

```
## RESUMEN EJECUTIVO

- Nº total de hosts analizados: X
- Nº total de puertos abiertos: X
- Nº de CVEs CRÍTICAS (CVSS >= 9.0): X
- Nº de CVEs ALTAS (CVSS 7.0–8.9): X
- Nº de vulnerabilidades con exploit disponible: X
- Riesgo general del objetivo: CRÍTICO / ALTO / MEDIO / BAJO

### Top 3 Vulnerabilidades Más Peligrosas

1. **CVE-XXXX-XXXX** (CVSS X.X) — [Servicio:Puerto]
   Descripción breve. Impacto. Referencia exploit.

2. **CVE-XXXX-XXXX** (CVSS X.X) — [Servicio:Puerto]
   ...

3. **CVE-XXXX-XXXX** (CVSS X.X) — [Servicio:Puerto]
   ...
```

**Criterio de Riesgo General:**
- CRÍTICO: >= 1 CVE con CVSS >= 9.0 y exploit disponible
- ALTO: CVEs CVSS >= 7.0 con exploits, sin llegar a crítico
- MEDIO: CVEs moderadas, sin exploits públicos confirmados
- BAJO: Solo issues informativos o CVSS < 4.0

---

## Notas de Calidad

- Responde siempre en **español técnico**
- Sé conciso: la tabla es el núcleo, evita relleno
- Si el fichero es ambiguo o incompleto, indícalo explícitamente y trabaja con lo disponible
- Para versiones sin CVE directa en el fichero, usa `[INFERIDO]` y justifica
- Añade comandos de validación cuando sea útil:
  ```bash
  searchsploit apache 2.4.49
  msfconsole -x "search cve:2021-41773"
  ```
- Si el usuario pide profundizar en una CVE concreta, proporciona:
  - Descripción técnica
  - Módulo Metasploit exacto o comando `searchsploit`
  - Link ExploitDB / GitHub PoC
  - Condiciones de explotación (auth requerida, versión exacta, etc.)

---

## Ejemplo de Activación

**Triggers típicos:**
- "Analiza este nmap" / "clasifica estas vulnerabilidades"
- "tengo un fichero .nessus" / "resultados de openvas"
- "dame tabla CVEs de este escaneo"
- "resumen ejecutivo de auditoría" / "qué puertos tienen exploits"
- Upload de fichero `.xml`, `.nessus`, `.txt` con resultados de escaneo

**No activar para:**
- Consultas genéricas sobre CVEs sin fichero/contexto de escaneo
- Análisis de código fuente (usar skill de code-review)
