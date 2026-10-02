--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Tests negativos para ProyectosDB
--
USE ProyectosDB;

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

CREATE OR REPLACE PROCEDURE p_test_ck01_budget()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('CK01', 'CK01: El presupuesto debe ser positivo', 'PASS');
    CALL p_populate();
    INSERT INTO projects (name, budget) VALUES ('Proyecto inválido', 0);
    CALL p_log_test('CK01', 'ERROR: Se permitió un presupuesto no positivo', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_uq01_task_position()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ01', 'UQ01: El orden de las tareas es único por proyecto', 'PASS');
    CALL p_populate();
    INSERT INTO tasks (project_id, position, task_code, description, estimate) VALUES (1, 1, 'T-X', 'Duplicada', 10);
    CALL p_log_test('UQ01', 'ERROR: Se permitió duplicar el orden de una tarea', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_uq02_task_code()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ02', 'UQ02: El identificador de tarea es único por proyecto', 'PASS');
    CALL p_populate();
    INSERT INTO tasks (project_id, position, task_code, description, estimate) VALUES (1, 10, 'T-DI', 'Duplicada', 10);
    CALL p_log_test('UQ02', 'ERROR: Se permitió duplicar el identificador de tarea', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_ck02_period()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('CK02', 'CK02: El fin de un periodo no puede preceder a su inicio', 'PASS');
    CALL p_populate();
    INSERT INTO task_periods (employee_id, task_id, start_date, end_date) VALUES (1, 2, '2026-02-01', '2026-01-01');
    CALL p_log_test('CK02', 'ERROR: Se permitió un periodo con fechas inválidas', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_uq03_national_id()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ03', 'UQ03: El DNI de empleado debe ser único', 'PASS');
    CALL p_populate();
    INSERT INTO employees (national_id, name) VALUES ('12345678A', 'Empleado duplicado');
    CALL p_log_test('UQ03', 'ERROR: Se permitió duplicar el DNI', 'FAIL');
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
    CALL p_test_ck01_budget();
    CALL p_test_uq01_task_position();
    CALL p_test_uq02_task_code();
    CALL p_test_ck02_period();
    CALL p_test_uq03_national_id();
    SELECT * FROM test_results ORDER BY test_id;
    SELECT test_status, COUNT(*) total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
CALL p_run_tests();
