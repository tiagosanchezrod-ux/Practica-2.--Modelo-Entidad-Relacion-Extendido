# Ejercicio 2.5: Integridad Referencial en el Almacén Asignado

## 1. Identificación del Modelo Multidimensional (Tabla de Hechos, Dimensiones y Granularidad)

* **Tabla de Hechos:** `hechos_recepcion_despacho` (o `hechos_donaciones`)
* **Dimensiones asociadas:**
  * `dim_tiempo` (año, mes, día, trimestre)
  * `dim_planta` (nombre_planta, región, capacidad)
  * `dim_donante` (tipo_donante, categoría)
  * `dim_material` (tipo_material, nivel_toxicidad)
* **Granularidad:** Un renglón en la tabla de hechos representa la recepción o despacho de una cantidad específica de materiales procesados en una fecha dada por una planta de tratamiento concreta.

---

## 2. Revisión de Claves Foráneas y Consultas de Auditoría (Detección de Huérfanos)

### A. Verificación del Esquema
En los procesos de carga y transformación del Data Warehouse, las restricciones `FOREIGN KEY` explícitas en la base de datos destino suelen no estar declaradas explícitamente a nivel DDL .

### B. Consultas SQL para buscar hechos huérfanos

```sql
-- 1. Verificación de hechos huérfanos en la dimensión Tiempo
SELECT h.* 
FROM hechos_donaciones h
LEFT JOIN dim_tiempo t ON h.id_tiempo = t.id_tiempo
WHERE t.id_tiempo IS NULL;

-- 2. Verificación de hechos huérfanos en la dimensión Planta
SELECT h.* 
FROM hechos_donaciones h
LEFT JOIN dim_planta p ON h.id_planta = p.id_planta
WHERE p.id_planta IS NULL;

-- 3. Verificación de hechos huérfanos en la dimensión Donante
SELECT h.* 
FROM hechos_donaciones h
LEFT JOIN dim_donante d ON h.id_donante = d.id_donante
WHERE d.id_donante IS NULL;
```
* **Resultado observado:** `0 filas` devueltas en todas las consultas.

---

## 3. Declaración de Claves Foráneas y Análisis Teórico

### A. Inclusión de FKs en una copia de la base de datos
```sql
-- Creación manual de restricciones FK en la copia del almacén
ALTER TABLE hechos_donaciones
  ADD CONSTRAINT fk_hechos_tiempo FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo),
  ADD CONSTRAINT fk_hechos_planta FOREIGN KEY (id_planta) REFERENCES dim_planta(id_planta),
  ADD CONSTRAINT fk_hechos_donante FOREIGN KEY (id_donante) REFERENCES dim_donante(id_donante);
```

### B. Justificación técnica: ¿Por qué un Almacén de Datos omite FKs a propósito?
1. **Rendimiento de Carga (ETL Performance):** Durante los procesos de carga batch de millones de registros, validar las restricciones fila por fila genera un sobrecosto en operaciones de disco e índices.
2. **Flexibilidad en Cargas Asíncronas:** Permite insertar hechos de eventos que ocurrieron en tiempo real aunque la dimensión descriptiva aún no haya sido actualizada en la última ejecución.

### C. Riesgos de omitir claves foráneas en el almacén
* **Inconsistencia y Reportes Incompletos:** Inserción de llaves foráneas inválidas que provocan que los reportes de BI o consultas OLAP omitan métricas numéricas, al realizar `INNER JOIN` entre la tabla de hechos y las dimensiones.
* **Pérdida de Calidad de Datos:** Generación de valores `NULL` no deseados en tableros analíticos cuando se utilizan `LEFT JOIN`.