--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Tests negativos para ApartamentosDB
--
USE ApartamentosDB;

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

CREATE OR REPLACE PROCEDURE p_test_uq01_email()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ01', 'UQ01: El correo del usuario debe ser único', 'PASS');
    CALL p_populate();
    INSERT INTO users (user_id, national_id, email) VALUES (100, '00000000X', 'juanperez@example.com');
    CALL p_log_test('UQ01', 'ERROR: Se permitió duplicar un correo', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_dates()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01', 'RN01: El check-in debe ser anterior al check-out', 'PASS');
    CALL p_populate();
    INSERT INTO reservations (reservation_id, guest_id, accommodation_id, check_in, check_out) VALUES (100, 1, 1, '2026-06-10', '2026-06-01');
    CALL p_log_test('RN01', 'ERROR: Se permitió una reserva con fechas inválidas', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn02_rating()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN02', 'RN02: La valoración debe estar entre 1 y 5', 'PASS');
    CALL p_populate();
    INSERT INTO reservations (reservation_id, guest_id, accommodation_id, check_in, check_out, rating) VALUES (100, 1, 1, '2026-06-01', '2026-06-10', 6);
    CALL p_log_test('RN02', 'ERROR: Se permitió una valoración fuera de rango', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn03_overlap()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN03', 'RN03: Las reservas de un alojamiento no pueden solaparse', 'PASS');
    CALL p_populate();
    INSERT INTO reservations (reservation_id, guest_id, accommodation_id, check_in, check_out) VALUES (100, 3, 2, '2022-01-05', '2022-01-08');
    CALL p_log_test('RN03', 'ERROR: Se permitió solapar dos reservas', 'FAIL');
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
    CALL p_test_uq01_email();
    CALL p_test_rn01_dates();
    CALL p_test_rn02_rating();
    CALL p_test_rn03_overlap();
    SELECT * FROM test_results ORDER BY test_id;
    SELECT test_status, COUNT(*) total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
CALL p_run_tests();
