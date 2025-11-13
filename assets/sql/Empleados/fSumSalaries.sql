-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de función que recorre un cursor
--

DELIMITER //
CREATE OR REPLACE FUNCTION 
	fSumSalaries() RETURNS DECIMAL 
BEGIN 
	DECLARE total DECIMAL; 
	DECLARE employee ROW TYPE OF Employees; 
	DECLARE done BOOLEAN DEFAULT FALSE; 
	DECLARE curEmployees CURSOR FOR
		SELECT *
		FROM Employees; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE; 
	SET total = 0; 
	OPEN curEmployees;
	readLoop: LOOP 
		FETCH curEmployees INTO employee; 
		IF done THEN 
			LEAVE readLoop; 
		END IF; 
		SET total = total + employee.salary; 
	END LOOP; 
	CLOSE curEmployees; 
	RETURN total; 
END //
DELIMITER ; 
