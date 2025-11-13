-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Consultas para implemtar ejemplos de álgebra relacional
-- 

-- Personas que adoptan animales:
SELECT DISTINCT p.nombre
FROM Personas p
	JOIN Adopciones a ON p.personaId = a.personaId
;

-- Personas que entregan animales (abandonados o no):
SELECT DISTINCT p.nombre
FROM Personas p
	JOIN Ingresos i ON p.personaId = i.personaId
	JOIN Entregas e ON i.ingresoId = e.ingresoId
;

-- Personas que entregan animales abandonados:
SELECT DISTINCT p.nombre
FROM Personas p
	JOIN Ingresos i ON p.personaId = i.personaId
	JOIN Abandonos a ON i.ingresoId = a.ingresoId
;

-- Adopciones realizadas en el mes de octubre:
SELECT *
FROM Adopciones a
WHERE EXTRACT(MONTH FROM a.fechaHoraAdopcion) = 10;

-- Número de adopciones realizadas por especie:
SELECT e.especieId, e.especie, COUNT(*) AS numAdopciones
FROM Adopciones ad
	JOIN Animales am ON ad.animalId = am.animalId
	JOIN Razas r ON r.razaId = am.razaId
	JOIN Especies e ON e.especieId = r.especieId
GROUP BY e.especieId;

