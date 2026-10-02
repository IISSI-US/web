-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para aplicar un aumento dado a la comisión de empleado concreto
--

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

-- CALL p_populate_db();
-- CALL p_raise_fee(4,0.3);
