--
-- Scripts de apoyo para tema de Compound Statements 
-- Autores: Daniel Ayala, Inma Hernández y David Ruiz
-- Fecha creación: Noviembre de 2019 
-- 



-- Procedimiento para igualar las feees de todos los Employees a 
-- la media de las feees.
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

-- Aplicar un aumento dado a la comisión de empleado concreto
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

-- Devuelve el numero de Employees de una localidad
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

-- Ejemplo de uso de funciones dentro de procedimientos
-- deben almacenarse en variables
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

-- Ejemplo de Trigger para comprobar que un empleado no puede ser 
-- su propio boosId. Dentro del Trigger se tiene acceso a una variable
-- llamada 'new' que almacena la tupla con los datos a actualizar
-- se usa SIGNAL para elevar error
DELIMITER //
CREATE OR REPLACE TRIGGER tSelfBossInsert
BEFORE INSERT ON Employees FOR EACH ROW 
BEGIN 
	IF (new.employeeId = new.bossId) THEN 
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'Un empleado no puede ser su propio boosId'; 
	END IF; 
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER tSelfBossUpdate 
BEFORE UPDATE ON Employees FOR EACH ROW 
BEGIN 
	IF (new.employeeId = new.bossId) THEN 
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'An employee cannot be his own boss'; 
	END IF; 
END //
DELIMITER ;

-- Ejemplo de Trigger para comprobar que las variaciones sobre 
-- la comisión de los Employees no puede cambar en más 0.2 puntos
-- Dentro del Trigger se tiene acceso a 'old', que almacena la tupla
-- con los valores antes de cambiar.

-- OPCIÓN 1: No se permite realizar el cambio en la comisión
-- DELIMITER //
-- CREATE OR REPLACE TRIGGER tChangeFee 
-- BEFORE UPDATE ON Employees FOR EACH ROW 
-- BEGIN 
-- 	IF((new.fee - old.fee) > 0.2 OR ((new.fee - old.fee) < -0.2)) THEN 
-- 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
-- 			'A fee cannot increase or decrease more than 0.2'; 
-- 	END IF; 
-- END //
-- DELIMITER ;

-- -- OPCIÓN 2: Se permita realizar el cambio al valor máximo permitido
-- DELIMITER //
-- CREATE OR REPLACE TRIGGER tChangeFee
-- BEFORE UPDATE ON Employees FOR EACH ROW 
-- BEGIN 
-- 	IF((new.fee - old.fee) > 0.2) THEN 
-- 		SET new.fee = old.fee + 0.2; 
-- 	END IF; 
-- 	IF((new.fee - old.fee) < -0.2) THEN 
-- 		SET new.fee = old.fee - 0.2; 
-- 	END IF; 
-- END //
-- DELIMITER ;

-- Ejemplo de Trigger para comprobar que un Departamento no tiene más
-- de 5 Employees.
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
			'Un departamento no puede tener más de 5 Employees'; 
		END IF; 
	END //
DELIMITER ;

-- Ejemplo de Trigger para almacenar en la startDate del contrato
-- de un empleado a la fecha actual del sistema en que caso de que la
-- startDate proporcionada sea NULL
-- DELIMITER //
-- CREATE OR REPLACE TRIGGER tDefaultStartDate 
-- BEFORE INSERT ON Employees FOR EACH ROW 
-- BEGIN 
-- 	IF (new.startDate IS NULL) THEN 
-- 		SET new.startDate = SYSDATE(); 
-- 	END IF; 
-- END //
-- DELIMITER ;

-- Ejemplo de función que recorre un cursor
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
	RETURN sum; 
END //
DELIMITER ; 

