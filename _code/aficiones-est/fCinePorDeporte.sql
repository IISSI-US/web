-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Función para cambiar CINE por DEPORTE de un usuario
-- 

USE HobbiesStaticDB;

DELIMITER //
CREATE OR REPLACE FUNCTION f_cine_por_deporte(p_user_id INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    UPDATE user_hobbies
    SET hobby = 'DEPORTE'
    WHERE hobby = 'CINE'
      AND user_id = p_user_id;

    RETURN CONCAT('Aficiones CINE cambiadas a DEPORTE para el usuario ', p_user_id);
END //
DELIMITER ;
