-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Trigger para validar la edad mínima de los usuarios
-- 

USE UsersDB;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bi_users_rn01
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.age < 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN01: Los usuarios deben ser mayores de edad';
    END IF;
END //
DELIMITER ;
