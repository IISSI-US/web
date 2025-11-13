-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script con las consultas
-- 

-- Precios por zonas y tipo de espectáculos:
SELECT p.precioId, z.zonaId, t.tipoEspectaculoId, z.nombreZona, t.tipo, p.precio
FROM Precios p JOIN Zonas z 
	ON z.zonaId = p.zonaId JOIN TiposEspectaculos t
	ON t.tipoEspectaculoId = p.tipoEspectaculoId
;

-- Localidades disponibles por Zonas:
SELECT z.zonaId, l.localidadId, z.nombreZona, l.numFila, l.numButaca
FROM Localidades l JOIN Zonas z
	ON z.zonaId = l.zonaId
;

-- Precio de las localidades por Zonas y tipo de espectáculo:
-- CREATE OR REPLACE VIEW vPrecioZonaLocalidades as
SELECT p.precioId, z.zonaId, t.tipoEspectaculoId, l.localidadId, p.precio, z.nombreZona, t.tipo, l.numFila, l.numButaca
FROM Precios p JOIN Zonas z 
	ON z.zonaId = p.zonaId JOIN TiposEspectaculos t
	ON t.tipoEspectaculoId = p.tipoEspectaculoId JOIN 	Localidades l 
	ON z.zonaId = l.zonaId
;

-- Número de entradas vendidas por representación:
SELECT r.representacionId, COUNT(*) numEntradas
FROM Entradas e JOIN Representaciones r
	ON r.representacionId = e.representacionId
GROUP BY r.representacionId
;

-- Representaciones que tienen los espectáculos:
SELECT r.representacionId, e.espectaculoId, e.nombre, r.fechaHoraInicio, e.duracion
FROM Representaciones r JOIN Espectaculos e
	ON e.espectaculoId = r.espectaculoId
;

-- Número de representaciones que tienen los espectáculos:
SELECT e.espectaculoId, COUNT(*)
FROM Representaciones r JOIN Espectaculos e
	ON e.espectaculoId = r.espectaculoId
GROUP BY e.espectaculoId
;

-- Total recaudado en cada representación:
SELECT e.representacionId, SUM(e.pCompra)
FROM Entradas e
GROUP BY e.representacionId
;

-- Número de localidades vendidas para la representación 'r3':
SELECT COUNT(*)
FROM Entradas e
WHERE e.representacionId = 3
;

-- Entradas por invitación de todas las representaciones agrupadas por espectáculo:
SELECT es.espectaculoId, COUNT(*)
FROM Entradas en JOIN Representaciones r 
	ON en.representacionId = r.representacionId JOIN Espectaculos es
	ON es.espectaculoId = r.espectaculoId
WHERE en.canal = 'Invitacion'
GROUP BY es.espectaculoId
;

