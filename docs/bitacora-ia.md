# Bitácora de asistencia de IA — Feature 1

Fecha: 6 de octubre de 2026. Herramienta: Codex. Alcance: análisis y construcción de la primera entrega del caso AbastecePyme.

## Solicitudes del usuario

1. Analizar el brief completo desde la aplicación práctica de teoría de grafos, considerando entregas parciales.
2. Inicialmente limitarse al análisis y al plan para el Feature 1.
3. Tras revisar el plan, proceder con su ejecución.

## Trabajo realizado con asistencia

- Lectura del brief proporcionado por el usuario.
- Propuesta de dirección requisito → dependiente y listas de adyacencia.
- Implementación de catálogo, API HTTP, persistencia local, interfaz SVG y datos sintéticos.
- Elaboración y ejecución de 21 pruebas automáticas de dominio, persistencia y API.
- Verificación de interacciones reales en el navegador y revisión del estado vacío y de diferentes tamaños de pantalla.
- Preparación de README, trazabilidad de requisitos, casos de aceptación y paquete de entrega.

## Decisiones y límites declarados

Se eligió Node.js sin dependencias externas. Los datos se conservan en un archivo JSON local, con un solo proceso por archivo. Se normalizan ID a mayúsculas. Se admiten ciclos y autorrelaciones para su tratamiento en el Feature 3. No se implementaron recorridos de impacto ni ordenamiento topológico.

La IA produjo el código y los documentos iniciales y ejecutó las comprobaciones registradas. No se atribuye al estudiante una revisión o una ejecución que no haya realizado. No se consultaron fuentes externas para definir requisitos: se trabajó con el brief entregado y las decisiones explícitas del plan.

## Por completar por el equipo antes de entregar

- Integrantes y responsabilidades.
- Revisión personal del código y comprensión del modelo.
- Cambios propios sobre esta versión y su justificación.
- Resultados de la ejecución en el equipo del estudiante.
- Declaración de uso de IA conforme a las reglas del curso.

Esta bitácora se incluye como base para mantener trazabilidad desde la primera entrega; la documentación integral de IA se solicita expresamente en el Feature 4.

## Ampliación solicitada del catálogo

A petición del usuario se añadieron doce productos acordes con un fabricante de muebles, cinco proveedores, doce insumos y 83 relaciones. Se preservaron los registros existentes, incluido «Metro 20 M», y se actualizó el ejemplo distribuible. Se verificaron integridad del grafo, persistencia y consulta en la interfaz. Los nombres de proveedores y las dependencias constituyen un escenario sintético para el taller.
