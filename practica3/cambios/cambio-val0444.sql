-- Ejercicio 8. Cambio de esquema por integrante
-- Propuesta 1: Prediccion de riesgo de desabasto por anomalias climaticas

CREATE TABLE proyeccion_riesgo (
    id_proyeccion           SERIAL        NOT NULL,
    id_ubicacion            INT           NOT NULL,   -- colonia que se clasifica
    id_fact_base            INT           NOT NULL,   -- hecho de consumo que califica
    fecha_proyectada        DATE          NOT NULL,   -- fecha futura a la que se refiere
    generada_en             TIMESTAMPTZ   NOT NULL DEFAULT now(),  -- marca de tiempo
    version_modelo          VARCHAR(50)   NOT NULL,   -- modelo que la genero
    nivel_riesgo_desabasto  VARCHAR(10)   NOT NULL,   -- BAJO, MEDIO o CRITICO
    probabilidad_escasez    NUMERIC(5,4)  NOT NULL,   -- salida del modelo, 0 a 1
    factor_anomalia_temp    NUMERIC(6,3),             -- desviacion estandar de la temperatura

    CONSTRAINT pk_proyeccion_riesgo
        PRIMARY KEY (id_proyeccion),

    CONSTRAINT fk_proyeccion_ubicacion
        FOREIGN KEY (id_ubicacion)
        REFERENCES dim_ubicacion (id_ubicacion)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_proyeccion_fact_base
        FOREIGN KEY (id_fact_base)
        REFERENCES fact_consumo_agua (id_fact)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT ck_proyeccion_nivel
        CHECK (nivel_riesgo_desabasto IN ('BAJO', 'MEDIO', 'CRITICO')),

    CONSTRAINT ck_proyeccion_probabilidad
        CHECK (probabilidad_escasez BETWEEN 0 AND 1),

    CONSTRAINT uq_proyeccion_colonia_fecha_modelo
        UNIQUE (id_ubicacion, fecha_proyectada, version_modelo)
);

CREATE INDEX ix_proyeccion_fecha_nivel
    ON proyeccion_riesgo (fecha_proyectada, nivel_riesgo_desabasto);

CREATE INDEX ix_proyeccion_fact_base
    ON proyeccion_riesgo (id_fact_base);
