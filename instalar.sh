#!/bin/sh
# (R) hackingyseguridad.com 2026 
# Script para instalar ollama y poder ejecutar en local IA
echo "Instalando herramientas para hacking con IA ... "  
echo "(R) hackingyseguridad.com 2026 "
chmod 777 *
apt-get install zstd
echo
# Comprobar si ollama ya esta instalado 
if command -v ollama >/dev/null 2>&1; then
    echo "Ollama ya está instalado ...!"
else
    echo "Instalando Ollama ... "
    curl -fsSL https://ollama.com/install.sh | sh
fi

# Intentar arrancar el servicio si existe systemctl
if command -v systemctl >/dev/null 2>&1; then
    if ! systemctl is-active ollama >/dev/null 2>&1; then
        echo "Iniciando servicio Ollama..."
        sudo systemctl start ollama
    fi
fi

# Intala node.js 
# curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
# apt install -y nodejs

# Instala Cloude CODE
echo "Instalando Claude ..."
uname -a
date
echo
timedatectl set-timezone Europe/Madrid
timedatectl set-local-rtc 0
timedatectl set-local-rtc 1
timedatectl status
apt-get install ntpdate
ntpdate hora.ngn.rima-tde.net
set - timezone
timedatectl status
dpkg --configure -a
apt-get clean
apt-get update
apt-get full-upgrade --fix-missing -y
apt-get dist-upgrade -y
apt-get autoremove -y
apt -y autoclean
apt update
apt -f -y install

curl -fsSL https://claude.ai/install.sh | bash

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc

echo
echo "... actualizando diccionarios ...  (R) 2025 hackingyseguridad.com "
echo
wget https://raw.githubusercontent.com/hackingyseguridad/diccionarios/refs/heads/master/ficheros.txt -q -O diccionario.txt  --inet4-only
wc -l diccionario.txt
echo ".."
echo "..."
wget https://raw.githubusercontent.com/hackingyseguridad/diccionarios/refs/heads/master/ficheros2.txt -q -O diccionario2.txt  --inet4-only
wc -l diccionario2.txt
echo "...."
echo "....."
echo
echo "actualizado !!! "
echo 
df -h

