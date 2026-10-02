-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de Trigger para comprobar que un Departamento 
-- no tiene más de 5 Empleados.

DELIMITER //
CREATE OR REPLACE PROCEDURE p_check_max_department(p_department_id INT)
BEGIN 
	DECLARE n INT; 
	SET n = (
		SELECT COUNT(*)
		FROM employees
		WHERE department_id = p_department_id
	); 
	IF (n > 4) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'A department cannot have more than 5 employees'; 
	END IF; 
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bi_max_employees_department 
BEFORE INSERT ON employees FOR EACH ROW 
BEGIN 
	CALL p_check_max_department(NEW.department_id);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bu_max_employees_department 
BEFORE UPDATE ON employees FOR EACH ROW 
BEGIN 
	IF (NEW.department_id <> OLD.department_id) THEN
		CALL p_check_max_department(NEW.department_id);
	END IF;
END //
DELIMITER ;

-- CALL p_populate_db();
-- CALL p_insert_employee(6, 1, NULL, 'quinto empleado departamento 1', null, NULL, 1500, 0);
-- CALL p_insert_employee(7, 1, NULL, 'sexto empleado departamento 1', null, NULL, 1500, 0);
