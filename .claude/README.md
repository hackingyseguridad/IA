### Guía de Skills para Pentesting con Claude Code

Este documento explica la estructura y el propósito de cada Skill en el repositorio de IA para pentesting. Las Skills establecen las premisas que permiten a Claude Code ejecutar tareas especializadas de seguridad ofensiva, con unas especificaciones muy concretas en cada caso, de manera estructurada y reproducible.

### Skills de Claude Code

Las Skills son especificaciones ampliadas o información adicional que se dota a la IA. Hay dos tipos:

| Tipo | Descripción |
|---|---|
| **Skills de capacidad** | Tarea específica y concreta |
| **Skills secuenciales** | Automatización encadenada de pasos |

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

### 🤖 Descripción de cada Skill y uso

Cómo usar una Skill en Claude Code (Ejemplos concretos)

| Skill | Comando de uso y ruta en local donde esta la SKILL |
|-------|----------------|
| Principal | `usa la SKILL /home/antonio/IA/CLAUDE.md` |
| Reconocimiento | `usa la SKILL /home/antonio/IA/claude/skills/recon/SKILL.md` |
| Vulnerabilidades | `usa la SKILL /home/antonio/IA/claude/skills/Vuln/SKILL.md` |
| Pruebas de concepto | `usa la SKILL /home/antonio/IA/claude/skills/POC/SKILL.md` |
| Explotación | `usa la SKILL /home/antonio/IA/claude/skills/Exploit/SKILL.md` |
| Informes | `usa la SKILL /home/antonio/IA/claude/skills/report/SKILL.md` |

Después de cargar la SKILL con el comando usa la SKILL ...,  pídele a Claude que realice la tarea correspondiente en lenguaje natural.

---

### Flujo recomendado

Recon → Vuln → POC → Exploit → Report

---

http://www.hackingyseguridad.com/

----



