-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Implementar los RFs del ejercicio de Aficiones estático
-- 

-- RF3: Listado de usuarios con sus aficiones:
SELECT u.usuarioId, a.aficionId, u.nombre, u.edad, u.email, a.aficion
FROM Usuarios u JOIN Aficiones a 
	ON u.usuarioId = a.usuarioId
;
-- creamos una vista de esta consulta porque la vamos a usar a continuación
CREATE OR REPLACE VIEW vUsuariosAficiones AS
	SELECT u.usuarioId, a.aficionId, u.nombre, u.edad, u.email, a.aficion
	FROM Usuarios u JOIN Aficiones a 
		ON u.usuarioId = a.usuarioId
;

-- RF3: Usuarios a los que le gusta el cine:
SELECT nombre, edad, email
	FROM vUsuariosAficiones
	WHERE aficion = 'CINE'
;

-- RF3: Usuarios que no tienen aficiones:
SELECT *
	FROM Usuarios u
	WHERE NOT EXISTS (
		SELECT * 
			FROM Aficiones a
			WHERE u.usuarioId = a.usuarioId
	)
;

-- Otra solución más simple con left join:
SELECT u.usuarioId, a.aficionId, u.nombre, u.genero, u.edad, u.email, a.aficion
	FROM Usuarios u LEFT JOIN Aficiones a 
		ON u.usuarioId = a.usuarioId
	WHERE a.aficionId IS NULL
;
-- RF3: Número de aficiones de cada usuario:
SELECT usuarioId, nombre, email, COUNT(*) total
	FROM vUsuariosAficiones
	GROUP BY usuarioId
;
-- creamos una vista de esta consulta porque la vamos a usar a continuación
CREATE OR REPLACE VIEW vNumAficionesUsuario AS
	SELECT usuarioId, nombre, email, COUNT(*) total
		FROM vUsuariosAficiones
		GROUP BY usuarioId
;

-- RF3: Máximo número de aficiones que tiene un usuario:
SELECT MAX(total) maxAficiones
	FROM vNumAficionesUsuario
;

-- RF3: Usuarios con el máximo número de aficiones:
SELECT *
	FROM vNumAficionesUsuario
	WHERE total = (
		SELECT MAX(total) maxAficiones
			FROM vNumAficionesUsuario
	)
;