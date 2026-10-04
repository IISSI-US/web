--
-- Triggers para mantener disjunta la especialización de Vino.
--
USE BodegasDB;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bi_young_wines_type
BEFORE INSERT ON young_wines
FOR EACH ROW
BEGIN
    DECLARE v_aged_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_aged_count
    FROM aged_wines
    WHERE wine_id = NEW.wine_id;

    IF v_aged_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La especialización de Vino es disjunta: ya existe como Crianza';
    END IF;
END //

CREATE OR REPLACE TRIGGER t_bi_aged_wines_type
BEFORE INSERT ON aged_wines
FOR EACH ROW
BEGIN
    DECLARE v_young_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_young_count
    FROM young_wines
    WHERE wine_id = NEW.wine_id;

    IF v_young_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La especialización de Vino es disjunta: ya existe como Joven';
    END IF;
END //
DELIMITER ;