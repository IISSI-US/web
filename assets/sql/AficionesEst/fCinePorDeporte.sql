-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: función para cambiar CINE por DEPORTE de todos los Usuarios
-- 

DELIMITER //
CREATE OR REPLACE FUNCTION fCinePorDeporte(usuarioId INT)
	RETURNS VARCHAR(255)

	BEGIN
		DECLARE mensaje VARCHAR(255);
		
		-- Actualizar las aficiones de CINE a DEPORTE
		UPDATE Aficiones a
		SET a.aficion = 'DEPORTE'
		WHERE a.aficion = 'CINE' AND a.usuarioId = usuarioId;
		
		-- Mensaje de confirmación
		SET mensaje = CONCAT('Aficiones de tipo CINE modificadas a DEPORTE para el usuario con ID: ', usuarioId);
		RETURN mensaje;
	END;
//

DELIMITER ;

-- Llamada para ejecutar la función
SELECT modificarAficiones(4);
-- Qué ocurre si se intenta hacer el cambio en 1,2 o 3
