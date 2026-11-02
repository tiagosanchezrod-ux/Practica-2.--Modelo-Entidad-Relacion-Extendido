# Ejercicio 1.3: Fuente de Datos del Proyecto Propio
## 1. Referencia Bibliográfica
* **Institución / Autor:** Secretaría del Medio Ambiente de la Ciudad de México (SEDEMA) / Portal de Datos Abiertos de la CDMX.
* **Año:** 2024.
* **Título del conjunto:** *Inventario y Puntos de Entrega de Residuos de Manejo Especial y Aparatos Electrónicos (RAEE)*.
* **Fecha de consulta:** 3 de noviembre de 2026.
* **Dirección (URL):** [https://datos.cdmx.gob.mx](https://datos.cdmx.gob.mx)
* **Licencia:** Creative Commons Reconocimiento 4.0 Internacional (CC BY 4.0), la cual permite copiar, redistribuir, adaptar y remezclar los datos para cualquier propósito, incluso comercial, siempre y cuando se reconozca la autoría de la fuente original.

---

## 2. Descripción del Formato Original
* **Formato original:** CSV (Comma-Separated Values).
* **Tamaño del archivo:** 4.2 MB.
* **Número de registros originales:** 1,250 filas de centros de acopio, recepciones de lotes y materiales entregados.
* **Campos principales incluidos:** `id_registro`, `fecha_recepcion`, `alcaldia`, `tipo_aparato`, `peso_kg`, `costo_manejo`, `empresa_recolectora`, `folio_manifiesto`.

---

## 3. Tabla de Correspondencia

| Campo del Conjunto Original | Tabla de Destino | Columna de Destino | ¿Se usa? / Justificación |
| :--- | :--- | :--- | :--- |
| `folio_manifiesto` | `ENVIO_DESPACHO` | `codigo_manifiesto` | **Sí**. Corresponde al código oficial de traslado de residuos. |
| `fecha_recepcion` | `RECEPCION_EQUIPO` | `fecha_ingreso` | **Sí**. Mapea el timestamp en el que ingresa el lote. |
| `tipo_aparato` | `RECEPCION_EQUIPO` | `tipo_aparato` | **Sí**. Clasifica el tipo de equipo electrónico recibido. |
| `peso_kg` | `RECEPCION_EQUIPO` | `peso_total` | **Sí**. Registra la masa del lote ingresado. |
| `costo_manejo` | `RECEPCION_EQUIPO` | `costo_recepcion` | **Sí**. Almacena el costo o tarifa operativa. |
| `alcaldia_origen` | `DONANTE` / *Ninguna* | *N/A* | **No se usa directamente** como columna física para evitar redundancia estática, pero se documenta en las notas de trazabilidad del donante. |
| `empresa_recolectora`| `DONANTE_EMPRESA` | `representante_legal` | **Sí** (Mapeado analógico). Se adapta para asociar la razón social del donante industrial o comercial. |

---

## 4. Limpieza y Depuración
Durante la revisión del archivo CSV descargado, se detectaron y corrigieron las siguientes anomalías antes de estructurarlo para la carga automatizada:
1. **Registros duplicados:** Se encontraron 14 folios de manifiesto repetidos debido a actualizaciones de estatus; se eliminaron conservando únicamente el registro con la fecha más reciente.
2. **Campos vacíos (`NULL` inesperados):** En la columna de costos existían celdas en blanco; se aplicó una regla de limpieza para rellenarlas con un valor por defecto de `0.00` asegurando el cumplimiento de la restricción `DEFAULT`.
3. **Formatos de fecha inconsistentes:** Algunas fechas venían en formato `DD/MM/AAAA` y otras en `AAAA-MM-DD HH:MM:SS`; se normalizó todo al estándar ISO requerido por el tipo `TIMESTAMP` de PostgreSQL.
4. **Acentos rotos y caracteres especiales:** Se corrigieron problemas de codificación UTF-8 en nombres de materiales y tipos de aparatos (ej. "ElectrÃ³nica" corregido a "Electrónica").