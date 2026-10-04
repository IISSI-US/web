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
CREATE OR REPLACE PROCEDURE p_test_ri02_unique_employee_name()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RI02A', 'RI-02: El nombre del empleado debe ser único', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (1, NULL, 'Pedro', 1500, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RI02A', 'ERROR: Se permitió duplicar el nombre del empleado', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_department_name_city()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01A', 'RN-01: La combinación de nombre y localidad debe ser única', 'PASS');

    CALL p_populate();

    INSERT INTO departments (name_dep, city) VALUES ('Arte', 'Cádiz');

    CALL p_log_test('RN01A', 'ERROR: Se permitió repetir nombre y localidad', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ri01_department_name_required()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RI01', 'RI-01: El nombre del departamento es obligatorio', 'PASS');

    CALL p_populate();

    INSERT INTO departments (name_dep, city) VALUES (NULL, 'Madrid');

    CALL p_log_test('RI01', 'ERROR: Se permitió un departamento sin nombre', 'FAIL');
END //
DELIMITER ;

DELIMITER //
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ck01_salary_positive()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('CK01', 'CK-01: salary debe ser > 0', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (2, NULL, 'Salario Negativo', -10, '2024-01-01', NULL, 0.1);

    CALL p_log_test('CK01', 'ERROR: Se permitió salary negativo', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ri02_salary_required()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RI02D', 'RI-02: El salario es obligatorio', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (1, NULL, 'Sin Salario', NULL, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RI02D', 'ERROR: Se permitió un empleado sin salario', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ri02_fee_required()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RI02E', 'RI-02: La comisión es obligatoria', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (1, NULL, 'Sin Comisión', 1200, '2024-01-01', NULL, NULL);

    CALL p_log_test('RI02E', 'ERROR: Se permitió un empleado sin comisión', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_fee_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02A', 'RN-02: fee debe estar entre 0 y 1', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (2, NULL, 'Fee Invalido', 1200, '2024-01-01', NULL, 1.5);

    CALL p_log_test('RN02A', 'ERROR: Se permitió fee fuera de rango', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ck02_dates_order()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('CK02', 'CK-02: start_date debe preceder a end_date', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (2, NULL, 'Fecha Incorrecta', 1200, '2024-12-01', '2024-01-01', 0.1);

    CALL p_log_test('CK02', 'ERROR: Se permitió start_date >= end_date', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_self_boss()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02B', 'RN-02: Un empleado no puede ser su propio jefe', 'PASS');

    CALL p_populate();

    INSERT INTO employees (employee_id, department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (20, 1, 20, 'JefeDeSiMismo', 1500, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RN02B', 'ERROR: Se permitió boss_id = employee_id', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_self_boss_update()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02E', 'RN-02: UPDATE no puede asignar un empleado como su propio jefe', 'PASS');

    CALL p_populate();

    UPDATE employees SET boss_id = employee_id WHERE employee_id = 1;

    CALL p_log_test('RN02E', 'ERROR: UPDATE permitió que un empleado fuera su propio jefe', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_max_department_insert()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01B', 'RN-01: Máximo cinco empleados por departamento', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (1, 1, 'Empleado6', 1200, '2024-02-01', NULL, 0.1);

    CALL p_log_test('RN01B', 'ERROR: Se permitió un sexto empleado en el departamento', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_max_department_transfer()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01C', 'RN-01: No se puede trasladar a un departamento lleno', 'PASS');

    CALL p_populate();

    UPDATE employees
    SET department_id = 1
    WHERE employee_id = 3;

    CALL p_log_test('RN01C', 'ERROR: Se permitió superar el máximo al trasladar un empleado', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_null_department_transfer()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01D', 'RN-01: No se puede trasladar desde NULL a un departamento lleno', 'PASS');

    CALL p_populate();

    UPDATE employees
    SET department_id = 1
    WHERE employee_id = 7;

    CALL p_log_test('RN01D', 'ERROR: Se permitió superar el máximo al asignar desde NULL', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_fee_delta()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02C', 'RN-02: La comisión no puede aumentar más de 0.2 puntos', 'PASS');

    CALL p_populate();

    UPDATE employees SET fee = 0.5 WHERE employee_id = 1;

    CALL p_log_test('RN02C', 'ERROR: Se permitió aumentar la comisión más de 0.2 puntos', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_fee_delta_decrease()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN02D', 'RN-02: La comisión no puede reducirse más de 0.2 puntos', 'PASS');

    CALL p_populate();

    UPDATE employees SET fee = 0.2 WHERE employee_id = 2;

    CALL p_log_test('RN02D', 'ERROR: Se permitió reducir la comisión más de 0.2 puntos', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_ri02_department_fk()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RI02C', 'RI-02: El departamento del empleado debe existir', 'PASS');

    CALL p_populate();

    INSERT INTO employees (department_id, boss_id, name_emp, salary, start_date, end_date, fee)
        VALUES (99, NULL, 'Dep Inexistente', 1200, '2024-01-01', NULL, 0.1);

    CALL p_log_test('RI02C', 'ERROR: Se permitió un department_id inexistente', 'FAIL');
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

    CALL p_test_ri02_unique_employee_name();
    CALL p_test_rn01_department_name_city();
    CALL p_test_ri01_department_name_required();
    CALL p_test_ck01_salary_positive();
    CALL p_test_ri02_salary_required();
    CALL p_test_ri02_fee_required();
    CALL p_test_rn02_fee_range();
    CALL p_test_ck02_dates_order();
    CALL p_test_rn02_self_boss();
    CALL p_test_rn02_self_boss_update();
    CALL p_test_rn01_max_department_insert();
    CALL p_test_rn01_max_department_transfer();
    CALL p_test_rn01_null_department_transfer();
    CALL p_test_rn02_fee_delta();
    CALL p_test_rn02_fee_delta_decrease();
    CALL p_test_ri02_department_fk();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_tests();