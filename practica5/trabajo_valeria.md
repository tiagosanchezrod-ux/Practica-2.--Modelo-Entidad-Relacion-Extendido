# Ejercicio 2.6: Trabajo Individual — Valeria Daniela Casasola Ávalos

## 1. Relación elegida y cambio 
* **Tablas involucradas:** `donante` (Tabla Padre) y `recepcion_residuo` (Tabla Hija).
* **Relación original:** `ON DELETE RESTRICT` impide borrar a un donante si ya tiene registros de recepción de residuos asociados en el sistema.
* **Modificación aplicada en la copia de prueba:** Cambiamos la acción referencial a `ON DELETE SET NULL` para analizar el comportamiento operacional al desvincular al donante.

```sql
-- 1. Eliminar la restricción de llave foránea
ALTER TABLE recepcion_residuo 
  DROP CONSTRAINT recepcion_residuo_id_donante_fkey;

-- 2. Agregar la nueva restricción con SET NULL
ALTER TABLE recepcion_residuo 
  ADD CONSTRAINT recepcion_residuo_id_donante_fkey 
  FOREIGN KEY (id_donante) 
  REFERENCES donante(id_donante) 
  ON DELETE SET NULL;
```

---

## 2. Demostración práctica con datos

### A. Estado previo a la eliminación
* **`donante`:** Registro con `id_donante = 5` ("Tech Recycling Corp").
* **`recepcion_residuo`:** 2 folios de recepción registrados con `id_donante = 5` (`id_recepcion` 201 y 202).

### B. Ejecución de la sentencia DML de borrado del padre
```sql
DELETE FROM donante WHERE id_donante = 5;
```

### C. Comprobación ¿Qué se perdió y qué se conservó?)
* **Lo que se perdió:** 
  * Se eliminó el registro de la entidad donante en la tabla `donante`.
  * Se perdió la trazabilidad del nombre y datos de contacto de quién realizó la entrega del material.
* **Lo que se conservó:** 
  * Los folios de recepción (`id_recepcion` 201 y 202) permanecen intactos en `recepcion_residuo`, guardando el peso, tipo de residuo y fecha de ingreso, pero con `id_donante = NULL`.

```sql
-- Consulta de posterior
SELECT id_recepcion, fecha_recepcion, id_donante 
FROM recepcion_residuo 
WHERE id_recepcion IN (201, 202);
-- Resultado: Las recepción existe, pero la columna id_donante ahora muestra NULL.
```

---

## 3. Justificación y Conclusión

* **Opción correcta:** **`ON DELETE RESTRICT`** o en su defecto mediante `UPDATE activo = FALSE`.
* **Justificación:** Aunque `SET NULL` evita perder los datos de residuos capturados en la planta de reciclaje, en el dominio de la legislación ambiental y los certificados exigen conocer la identidad legal del donante originario de los componentes. Dejar folios en `NULL` genera vacíos. Por lo tanto, `RESTRICT` es la mejoir opción para obligar a conservar los registros o deshabilitar al donante mediante borrado lógico.