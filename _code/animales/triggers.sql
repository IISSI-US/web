--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Triggers y rutinas auxiliares de AnimalesDB
--
USE AnimalesDB;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bi_deliveries_rn02
BEFORE INSERT ON deliveries
FOR EACH ROW
BEGIN
    DECLARE v_person_id INT;

    SELECT person_id INTO v_person_id
    FROM admissions
    WHERE admission_id = NEW.admission_id;

    IF v_person_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN02: Una entrega debe identificar a la persona que la realiza';
    END IF;
END //

CREATE OR REPLACE TRIGGER t_bi_adoptions_rn01
BEFORE INSERT ON adoptions
FOR EACH ROW
BEGIN
    DECLARE v_abandoned_adoptions INT;
    DECLARE v_is_abandoned INT;

    SELECT COUNT(*) INTO v_is_abandoned
    FROM admissions i
    JOIN abandonments a ON a.admission_id = i.admission_id
    WHERE i.animal_id = NEW.animal_id;

    IF v_is_abandoned > 0 THEN
        SELECT COUNT(*) INTO v_abandoned_adoptions
        FROM adoptions ad
        JOIN admissions i ON i.animal_id = ad.animal_id
        JOIN abandonments a ON a.admission_id = i.admission_id
        WHERE ad.person_id = NEW.person_id
          AND YEAR(ad.adoption_datetime) = YEAR(NEW.adoption_datetime)
          AND MONTH(ad.adoption_datetime) = MONTH(NEW.adoption_datetime);

        IF v_abandoned_adoptions >= 2 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN01: Una persona no puede adoptar más de dos animales abandonados al mes';
        END IF;
    END IF;
END //
DELIMITER ;
