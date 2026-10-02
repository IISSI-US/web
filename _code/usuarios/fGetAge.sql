-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Función auxiliar para calcular la edad a partir de una fecha
-- 

USE UsersDB;

DELIMITER //
CREATE OR REPLACE FUNCTION f_get_age(p_birth_date DATE)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_birth_date, CURDATE());
END //
DELIMITER ;
