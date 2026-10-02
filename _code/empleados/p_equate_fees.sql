-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para igualar las fees de todos los employees a la media de las fees.
--

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

-- CALL p_populate();
-- CALL p_equate_fees();