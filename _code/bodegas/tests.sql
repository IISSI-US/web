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
-- TESTS (RN01 - RN05)
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
        CALL p_log_test('RN02A', 'RN02: El vino joven pasa menos de seis meses en barrica', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Vino Joven Invalido', 12.0);

    INSERT INTO young_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, 6, 0);

    CALL p_log_test('RN02', 'ERROR: Se permitió un vino joven con demasiados meses en barrica', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_negative_months()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02B', 'RN02: Los meses de maduración no pueden ser negativos', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Vino Joven Meses Negativos', 12.0);

    INSERT INTO young_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, -1, 1);

    CALL p_log_test('RN02B', 'ERROR: Se permitió un tiempo negativo en barrica', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_young_negative_bottle_months()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02E', 'RN02: Los meses en botella de un Joven no pueden ser negativos', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Vino Joven Botella Negativa', 12.0);

    INSERT INTO young_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, 0, -1);

    CALL p_log_test('RN02E', 'ERROR: Se permitió un tiempo negativo en botella', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_aged_limits()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02C', 'RN02: La barrica de una Crianza dura entre seis y doce meses', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Crianza Barrica Fuera Rango', 12.0);

    INSERT INTO aged_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, 13, 11);

    CALL p_log_test('RN02C', 'ERROR: Se permitió una Crianza con trece meses en barrica', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_aged_lower_barrel_limit()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02F', 'RN02: Una Crianza debe pasar al menos seis meses en barrica', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Crianza Barrica Bajo Minimo', 12.0);

    INSERT INTO aged_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, 5, 19);

    CALL p_log_test('RN02F', 'ERROR: Se permitió una Crianza con cinco meses en barrica', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_aged_negative_barrel_months()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02H', 'RN02: Los meses en barrica de una Crianza no pueden ser negativos', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Crianza Barrica Negativa', 12.0);

    INSERT INTO aged_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, -1, 25);

    CALL p_log_test('RN02H', 'ERROR: Se permitió un tiempo negativo en barrica de Crianza', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_aged_total_minimum()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02D', 'RN02: Una Crianza dura al menos veinticuatro meses', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Crianza Tiempo Insuficiente', 12.0);

    INSERT INTO aged_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, 6, 17);

    CALL p_log_test('RN02D', 'ERROR: Se permitió una Crianza de menos de veinticuatro meses', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_aged_negative_months()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02G', 'RN02: Los meses de Crianza no pueden ser negativos', 'PASS');

    CALL p_populate();

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent)
    VALUES (20, 1, 'Crianza Meses Negativos', 12.0);

    INSERT INTO aged_wines (wine_id, barrel_months, bottle_months)
    VALUES (20, 12, -1);

    CALL p_log_test('RN02G', 'ERROR: Se permitió un tiempo negativo en botella', 'FAIL');
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
    VALUES (10, 3, 2020, 'Buena');

    CALL p_log_test('RN04', 'ERROR: Se permitió duplicar cosecha de un vino para el mismo año', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_harvest_only_for_aged_wines()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN04B', 'RN04: Las cosechas solo corresponden a Crianzas', 'PASS');

    CALL p_populate();

    INSERT INTO harvests (wine_id, harvest_year, quality)
    VALUES (1, 2021, 'Buena');

    CALL p_log_test('RN04B', 'ERROR: Se permitió asignar cosecha a un vino Joven', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn05_subtype_disjoint()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN05', 'RN05: Un vino no puede ser Joven y Crianza a la vez', 'PASS');

    CALL p_populate();

    INSERT INTO aged_wines (wine_id, barrel_months, bottle_months)
    VALUES (1, 6, 18);

    CALL p_log_test('RN05', 'ERROR: Se permitió clasificar un Vino como Joven y Crianza', 'FAIL');
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
    CALL p_test_rn02_negative_months();
    CALL p_test_rn02_young_negative_bottle_months();
    CALL p_test_rn02_aged_limits();
    CALL p_test_rn02_aged_lower_barrel_limit();
    CALL p_test_rn02_aged_negative_barrel_months();
    CALL p_test_rn02_aged_total_minimum();
    CALL p_test_rn02_aged_negative_months();
    CALL p_test_rn03_alcohol_range();
    CALL p_test_rn04_harvest_per_year();
    CALL p_test_rn04_harvest_only_for_aged_wines();
    CALL p_test_rn05_subtype_disjoint();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_tests();
