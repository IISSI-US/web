-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de uso de funciones dentro de procedimientos deben almacenarse en variables
--

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

-- CALL p_populate_db();
-- CALL p_equate_fees();