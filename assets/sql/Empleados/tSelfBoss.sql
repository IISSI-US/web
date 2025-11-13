-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de Trigger para comprobar que un empleado no puede ser su propio boosId. 
-- Dentro del Trigger se tiene acceso a una variable llamada 'new' que almacena la tupla con 
-- los datos a actualizar se usa SIGNAL para elevar error
--

DELIMITER //
CREATE OR REPLACE PROCEDURE  pCheckSelfBoss(
	p_employeeId INT,
	p_bossId INT) 
BEGIN 
	IF (p_employeeId = p_bossId) THEN 
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'An employee cannot be his own boss'; 
	END IF; 
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER tBISelfBoss
BEFORE INSERT ON Employees FOR EACH ROW 
BEGIN 
	CALL pCheckSelfBoss (NEW.employeeId, NEW.bossId);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER tBUSelfBoss
BEFORE UPDATE ON Employees FOR EACH ROW 
BEGIN 
	CALL pCheckSelfBoss (NEW.employeeId, NEW.bossId);
END //
DELIMITER ;

-- CALL pPopulateDB();
-- CALL pInsertEmployee(p_employeeId, p_departmentId, p_bossId, p_nameEmp, p_startDate, p_endDate, p_salary, p_fee)