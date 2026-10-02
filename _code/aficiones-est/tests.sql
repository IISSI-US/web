-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Tests negativos para la BD de Aficiones Estáticas
-- 
USE HobbiesStaticDB;

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
-- TESTS (RN01 - RN03)
-- =============================================================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_age_adult()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'RN01: Edad mínima 18 años', 'PASS');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Usuario Menor', 'MASCULINO', 17, 'menor@ejemplo.com');

    CALL p_log_test('RN01', 'ERROR: Se permitió un usuario menor de edad', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_unique_email()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: Email debe ser único', 'PASS');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Correo Duplicado', 'FEMENINO', 30, 'druiz@us.es');

    CALL p_log_test('RN02', 'ERROR: Se permitió duplicar un email', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_unique_hobby_per_user()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: No se pueden repetir aficiones por usuario', 'PASS');

    CALL p_populate();

    INSERT INTO user_hobbies (user_id, hobby) VALUES (1, 'DEPORTE');

    CALL p_log_test('RN03', 'ERROR: Se permitió repetir afición para el mismo usuario', 'FAIL');
END //
DELIMITER ;

-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
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

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

call p_run_tests();