#!/bin/sh
# Script para DeepSeek IA

if ! command -v ollama &> /dev/null; then
    echo "Instalando Ollama..."
    curl -fsSL https://ollama.com/install.sh | sudo sh
    sudo systemctl start ollama
fi

echo "Ejecutando DeepSeek-R1:1.5b..."
ollama run deepseek-r1:1.5b
