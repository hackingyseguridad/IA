#!/bin/sh

# Script Bash Shell 1.0.x para ejecutar en local Claude Code (Anthropic CLI)
# Requiere API key configurada en variable de entorno ANTHROPIC_API_KEY
# 2026 http://www.hackingyseguridad.com/ 
# Ejecuta Claude 3 Haiku o Sonnet (sin necesidad de GPU NVIDIA)
# modelos disponibles sin GPU NVIDIA
#
# claude-3-haiku-20240307                (rápido y económico)
# claude-3-sonnet-20240229               (balance calidad/velocidad)
# claude-3-opus-20240229                 (potente pero más lento)

MODEL="claude-3-haiku-20240307"  # Opciones: haiku, sonnet, opus

# Verificar API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "  Error: ANTHROPIC_API_KEY no está configurada."
    echo "  Por favor, establece tu clave de API de Anthropic:"
    echo "  export ANTHROPIC_API_KEY='tu-api-key-aqui'"
    exit 1
fi

# Configurar límite de tokens (safe para Claude)
if [ -z "$CLAUDE_MAX_TOKENS" ]; then
    CLAUDE_MAX_TOKENS=4096
    export CLAUDE_MAX_TOKENS
fi

# Configurar timeout (en milisegundos)
if [ -z "$CLAUDE_TIMEOUT_MS" ]; then
    CLAUDE_TIMEOUT_MS=60000
    export CLAUDE_TIMEOUT_MS
fi

echo "... conexión a Anthropic API..."
if ! curl -s -o /dev/null -w "%{http_code}" https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" > /dev/null 2>&1; then
    echo " No se pudo contactar con Anthropic API. Revisa tu conexión o API key."
    exit 1
fi

echo " Ejecutando modelo: $MODEL ..."
echo " (Escribe tu prompt. Presiona Ctrl+C para salir)"
echo ""

# Modo interactivo con claude CLI
# Si quieres pasar un prompt directo: echo "Tu pregunta" | claude --model $MODEL
# claude --model  claude-3-haiku-20
claude --model "$MODEL" --interactive
