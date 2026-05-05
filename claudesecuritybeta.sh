#!/bin/sh

# Script  para escanear vulnerabilidades con Claude Security Beta, en la carpeta actual
# ./claudesecuritybeta.sh /ruta/a/escanear
# https://claude.com/pricing/enterprise

MODEL="claude-3-sonnet-20240229"
TARGET_DIR="${1:-.}"

export ANTHROPIC_API_KEY="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"

if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY no configurada"
    echo "export ANTHROPIC_API_KEY='tu-api-key'"
    exit 1
fi

API_URL="https://api.anthropic.com/v1/messages"

echo "Escaneando: $TARGET_DIR"

# Buscar archivos .py, .js, .sh
find "$TARGET_DIR" -type f \( -name "*.py" -o -name "*.js" -o -name "*.sh" \) | head -10 | while read -r file; do
    echo "Analizando: $file"
    content=$(cat "$file" | head -200)

    # Crear JSON manualmente sin jq complejo
    cat > /tmp/scan.json << EOF
{
    "model": "$MODEL",
    "max_tokens": 2000,
    "messages": [{
        "role": "user",
        "content": "Analiza este codigo para vulnerabilidades de seguridad. Responde con JSON: {\"vulnerabilities\": [{\"type\": \"tipo\", \"location\": \"linea\", \"fix\": \"solucion\"}]} Codigo:\n\n$content"
    }]
}
EOF

    curl -s "$API_URL" \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d @/tmp/scan.json | jq -r '.content[0].text'

    echo "---"
done

echo "Escaneo finalizado"
