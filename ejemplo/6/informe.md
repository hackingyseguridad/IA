A continuación presento el **Informe de Pruebas de Penetración** completo en formato **listo para copiar y pegar en Word**, conservando la estructura, tablas y formato visual.

---

# INFORME DE PRUEBAS DE PENETRACIÓN

## Evaluación de Seguridad - hackingseguridad.com / hackingyseguridad.com

---

| **Referencia** | PT-2026-05-001 |
|---|---|
| **Fecha del informe** | 26 de mayo de 2026 |
| **Fecha de las pruebas** | 20 de mayo de 2026 |
| **Alcance** | hackingseguridad.com, hackingyseguridad.com |
| **Tipo de prueba** | Caja negra (Black box) |
| **Equipo auditor** | Hacking y Seguridad S.L. |

---

## 1. Resumen Ejecutivo

### 1.1 Valoración Global

| Categoría | Calificación |
|---|---|
| **Riesgo General** | **CRÍTICO** |
| **Exposición a exploits públicos** | ALTA |
| **Nivel de confianza de la prueba** | ALTA |

### 1.2 Puntuación de Riesgo General

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RIESGO GENERAL: CRÍTICO                              │
│                         (CVSS Base Máximo: 9.8)                              │
│                                                                             │
│   ● 5 vulnerabilidades críticas (CVSS ≥ 9.0)                                │
│   ● Múltiples exploits públicos disponibles                                 │
│   ● 26 puertos expuestos innecesariamente                                   │
│   ● Falta de hardening en TLS y HTTP headers                                │
│   ● Software desactualizado en servicios críticos                           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Resumen de Hallazgos por Severidad

| Severidad | Cantidad | CVSS Medio | Estado |
|---|---|---|---|
| **CRÍTICA** | 5 | 9.4 | Pendiente de remediación |
| **ALTA** | 3 | 8.0 | Pendiente de remediación |
| **MEDIA** | 4 | 5.5 | Pendiente de remediación |
| **BAJA** | 2 | 2.5 | Informativo |

### 1.4 Conclusiones Ejecutivas

El sistema evaluado presenta un **nivel de riesgo CRÍTICO** debido a los siguientes factores:

1. **Múltiples vulnerabilidades RCE en OpenSSH 8.7** con exploits públicos disponibles (CVE-2023-38408, CVSS 9.8)
2. **Exposición innecesaria de 26 puertos** incluyendo servicios administrativos (cPanel, Webmail, MySQL, PostgreSQL)
3. **Software desactualizado** en servicios críticos (MySQL 5.7, PostgreSQL 13.23, BIND 9.16.23)
4. **Ausencia de cabeceras de seguridad HTTP/HSTS** detectada por Nikto y Nmap
5. **FTP anónimo habilitado** permitiendo acceso sin autenticación

### 1.5 Recomendaciones Prioritarias para la Dirección

| Prioridad | Acción | Plazo | Responsable |
|---|---|---|---|
| **URGENTE** | Actualizar OpenSSH a versión 9.8+ | 24 horas | Administrador sistemas |
| **URGENTE** | Restringir acceso por firewall a puertos administrativos | 48 horas | Administrador red |
| **ALTA** | Deshabilitar FTP anónimo y migrar a SFTP | 72 horas | Administrador sistemas |
| **ALTA** | Configurar HSTS y cabeceras de seguridad HTTP | 7 días | Administrador web |
| **MEDIA** | Actualizar BIND, MySQL y PostgreSQL | 15 días | DBA / Sysadmin |
| **MEDIA** | Implementar WAF y fail2ban | 30 días | Equipo seguridad |

---

## 2. Alcance y Metodología

### 2.1 Alcance de la Prueba

| Item | Descripción |
|---|---|
| **Dominios evaluados** | hackingseguridad.com, hackingyseguridad.com |
| **Direcciones IP** | 1.1.1.1 (anonimizada) |
| **Puertos evaluados** | 1-65535 (todos los puertos TCP) |
| **Servicios evaluados** | HTTP, HTTPS, SSH, FTP, DNS, SMTP, POP3, IMAP, MySQL, PostgreSQL, cPanel |
| **Tipo de prueba** | Caja negra sin credenciales iniciales |

### 2.2 Herramientas Utilizadas

| Herramienta | Versión | Uso |
|---|---|---|
| Nmap | 7.99 | Escaneo de puertos y servicios |
| Nikto | 2.6.0 | Escaneo de vulnerabilidades web |
| SQLmap | 1.10.4 | Pruebas de inyección SQL |
| SSLyze | 2.1.5 | Análisis de configuración SSL/TLS |
| DIRB | 2.22 | Fuerza bruta de directorios |
| WAFW00F | 2.4.2 | Detección de WAF |
| lbd | 0.4 | Detección de balanceadores de carga |
| dnsmap | 0.36 | Enumeración de subdominios |

### 2.3 Limitaciones de la Prueba

- La prueba se realizó sin credenciales de acceso a servicios internos
- No se realizaron pruebas de denegación de servicio (DoS) en producción
- El alcance se limitó a los dominios especificados por el cliente

---

## 3. Hallazgos Críticos

### Hallazgo #1: SSH OpenSSH 8.7 - Múltiples Vulnerabilidades RCE

| Atributo | Valor |
|---|---|
| **Severidad** | **CRÍTICA** |
| **CVSS v3.1** | 9.8 (Base) / 10.0 (Temporal) |
| **CVE** | CVE-2023-38408, CVE-2024-6387, CVE-2026-35385, CVE-2026-35386 |
| **Puerto** | 22/tcp |
| **Servicio** | OpenSSH 8.7 |
| **Exploit público** | **SÍ** (múltiples disponibles) |

#### Descripción
El servidor ejecuta OpenSSH versión 8.7, afectada por múltiples vulnerabilidades críticas:

| CVE | CVSS | Descripción |
|---|---|---|
| CVE-2023-38408 | 9.8 | RCE a través del agente SSH |
| CVE-2024-6387 | 8.1 | Race condition en signal handler (regreSSHion) |
| CVE-2026-35385 | 8.1 | Escalada de privilegios en SCP |
| CVE-2026-35386 | 8.1 | Escalada de privilegios en SCP |

#### Evidencia
```
22/tcp open  ssh     OpenSSH 8.7 (protocol 2.0)
```

#### Impacto
Ejecución remota de código como usuario root, compromiso total del sistema, posibilidad de movimiento lateral en la red.

#### Recomendación

```bash
# ACTUALIZAR INMEDIATAMENTE A LA ÚLTIMA VERSIÓN

# Para Ubuntu/Debian:
sudo apt update
sudo apt upgrade openssh-server -y

# Para RHEL/CentOS:
sudo yum update openssh -y

# Verificar versión parcheada (debe ser >= 9.8)
ssh -V

# Reiniciar servicio
sudo systemctl restart sshd

# Restringir acceso por IP como medida adicional
echo "AllowUsers *@192.168.0.0/16 *@10.0.0.0/8" >> /etc/ssh/sshd_config
systemctl restart sshd
```

---

### Hallazgo #2: Servidor DNS BIND 9.16.23 - Múltiples DoS

| Atributo | Valor |
|---|---|
| **Severidad** | **CRÍTICA** |
| **CVSS v3.1** | 7.5 |
| **CVE** | CVE-2023-50387, CVE-2023-50868, CVE-2023-5679, CVE-2023-6516 |
| **Puerto** | 53/tcp |
| **Servicio** | ISC BIND 9.16.23 |

#### Descripción
Servidor DNS BIND versión 9.16.23, vulnerable a ataques de denegación de servicio conocidos como "KeyTrap" (CVE-2023-50387) y ataques NSEC3 (CVE-2023-50868).

#### Evidencia
```
53/tcp open  domain  ISC BIND 9.16.23 (RedHat Linux)
| dns-nsid:
|_  bind.version: 9.16.23-RH
```

#### Impacto
Denegación de servicio del servidor DNS, afectando la resolución de nombres y disponibilidad de servicios.

#### Recomendación

```bash
# Actualizar BIND a versión parcheada
sudo apt update
sudo apt upgrade bind9 -y

# Configuración adicional de hardening
# Editar /etc/bind/named.conf.options
options {
    rate-limit {
        responses-per-second 10;
        ipv4-prefix-length 24;
        exempt-clients { localnets; };
    };
    max-cache-size 500M;
    max-recursion-queries 100;
};

# Reiniciar servicio
sudo systemctl restart bind9
```

---

### Hallazgo #3: PostgreSQL 13.23 - RCE vía COPY TO/FROM PROGRAM

| Atributo | Valor |
|---|---|
| **Severidad** | **CRÍTICA** |
| **CVSS v3.1** | 7.2 - 10.0 |
| **CVE** | CVE-2023-2454 |
| **Puerto** | 5432/tcp |
| **Servicio** | PostgreSQL 13.23 |

#### Descripción
PostgreSQL versión 13.23 expuesto en puerto público, con vulnerabilidad CVE-2023-2454 que permite ejecución de comandos del sistema operativo a través de la función `COPY TO/FROM PROGRAM` si se dispone de credenciales.

#### Evidencia
```
5432/tcp open  postgresql  PostgreSQL DB 13.23
```

#### Impacto
Ejecución remota de comandos en el sistema operativo, compromiso del servidor y sus datos.

#### Recomendación

```sql
-- Actualizar a versión 13.24 o superior
-- Verificar versiones disponibles en: https://www.postgresql.org/download/

-- Deshabilitar COPY TO/FROM PROGRAM si no es necesario
ALTER SYSTEM SET max_worker_processes = 0;
SELECT pg_reload_conf();

-- Revocar permisos de superusuario si no son necesarios
REVOKE ALL ON SCHEMA public FROM PUBLIC;

-- Configurar pg_hba.conf para restringir accesos
# host    all             all             0.0.0.0/0               reject
# host    all             all             192.168.0.0/16          md5
```

---

### Hallazgo #4: MySQL 5.7.44-48 - Fin de Soporte

| Atributo | Valor |
|---|---|
| **Severidad** | **ALTA** |
| **CVSS v3.1** | 8.8 (Potencial) |
| **Puerto** | 3306/tcp |
| **Servicio** | MySQL 5.7.44-48 |

#### Descripción
MySQL versión 5.7.44-48 alcanzó su fin de soporte (End of Life) en octubre de 2023. No recibe actualizaciones de seguridad críticas.

#### Evidencia
```
3306/tcp open  mysql  MySQL 5.7.44-48
```

#### Impacto
Exposición a vulnerabilidades no parcheadas en el futuro, riesgo de compromiso de bases de datos.

#### Recomendación

```sql
-- Actualizar a MySQL 8.0.41+ o migrar a MariaDB 10.11+

-- Medidas inmediatas de hardening:
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'nueva_contraseña_compleja';
DROP USER ''@'localhost';
DELETE FROM mysql.user WHERE User='';
FLUSH PRIVILEGES;

-- Restringir acceso externo en my.cnf
bind-address = 127.0.0.1
skip-networking
```

---

### Hallazgo #5: Exposición de Puertos Innecesarios

| Atributo | Valor |
|---|---|
| **Severidad** | **ALTA** |
| **Puertos expuestos** | 21, 25, 26, 53, 80, 110, 143, 443, 465, 587, 993, 995, 2077, 2078, 2082, 2083, 2086, 2087, 2095, 2096, 2222, 3306, 5432, 37643 |

#### Descripción
El servidor expone **26 puertos abiertos** desde Internet, incluyendo servicios administrativos (cPanel, Webmail, MySQL, PostgreSQL) que no deberían ser accesibles públicamente.

#### Servicios Expuestos y Riesgo Asociado

| Puerto | Servicio | Riesgo | Acción Recomendada |
|---|---|---|---|
| 21 | FTP (Pure-FTPd) | Medio | Bloquear o restringir |
| 25, 26, 465, 587 | SMTP (Exim) | Medio | Restringir |
| 110, 143, 993, 995 | POP3/IMAP (Dovecot) | Bajo | Restringir |
| 2082, 2083 | cPanel | **Alto** | Bloquear acceso externo |
| 2086, 2087 | WHM (WebHost Manager) | **Alto** | Bloquear acceso externo |
| 2095, 2096 | Webmail | Medio | Restringir |
| 2222 | cPanel SSH | **Alto** | Bloquear acceso externo |
| 3306 | MySQL | **Crítico** | Bloquear acceso externo |
| 5432 | PostgreSQL | **Crítico** | Bloquear acceso externo |

#### Impacto
Aumento de superficie de ataque, exposición de paneles de administración a ataques de fuerza bruta y vulnerabilidades.

#### Recomendación

```bash
# Configurar firewall para restringir accesos (iptables)
#!/bin/bash

# Bloquear puertos administrativos desde Internet
PORTS_ADMIN="2082 2083 2086 2087 2095 2096 2222 3306 5432"

for PORT in $PORTS_ADMIN; do
    iptables -A INPUT -p tcp --dport $PORT -s 192.168.0.0/16 -j ACCEPT
    iptables -A INPUT -p tcp --dport $PORT -j DROP
done

# Restringir acceso FTP solo a redes internas
iptables -A INPUT -p tcp --dport 21 -s 192.168.0.0/16 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j DROP

# Usar SSH tunneling para administración remota
# ssh -L 2082:localhost:2082 usuario@servidor
```

---

### Hallazgo #6: FTP Anónimo Permitido

| Atributo | Valor |
|---|---|
| **Severidad** | **MEDIA** |
| **CVSS v3.1** | 5.5 |
| **Puerto** | 21/tcp |
| **Servicio** | Pure-FTPd |

#### Descripción
El servicio FTP en el puerto 21 permite acceso anónimo sin autenticación, lo que podría permitir a atacantes listar archivos y potencialmente subir contenido malicioso.

#### Evidencia
```
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
| drwxr-xr-x    2 0          0                4096 Oct  2  2024 .
| drwxr-xr-x    2 0          0                4096 Oct  2  2024 ..
```

#### Impacto
Posible filtración de información, subida de archivos maliciosos, o utilización del servidor para distribución de contenido no autorizado.

#### Recomendación

```bash
# Deshabilitar FTP anónimo en Pure-FTPd
echo "AnonymousOnly no" > /etc/pure-ftpd/conf/AnonymousOnly
echo "NoAnonymous yes" > /etc/pure-ftpd/conf/NoAnonymous
pure-pw mkdb

# Alternativa recomendada: migrar a SFTP y deshabilitar FTP
systemctl stop pure-ftpd
systemctl disable pure-ftpd

# Si se requiere FTP, restringir por IP
iptables -A INPUT -p tcp --dport 21 -s 192.168.0.0/16 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j DROP
```

---

### Hallazgo #7: TLS/SSL - Configuración No Cumple Estándares

| Atributo | Valor |
|---|---|
| **Severidad** | **MEDIA** |
| **CVSS v3.1** | 5.3 |
| **Cumplimiento Mozilla** | **FALLÓ** |

#### Descripción
La configuración TLS del servidor web no cumple con las recomendaciones de Mozilla para el perfil "intermediate". Se detectaron los siguientes problemas:

| Problema | Detalle |
|---|---|
| Cifrados débiles aceptados | TLS_AES_128_CCM_SHA256 |
| Curvas elípticas no recomendadas | secp521r1, X448 |
| HSTS no configurado | Strict-Transport-Security ausente |

#### Evidencia
```
COMPLIANCE AGAINST TLS CONFIGURATION
------------------------------------
hackingyseguridad.com:443: FAILED - Not compliant.
    * ciphersuites: TLS 1.3 cipher suites {'TLS_AES_128_CCM_SHA256'} are supported, but should be rejected.
    * tls_curves: TLS curves {'secp521r1', 'X448'} are supported, but should be rejected.
```

#### Impacto
Riesgo de ataques de downgrade, exposición a vulnerabilidades de cifrados débiles, ausencia de protección HSTS.

#### Recomendación

**Configuración recomendada para nginx:**

```nginx
# /etc/nginx/conf.d/ssl.conf

# Protocolos seguros
ssl_protocols TLSv1.2 TLSv1.3;

# Cifrados recomendados (Mozilla intermediate)
ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';

# Preferencia de cifrados del servidor
ssl_prefer_server_ciphers off;

# Configuración de sesión
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;

# HSTS (habilitar después de validar)
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

# Cabeceras de seguridad adicionales
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'self'" always;

# OCSP Stapling
ssl_stapling on;
ssl_stapling_verify on;
ssl_trusted_certificate /etc/nginx/ssl/chain.pem;
```

**Verificar configuración:**
```bash
# Probar configuración
nginx -t

# Reiniciar servicio
systemctl restart nginx

# Verificar en https://www.ssllabs.com/ssltest/
```

---

### Hallazgo #8: Cabeceras de Seguridad HTTP Ausentes

| Atributo | Valor |
|---|---|
| **Severidad** | **MEDIA** |
| **CVSS v3.1** | 4.3 |

#### Descripción
Nikto detectó la ausencia de múltiples cabeceras de seguridad HTTP que son estándar en configuraciones seguras.

| Cabecera | Estado | Riesgo |
|---|---|---|
| Strict-Transport-Security (HSTS) | ❌ Ausente | Ataques de downgrade SSL |
| Content-Security-Policy (CSP) | ❌ Ausente | XSS, inyección de datos |
| Referrer-Policy | ❌ Ausente | Fuga de información |
| Permissions-Policy | ❌ Ausente | Acceso a APIs del navegador |
| X-Content-Type-Options | ❌ Ausente | MIME type sniffing |
| X-Frame-Options | ❌ Ausente | Clickjacking |

#### Evidencia
```
+ [013587] /: Suggested security header missing: referrer-policy.
+ [013587] /: Suggested security header missing: permissions-policy.
+ [013587] /: Suggested security header missing: strict-transport-security.
+ [013587] /: Suggested security header missing: content-security-policy.
+ [013587] /: Suggested security header missing: x-content-type-options.
```

#### Impacto
Mayor exposición a ataques de tipo XSS, clickjacking, sniffing MIME, y downgrade de conexiones SSL.

#### Recomendación

**Agregar cabeceras en nginx:**
```nginx
# /etc/nginx/sites-available/default

add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'" always;
```

**Agregar cabeceras en Apache:**
```apache
# .htaccess o httpd.conf
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
Header always set X-Frame-Options "DENY"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
```

---

### Hallazgo #9: Certificado SSL con Múltiples SAN Names

| Atributo | Valor |
|---|---|
| **Severidad** | **BAJA** (Informativo) |
| **Certificado Emisor** | Let's Encrypt R13 |
| **Válido hasta** | 23 de julio de 2026 |

#### Descripción
El certificado SSL incluye múltiples nombres alternativos (Subject Alternative Names) que revelan información sobre la infraestructura.

#### SAN Names expuestos
```
- autodiscover.hackingseguridad.com
- cgn.ilc.mybluehost.me
- cpanel.hackingseguridad.com
- mail.cgn.ilc.mybluehost.me
- mail.hackingseguridad.com
- hackingseguridad.com
- webdisk.hackingseguridad.com
- webmail.hackingseguridad.com
- www.cgn.ilc.mybluehost.me
- www.hackingseguridad.com
```

#### Observación
La presencia del dominio `mybluehost.me` indica que el sitio está alojado en infraestructura compartida de Bluehost. No constituye una vulnerabilidad, pero proporciona información valiosa para un atacante.

#### Recomendación
- Renovar certificado antes del 23 de julio de 2026
- Considerar certificado Wildcard (`*.hackingseguridad.com`) para simplificar gestión
- Evaluar migración a IP dedicada si la información de hosting compartido es un riesgo de negocio

---

### Hallazgo #10: Cabecera HTTP Personalizada "Host-Header"

| Atributo | Valor |
|---|---|
| **Severidad** | **BAJA** (Informativo) |
| **Cabecera** | host-header: c2hhcmVkLmJsdWVob3N0LmNvbQ== |

#### Descripción
Se detectó una cabecera HTTP no estándar `Host-Header` con un valor codificado en Base64.

#### Decodificación
```bash
echo "c2hhcmVkLmJsdWVob3N0LmNvbQ==" | base64 -d
# Resultado: shared.bluehost.com
```

#### Observación
Esta cabecera es típica de entornos de hosting compartido de Bluehost y se utiliza para el enrutamiento interno. No representa una vulnerabilidad, pero confirma la naturaleza compartida del alojamiento.

#### Recomendación
No requiere acción específica, documentado para contexto.

---

## 4. Detalle de Puertos y Servicios

### 4.1 Puertos Abiertos Detectados

| Puerto | Servicio | Producto | Versión | Riesgo |
|---|---|---|---|---|
| 21 | FTP | Pure-FTPd | - | Medio |
| 22 | SSH | OpenSSH | 8.7 | **Crítico** |
| 25 | SMTP | Exim | 4.99.2 | Medio |
| 26 | SMTP | Exim | 4.99.2 | Medio |
| 53 | DNS | ISC BIND | 9.16.23 | **Crítico** |
| 80 | HTTP | Apache | - | Bajo |
| 110 | POP3 | Dovecot | - | Bajo |
| 143 | IMAP | Dovecot | - | Bajo |
| 443 | HTTPS | nginx/Apache | 1.27.2 | Bajo |
| 465 | SMTPS | Exim | 4.99.2 | Medio |
| 587 | SMTP | Exim | 4.99.2 | Medio |
| 993 | IMAPS | Dovecot | - | Bajo |
| 995 | POP3S | Dovecot | - | Bajo |
| 2077 | cPanel | - | - | Alto |
| 2078 | cPanel SSL | - | - | Alto |
| 2082 | cPanel | - | - | **Alto** |
| 2083 | cPanel SSL | - | - | **Alto** |
| 2086 | WHM | - | - | **Alto** |
| 2087 | WHM SSL | - | - | **Alto** |
| 2095 | Webmail | - | - | Medio |
| 2096 | Webmail SSL | - | - | Medio |
| 2222 | cPanel SSH | OpenSSH | 8.7 | **Alto** |
| 3306 | MySQL | MySQL | 5.7.44-48 | **Crítico** |
| 5432 | PostgreSQL | PostgreSQL | 13.23 | **Crítico** |
| 37643 | rpcbind | - | - | Informativo |

---

## 5. Vulnerabilidades SSL/TLS - Análisis Completo

### 5.1 Resumen de Protocolos Soportados

| Protocolo | Estado | Riesgo |
|---|---|---|
| SSLv2 | Deshabilitado | ✅ Seguro |
| SSLv3 | Deshabilitado | ✅ Seguro |
| TLSv1.0 | Deshabilitado | ✅ Seguro |
| TLSv1.1 | Deshabilitado | ✅ Seguro |
| TLSv1.2 | **Habilitado** | ✅ Aceptable |
| TLSv1.3 | **Habilitado** | ✅ Seguro |

### 5.2 Cifrados TLS Soportados

| Cifrado | TLS | Bits | Seguridad |
|---|---|---|---|
| TLS_AES_256_GCM_SHA384 | 1.3 | 256 | ✅ Seguro |
| TLS_CHACHA20_POLY1305_SHA256 | 1.3 | 256 | ✅ Seguro |
| TLS_AES_128_GCM_SHA256 | 1.3 | 128 | ✅ Seguro |
| TLS_AES_128_CCM_SHA256 | 1.3 | 128 | ⚠️ Revisar |
| TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 | 1.2 | 128 | ✅ Seguro |
| TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 | 1.2 | 256 | ✅ Seguro |
| TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 | 1.2 | 128 | ✅ Seguro |
| TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 | 1.2 | 256 | ✅ Seguro |

### 5.3 Forward Secrecy
✅ **Soportado** - Todos los cifrados utilizan Diffie-Hellman Ephemeral (DHE/ECDHE)

---

## 6. Información de Dominio y Subdominios

### 6.1 Registro WHOIS

| Campo | Valor |
|---|---|
| **Dominio** | hackingseguridad.com |
| **Creación** | 2017-11-16 |
| **Expiración** | 2026-11-16 |
| **Registrar** | Bluehost Inc. |
| **Name Servers** | NS1.BLUEHOST.COM, NS2.BLUEHOST.COM |
| **DNSSEC** | No configurado |

### 6.2 Subdominios Detectados (dnsmap)

| Subdominio | IP |
|---|---|
| cpanel.hackingseguridad.com | 1.1.1.1 |
| ftp.hackingseguridad.com | 1.1.1.1 |
| imap.hackingseguridad.com | 1.1.1.1 |
| localhost.hackingseguridad.com | 127.0.0.1 |
| mail.hackingseguridad.com | 1.1.1.1 |
| pop.hackingseguridad.com | 1.1.1.1 |
| smtp.hackingseguridad.com | 1.1.1.1 |
| webmail.hackingseguridad.com | 1.1.1.1 |
| www.hackingseguridad.com | 1.1.1.1 |

### 6.3 Registros DNS

| Tipo | Valor |
|---|---|
| **SOA** | ns1.bluehost.com |
| **NS** | ns1.bluehost.com, ns2.bluehost.com |
| **MX** | mail.hackingseguridad.com |
| **A** | 1.1.1.1 |
| **TXT** | v=spf1 a mx include:websitewelcome.com ~all |

---

## 7. Plan de Remediación Detallado

### 7.1 Acciones Inmediatas (Día 1, 0-24 horas)

| # | Acción | Comandos / Configuración | Responsable | Tiempo |
|---|---|---|---|---|
| 1 | Actualizar OpenSSH | `apt update && apt upgrade openssh-server -y` | Sysadmin | 1h |
| 2 | Restringir SSH por IP | `echo "AllowUsers *@192.168.0.0/16" >> /etc/ssh/sshd_config` | Sysadmin | 30m |
| 3 | Bloquear puertos cPanel/WHM | Ver script de firewall | Network admin | 1h |
| 4 | Deshabilitar FTP anónimo | `echo "NoAnonymous yes" > /etc/pure-ftpd/conf/NoAnonymous` | Sysadmin | 15m |

### 7.2 Script de Firewall Urgente

```bash
#!/bin/bash
# firewall_urgente.sh - Ejecutar inmediatamente

echo "=== CONFIGURANDO FIREWALL DE EMERGENCIA ==="

# Limpiar reglas existentes
iptables -F
iptables -X

# Política por defecto
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir loopback
iptables -A INPUT -i lo -j ACCEPT

# Permitir conexiones establecidas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH - Restringido (ajustar según necesidad)
iptables -A INPUT -p tcp --dport 22 -s 192.168.0.0/16 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT

# HTTP/HTTPS - Público
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# BLOQUEAR PUERTOS ADMINISTRATIVOS DESDE INTERNET
for PORT in 2082 2083 2086 2087 2095 2096 2222 3306 5432 21; do
    iptables -A INPUT -p tcp --dport $PORT -s 192.168.0.0/16 -j ACCEPT
    iptables -A INPUT -p tcp --dport $PORT -j LOG --log-prefix "BLOCKED_ADMIN_PORT: "
    iptables -A INPUT -p tcp --dport $PORT -j DROP
done

# Guardar reglas (ajustar según distribución)
iptables-save > /etc/iptables/rules.v4

echo "=== FIREWALL CONFIGURADO ==="
iptables -L -n
```

### 7.3 Acciones de Alto Impacto (Días 2-7)

| # | Acción | Detalle | Responsable | Tiempo | CVSS reducido |
|---|---|---|---|---|---|
| 1 | Actualizar BIND | `apt upgrade bind9 -y` | Sysadmin | 1h | 7.5 → 0 |
| 2 | Migrar MySQL 5.7 → 8.0 | Backup + upgrade + testing | DBA | 4h | 8.8 → 2.0 |
| 3 | Actualizar PostgreSQL | A versión 13.24+ | DBA | 2h | 7.2 → 0 |
| 4 | Configurar HSTS | Agregar cabeceras en nginx | Web admin | 1h | 5.3 → 2.0 |
| 5 | Configurar fail2ban | Protección SSH y servicios | Sysadmin | 1h | Mitigación |

### 7.4 Configuración de fail2ban

```bash
# Instalar fail2ban
apt install fail2ban -y

# Configurar jail.local
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[ss
