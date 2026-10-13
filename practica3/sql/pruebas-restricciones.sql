----SCRIPT DEFINICIÓN DE DATOS (DDL)

INSERT INTO material (id_material, nombre_material, valormercado_kg, es_peligroso) 
VALUES (999, 'Batería defectuosa de prueba', -15.50, true);

INSERT INTO planta_tratamiento (id_planta, nombre_planta, licencia_ambiental, contacto_telefono) 
VALUES (101, 'Planta ReciclaVerde CDMX', 'LIC-ENV-2026-999', '5512345678');

Awui se duplicar la licencia ambiental:
INSERT INTO planta_tratamiento (id_planta, nombre_planta, licencia_ambiental, contacto_telefono) 
VALUES (102, 'Planta Ecológica del Valle', 'LIC-ENV-2026-999', '5587654321');

INSERT INTO envio_despacho (id_envio, fecha_envio, codigo_manifiesto, id_planta) 
VALUES (5001, '2026-10-12', 'MANIFIESTO-FAIL-01', 9999);