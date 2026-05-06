#!/bin/sh
# (R) hackingyseguridad.com 2026 
# Script para instalar ollama y poder ejecutar en local IA
echo "Instalando herramientas para hacking con IA ... "  
echo "(R) hackingyseguridad.com 2026 "
chmod 777 *
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

echo "..."

