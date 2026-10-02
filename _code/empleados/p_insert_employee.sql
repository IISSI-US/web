-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para insertar un nuevo Empleado, si la startDate es null, poner la fecha actual del sistema
--

DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_employee (
	p_employee_id INT,
	p_department_id INT,
	p_boss_id INT,
	p_name_emp VARCHAR(64),
	p_start_date DATE,
	p_end_date DATE,
	p_salary DOUBLE, 
	p_fee DOUBLE)
BEGIN 
	IF (p_start_date IS NULL) THEN 
		SET p_start_date = SYSDATE(); 
	END IF;
	INSERT INTO employees (employee_id, department_id, boss_id, name_emp, salary, start_date, end_date, fee)	
	VALUES (p_employee_id, p_department_id, p_boss_id, p_name_emp, p_salary, p_start_date, p_end_date, p_fee); 
END //
DELIMITER ;

-- CALL p_populate_db();
-- CALL p_insert_employee(6, 1, NULL, 'Daniel', '2020-09-15', NULL, 2500.0, 0.2); 