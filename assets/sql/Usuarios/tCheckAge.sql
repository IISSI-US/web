-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script con triggers para Usuarios
-- 

-- Disparador para comprobar edad antes de insertar
DELIMITER //
CREATE OR REPLACE TRIGGER tCheckAge_RN_1
	BEFORE INSERT ON Usuarios
	FOR EACH ROW
	BEGIN
		IF ( NEW.edad < 18 ) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN-1: Los Usuarios tienen que ser mayores de edad';
		END IF;
END//
DELIMITER ;
