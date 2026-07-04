---
name: blacklist-ip
description: >
  Usar esta skill SIEMPRE que el usuario quiera comprobar si una IP, rango de IPs o dominio
  está en una lista negra (blacklist), RBL o DNSBL (Spamhaus, SORBS, Barracuda, UCEPROTECT,
  abuse.ch, etc.). Activar cuando se mencionen: lista negra, blacklist, DNSBL, RBL, IP
  listada/bloqueada, reputación de IP, spam blacklist, comprobar reputación de dominio/correo,
  deliverability de email, servidor SMTP bloqueado, IP marcada como spam/phishing/malware/botnet/
  proxy abierto, o códigos de retorno de Spamhaus (127.0.0.x). También activar cuando el usuario
  proporcione una IP o fichero de IPs y pida: auditar reputación, verificar blacklisting, sacar
  de lista negra (delisting), o análisis forense de por qué un servidor de correo rebota.
  Repositorio de referencia: https://github.com/hackingyseguridad/listanegra
---

# Blacklist IP Skill — hackingyseguridad/listanegra

Skill de auditoría de reputación IP contra RBL/DNSBL. El repositorio contiene varios scripts
en shell con distintos grados de robustez, ficheros de listas/DNS de apoyo, una tabla completa
de referencia de listas (`LISTAS.md`) y los códigos de retorno de Spamhaus documentados en el
`README.md`. Este SKILL.md está verificado línea a línea contra el código real de cada script
(no solo contra la documentación del README, que en algunos puntos no coincide con el
comportamiento real — ver sección de advertencias más abajo).

Motivo por el que una IP acaba en lista negra (contexto para el análisis y el informe):

1. Spam de correo electrónico, phishing, scam, servicios de spam-support, bulletproof hosting, spambots.
2. Sitios de phishing / suplantación de identidad.
3. Distribución de malware / equipos infectados.
4. Command & Control de botnets / equipos zombis.
5. Proxies abiertos HTTP/SOCKS comprometidos.

Impacto de estar listado: rechazo o filtrado a spam de los correos salientes, pérdida de
reputación ante ISPs, y en agresivas incluso bloqueo de rangos CIDR completos (p.ej. `/24`) o
de un AS completo si ~20% de sus IPs activas están listadas (umbral que aplican UCEPROTECT
Nivel 3 y los sistemas de reputación de Spamhaus).

---

## FASE 0 — Preparación del entorno

```bash
git clone https://github.com/hackingyseguridad/listanegra.git
cd listanegra
chmod +x *.sh

# Dependencias necesarias (Kali Linux normalmente ya las trae)
sudo apt install -y whois dnsutils curl jq --break-system-packages 2>/dev/null || \
sudo apt install -y whois dnsutils curl jq
```

Ficheros de configuración incluidos en el repo (necesarios según el script, ver tabla siguiente):

| Fichero | Contenido real en el repo | Usado por |
|---|---|---|
| `listas.txt` | ~207 FQDN de RBL/DNSBL, **una sola columna** (solo el dominio, sin nombre) | `listanegra.sh`, `listanegra2.sh`, `consulta.sh` (con bug, ver abajo) |
| `dns.txt` | Lista de resolvers DNS a rotar (127.0.0.1, 1.1.1.1, 8.8.8.8, 9.9.9.9, resolvers `.es`, IPv6) | `listanegra.sh`, `listanegra2.sh`, `spamhaus.sh`, `spamhaus2.sh` |
| `ip.txt` | **No viene en el repo** — debe crearlo el usuario, una IP por línea | `listanegra2.sh`, `spamhaus2.sh` |
| `resultado.txt` | Fichero de salida, se genera/sobreescribe en cada ejecución | Todos los scripts |
| `LISTAS.md` | Tabla de referencia con ~200 RBL/DNSBL, tipo de amenaza y descripción | Consulta manual / documentación |
| `LEEME.md` / `README.md` | Documentación general (idéntica en ambos), tabla de scripts y códigos Spamhaus | Documentación |

---

## FASE 1 — Elegir el script correcto

**Importante:** la tabla de scripts del `README.md`/`LEEME.md` del repositorio **no coincide**
con el comportamiento real del código en varios casos (ver advertencias en FASE 1-bis). La
tabla siguiente refleja lo que hace **realmente** cada script tras revisar su código fuente.

| Script | Entrada | Qué consulta | Requiere en el directorio |
|---|---|---|---|
| `consulta2.sh` | IP(s) como argumento, `-f fichero`, o stdin (`-`) | 5 RBL clave, embebidas en el propio script (`zen.spamhaus.org`, `b.barracudacentral.org`, `bl.spamcop.net`, `dnsbl.sorbs.net`, `cbl.abuseat.org`) | Nada más — **autocontenido, es el más portable** |
| `listanegra.sh` | **Una** IP como argumento (`$1`) | **Todas** las FQDN de `listas.txt` (~207 listas) | `dns.txt`, `listas.txt` |
| `listanegra2.sh` | Lee **varias** IPs desde `ip.txt` | **Todas** las FQDN de `listas.txt` para cada IP | `ip.txt`, `dns.txt`, `listas.txt` |
| `spamhaus.sh` | **Una** IP como argumento (`$1`) | Solo Spamhaus: SBL → XBL → PBL → CSS, en cascada, con nombre exacto del código | `dns.txt` |
| `spamhaus2.sh` | Lee **varias** IPs desde `ip.txt` | Solo Spamhaus (SBL/XBL/PBL/CSS) para cada IP | `ip.txt`, `dns.txt` |
| `consulta.sh` | IP(s), `-f fichero`, o stdin | ⚠️ Tiene un bug de formato, ver abajo | `listas.txt` |
| `consulta1.sh` | IP(s), `-f fichero`, o stdin | ⚠️ Depende de `todas.txt`, fichero que no existe en el repo | `todas.txt` (no incluido) |

### ⚠️ Advertencias verificadas (no confiar ciegamente en el README del repo)

- **`consulta.sh` tiene un bug real de parseo.** Espera que `listas.txt` tenga dos columnas
  (`nombre dominio`), pero el `listas.txt` del repo solo tiene **una** columna (el FQDN). Al
  hacer `awk '{print $2}'` sobre una línea de una sola palabra, el campo `dominio` sale vacío,
  la consulta DNS se construye como `IP_INVERTIDA.` (con un punto final y sin dominio), y por
  tanto **el script siempre devuelve "LIMPIA" aunque la IP esté realmente listada**. No lo uses
  tal cual para tomar decisiones; usa `listanegra.sh`/`listanegra2.sh` (compatibles con el
  `listas.txt` de una columna) o `consulta2.sh` (autocontenido) en su lugar.
- **`consulta1.sh` no es ejecutable "out of the box"**: referencia un fichero `todas.txt` que
  no está en el repositorio. Fallará salvo que el usuario cree manualmente ese fichero con el
  mismo formato de una FQDN por línea que `listas.txt`.
- El `README.md`/`LEEME.md` del repo describe `listanegra.sh` como "consulta tu IP pública
  actual sin argumentos" y `listanegra2.sh` como "consulta una IP concreta arbitraria" — **esto
  no es lo que hace el código real**: ambos requieren argumentos/ficheros como se detalla en la
  tabla de arriba (IP única por argumento vs. lote desde `ip.txt`). Confía en el comportamiento
  verificado, no en la tabla de la doc.

---

## FASE 2 — Consulta rápida y portable (recomendada para uso puntual)

```bash
# Una IP
./consulta2.sh 203.0.113.10

# Varias IPs como argumentos
./consulta2.sh 203.0.113.10 198.51.100.25 8.8.8.8

# Desde fichero
./consulta2.sh -f ip.txt

# Desde stdin
echo "203.0.113.10" | ./consulta2.sh -
```

Salida: `[LISTADA] IP → lista1, lista2` o `[LIMPIA] IP → No aparece en ninguna lista`, y además
se anexa a `resultado.txt`. Solo cubre 5 RBL (las de mayor peso real en filtrado de correo), por
lo que es ideal para un triage rápido, no para una auditoría exhaustiva.

---

## FASE 3 — Auditoría exhaustiva contra ~207 RBL/DNSBL

Usa `listanegra.sh` (una IP) o `listanegra2.sh` (lote desde `ip.txt`). Ambos recorren
**todo** `listas.txt` y rotan servidor DNS de `dns.txt` según el último octeto de la IP (o el
índice de procesamiento en el caso de `listanegra2.sh`).

```bash
# Una sola IP contra las ~207 listas
./listanegra.sh <IP>

# Lote de IPs (una por línea) contra las ~207 listas
cat > ip.txt << 'EOF'
203.0.113.10
198.51.100.25
EOF
./listanegra2.sh
```

**Interpretación de la salida:**
- `>>> LISTADA en: <fqdn> (Código: 127.x.x.x)` → listado positivo, documentar.
- `LIMPI en: <fqdn>` → no listado en esa RBL concreta.
- `ERROR en: <fqdn> (Código: 127.255.255.x)` → error de consulta (ver tabla de códigos de error
  en FASE 5), **no es un listado**, no debe interpretarse como positivo.
- Resumen final: total de listas, listadas, limpias y errores.
- Resultados acumulados en `resultado.txt` (se **anexa**, no se sobreescribe, en `listanegra.sh`;
  revisa/limpia el fichero entre auditorías distintas si no quieres mezclar resultados).

---

## FASE 4 — Verificación específica en Spamhaus (SBL/XBL/PBL/CSS)

Cuando el hallazgo se centra en Spamhaus (la fuente de reputación más usada por Microsoft,
Google y miles de empresas), usa `spamhaus.sh` (una IP) o `spamhaus2.sh` (lote desde `ip.txt`).
Consultan en cascada SBL → XBL → PBL → CSS y muestran el nombre exacto de la lista.

```bash
./spamhaus.sh <IP>
# o, para varias IPs:
./spamhaus2.sh
```

- `SBL (Spamhaus Blocklist)` → spam/phishing/hosting malicioso confirmado por analistas.
- `XBL (Exploits Blocklist)` → equipo comprometido (botnet/malware) enviando spam.
- `PBL (Policy Blocklist)` → rango dinámico/residencial que no debería enviar correo directo.
- `CSS (Combined Spam Sources)` → spam de baja reputación detectado automáticamente, sin SPF/DKIM/DMARC.
- Spamhaus DNSBL solo soporta consultas IPv4.

---

## FASE 5 — Códigos de retorno de Spamhaus (referencia para interpretar cualquier script)

| Código | Lista | Significado | Acción |
|---|---|---|---|
| `127.0.0.2` | SBL | IP en spam, phishing o hosting malicioso | Bloquear / Marcar |
| `127.0.0.3` | CSS | Fuente de spam detectada automáticamente | Bloquear / Marcar |
| `127.0.0.4` | XBL | Equipo comprometido (botnet/malware) enviando spam | Bloquear / Marcar |
| `127.0.0.9` | DROP | Rango usado por ciberdelincuentes (se añade a otro código, no aparece solo) | Bloquear / Marcar |
| `127.0.0.10` / `.11` | PBL | Red residencial/dinámica, no debería enviar correo directo | Bloquear con precaución (falsos positivos si usa smarthost del ISP) |
| `127.0.0.30` | BCL | Aloja C&C de una botnet | Bloquear / Marcar |
| `127.0.1.2/.4/.5/.6` | DBL | Dominio (no IP) de spam/phishing/malware/C&C | Bloquear / Marcar (solo aplica a dominios) |
| `127.0.2.2`–`.24` | ZRD | Dominio visto por primera vez, hace 2–24h | Marcar con precaución, no bloquear solo por esto |
| `127.255.255.252` | ERROR | FQDN de la lista mal escrito | **No bloquear**, revisar ortografía |
| `127.255.255.254` | ERROR | Consulta hecha vía resolver público (8.8.8.8, etc.) | **No bloquear**, usar DNS local |
| `127.255.255.255` | ERROR | Límite de uso justo superado | **No bloquear**, reducir frecuencia o usar DQS |
| `127.0.1.255` | ERROR | Se consultó DBL con una IP en vez de un dominio | **No bloquear**, usar dominio |

Nota clave: `zen.spamhaus.org` combina SBL+XBL+PBL+CSS en una sola consulta — el código que
devuelve indica la sublista real, pero si necesitas saber cuál exactamente sin ambigüedad,
consulta cada lista Spamhaus por separado (esto es justo lo que hace `spamhaus.sh`/`spamhaus2.sh`).

---

## FASE 6 — Consulta manual / verificación cruzada (web, para evidencia de informe o delisting)

| Servicio | URL |
|---|---|
| Spamhaus (consulta directa + enlace de delisting) | https://check.spamhaus.org/query/ip/$IP |
| CBL / abuseat.org | https://www.abuseat.org/ |
| AbuseIPDB | https://www.abuseipdb.com/ |
| AlienVault OTX | https://otx.alienvault.com/ |
| Shodan (contexto de puertos/servicios expuestos) | https://www.shodan.io/ |
| WhatIsMyIPAddress Blacklist Check | https://whatismyipaddress.com/blacklist-check |
| BlacklistAlert | https://blacklistalert.org/ |
| DNSBL.info | https://www.dnsbl.info/ |
| MXToolbox | https://mxtoolbox.com/ |
| MultiRBL (Valli) | https://multirbl.valli.org/lookup/$IP.html |

Estos paneles suelen incluir el enlace directo de **delisting/removal request** cuando la IP
figura listada, dato imprescindible para la sección de remediación del informe.

---

## FASE 7 — Referencia de listas RBL/DNSBL por tipo de amenaza

El repo incluye `LISTAS.md` con ~200 RBL clasificadas. Extracto de las más relevantes para un
informe (consulta `LISTAS.md` en el repo clonado para la tabla completa):

| Lista | Tipo | Descripción |
|---|---|---|
| `zen.spamhaus.org` | Combinada | SBL+XBL+CSS+PBL en una consulta; referencia para Microsoft/Google. |
| `sbl-xbl.spamhaus.org` | Combinada | SBL + XBL de Spamhaus. |
| `all.spamrats.com` | Combinada | Spam, botnets y proxies. |
| `bl.spamcop.net` | Spam Email | Alimentada por reportes de usuarios y spamtraps; muy respetada. |
| `dnsbl.sorbs.net` | Spam/Relays | Spam and Open Relay Blocking System. |
| `dnsbl-1/2/3.uceprotect.net` | Spam Email | UCEPROTECT niveles 1 (IP), 2 (rango) y 3 (AS completo). |
| `b.barracudacentral.org` | Spam Email | Reputación de Barracuda Networks. |
| `cbl.abuseat.org` | Malware/Botnet | Composite Blocking List — malware, bots, proxies abiertos. |
| `ipbl.zeustracker.abuse.ch` | Malware/Botnet | C&C de la botnet Zeus. |
| `phishing.rbl.msrbl.net` | Phishing | Sitios de suplantación de identidad. |
| `proxies.dnsbl.sorbs.net` | Proxy | Proxies HTTP/SOCKS abiertos comprometidos. |
| `pbl.spamhaus.org` | Política | Rangos dinámicos/residenciales, no deberían enviar correo directo. |

---

## FASE 8 — Decisión: siguiente paso según resultado

| Resultado | Acción recomendada |
|---|---|
| No listada en ninguna RBL | Documentar como OK / baseline de reputación limpia |
| Listada solo en RBL secundarias/experimentales | Riesgo bajo, monitorizar, revisar SPF/DKIM/DMARC |
| Listada en Spamhaus PBL | Verificar si la IP es dinámica/residencial y no debería enviar correo directo (usar smarthost/relay del ISP) |
| Listada en Spamhaus SBL/XBL/ZEN/CSS, SORBS, Barracuda o UCEPROTECT | Riesgo alto: investigar compromiso (malware, relay abierto, cuenta comprometida) antes de solicitar delisting |
| ≥20% de IPs de un mismo AS listadas | Riesgo de bloqueo de todo el AS (umbral crítico Spamhaus/UCEPROTECT Nivel 3) |

---

## FASE 9 — Remediación / Delisting (checklist)

1. Confirmar y **corregir la causa raíz** (limpiar malware, cerrar relay/proxy abierto, rotar
   credenciales SMTP comprometidas, filtrar salida SMTP con firewall).
2. Verificar registros de autenticación de correo: SPF, DKIM y DMARC correctamente publicados.
3. Solicitar el delisting en cada RBL donde aparezca (Spamhaus:
   https://check.spamhaus.org/query/ip/$IP incluye el enlace "Remove me from this list").
4. Volver a ejecutar `consulta2.sh` (rápido) y `listanegra.sh`/`spamhaus.sh` (completo)
   transcurridas 24–72h para confirmar la baja.
5. Monitorización continua recomendada (cron diario con `consulta2.sh` sobre las IPs de salida SMTP).

---

## PLANTILLA DE HALLAZGO PARA INFORME

```
HALLAZGO: IP en lista negra (Blacklist / DNSBL)
IP/Rango:  [objetivo]
PTR:       [resultado de dig -x]
ASN/Whois: [organización propietaria]
CVSS v3.1: N/A (hallazgo operativo, no vulnerabilidad técnica clásica) — clasificar como
           Informativo/Medio/Alto según impacto en entregabilidad de correo

LISTAS EN LAS QUE APARECE:
- zen.spamhaus.org   -> [SI/NO] (código: [127.x.x.x])
- sbl.spamhaus.org   -> [SI/NO]
- xbl.spamhaus.org   -> [SI/NO]
- pbl.spamhaus.org   -> [SI/NO]
- [otras RBL detectadas por listanegra.sh / consulta2.sh]

DESCRIPCIÓN:
[Contexto: motivo probable — spam, phishing, malware, botnet C&C, proxy abierto]

EVIDENCIA:
$ ./consulta2.sh <IP>
[output recortado]
$ ./listanegra.sh <IP>
[output recortado]
$ ./spamhaus.sh <IP>
[output recortado]

IMPACTO:
[Correo rebotado/marcado como spam, reputación de dominio afectada, posible indicador de compromiso]

REMEDIACIÓN:
- Identificar y neutralizar la causa raíz (ver FASE 9)
- Publicar/corregir SPF, DKIM, DMARC
- Solicitar delisting en cada RBL afectada
- Monitorización periódica de reputación

REFERENCIAS:
- https://github.com/hackingyseguridad/listanegra
- https://check.spamhaus.org/query/ip/[IP]
```

---

## REFERENCIAS

- Repositorio: https://github.com/hackingyseguridad/listanegra
- Scripts verificados: `consulta2.sh` (recomendado, autocontenido), `listanegra.sh` /
  `listanegra2.sh` (auditoría completa contra `listas.txt`), `spamhaus.sh` / `spamhaus2.sh`
  (Spamhaus en cascada). `consulta.sh` y `consulta1.sh` tienen bugs conocidos, ver FASE 1.
- Documentación del repo: `README.md` / `LEEME.md` (tabla de scripts, códigos Spamhaus),
  `LISTAS.md` (tabla completa de ~200 RBL/DNSBL por tipo de amenaza)
- Spamhaus Blocklists (doc. oficial): https://www.spamhaus.org/blocklists/
- Spamhaus FAQ (códigos de respuesta): https://www.spamhaus.org/faq/
- www.hackingyseguridad.com
