# Aceptación y demostración — Feature 1

Verificación realizada el **6 de octubre de 2026**, con Node.js **24.14.1** en Windows y la interfaz ejecutada en el navegador integrado de Codex.

## Resultado registrado de la versión original

- `npm run check`: sin errores de sintaxis.
- `npm test`: **21 pruebas, 21 aprobadas, 0 fallidas**.
- Pruebas de interfaz realizadas mediante interacción real con formularios, selectores y nodos; no están automatizadas dentro de `npm test`.
- Datos de prueba de navegador separados del catálogo final. La versión original iniciaba con 9 elementos y 9 dependencias. El ejemplo ampliado contiene 38 elementos y 92 dependencias.

## Casos automáticos

| Archivo | Cantidad | Cobertura |
|---|---:|---|
| `tests/catalog.test.js` | 8 | Dirección, tipos, aislamiento, unicidad normalizada, datos inválidos, existencia de extremos, duplicados dirigidos, ciclos, autorrelaciones, copias y catálogo vacío. |
| `tests/store.test.js` | 4 | Reapertura persistente, rechazo sin modificar disco, fallo de guardado sin publicar memoria y protección de archivo corrupto. |
| `tests/api.test.js` | 9 | HTTP real: consulta vacía, creación/listado/conexión, duplicados, extremos ausentes, cuerpos inválidos, límite de tamaño, solicitudes simultáneas, ciclos y rutas/métodos/interfaz. |

Algunas pruebas agrupan varias entradas inválidas dentro del mismo caso. El conteo de 21 corresponde a los casos reportados por el ejecutor, no al número de aserciones.

## Casos de aceptación del enunciado

| ID | Acción | Resultado esperado | Verificación realizada |
|---|---|---|---|
| F1-01 | Registrar elemento con ID, nombre y tipo válidos | HTTP 201; se ve en catálogo y red. | API y formulario: un insumo nuevo apareció en lista, selector y SVG. |
| F1-02 | Repetir un ID, incluso en minúsculas | HTTP 409; no se duplica. | API y formulario: mensaje «Ya existe el identificador». |
| F1-03 | Registrar relación entre dos elementos existentes | HTTP 201; arista requisito → dependiente. | API y formulario: nueva relación reflejada en red y tabla. |
| F1-04 | Registrar el mismo origen y destino otra vez | HTTP 409; se conserva una sola arista. | API y formulario: mensaje de dependencia existente. |
| F1-05 | Referenciar un extremo no registrado | HTTP 404; no se crea una arista parcial. | Prueba API y dominio. El formulario ofrece únicamente elementos existentes. |
| F1-06 | Enviar JSON roto, campos vacíos o un tipo no permitido | HTTP 400; estado intacto. | Pruebas API y dominio. |
| F1-07 | Consultar la red de ejemplo | Nodos, aristas y adyacencia coherentes. | API y navegador: 9 elementos, 9 relaciones. |
| F1-08 | Mantener un elemento sin relaciones | Figura en catálogo y red, con adyacencia vacía. | Tela de tapicería visible como «Sin conexiones»; prueba de dominio. |
| F1-09 | Reabrir el almacén | Conserva elementos y relaciones registrados. | Prueba de persistencia; recarga de página adicional en navegador. |
| F1-10 | Consultar un catálogo vacío y agregar su primer elemento | Estado vacío comprensible; el primer elemento se dibuja. | API y navegador. |
| F1-11 | Registrar un ciclo o una autorrelación | El catálogo lo conserva; no se anuncia un orden válido. | API; autorrelación registrada también desde la interfaz con advertencia previa. |
| F1-12 | Seleccionar un nodo con `Enter` | Resalta sus relaciones directas y muestra sus vecinos. | Navegador: madera mostró proveedor, mesa y estante. |

## Revisión de la interfaz

- Vista de escritorio comprobada con viewport de 1366 × 900.
- Vista estrecha comprobada con viewport de 390 × 844, tanto vacía como con el ejemplo cargado.
- En la vista estrecha, el documento no presentó desbordamiento horizontal; la red conservó su propio desplazamiento horizontal (760 px de contenido dentro de su contenedor).
- No se observaron errores o advertencias de consola durante las interacciones verificadas.
- Se corrigió el ocultamiento del SVG vacío para mostrar únicamente el mensaje de inicio en ese estado.
- Se ajustó el trazado de relaciones dentro de la misma columna para conservarlo dentro del área del dibujo.

La revisión se limita a estos casos y tamaños. No equivale a una auditoría exhaustiva de accesibilidad o a pruebas en todos los navegadores.

## Guion sugerido de demostración, 4–6 minutos

1. **Contexto y orientación (45 s).** Explicar que el catálogo permite registrar requisitos. Mostrar `Maderas del Norte → Tablero de madera → Mesa de trabajo`. Leer una arista con una frase del negocio.
2. **Elementos iniciales (30 s).** Mostrar los tres tipos y el fieltro protector sin conexiones. Explicar que un nodo aislado sigue siendo un elemento válido.
3. **Nuevo elemento (45 s).** Registrar `INS-PEGAMENTO`, nombre «Pegamento para madera», tipo «Insumo». Verificar su aparición. Si ese ID ya fue utilizado, elegir uno nuevo.
4. **Nueva dependencia (45 s).** Elegir el pegamento como requisito y la mesa como dependiente. Leer la frase y registrar. Mostrar la flecha y la fila de la tabla.
5. **Duplicados y entrada inválida (45 s).** Repetir la relación para observar el rechazo. Mostrar una respuesta 400 o 404 con los ejemplos de API que siguen.
6. **API y sustento (45 s).** Abrir Consultar API. Identificar nodos, aristas y lista de adyacencia. Explicar por qué la representación es dirigida y por qué se eligieron listas.
7. **Cierre del alcance (30 s).** Mostrar `npm test`. Aclarar que la consulta de impacto y la detección de ciclos serán las próximas entregas.

## Ejemplos API para demostrar errores

Ejecutar con el servidor encendido y el ejemplo inicial cargado. PowerShell mostrará el error HTTP y su respuesta; esos errores son el resultado esperado. La sintaxis de `Invoke-RestMethod` puede mostrar el cuerpo con distinto formato según la versión de PowerShell.

Elemento inexistente, esperado **404**:

```powershell
$body = @{ origen = 'INS-MADERA'; destino = 'NO-EXISTE' } | ConvertTo-Json
Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/dependencias' -Method Post -ContentType 'application/json' -Body $body
```

Tipo no admitido, esperado **400**:

```powershell
$body = @{ id = 'PRUEBA-ERROR'; nombre = 'Dato de prueba'; tipo = 'desconocido' } | ConvertTo-Json
Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/elementos' -Method Post -ContentType 'application/json' -Body $body
```

Dependencia repetida del ejemplo, esperado **409**:

```powershell
$body = @{ origen = 'INS-MADERA'; destino = 'PROD-MESA' } | ConvertTo-Json
Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/dependencias' -Method Post -ContentType 'application/json' -Body $body
```

Los tres ejemplos deben dejar el catálogo intacto. La suite automática comprueba esa propiedad sin alterar los datos de trabajo.

## Evidencia visual

`vista-catalogo.png` contiene una captura de la aplicación ejecutada con los datos sintéticos iniciales. El dibujo muestra las dependencias almacenadas; no certifica viabilidad ni representa un orden de producción calculado.

## Verificación de la ampliación del catálogo

Se incorporaron 12 productos, 5 proveedores, 12 insumos y 83 dependencias. Se validaron los datos con el modelo del aplicativo, la existencia de extremos, las relaciones proveedor → insumo → producto y la presencia de requisitos en todos los productos. Se comprobó la igualdad entre los datos de la API y el archivo persistido y la conservación de los registros anteriores.

El ejemplo distribuible contiene 38 elementos y 92 relaciones. La instancia local contiene 39 elementos porque conserva el insumo del usuario «Metro 20 M»: 8 proveedores, 17 insumos y 14 productos. En el navegador se verificaron los totales y la selección del banco tapizado con sus siete requisitos directos. Las evidencias y pruebas anteriores corresponden a la versión original; el código funcional no cambió durante esta ampliación.
