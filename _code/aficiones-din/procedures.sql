-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Procedimientos y funciones para Aficiones Dinámicas
-- 

USE HobbiesDynamicDB;

-- Insertar usuario
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_user(
    IN p_full_name VARCHAR(64),
    IN p_gender ENUM('MASCULINO','FEMENINO','OTRO'),
    IN p_age INT,
    IN p_email VARCHAR(255)
)
BEGIN
    INSERT INTO users (full_name, gender, age, email)
    VALUES (p_full_name, p_gender, p_age, p_email);
END //
DELIMITER ;

-- Insertar usuario y afición en una transacción
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_user_with_hobby(
    IN p_full_name VARCHAR(64),
    IN p_gender ENUM('MASCULINO','FEMENINO','OTRO'),
    IN p_age INT,
    IN p_email VARCHAR(255),
    IN p_hobby_name VARCHAR(128)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_hobby_id INT;

    CALL p_insert_user(p_full_name, p_gender, p_age, p_email);
    SET v_user_id = LAST_INSERT_ID();

    INSERT INTO hobbies (hobby_name) VALUES (p_hobby_name);
    SET v_hobby_id = LAST_INSERT_ID();

    INSERT INTO user_hobby_links (user_id, hobby_id) VALUES (v_user_id, v_hobby_id);
END //
DELIMITER ;

-- Versión transaccional
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_user_with_hobby_tx(
    IN p_full_name VARCHAR(64),
    IN p_gender ENUM('MASCULINO','FEMENINO','OTRO'),
    IN p_age INT,
    IN p_email VARCHAR(255),
    IN p_hobby_name VARCHAR(128)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en inserción de usuario/afición';
    END;

    START TRANSACTION;
        CALL p_insert_user_with_hobby(p_full_name, p_gender, p_age, p_email, p_hobby_name);
    COMMIT;
END //
DELIMITER ;
