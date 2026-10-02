--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Triggers y rutinas auxiliares de ApartamentosDB
--
USE ApartamentosDB;

DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_reservations_rn03
BEFORE INSERT OR UPDATE ON reservations
FOR EACH ROW
BEGIN
    DECLARE v_overlaps INT;

    SELECT COUNT(*) INTO v_overlaps
    FROM reservations
    WHERE accommodation_id = NEW.accommodation_id
      AND reservation_id <> COALESCE(NEW.reservation_id, -1)
      AND NEW.check_in < check_out
      AND NEW.check_out > check_in;

    IF v_overlaps > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN03: Las reservas de un alojamiento no pueden solaparse';
    END IF;
END //
DELIMITER ;
