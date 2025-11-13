-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Función que devuelve el numero de Employees de una localidad
--

DELIMITER //
CREATE OR REPLACE FUNCTION 
	fNumEmployees(c VARCHAR(64)) RETURNS INT 
BEGIN 
	RETURN (
		SELECT COUNT(*)
		FROM Employees E JOIN Departments D
		ON (E.departmentId = D.departmentId)
		WHERE D.city = c
	); 
END//
DELIMITER ;

SELECT *, fNumEmployees(d.city) numEmployees
FROM Departments d
;