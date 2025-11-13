-- Ejemplo de Trigger para almacenar en la startDate del contrato
-- de un empleado a la fecha actual del sistema en que caso de que la
-- startDate proporcionada sea NULL
DELIMITER //
CREATE OR REPLACE TRIGGER tDefaultStartDate 
BEFORE INSERT ON Employees FOR EACH ROW 
BEGIN 
	IF (new.startDate IS NULL) THEN 
		SET new.startDate = SYSDATE(); 
	END IF; 
END //
DELIMITER ;


