#!/bin/sh
# (R) hackingyseguridad.com 2026
# Script Bash Shell 1.0.x para ejecutar interface Claude Code, con ollana, impulsado por otro modelo online:cloud
# Tenemos que instalar Ollama
#  curl -fsSL https://ollama.com/install.sh | sh
# Tenemos que instalar primero Claude , con API Gratuita, sin saldo ni inscripcion
#  curl -fsSL https://claude.ai/install.sh | bash
echo
echo "... "
echo
ollama -v
echo " "
cat << 'EOF'
 ██████  ██       █████  ██    ██ ██████  ███████
██       ██      ██   ██ ██    ██ ██   ██ ██
██       ██      ███████ ██    ██ ██   ██ █████
██       ██      ██   ██ ██    ██ ██   ██ ██
 ██████  ███████ ██   ██  ██████  ██████  ███████

 ██████  ██████  ██████  ███████
██       ██   ██ ██   ██ ██
██       ██   ██ ██   ██ █████
██       ██   ██ ██   ██ ██
 ██████  ██████  ██████  ███████
EOF
echo
claude -v
echo
echo "Interface CLAUDE CODE ,  impulsado por otro modelo online:cloud: -- hackingyseguridad.com -- v1.0 "
echo "/"
export LANG=es_US.UTF-8
sleep 3
# Opcion0
# ollama launch claude --config
# escogemos una opcion para ejecutar claude code online o local impulsado

# Opcion1
# Claude Code Impulsado por deepseek-v4-pro:cloud online en la nube !!!
# ollama launch claude --model deepseek-v4-flash:cloud

# Opcion2
# CLaude Code impulsado por Gemma4 online!!!
ollama launch claude --model gemma4:31b-cloud

# Opcion3
# Claude Code impuslado por minimax-m3:cloud
# ollama launch claude --model minimax-m3:cloud

# Opcion4
# ejecuta Claude (sin GPU NVIDIA)
# Claude Code impulsado por Qwen en local PC
# ollama launch claude --model qwen3-coder
