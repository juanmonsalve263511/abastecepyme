# Catálogo ampliado de muebles

Escenario sintético del Feature 1: **8 proveedores, 16 insumos, 14 productos y 92 dependencias**. Se añadieron 12 productos, 5 proveedores y 12 insumos al ejemplo original.

Las flechas conservan el significado requisito → dependiente. Cada relación expresa una necesidad; no incluye cantidades, costos ni proveedores alternativos. Es una simplificación académica, no una lista industrial exhaustiva de materiales.

## Productos y requisitos directos

| Producto | Identificador | Insumos necesarios |
|---|---|---|
| Mesa de trabajo | PROD-MESA | Tablero de madera, Tornillos, Barniz |
| Estante modular | PROD-ESTANTE | Tablero de madera, Tornillos, Barniz |
| Mesa de comedor | PROD-MESA-COMEDOR | Tablero de madera, Tornillos, Barniz, Patas prefabricadas, Cola para madera |
| Escritorio con cajones | PROD-ESCRITORIO | Tornillos, Tablero melamínico, Tablero contrachapado, Canto de PVC, Correderas para cajones, Tiradores para muebles, Patas prefabricadas |
| Mesa de centro | PROD-MESA-CENTRO | Tablero de madera, Tornillos, Barniz, Patas prefabricadas, Cola para madera |
| Mesa de noche | PROD-MESA-NOCHE | Tornillos, Barniz, Tablero MDF, Tablero contrachapado, Correderas para cajones, Tiradores para muebles, Cola para madera |
| Silla de comedor | PROD-SILLA-COMEDOR | Tablero de madera, Tornillos, Barniz, Cola para madera |
| Banco de recibidor | PROD-BANCO-RECIBIDOR | Tablero de madera, Tornillos, Barniz, Patas prefabricadas, Cola para madera |
| Biblioteca de entrepaños | PROD-BIBLIOTECA | Tornillos, Tablero melamínico, Tablero contrachapado, Canto de PVC, Soportes para entrepaños |
| Armario de dos puertas | PROD-ARMARIO | Tornillos, Tablero melamínico, Tablero contrachapado, Canto de PVC, Bisagras para puertas, Tiradores para muebles |
| Cómoda de cajones | PROD-COMODA | Tornillos, Barniz, Tablero MDF, Tablero contrachapado, Correderas para cajones, Tiradores para muebles, Cola para madera |
| Mueble para televisión | PROD-MUEBLE-TV | Tornillos, Tablero melamínico, Tablero contrachapado, Canto de PVC, Bisagras para puertas, Tiradores para muebles, Patas prefabricadas |
| Zapatero con puertas | PROD-ZAPATERO | Tornillos, Tablero melamínico, Tablero contrachapado, Canto de PVC, Bisagras para puertas, Tiradores para muebles |
| Banco tapizado | PROD-BANCO-TAPIZADO | Tablero de madera, Tornillos, Barniz, Tela de tapicería, Patas prefabricadas, Espuma para tapicería, Cola para madera |

## Proveedores y abastecimiento

| Proveedor | Insumos suministrados |
|---|---|
| Maderas del Norte | Tablero de madera |
| Ferretería Central | Tornillos |
| Acabados Andinos | Barniz |
| Tableros del Valle | Tablero MDF, Tablero melamínico, Tablero contrachapado, Canto de PVC |
| Herrajes del Taller | Bisagras para puertas, Correderas para cajones, Tiradores para muebles, Patas prefabricadas, Soportes para entrepaños |
| Textiles del Hogar | Tela de tapicería |
| Espumas del Centro | Espuma para tapicería |
| Adhesivos para Madera | Cola para madera |

El fieltro protector es un insumo de reserva sin relaciones asignadas y permite demostrar la conservación de nodos aislados. La instancia local también conserva «Metro 20 M», registrado previamente por el usuario; este registro no se incorpora al ejemplo distribuible.
