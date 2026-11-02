-- Migración 002: Restricciones de Columna (NOT NULL, DEFAULT, UNIQUE y CHECK)
-- 1. NOT NULL en claves foráneas y atributos obligatorios
ALTER TABLE DONANTE 
    ALTER COLUMN nombre_pila SET NOT NULL,
    ALTER COLUMN apellido_paterno SET NOT NULL,
    ALTER COLUMN tipo_donante SET NOT NULL;

ALTER TABLE RECEPCION_EQUIPO 
    ALTER COLUMN id_donante SET NOT NULL,
    ALTER COLUMN fecha_ingreso SET NOT NULL,
    ALTER COLUMN peso_total SET NOT NULL;

ALTER TABLE ENVIO_DESPACHO 
    ALTER COLUMN id_planta SET NOT NULL,
    ALTER COLUMN fecha_envio SET NOT NULL;

-- 2. DEFAULT en valores iniciales naturales
ALTER TABLE RECEPCION_EQUIPO 
    ALTER COLUMN fecha_ingreso SET DEFAULT CURRENT_TIMESTAMP,
    ALTER COLUMN costo_recepcion SET DEFAULT 0.00;

ALTER TABLE MATERIAL 
    ALTER COLUMN es_peligroso SET DEFAULT FALSE;

ALTER TABLE ENVIO_DESPACHO 
    ALTER COLUMN fecha_envio SET DEFAULT CURRENT_TIMESTAMP;

-- 3. UNIQUE simples y compuestas
-- R1 (Simple): Correo electrónico único por donante
ALTER TABLE DONANTE 
    ADD CONSTRAINT uq_donante_correo UNIQUE (correo);

-- R2 (Simple): CURP única por donante particular
ALTER TABLE DONANTE_PARTICULAR 
    ADD CONSTRAINT uq_donante_curp UNIQUE (curp);

-- R3 (Simple): RFC único por empresa
ALTER TABLE DONANTE_EMPRESA 
    ADD CONSTRAINT uq_empresa_rfc UNIQUE (rfc);

-- R4 (Simple): Código de manifiesto de transporte único
ALTER TABLE ENVIO_DESPACHO 
    ADD CONSTRAINT uq_envio_manifiesto UNIQUE (codigo_manifiesto);

-- R5 (Compuesta): Un mismo material no se repite dos veces dentro del mismo despacho
ALTER TABLE DETALLE_DESPACHO 
    ADD CONSTRAINT uq_detalle_envio_material UNIQUE (id_envio, id_material);

-- 4. Restricciones CHECK (Formato, rango y reglas de dominio)
-- R6 (Formato): Validación de correo con signo '@'
ALTER TABLE DONANTE 
    ADD CONSTRAINT chk_correo_formato CHECK (correo LIKE '%@%.%');

-- R7 (Formato): Teléfono a 10 dígitos numéricos
ALTER TABLE DONANTE 
    ADD CONSTRAINT chk_telefono_formato CHECK (telefono ~ '^[0-9]{10}$');

-- R8 (Rango): Donante particular mayor de edad (18 años mínimos)
ALTER TABLE DONANTE_PARTICULAR 
    ADD CONSTRAINT chk_fecha_nacimiento_edad CHECK (fecha_nacimiento <= CURRENT_DATE - INTERVAL '18 years');

-- R9 (Rango): Peso total del lote superior a 0 kg
ALTER TABLE RECEPCION_EQUIPO 
    ADD CONSTRAINT chk_peso_total_positivo CHECK (peso_total > 0);

-- R10 (Rango): Costo de recepción no negativo
ALTER TABLE RECEPCION_EQUIPO 
    ADD CONSTRAINT chk_costo_recepcion_valido CHECK (costo_recepcion >= 0);

-- R11 (Formato): Estados funcionales permitidos para componentes
ALTER TABLE COMPONENTE 
    ADD CONSTRAINT chk_estado_funcional_enum CHECK (estado_funcional IN ('OPERATIVO', 'REPARABLE', 'PARA DESPIECE', 'OBSOLETO'));

-- R12 (Rango): Peso de componente individual positivo
ALTER TABLE COMPONENTE 
    ADD CONSTRAINT chk_peso_componente_positivo CHECK (peso_kg > 0);

-- R13 (Rango): Valor de mercado por kg no negativo
ALTER TABLE MATERIAL 
    ADD CONSTRAINT chk_valormercado_positivo CHECK (valormercado_kg >= 0);

-- R14 (Rango): Cantidad despachada en kg positiva
ALTER TABLE DETALLE_DESPACHO 
    ADD CONSTRAINT chk_cantidad_despacho_positiva CHECK (cantidad_kg > 0);