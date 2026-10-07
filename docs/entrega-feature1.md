# Entrega 1 — Catálogo de dependencias

**Caso:** AbastecePyme. **Fecha:** 6 de octubre de 2026. **Fuente:** `data/05-brief-abastecepyme.md`. **Estado:** implementación local del Feature 1.

Este documento sustenta el diseño realizado. No reemplaza una rúbrica docente ni afirma requisitos que no figuren en el brief.

## 1. Problema y alcance

AbastecePyme necesita relacionar proveedores, insumos y productos para entender de qué depende su operación. El primer paso es disponer de un catálogo consistente y de relaciones interpretables. Sin esa base, los recorridos de impacto y el ordenamiento de producción de las entregas siguientes no tendrían datos confiables.

El Feature 1 entrega registro, listado, validación y visualización. Compras puede registrar los elementos y sus dependencias; producción puede consultar la estructura. No se calcula aún la propagación de una falla ni una secuencia válida de producción.

## 2. Trazabilidad del enunciado

| Exigencia textual del Feature 1 | Solución implementada | Evidencia |
|---|---|---|
| Crear/listar elementos con tipo e identificador único | Catálogo `Map`, POST/GET de elementos y formulario/lista. ID único global. | `src/catalog.js`, `src/server.js`, formulario Nuevo elemento y tabla Elementos registrados. |
| Registrar dependencias solo entre elementos válidos | Se valida formato y existencia de ambos extremos antes de mutar. Selectores construidos a partir del catálogo. | Pruebas de extremo inexistente, errores 400/404. |
| Validar relaciones repetidas y datos mal formados | `Set` por origen, esquema de campos, reglas de ID/nombre/tipo y JSON. | Pruebas de duplicados, solicitudes inválidas y estado intacto. |
| Mostrar la red mediante API e interfaz mínima | GET `/api/grafo`, SVG con flechas y tablas equivalentes. | Red de ejemplo de 9 nodos y 9 aristas; nodos aislados visibles. |
| Justificar dirección y representación principal | Requisito → dependiente, listas de adyacencia. | README y secciones 3–5 de este documento. |

La persistencia, el nombre legible, la normalización, las pruebas de Feature 1 y los materiales de demostración son decisiones de apoyo a la entrega; el brief no los especifica con ese nivel de detalle.

## 3. Formalización

Sea `G = (V, E)` un grafo dirigido no ponderado. Cada `v ∈ V` tiene identificador, nombre y tipo. Una arista `(u, v) ∈ E` significa que `u` es requisito de `v`. No se permiten aristas paralelas idénticas. Los ciclos y lazos están permitidos como datos del catálogo para su análisis posterior.

Esta precisión evita llamar al modelo «DAG» o «grafo simple sin lazos»: la aplicación no garantiza aciclicidad y permite autorrelaciones. El ejemplo inicial sí es acíclico.

El dominio no contiene pesos porque el alcance no define costos, cantidades, tiempos, probabilidades ni capacidades. Tampoco hay una regla de sustitución: las relaciones expresan requisitos necesarios.

## 4. Por qué esta dirección

Se elige `requisito → dependiente`. Por ejemplo, `INS-MADERA → PROD-MESA` permite decir: «Para producir una mesa de trabajo necesito tablero de madera». Su inversa afirmaría una dependencia diferente, que no se deriva de la original.

Se podría utilizar la convención inversa si se documentara y se recorriera de manera coherente. La elegida reduce la adaptación necesaria para el análisis desde una causa hacia sus consecuencias. En una futura consulta hacia los requisitos de un producto se deberán examinar aristas entrantes o construir un índice inverso; no se reinterpretarán arbitrariamente las salientes.

Para el futuro orden topológico, la orientación elegida ubica los requisitos antes de los dependientes. Antes de implementarlo se deberá distinguir la disponibilidad de un proveedor de una operación productiva. La disposición por columnas de la interfaz no constituye ese orden.

## 5. Por qué listas de adyacencia

El catálogo se indexa por ID con `Map`. La red usa otro `Map`, cuyas claves son los mismos ID y cuyos valores son conjuntos `Set` de destinos. Cada vértice obtiene una lista, aunque esté vacía.

| Alternativa | Espacio | Evaluación para el taller |
|---|---|---|
| Matriz de adyacencia | `O(V²)` | Fácil consulta de una pareja; reserva espacio para relaciones ausentes. |
| Lista plana de aristas | `O(V + E)` contando el catálogo | Sencilla para guardar; localizar los vecinos de un nodo requiere recorrer aristas si no hay índice. |
| Listas de adyacencia | `O(V + E)` | Facilita vecinos salientes y futuros recorridos; `Set` controla duplicados por origen. |

Se elige la última. La lista plana en el JSON es un formato de intercambio y persistencia; el modelo activo reconstruye las listas de adyacencia.

La optimización del grafo no implica que toda operación HTTP sea constante: guardar crea una copia completa, valida y serializa. El costo por escritura es lineal en el tamaño del catálogo más el acceso al disco. Este intercambio favorece consistencia y facilidad de explicación en un escenario pequeño.

## 6. Invariantes y consistencia

1. Cada ID identifica exactamente un elemento, después de normalizarlo.
2. Cada elemento tiene un tipo permitido y un nombre válido.
3. Toda arista tiene dos extremos presentes en el catálogo.
4. Cada pareja ordenada se registra a lo sumo una vez.
5. Toda entrada inválida deja intactos el estado persistente y el modelo publicado.
6. Los elementos sin conexiones se conservan en la API y la interfaz.

Para sostener el quinto punto, el almacén opera sobre una copia candidata. Publica el cambio solo después del reemplazo del archivo. También valida el catálogo al cargarlo: los archivos incoherentes no se aceptan silenciosamente.

## 7. Escenario de demostración

Se modela un pequeño fabricante de muebles con tres proveedores, cuatro insumos y dos productos. La madera, los tornillos y el barniz son requisitos compartidos de una mesa y un estante. La tela de tapicería está registrada sin conexiones.

Las nueve aristas iniciales se pueden leer así:

| Requisito | Dependiente | Interpretación |
|---|---|---|
| Maderas del Norte | Tablero de madera | Para disponer de tablero de madera necesito a Maderas del Norte. |
| Ferretería Central | Tornillos | Para disponer de tornillos necesito a Ferretería Central. |
| Acabados Andinos | Barniz | Para disponer de barniz necesito a Acabados Andinos. |
| Tablero de madera | Mesa de trabajo | Para producir una mesa de trabajo necesito tablero de madera. |
| Tablero de madera | Estante modular | Para producir un estante modular necesito tablero de madera. |
| Tornillos | Mesa de trabajo | Para producir una mesa de trabajo necesito tornillos. |
| Tornillos | Estante modular | Para producir un estante modular necesito tornillos. |
| Barniz | Mesa de trabajo | Para producir una mesa de trabajo necesito barniz. |
| Barniz | Estante modular | Para producir un estante modular necesito barniz. |

Es un escenario sintético de dependencias. No representa consumos, existencias ni un plan de fabricación ejecutable.

## 8. Decisiones abiertas para las siguientes entregas

- **Procesos:** confirmar con la rúbrica si deberán ser vértices de tipo propio o si basta la red de productos e insumos.
- **Alternativas:** si aparece el requisito de proveedores sustitutos, será necesario modelar condiciones alternativas; agregar aristas ordinarias no basta.
- **Impacto:** implementar un recorrido propio y explicar qué significa alcanzar un elemento; el resaltado actual muestra solo vecinos directos.
- **Orden y ciclos:** incorporar ordenamiento y una evidencia útil de ciclo. Con ciclos, no presentar un orden como válido. Actualmente no existe un endpoint de ordenamiento.
- **Escala y uso compartido:** si se amplía a múltiples procesos o usuarios, cambiar la persistencia antes de asumir garantías de concurrencia que esta entrega no ofrece.

## 9. Qué debe revisar el estudiante

El equipo debe poder explicar la dirección con una frase del negocio, distinguir listas de adyacencia de la visualización, justificar los casos inválidos y ejecutar las pruebas. También debe revisar los supuestos frente a las instrucciones particulares del docente y completar autoría, integrantes, curso y cualquier requisito de formato que no aparece en el brief.
