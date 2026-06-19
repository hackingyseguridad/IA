## Claude Fable 5 — System Prompt cómo aplicarlo

El system prompt completo (1.585 líneas / aprox. 120K caracteres) de Claude Fable 5, que Anthropic lanzó el 2026-06-09 y retiró por completo el 2026-06-12 debido a las directrices de control de exportaciones de Estados Unidos. El modelo se retiró, pero el prompt permanece. Se puede recrear el comportamiento de Fable 5 simplemente aplicando este prompt sobre el mismo modelo (por ejemplo, Opus 4.8).

Enlace original: https://github.com/elder-plinius/CL4R1T4S/blob/main/ANTHROPIC/CLAUDE-FABLE-5.md

Enlace raw: https://raw.githubusercontent.com/elder-plinius/CL4R1T4S/main/ANTHROPIC/CLAUDE-FABLE-5.md

Aplicación rápida (una sola vez)

bash

claude --dangerously-skip-permissions --system-prompt-file CLAUDE-FABLE-5.md

--system-prompt-file reemplaza el system prompt predeterminado con este archivo. El modelo sigue siendo el mismo, solo el comportamiento cambia al estilo Fable 


Registrar el comando dedicado fable

macOS / Linux (zsh·bash)

bash

### 1) Guardar el prompt
mkdir -p ~/.claude

curl -fsSL https://raw.githubusercontent.com/elder-plinius/CL4R1T4S/main/ANTHROPIC/CLAUDE-FABLE-5.md \   -o ~/.claude/CLAUDE-FABLE-5.md

### 2) Añadir a ~/.zshrc (o ~/.bashrc)

alias fable='claude --dangerously-skip-permissions --system-prompt-file ~/.claude/CLAUDE-FABLE-5.md'

### 3) Recargar el shell

source ~/.zshrc        # si usas bash: source ~/.bashrc

Windows (PowerShell)

powershell

### 1) Guardar el prompt

New-Item -ItemType Directory -Force "$HOME\.claude" | Out-Null

Invoke-WebRequest https://raw.githubusercontent.com/elder-plinius/CL4R1T4S/main/ANTHROPIC/CLAUDE-FABLE-5.md ` -OutFile "$HOME\.claude\CLAUDE-FABLE-5.md"

### 2) Añadir la función a $PROFILE

function fable { claude --dangerously-skip-permissions --system-prompt-file "$HOME\.claude\CLAUDE-FABLE-5.md" @args }

### 3) Recargar el perfil

. $PROFILE

Uso

bash

fable                  # Inicia con el prompt de Fable 5

fable -c               # Continúa (continue)
fable "refactoriza esto"    # Pasa el argumento directamente



