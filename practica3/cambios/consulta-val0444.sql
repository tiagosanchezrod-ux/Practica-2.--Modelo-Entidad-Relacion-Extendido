-- =====================================================================
-- Ejercicio 8, punto 3. Consulta que solo es posible despues del cambio
-- Autora: Diana Valeria Casasola Avalos (GitHub: val0444)
-- Se ejecuta sobre la copia data_warehouse_copia, despues de cambio-val0444.sql
-- =====================================================================

-- PASO A. Datos de demostracion.
-- Aun no existe un modelo entrenado, asi que se llena la tabla con una
-- LINEA BASE estadistica (no es aprendizaje automatico): para la ultima
-- fecha con lecturas, a cada colonia se le asigna una probabilidad segun el
-- percentil de su consumo mas alto. Un modelo real escribiria en esta misma
-- tabla, con otra version_modelo.
INSERT INTO proyeccion_riesgo
    (id_ubicacion, id_fact_base, fecha_proyectada, version_modelo,
     nivel_riesgo_desabasto, probabilidad_escasez, factor_anomalia_temp)
WITH ultima AS (
    SELECT MAX(t.fecha) AS fecha
    FROM dim_tiempo t
    WHERE EXISTS (SELECT 1 FROM fact_consumo_agua f WHERE f.id_tiempo = t.id_tiempo)
),
base AS (
    SELECT DISTINCT ON (f.id_ubicacion)
           f.id_ubicacion, f.id_fact, f.consumo_total
    FROM fact_consumo_agua f
    JOIN dim_tiempo t ON t.id_tiempo = f.id_tiempo
    JOIN ultima u     ON t.fecha = u.fecha
    WHERE f.id_ubicacion IS NOT NULL
      AND f.consumo_total IS NOT NULL
    ORDER BY f.id_ubicacion, f.consumo_total DESC, f.id_fact
),
clima AS (
    SELECT z
    FROM (
        SELECT t.fecha,
               (c.temp_promedio - AVG(c.temp_promedio) OVER ())
                 / NULLIF(STDDEV_POP(c.temp_promedio) OVER (), 0) AS z
        FROM fact_clima c
        JOIN dim_tiempo t ON t.id_tiempo = c.id_tiempo
        WHERE c.temp_promedio IS NOT NULL
    ) s
    ORDER BY fecha DESC
    LIMIT 1
),
puntaje AS (
    SELECT b.id_ubicacion, b.id_fact,
           ROUND((0.01 + 0.98 * PERCENT_RANK() OVER (ORDER BY b.consumo_total))::numeric, 4) AS p
    FROM base b
)
SELECT p.id_ubicacion,
       p.id_fact,
       CURRENT_DATE + 30,
       'baseline-percentil-v0',
       CASE WHEN p.p >= 0.90 THEN 'CRITICO'
            WHEN p.p >= 0.60 THEN 'MEDIO'
            ELSE 'BAJO' END,
       p.p,
       (SELECT ROUND(z::numeric, 3) FROM clima)
FROM puntaje p;

-- PASO B. Cuantas proyecciones hay por nivel de riesgo.
SELECT nivel_riesgo_desabasto AS nivel, COUNT(*) AS colonias
FROM proyeccion_riesgo
GROUP BY nivel_riesgo_desabasto
ORDER BY colonias DESC;

-- PASO C. CONSULTA DEL PUNTO 3: las 10 colonias con riesgo CRITICO y mayor
-- probabilidad de escasez, con la version del modelo y el consumo en que se
-- basa la proyeccion. Antes del cambio esta consulta no se podia escribir:
-- la tabla proyeccion_riesgo no existia.
SELECT u.alcaldia,
       u.colonia,
       p.fecha_proyectada,
       p.nivel_riesgo_desabasto AS nivel,
       p.probabilidad_escasez   AS probabilidad,
       p.version_modelo,
       f.consumo_total          AS consumo_base
FROM proyeccion_riesgo p
JOIN dim_ubicacion u     ON u.id_ubicacion = p.id_ubicacion
JOIN fact_consumo_agua f ON f.id_fact      = p.id_fact_base
WHERE p.nivel_riesgo_desabasto = 'CRITICO'
ORDER BY p.probabilidad_escasez DESC, f.consumo_total DESC
LIMIT 10;
