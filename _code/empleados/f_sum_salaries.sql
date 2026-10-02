-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de función que recorre un cursor
--

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
