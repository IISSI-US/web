-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Consultas para implemtar ejemplos de álgebra relacional
-- 

-- Seleccionar todas las bodegas con denominación de origen Rioja:
SELECT *
FROM bodegas
WHERE denominacion_origen = 'Rioja'
;

-- Listado de vinos con sus uvas:
SELECT v.nombre, u.nombre
FROM vinos v
	JOIN vinos_uvas vu ON v.vino_id = vu.vino_id
	JOIN uvas u ON vu.uva_id = u.uva_id
;

-- Vinos con sus cosechas (crianza):
SELECT *
	FROM vinos v
	JOIN cosechas c ON v.vino_id = c.vino_id
;

-- Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas:
SELECT DISTINCT b.nombre 
	FROM bodegas b
	JOIN vinos v ON b.bodega_id = v.bodega_id 
;

-- Nombre de las bodegas y vinos que están compuestos, al menos, con uva "Tempranillo":
SELECT b.nombre, v.nombre
FROM bodegas b
	JOIN vinos v ON b.bodega_id = v.bodega_id
	JOIN vinos_uvas vu ON v.vino_id = vu.vino_id
	JOIN uvas u ON vu.uva_id = u.uva_id
WHERE u.nombre = 'Tempranillo'
;

-- Total de cosechas por crianza:
SELECT c.vino_id, COUNT(*) 
FROM cosechas c
	JOIN crianzas cr ON c.vino_id = cr.vino_id
GROUP BY c.vino_id
;

-- Nombre del vino joven con más grados:
SELECT v.nombre, MAX(v.grados)
	FROM vinos v 
		JOIN jovenes j ON v.vino_id	 = j.vino_id
;

-- Contar cuántas cosechas "Excelente" ha tenido cada vino:
SELECT v.nombre, COUNT(*)
FROM vinos v
	JOIN cosechas c ON v.vino_id = c.vino_id
	-- WHERE c.calidad = 'Excelente'
GROUP BY v.nombre
;
