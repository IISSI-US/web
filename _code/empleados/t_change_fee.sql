-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: La comisión no puede variar más de 0.2 (20 puntos porcentuales) por actualización.
-- Dentro del Trigger se tiene acceso a 'old', que almacena la tupla
-- con los valores antes de cambiar.

-- OPCIÓN 1: No se permite realizar el cambio en la comisión
DELIMITER //
CREATE OR REPLACE TRIGGER t_bu_change_fee
BEFORE UPDATE ON employees FOR EACH ROW 
BEGIN 
	IF OLD.fee IS NOT NULL AND NEW.fee IS NOT NULL
		AND ABS(NEW.fee - OLD.fee) > 0.2 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
			'RN-02: La diferencia absoluta de comisión no puede superar 0.2';
	END IF; 
END //
DELIMITER ;

-- OPCIÓN 2: Se permite realizar el cambio al valor máximo permitido
/*
DELIMITER //
CREATE OR REPLACE TRIGGER t_bu_change_fee
BEFORE UPDATE ON employees FOR EACH ROW 
BEGIN 
	IF OLD.fee IS NOT NULL AND NEW.fee IS NOT NULL THEN
		IF NEW.fee - OLD.fee > 0.2 THEN
			SET NEW.fee = LEAST(OLD.fee + 0.2, 1);
		ELSEIF NEW.fee - OLD.fee < -0.2 THEN
			SET NEW.fee = GREATEST(OLD.fee - 0.2, 0);
		END IF;
	END IF; 
END //
DELIMITER ;
*/
