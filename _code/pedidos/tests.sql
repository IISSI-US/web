-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2025
-- Descripción: Tests negativos para la BD de Pedidos
-- 
USE OrdersDB;

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
CREATE OR REPLACE PROCEDURE p_test_rn01_daily_order_limit()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'RN01: No se permiten más de tres pedidos por usuario y día', 'PASS');

    CALL p_populate();

    INSERT INTO orders (user_id, product_id, amount, purchase_date)
        VALUES (1, 1, 1, '2019-05-13');

    CALL p_log_test('RN01', 'ERROR: Se permitió un cuarto pedido diario', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_august_forbidden()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: No se permiten compras en agosto', 'PASS');

    CALL p_populate();

    INSERT INTO orders (user_id, product_id, amount, purchase_date)
        VALUES (1, 1, 2, '2019-08-10');

    CALL p_log_test('RN02', 'ERROR: Se permitió realizar un pedido en agosto', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_available_stock()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: Se rechazan pedidos sin stock suficiente', 'PASS');

    CALL p_populate();

    INSERT INTO orders (user_id, product_id, amount, purchase_date)
        VALUES (1, 7, 1, CURDATE());

    CALL p_log_test('RN03', 'ERROR: Se permitió pedir un producto sin stock', 'FAIL');
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

    CALL p_test_rn01_daily_order_limit();
    CALL p_test_rn02_august_forbidden();
    CALL p_test_rn03_available_stock();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
CALL p_run_tests();
