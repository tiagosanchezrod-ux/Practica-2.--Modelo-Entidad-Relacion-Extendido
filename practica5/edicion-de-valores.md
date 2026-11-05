# Ejercicio 2.4

## 1. Operaciones INSERT

### A. INSERT basado en consulta (INSERT INTO ... SELECT)
*Situación real:* Registrar una lista de recepción con todos los donantes que son empresas registradas en el sistema.
```sql
INSERT INTO recepcion_residuo (id_donante, fecha_recepcion, estado)
SELECT id_donante, CURRENT_DATE, 'Pendiente'
FROM donante_empresa;
```

### B. Inserción con resolución de duplicados (`ON CONFLICT` / Upsert)
*Situación real:* Registrar o actualizar la capacidad operativa de una planta de tratamiento sin duplicar registros por su código único.
```sql
INSERT INTO planta_tratamiento (id_planta, nombre_planta, capacidad_toneladas)
VALUES (1, 'Planta Central CDMX', 150.00)
ON CONFLICT (id_planta) 
DO UPDATE SET capacidad_toneladas = EXCLUDED.capacidad_toneladas;
```

---

## 2. Operaciones UPDATE

### A. UPDATE que depende de otra tabla (`FROM` / Subconsulta)
*Situación real:* Marca como 'Despachado' todos los envíos asociados a plantas de tratamiento ubicadas en la zona 'Norte'.
```sql
UPDATE envio_despacho e
SET estado_envio = 'En Tránsito'
FROM planta_tratamiento p
WHERE e.id_planta = p.id_planta
  AND p.region = 'Norte';
```

### B. UPDATE condicional clasificado con `CASE`
*Situación real:* Clasificar el nivel de prioridad de despacho según la cantidad de componentes acumulados en cada envío.
```sql
UPDATE envio_despacho
SET prioridad = CASE 
    WHEN total_componentes > 100 THEN 'Alta'
    WHEN total_componentes BETWEEN 50 AND 100 THEN 'Media'
    ELSE 'Baja'
END;
```

---

## 3. Operaciones DELETE y Borrado Lógico

### A. DELETE con subconsulta (Borrado físico)
*Situación real:* Eliminar los registros de componentes cual material asociado esté marcado como 'Obsoleto' o fuera de normativa.
```sql
DELETE FROM componente
WHERE id_material IN (
    SELECT id_material 
    FROM material 
    WHERE estado_material = 'Obsoleto'
);
```

### B. Borrado Lógico (Soft Delete)
*Situación real:* En lugar de borrar un donante, se desactiva cambiando su estatus.
```sql
UPDATE donante
SET activo = FALSE
WHERE id_donante = 10;
```

### C. Justificación teórica: Borrado Lógico vs. Físico
* **¿Cuándo conviene cada uno?**
  * **Borrado Físico (`DELETE`):** Conviene en datos temporales, registros erróneos recién ingresados exigen eliminar datos personales.
  * **Borrado Lógico (`UPDATE activo = false`):** Conviene en entidades transaccionales y maestras para mantener la integridad referencial y la trazabilidad histórica.
* **¿Qué se pierde al borrar de verdad considerando las acciones referenciales (Ejercicio 2.2)?**
  * Si la clave foránea tiene `ON DELETE CASCADE`, se pierde en todo el historial de tablas hijas.
  * Si tiene `ON DELETE RESTRICT`, el borrado físico falla si existen registros vinculados, obliga a limpiar manualmente las dependencias o bloquea operativamente el sistema.

---

## 4. Transacción con Reversión Parcial (`SAVEPOINT`)

*Situación real:* Registrar un nuevo envío y dos detalles de componentes, pero revertir parcialmente la inserción del segundo detalle si excede la capacidad antes de confirmar la transacción final.

```sql
BEGIN;

-- 1. Insertar nuevo envío
INSERT INTO envio_despacho (id_envio, fecha_envio, id_planta) 
VALUES (50, CURRENT_DATE, 1);

-- 2. Establecer punto de restauración
SAVEPOINT envio_registrado;

-- 3. Primer detalle que es válido
INSERT INTO detalle_despacho (id_envio, id_componente, cantidad) 
VALUES (50, 101, 5);

-- 4. Segundo detalle que sera operación que queremos revertir parcialmente
INSERT INTO detalle_despacho (id_envio, id_componente, cantidad) 
VALUES (50, 102, 9999);

-- 5. Reversión parcial al SAVEPOINT se quita el segundo detalle
ROLLBACK TO SAVEPOINT envio_registrado;

-- 6. Insertar detalle corregido
INSERT INTO detalle_despacho (id_envio, id_componente, cantidad) 
VALUES (50, 102, 10);

-- 7. Confirmación final
COMMIT;
```

---

## 5. Transacción que falla por violación de restricción

### A. Ejecución de la Transacción
*Situación real:* Se intenta registrar un envío y luego asociarle una planta que no existe (`id_planta = 9999`), violando la clave foránea.

```sql
BEGIN;

-- Paso 1: Inserción válida previa
INSERT INTO envio_despacho (id_envio, fecha_envio, id_planta) 
VALUES (60, CURRENT_DATE, 1);

-- Paso 2: Inserción que viola la restricción de llave foránea
INSERT INTO envio_despacho (id_envio, fecha_envio, id_planta) 
VALUES (61, CURRENT_DATE, 9999); -- ID 9999 no existe

COMMIT;
```

### B. Mensaje devuelto por el gestor (PostgreSQL)
```text
ERROR: insert or update on table "envio_despacho" violates foreign key constraint "envio_despacho_id_planta_fkey"
DETAIL: Key (id_planta)=(9999) is not present in table "planta_tratamiento".
ERROR: current transaction is aborted, commands ignored until end of transaction block
```

### C. Comprobación de que la base de datos quedó intacta
Al fallar el segundo comando, PostgreSQL aborta toda la transacción y ejecuta un `ROLLBACK` implícito. Después de verificar la tabla:
```sql
SELECT * FROM envio_despacho WHERE id_envio IN (60, 61);
```
* **Resultado:** `0 filas` El envío `60`, aunque era válido no se guardó por que la transacción debe ser atómica osea todo o nada.