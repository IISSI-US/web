-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para insertar un nuevo Empleado, si la startDate es null, poner la fecha actual del sistema
--

DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertEmployee (
	p_employeeId INT,
	p_departmentId INT,
	p_bossId INT,
	p_nameEmp VARCHAR(64),
	p_startDate DATE,
	p_endDate DATE,
	p_salary DOUBLE, 
	p_fee DOUBLE)
BEGIN 
	IF (p_startDate IS NULL) THEN 
		SET p_startDate = SYSDATE(); 
	END IF;
	INSERT INTO Employees (employeeId, departmentId, bossId, nameEmp, salary, startDate, endDate, fee)	
	VALUES (p_employeeId, p_departmentId, p_bossId, p_nameEmp, p_salary, p_startDate, p_endDate, p_fee); 
END //
DELIMITER ;

CALL pPopulateDB();
CALL pInsertEmployee(6, 1, NULL, 'Daniel', '2020-09-15', NULL, 2500.0, 0.2); 