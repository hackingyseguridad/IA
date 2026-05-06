#!/bin/bash

Negro='\033[0;30m'
Rojo='\033[0;31m'
Verde='\033[0;32m'
Amarillo='\033[0;33m'
Azul='\033[0;34m'
Purpura='\033[0;35m'
Cyan='\033[0;36m'
Blanco='\033[0;37m'
Normal='\033[0m'
cat << "INFO"
  __           _                         _ _ _
 / _| __ _  __| |_ __     __ _ _   _  __| (_) |_
| |_ / _` |/ _` | '_ \   / _` | | | |/ _` | | __|
|  _| (_| | (_| | | | | | (_| | |_| | (_| | | |_
|_|  \__, |\__,_|_| |_|  \__,_|\__,_|\__,_|_|\__| V 1.0
        |_|      http://www.hackingyseguridad.com
                 Aldea del Fresno
$$$$$$ $$$$$ $$$$  $$$ $$$$  $$$     $$$$     $$$$$$ $$$$$ $$$$$$$$$ $$$$$$$$$
INFO

if [ -z "$1" ]; then
        printf "${Amarillo}" ; echo
        echo "Test vulnerabilidades API."
        echo "Uso: $0 <fqdn URI>"; printf "${Normal}\n"
        exit 0
fi
echo
echo "================================================="
echo "test sobre la el fqdn de la URI.: $1"
echo "================================================="
echo
echo -e "\e[00;32m# Informacion del host ########################################################\e[00m"
echo
host $1
echo
echo -e "\e[00;32m# Versiones HTTP soportadas por el  servidor web ####@@##########################\e[00m"
echo
timeout 3 curl -Is --http1.0 https://$1 | head -1
timeout 3 curl -Is --http1.1 https://$1 | head -1
timeout 3 curl -Is --http2-prior-knowledge https://$1 | head -1
echo
whatweb https://$1
echo
HEAD https://$1
echo
curl -I -v https://$1
echo
echo -e "\e[00;32m# Detecta firewall o balanceador ########################################################\e[00m"
echo
timeout 3 lbd $1
echo
echo -e "\e[00;32m# Detecta firewall WAF ########################################################\e[00m"
echo
curl -sI  https://$1   | grep "server: "
echo
timeout 3 wafw00f $1
echo
echo -e "\e[00;32m#Vulnerabilidades SSL, certificado ######################################################\e[00m"
echo
sslyze  $1
echo
sslscan $1
echo
sslyze --certinfo $1
sslyze --compression $1
sslyze --reneg $1
sslyze --resum $1
echo
echo -e "\e[00;32m# Metodos HTTP ##########################################################\e[00m"
echo
echo " ==== Metodos http!"
echo "PUT";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X PUT  -H 'X-Method-Override: PUT' -H "X-HTTP-Method: PUT" -H "X-Method-Override: PUT"
echo
echo "prueba PUT "; curl -k -X PUT https://$1 -d "HOLA"
echo
echo "TRACE";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X TRACE  -H 'X-Method-Override: TRACE' -H "X-HTTP-Method: TRACE" -H "X-Method-Override: TRACE"
echo
echo "prueba TRACE "; curl -k https://$1 -X TRACE
echo
echo "GET";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X GET -H 'X-Method-Override: GET' -H "X-HTTP-Method: GET" -H "X-Method-Override: GET"
echo "POST";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X POST -H 'X-Method-Override: POST' -H "X-HTTP-Method: POST" -H "X-Method-Override: POST"
echo "HEAD";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X HEAD -H 'X-Method-Override: HEAD' -H "X-HTTP-Method: HEAD" -H "X-Method-Override: HEAD"
echo "OPTIONS";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X OPTIONS -H 'X-Method-Override: OPTIONS' -H "X-HTTP-Method: OPTIONS" -H "X-Method-Override: OPTIONS"
echo "PATCH";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X PATCH -H 'X-Method-Override: PATCH' -H "X-HTTP-Method: PATCH" -H "X-Method-Override: PATCH"
echo " ==== Mas metodos http!"
echo "ACL";  curl -ks https://$1 -L -H 'accept: json' -H 'User-Agent: Mozilla/5.0' -I  -X ACL -H 'X-Method-Override: ACL' -H "X-HTTP-Method: ACL" -H "X-Method-Override: ACL"
echo "ARBITRARY";  curl -ks https://$1 -L -H 'accept: json' -H 'User-Agent: Mozilla/5.0' -I  -X ARBITRARY
echo "BASELINE-CONTROL";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X BASELINE-CONTROL -H 'X-Method-Override: BASELINE-CONTROL' -H "X-HTTP-Method: BASELINE-CONTROL" -H "X-Method-Override: BASELINE-CONTROL"
echo "BIND";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X BIND  -H 'X-Method-Override: BIND' -H "X-HTTP-Method: BIND" -H "X-Method-Override: BIND"
echo "CHECKIN";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X CHECKIN -H 'X-Method-Override: CHECKIN' -H "X-HTTP-Method: CHECKIN" -H "X-Method-Override: CHECKIN"
echo "CHECKOUT";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X CHECKOUT -H 'X-Method-Override: CHECKOUT' -H "X-HTTP-Method: CHECKOUT" -H "X-Method-Override: CHECKOUT"
echo "CONNECT";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X CONNECT -H 'X-Method-Override: CONNECT' -H "X-HTTP-Method: CONNECT" -H "X-Method-Override: CONNECT"
echo "COPY";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X COPY -H 'X-Method-Override: COPY' -H "X-HTTP-Method: COPY" -H "X-Method-Override: COPY"
echo "INDEX";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X INDEX -H 'X-Method-Override: INDEX' -H "X-HTTP-Method: INDEX" -H "X-Method-Override: INDEX"
echo "LABEL";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X LABEL -H 'X-Method-Override: LABEL' -H "X-HTTP-Method: LABEL" -H "X-Method-Override: LABEL"
echo "LINK";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X LINK -H 'X-Method-Override: LINK' -H "X-HTTP-Method: LINK" -H "X-Method-Override: LINK"
echo "LOCK";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X LOCK -H 'X-Method-Override: LOCK' -H "X-HTTP-Method: LOCK" -H "X-Method-Override: LOCK"
echo "MERGE";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X MERGE -H 'X-Method-Override: MERGE' -H "X-HTTP-Method: MERGE" -H "X-Method-Override: MERGE"
echo "MKACTIVITY";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X MKACTIVITY -H 'X-Method-Override: MKACTIVITY' -H "X-HTTP-Method: MKACTIVITY" -H "X-Method-Override: MKACTIVITY"
echo "MKCALENDAR";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X MKCALENDAR -H 'X-Method-Override: MKCALENDAR' -H "X-HTTP-Method: MKCALENDAR" -H "X-Method-Override: MKCALENDAR"
echo "MKCOL";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X MKCOL -H 'X-Method-Override: MKCOL' -H "X-HTTP-Method: MKCOL" -H "X-Method-Override: MKCOL"
echo "MKREDIRECTREF";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X MKREDIRECTREF -H 'X-Method-Override: MKREDIRECTREF' -H "X-HTTP-Method: MKREDIRECTREF" -H "X-Method-Override: MKREDIRECTREF"
echo "MKWORKSPACE";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X MKWORKSPACE -H 'X-Method-Override: MKWORKSPACE' -H "X-HTTP-Method: MKWORKSPACE" -H "X-Method-Override: MKWORKSPACE"
echo "MOVE";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X MOVE -H 'X-Method-Override: MOVE' -H "X-HTTP-Method: MOVE" -H "X-Method-Override: MOVE"
echo "ORDERPATCH";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X ORDERPATCH  -H 'X-Method-Override: ORDERPATCH' -H "X-HTTP-Method: ORDERPATCH" -H "X-Method-Override: ORDERPATCH"
echo "PRI";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X PRI  -H 'X-Method-Override: PRI' -H "X-HTTP-Method: PRI" -H "X-Method-Override: PRI"
echo "PROPFIND";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X PROPFIND  -H 'X-Method-Override: PROPFIND' -H "X-HTTP-Method: PROPFIND" -H "X-Method-Override: PROPFIND"
echo "PROPPATCH";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X PROPPATCH  -H 'X-Method-Override: PROPPATCH' -H "X-HTTP-Method: PROPPATCH" -H "X-Method-Override: PROPPATCH"
echo "REBIND";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X REBIND  -H 'X-Method-Override: REBIND' -H "X-HTTP-Method: REBIND" -H "X-Method-Override: REBIND"
echo "REPORT";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X REPORT  -H 'X-Method-Override: REPORT' -H "X-HTTP-Method: REPORT" -H "X-Method-Override: REPORT"
echo "SEARCH";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X SEARCH  -H 'X-Method-Override: SEARCH' -H "X-HTTP-Method: SEARCH" -H "X-Method-Override: SEARCH"
echo "SHOWMETHOD";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X SHOWMETHOD  -H 'X-Method-Override: SHOWMETHOD' -H "X-HTTP-Method: SHOWMETHOD" -H "X-Method-Override: SHOWMETHOD"
echo "SPACEJUMP";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X SPACEJUMP  -H 'X-Method-Override: SPACEJUMP' -H "X-HTTP-Method: SPACEJUMP" -H "X-Method-Override: SPACEJUMP"
echo "TEXTSEARCH";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X TEXTSEARCH  -H 'X-Method-Override: TEXTSEARCH' -H "X-HTTP-Method: TEXTSEARCH" -H "X-Method-Override: TEXTSEARCH"
echo "TRACK";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X TRACK  -H 'X-Method-Override: TRACK' -H "X-HTTP-Method: TRACK" -H "X-Method-Override: TRACK"
echo "UNBIND";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X UNBIND  -H 'X-Method-Override: UNBIND' -H "X-HTTP-Method: UNBIND" -H "X-Method-Override: UNBIND"
echo "UNCHECKOUT";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X UNCHECKOUT  -H 'X-Method-Override: UNCHECKOUT' -H "X-HTTP-Method: UNCHECKOUT" -H "X-Method-Override: UNCHECKOUT"
echo "UNLINK";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X UNLINK  -H 'X-Method-Override: UNLINK' -H "X-HTTP-Method: UNLINK" -H "X-Method-Override: UNLINK"
echo "UNLOCK";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X UNLOCK  -H 'X-Method-Override: UNLOCK' -H "X-HTTP-Method: UNLOCK" -H "X-Method-Override: UNLOCK"
echo "UPDATE";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X UPDATE  -H 'X-Method-Override: UPDATE' -H "X-HTTP-Method: UPDATE" -H "X-Method-Override: UPDATE"
echo "UPDATEREDIRECTREF";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X UPDATEREDIRECTREF  -H 'X-Method-Override: UPDATEREDIRECTREF' -H "X-HTTP-Method: UPDATEREDIRECTREF" -H "X-Method-Override: UPDATEREDIRECTREF"
echo "VERSION-CONTROL";  curl -ks https://$1 -L -H 'User-Agent: Mozilla/5.0' -I  -X VERSION-CONTROL  -H 'X-Method-Override: VERSION-CONTROL' -H "X-HTTP-Method: VERSION-CONTROL" -H "X-Method-Override: VERSION-CONTROL"
echo
echo -e "\e[00;32m# SQLi ########################################################\e[00m"
sqlmap -u 'https://$1' --crawl=3 --random-agent --batch --forms --threads=5 --hostname --timeout=15 --retries=1 --time-sec 12
echo
echo -e "\e[00;32m# Vulnerabilidades web con Nikto ########################################################\e[00m"
echo
nikto -Plugins 'cookies' -host https://$1 -C all
nikto -Plugins 'headers' -host https://$1 -C all
nikto -Plugins 'msgs' -host https://$1 -C all
nikto -Plugins 'httpoptions' -host https://$1 -C all
nikto -Plugins 'ssl' -host https://$1 -C all
echo
wapiti -u https://$1
echo
echo
echo -e "\e[00;32m# Escaneo con Nmap de puertos web habituales ########################################################\e[00m"
echo
nmap $1 -Pn -p 80,81,443,4443,7443,8000,8080,8081,8443,8888,9443,10443 --script=http-enum --script=http-security-headers --script=http-methods --script=ssl* --open -sC -O
echo
echo -e "\e[00;32m# Descubre directorios por fuerza bruta ########################################################\e[00m"
echo
echo "Fuzz de: " $1
echo "--- -----------"
echo "Cod Significado"
echo "--- -----------"
echo "200 OK"
echo "301 Movido permamentemente"
echo "302 Encontrado"
echo "304 No modificado"
echo "400 Solicitud incorrecta"
echo "400 No autorizado"
echo "403 Prohibido"
echo "404 No encontrado"
echo "410 Ya no esta disponible"
echo "500 Error interno en el servidor"
echo
dirb  https://$1 diccionario.txt -N 302 204 307 400 401 403 409 500 503 -b -f -w -S -z 99 -a "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" -H "Accept: text/html, applicattion/xhtml+xml, application/xml;q=0.9,*/*;q=0.8"
echo
echo
