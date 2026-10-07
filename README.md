# AbastecePyme — Feature 1

Catálogo de proveedores, insumos, productos y dependencias, con API HTTP, interfaz web, persistencia local y pruebas de aceptación.

**Alcance:** crear y listar elementos; crear y consultar relaciones; validar entradas; visualizar un grafo dirigido. Esta entrega no implementa el análisis de impacto, el ordenamiento de producción ni la detección de ciclos de los Features 2 y 3.

## Inicio rápido

Requiere **Node.js 22 o superior** y un navegador moderno. La entrega fue verificada con Node.js **24.14.1** en Windows. No requiere `npm install`, paquetes externos ni conexión a Internet para funcionar.

1. Extraer el ZIP completo.
2. Abrir una terminal en la carpeta `abastecepyme-feature1`.
3. Ejecutar:

```sh
npm start
```

4. Abrir **http://127.0.0.1:3000**.
5. Detener el servidor con `Ctrl+C` cuando termine la sesión.

En Windows también puede abrir `Iniciar.cmd`. El archivo inicia el servidor y muestra la dirección para abrir en el navegador. Mantenga esa ventana abierta mientras utiliza la aplicación. Si una vista previa de esta entrega ya usa el puerto 3000, utilícela o deténgala antes de iniciar otra instancia.

El primer inicio carga 9 elementos y 9 dependencias sintéticas desde `data/ejemplo.json`. Se guardan en `data/catalogo.json`; los siguientes inicios conservan ese catálogo. El ZIP no incluye datos creados durante las pruebas.

### Otro puerto o archivo de datos

En PowerShell:

```powershell
$env:PORT = '3001'
$env:DATA_FILE = Join-Path $PWD 'data/mi-catalogo.json'
npm start
```

Abra el puerto elegido. Ambas variables son opcionales; `DATA_FILE` se resuelve desde la carpeta de ejecución si se proporciona una ruta relativa. Use archivos de datos diferentes para instancias simultáneas. Una nueva terminal recupera los valores predeterminados si las variables solo se definieron en la sesión anterior.

### Volver al ejemplo sin perder los datos registrados

Detenga el servidor. Mueva `data/catalogo.json` a un archivo de respaldo con un nombre nuevo, por ejemplo `data/catalogo-respaldo-01.json`. Al reiniciar se crea un catálogo nuevo a partir de `data/ejemplo.json`. No reemplace un respaldo existente. Los datos de demostración y las pruebas están separados.

## Uso de la interfaz

1. En **Nuevo elemento**, seleccione el tipo, escriba un identificador y un nombre.
2. En **Nueva dependencia**, seleccione primero el requisito y luego el elemento que depende de él.
3. Lea la frase de confirmación semántica antes de registrar la relación.
4. Revise las flechas y las tablas. Active un nodo con un clic o con `Enter`/espacio para resaltar exclusivamente sus conexiones directas.
5. Use **Actualizar** para cargar cambios registrados desde otro cliente de la API.

La red se agrupa visualmente por tipo, **no por orden de producción**. En pantallas pequeñas el diagrama tiene desplazamiento horizontal; las tablas ofrecen los nombres e identificadores completos. Un elemento puede existir sin aristas y se muestra como «Sin conexiones».

## Modelo de grafos y significado de las relaciones

Se utiliza un grafo dirigido `G = (V, E)`. Cada vértice representa un elemento identificado de manera única. Cada arista `(u, v)` significa:

> **u es un requisito necesario para v: requisito → dependiente.**

Ejemplo:

```text
Maderas del Norte → Tablero de madera → Mesa de trabajo
```

«Para producir una mesa de trabajo necesito tablero de madera». En el caso del proveedor, «Para disponer de tablero de madera necesito a Maderas del Norte» expresa una dependencia de abastecimiento, no que se fabrique un proveedor.

La dirección es necesaria porque invertir la relación cambia su significado. Que la mesa necesite madera no significa que la madera necesite una mesa.

En el futuro, seguir aristas salientes desde un requisito permitirá explorar sus consecuencias (Feature 2). Para un grafo sin ciclos, un orden topológico de esta orientación situará los requisitos antes de sus dependientes (Feature 3). Estas funciones todavía no se ejecutan en esta entrega. La presencia de proveedores en ese futuro orden indicará disponibilidad previa, no una tarea de fabricar al proveedor.

### Representación principal

El modelo en memoria utiliza:

```text
Map<id, {id, nombre, tipo}>        catálogo de vértices
Map<id, Set<idDependiente>>        listas de adyacencia salientes
```

Ejemplo parcial:

```json
{
  "PROV-MADERA": ["INS-MADERA"],
  "INS-MADERA": ["PROD-MESA", "PROD-ESTANTE"],
  "PROD-MESA": [],
  "INS-TELA": []
}
```

Las listas de adyacencia ocupan `O(|V| + |E|)` y permiten iterar directamente sobre los dependientes de un elemento. Una matriz de adyacencia usaría `O(|V|²)`, aunque hubiera pocas relaciones. `Set` evita aristas paralelas repetidas entre la misma pareja ordenada. En el modelo, consultar la existencia de un ID o una arista tiene costo esperado constante; exportar el grafo cuesta `O(|V| + |E|)`.

El archivo JSON contiene listas de elementos y dependencias por legibilidad y portabilidad. Al cargarlo se reconstruyen las listas de adyacencia. El archivo no sustituye la representación principal del grafo.

**Costo real de una escritura persistente:** se copia y valida un candidato completo, se serializa y se guarda antes de publicar el estado nuevo. Por ello, cada escritura cuesta `O(|V| + |E|)` más la entrada/salida a disco, aunque insertar en `Map` o `Set` sea una operación de costo esperado constante. Es una decisión deliberada para un taller con pocos datos.

### Reglas y supuestos explícitos

- Tipos: `proveedor`, `insumo` y `producto`. Los procesos se mencionan en el contexto, pero no se incorporan como cuarto tipo en este Feature 1.
- ID: de 2 a 40 caracteres; primera posición una letra; letras ASCII, números, guion o guion bajo. Se recortan espacios exteriores y se convierten a mayúsculas. La unicidad es global, sin importar el tipo.
- Nombre: de 2 a 80 caracteres después de recortar espacios exteriores, sin caracteres de control. Dos elementos pueden tener igual nombre y distintos ID.
- Tipo: se recortan espacios exteriores y se convierte a minúsculas antes de validar.
- Los dos extremos deben estar registrados. El orden de la pareja importa: `A → B` y `B → A` son relaciones distintas.
- No se impone una jerarquía de tipos. Pueden existir requisitos del mismo tipo o productos intermedios. El usuario debe justificar su significado; no basta con que la API acepte la relación para que tenga sentido operativo.
- Se admiten ciclos y autorrelaciones como configuraciones que el Feature 3 deberá analizar. La interfaz advierte sobre una autorrelación antes del registro. **Aceptar el dato no certifica que la producción sea viable.**
- Las aristas no tienen peso, cantidades, costos ni tiempos. No hay aristas paralelas idénticas.
- Todas las dependencias registradas se interpretan como necesarias. No se representan sustitutos ni condiciones «B o C». Dos proveedores conectados a un mismo insumo significarían dos requisitos, no alternativas intercambiables.

## API

Todas las respuestas son JSON, salvo los archivos de la interfaz. Los `POST` requieren `Content-Type: application/json`, un objeto con los campos indicados y un máximo de 16 KB. Los campos adicionales se rechazan para detectar errores de escritura.

| Método y ruta | Entrada | Respuesta correcta |
|---|---|---|
| `GET /api/elementos` | — | `200 {elementos: [...], total: n}` |
| `POST /api/elementos` | `id`, `nombre`, `tipo` | `201 {elemento: {...}}` |
| `GET /api/dependencias` | — | `200 {dependencias: [...], total: n}` |
| `POST /api/dependencias` | `origen`, `destino` | `201 {dependencia: {...}}` |
| `GET /api/grafo` | — | `200 {direccion, nodos, aristas, adyacencia}` |

Crear un insumo en PowerShell:

```powershell
$elemento = @{ id = 'INS-PEGAMENTO'; nombre = 'Pegamento para madera'; tipo = 'insumo' } | ConvertTo-Json
Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/elementos' -Method Post -ContentType 'application/json; charset=utf-8' -Body ([System.Text.Encoding]::UTF8.GetBytes($elemento))
```

Conectarlo a un producto incluido en el ejemplo:

```powershell
$dependencia = @{ origen = 'INS-PEGAMENTO'; destino = 'PROD-MESA' } | ConvertTo-Json
Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/dependencias' -Method Post -ContentType 'application/json' -Body $dependencia
Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/grafo' | ConvertTo-Json -Depth 10
```

Las operaciones de estos ejemplos modifican el catálogo. Una segunda ejecución del mismo registro devuelve un conflicto de duplicado.

### Errores

Formato uniforme:

```json
{
  "error": {
    "codigo": "DEPENDENCIA_DUPLICADA",
    "mensaje": "La dependencia INS-MADERA → PROD-MESA ya existe."
  }
}
```

| HTTP | Situación |
|---|---|
| 400 | JSON roto, campos faltantes, datos mal formados, ID/nombre/tipo inválido o campos adicionales. |
| 403 | Una página de otro origen intenta escribir en esta aplicación. |
| 404 | Un extremo no existe o se solicita una ruta inexistente. |
| 405 | Método no admitido; la cabecera `Allow` indica los permitidos en la ruta API. |
| 409 | ID o pareja dirigida ya registrados. |
| 413 | Cuerpo mayor que 16 KB. |
| 415 | Tipo de contenido diferente de JSON. |
| 500 | Error interno, por ejemplo un fallo de disco; la operación no se publica en memoria. |

## Persistencia y límites

Cada escritura construye un candidato independiente, lo valida, lo escribe en un archivo temporal del mismo directorio y reemplaza el archivo anterior. La memoria se actualiza únicamente tras el guardado. El proceso atiende estas operaciones de forma síncrona para evitar escrituras intercaladas dentro de una misma instancia.

La aplicación está pensada para una demostración local, con pocos elementos y **un único proceso por archivo**. No ofrece bloqueo entre procesos, base de datos multiusuario, autenticación, inventario, compras, facturación ni pronósticos. Un fallo abrupto del sistema operativo o disco no tiene las garantías transaccionales de una base de datos. Un archivo corrupto detiene el inicio sin sobrescribirlo con ejemplos.

## Verificación

```sh
npm run check
npm test
```

- `check`: comprueba la sintaxis de los módulos del servidor y del navegador.
- `test`: ejecuta **21 pruebas automáticas** de dominio, persistencia y HTTP real, con archivos temporales y puertos asignados por el sistema. No modifica su catálogo de trabajo.
- La comprobación visual del navegador se documenta en `docs/aceptacion.md`; no se presenta como una suite automática de interfaz.

## Archivos de la entrega

```text
src/catalog.js               Modelo del grafo y reglas de validación
src/store.js                 Carga y guardado local
src/server.js                API y servidor de la interfaz
public/index.html            Formularios, red y tablas
public/app.js                Conexión con la API y dibujo SVG
public/styles.css            Presentación adaptable
data/ejemplo.json             Escenario sintético inicial
data/05-brief-abastecepyme.md  Enunciado original de referencia
tests/                       21 pruebas y utilidades
docs/entrega-feature1.md      Justificación y trazabilidad académica
docs/aceptacion.md            Casos de aceptación y guion de demostración
docs/bitacora-ia.md           Registro de asistencia de IA de esta entrega
Iniciar.cmd                  Inicio en Windows
```

El software, sus decisiones y los resultados deben ser revisados por el estudiante antes de presentarlos. La bitácora identifica qué se elaboró con asistencia de IA y qué debe completar personalmente el equipo.
