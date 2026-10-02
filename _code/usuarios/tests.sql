-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Pruebas de aceptación para la BD de Users
-- 
USE UsersDB;

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

-- =============================================================
-- TESTS NEGATIVOS (PA03 - PA05, RN01 - RN02)
-- =============================================================

CREATE OR REPLACE PROCEDURE p_test_rn01_minimum_age()
BEGIN
    DECLARE EXIT HANDLER FOR 4025
        CALL p_log_test('RN01', 'RN01: Se rechazan usuarios menores de edad', 'PASS');
    DECLARE EXIT HANDLER FOR SQLSTATE '45000'
        CALL p_log_test('RN01', 'RN01: Se rechazan usuarios menores de edad', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'ERROR: No se produjo el error esperado para la edad mínima', 'ERROR');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Usuario Menor', 'MASCULINO', 17, 'menor@example.com');

    CALL p_log_test('RN01', 'ERROR: Se permitió registrar un usuario menor de edad', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn02_unique_email()
BEGIN
    DECLARE EXIT HANDLER FOR 1062
        CALL p_log_test('RN02', 'RN02: Se rechazan emails duplicados', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'ERROR: No se produjo el error esperado para el email duplicado', 'ERROR');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Correo Duplicado', 'FEMENINO', 30, 'druiz@us.es');

    CALL p_log_test('RN02', 'ERROR: Se permitió duplicar un email', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_pa03_required_name()
BEGIN
    DECLARE EXIT HANDLER FOR 1048
        CALL p_log_test('PA03', 'PA03: Se rechaza un usuario sin nombre', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('PA03', 'ERROR: No se produjo el error esperado para el nombre', 'ERROR');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES (NULL, 'MASCULINO', 30, 'sin-nombre@example.com');

    CALL p_log_test('PA03', 'ERROR: Se permitió insertar un usuario sin nombre', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_pa04_required_age()
BEGIN
    DECLARE EXIT HANDLER FOR 1048
        CALL p_log_test('PA04', 'PA04: Se rechaza un usuario sin edad', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('PA04', 'ERROR: No se produjo el error esperado para la edad', 'ERROR');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Usuario Sin Edad', 'MASCULINO', NULL, 'sin-edad@example.com');

    CALL p_log_test('PA04', 'ERROR: Se permitió insertar un usuario sin edad', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_pa05_required_email()
BEGIN
    DECLARE EXIT HANDLER FOR 1048
        CALL p_log_test('PA05', 'PA05: Se rechaza un usuario sin email', 'PASS');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('PA05', 'ERROR: No se produjo el error esperado para el email', 'ERROR');

    CALL p_populate();

    INSERT INTO users (full_name, gender, age, email)
        VALUES ('Usuario Sin Email', 'MASCULINO', 30, NULL);

    CALL p_log_test('PA05', 'ERROR: Se permitió insertar un usuario sin email', 'FAIL');
END //

-- =============================================================
-- ORQUESTADOR
-- =============================================================
CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL p_log_test('POPULATE', 'ERROR: Falló la preparación de la suite de aceptación.', 'ERROR');
        SELECT * FROM test_results ORDER BY execution_time, test_id;
        SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
    END;

    DELETE FROM test_results;

    CALL p_populate();

    CALL p_test_pa03_required_name();
    CALL p_test_pa04_required_age();
    CALL p_test_pa05_required_email();
    CALL p_test_rn01_minimum_age();
    CALL p_test_rn02_unique_email();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_tests();
