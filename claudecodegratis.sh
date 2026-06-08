#!/bin/sh
# hackingyseguridad.com 2026 
# Script Bash Shell 1.0.x para ejecutar Claude Code, con ollana
# ejecuta Claude (sin GPU NVIDIA)

# ollama launch claude --config
# escogemos una opcion para ejecutar claude code online o local impulsado 


# CLaude Code impulstado por Gemma4 online!!!
ollama launch claude --model gemma4:31b-cloud


ollama launch claude --model qwen3-coder
