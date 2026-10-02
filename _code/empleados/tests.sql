-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Tests negativos para la BD de Empleados
-- 
USE EmployeesDB;

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
-- TESTS (RN01 - RN09)
-- =============================================================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_unique_name()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'RN01: name_emp debe ser único', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (1, NULL, 'Pedro', 1500, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RN01', 'ERROR: Se permitió duplicar name_emp', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_salary_positive()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02', 'RN02: salary debe ser > 0', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (2, NULL, 'Salario Negativo', -10, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RN02', 'ERROR: Se permitió salary negativo', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_fee_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN03', 'RN03: fee debe estar entre 0 y 1', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (2, NULL, 'Fee Invalido', 1200, '2024-01-01', NULL, 1.5);

    CALL p_log_test('RN03', 'ERROR: Se permitió fee fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn04_dates_order()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN04', 'RN04: start_date < end_date', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (2, NULL, 'Fecha Incorrecta', 1200, '2024-12-01', '2024-01-01', 0.1);

    CALL p_log_test('RN04', 'ERROR: Se permitió start_date >= end_date', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn05_self_boss()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN05', 'RN05: Un empleado no puede ser su propio jefe', 'PASS');

    CALL p_populate();

    INSERT INTO employees (employee_id, department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (20, 1, 20, 'JefeDeSiMismo', 1500, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RN05', 'ERROR: Se permitió boss_id = employee_id', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn06_max_department()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN06', 'RN06: Máximo 5 empleados por departamento', 'PASS');

    CALL p_populate();

    -- Quinto empleado (permitido)
    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (1, 1, 'Empleado5', 1200, '2024-01-01', NULL, 0.1);
    -- Sexto empleado (debe fallar)
    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (1, 1, 'Empleado6', 1200, '2024-02-01', NULL, 0.1);

    CALL p_log_test('RN06', 'ERROR: Se permitió un sexto empleado en el departamento', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn07_fee_delta()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN07', 'RN07: La comisión no puede variar más de 0.2', 'PASS');

    CALL p_populate();

    UPDATE employees SET fee = 0.7 WHERE employee_id = 1;

    CALL p_log_test('RN07', 'ERROR: Se permitió variar la comisión en más de 0.2', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn08_default_start_date()
BEGIN
    DECLARE v_date DATE;

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (2, NULL, 'SinFecha', 1200, NULL, NULL, 0.1);

    SELECT start_date INTO v_date FROM employees WHERE name_emp = 'SinFecha';

    IF v_date IS NULL THEN
        CALL p_log_test('RN08', 'ERROR: start_date no se asignó por defecto', 'FAIL');
    ELSE
        CALL p_log_test('RN08', 'RN08: start_date se asigna por defecto', 'PASS');
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn09_fk_department()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN09', 'RN09: department_id debe existir', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (99, NULL, 'Dep Inexistente', 1200, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RN09', 'ERROR: Se permitió un department_id inexistente', 'FAIL');
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

    CALL p_test_rn01_unique_name();
    CALL p_test_rn02_salary_positive();
    CALL p_test_rn03_fee_range();
    CALL p_test_rn04_dates_order();
    CALL p_test_rn05_self_boss();
    CALL p_test_rn06_max_department();
    CALL p_test_rn07_fee_delta();
    CALL p_test_rn08_default_start_date();
    CALL p_test_rn09_fk_department();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_tests();