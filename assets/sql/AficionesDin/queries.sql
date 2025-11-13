-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Consultas para implementar los RFs del ejercicio de Usuarios
-- 

-- RF3: Listado de usuarios con sus aficiones:
SELECT u.usuarioId, ua.aficionId, u.nombre, u.edad, u.email, a.aficion
FROM Usuarios u JOIN UsuariosAficiones ua JOIN Aficiones a 
	ON u.usuarioId = ua.usuarioId AND
	   ua.aficionId = a.aficionId
;
-- creamos una vista de esta consulta porque la vamos a usar a continuación
CREATE OR REPLACE VIEW vUsuariosAficiones AS
	SELECT u.usuarioId, ua.aficionId, u.nombre, u.edad, u.email, a.aficion
	FROM Usuarios u JOIN UsuariosAficiones ua JOIN Aficiones a 
		ON u.usuarioId = ua.usuarioId AND
		   ua.aficionId = a.aficionId
;

-- Usuarios a los que le gusta el cine:
SELECT ua.nombre, ua.edad, ua.email, ua.aficion
	FROM vUsuariosAficiones ua
	WHERE aficion like '%cine%'
;

-- Usuarios que no tienen aficiones:
SELECT *
	FROM Usuarios u
	WHERE NOT EXISTS (
		SELECT * 
			FROM UsuariosAficiones ua
			WHERE u.usuarioId = ua.usuarioId
	)
;

-- Número de aficiones de cada usuario:
SELECT usuarioId, nombre, email, COUNT(*) total
	FROM vUsuariosAficiones
	GROUP BY usuarioId
;
-- Creamos una vista de esta consulta porque la vamos a usar a continuación
CREATE OR REPLACE VIEW vNumAficionesUsuario AS
	SELECT usuarioId, nombre, email, COUNT(*) total
		FROM vUsuariosAficiones
		GROUP BY usuarioId
;

-- Máximo número de aficiones que tiene un usuario:
SELECT MAX(total) maxAficiones
	FROM vNumAficionesUsuario
;

-- Usuarios con el máximo número de aficiones:
SELECT *
	FROM vNumAficionesUsuario
	WHERE total = (
		SELECT MAX(total) maxAficiones
			FROM vNumAficionesUsuario
	)
;
