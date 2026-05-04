#!/bin/sh

# Script Bash Shell 1.0.x para ejecutar  en local DeepSeek Coder, con ollana
# ejecuta DeepSeek Coder en CPU (sin GPU NVIDIA)

MODEL="deepseek-coder:6.7b"

if command -v ollama >/dev/null 2>&1; then
    echo "Ollama ya está instalado."
else
    echo "Instalando Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

export OLLAMA_NO_GPU=1

if [ -z "$OLLAMA_NUM_THREADS" ]; then
    OLLAMA_NUM_THREADS=4
    export OLLAMA_NUM_THREADS
fi

if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active ollama >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Iniciando servicio Ollama..."
        sudo systemctl start ollama
    fi
fi

echo "Ejecutando modelo: $MODEL ..."
ollama run "$MODEL"
