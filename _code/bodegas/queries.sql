-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Consultas de referencia para la BD de Bodegas
-- 

USE BodegasDB;

-- Bodegas con denominación Rioja
SELECT *
FROM wineries
WHERE origin_designation = 'Rioja';

-- Listado de vinos con sus uvas
SELECT w.wine_name, g.grape_name
FROM wines w
JOIN wine_grapes wg ON w.wine_id = wg.wine_id
JOIN grapes g ON wg.grape_id = g.grape_id;

-- Vinos con sus cosechas
SELECT w.*, h.harvest_year, h.quality
FROM wines w
JOIN harvests h ON w.wine_id = h.wine_id;

-- Bodegas que producen vinos jóvenes y crianzas
SELECT DISTINCT wy.winery_name
FROM wineries wy
JOIN wines w ON wy.winery_id = w.winery_id;

-- Bodegas y vinos que usan la uva Tempranillo
SELECT wy.winery_name, w.wine_name
FROM wineries wy
JOIN wines w ON wy.winery_id = w.winery_id
JOIN wine_grapes wg ON w.wine_id = wg.wine_id
JOIN grapes g ON wg.grape_id = g.grape_id
WHERE g.grape_name = 'Tempranillo';

-- Total de cosechas por vino de crianza
SELECT h.wine_id, COUNT(*) AS total_harvests
FROM harvests h
JOIN aged_wines aw ON h.wine_id = aw.wine_id
GROUP BY h.wine_id;

-- Vino joven con más grados
SELECT w.wine_name, w.alcohol_percent
FROM wines w
JOIN young_wines yw ON w.wine_id = yw.wine_id
ORDER BY w.alcohol_percent DESC
LIMIT 1;

-- Conteo de cosechas por vino
SELECT w.wine_name, COUNT(*) AS total_harvests
FROM wines w
JOIN harvests h ON w.wine_id = h.wine_id
GROUP BY w.wine_name;
