-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Función para obtener el dominio de un email
-- 

USE UsersDB;

-- Cálculo del dominio en SQL: https://stackoverflow.com/questions/2628138/how-to-select-domain-name-from-email-address
DELIMITER //
CREATE OR REPLACE FUNCTION f_get_email_domain(p_email VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN SUBSTRING_INDEX(SUBSTR(p_email, INSTR(p_email, '@') + 1), ' ', 1);
END //
DELIMITER ;
