#!/bin/sh

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
               _                     _ _ _   
              | |                   | (_) |  
 __      _____| |__   __ _ _   _  __| |_| |_ 
 \ \ /\ / / _ \ '_ \ / _` | | | |/ _` | | __| 
  \ V  V /  __/ |_) | (_| | |_| | (_| | | |_ 
   \_/\_/ \___|_.__/ \__,_|\__,_|\__,_|_|\__| ver. 1.0
            http://www.hackingyseguridad.con/ 

$$$$$$ $$$$$ $$$$  $$$ $$$$  $$$     $$$$     $$$$$$ $$$$$ $$$$$$$$$ $$$$$$$$$
INFO

if [ -z "$1" ]; then
        printf "${Amarillo}" ; echo
        echo "Test vulnerabilidades web."
        echo "Uso: $0 <URL>"; printf "${Normal}\n"
        exit 0
fi

echo
echo "================================================="
echo "test sobre la url.: $1"
echo "================================================="
echo
echo -e "\e[00;32m# Informacion del host ########################################################\e[00m" 
echo
host $1
echo
curl -Is --http2-prior-knowledge $1 | head -1
echo
echo -e "\e[00;32m# Escaneo con Nmap de puertos web habituales ########################################################\e[00m" 
echo
nmap $1 -Pn -p80,81,443,4443,7443,8000,8080,8081,8443,8888 --script=http-enum --script=http-security-headers --script=http-methods --open -sCV -O
echo
echo -e "\e[00;32m# Escaneo con Nmap de otros puertos  de servicio sensibles ########################################################\e[00m" 
echo
nmap $1 -Pn -sVC -p21,22,23,25,53,139,161,389,554,445,631,966,1023,1433,1521,1723,1080,3306,3389,5900,10000 --open
echo
echo -e "\e[00;32m# Informacion del servidor web ########################################################\e[00m" 
echo
whatweb $1
HEAD $1
curl -I $1
echo
echo -e "\e[00;32m# Escaneo con Uniscan ########################################################\e[00m" 
echo
uniscan -e -u $1
echo
echo -e "\e[00;32m# Detecta firewall o balanceador ########################################################\e[00m" 
echo
lbd $1
echo
echo -e "\e[00;32m# Detecta firewall WAF ########################################################\e[00m" 
echo
wafw00f $1
echo
echo -e "\e[00;32m# Informacion en internet ########################################################\e[00m" 
echo
theharvester -l 50 -b google -d $1
echo
echo
echo -e "\e[00;32m# SQLi ########################################################\e[00m" 
echo
sqlmap -u 'http://$1' --crawl=3 --random-agent --batch --forms --threads=5 --hostname --timeout=15 --retries=1 --time-sec 12
echo
echo -e "\e[00;32m# Busqueda de recursos vulnerables ########################################################\e[00m" 
echo
wget -O temp_aspnet_config_err --tries=1 $1/%7C~.aspx
wget -O temp_wp_check --tries=1 $1/wp-admin
wget -O temp_drp_check --tries=1 $1/user
wget -O temp_joom_check --tries=1 $1/administrator
wget -O temp_aspnet_elmah_axd --tries=1 $1/elmah.axd
echo
echo -e "\e[00;32m# Informacion dominio ########################################################\e[00m" 
echo
dnsrecon -d $1
echo
echo -e "\e[00;32m# Busqyeda de subdominios del dominio ########################################################\e[00m" 
echo
fierce -wordlist xxx -dns $1
fierce -dns $1
dnsmap $1
dnsenum $1
echo
echo -e "\e[00;32m# Vulnerabilidades DNS ########################################################\e[00m" 
echo
dnswalk -d $1.
echo
echo -e "\e[00;32m#Vulnerabilidades SSL########################################################\e[00m" 
echo
nmap -p443 --script ssl-heartbleed -Pn $1
nmap -p443 --script ssl-poodle -Pn $1
nmap -p443 --script ssl-ccs-injection -Pn $1
nmap -p443 --script ssl-enum-ciphers -Pn $1
nmap -p443 --script ssl-dh-params -Pn $1
sslyze --heartbleed $1
sslyze --certinfo=basic $1
sslyze --compression $1
sslyze --reneg $1
sslyze --resum $1
echo
echo -e "\e[00;32m#Vulnerabilidades con Kit Golismero ########################################################\e[00m" 
echo
golismero -e dns_malware scan $1
golismero -e heartbleed scan $1
golismero -e brute_url_predictables scan $1
golismero -e brute_directories scan $1
golismero -e sqlmap scan $1
golismero -e sslscan scan $1
golismero -e zone_transfer scan $1
golismero -e nikto scan $1
golismero -e brute_dns scan $1
echo
echo -e "\e[00;32m# Descubre directorios por fuerza bruta ########################################################\e[00m" 
echo
dirb http://$1 diccionario.txt -M 100,204,307,400,401,403,409,500,503 -f -w  -z 99 -a "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0" -H "Accept: text/html, applicattion/xhtml+xml, application/xml;q=0.9,*/*;q=0.8"
echo
echo -e "\e[00;32m# Vulnerable a XSS ########################################################\e[00m" 
echo
xsser --all=http://$1
echo
echo -e "\e[00;32m#########################################################\e[00m" 
echo
dmitry -e $1
dmitry -s $1
echo
echo -e "\e[00;32m# Vulnerabilidad DAV ########################################################\e[00m" 
echo
davtest -url http://$1
echo
echo -e "\e[00;32m# Vulnerabilidad web ########################################################\e[00m" 
echo
golismero -e fingerprint_web scan $1
echo
echo -e "\e[00;32m Vulnerabilidades con Uniscan #########################################################\e[00m" 
echo
uniscan -w -u $1
uniscan -q -u $1
uniscan -r -u $1
uniscan -s -u $1
uniscan -d -u $1
echo
echo -e "\e[00;32m# Vulnerabilidades web con Nikto ########################################################\e[00m" 
echo
nikto -Plugins 'apache_expect_xss' -host $1
nikto -Plugins 'subdomain' -host $1
nikto -Plugins 'shellshock' -host $1
nikto -Plugins 'cookies' -host $1
nikto -Plugins 'put_del_test' -host $1
nikto -Plugins 'headers' -host $1
nikto -Plugins 'ms10-070' -host $1
nikto -Plugins 'msgs' -host $1
nikto -Plugins 'outdated' -host $1
nikto -Plugins 'httpoptions' -host $1
nikto -Plugins 'cgi' -host $1
nikto -Plugins 'ssl' -host $1
nikto -Plugins 'sitefiles' -host $1
nikto -Plugins 'paths' -host $1
echo
echo -e "\e[00;32m# Analisis con wapiti ########################################################\e[00m" 
wapiti $1 -f txt -o temp_wapiti
echo
echo -e "\e[00;32m# Informacion de registro del dominio ########################################################\e[00m" 
echo
whois $1
echo
