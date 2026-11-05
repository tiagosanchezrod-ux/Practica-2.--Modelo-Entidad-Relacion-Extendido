# Ejercicio 2.3
## 1. Pruebas por cada acción referencial usada con datos reales

### A. Prueba de `ON DELETE CASCADE` (`envio_despacho` y `detalle_despacho`)
* **Registros antes de la acción:**
  * `envio_despacho`: 3 registros
  * `detalle_despacho`: 8 registros asociados
* **Sentencia DML:**
  ```sql
  DELETE FROM envio_despacho WHERE id_envio = 1;
  ```
* **Registros de la acción:**
  * `envio_despacho`: 2 registros (se eliminó el envío 1).
  * `detalle_despacho`: 5 registros (los 3 renglones detalle que pertenecían al envío 1 se eliminaron automáticamente en cascada).

### B. Prueba de `ON DELETE RESTRICT` (`planta_tratamiento` y `envio_despacho`)
* **Registros antes de la acción:**
  * `planta_tratamiento`: Planta ID `1` ("Planta Central CDMX") tiene un envío registrado.
* **Sentencia DML:**
  ```sql
  DELETE FROM planta_tratamiento WHERE id_planta = 1;
  ```
* **Resultado:**
  ```text
  ERROR: update or delete on table "planta_tratamiento" violates foreign key constraint "envio_despacho_id_planta_fkey" on table "envio_despacho"
  DETAIL: Key (id_planta)=(1) is still referenced from table "envio_despacho".
  ```
---

## 2. Inserción con clave foránea inexistente (`INSERT` rechazado)
* **DML intentada:**
  ```sql
  INSERT INTO envio_despacho (id_envio, fecha_envio, codigo_manifiesto, id_planta) 
  VALUES (99, '2026-11-04', 'MAN-999', 9999);
  ```
* **Mensaje de error devuelto:**
  ```text
  ERROR: insert or update on table "envio_despacho" violates foreign key constraint "envio_despacho_id_planta_fkey"
  DETAIL: Key (id_planta)=(9999) is not present in table "planta_tratamiento".
  ```
---

## 3. Orden de carga y dependencias
* **Comportamiento al cargar tablas hijas antes que padres:** Si el script de población intenta insertar registros en `envio_despacho` antes de cargar los catálogos en `planta_tratamiento`, PostgreSQL rechaza la carga completa arrojando un error de llave foránea debido a que los IDs referenciados no existen físicamente.
* **Solución:** Respetar estrictamente la jerarquía del modelo relacional:
  1. Cargar primero tablas independientes o catálogos padre ( `plantas.csv`, `materiales.csv`, `donantes.csv`).
  2. Cargar posteriormente las tablas hijas o dependientes ( `envios.csv`, `detalle_despacho.csv`, `componentes.csv`).

---

## 4. Comprobaciones de auditoría (Deben arrojar resultados vacíos / 0 filas)

### A. Claves foráneas huérfanas
```sql
SELECT * FROM envio_despacho e 
LEFT JOIN planta_tratamiento p ON e.id_planta = p.id_planta 
WHERE p.id_planta IS NULL;
```
* **Resultado:** 0 filas.

### B. Duplicados en columnas únicas
```sql
SELECT correo, COUNT(*) 
FROM donante 
GROUP BY correo 
HAVING COUNT(*) > 1;
```
* **Resultado:** 0 filas.

### C. Nulos en columnas que no los admiten
```sql
SELECT * FROM donante WHERE nombre IS NULL;
```
* **Resultado:** 0 filas.