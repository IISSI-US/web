-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para igualar las fees de todos los Employees a la media de las fees.
--

DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pEquateFees() 
BEGIN 
	DECLARE avgFee DOUBLE; 
	SET avgFee = (SELECT AVG(fee) FROM Employees);
	-- Modifica TODOS los Employees, no tiene WHERE
	UPDATE Employees SET fee = avgFee; 
END //
DELIMITER ;

-- CALL pPopulateDB();
-- CALL pEquateFees();