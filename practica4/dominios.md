# Ejercicio 1.1: Tipos de Dato y Dominios
## 1. Dominios Reutilizables y Tipos Enumerados (CREATE DOMAIN / ENUM)

Se definen los siguientes dominios y ENUMs:

- **`tipo_donante_enum` (ENUM)**: Define la categoría del donante (`PARTICULAR`, `EMPRESA`). Evita valores inconsistentes.
- **`dom_rfc` (DOMAIN)**: Texto de longitud fija (12 o 13 caracteres) con validación de formato mediante expresión regular para RFC de personas físicas o morales en México.
- **`dom_curp` (DOMAIN)**: Texto de longitud fija (18 caracteres) con validación por expresión regular para CURP oficial.
- **`dom_monto` (DOMAIN)**: `NUMERIC(12,2) CHECK (VALUE >= 0)`. **No se utiliza punto flotante** (`REAL` o `DOUBLE PRECISION`) para montos monetarios o costos de recepción para evitar errores de redondeo binario acumulados.
- **`dom_peso` (DOMAIN)**: `NUMERIC(8,3) CHECK (VALUE > 0)`. Permite registrar pesajes en kilogramos con precisión de gramos.

---

## 2. Definición y Justificación de Atributos por Tabla

### Tabla `DONANTE`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_donante` | `INT` / `SERIAL` | 4 bytes | Clave primaria surrogate de incremento autogestionado. |
| `nombre_pila` | `VARCHAR(50)` | Hasta 50 caracteres | Longitud variable adecuada para nombres de pila reales. |
| `apellido_paterno` | `VARCHAR(50)` | Hasta 50 caracteres | Longitud variable para el primer apellido. |
| `apellido_materno` | `VARCHAR(50)` | Hasta 50 caracteres | Opcional pero estandarizado a 50 caracteres. |
| `correo` | `VARCHAR(100)` | Hasta 100 caracteres | Estándar para correos electrónicos institucionales o personales. |
| `telefono` | `VARCHAR(15)` | 15 caracteres | Longitud suficiente para incluir clave de larga distancia e indicativo de país. |
| `tipo_donante` | `tipo_donante_enum` | ENUM | Controla que solo existan donantes particulares o empresariales. |

### Tabla `DONANTE_PARTICULAR`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_donante` | `INT` | 4 bytes | Clave primaria/foránea a `DONANTE`. |
| `fecha_nacimiento` | `DATE` | AAAA-MM-DD (4 bytes) | Fecha natural sin componente de hora. |
| `curp` | `dom_curp` | 18 caracteres fijos | Clave Única de Registro de Población validada en formato estricto. |

### Tabla `DONANTE_EMPRESA`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_donante` | `INT` | 4 bytes | Clave primaria/foránea a `DONANTE`. |
| `representante_legal` | `VARCHAR(120)` | Hasta 120 caracteres | Nombre completo del apoderado o representante. |
| `rfc` | `dom_rfc` | 12 a 13 caracteres | Registro Federal de Contribuyentes con validación de estructura de persona moral o física. |

### Tabla `RECEPCION_EQUIPO`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_recepcion` | `INT` / `SERIAL` | 4 bytes | Identificador único del lote o recepción. |
| `id_donante` | `INT` | 4 bytes | Identificador del donante que entrega los equipos. |
| `fecha_ingreso` | `TIMESTAMP` | Con hora (8 bytes) | Registro del instante exacto de recepción física del material. |
| `tipo_aparato` | `VARCHAR(60)` | Hasta 60 caracteres | Clasificación del lote (ej. "Laptops", "Monitores CRT", "Servidores"). |
| `peso_total` | `dom_peso` | NUMERIC(8,3) | Peso acumulado del lote ingresado en kilogramos. |
| `costo_recepcion` | `dom_monto` | NUMERIC(12,2) | Costo asignado o tarifa de manejo; **nunca en float** para evitar errores numéricos. |

### Tabla `COMPONENTE`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_recepcion` | `INT` | 4 bytes | Parte de la clave primaria compuesta (proveniente de RECEPCION_EQUIPO). |
| `id_componente` | `INT` | 4 bytes | Secuencial del componente dentro del lote recibido. |
| `estado_funcional` | `VARCHAR(30)` | Hasta 30 caracteres | Estado inicial (ej. "Operativo", "Para Despiece", "Dañado"). |
| `peso_kg` | `dom_peso` | NUMERIC(8,3) | Peso del componente individual en kilogramos. |
| `tipo_componente` | `VARCHAR(50)` | Hasta 50 caracteres | Categoría de la pieza (ej. "Tarjeta Madre", "Fuente de Poder", "Batería Li-ion"). |

### Tabla `MATERIAL`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_material` | `INT` / `SERIAL` | 4 bytes | Clave primaria del tipo de material recuperable. |
| `nombre_material` | `VARCHAR(50)` | Hasta 50 caracteres | Nombre técnico del elemento (ej. "Cobre", "Oro", "Plástico ABS"). |
| `valormercado_kg` | `dom_monto` | NUMERIC(12,2) | Valor comercial de rescate por kg; **nunca float**. |
| `es_peligroso` | `BOOLEAN` | 1 byte | Indicador binario de residuo peligroso (NOM-052/SEMARNAT). |

### Tabla `COMPONENTES_MATERIAL` (Relación Muchos a Muchos)
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_recepcion` | `INT` | 4 bytes | FK/PK compuesta hacia `COMPONENTE`. |
| `id_componente` | `INT` | 4 bytes | FK/PK compuesta hacia `COMPONENTE`. |
| `id_material` | `INT` | 4 bytes | FK/PK compuesta hacia `MATERIAL`. |

### Tabla `PLANTA_TRATAMIENTO`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_planta` | `INT` / `SERIAL` | 4 bytes | Identificador de la planta o destino final de tratamiento. |
| `nombre_planta` | `VARCHAR(100)` | Hasta 100 caracteres | Razon social del centro receptor. |
| `licencia_ambiental`| `VARCHAR(50)` | Texto fijo/variable | Folio de autorización oficial emitido por autoridad ambiental. |
| `contacto_telefono` | `VARCHAR(15)` | Hasta 15 caracteres | Teléfono directo del responsable de la planta. |

### Tabla `ENVIO_DESPACHO`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_envio` | `INT` / `SERIAL` | 4 bytes | Clave de despacho de transferencia. |
| `fecha_envio` | `TIMESTAMP` | Con hora (8 bytes) | Instante de salida del despacho hacia la planta. |
| `codigo_manifiesto` | `VARCHAR(40)` | Longitud fija/variable | Manifiesto de entrega, transporte y recepción de residuos. |
| `id_planta` | `INT` | 4 bytes | FK a la planta destino. |

### Tabla `DETALLE_DESPACHO`
| Columna | Tipo de Dato | Longitud / Precisión | Justificación |
| :--- | :--- | :--- | :--- |
| `id_envio` | `INT` | 4 bytes | FK/PK compuesta hacia `ENVIO_DESPACHO`. |
| `id_material` | `INT` | 4 bytes | FK/PK compuesta hacia `MATERIAL`. |
| `cantidad_kg` | `dom_peso` | NUMERIC(8,3) | Masa total enviada del material específico en kilogramos. |