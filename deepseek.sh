#!/bin/sh
# Script para ejecutar en local DeepSeek IA

# Comprobar si ollama existe
if command -v ollama >/dev/null 2>&1; then
    echo "Ollama ya está instalado."
else
    echo "Instalando Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

# Intentar arrancar el servicio si existe systemctl
if command -v systemctl >/dev/null 2>&1; then
    if ! systemctl is-active ollama >/dev/null 2>&1; then
        echo "Iniciando servicio Ollama..."
        sudo systemctl start ollama
    fi
fi

echo "Ejecutando DeepSeek-R1:1.5b..."
ollama run deepseek-r1:1.5b
