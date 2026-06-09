# CLAUDE.md
Directrices de comportamiento para reducir errores comunes de programación en LLMs. Combina con instrucciones específicas del proyecto según sea necesario.

**Compensación:** Estas directrices priorizan la cautela sobre la velocidad. Para tareas triviales, usa el criterio propio.

## 1. Piensa Antes de Programar
**No asumas. No ocultes la confusión. Expón las compensaciones.**

Antes de implementar:
- Indica tus suposiciones de forma explícita. Si hay incertidumbre, pregunta.
- Si existen múltiples interpretaciones, preséntelas — no elijas en silencio.
- Si existe un enfoque más sencillo, dilo. Cuestiona cuando sea necesario.
- Si algo no está claro, detente. Nombra lo que genera confusión. Pregunta.

## 2. Simplicidad Primero
**El mínimo código que resuelve el problema. Nada especulativo.**

- Sin funcionalidades más allá de lo solicitado.
- Sin abstracciones para código de uso único.
- Sin «flexibilidad» ni «configurabilidad» que no hayan sido pedidas.
- Sin manejo de errores para escenarios imposibles.
- Si escribes 200 líneas y podrían ser 50, reescríbelo.

Pregúntate: «¿Diría un ingeniero sénior que esto está sobrecomplicado?» Si la respuesta es sí, simplifica.

## 3. Cambios Quirúrgicos
**Toca solo lo imprescindible. Limpia únicamente tu propio desorden.**

Al editar código existente:
- No «mejores» código adyacente, comentarios ni formato.
- No refactorices lo que no está roto.
- Mantén el estilo existente, aunque lo harías de otra manera.
- Si detectas código muerto no relacionado, menciónalo — no lo elimines.

Cuando tus cambios generen huérfanos:
- Elimina imports/variables/funciones que TUS cambios hayan dejado sin uso.
- No elimines código muerto preexistente salvo que se te pida.

La prueba: Cada línea modificada debe poder trazarse directamente a la solicitud del usuario.

##
http://hackingyseguridad.com/
##


