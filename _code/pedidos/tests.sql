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
-- TESTS (RN01 - RN08)
-- =============================================================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_user_name_not_null()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'RN01: full_name no puede ser NULL', 'PASS');

    CALL p_populate();

    INSERT INTO users (full_name, province, start_date) VALUES (NULL, 'Test', CURDATE());

    CALL p_log_test('RN01', 'ERROR: Se permitió full_name NULL', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_user_name_unique()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: full_name debe ser único', 'PASS');

    CALL p_populate();

    INSERT INTO users (full_name, province, start_date) VALUES ('Nombre Duplicado', 'Sevilla', CURDATE());
    INSERT INTO users (full_name, province, start_date) VALUES ('Nombre Duplicado', 'Huelva', CURDATE());

    CALL p_log_test('RN02', 'ERROR: Se permitió duplicar full_name', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_price_not_null()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: price no puede ser NULL', 'PASS');

    CALL p_populate();

    INSERT INTO products (description, price, stock) VALUES ('Test', NULL, 10);

    CALL p_log_test('RN03', 'ERROR: Se permitió price NULL', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_price_nonnegative()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN04', 'RN04: price debe ser >= 0', 'PASS');

    CALL p_populate();

    INSERT INTO products (description, price, stock) VALUES ('Test', -1, 10);

    CALL p_log_test('RN04', 'ERROR: Se permitió price negativo', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn05_stock_nonnegative()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN05', 'RN05: stock debe ser >= 0', 'PASS');

    CALL p_populate();

    INSERT INTO products (description, price, stock) VALUES ('Test', 10, -5);

    CALL p_log_test('RN05', 'ERROR: Se permitió stock negativo', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn06_amount_not_null()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN06', 'RN06: amount no puede ser NULL', 'PASS');

    CALL p_populate();

    INSERT INTO orders (user_id, product_id, amount, purchase_date)
        VALUES (1, 1, NULL, CURDATE());

    CALL p_log_test('RN06', 'ERROR: Se permitió amount NULL', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn07_amount_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN07', 'RN07: amount debe estar entre 1 y 10', 'PASS');

    CALL p_populate();

    INSERT INTO orders (user_id, product_id, amount, purchase_date)
        VALUES (1, 1, 20, CURDATE());

    CALL p_log_test('RN07', 'ERROR: Se permitió amount fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn08_august_forbidden()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN08', 'RN08: No se permiten compras en agosto', 'PASS');

    CALL p_populate();

    INSERT INTO orders (user_id, product_id, amount, purchase_date)
        VALUES (1, 1, 2, '2019-08-10');

    CALL p_log_test('RN08', 'ERROR: Se permitió compra en agosto', 'FAIL');
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

    CALL p_test_rn01_user_name_not_null();
    CALL p_test_rn02_user_name_unique();
    CALL p_test_rn03_price_not_null();
    CALL p_test_rn04_price_nonnegative();
    CALL p_test_rn05_stock_nonnegative();
    CALL p_test_rn06_amount_not_null();
    CALL p_test_rn07_amount_range();
    CALL p_test_rn08_august_forbidden();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
CALL p_run_tests();
