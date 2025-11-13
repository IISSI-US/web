--
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Función para obtener el dominio de un email
--
 
-- cálculo del dominio en SQL: https://stackoverflow.com/questions/2628138/how-to-
-- select-domain-name-from-email-address
DELIMITER //
	CREATE OR REPLACE FUNCTION fEmailDomain(email VARCHAR(64)) 
	RETURNS VARCHAR(64)
	BEGIN
	 	RETURN SUBSTRING_INDEX(SUBSTR(email, INSTR(email, '@') + 1),' ',1);
	END //
DELIMITER ;