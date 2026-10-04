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
    INSERT INTO tasks (project_id, position, task_code, description, estimate) VALUES (1, 10, 'T-01', 'Duplicada', 10);
    CALL p_log_test('UQ02', 'ERROR: Se permitió duplicar el identificador de tarea', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_project_description()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01A', 'RN-01: La descripción del proyecto es obligatoria', 'PASS');
    CALL p_populate();
    INSERT INTO projects (name, description, budget) VALUES ('Sin descripción', NULL, 1000);
    CALL p_log_test('RN01A', 'ERROR: Se permitió un proyecto sin descripción', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_role_project()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01B', 'RN-01: Todo rol pertenece a un proyecto', 'PASS');
    CALL p_populate();
    INSERT INTO roles (project_id, name) VALUES (NULL, 'Rol sin proyecto');
    CALL p_log_test('RN01B', 'ERROR: Se permitió un rol sin proyecto', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_task_project()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01C', 'RN-01: Toda tarea pertenece a un proyecto', 'PASS');
    CALL p_populate();
    INSERT INTO tasks (project_id, position, task_code, description, estimate) VALUES (NULL, 10, 'T-99', 'Sin proyecto', 10);
    CALL p_log_test('RN01C', 'ERROR: Se permitió una tarea sin proyecto', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_role_period_employee()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01D', 'RN-01: Todo periodo de rol pertenece a un empleado', 'PASS');
    CALL p_populate();
    INSERT INTO role_periods (employee_id, role_id, start_date) VALUES (NULL, 1, '2024-04-01');
    CALL p_log_test('RN01D', 'ERROR: Se permitió un periodo de rol sin empleado', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_role_period_role()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01E', 'RN-01: Todo periodo de rol refiere un rol', 'PASS');
    CALL p_populate();
    INSERT INTO role_periods (employee_id, role_id, start_date) VALUES (1, NULL, '2024-04-01');
    CALL p_log_test('RN01E', 'ERROR: Se permitió un periodo sin rol', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_task_period_employee()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01F', 'RN-01: Todo periodo de tarea pertenece a un empleado', 'PASS');
    CALL p_populate();
    INSERT INTO task_periods (employee_id, task_id, start_date) VALUES (NULL, 1, '2024-04-01');
    CALL p_log_test('RN01F', 'ERROR: Se permitió un periodo de tarea sin empleado', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn01_task_period_task()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN01G', 'RN-01: Todo periodo de tarea refiere una tarea', 'PASS');
    CALL p_populate();
    INSERT INTO task_periods (employee_id, task_id, start_date) VALUES (1, NULL, '2024-04-01');
    CALL p_log_test('RN01G', 'ERROR: Se permitió un periodo sin tarea', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_ck02_period()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('CK02', 'CK02: El fin de un periodo no puede preceder a su inicio', 'PASS');
    CALL p_populate();
    INSERT INTO task_periods (employee_id, task_id, start_date, end_date) VALUES (1, 2, '2026-02-01', '2026-01-01');
    CALL p_log_test('CK02', 'ERROR: Se permitió un periodo con fechas inválidas', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn03_task_period_overlap()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN03', 'RN-03: Los periodos de una tarea no se solapan', 'PASS');
    CALL p_populate();
    INSERT INTO task_periods (employee_id, task_id, start_date, end_date) VALUES (3, 1, '2024-02-10', '2024-02-20');
    CALL p_log_test('RN03', 'ERROR: Se permitió solapar periodos de una tarea', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn03_task_period_update_overlap()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN03B', 'RN-03: No se puede actualizar un periodo para que se solape', 'PASS');
    CALL p_populate();
    UPDATE task_periods
    SET start_date = '2024-02-10', end_date = '2024-02-20'
    WHERE task_period_id = 3;
    CALL p_log_test('RN03B', 'ERROR: Se permitió actualizar un periodo solapado', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn04_subtask_same_project()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN04A', 'RN-04: Padre y subtarea pertenecen al mismo proyecto', 'PASS');
    CALL p_populate();
    INSERT INTO subtasks (subtask_id, task_id, position) VALUES (1, 3, 2);
    CALL p_log_test('RN04A', 'ERROR: Se vinculó una subtarea de otro proyecto', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn04_subtask_update_project()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('RN04B', 'RN-04: La actualización conserva el proyecto de la WBS', 'PASS');
    CALL p_populate();
    UPDATE subtasks SET task_id = 3 WHERE subtask_id = 4;
    CALL p_log_test('RN04B', 'ERROR: Se movió una subtarea a otro proyecto', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_uq03_national_id()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION CALL p_log_test('UQ03', 'UQ03: El DNI de empleado debe ser único', 'PASS');
    CALL p_populate();
    INSERT INTO employees (national_id, name) VALUES ('11111111A', 'Empleado duplicado');
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
    CALL p_test_rn01_project_description();
    CALL p_test_rn01_role_project();
    CALL p_test_rn01_task_project();
    CALL p_test_rn01_role_period_employee();
    CALL p_test_rn01_role_period_role();
    CALL p_test_rn01_task_period_employee();
    CALL p_test_rn01_task_period_task();
    CALL p_test_ck02_period();
    CALL p_test_rn03_task_period_overlap();
    CALL p_test_rn03_task_period_update_overlap();
    CALL p_test_rn04_subtask_same_project();
    CALL p_test_rn04_subtask_update_project();
    CALL p_test_uq03_national_id();
    SELECT * FROM test_results ORDER BY test_id;
    SELECT test_status, COUNT(*) total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
CALL p_run_tests();
