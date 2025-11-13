-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para aplicar un aumento dado a la comisión de empleado concreto
--

DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pRaiseFee(id INT, amount DOUBLE) 
BEGIN 
	DECLARE e ROW TYPE OF Employees; 
	DECLARE newFee DOUBLE;
	SELECT * INTO e -- el resultado del select lo almacena en la variable
		FROM Employees
		WHERE employeeId = id; 
	SET newFee = e.fee + amount;
	UPDATE Employees 
		SET fee = newFee 
		WHERE employeeId = id; 
END //
DELIMITER ;

-- CALL pPopulateDB();
-- CALL pRaiseFee(4,0.3);
