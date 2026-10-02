-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Tests negativos para la BD de Aficiones Dinámicas
-- 
USE HobbiesNMDB;

-- =============================================================
-- TABLA DE RESULTADOS
-- =============================================================
CREATE OR REPLACE TABLE test_results (
    test_id VARCHAR(20) PRIMARY KEY,
    test_name VARCHAR(200) NOT NULL,
    test_message VARCHAR(500) NOT NULL,
    test_status ENUM('PASS','FAIL','ERROR') NOT NULL,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- PROCEDIMIENTO AUXILIAR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
    IN p_test_id VARCHAR(20),
    IN p_message VARCHAR(500),
    IN p_status ENUM('PASS','FAIL','ERROR')
)
BEGIN
    INSERT INTO test_results(test_id, test_name, test_message, test_status)
    VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;

-- =============================================================
-- TESTS (RN01 - RN03 + FK)
-- =============================================================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_age_adult()
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
        CALL p_log_test('RN01', 'RN01: Edad mínima 18 años', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'ERROR: No se produjo el error esperado para la edad mínima', 'ERROR');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Usuario Menor', 'MASCULINO', 17, 'menor@ejemplo.com');

    CALL p_log_test('RN01', 'ERROR: Se permitió un usuario menor de edad', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_unique_email()
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
        CALL p_log_test('RN02', 'RN02: Email debe ser único', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'ERROR: No se produjo el error esperado para el email duplicado', 'ERROR');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Correo Duplicado', 'FEMENINO', 30, 'druiz@us.es');

    CALL p_log_test('RN02', 'ERROR: Se permitió duplicar un email', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_unique_hobby_per_user()
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
        CALL p_log_test('RN03', 'RN03: No se pueden repetir aficiones por usuario', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'ERROR: No se produjo el error esperado para la afición repetida', 'ERROR');

    CALL p_populate();

    INSERT INTO user_hobby_links (user_id, hobby_id) VALUES (1, 3);

    CALL p_log_test('RN03', 'ERROR: Se permitió repetir afición para el mismo usuario', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_fk_user_exists()
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
        CALL p_log_test('FK01', 'FK01: user_id debe existir', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('FK01', 'ERROR: No se produjo el error esperado para user_id', 'ERROR');

    CALL p_populate();

    INSERT INTO user_hobby_links (user_id, hobby_id) VALUES (999, 1);

    CALL p_log_test('FK01', 'ERROR: Se permitió FK user_id inexistente', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_fk_hobby_exists()
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
        CALL p_log_test('FK02', 'FK02: hobby_id debe existir', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('FK02', 'ERROR: No se produjo el error esperado para hobby_id', 'ERROR');

    CALL p_populate();

    INSERT INTO user_hobby_links (user_id, hobby_id) VALUES (1, 999);

    CALL p_log_test('FK02', 'ERROR: Se permitió FK hobby_id inexistente', 'FAIL');
END //
DELIMITER ;

-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
    -- Restaurar la población positiva antes de ejecutar los casos negativos.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL p_log_test('POPULATE', 'ERROR: El populate falló. No se ejecutaron los tests negativos.', 'ERROR');
        SELECT * FROM test_results ORDER BY execution_time, test_id;
        SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
    END;

    DELETE FROM test_results;

    CALL p_populate();

    CALL p_test_rn01_age_adult();
    CALL p_test_rn02_unique_email();
    CALL p_test_rn03_unique_hobby_per_user();
    CALL p_test_fk_user_exists();
    CALL p_test_fk_hobby_exists();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_tests();