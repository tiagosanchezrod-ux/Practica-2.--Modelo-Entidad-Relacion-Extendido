# Ejercicio 2.6: Trabajo Individual — Santiago Sánchez Rodríguez

## 1. Relación elegida y cambio de acción referencial
* **Tablas involucradas:** `planta_tratamiento` (clase padre) y `envio_despacho` (clase hija).
* **Relación original:** `ON DELETE RESTRICT` protege los envíos impidiendo borrar plantas que tengan despachos vinculados.
* **Modificación aplicada para la prueba:** Cambiamos la restricción a `ON DELETE CASCADE` para poder evaluar el comportamiento operativo.

```sql
-- 1. Primero eliminamos la restricción actual
ALTER TABLE envio_despacho 
  DROP CONSTRAINT envio_despacho_id_planta_fkey;

-- 2. Agregamos la nueva restricción con CASCADE
ALTER TABLE envio_despacho 
  ADD CONSTRAINT envio_despacho_id_planta_fkey 
  FOREIGN KEY (id_planta) 
  REFERENCES planta_tratamiento(id_planta) 
  ON DELETE CASCADE;
```

---

## 2. Demostración práctica

### A. Estado previo a la eliminación
* **`planta_tratamiento`:** Registro con `id_planta = 1` ("Planta Central CDMX").
* **`envio_despacho`:** 3 registros asociados a la planta 1 (`id_envio` 10, 11 y 12).

### B. Ejecución de la sentencia DML
```sql
DELETE FROM planta_tratamiento WHERE id_planta = 1;
```

### C. Comprobación de ¿Qué se perdió y qué se conservó?
* **Que se perdió:** 
  * Desapareció físicamente el registro de la planta 1 en `planta_tratamiento`.
  * Se eliminaron automáticamente en cascada los 3 registros de envíos asociados (`id_envio` 10, 11 y 12) y con todo su detalle operativo en la tabla hija.
* **Lo que se conservó:** 
  * Ningún registro quedó huérfano; la base de datos mantuvo consistencia, pero tuvo que destruir masivamente información transaccional crítica.

```sql
SELECT COUNT(*) FROM envio_despacho WHERE id_planta = 1;
-- Resultado: 0 filas (Los despachos históricos fueron borrados por el CASCADE).
```

---

## 3. Justificación y Conclusión

* **Opción correcta:** **`ON DELETE RESTRICT`** (o `NO ACTION`).
* **Justificación:** En un sistema de gestión de residuos electrónicos y reciclaje, las plantas de tratamiento tienen despachos que forman parte del historial financiero, auditorías ambientales y reportes legales. Si se permitiera un `ON DELETE CASCADE` daria una pérdida accidental de datos de trazabilidad si un operador elimina una planta por error. La opción restrictiva obliga a hacer un respaldo de los envíos antes de retirar una planta del sistema.