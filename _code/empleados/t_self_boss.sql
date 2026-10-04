-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Comprueba que un empleado no puede ser su propio jefe.
--

DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_self_boss
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
	IF NEW.employee_id = NEW.boss_id THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RN-02: Un empleado no puede ser su propio jefe';
	END IF;
END //
DELIMITER ;

-- CALL p_populate_db();
-- CALL p_insert_employee(p_employee_id, p_department_id, p_boss_id, p_name_emp, p_start_date, p_end_date, p_salary, p_fee)