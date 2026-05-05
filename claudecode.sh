#!/bin/sh

# https://github.com/hackingyseguridad/IA/
# Script Bash Shell 1.0.x para ejecutar en un directorio de Linux en local Claude Code (Anthropic CLI)
# Requiere API key configurada en variable de entorno ANTHROPIC_API_KEY
#
# Ejecyta Claude 3 Haiku o Sonnet; Modelos disponibles sin GPU NVIDIA; - elige uno:
#
# claude-3-haiku-20240307                (rápido y económico)
# claude-3-sonnet-20240229               (balance calidad/velocidad)
# claude-3-opus-20240229                 (potente pero más lento)
#

MODEL="claude-3-haiku-20240307"  # Opciones: haiku, sonnet, opus

export ANTHROPIC_API_KEY="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"

# Verifica API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "  Error: ANTHROPIC_API_KEY no está configurada."
    echo "  Por favor, establece tu clave de API de Anthropic:"
    echo "  export ANTHROPIC_API_KEY='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'"
    exit 1
fi

# Conf límite de tokens
if [ -z "$CLAUDE_MAX_TOKENS" ]; then
    CLAUDE_MAX_TOKENS=4096
    export CLAUDE_MAX_TOKENS
fi

# Conf timeout en milisegundos
if [ -z "$CLAUDE_TIMEOUT_MS" ]; then
    CLAUDE_TIMEOUT_MS=60000
    export CLAUDE_TIMEOUT_MS
fi

# Claude Code es de pago, hay que iniciar sesion y pagar en https://platform.claude.com/dashboard
# Obtener API Key en https://platform.claude.com/settings/keys
echo "... conectando a Anthropic API...!!!"
if ! curl -s -o /dev/null -w "%{http_code}" https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" > /dev/null 2>&1; then
    echo " No se pudo contactar con Anthropic API. Revisa tu conexión o API key."
    exit 1
fi

echo " Ejecutando modelo: $MODEL ..."
echo " (Escribe tu prompt. Presiona Ctrl+C o teclea quit para salir)"
echo ""

claude --model "$MODEL"

