--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Tests negativos para AnimalesDB
--
USE AnimalesDB;

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

CREATE OR REPLACE PROCEDURE p_test_uq01_species()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ01', 'UQ01: El nombre de la especie debe ser único', 'PASS');
    CALL p_populate();
    INSERT INTO species (species_name) VALUES ('Canino');
    CALL p_log_test('UQ01', 'ERROR: Se permitió duplicar una especie', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn02_abandonment()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN02A', 'RN02: Un abandono requiere fecha, hora y lugar', 'PASS');
    CALL p_populate();
    INSERT INTO animals (animal_id, breed_id, chip) VALUES (8, 1, '88888');
    INSERT INTO admissions (admission_id, animal_id, delivery_datetime) VALUES (8, 8, '2026-01-01 10:00:00');
    INSERT INTO abandonments (admission_id, abandonment_datetime, place) VALUES (8, NULL, NULL);
    CALL p_log_test('RN02A', 'ERROR: Se permitió un abandono sin datos del hallazgo', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn02_delivery()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN02E', 'RN02: Una entrega debe identificar a la persona', 'PASS');
    CALL p_populate();
    INSERT INTO animals (animal_id, breed_id, chip) VALUES (8, 1, '88888');
    INSERT INTO admissions (admission_id, animal_id, delivery_datetime) VALUES (8, 8, '2026-01-01 10:00:00');
    INSERT INTO deliveries (admission_id) VALUES (8);
    CALL p_log_test('RN02E', 'ERROR: Se permitió una entrega sin persona', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_adoptions()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01', 'RN01: Máximo dos animales abandonados por persona y mes', 'PASS');
    CALL p_populate();
    INSERT INTO animals (animal_id, breed_id, chip) VALUES (8, 1, '88888');
    INSERT INTO admissions (admission_id, animal_id, delivery_datetime) VALUES (8, 8, '2024-10-20 10:00:00');
    INSERT INTO abandonments (admission_id, abandonment_datetime, place) VALUES (8, '2024-10-20 09:00:00', 'Parque Este');
    INSERT INTO adoptions (adoption_id, person_id, animal_id, adoption_datetime) VALUES (8, 3, 8, '2024-10-25 10:00:00');
    CALL p_log_test('RN01', 'ERROR: Se permitió una tercera adopción de animal abandonado', 'FAIL');
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
    CALL p_test_uq01_species();
    CALL p_test_rn02_abandonment();
    CALL p_test_rn02_delivery();
    CALL p_test_rn01_adoptions();
    SELECT * FROM test_results ORDER BY test_id;
    SELECT test_status, COUNT(*) total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
CALL p_run_tests();
