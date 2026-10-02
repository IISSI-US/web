-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de Trigger para comprobar que un empleado no puede ser su propio boosId. 
-- Dentro del Trigger se tiene acceso a una variable llamada 'new' que almacena la tupla con 
-- los datos a actualizar se usa SIGNAL para elevar error
--

DELIMITER //
CREATE OR REPLACE PROCEDURE  p_check_self_boss(
	p_employee_id INT,
	p_boss_id INT) 
BEGIN 
	IF (p_employee_id = p_boss_id) THEN 
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'An employee cannot be his own boss'; 
	END IF; 
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bi_self_boss
BEFORE INSERT ON employees FOR EACH ROW 
BEGIN 
	CALL p_check_self_boss (NEW.employee_id, NEW.boss_id);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bu_self_boss
BEFORE UPDATE ON employees FOR EACH ROW 
BEGIN 
	CALL p_check_self_boss (NEW.employee_id, NEW.boss_id);
END //
DELIMITER ;

-- CALL p_populate_db();
-- CALL p_insert_employee(p_employee_id, p_department_id, p_boss_id, p_name_emp, p_start_date, p_end_date, p_salary, p_fee)