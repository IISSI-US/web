-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de Trigger para comprobar que un Departamento 
-- no tiene más de 5 Empleados.

DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_max_employees_department
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
	DECLARE v_employee_count INT DEFAULT 0;

	IF NOT (NEW.department_id <=> OLD.department_id) THEN
		SELECT COUNT(*) INTO v_employee_count
		FROM employees
		WHERE department_id = NEW.department_id;

		IF v_employee_count > 4 THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'RN-01: Un departamento no puede tener más de cinco empleados';
		END IF;
	END IF;
END //
DELIMITER ;

-- CALL p_populate_db();
-- CALL p_insert_employee(6, 1, NULL, 'quinto empleado departamento 1', null, NULL, 1500, 0);
-- CALL p_insert_employee(7, 1, NULL, 'sexto empleado departamento 1', null, NULL, 1500, 0);
