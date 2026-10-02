-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Tests negativos para la BD de Bodegas
-- 
USE BodegasDB;

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
-- TESTS (RN01 - RN04)
-- =============================================================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_unique_winery()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'RN01: Los nombres de bodegas deben ser únicos', 'PASS');

    CALL p_populate();

    INSERT INTO wineries (winery_id, winery_name, origin_designation)
    VALUES (10, 'Bodegas El Sol', 'Rioja');

    CALL p_log_test('RN01', 'ERROR: Se permitió duplicar el nombre de una bodega', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_young_limits()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: Los vinos jóvenes respetan los límites de meses', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Vino Joven Invalido', 12.0);

    INSERT INTO young_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, 8, 10);

    CALL p_log_test('RN02', 'ERROR: Se permitió un vino joven con demasiados meses en barrica', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_alcohol_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: La graduación alcohólica debe estar entre 10 y 15', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (30, 1, 'Vino Fuera Rango', 9.0);

    CALL p_log_test('RN03', 'ERROR: Se permitió una graduación alcohólica fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_harvest_per_year()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN04', 'RN04: Solo una cosecha por vino y año', 'PASS');

    CALL p_populate();

    INSERT INTO harvests (harvest_id, wine_id, harvest_year, quality)
    VALUES (10, 3, 2020, 'Duplicada');

    CALL p_log_test('RN04', 'ERROR: Se permitió duplicar cosecha de un vino para el mismo año', 'FAIL');
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

    CALL p_test_rn01_unique_winery();
    CALL p_test_rn02_young_limits();
    CALL p_test_rn03_alcohol_range();
    CALL p_test_rn04_harvest_per_year();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_tests();
