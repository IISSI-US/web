--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Triggers y rutinas auxiliares de EspectaculosDB
--
USE EspectaculosDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_check_purchase_date_rn02(
    p_representacion_id INT,
    p_fecha_compra DATETIME
)
BEGIN
    DECLARE v_start_datetime DATETIME;

    SELECT start_datetime INTO v_start_datetime
    FROM performances
    WHERE performance_id = p_representacion_id;

    IF p_fecha_compra >= v_start_datetime THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN02: La compra debe ser anterior a la representación';
    END IF;
END //

CREATE OR REPLACE TRIGGER t_biu_performances_rn01
BEFORE INSERT OR UPDATE ON performances
FOR EACH ROW
BEGIN
    DECLARE v_performances INT;

    SELECT COUNT(*) INTO v_performances
    FROM performances
    WHERE show_id = NEW.show_id
      AND DATE(start_datetime) = DATE(NEW.start_datetime)
      AND performance_id <> COALESCE(NEW.performance_id, -1);

    IF v_performances > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN01: Un espectáculo solo puede tener una representación al día';
    END IF;
END //

CREATE OR REPLACE TRIGGER t_biu_tickets_rn02
BEFORE INSERT OR UPDATE ON tickets
FOR EACH ROW
BEGIN
    CALL p_check_purchase_date_rn02(NEW.performance_id, NEW.purchase_datetime);
END //
DELIMITER ;
