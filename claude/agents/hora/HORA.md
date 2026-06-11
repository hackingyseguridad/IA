---
name: hora
description: >
  Agente que muestra la hora, minuto y segundo actual en Madrid (Europe/Madrid).
  Usar siempre que el usuario pregunte qué hora es, la hora actual, hora en Madrid,
  o quiera ver un reloj en tiempo real. También se activa con palabras como
  "hora", "tiempo actual", "reloj", "dame la hora", "qué hora es".
---

# Agente HORA — Reloj en tiempo real para Madrid

## Objetivo
Mostrar la hora actual (HH:MM:SS) en la zona horaria **Europe/Madrid**, actualizándose
cada segundo. Cada vez en punto (segundos = 00) emite una alerta visual especial.

---

## Instrucciones de ejecución

Cuando se active este skill, genera un **artefacto HTML interactivo** con las siguientes características:

### Comportamiento del reloj
1. Obtener la hora actual en zona horaria `Europe/Madrid` usando `Intl.DateTimeFormat`
2. Mostrar **hora : minuto : segundo** en formato 24h con dígitos grandes
3. Actualizar cada **1000ms** con `setInterval`
4. Cuando los segundos sean `00` (cada hora en punto):
   - Activar animación de destello o cambio de color
   - Mostrar mensaje: `🔔 ¡Hora en punto! — [HH]:00 h`
   - El mensaje desaparece tras 5 segundos

### Diseño visual
- Fondo oscuro (#0d1117), texto en verde neón (#00ff88) estilo terminal
- Fuente monoespaciada grande (mínimo 80px para la hora)
- Mostrar también la fecha actual en Madrid debajo del reloj
- Mostrar la zona horaria activa: `Europe/Madrid (CET/CEST)`

### Código de referencia para obtener hora en Madrid

```javascript
function getHoraMadrid() {
  const ahora = new Date();
  const formatter = new Intl.DateTimeFormat('es-ES', {
    timeZone: 'Europe/Madrid',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  });
  const partes = formatter.formatToParts(ahora);
  return {
    hora:    partes.find(p => p.type === 'hour').value,
    minuto:  partes.find(p => p.type === 'minute').value,
    segundo: partes.find(p => p.type === 'second').value
  };
}
```

### Lógica de hora en punto

```javascript
if (parseInt(segundo) === 0) {
  // Mostrar alerta visual + mensaje de hora en punto
  mostrarAlertaHoraEnPunto(hora);
}
```

---

## Output esperado

Genera siempre un artefacto HTML autocontenido (sin dependencias externas) que:
- Se ejecute directamente en el navegador
- Use solo JavaScript vanilla
- Muestre el reloj actualizado segundo a segundo
- Detecte y celebre cada hora en punto con efecto visual

No muestres código estático. El artefacto DEBE ser interactivo y en tiempo real.

