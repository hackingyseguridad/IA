---
name: pentest-report
description: >
  Usar esta skill siempre que el usuario quiera generar un informe de pruebas de penetración,
  informe técnico de vulnerabilidades, resumen ejecutivo de seguridad, o cualquier documento
  de auditoría ofensiva. Activa cuando se mencionen: hallazgos de pentest, CVE, CVSS,
  vulnerabilidades detectadas, POC realizados, informe de auditoría, recomendaciones de
  remediación, parcheo o hardening. También cuando el usuario proporcione notas de hallazgos
  y pida estructurarlos en informe profesional.
---

# Skill: Informe Profesional de Pentesting

Genera dos documentos a partir de hallazgos de seguridad en bruto:
1. **Informe Técnico** con tabla de vulnerabilidades ordenada por criticidad + remediación detallada
2. **Informe de Pentesting Profesional** con resumen ejecutivo, puntuaciones CVSS y planes de reparación

---

## Flujo de trabajo

### PASO 1 — Recopilar hallazgos

Si el usuario no ha proporcionado hallazgos estructurados, solicitar:
- Nombre/tipo de vulnerabilidad
- Componente o endpoint afectado
- CVE asociado (si existe)
- Evidencia o POC realizado
- Impacto observado

Si los hallazgos ya están en la conversación, extraerlos directamente sin preguntar.

---

### PASO 2 — Tabla maestra de vulnerabilidades

Construir tabla ordenada de **mayor a menor criticidad** (CVSS base score):

| # | Vulnerabilidad | CVE | CVSS | Severidad | Componente | POC Realizado | Estado |
|---|---------------|-----|------|-----------|------------|---------------|--------|
| 1 | ... | CVE-XXXX | 9.8 | Crítica | ... | Sí | Abierta |

**Escala de severidad CVSS v3.1:**
| Rango | Severidad |
|-------|-----------|
| 9.0–10.0 | Crítica |
| 7.0–8.9 | Alta |
| 4.0–6.9 | Media |
| 0.1–3.9 | Baja |
| 0.0 | Informativa |

---

### PASO 3 — Documento A: Informe Técnico

Estructura obligatoria:

```
1. RESUMEN EJECUTIVO (máx. 1 página)
   - Alcance del análisis
   - Hallazgos por severidad (tabla resumen numérica)
   - Riesgo global estimado
   - Top 3 recomendaciones prioritarias

2. TABLA DE VULNERABILIDADES (ordenada CVSS desc.)

3. DETALLE POR HALLAZGO
   Para cada vulnerabilidad:
   a) Descripción técnica
   b) Vector de ataque (CVSS vector string)
   c) Evidencia / POC realizado
   d) Impacto (Confidencialidad / Integridad / Disponibilidad)
   e) REMEDIACIÓN:
      - Parcheo: versión/parche específico
      - Configuración: parámetros exactos a cambiar
      - Workaround temporal (si existe)
      - Referencia: NVD / vendor advisory / CIS Benchmark

4. PLAN DE REMEDIACIÓN PRIORIZADO
   Tabla: Hallazgo | Acción | Responsable | Plazo sugerido | Verificación
```

---

### PASO 4 — Documento B: Informe Profesional de Pentesting

Estructura obligatoria:

```
PORTADA
  - Título: "Informe de Pruebas de Penetración"
  - Cliente / Sistema evaluado
  - Fecha
  - Clasificación: CONFIDENCIAL

1. RESUMEN EJECUTIVO
   - Objetivo del ejercicio
   - Metodología aplicada (PTES / OWASP / NIST)
   - Resultado global: [CRÍTICO / ALTO / MEDIO / BAJO]
   - Cuadro de mando: total hallazgos por severidad
   - Conclusión para dirección (sin tecnicismos)

2. ALCANCE Y METODOLOGÍA
   - Sistemas/IPs/URLs en scope
   - Tipo de test: Caja negra / gris / blanca
   - Fases ejecutadas: Reconocimiento → Escaneo → Explotación → Post-explotación → Reporting

3. HALLAZGOS DETALLADOS
   Para cada vulnerabilidad:
   
   ### [CRÍTICA/ALTA/...] — Nombre Vulnerabilidad
   - CVE: CVE-XXXX-YYYY
   - CVSS v3.1 Score: X.X
   - CVSS Vector: AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
   - Descripción: ...
   - Evidencia técnica: [output de herramienta / captura / payload]
   - Impacto de negocio: ...
   - Plan de reparación:
     * Corto plazo (0–7 días): ...
     * Medio plazo (7–30 días): ...
     * Largo plazo (> 30 días): ...

4. MÉTRICAS Y ESTADÍSTICAS
   - Gráfico de distribución por severidad
   - Tiempo de detección vs. explotación
   - Superficie de ataque identificada

5. CONCLUSIONES Y RECOMENDACIONES ESTRATÉGICAS
   - Postura de seguridad actual
   - Hoja de ruta de mejora
   - Próximas revisiones sugeridas
```

---

## Vectores CVSS v3.1 — Referencia rápida

```
AV: N=Red  A=Adyacente  L=Local  P=Físico
AC: L=Baja  H=Alta
PR: N=Ninguno  L=Bajo  H=Alto
UI: N=Ninguno  R=Requerido
S:  U=Sin cambio  C=Con cambio
C/I/A: N=Ninguno  L=Bajo  H=Alto
```

Calculadora online: https://www.first.org/cvss/calculator/3.1

---

## Plantillas de remediación por tipo

### Inyección SQL
- **Parche**: Actualizar ORM/framework a versión con prepared statements
- **Config**: Deshabilitar mensajes de error detallados en producción
- **Dev**: Usar consultas parametrizadas, validar/escapar toda entrada

### Command Injection
- **Parche**: Eliminar llamadas a `system()`, `exec()`, `shell_exec()`
- **Config**: Aplicar principio de mínimo privilegio al proceso
- **Dev**: Whitelist de caracteres permitidos, evitar shell=True

### XSS (Reflected/Stored)
- **Parche**: Implementar Content Security Policy (CSP)
- **Config**: Cabeceras: `X-XSS-Protection`, `X-Content-Type-Options`
- **Dev**: Encoding de salida contextual, sanitización de entrada

### Path Traversal
- **Parche**: Resolver rutas con `realpath()` y validar contra directorio base
- **Config**: Chroot / jail del proceso de servidor web
- **Dev**: Whitelist de rutas permitidas, nunca concatenar entrada de usuario

### Buffer Overflow
- **Parche**: Recompilar con Stack Canaries, ASLR, DEP/NX habilitado
- **Config**: Activar ASLR en kernel (`sysctl kernel.randomize_va_space=2`)
- **Dev**: Usar `strncpy`/`snprintf`, auditoría con AddressSanitizer

### Credenciales / Fuerza Bruta
- **Config**: Lockout tras N intentos fallidos, MFA obligatorio
- **Config**: Rate limiting en endpoints de autenticación
- **Dev**: bcrypt/Argon2 para almacenamiento de contraseñas

### CVE en servicios de red (e.g., telnetd, SSH)
- **Parche**: Actualizar a versión corregida según advisory oficial
- **Config**: Deshabilitar el servicio vulnerable si no es imprescindible
- **Hardening**: Firewall/ACL para restringir acceso por IP origen

---

## Notas de uso

- Si el usuario no indica CVSS score, estimar basándose en el tipo de vulnerabilidad y contexto
- Usar siempre CVE oficial si existe; si no, indicar "Sin CVE asignado"
- El informe ejecutivo debe ser legible por perfiles no técnicos (dirección, legal)
- El informe técnico debe ser reproducible por otro auditor
- Clasificar siempre los documentos como **CONFIDENCIAL**

