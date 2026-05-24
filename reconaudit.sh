#!/bin/sh
# Script: reconaudit.sh
# Uso: sh recon.sh <dominio|FQDN|IP>
# Compatible con shells antiguas (Bash 1.0.x y sh)

# Colores básicos (si no soporta, se pueden quitar)
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NC="\033[0m" # Sin color

# Mostrar ayuda
if [ $# -ne 1 ]; then
    echo "Uso: $0 <dominio|FQDN|IP>"
    echo "Ejemplo: $0 ejemplo.com"
    echo "         $0 8.8.8.8"
    exit 1
fi

TARGET="$1"
echo "${GREEN}=== Reconocimiento sobre: $TARGET ===${NC}"
echo ""

# Función para verificar si es IP
is_ip() {
    echo "$1" | grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' > /dev/null
}

# 1. WHOIS - Dueño del dominio o IP
echo "${YELLOW}[*] WHOIS - Información de registro:${NC}"
if is_ip "$TARGET"; then
    whois "$TARGET" | head -30
else
    whois "$TARGET" | grep -E "Registrant|Organization|Name Server|Creation Date|Expiry Date|Admin|Tech" | head -20
fi
echo ""

# 2. Resolución DNS inversa (si es IP)
if is_ip "$TARGET"; then
    echo "${YELLOW}[*] Resolución inversa (PTR):${NC}"
    host "$TARGET" 2>/dev/null || nslookup "$TARGET" 2>/dev/null | grep "name ="
    echo ""
fi

# 3. Registros DNS básicos
echo "${YELLOW}[*] Registros A (IPv4):${NC}"
host -t A "$TARGET" 2>/dev/null || nslookup "$TARGET" 2>/dev/null | grep "Address"
echo ""

echo "${YELLOW}[*] Registros MX (Mail Exchange):${NC}"
host -t MX "$TARGET" 2>/dev/null || nslookup -type=MX "$TARGET" 2>/dev/null | grep "mail exchanger"
echo ""

echo "${YELLOW}[*] Registros NS (Name Servers):${NC}"
host -t NS "$TARGET" 2>/dev/null || nslookup -type=NS "$TARGET" 2>/dev/null | grep "nameserver"
echo ""

echo "${YELLOW}[*] Registros TXT (incluyendo SPF, DKIM, etc.):${NC}"
host -t TXT "$TARGET" 2>/dev/null | head -10
echo ""

# 4. Búsqueda de subdominios (con lista básica hardcodeada)
echo "${YELLOW}[*] Buscando subdominios comunes...${NC}"
SUBDOMS="www mail ftp ns1 ns2 blog shop api dev test vpn"

for sub in $SUBDOMS; do
    subdomain="$sub.$TARGET"
    ip=$(host "$subdomain" 2>/dev/null | grep "has address" | head -1 | awk '{print $4}')
    if [ -n "$ip" ]; then
        echo "  [+] $subdomain -> $ip"
    fi
done
echo ""

# 5. Reputación básica (consultas externas públicas)
echo "${YELLOW}[*] Reputación y listas negras (básico):${NC}"
if ! is_ip "$TARGET"; then
    # Obtener IP del dominio
    ip_target=$(host "$TARGET" 2>/dev/null | grep "has address" | head -1 | awk '{print $4}')
    if [ -z "$ip_target" ]; then
        ip_target="$TARGET"
    fi
else
    ip_target="$TARGET"
fi

echo "  Consultando en AbuseIPDB (resumen público):"
echo "  https://www.abuseipdb.com/check/$ip_target"
echo ""
echo "  Consultando en VirusTotal (dominio):"
echo "  https://www.virustotal.com/gui/domain/$TARGET"
echo ""

# 6. Ping simple para ver si responde
echo "${YELLOW}[*] Estado del host (ping):${NC}"
if ping -c 1 -W 2 "$TARGET" > /dev/null 2>&1; then
    echo "  [+] $TARGET responde a ping"
else
    echo "  [-] $TARGET NO responde a ping (quizás bloqueado)"
fi
echo ""

# 7. Escaneo de puertos comunes (simple, con nc o telnet)
echo "${YELLOW}[*] Puertos comunes abiertos (TCP):${NC}"
COMMON_PORTS="22 80 443 25 110 143 993 995 8080 8443 3306 5432"
for port in $COMMON_PORTS; do
    # Usar timeout o no, según disponibilidad
    if command -v nc > /dev/null 2>&1; then
        nc -z -w 2 "$TARGET" "$port" 2>/dev/null && echo "  [+] Puerto $port abierto"
    else
        # Alternativa con telnet
        (echo "quit" | telnet "$TARGET" "$port" 2>/dev/null | grep -q "Connected") && echo "  [+] Puerto $port abierto"
    fi
done
echo ""

echo "${GREEN}=== Fin del reconocimiento ===${NC}"
