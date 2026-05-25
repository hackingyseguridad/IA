#!/bin/sh
# requiere 6GB de RAM
# Si se rompe al arrancar porbar con: ollama pull mistral
# ssh -L 0.0.0.0:11434:localhost:11434 -p 22 usuario@IP_Publica
export OLLAMA_MMAP=1
ollama run mistral
