### Guía de Skills para Pentesting con Claude Code

Este documento explica la estructura y el propósito de cada Skill en el repositorio de IA para pentesting. Las Skills permiten a Claude Code ejecutar tareas especializadas de seguridad ofensiva de manera estructurada y reproducible.

###  IA Pentesting Skills (Claude Code)

Este documento describe la estructura de Skills para pentesting utilizada en el proyecto `IA/claude/skills`.

Repositorio base:

https://github.com/hackingyseguridad/IA/tree/main/claude/skills

###  Estructura del proyecto

```

IA/
└── claude/
    ├── README.md
    └── skills/
        ├── recon/
        │   └── SKILL.md       # Reconocimiento y enumeración
        ├── Vuln/
        │   └── SKILL.md       # Detección de vulnerabilidades
        ├── POC/
        │   └── SKILL.md       # Pruebas de concepto
        ├── Exploit/
        │   └── SKILL.md       # Explotación
        └── report/
            └── SKILL.md       # Generación de informes

```

###  Descripción de cada Skill

Cómo usar una Skill en Claude Code (Ejemplos concretos)

| Skill | Comando de uso |
|-------|----------------|
| Principal | `usa la SKILL /home/antonio/IA/claude/README.md` |
| Reconocimiento | `usa la SKILL /home/antonio/IA/claude/skills/recon/SKILL.md` |
| Vulnerabilidades | `usa la SKILL /home/antonio/IA/claude/skills/Vuln/SKILL.md` |
| Pruebas de concepto | `usa la SKILL /home/antonio/IA/claude/skills/POC/SKILL.md` |
| Explotación | `usa la SKILL /home/antonio/IA/claude/skills/Exploit/SKILL.md` |
| Informes | `usa la SKILL /home/antonio/IA/claude/skills/report/SKILL.md` |

Después de cargar la SKILL con el comando usa la SKILL ..., simplemente pídele a Claude que realice la tarea correspondiente en lenguaje natural.

---

### 🤖 Uso de Skills

usa la SKILL /home/antonio/IA/claude/README.md
usa la SKILL /home/antonio/IA/claude/skills/recon/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/Vuln/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/POC/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/Exploit/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/report/SKILL.md

---

### Flujo recomendado

Recon → Vuln → POC → Exploit → Report
