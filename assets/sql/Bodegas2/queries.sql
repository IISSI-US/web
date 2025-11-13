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

-- Vista auxiliar con todos los vinos
CREATE OR REPLACE VIEW v_vinos AS 
	SELECT j.joven_id vino_id, j.bodega_id, j.nombre, j.grados  
	FROM jovenes j
	UNION
	SELECT c.crianza_id vino_id, c.bodega_id, c.nombre, c.grados 
	FROM crianzas c
;

-- Listado de vinos con sus uvas:
SELECT v.nombre, u.nombre
FROM v_vinos v JOIN vinos_uvas vu 
	ON	(v.vino_id = vu.joven_id OR v.vino_id = vu.crianza_id) JOIN uvas u
	ON u.uva_id = vu.uva_id
ORDER BY v.nombre
;

-- Vinos con sus cosechas (crianza):
SELECT *
FROM crianzas c JOIN cosechas co 
	ON c.crianza_id = co.crianza_id
;

-- Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas:
SELECT DISTINCT b.nombre 
FROM bodegas b	JOIN v_vinos v 
	ON b.bodega_id = v.bodega_id 
;

-- Nombre de las bodegas y vinos que están compuestos, al menos, con uva "Tempranillo":
SELECT v.vino_id, b.nombre nombre_bodega, v.nombre nombre_vino
FROM bodegas b JOIN v_vinos v
	ON	b.bodega_id=v.bodega_id JOIN vinos_uvas vu 
	ON (v.vino_id = vu.joven_id OR v.vino_id = vu.crianza_id) JOIN uvas u
	ON vu.uva_id = u.uva_id
WHERE 
	u.nombre = 'Tempranillo'
ORDER by b.nombre
;

-- Total de cosechas pr crianza:
SELECT c.crianza_id, COUNT(*)
FROM cosechas c JOIN crianzas cr 
	ON c.crianza_id = cr.crianza_id
GROUP BY c.crianza_id
;

-- Nombre del vino joven con más grados:
SELECT j.nombre, MAX(j.grados)
	FROM jovenes j 
;

-- Contar cuántas cosechas "Excelente" ha tenido cada vino:
SELECT c.crianza_id, c.nombre, COUNT(*)
FROM crianzas c JOIN cosechas co 
	ON c.crianza_id = co.crianza_id
WHERE co.calidad = 'Excelente'
GROUP BY c.nombre
;
