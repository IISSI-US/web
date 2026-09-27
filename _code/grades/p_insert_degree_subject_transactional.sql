--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Procedimiento transaccional para crear un grado y una asignatura
--

USE GradesDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_degree_subject_transactional(
    IN p_degree_name VARCHAR(80),
    IN p_degree_years TINYINT,
    IN p_subject_name VARCHAR(120),
    IN p_subject_acronym VARCHAR(12),
    IN p_subject_credits TINYINT,
    IN p_subject_course TINYINT,
    IN p_subject_type VARCHAR(30)
)
BEGIN
    START TRANSACTION;

    tblock: BEGIN
        DECLARE v_new_degree_id INT;

        DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

        INSERT INTO degrees (degree_name, duration_years)
        VALUES (p_degree_name, p_degree_years);

        SET v_new_degree_id = LAST_INSERT_ID();

        INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type)
        VALUES (v_new_degree_id, p_subject_name, p_subject_acronym,
                p_subject_credits, p_subject_course, p_subject_type);

        COMMIT;
    END tblock;
END //
DELIMITER ;
