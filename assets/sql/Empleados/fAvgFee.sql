-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de uso de funciones dentro de procedimientos deben almacenarse en variables
--

DELIMITER //
CREATE OR REPLACE FUNCTION 
	fAvgFee() RETURNS DOUBLE 
BEGIN 
	RETURN (
		SELECT AVG(fee)
		FROM Employees
	); 
END //
DELIMITER ;

-- El procedimiento puede usar la función 
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pEquateFees() 
BEGIN 
	DECLARE af DOUBLE; 
	SET af = fAvgFee();
	UPDATE Employees SET fee = af; 
END//
DELIMITER ;

-- CALL pPopulateDB();
-- CALL pEquateFees();