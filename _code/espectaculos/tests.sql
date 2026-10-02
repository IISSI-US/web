--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Tests negativos para EspectaculosDB
--
USE EspectaculosDB;

CREATE OR REPLACE TABLE test_results (
    test_id VARCHAR(20) PRIMARY KEY,
    test_name VARCHAR(200) NOT NULL,
    test_message VARCHAR(500) NOT NULL,
    test_status ENUM('PASS','FAIL','ERROR') NOT NULL,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(p_id VARCHAR(20), p_message VARCHAR(500), p_status VARCHAR(10))
BEGIN
    INSERT INTO test_results VALUES (p_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status, DEFAULT);
END //

CREATE OR REPLACE PROCEDURE p_test_uq01_price()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ01', 'UQ01: Solo hay un precio por zona y tipo de espectáculo', 'PASS');
    CALL p_populate();
    INSERT INTO prices (area_id, show_type_id, price) VALUES (1, 1, 60);
    CALL p_log_test('UQ01', 'ERROR: Se permitió duplicar un precio', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_performance()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01', 'RN01: Un espectáculo solo puede representarse una vez al día', 'PASS');
    CALL p_populate();
    INSERT INTO performances (show_id, start_datetime) VALUES (1, '2024-10-15 22:00:00');
    CALL p_log_test('RN01', 'ERROR: Se permitió otra representación el mismo día', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn02_purchase_date()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN02-A', 'RN02: La compra debe ser anterior a la representación', 'PASS');
    CALL p_populate();
    INSERT INTO tickets (performance_id, seat_id, purchase_datetime, channel, purchase_price) VALUES (1, 2, '2024-10-16 10:00:00', 'Web', 50);
    CALL p_log_test('RN02', 'ERROR: Se permitió comprar después de la representación', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn02_invitation()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN02-B', 'RN02: Las invitaciones tienen precio cero', 'PASS');
    CALL p_populate();
    INSERT INTO tickets (performance_id, seat_id, purchase_datetime, channel, purchase_price) VALUES (1, 2, '2024-10-12 10:00:00', 'Invitación', 10);
    CALL p_log_test('RN02-B', 'ERROR: Se permitió una invitación con precio', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_uq02_ticket()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ02', 'UQ02: Una localidad solo tiene una entrada por representación', 'PASS');
    CALL p_populate();
    INSERT INTO tickets (performance_id, seat_id, purchase_datetime, channel, purchase_price) VALUES (1, 1, '2024-10-12 10:00:00', 'Web', 50);
    CALL p_log_test('UQ02', 'ERROR: Se permitió vender dos veces la misma localidad', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        CALL p_log_test('POPULATE', 'ERROR: La carga inicial falló', 'ERROR');
        SELECT * FROM test_results ORDER BY test_id;
    END;
    DELETE FROM test_results;
    CALL p_populate();
    CALL p_test_uq01_price();
    CALL p_test_rn01_performance();
    CALL p_test_rn02_purchase_date();
    CALL p_test_rn02_invitation();
    CALL p_test_uq02_ticket();
    SELECT * FROM test_results ORDER BY test_id;
    SELECT test_status, COUNT(*) total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
CALL p_run_tests();
