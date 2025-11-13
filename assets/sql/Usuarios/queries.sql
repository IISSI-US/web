-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Consultas para implementar los RFs del ejercicio de Usuarios
-- 


-- RF-1: Usuarios ordenados por nombre de la A-Z
SELECT *
	FROM Usuarios
	ORDER BY nombre ASC
;

-- RF-1: Nombre y correo de los usuarios de género femenino. 
SELECT nombre, email
	FROM Usuarios
	WHERE genero='FEMENINO'
;

-- RF-1: Nombre, edad y correo de los usuarios con dominio 'us.es'.
SELECT nombre, edad, email
	FROM Usuarios
	WHERE email LIKE '%@us.es'
;

-- RF-1: Edad media y total de usuarios.
SELECT AVG(edad) mediaTotal, COUNT(*) total
	FROM Usuarios
;

-- RF-1: Edad media y total de los usuarios con dominio 'us.es'.
SELECT AVG(edad) mediaUS, COUNT(*) totalUS
	FROM Usuarios
	WHERE email LIKE '%@us.es'
;

-- RF-2: Edad media de los usuarios según el género.
SELECT genero, AVG(edad) media
	FROM Usuarios
	GROUP BY genero
;

-- RF-2: Número de usuarios según el género.
SELECT genero, COUNT(*) total
	FROM Usuarios
	GROUP BY genero
;

-- RF-2: Edad media de los usuarios según el género.
SELECT genero, AVG(edad) mediaEdad
	FROM Usuarios
	GROUP BY genero
;

-- RF-2: Total de usuarios según el género.
SELECT genero, COUNT(*) total
	FROM Usuarios
	GROUP BY genero
;

-- RF-2: Edad media y total de usuarios según el dominio de su correo electrónico.
SELECT AVG(edad), COUNT(*), SUBSTRING_INDEX(
		SUBSTR(email, INSTR(email, '@') + 1),' ',1) dominio
	FROM Usuarios
	GROUP BY dominio
; -- cálculo del dominio en SQL: https://stackoverflow.com/questions/2628138/how-to-
  -- select-domain-name-from-email-address

-- RF-2: Usuarios de mayor edad
-- Opción 1: devuelve todos los usuarios con edad máxima
SELECT *
	FROM Usuarios
	WHERE edad = (
		SELECT MAX(edad) FROM Usuarios
	)
;

-- Opción 2: devuelve sólo un usuario
SELECT *
	FROM Usuarios
	ORDER BY edad DESC 
	LIMIT 1;
	
-- RF-2: Usuario de mayor edad según el género
SELECT * 
	FROM Usuarios u1 
	WHERE edad = (
		SELECT MAX(u2.edad)
			FROM Usuarios u2
			WHERE u1.genero=u2.genero
	)
;


