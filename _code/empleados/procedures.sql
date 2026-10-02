--
-- Scripts de apoyo para tema de Compound Statements 
-- Autores: Daniel Ayala, Inma Hernández y David Ruiz
-- Fecha creación: Noviembre de 2019 
-- 



-- Procedimiento para igualar las feees de todos los employees a 
-- la media de las feees.
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	p_equate_fees() 
BEGIN 
	DECLARE avg_fee DOUBLE; 
	SET avg_fee = (SELECT AVG(fee) FROM employees);
	-- Modifica TODOS los employees, no tiene WHERE
	UPDATE employees SET fee = avg_fee; 
END //
DELIMITER ;

-- Aplicar un aumento dado a la comisión de empleado concreto
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	p_raise_fee(id INT, amount DOUBLE) 
BEGIN 
	DECLARE e ROW TYPE OF employees; 
	DECLARE new_fee DOUBLE;
	SELECT * INTO e -- el resultado del select lo almacena en la variable
		FROM employees
		WHERE employee_id = id; 
	SET new_fee = e.fee + amount;
	UPDATE employees 
		SET fee = new_fee 
		WHERE employee_id = id; 
END //
DELIMITER ;

-- Devuelve el numero de employees de una localidad
DELIMITER //
CREATE OR REPLACE FUNCTION 
	f_num_employees(c VARCHAR(64)) RETURNS INT 
BEGIN 
	RETURN (
		SELECT COUNT(*)
		FROM employees e JOIN departments d
		ON (e.department_id = d.department_id)
		WHERE d.city = c
	); 
END//
DELIMITER ;

-- Ejemplo de uso de funciones dentro de procedimientos
-- deben almacenarse en variables
DELIMITER //
CREATE OR REPLACE FUNCTION 
	f_avg_fee() RETURNS DOUBLE 
BEGIN 
	RETURN (
		SELECT AVG(fee)
		FROM employees
	); 
END //
DELIMITER ;

-- El procedimiento puede usar la función 
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	p_equate_fees() 
BEGIN 
	DECLARE af DOUBLE; 
	SET af = f_avg_fee();
	UPDATE employees SET fee = af; 
END//
DELIMITER ;

-- Ejemplo de Trigger para comprobar que un empleado no puede ser 
-- su propio boos_id. Dentro del Trigger se tiene acceso a una variable
-- llamada 'new' que almacena la tupla con los datos a actualizar
-- se usa SIGNAL para elevar error
DELIMITER //
CREATE OR REPLACE TRIGGER t_self_boss_insert
BEFORE INSERT ON employees FOR EACH ROW 
BEGIN 
	IF (new.employee_id = new.boss_id) THEN 
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'Un empleado no puede ser su propio boos_id'; 
	END IF; 
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER t_self_boss_update 
BEFORE UPDATE ON employees FOR EACH ROW 
BEGIN 
	IF (new.employee_id = new.boss_id) THEN 
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'An employee cannot be his own boss'; 
	END IF; 
END //
DELIMITER ;

-- Ejemplo de Trigger para comprobar que las variaciones sobre 
-- la comisión de los Employees no puede cambar en más 0.2 puntos
-- Dentro del Trigger se tiene acceso a 'old', que almacena la tupla
-- con los valores antes de cambiar.

-- OPCIÓN 1: No se permite realizar el cambio en la comisión
-- DELIMITER //
-- CREATE OR REPLACE TRIGGER t_change_fee 
-- BEFORE UPDATE ON employees FOR EACH ROW 
-- BEGIN 
-- 	IF((new.fee - old.fee) > 0.2 OR ((new.fee - old.fee) < -0.2)) THEN 
-- 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
-- 			'A fee cannot increase or decrease more than 0.2'; 
-- 	END IF; 
-- END //
-- DELIMITER ;

-- -- OPCIÓN 2: Se permita realizar el cambio al valor máximo permitido
-- DELIMITER //
-- CREATE OR REPLACE TRIGGER t_change_fee
-- BEFORE UPDATE ON employees FOR EACH ROW 
-- BEGIN 
-- 	IF((new.fee - old.fee) > 0.2) THEN 
-- 		SET new.fee = old.fee + 0.2; 
-- 	END IF; 
-- 	IF((new.fee - old.fee) < -0.2) THEN 
-- 		SET new.fee = old.fee - 0.2; 
-- 	END IF; 
-- END //
-- DELIMITER ;

-- Ejemplo de Trigger para comprobar que un Departamento no tiene más
-- de 5 Employees.
DELIMITER //
CREATE OR REPLACE TRIGGER t_max_employees_department 
BEFORE INSERT ON employees FOR EACH ROW 
BEGIN 
	DECLARE n INT; 
	SET n = (
		SELECT COUNT(*)
		FROM employees
		WHERE department_id = new.department_id
	); 
	IF (n > 4) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'Un departamento no puede tener más de 5 employees'; 
		END IF; 
	END //
DELIMITER ;

-- Ejemplo de Trigger para almacenar en la start_date del contrato
-- de un empleado a la fecha actual del sistema en que caso de que la
-- start_date proporcionada sea NULL
-- DELIMITER //
-- CREATE OR REPLACE TRIGGER t_default_start_date 
-- BEFORE INSERT ON employees FOR EACH ROW 
-- BEGIN 
-- 	IF (new.start_date IS NULL) THEN 
-- 		SET new.start_date = SYSDATE(); 
-- 	END IF; 
-- END //
-- DELIMITER ;

-- Ejemplo de función que recorre un cursor
DELIMITER //
CREATE OR REPLACE FUNCTION 
	f_sum_salaries() RETURNS DECIMAL 
BEGIN 
	DECLARE total DECIMAL; 
	DECLARE employee ROW TYPE OF employees; 
	DECLARE done BOOLEAN DEFAULT FALSE; 
	DECLARE cur_employees CURSOR FOR
		SELECT *
		FROM employees; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE; 
	SET total = 0; 
	OPEN cur_employees;
	readLoop: LOOP 
		FETCH cur_employees INTO employee; 
		IF done THEN 
			LEAVE readLoop; 
		END IF; 
		SET total = total + employee.salary; 
	END LOOP; 
	CLOSE cur_employees; 
	RETURN total; 
END //
DELIMITER ; 

