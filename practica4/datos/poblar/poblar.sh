#!/usr/bin/env bash
set -e

export PGHOST=${PGHOST:-localhost}
export PGPORT=${PGPORT:-5432}
export PGDATABASE=${PGDATABASE:-postgres}
export PGUSER=${PGUSER:-postgres}

echo "================================================================="
echo "Iniciando proceso de carga masiva automatizada..."
echo "Conectando a la base de datos: $PGDATABASE en $PGHOST:$PGPORT"
echo "================================================================="

INICIO_TIEMPO=$(date +%s.%N)

psql -v ON_ERROR_STOP=1 <<SQLEOF
BEGIN;

TRUNCATE TABLE DETALLE_DESPACHO, COMPONENTE_MATERIAL, ENVIO_DESPACHO, COMPONENTE, MATERIAL, RECEPCION_EQUIPO, DONANTE_EMPRESA, DONANTE_PARTICULAR, PLANTA_TRATAMIENTO, DONANTE RESTART IDENTITY CASCADE;

COMMIT;
BEGIN;

\copy PLANTA_TRATAMIENTO(id_planta, nombre_planta, licencia_ambiental, contacto_telefono) FROM '/tmp/datos/plantas.csv' WITH (FORMAT csv, HEADER true);
\copy MATERIAL(id_material, nombre_material, valormercado_kg, es_peligroso) FROM '/tmp/datos/materiales.csv' WITH (FORMAT csv, HEADER true);
\copy DONANTE(id_donante, nombre_pila, apellido_paterno, apellido_materno, correo, telefono, tipo_donante) FROM '/tmp/datos/donantes.csv' WITH (FORMAT csv, HEADER true);
\copy DONANTE_PARTICULAR(id_donante, fecha_nacimiento, curp) FROM '/tmp/datos/donantes_particular.csv' WITH (FORMAT csv, HEADER true);
\copy DONANTE_EMPRESA(id_donante, representante_legal, rfc) FROM '/tmp/datos/donantes_empresa.csv' WITH (FORMAT csv, HEADER true);
\copy RECEPCION_EQUIPO(id_recepcion, id_donante, fecha_ingreso, tipo_aparato, peso_total, costo_recepcion) FROM '/tmp/datos/recepciones.csv' WITH (FORMAT csv, HEADER true);
\copy COMPONENTE(id_recepcion, id_componente, estado_funcional, peso_kg, tipo_componente) FROM '/tmp/datos/componentes.csv' WITH (FORMAT csv, HEADER true);
\copy COMPONENTE_MATERIAL(id_recepcion, id_componente, id_material) FROM '/tmp/datos/componentes_material.csv' WITH (FORMAT csv, HEADER true);
\copy ENVIO_DESPACHO(id_envio, fecha_envio, codigo_manifiesto, id_planta) FROM '/tmp/datos/envios.csv' WITH (FORMAT csv, HEADER true);
\copy DETALLE_DESPACHO(id_envio, id_material, cantidad_kg) FROM '/tmp/datos/detalle_despacho.csv' WITH (FORMAT csv, HEADER true);

COMMIT;
SQLEOF

echo "================================================================="
echo "¡Carga masiva completada con éxito!"
echo "================================================================="
echo "Conteo de registros por tabla:"
psql -Atc "
SELECT 'PLANTA_TRATAMIENTO: ' || count(*) FROM PLANTA_TRATAMIENTO UNION ALL
SELECT 'MATERIAL: ' || count(*) FROM MATERIAL UNION ALL
SELECT 'DONANTE: ' || count(*) FROM DONANTE UNION ALL
SELECT 'DONANTE_PARTICULAR: ' || count(*) FROM DONANTE_PARTICULAR UNION ALL
SELECT 'DONANTE_EMPRESA: ' || count(*) FROM DONANTE_EMPRESA UNION ALL
SELECT 'RECEPCION_EQUIPO: ' || count(*) FROM RECEPCION_EQUIPO UNION ALL
SELECT 'COMPONENTE: ' || count(*) FROM COMPONENTE UNION ALL
SELECT 'COMPONENTE_MATERIAL: ' || count(*) FROM COMPONENTE_MATERIAL UNION ALL
SELECT 'ENVIO_DESPACHO: ' || count(*) FROM ENVIO_DESPACHO UNION ALL
SELECT 'DETALLE_DESPACHO: ' || count(*) FROM DETALLE_DESPACHO;
"
echo "================================================================="
