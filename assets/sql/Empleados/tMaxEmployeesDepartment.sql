-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de Trigger para comprobar que un Departamento 
-- no tiene más de 5 Empleados.

DELIMITER //
CREATE OR REPLACE TRIGGER tMaxEmployeesDepartment 
BEFORE INSERT ON Employees FOR EACH ROW 
BEGIN 
	DECLARE n INT; 
	SET n = (
		SELECT COUNT(*)
		FROM Employees
		WHERE departmentId = new.departmentId
	); 
	IF (n > 4) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'A department cannot have more than 5 employees'; 
		END IF; 
	END //
DELIMITER ;

-- CALL pPopulateDB();
-- CALL pInsertEmployee(6, 1, NULL, 'quinto empleado departamento 1', null, NULL, 1500, 0);
-- CALL pInsertEmployee(7, 1, NULL, 'sexto empleado departamento 1', null, NULL, 1500, 0);
