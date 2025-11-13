-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Ejemplo de Trigger para comprobar que las variaciones sobre 
-- la comisión de los Employees no puede cambiar en más 0.2 puntos
-- Dentro del Trigger se tiene acceso a 'old', que almacena la tupla
-- con los valores antes de cambiar.

-- OPCIÓN 1: No se permite realizar el cambio en la comisión
DELIMITER //
CREATE OR REPLACE TRIGGER tChangeFee1 
BEFORE UPDATE ON Employees FOR EACH ROW 
BEGIN 
	IF((new.fee - old.fee) > 0.2 OR ((new.fee - old.fee) < -0.2)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'A fee cannot increase or decrease more than 0.2'; 
	END IF; 
END //
DELIMITER ;

-- OPCIÓN 2: Se permite realizar el cambio al valor máximo permitido
DELIMITER //
CREATE OR REPLACE TRIGGER tChangeFee2
BEFORE UPDATE ON Employees FOR EACH ROW 
BEGIN 
	IF((new.fee - old.fee) > 0.2) THEN 
		SET new.fee = old.fee + 0.2; 
	END IF; 
	IF((new.fee - old.fee) < -0.2) THEN 
		SET new.fee = old.fee - 0.2; 
	END IF; 
END //
DELIMITER ;
