--
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Consultas para implementar los RFs del ejercicio de Usuarios2
--

-- Tenemos dos opciones:
-- A.- Usar la función definida para calcular la edad
-- B.- Usar una vista de la tabla usuarios con la edad calculada

-- Ejemplo con la opción A
-- RF-1: Nombre, edad y correo de los usuarios con dominio 'us.es'.
SELECT nombre, fGetAge(fechaNacimiento) edad, email
	FROM Usuarios
	WHERE email LIKE '%@us.es'
;

-- Ejemplo con la opción B
CREATE OR REPLACE VIEW vUsuariosEdad AS
	SELECT *, fGetAge(fechaNacimiento) edad
		FROM Usuarios
;
		
SELECT nombre, edad, email
	FROM vUsuariosEdad
	WHERE email LIKE '%@us.es'
;

-- RF-2: Edad media y total de usuarios según el dominio de su correo electrónico.
SELECT AVG(edad), COUNT(*), fEmailDomain(email) dominio
	FROM vUsuariosEdad
	GROUP BY dominio
; 
