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

# Skill: Informe Profesional de Pentesting — hackingyseguridad.com

Genera el informe final de auditoría como documento Word (.docx) con el formato corporativo
oficial de **hackingyseguridad.com**, replicando exactamente la estructura, orden de secciones,
tablas, logotipos y estilo visual del documento de referencia.

---

## Formato corporativo obligatorio

### Logotipo
- **Logo principal**: texto estilizado "Hacking y seguridad.com" en tipografía bold gris oscuro
  - "Hacking" en grande, negrita, gris (#555555)
  - "y seguridad.com" debajo, misma fuente, gris más claro
- **Posición header**: esquina superior derecha en TODAS las páginas (header del documento)
- **Posición portada**: centrado/grande a 1/3 superior de página, con URL http://www.hackingyseguridad.com/
- **URL debajo del logo portada**: enlace azul http://www.hackingyseguridad.com/ centrado
- **Tipografía**: Arial o similar sans-serif

### Paleta de colores
- Texto body: negro (#000000)
- Títulos de sección: negro bold
- Numeración de hallazgos: azul (#2E75B6)
- Severidad CRÍTICA: texto rojo (#C00000)
- Severidad ALTA: fondo o texto naranja (#FF6600)
- Severidad MEDIA: fondo amarillo claro (#FFE699)
- Severidad BAJA: fondo verde claro (#70AD47)
- Severidad INFORMATIVA: fondo gris claro (#F2F2F2)
- Resaltado amarillo en texto: para destacar datos clave en párrafos
- Resaltado naranja: para cifrados o protocolos vulnerables concretos
- Comandos/output técnico: fondo negro (#1E1E1E), texto verde (#00FF00) — estilo terminal Kali

### Márgenes y página
- Tamaño: A4 (11906 × 16838 DXA)
- Márgenes: 1 pulgada en todos los lados (1440 DXA)
- Fuente base: Arial 11pt (22 half-points)
- Texto body: justificado

---

## Flujo de trabajo

### PASO 1 — Recopilar hallazgos

Si el usuario no ha proporcionado hallazgos estructurados, solicitar:
- Nombre/tipo de vulnerabilidad
- Activo/componente afectado (IP, FQDN, API, puerto)
- CVE asociado (si existe)
- Evidencia o POC realizado (output de herramienta)
- Impacto observado

Si los hallazgos ya están en la conversación, extraerlos directamente sin preguntar.

---

### PASO 2 — Tabla maestra de vulnerabilidades

Construir tabla ordenada de **mayor a menor criticidad** (CVSS base score):

| # | Vulnerabilidad | CVE | CVSS | Severidad | Componente | POC Realizado | Estado |
|---|---------------|-----|------|-----------|------------|---------------|--------|
| 1 | ... | CVE-XXXX | 9.8 | Crítica | ... | Sí | Abierta |

**Escala de severidad CVSS v3.1:**
| Rango     | Severidad   | Color en informe              |
|-----------|-------------|-------------------------------|
| 9.0–10.0  | Crítica     | Rojo (#C00000)                |
| 7.0–8.9   | Alta        | Naranja (#FF6600)             |
| 4.0–6.9   | Media       | Amarillo (#FFE699) fondo      |
| 0.1–3.9   | Baja        | Verde (#70AD47)               |
| 0.0       | Informativa | Gris (#F2F2F2)                |

---

### PASO 3 — Orden de secciones del documento Word

La estructura sigue EXACTAMENTE este orden (igual que el documento de referencia):

```
SECCIÓN 1:   PORTADA
SECCIÓN 2:   PÁGINA EN BLANCO (contraportada)
SECCIÓN 3:   ÍNDICE
SECCIÓN 4:   INTRODUCCIÓN
SECCIÓN 5:   DESCRIPCIÓN DE LAS PRUEBAS, AUDITORIA "HACKING ÉTICO"
SECCIÓN 6:   DESCRIPCIÓN PRUEBAS HACKING ÉTICO EN MODALIDAD CAJA NEGRA
SECCIÓN 7:   LISTA DE REVISIONES
SECCIÓN 8:   RESUMEN EJECUTIVO
SECCIÓN 9:   EVIDENCIAS
SECCIÓN N:   HALLAZGOS numerados 1..N (uno por vulnerabilidad)
SECCIÓN FIN: ANEXO
```

---

## Estructura detallada por sección

### PORTADA (página 1)

```
[Header: logo HyS esquina superior derecha]

[Logo grande centrado]:
  "Hacking"          ← negrita, 36pt, gris (#595959)
  "y seguridad.com"  ← negrita, 26pt, gris (#595959)

[URL centrada, azul]:
  http://www.hackingyseguridad.com/

[Título centrado, negrita, grande, azul (#2E75B6)]:
  "Auditoria de seguridad, «hacking ético»
   en modalidad caja negra a [SISTEMA/SCOPE]"

[Imagen/logotipos de los sistemas auditados: centrados]
[Salto de página]
```

### PÁGINA EN BLANCO (página 2)

```
[Header: logo HyS esquina superior derecha]
[Contenido vacío — página de cortesía]
[Salto de página]
```

### ÍNDICE (página 3)

```
ÍNDICE

ÍNDICE .............................................................. 3
INTRODUCCIÓN ........................................................ 4
DESCRIPCION DE LAS PRUEBAS, AUDITORIA "HACKING ETICO": ............. 5
DESCRIPTCION PRUEBAS HACKING ETICO EN MODALIDAD CAJA NEGRA ......... 6
LISTA DE REVISIONES ................................................. 8
RESUMEN EJECUTIVO: .................................................. 9
EVIDENCIAS: ........................................................ 10
1. [NOMBRE HALLAZGO 1] | VULNERABILIDAD GRAVEDAD [NIVEL] ........... 11
2. [NOMBRE HALLAZGO 2] | VULNERABILIDAD GRAVEDAD [NIVEL] ........... 18
...
ANEXO: ............................................................. 32
[Salto de página]
```

Formato: texto en negrita, números de página alineados a la derecha con tab stop.
Construir manualmente (no usar TOC automático de Word para control total del formato).

### INTRODUCCIÓN

```
INTRODUCCIÓN

[Párrafo justificado: objetivo del análisis, modalidad caja negra, scope
(IPs/FQDNs), herramientas de referencia como shodan.io / censys.io]

[Diagrama de flujo]:
  WEB PAGE → INTERNET → API → WEB SERVER → DATABASE
  con flechas REQUEST/RESPONSE — tabla estilizada o imagen

• [FQDN/sistema 1]: [descripción]
• [FQDN/sistema 2]: [descripción]
• [FQDN/sistema N]: [descripción]
```

### DESCRIPCIÓN DE LAS PRUEBAS, AUDITORIA "HACKING ÉTICO"

```
DESCRIPCION DE LAS PRUEBAS, AUDITORIA "HACKING ETICO":

[Descripción de la metodología: técnicas evaluadas, vectores de ataque,
tipos de pruebas aplicadas]

[Tabla comparativa de sistemas/APIs auditados si procede — p.ej. Key API Tools
con columnas por proveedor: AWS / Azure / GCP]
```

### DESCRIPCIÓN PRUEBAS HACKING ÉTICO EN MODALIDAD CAJA NEGRA

```
DESCRIPTCION PRUEBAS HACKING ETICO EN MODALIDAD CAJA NEGRA

FASE 1
1º.- Reconocimiento pasivo y activo.
2º.- Identificación de activos.
3º.- Fingerprinting de servicios.
4º.- Enumeración.
5º.- Detección de vulnerabilidades:
     [lista de vectores evaluados: Fuzzing, Análisis estático/dinámico,
      Escaneo de vulnerabilidades, Autenticación, Autorización, Fuerza Bruta,
      Validación de entrada, Manejo de errores, Encriptación, Gestión de sesiones,
      XSS, CSRF, Inyección SQL, XXE, Control de acceso roto, RCE, DoS, etc.]
     Herramientas: nmap, wapiti, acunetix, nessus, zap OWASP, openvas, nikto, scripts

FASE 2
6º.- Explotación de vulnerabilidades.
7º.- Pentesting. Pruebas de intrusión. Exploit: No aplica / Solo si requerido.
8º.- Pruebas de Estrés: No aplica / Solo si requerido.
9º.- Batería de ataques: No aplica / Solo si requerido.

FASE 3
10ª.- Informes finales con:
      - I. Resumen de las vulnerabilidades detectadas, ordenadas por grado de
           criticidad: (alta, media ó baja-informativa).
      - II. Evidencias y detalle de las pruebas realizadas y datos sobre cada
            una de las vulnerabilidades detectadas o explotadas.
      - III. Cambios de mejora propuestos. Plan de contingencia.
```

### LISTA DE REVISIONES

```
LISTA DE REVISIONES

[Tabla con bordes simples, cabecera en negrita]:

| Número edición | Fecha edición | Apartados revisados | Cambios efectuados | Observaciones |
|----------------|---------------|--------------------|--------------------|---------------|
| 1ª             | DD MMM. AAAA  | [descripción]      |                    |               |
|                |               |                    |                    |               |
[Salto de página]
```

### RESUMEN EJECUTIVO

```
RESUMEN EJECUTIVO:

[Párrafo ejecutivo con la valoración global. Destacar la severidad más
alta detectada con resaltado amarillo (highlight) en el texto.]

Tabla resumen:

| #Ref | Activo | Vulnerabilidad                              | Gravedad    |
|------|--------|---------------------------------------------|-------------|
| 1    | API    | [nombre vulnerabilidad completo]            | Media       | ← celda color amarillo
| 2    | API    | [nombre vulnerabilidad completo]            | Baja        | ← celda color verde
| 3    | API    | [nombre vulnerabilidad completo]            | Informativa | ← celda gris
[Salto de página]
```

Celdas de Gravedad con color de fondo según severidad (ver paleta).

### EVIDENCIAS

```
EVIDENCIAS:

Puertos/servicios en los activos IP:

| #Ref | Activo | Puerto TCP/UDP | Servicio | Fingerprint | Vuln int | Descripción Vuln | Exploit |
|------|--------|----------------|---------|-------------|----------|-----------------|---------|
|  1   |        | 80/TCP         | http    |             |          |                 |         |
|  2   |        | 443 TCP/UDP    | httpd   |             |          |                 |         |
|  3   |        |                |         |             |          |                 |         |
|  4   |        |                |         |             |          |                 |         |
|  5   |        |                |         |             |          |                 |         |

Tecnologías/Fingerprint y versiones utilizadas:
[tabla o lista con banner grabbing / captura de banner obtenida]
```

### HALLAZGOS (secciones numeradas 1..N)

Cada hallazgo ocupa su propia sección con el siguiente formato:

```
[Salto de página]

[N]. [NOMBRE VULNERABILIDAD EN MAYÚSCULAS] | VULNERABILIDAD GRAVEDAD [NIVEL EN MAYÚSCULAS]
     ← título centrado, negrita, azul, Heading 2

[Subtítulo con highlight AMARILLO]:
[Descripción en una línea del contexto específico auditado]

[Párrafo inicial JUSTIFICADO con highlight amarillo describiendo el protocolo/
 tecnología vulnerable y resaltando en naranja los valores/protocolos concretos
 afectados, p.ej. "TLS 1.0 y TLS 1.1 y combinaciones de cifrado «débiles»"]

[Por cada activo/FQDN afectado]:

[FQDN - https://fqdn.ejemplo.com]   ← fondo azul oscuro (#1F4E79), texto blanco, bold

[Output técnico de la herramienta]
← bloque en Courier New 8-9pt, fondo negro (#1E1E1E), texto verde (#00FF00)
   con resaltado en las líneas relevantes (cifrados débiles: naranja/amarillo,
   warnings: amarillo, versiones vulnerables: naranja)

Descripción de la vulnerabilidad:
[Párrafo técnico explicando la causa raíz, CWE si aplica]

Impacto:
[Consecuencias: Confidencialidad / Integridad / Disponibilidad, ataques posibles,
 referencias OWASP/NIST/CVSSv3]

Recomendación / Remediación (Bastionado):
[Acciones concretas con comandos/parámetros exactos]

CVSS v3.1 Score: X.X  |  Vector: AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
CVE: CVE-XXXX-YYYY  (o "Sin CVE asignado")
CWE: CWE-XXX  (si aplica)
Herramientas utilizadas: [lista]
Referencias: [URLs]
```

**Para hallazgos con múltiples activos** (p.ej. GCP + Azure + AWS):
repetir el bloque [FQDN → output terminal] dentro de la misma sección numerada.

### ANEXO

```
ANEXO:

[Evidencias adicionales, capturas de pantalla de herramientas,
 outputs completos, referencias normativas, URLs de referencia,
 datos de configuración complementaria]

Referencias:
[Lista de URLs / advisories / papers relacionados]
```

---

## PASO 4 — Código JavaScript para generar el .docx

Instalar dependencia: `npm install -g docx`

```javascript
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        Header, AlignmentType, HeadingLevel, BorderStyle, WidthType,
        ShadingType, LevelFormat, PageBreak, VerticalAlign } = require('docx');
const fs = require('fs');

// ── PALETA CORPORATIVA ────────────────────────────────────────────────────
const C = {
  negro:       "000000",
  azulHyS:     "2E75B6",
  azulOscuro:  "1F4E79",
  grisLogo:    "595959",
  rojoCritico: "C00000",
  naranja:     "FF6600",
  amarillo:    "FFE699",
  verde:       "70AD47",
  grisInfo:    "F2F2F2",
  blanco:      "FFFFFF",
  terminalBg:  "1E1E1E",
  terminalFg:  "00FF00",
};

// ── HEADER CORPORATIVO (logo esquina superior derecha) ────────────────────
function makeHeader() {
  return new Header({
    children: [
      new Paragraph({
        alignment: AlignmentType.RIGHT,
        children: [
          new TextRun({ text: "Hacking", bold: true, size: 22, color: C.grisLogo, font: "Arial" }),
          new TextRun({ break: 1 }),
          new TextRun({ text: "y seguridad.com", size: 16, color: C.grisLogo, font: "Arial" }),
        ],
      }),
    ],
  });
}

// ── PORTADA ───────────────────────────────────────────────────────────────
function makePortada(tituloInforme) {
  return [
    new Paragraph({ spacing: { before: 2880, after: 240 }, alignment: AlignmentType.CENTER,
      children: [
        new TextRun({ text: "Hacking", bold: true, size: 72, color: C.grisLogo, font: "Arial" }),
        new TextRun({ break: 1 }),
        new TextRun({ text: "y seguridad.com", bold: true, size: 52, color: C.grisLogo, font: "Arial" }),
      ],
    }),
    new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 240, after: 720 },
      children: [new TextRun({ text: "http://www.hackingyseguridad.com/", color: C.azulHyS, size: 20, font: "Arial" })],
    }),
    new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 480, after: 480 },
      children: [new TextRun({ text: tituloInforme, bold: true, size: 48, color: C.azulHyS, font: "Arial" })],
    }),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── PÁGINA EN BLANCO ──────────────────────────────────────────────────────
const paginaBlanco = [
  new Paragraph({ children: [] }),
  new Paragraph({ children: [new PageBreak()] }),
];

// ── ENTRADA DE ÍNDICE ─────────────────────────────────────────────────────
function lineaIndice(texto, pagina) {
  return new Paragraph({
    tabStops: [{ type: "right", position: 9000 }],
    children: [
      new TextRun({ text: texto, bold: true, font: "Arial", size: 20 }),
      new TextRun({ text: `\t${pagina}`, bold: true, font: "Arial", size: 20 }),
    ],
    spacing: { before: 60, after: 60 },
  });
}

// ── CELDA CON COLOR DE SEVERIDAD ─────────────────────────────────────────
function celdaSeveridad(texto, nivel) {
  const fills = { "Crítica": C.rojoCritico, "Alta": C.naranja,
                  "Media": C.amarillo, "Baja": C.verde, "Informativa": C.grisInfo };
  const textColors = { "Crítica": C.blanco, "Alta": C.blanco };
  const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
  return new TableCell({
    borders: { top: border, bottom: border, left: border, right: border },
    shading: { fill: fills[nivel] || C.grisInfo, type: ShadingType.CLEAR },
    width: { size: 1500, type: WidthType.DXA },
    children: [new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: texto, bold: true, font: "Arial", size: 20,
        color: textColors[nivel] || C.negro })],
    })],
  });
}

// ── TABLA RESUMEN EJECUTIVO ───────────────────────────────────────────────
function tablaResumenEjecutivo(hallazgos) {
  const b = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
  const borders = { top: b, bottom: b, left: b, right: b };
  const cel = (t, w, bold=false) => new TableCell({ borders, width: { size: w, type: WidthType.DXA },
    children: [new Paragraph({ children: [new TextRun({ text: t, bold, font: "Arial", size: 20 })] })] });

  return new Table({
    width: { size: 8800, type: WidthType.DXA },
    columnWidths: [800, 1500, 5000, 1500],
    rows: [
      new TableRow({ children: [cel("#Ref",true,800), cel("Activo",true,1500),
                                cel("Vulnerabilidad",true,5000), cel("Gravedad",true,1500)] }),
      ...hallazgos.map(h => new TableRow({ children: [
        cel(String(h.ref), 800), cel(h.activo, 1500),
        cel(h.vulnerabilidad, 5000), celdaSeveridad(h.gravedad, h.gravedad),
      ]})),
    ],
  });
}

// ── TABLA LISTA DE REVISIONES ─────────────────────────────────────────────
function tablaRevisiones(revisiones) {
  const b = { style: BorderStyle.SINGLE, size: 1, color: "000000" };
  const borders = { top: b, bottom: b, left: b, right: b };
  const widths = [1200, 1400, 2400, 2400, 1400];
  const cel = (t, w, bold=false) => new TableCell({ borders, width: { size: w, type: WidthType.DXA },
    children: [new Paragraph({ children: [new TextRun({ text: t, bold, font: "Arial", size: 20 })] })] });

  return new Table({
    width: { size: 8800, type: WidthType.DXA },
    columnWidths: widths,
    rows: [
      new TableRow({ children: [
        cel("Número edición", widths[0], true), cel("Fecha edición", widths[1], true),
        cel("Apartados revisados", widths[2], true), cel("Cambios efectuados", widths[3], true),
        cel("Observaciones", widths[4], true),
      ]}),
      ...revisiones.map(r => new TableRow({ children: [
        cel(r.numero, widths[0]), cel(r.fecha, widths[1]),
        cel(r.apartados, widths[2]), cel(r.cambios, widths[3]),
        cel(r.observaciones, widths[4]),
      ]})),
      // fila vacía final
      new TableRow({ children: widths.map(w => cel("", w)) }),
    ],
  });
}

// ── TABLA EVIDENCIAS ──────────────────────────────────────────────────────
function tablaEvidencias(puertos) {
  const b = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
  const borders = { top: b, bottom: b, left: b, right: b };
  const widths = [600, 900, 1200, 900, 1500, 900, 1900, 900];
  const cel = (t, w, bold=false) => new TableCell({ borders, width: { size: w, type: WidthType.DXA },
    children: [new Paragraph({ children: [new TextRun({ text: t, bold, font: "Arial", size: 16 })] })] });

  return new Table({
    width: { size: 8800, type: WidthType.DXA },
    columnWidths: widths,
    rows: [
      new TableRow({ children: [
        cel("#Ref", widths[0], true), cel("Activo", widths[1], true),
        cel("Puerto TCP/UDP", widths[2], true), cel("Servicio", widths[3], true),
        cel("Fingerprint", widths[4], true), cel("Vuln int", widths[5], true),
        cel("Descripción Vuln", widths[6], true), cel("Exploit", widths[7], true),
      ]}),
      ...puertos.map(p => new TableRow({ children: [
        cel(String(p.ref), widths[0]), cel(p.activo, widths[1]),
        cel(p.puerto, widths[2]), cel(p.servicio, widths[3]),
        cel(p.fingerprint, widths[4]), cel(p.vulnInt, widths[5]),
        cel(p.descVuln, widths[6]), cel(p.exploit, widths[7]),
      ]})),
    ],
  });
}

// ── BLOQUE TERMINAL (output técnico) ──────────────────────────────────────
function bloqueTerminal(lineas) {
  return lineas.map(linea => new Paragraph({
    shading: { fill: C.terminalBg, type: ShadingType.CLEAR },
    spacing: { before: 0, after: 0 },
    children: [new TextRun({ text: linea, font: "Courier New", size: 16, color: C.terminalFg })],
  }));
}

// ── CABECERA ACTIVO EN HALLAZGO (fondo azul oscuro) ──────────────────────
function tituloActivo(texto) {
  return new Paragraph({
    shading: { fill: C.azulOscuro, type: ShadingType.CLEAR },
    spacing: { before: 120, after: 60 },
    children: [new TextRun({ text: texto, bold: true, color: C.blanco, font: "Arial", size: 20 })],
  });
}

// ── SECCIÓN HALLAZGO INDIVIDUAL ───────────────────────────────────────────
// hallazgo: { nombre, gravedad, subtitulo, descripcion, activos:[{fqdn, output:[]}],
//             causaRaiz, impacto, remediacion, cvss, cvssVector, cve, cwe,
//             herramientas:[], referencias:[] }
function seccionHallazgo(numero, h) {
  const titulo = `${numero}. ${h.nombre} | VULNERABILIDAD GRAVEDAD ${h.gravedad.toUpperCase()}`;
  return [
    new Paragraph({ children: [new PageBreak()] }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      heading: HeadingLevel.HEADING_2,
      spacing: { before: 240, after: 120 },
      children: [new TextRun({ text: titulo, bold: true, font: "Arial", size: 28, color: C.azulHyS })],
    }),
    new Paragraph({ spacing: { before: 120, after: 120 },
      children: [new TextRun({ text: h.subtitulo, highlight: "yellow", font: "Arial", size: 20 })],
    }),
    new Paragraph({ alignment: AlignmentType.JUSTIFIED, spacing: { before: 120, after: 240 },
      children: [new TextRun({ text: h.descripcion, font: "Arial", size: 20 })],
    }),
    ...h.activos.flatMap(activo => [
      tituloActivo(activo.fqdn),
      ...bloqueTerminal(activo.output),
    ]),
    new Paragraph({ spacing: { before: 240, after: 60 },
      children: [new TextRun({ text: "Descripción de la vulnerabilidad:", bold: true, font: "Arial", size: 20 })] }),
    new Paragraph({ alignment: AlignmentType.JUSTIFIED, spacing: { before: 60, after: 120 },
      children: [new TextRun({ text: h.causaRaiz, font: "Arial", size: 20 })] }),
    new Paragraph({ spacing: { before: 120, after: 60 },
      children: [new TextRun({ text: "Impacto:", bold: true, font: "Arial", size: 20 })] }),
    new Paragraph({ alignment: AlignmentType.JUSTIFIED, spacing: { before: 60, after: 120 },
      children: [new TextRun({ text: h.impacto, font: "Arial", size: 20 })] }),
    new Paragraph({ spacing: { before: 120, after: 60 },
      children: [new TextRun({ text: "Recomendación / Remediación (Bastionado):", bold: true, font: "Arial", size: 20 })] }),
    new Paragraph({ alignment: AlignmentType.JUSTIFIED, spacing: { before: 60, after: 240 },
      children: [new TextRun({ text: h.remediacion, font: "Arial", size: 20 })] }),
    new Paragraph({ spacing: { before: 120, after: 60 }, children: [
      new TextRun({ text: `CVSS v3.1 Score: ${h.cvss}`, bold: true, font: "Arial", size: 20 }),
      new TextRun({ text: `  |  Vector: ${h.cvssVector}`, font: "Arial", size: 20 }),
    ]}),
    new Paragraph({ children: [new TextRun({ text: `CVE: ${h.cve}`, font: "Arial", size: 20 })] }),
    new Paragraph({ children: [new TextRun({ text: `CWE: ${h.cwe}`, font: "Arial", size: 20 })] }),
    new Paragraph({ children: [new TextRun({ text: `Herramientas: ${h.herramientas.join(", ")}`, font: "Arial", size: 20 })] }),
    new Paragraph({ spacing: { before: 120, after: 60 },
      children: [new TextRun({ text: "Referencias:", bold: true, font: "Arial", size: 20 })] }),
    ...h.referencias.map(r => new Paragraph({
      children: [new TextRun({ text: r, color: C.azulHyS, font: "Arial", size: 20 })],
    })),
  ];
}

// ── CONSTRUCCIÓN DEL DOCUMENTO ────────────────────────────────────────────
// Rellenar estas variables con los datos del engagement:
const TITULO_INFORME = "Auditoria de seguridad, «hacking ético» en modalidad caja negra a [SISTEMA]";
const REVISIONES = [{ numero: "1ª", fecha: "DD MMM. AAAA", apartados: "[descripción]", cambios: "", observaciones: "" }];
const RESUMEN_EJECUTIVO_TEXTO = "El sistema auditado y la infraestructura expuesta a internet presenta...";
const HALLAZGOS_RESUMEN = [
  { ref: 1, activo: "API", vulnerabilidad: "[nombre vulnerabilidad]", gravedad: "Media" },
];
const PUERTOS_EVIDENCIA = [
  { ref: 1, activo: "", puerto: "80/TCP", servicio: "http", fingerprint: "", vulnInt: "", descVuln: "", exploit: "" },
  { ref: 2, activo: "", puerto: "443 TCP/UDP", servicio: "httpd", fingerprint: "", vulnInt: "", descVuln: "", exploit: "" },
];
const HALLAZGOS = [
  {
    nombre: "PROTOCOLOS Y CIFRADOS OFRECIDOS «DEBILES»",
    gravedad: "Media",
    subtitulo: "Combinaciones de cifrados débiles ofrecidas para los sistemas auditados",
    descripcion: "Se detectan protocolos TLS 1.0 y TLS 1.1 y combinaciones de cifrado débiles/vulnerables...",
    activos: [
      { fqdn: "GCP - https://ejemplo.com", output: ["PORT   STATE SERVICE", "443/tcp open  https", "| TLSv1.0:", "| ciphers:", "|   TLS_RSA_WITH_3DES_EDE_CBC_SHA - C"] },
    ],
    causaRaiz: "El servidor acepta protocolos TLS obsoletos (1.0, 1.1) y suites de cifrado débiles...",
    impacto: "Interceptación de tráfico (Man-in-the-Middle), inyección de datos, SWEET32, BEAST...",
    remediacion: "Deshabilitar TLS 1.0 y TLS 1.1. Configurar únicamente TLS 1.2+ con suites seguras:\nnginx: ssl_protocols TLSv1.2 TLSv1.3;\nApache: SSLProtocol -all +TLSv1.2 +TLSv1.3",
    cvss: "5.9",
    cvssVector: "AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:N/A:N",
    cve: "CVE-2011-3389 (BEAST), CVE-2016-2183 (SWEET32)",
    cwe: "CWE-326",
    herramientas: ["nmap", "testssl.sh", "sslscan"],
    referencias: ["https://www.bsi.bund.de/EN/Topics/OwnOrganisation/StandardsAndCriteria/TechnicalGuidelines/tr02102/tr02102_node.html"],
  },
];

const doc = new Document({
  styles: {
    default: { document: { run: { font: "Arial", size: 22, color: C.negro } } },
    paragraphStyles: [
      { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal",
        run: { size: 32, bold: true, font: "Arial", color: C.negro },
        paragraph: { spacing: { before: 360, after: 180 }, outlineLevel: 0 } },
      { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal",
        run: { size: 28, bold: true, font: "Arial", color: C.azulHyS },
        paragraph: { spacing: { before: 240, after: 120 }, outlineLevel: 1 } },
    ],
  },
  numbering: {
    config: [
      { reference: "bullets", levels: [{ level: 0, format: LevelFormat.BULLET, text: "•",
          alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 720, hanging: 360 } } } }] },
    ],
  },
  sections: [{
    properties: {
      page: { size: { width: 11906, height: 16838 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } },
    },
    headers: { default: makeHeader() },
    children: [
      // 1. PORTADA
      ...makePortada(TITULO_INFORME),

      // 2. PÁGINA EN BLANCO
      ...paginaBlanco,

      // 3. ÍNDICE
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "ÍNDICE", bold: true })] }),
      lineaIndice("ÍNDICE", "3"),
      lineaIndice("INTRODUCCIÓN", "4"),
      lineaIndice('DESCRIPCION DE LAS PRUEBAS, AUDITORIA "HACKING ETICO":', "5"),
      lineaIndice("DESCRIPTCION PRUEBAS HACKING ETICO EN MODALIDAD CAJA NEGRA", "6"),
      lineaIndice("LISTA DE REVISIONES", "8"),
      lineaIndice("RESUMEN EJECUTIVO:", "9"),
      lineaIndice("EVIDENCIAS:", "10"),
      // ...lineaIndice para cada hallazgo
      lineaIndice("ANEXO:", "32"),
      new Paragraph({ children: [new PageBreak()] }),

      // 4. INTRODUCCIÓN
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "INTRODUCCIÓN", bold: true })] }),
      new Paragraph({ alignment: AlignmentType.JUSTIFIED, spacing: { before: 120, after: 240 },
        children: [new TextRun({ text: "El presente documento pretende servir de guía y ayuda, para la detección de vulnerabilidades, «hacking ético», en modalidad caja negra, desde internet, sin información previa...", font: "Arial", size: 22 })],
      }),
      new Paragraph({ children: [new PageBreak()] }),

      // 5. DESCRIPCIÓN DE LAS PRUEBAS
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: 'DESCRIPCION DE LAS PRUEBAS, AUDITORIA "HACKING ETICO":', bold: true })] }),
      new Paragraph({ children: [new PageBreak()] }),

      // 6. DESCRIPCIÓN CAJA NEGRA
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "DESCRIPTCION PRUEBAS HACKING ETICO EN MODALIDAD CAJA NEGRA", bold: true })] }),
      new Paragraph({ children: [new PageBreak()] }),

      // 7. LISTA DE REVISIONES
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "LISTA DE REVISIONES", bold: true })] }),
      new Paragraph({ spacing: { before: 240, after: 120 }, children: [] }),
      tablaRevisiones(REVISIONES),
      new Paragraph({ children: [new PageBreak()] }),

      // 8. RESUMEN EJECUTIVO
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "RESUMEN EJECUTIVO:", bold: true })] }),
      new Paragraph({ alignment: AlignmentType.JUSTIFIED, spacing: { before: 120, after: 240 },
        children: [new TextRun({ text: RESUMEN_EJECUTIVO_TEXTO, font: "Arial", size: 22 })],
      }),
      new Paragraph({ spacing: { before: 120, after: 120 },
        children: [new TextRun({ text: "Tabla resumen:", font: "Arial", size: 22 })] }),
      tablaResumenEjecutivo(HALLAZGOS_RESUMEN),
      new Paragraph({ children: [new PageBreak()] }),

      // 9. EVIDENCIAS
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "EVIDENCIAS:", bold: true })] }),
      new Paragraph({ spacing: { before: 120, after: 120 },
        children: [new TextRun({ text: "Puertos/servicios en los activos IP:", font: "Arial", size: 22 })] }),
      tablaEvidencias(PUERTOS_EVIDENCIA),

      // 10..N. HALLAZGOS
      ...HALLAZGOS.flatMap((h, i) => seccionHallazgo(i + 1, h)),

      // ANEXO
      new Paragraph({ children: [new PageBreak()] }),
      new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun({ text: "ANEXO:", bold: true })] }),
      new Paragraph({ children: [new TextRun({ text: "[Evidencias adicionales, capturas, referencias]", font: "Arial", size: 22 })] }),
    ],
  }],
});

Packer.toBuffer(doc).then(buf => {
  fs.writeFileSync("/mnt/user-data/outputs/informe_pentest.docx", buf);
  console.log("✓ informe_pentest.docx generado");
});
```

---

## PASO 5 — Validación del fichero generado

```bash
python /mnt/skills/public/docx/scripts/office/validate.py informe_pentest.docx

# Si falla → desempacar, corregir XML, reempacar
python /mnt/skills/public/docx/scripts/office/unpack.py informe_pentest.docx unpacked/
# [editar unpacked/word/document.xml]
python /mnt/skills/public/docx/scripts/office/pack.py unpacked/ informe_pentest_fixed.docx \
  --original informe_pentest.docx
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

Calculadora: https://www.first.org/cvss/calculator/3.1

---

## Plantillas de remediación (Bastionado) por tipo de vulnerabilidad

### Protocolos TLS/cifrados débiles
- **Bastionado**: Deshabilitar TLS 1.0 y TLS 1.1; forzar TLS 1.2+ con suites seguras
- **Config nginx**: `ssl_protocols TLSv1.2 TLSv1.3; ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:...`
- **Config Apache**: `SSLProtocol -all +TLSv1.2 +TLSv1.3`
- **Referencia**: BSI TR-02102, NIST SP 800-52r2

### Ausencia de cabeceras de seguridad X-Header
- **Bastionado nginx**:
  ```
  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
  add_header X-Frame-Options "SAMEORIGIN" always;
  add_header X-Content-Type-Options "nosniff" always;
  add_header X-XSS-Protection "1; mode=block" always;
  add_header Content-Security-Policy "default-src 'self'" always;
  add_header Referrer-Policy "no-referrer-when-downgrade" always;
  ```
- **Referencia**: OWASP Secure Headers Project

### Certificado wildcard/comodín
- **Remediación**: Emitir certificado específico por FQDN; limitar scope del comodín
- **Config**: Certificate Transparency, HPKP si aplica

### DoS/DDoS
- **Bastionado**: Rate limiting, filtros Ingress/Egress, ACLs, CDN/WAF
- **Config nginx**: `limit_req_zone`, `limit_conn_zone`
- **Config iptables**: `hashlimit`, `connlimit`
- **Referencia**: NIST SP 800-61r2, RFC 5635

### Inyección SQL
- **Bastionado**: Prepared statements; ORM con parámetros; deshabilitar errores detallados en producción
- **Config**: WAF con OWASP Core Rule Set

### Command Injection / RCE
- **Bastionado**: Eliminar `system()`/`exec()`; aplicar mínimo privilegio; chroot/jail

### XSS (Reflected/Stored)
- **Bastionado**: Content Security Policy; encoding de salida contextual; sanitización de entrada

### Path Traversal
- **Bastionado**: `realpath()` con validación contra directorio base; whitelist de rutas

### Fuerza bruta / Credenciales débiles
- **Bastionado**: Lockout tras N intentos; MFA; rate limiting; bcrypt/Argon2

### CVE en servicios de red (SSH, OpenSSL, Apache…)
- **Bastionado**: Actualizar a versión corregida; deshabilitar servicio si no es necesario; ACL por IP

---

## Notas de uso

- Si el usuario no indica CVSS score, estimar basándose en tipo de vulnerabilidad y contexto
- Usar siempre CVE oficial si existe; si no, indicar "Sin CVE asignado"
- El resumen ejecutivo debe ser legible por perfiles no técnicos (dirección, legal, cumplimiento)
- El informe técnico debe ser reproducible por otro auditor
- Clasificar siempre el documento como **CONFIDENCIAL**
- Terminología preferida en castellano:
  - *bastionado* (no "hardening")
  - *fichero* (no "archivo")
  - *captura de banner* (no "banner grabbing")
  - *comodín* (no "wildcard")
  - *auditoría* (no "assessment")
- Idioma del informe: castellano (español de España)
- El logo de hackingyseguridad.com SIEMPRE en el header de todas las páginas
- El output técnico de herramientas: bloques de fuente monoespaciada con fondo oscuro
  (estilo terminal Kali Linux)
- El documento final se entrega en /mnt/user-data/outputs/informe_pentest_[cliente]_[fecha].docx

### Guardar el informe en disco

Guarda el informe en la carpeta: /tmp/ 

en ficheros en formatos: 

- PDF v1.7 
- DOC compatible con Microsoft Word 97-2003
- Rich Text Format v1, ANSI
- Microsoft Word 2007+






