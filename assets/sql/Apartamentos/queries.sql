-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Consultas para implementar AR de Apartamentos
-- 

-- Vistas Auxiliares
CREATE OR REPLACE VIEW vPropietarios as
	SELECT * 
		FROM Usuarios u
		WHERE u.esPropietario = TRUE
;

CREATE OR REPLACE VIEW vHuespedes as
	SELECT * 
		FROM Usuarios u
		WHERE u.esHuesped = TRUE
;

-- Listado de alojamientos con sus propietarios y zona turística:
SELECT  *
FROM  Alojamientos a, vPropietarios p, ZonasTuristicas z
WHERE a.propietarioId = p.usuarioId AND  a.zonaId = z.zonaId;

-- Mejor haciendo uso de Joins
SELECT *
FROM Alojamientos a 
   JOIN vPropietarios p ON a.propietarioId = p.usuarioId
	JOIN ZonasTuristicas z ON a.zonaId = z.zonaId;

-- Listado de alojamientos con sus fotos:
SELECT *
FROM Alojamientos a 
	JOIN Fotos f ON a.alojamientoId = f.alojamientoId
;
	
-- Listado de alojamientos con sus servicios:
SELECT *
FROM Alojamientos a 
	JOIN Servicios s ON a.alojamientoId = s.alojamientoId
;

-- Listado de alojamientos con sus reservas:
SELECT *
FROM Alojamientos a 
	JOIN Reservas r ON a.alojamientoId = r.alojamientoId
;

-- Listado de alojamientos con sus propietarios, zona turística, fotos, servicios y reservas:
SELECT *
FROM vPropietarios p 
	JOIN Alojamientos a ON p.usuarioId = a.propietarioId
	JOIN ZonasTuristicas z ON a.zonaId = z.zonaId
	JOIN Servicios s ON a.alojamientoId = s.alojamientoId
	JOIN Fotos f ON a.alojamientoId = f.alojamientoId
;

-- Listado de alojamientos con piscina:
SELECT *
FROM Alojamientos a
	JOIN Servicios s ON a.alojamientoId = s.alojamientoId
	AND s.tipoServicio = 'Piscina' AND s.disponible = true
;

-- Listado de reservas de alojamientos de la Costa del Sol:
SELECT *
FROM Alojamientos a
	JOIN ZonasTuristicas z ON z.zonaId = a.zonaId
	AND z.zona = 'Costa del Sol'
;
-- Obtener el número de dormitorios y banos de los alojamientos que tienen Wifi disponible:   
SELECT  a.numDormitorios, a.numBaños
FROM Alojamientos a
	JOIN Servicios s ON a.alojamientoId = s.alojamientoId
	AND s.tipoServicio = 'Wifi' AND s.disponible = true
;

-- Obtener los nombres de los propietarios que tienen alojamientos en una zona turística específica (por ejemplo, zona = 'Sierra Nevada'):
SELECT DISTINCT p.nombre, p.apellidos
FROM vPropietarios p
	JOIN Alojamientos a ON p.usuarioId = a.propietarioId
	JOIN ZonasTuristicas z ON a.zonaId = z.zonaId
	AND z.zona = 'Sierra Nevada'
;

-- Obtener los alojamientos con valoraciones mayores o iguales a 4:
SELECT *
FROM Alojamientos a
	JOIN Reservas r ON a.alojamientoId = r.alojamientoId
	AND r.valoracion >=4
;
	
-- Obtener el número total de servicios por alojamiento:
SELECT alojamientoId, COUNT(*) AS totalServicios
FROM Servicios
GROUP BY alojamientoId
;

-- Obtener la valoración promedio de todos los alojamientos:
SELECT AVG(valoracion) AS valoracionPromedio
FROM Alojamientos a
	JOIN Reservas r ON r.alojamientoId = a.alojamientoId
;

-- Obtener el número de alojamientos por zona turística:
SELECT zonaId, COUNT(*) AS numeroAlojamientos
FROM Alojamientos a
GROUP BY zonaId;

-- Obtener el número total de servicios por alojamiento:
SELECT alojamientoId, COUNT(*) AS totalServicios
FROM Servicios
GROUP BY alojamientoId;

-- Obtener el número total de fotos por alojamiento:
SELECT a.alojamientoId, COUNT(*) AS totalFotos
FROM Fotos f
	JOIN Alojamientos a ON f.alojamientoId = a.alojamientoId
GROUP BY a.alojamientoId;

-- Obtener el número de reservas realizadas por cada huésped:
SELECT h.usuarioId, COUNT(*) AS totalReservas
FROM Reservas r
	JOIN vHuespedes h ON r.huespedId = h.usuarioId
GROUP BY h.usuarioId;

-- Obtener la fecha de compra más antigua (primera propiedad adquirida) entre todos los propietarios:
SELECT MIN(fCompra) AS fechaCompraMasAntigua
FROM vPropietarios
;
    


