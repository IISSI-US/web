--
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Función para calcular la edad a partir de una fecha
--
 
DELIMITER //
	CREATE OR REPLACE FUNCTION fGetAge(birthDate DATE) 
	RETURNS INT
	BEGIN
		DECLARE age INT;
		SET age = (SELECT TIMESTAMPDIFF(YEAR, birthDate, CURDATE()));
	 	RETURN age ;
	END //
DELIMITER ;
