#!/bin/sh
# Esaneo de puertos/servicios y vulnerabilidades conocidas.  @antonio_taboada
cat << "INFO"

(:`--..___...-''``-._             |`._
  ```--...--.      . `-..__      .`/ _\  
            `\     '       ```--`.    />
            : :   :               `:`-'
             `.:.  `.._--...___     ``--...__      
                ``--..,)       ```----....__,)   http://www.hackingyseguridad.com
                 Aldea del Fresno / Madrid 2026
$$$$$$ $$$$$ $$$$  $$$ $$$$  $$$     $$$$     $$$$$$ $$$$$ $$$$$$$$$ $$$$$$$$$ $$$
INFO
if [ -z "$1" ]; then
        echo
        echo "Esaneo de puertos/servicios y vulnerabilidades conocidas."
        echo "Requiere nmap"
        echo "Uso.: sh redaudit.sh <ip/fqdn/rango>"
        echo
        exit 0
fi
echo
nmap -Pn $1 $2 $3 $4 $5 -sVC -O --script=default,banner,vuln,vulners --script-args mincvss=7 -p- --open -oX resultado.xml -oN resultado.csv
