--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Comprobar que las FK de VInosUvas son disjuntas
--

DELIMITER //
CREATE OR REPLACE PROCEDURE p_check_id_disjuntos
	(id1 VARCHAR(32), id2 VARCHAR(32))
BEGIN
	IF (id1 = id2) OR	(id1 = '' AND id2 = '') OR (id1 <> '' AND id2 <> '') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las FK de VinosUvas tienen que ser disjuntas';
	END if;
END;
//
DELIMITER ;

DELIMITER //
CREATE or REPLACE TRIGGER t_bi_vinos_uvas 
BEFORE INSERT ON vinos_uvas FOR EACH ROW 
BEGIN
	call p_check_id_disjuntos(NEW.joven_id, NEW.crianza_id);
END
//
DELIMITER ;

DELIMITER //
CREATE or REPLACE TRIGGER t_bu_vinos_uvas 
BEFORE UPDATE ON vinos_uvas FOR EACH ROW 
BEGIN
	call p_check_id_disjuntos(NEW.joven_id, NEW.crianza_id);
END
//
DELIMITER ;
