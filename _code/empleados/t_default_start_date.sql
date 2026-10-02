-- Ejemplo de Trigger para almacenar en la startDate del contrato
-- de un empleado a la fecha actual del sistema en que caso de que la
-- startDate proporcionada sea NULL
DELIMITER //
CREATE OR REPLACE TRIGGER t_default_start_date 
BEFORE INSERT ON employees FOR EACH ROW 
BEGIN 
	IF (new.start_date IS NULL) THEN 
		SET new.start_date = SYSDATE(); 
	END IF; 
END //
DELIMITER ;


