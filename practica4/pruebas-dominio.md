# Ejercicio 1.5: Pruebas de Restricciones de Dominio

Se haran 10 casos de prueba ejecutados sobre el motor de PostgreSQL para verificar el cumplimiento y robustez de las restricciones físicas y de dominio implementadas en el sistema de gestión de residuos electrónicos.

---

## Caso 1: Violación de restricción `NOT NULL`
* **Operación intentada:** Insertar un nuevo donante omitiendo el apellido paterno obligatorio.
  ```sql
  INSERT INTO DONANTE (id_donante, nombre_pila, apellido_paterno, apellido_materno, correo, telefono, tipo_donante) 
  VALUES (10, 'Roberto', NULL, 'Sánchez', 'santiago_s@gmail.com', '5511223344', 'PARTICULAR');
* **Resultado esperado:** Rechazo de la inserción por incumplimiento de nulos en una columna protegida.
* **Mensaje que devolvió el gestor:** 
  ```text
  ERROR:  null value in column "apellido_paterno" of relation "donante" violates not-null constraint
  DETAIL:  Failing row contains (10, Roberto, null, Sánchez, santiago_s@gmail.com, 5511223344, PARTICULAR).

## Caso 2: Verificación de valor por defecto (DEFAULT)
* **Operación intentada:** Registrar una nueva recepción de equipo omitiendo la fecha de ingreso y el costo para comprobar la asignación automática por defecto.
```sql
INSERT INTO RECEPCION_EQUIPO (id_recepcion, id_donante, tipo_aparato, peso_total) 
VALUES (10, 1, 'Impresoras Láser', 45.000);
SELECT fecha_ingreso, costo_recepcion FROM RECEPCION_EQUIPO WHERE id_recepcion = 10;
* **Resultado esperado:** Inserción exitosa asignando automáticamente la fecha/hora actual del sistema y valor inicial de 0.00 al costo.
* **Mensaje que devolvió el gestor:** 
INSERT 0 1
 fecha_ingreso        | costo_recepcion 
----------------------+-----------------
 2026-10-31 18:30:00  |            0.00

## Caso 3:
* **Operación intentada:** Registrar un donante nuevo utilizando un correo electrónico que ya se encuentra asociado a otro usuario en la tabla
```sql
INSERT INTO DONANTE (id_donante, nombre_pila, apellido_paterno, apellido_materno, correo, telefono, tipo_donante) 
VALUES (11, 'Lucía', 'Martínez', 'Rojas', 'carlos.perez@gmail.com', '5599887766', 'PARTICULAR');
* **Resultado esperado:** Rechazo por duplicidad de llave única en el campo de correo electrónico.
* **Mensaje que devolvió el gestor:** 
ERROR:  duplicate key value violates unique constraint "uq_donante_correo"
DETAIL:  Key (correo)=(carlos.perez@gmail.com) already exists.

## Caso 4:
* **Operación intentada:** Registrar los datos particulares de un donante ingresando una CURP que ya está registrada en el sistema.
```sql
INSERT INTO DONANTE_PARTICULAR (id_donante, fecha_nacimiento, curp) 
VALUES (2, '1990-01-01', 'PEGC950512HDFRRS01');
* **Resultado esperado:** Rechazo de la inserción por violación de la clave única de registro poblacional.
* **Mensaje que devolvió el gestor:** 
ERROR:  duplicate key value violates unique constraint "uq_donante_curp"
DETAIL:  Key (curp)=(PEGC950512HDFRRS01) already exists.

## Caso 5:
* **Operación intentada:** Insertar en la tabla asociativa DETALLE_DESPACHO un material repetido para un mismo envío de despacho.
```sql
INSERT INTO DETALLE_DESPACHO (id_envio, id_material, cantidad_kg) 
VALUES (1, 1, 3.000); -- El id_envio 1 y id_material 1 ya existían en los datos de carga
* **Resultado esperado:** Rechazo de la inserción por duplicidad en la llave compuesta de envío y material.
* **Mensaje que devolvió el gestor:** 
ERROR:  duplicate key value violates unique constraint "uq_detalle_envio_material"
DETAIL:  Key (id_envio, id_material)=(1, 1) already exists.

## Caso 6:
* **Operación intentada:** Insertar un correo electrónico que carece del símbolo @ obligatorio.
```sql
INSERT INTO DONANTE (id_donante, nombre_pila, apellido_paterno, apellido_materno, correo, telefono, tipo_donante) 
VALUES (12, 'Fernando', 'Garcés', 'Lira', 'fernando_correo.com', '5533221100', 'PARTICULAR');
* **Resultado esperado:** Rechazo por incumplimiento del patrón de expresión regular del formato de correo.
* **Mensaje que devolvió el gestor:** 
ERROR:  new row for relation "donante" violates check constraint "chk_correo_formato"
DETAIL:  Failing row contains (12, Fernando, Garcés, Lira, fernando_correo.com, 5533221100, PARTICULAR).

## Caso 7:
* **Operación intentada:** Insertar un número telefónico con una longitud menor a 10 dígitos numéricos.
```sql
INSERT INTO DONANTE (id_donante, nombre_pila, apellido_paterno, apellido_materno, correo, telefono, tipo_donante) 
VALUES (13, 'Sofía', 'Paz', 'Valdés', 'sofia@gmail.com', '55123', 'PARTICULAR');
* **Resultado esperado:** Rechazo de la inserción por incumplimiento de la regla de formato telefónico.
* **Mensaje que devolvió el gestor:** 
ERROR:  new row for relation "donante" violates check constraint "chk_telefono_formato"
DETAIL:  Failing row contains (13, Sofía, Paz, Valdés, sofia@gmail.com, 55123, PARTICULAR).

## Caso 8:
* **Operación intentada:** Registrar un donante particular cuya fecha de nacimiento indique que es menor de 18 años por ejemplo, nacido hace 5 años.
```sql
INSERT INTO DONANTE_PARTICULAR (id_donante, fecha_nacimiento, curp) 
VALUES (2, CURRENT_DATE - INTERVAL '5 years', 'MENO180512HDFRR099');
* **Resultado esperado:** Rechazo de la inserción por no cumplir con la edad mínima legal permitida para el registro autónomo.
* **Mensaje que devolvió el gestor:** 
ERROR:  new row for relation "donante_particular" violates check constraint "chk_fecha_nacimiento_edad"
DETAIL:  Failing row contains (2, 2021-11-01, MENO180512HDFRR099).

## Caso 9:
* **Operación intentada:** Registrar una recepción de equipo con un peso total igual a cero o negativo.
```sql
INSERT INTO RECEPCION_EQUIPO (id_recepcion, id_donante, tipo_aparato, peso_total, costo_recepcion) 
VALUES (15, 1, 'Televisores Viejos', -10.500, 100.00);
* **Resultado esperado:** Rechazo de la inserción por ingresar un valor de masa no válido.
* **Mensaje que devolvió el gestor:** 
ERROR:  new row for relation "recepcion_equipo" violates check constraint "chk_peso_total_positivo"
DETAIL:  Failing row contains (15, 1, Televisores Viejos, -10.500, 100.00, 2026-11-01 21:30:00).

## Caso 10:
* **Operación intentada:** Registrar un componente con un estado funcional fuera del catálogo permitido por el dominio.
```sql
INSERT INTO COMPONENTE (id_recepcion, id_componente, estado_funcional, peso_kg, tipo_componente) 
VALUES (1, 3, 'CASI NUEVO', 0.500, 'Disco Duro');
* **Resultado esperado:** Rechazo de la inserción por valor no contemplado en el conjunto de estados válidos del sistema.
* **Mensaje que devolvió el gestor:** 
ERROR:  new row for relation "componente" violates check constraint "chk_estado_funcional_enum"
DETAIL:  Failing row contains (1, 3, CASI NUEVO, 0.500, Disco Duro).
