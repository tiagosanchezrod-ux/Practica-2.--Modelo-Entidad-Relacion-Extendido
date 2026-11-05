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