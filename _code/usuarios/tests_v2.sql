USE Users_v2DB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_v2_birth_date_rules()
BEGIN
    DECLARE v_rejected BOOLEAN DEFAULT FALSE;

    CALL p_populate_users_v2();

    IF (SELECT IS_DETERMINISTIC
        FROM information_schema.ROUTINES
        WHERE ROUTINE_SCHEMA = DATABASE()
          AND ROUTINE_NAME = 'f_get_age_from_birth_date') <> 'NO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La función de edad debe ser no determinista';
    END IF;

    INSERT INTO users (full_name, gender, birth_date, email)
    VALUES ('Edad Limite', NULL, DATE_SUB(CURDATE(), INTERVAL 18 YEAR), 'limite18@example.com');

    IF f_get_age_from_birth_date(DATE_SUB(CURDATE(), INTERVAL 18 YEAR)) <> 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La fecha límite debe producir exactamente 18 años';
    END IF;
    SELECT 'PASS: se acepta la fecha que cumple 18 años hoy' AS test_result;

    SET v_rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '45000' SET v_rejected = TRUE;
        INSERT INTO users (full_name, gender, birth_date, email)
        VALUES (
            'Menor de Edad', NULL,
            DATE_ADD(DATE_SUB(CURDATE(), INTERVAL 18 YEAR), INTERVAL 1 DAY),
            'menor-v2@example.com'
        );
    END;
    IF NOT v_rejected THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El trigger permitió insertar a un menor de edad';
    END IF;
    SELECT 'PASS: se rechaza una fecha que no alcanza los 18 años' AS test_result;

    SET v_rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '45000' SET v_rejected = TRUE;
        UPDATE users
        SET birth_date = DATE_ADD(DATE_SUB(CURDATE(), INTERVAL 18 YEAR), INTERVAL 1 DAY)
        WHERE email = 'limite18@example.com';
    END;
    IF NOT v_rejected THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El trigger permitió actualizar a un menor de edad';
    END IF;
    SELECT 'PASS: se rechaza actualizar a una fecha que no alcanza los 18 años' AS test_result;

    SET v_rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '45000' SET v_rejected = TRUE;
        INSERT INTO users (full_name, gender, birth_date, email)
        VALUES ('Fecha Futura', NULL, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 'futuro-v2@example.com');
    END;
    IF NOT v_rejected THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El trigger permitió insertar una fecha futura';
    END IF;
    SELECT 'PASS: se rechaza una fecha de nacimiento futura' AS test_result;

    SET v_rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '45000' SET v_rejected = TRUE;
        UPDATE users
        SET birth_date = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
        WHERE email = 'limite18@example.com';
    END;
    IF NOT v_rejected THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El trigger permitió actualizar a una fecha futura';
    END IF;
    SELECT 'PASS: se rechaza actualizar a una fecha de nacimiento futura' AS test_result;
END //
DELIMITER ;

CALL p_test_v2_birth_date_rules();
DROP PROCEDURE p_test_v2_birth_date_rules;