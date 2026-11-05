# Ejercicio 2.1: Claves Foráneas del Proyecto
La tabla detalla las claves foráneas implementadas en el esquema relacional, indicando la relación del EER, las tablas y columnas involucradas, y si admiten nulos según su cardinalidad:

| Clave Foránea (Columna) | Relación EER | Tabla Origen (FK) | Tabla Referenciada (PK) | ¿Admite Nulos? | Justificación / Cardinalidad |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `id_planta` | 1:N | `envio_despacho` | `planta_tratamiento` | **No** (`NOT NULL`) | Todo envío de despacho debe estar asociado obligatoriamente a una planta de tratamiento registrada. |
| `id_envio` | 1:N | `detalle_despacho` | `envio_despacho` | **No** (`NOT NULL`) | Parte de la clave primaria compuesta; un detalle pertenece estrictamente a un envío. |
| `id_material` | 1:N | `detalle_despacho` | `material` | **No** (`NOT NULL`) | Parte de la clave primaria compuesta; identifica el material despachado. |
| `id_donante` | 1:1 (Especialización) | `donante_particular` | `donante` | **No** (`NOT NULL`) | Subtipo de entidad generalizada; todo donante particular es a su vez un donante base. |
| `id_donante` | 1:1 (Especialización) | `donante_empresa` | `donante` | **No** (`NOT NULL`) | Subtipo de entidad generalizada; toda empresa donante es a su vez un donante base. |
| `id_donante` | 1:N | `recepcion_equipo` | `donante` | **No** (`NOT NULL`) | Toda recepción de equipo requiere un donante registrado que lo entregue. |
| `id_recepcion` | 1:N | `componente` | `recepcion_equipo` | **No** (`NOT NULL`) | Parte de la clave primaria compuesta; un componente pertenece a una recepción específica. |
| `id_recepcion`, `id_componente` | 1:N | `componente_material` | `componente` | **No** (`NOT NULL`) | Clave foránea compuesta que apunta al componente desglosado. |
| `id_material` | 1:N | `componente_material` | `material` | **No** (`NOT NULL`) | Identifica el material específico que compone al equipo recibido. |

## Justificación
Todas las relaciones del modelo EER se tradujeron exitosamente a claves foráneas con restricciones estrictas (`NOT NULL`), asegurando la integridad referencial en el almacenamiento transaccional del gestor PostgreSQL. No se mantuvieron relaciones huérfanas ni se requirieron migraciones adicionales fuera del esquema relacional base.

<<<<<<< practica4-5
## Ejercicio 2.2: Acciones Referenciales
=======

# Ejercicio 2.2: Acciones Referenciales
>>>>>>> practica2

Se definen las acciones referenciales (`ON DELETE` y `ON UPDATE`) aplicadas a cada clave foránea del sistema, justificando la elección en función de la integridad de los datos y las reglas:

| Tabla Origen (FK) | Clave Foránea | Tabla Referenciada | Acción `ON DELETE` | Acción `ON UPDATE` | Regla del Dominio / Justificación |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `envio_despacho` | `id_planta` | `planta_tratamiento` | `RESTRICT` | `CASCADE` | No se permite eliminar una planta que tenga despachos históricos registrados (`RESTRICT`). Si la clave de la planta cambia, el despacho debe actualizarse automáticamente (`CASCADE`). |
| `detalle_despacho` | `id_envio` | `envio_despacho` | `CASCADE` | `CASCADE` | Como `detalle_despacho` es una entidad débil asociada al envío, si se borra el envío principal, sus renglones de detalle pierden sentido y deben eliminarse en cascada (`CASCADE`). |
| `detalle_despacho` | `id_material` | `material` | `RESTRICT` | `CASCADE` | Un catálogo de material no se puede eliminar si ya fue despachado en algún lote (`RESTRICT`). |
| `donante_particular`| `id_donante` | `donante` | `CASCADE` | `CASCADE` | Al ser una relación de especialización (1:1), si se elimina la entidad padre `donante`, el registro específico de persona física debe borrarse automáticamente (`CASCADE`). |
| `donante_empresa` | `id_donante` | `donante` | `CASCADE` | `CASCADE` | Mismo caso de especialización: eliminar la entidad base `donante` elimina su perfil corporativo en cascada (`CASCADE`). |
| `recepcion_equipo` | `id_donante` | `donante` | `RESTRICT` | `CASCADE` | Un donante con historial de recepciones activas no debe ser eliminado del sistema para mantener la trazabilidad de la auditoría (`RESTRICT`). |
| `componente` | `id_recepcion` | `recepcion_equipo` | `CASCADE` | `CASCADE` | Entidad débil/composición: los componentes desglosados pertenecen a una recepción; si la recepción se cancela/elimina, sus componentes se eliminan en cascada (`CASCADE`). |
| `componente_material`| `id_recepcion`, `id_componente` | `componente` | `CASCADE` | `CASCADE` | Tabla intermedia de composición: si el componente desaparece, el desglose de sus materiales constitutivos debe eliminarse en cascada (`CASCADE`). |
<<<<<<< practica4-5
| `componente_material`| `id_material` | `material` | `RESTRICT` | `CASCADE` | No se puede borrar un tipo de material del catálogo general si hay componentes desglosados asociados a él (`RESTRICT`). |
=======
| `componente_material`| `id_material` | `material` | `RESTRICT` | `CASCADE` | No se puede borrar un tipo de material del catálogo general si hay componentes desglosados asociados a él (`RESTRICT`). |
>>>>>>> practica2
