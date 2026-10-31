-- Migración 001: Definición de Dominios y Tipos Personalizados
-- Proyecto: Sistema de Gestión de Residuos Electrónicos y Trazabilidad
-- 1. Crear ENUM para tipo de donante
CREATE TYPE tipo_donante_enum AS ENUM ('PARTICULAR', 'EMPRESA');

-- 2. Crear DOMAINs reutilizables
CREATE DOMAIN dom_monto AS NUMERIC(12,2)
    CHECK (VALUE >= 0);

CREATE DOMAIN dom_peso AS NUMERIC(8,3)
    CHECK (VALUE > 0);

CREATE DOMAIN dom_curp AS VARCHAR(18)
    CHECK (VALUE ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$');

CREATE DOMAIN dom_rfc AS VARCHAR(13)
    CHECK (VALUE ~ '^[A-Z&Ñ]{3,4}[0-9]{6}[A-Z0-9]{3}$');

-- 3. Aplicar tipos de dominio mediante ALTER TABLE sobre el esquema
ALTER TABLE DONANTE 
    ALTER COLUMN tipo_donante TYPE tipo_donante_enum USING tipo_donante::tipo_donante_enum;

ALTER TABLE DONANTE_PARTICULAR 
    ALTER COLUMN curp TYPE dom_curp;

ALTER TABLE DONANTE_EMPRESA 
    ALTER COLUMN rfc TYPE dom_rfc;

ALTER TABLE RECEPCION_EQUIPO 
    ALTER COLUMN peso_total TYPE dom_peso,
    ALTER COLUMN costo_recepcion TYPE dom_monto;

ALTER TABLE COMPONENTE 
    ALTER COLUMN peso_kg TYPE dom_peso;

ALTER TABLE MATERIAL 
    ALTER COLUMN valormercado_kg TYPE dom_monto;

ALTER TABLE DETALLE_DESPACHO 
    ALTER COLUMN cantidad_kg TYPE dom_peso;