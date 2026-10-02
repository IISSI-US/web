-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para la carga inicial de datos
-- 

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
	-- desactivar las restricciones de FK para poder borrar, la tabla de empleados tiene una FK a si misma.
	SET FOREIGN_KEY_CHECKS = 0;
	DELETE FROM employees;
	DELETE FROM departments;
	SET FOREIGN_KEY_CHECKS = 1;
		
	INSERT INTO departments (department_id, name_dep, city) VALUES
		(1, 'Arte', 'Cádiz'),
		(2, 'Historia', NULL),
		(3, 'Informática', 'Sevilla')
	;

	INSERT INTO employees (employee_id, department_id, boss_id, name_emp, salary, start_date, end_date, fee) VALUES
		(1, 1, NULL, 'Pedro', 2300.00, '2017-09-15', NULL, 0.2),
		(2, 1, NULL, 'Jose', 2500.00, '2018-08-15', NULL, 0.5),
		(3, 2, NULL, 'Lola', 2300.00, '2018-08-15', NULL, 0.3),
		(4, 1, 1, 'Luis', 1300.00, '2018-08-15', '2018-11-15', 0),
		(5, 1, 1, 'Ana', 1300.00, '2018-08-15', '2018-11-15', 0)
	;
END;
//
DELIMITER ;

CALL p_populate();