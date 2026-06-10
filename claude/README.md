# Guía de Skills para Pentesting con Claude Code

Este documento explica la estructura y el propósito de cada Skill en el repositorio de IA para pentesting. Las Skills permiten a Claude Code ejecutar tareas especializadas de seguridad ofensiva de manera estructurada y reproducible.

# 🧠 IA Pentesting Skills (Claude)

Este documento describe la estructura de Skills para pentesting utilizada en el proyecto `IA/claude/skills`.

Repositorio base:
https://github.com/hackingyseguridad/IA/tree/main/claude/skills

---

# 📁 Estructura del proyecto

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

---

# 🔍 Descripción de cada Skill

## 🛰️ recon/

Fase de reconocimiento:
- OSINT
- Enumeración de servicios
- Subdominios
- Fingerprinting

Objetivo: recolectar información sin interacción agresiva.

---

## 🛡️ Vuln/

Detección de vulnerabilidades:
- CVEs
- OWASP Top 10
- Configuraciones inseguras
- Servicios expuestos

Objetivo: identificar debilidades.

---

## 💣 POC/

Pruebas de concepto:
- Validación de vulnerabilidades
- Scripts de prueba
- Demostración controlada

Objetivo: confirmar existencia real del fallo.

---

## ⚔️ Exploit/

Explotación:
- RCE
- Escalada de privilegios
- Acceso no autorizado

Objetivo: demostrar impacto real.

---

## 📊 report/

Reportes:
- Documentación técnica
- CVSS
- Evidencias
- Mitigación

Objetivo: comunicación profesional de hallazgos.

---

# 🤖 Uso de Skills

usa la SKILL /home/antonio/IA/claude/README.md
usa la SKILL /home/antonio/IA/claude/skills/recon/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/Vuln/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/POC/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/Exploit/SKILL.md
usa la SKILL /home/antonio/IA/claude/skills/report/SKILL.md

---

# 🔐 Flujo recomendado

Recon → Vuln → POC → Exploit → Report
