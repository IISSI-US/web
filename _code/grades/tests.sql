--
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Tests negativos para la BD de Grados
--
USE GradesDB;

-- =============================================================
-- TABLA DE RESULTADOS
-- =============================================================
CREATE OR REPLACE TABLE test_results (
    test_id VARCHAR(20) PRIMARY KEY,
    test_name VARCHAR(200) NOT NULL,
    test_message VARCHAR(500) NOT NULL,
    test_status ENUM('PASS','FAIL','ERROR') NOT NULL,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- PROCEDIMIENTO AUXILIAR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
    IN p_test_id VARCHAR(20),
    IN p_message VARCHAR(500),
    IN p_status ENUM('PASS','FAIL','ERROR')
)
BEGIN
    INSERT INTO test_results(test_id, test_name, test_message, test_status)
    VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;

-- =============================================================
-- TESTS (RN001 - RN016)
-- =============================================================

-- Test RN001: Matrícula de honor requiere nota >= 9
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn001_mh_requirement()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN001', 'RN001: La MH requiere nota >= 9', 'PASS');

    CALL p_populate_grados();

    UPDATE grades SET with_honors = 1 WHERE grade_id = 21;

    CALL p_log_test('RN001', 'ERROR: Se permitió MH con nota inferior a 9', 'FAIL');
END //
DELIMITER ;

-- Test RN002: No se permiten notas duplicadas por asignatura/convocatoria
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn002_duplicate_grade()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN002', 'RN002: No se permiten notas duplicadas por asignatura/convocatoria', 'PASS');

    CALL p_populate_grados();

    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (101, 6, 1, 6.0, 'Primera', 0);

    CALL p_log_test('RN002', 'ERROR: Se permitió duplicar nota en la misma convocatoria', 'FAIL');
END //
DELIMITER ;

-- Test RN003: Un grupo no puede tener más de 2 profesores
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn003_professors_per_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN003', 'RN003: No se permite añadir un tercer profesor al grupo', 'PASS');

    CALL p_populate_grados();

    INSERT INTO teaching_loads (professor_id, group_id, credits) VALUES (5, 1, 1.0);

    CALL p_log_test('RN003', 'ERROR: Se asignó un tercer profesor al grupo', 'FAIL');
END //
DELIMITER ;

-- Test RN004: Un alumno no puede pertenecer a más de un grupo de teoría y uno de laboratorio por asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn004_student_group_limit()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN004', 'RN004: Un alumno no puede pertenecer a más grupos de los permitidos', 'PASS');

    CALL p_populate_grados();

    INSERT INTO group_enrollments (student_id, group_id) VALUES (6, 3);

    CALL p_log_test('RN004', 'ERROR: Se permitió un alumno en más grupos de los permitidos', 'FAIL');
END //
DELIMITER ;

-- Test RN005: Una nota no puede alterarse en más de 4 puntos
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn005_grade_delta()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN005', 'RN005: No se puede modificar la nota en más de 4 puntos', 'PASS');

    CALL p_populate_grados();

    UPDATE grades SET grade_value = 0.5 WHERE grade_id = 1;

    CALL p_log_test('RN005', 'ERROR: Se permitió modificar la nota en más de 4 puntos', 'FAIL');
END //
DELIMITER ;

-- Test RN006: No puede haber más de un grupo de teoría y dos de laboratorio por asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn006_extra_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN006', 'RN006: No se permite crear un segundo grupo de teoría para la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (11, 11, 'T2', 'Teoría', 2024);

    CALL p_log_test('RN006', 'ERROR: Se creó un segundo grupo de teoría para la misma asignatura', 'FAIL');
END //
DELIMITER ;

-- Test RN007: Un alumno sólo puede pertenecer a grupos de asignaturas en las que está matriculado
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn007_subject_enrollment()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN007', 'RN007: No se puede añadir a un grupo sin matrícula en la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (102, '20000002B', 'Test', 'Alumno', 20, 'nuevo@alum.us.es', 'student', 'pbkdf2_sha256$1$00$00');
    INSERT INTO students (student_id, access_method) VALUES (102, 'Selectividad');
    INSERT INTO group_enrollments (student_id, group_id) VALUES (102, 1);

    CALL p_log_test('RN007', 'ERROR: Se permitió unir a un grupo sin matrícula en la asignatura', 'FAIL');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn001_mh_requirement()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN001', 'RN001: La MH requiere nota >= 9', 'PASS');

    CALL p_populate_grados();

    UPDATE grades SET with_honors = 1 WHERE grade_id = 21;

    CALL p_log_test('RN001', 'ERROR: Se permitió MH con nota inferior a 9', 'FAIL');
END //
DELIMITER ;

-- Test RN008: Un alumno no puede acceder por selectividad con menos de 16 años
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn008_min_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN008', 'RN008: No se permite Selectividad con menos de 16 años', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (104, '20000004D', 'Test', 'Menor', 15, 'menor@alum.us.es', 'student', 'pbkdf2_sha256$1$00$00');
    INSERT INTO students (student_id, access_method) VALUES (104, 'Selectividad');

    CALL p_log_test('RN008', 'ERROR: Se permitió Selectividad para un menor', 'FAIL');
END //
DELIMITER ;

-- Test RN009: Los atributos obligatorios no pueden quedar a NULL
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn009_not_null_attributes()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN009', 'RN009: Los atributos obligatorios no pueden quedar a NULL', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (103, '20000003C', NULL, 'Campos', 22, 'null@alum.us.es', 'student', 'pbkdf2_sha256$1$00$00');

    CALL p_log_test('RN009', 'ERROR: Se permitió dejar atributos obligatorios a NULL', 'FAIL');
END //
DELIMITER ;

-- Test RN010: Los créditos de una asignatura pueden ser 6 o 12
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn010_subject_credits()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN010', 'RN010: Los créditos de una asignatura pueden ser 6 o 12', 'PASS');

    CALL p_populate_grados();

    INSERT INTO subjects (subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
        VALUES (31, 3, 'Asignatura Créditos Inválidos', 'ACI', 8, 2, 'Obligatoria');

    CALL p_log_test('RN010', 'ERROR: Se permitió una asignatura con créditos inválidos', 'FAIL');
END //
DELIMITER ;

-- Test RN011: El valor de la nota está comprendido entre 0 y 10
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn011_grade_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN011', 'RN011: La nota debe estar entre 0 y 10', 'PASS');

    CALL p_populate_grados();

    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (201, 6, 1, 11.0, 'Primera', 0);

    CALL p_log_test('RN011', 'ERROR: Se permitió una nota fuera de rango', 'FAIL');
END //
DELIMITER ;

-- Test RN012: La edad de las personas está entre 16 y 70 años
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn012_people_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN012', 'RN012: La edad de las personas debe estar entre 16 y 70', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (105, '20000005E', 'Edad', 'Fuera', 80, 'edad@us.es', 'student', 'pbkdf2_sha256$1$00$00');

    CALL p_log_test('RN012', 'ERROR: Se permitió una edad fuera de rango', 'FAIL');
END //
DELIMITER ;

-- Test RN013: Los años de un grado están entre 3 y 6
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn013_degree_years()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN013', 'RN013: Los grados deben tener entre 3 y 6 años', 'PASS');

    CALL p_populate_grados();

    INSERT INTO degrees (degree_id, degree_name, duration_years)
        VALUES (10, 'Grado Experimental', 2);

    CALL p_log_test('RN013', 'ERROR: Se permitió un grado con años fuera de rango', 'FAIL');
END //
DELIMITER ;

-- Test RN014: El DNI está formado por 8 números y una letra
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn014_dni_format()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN014', 'RN014: El DNI debe tener 8 dígitos y una letra', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email, role, password_hash)
        VALUES (106, 'INVALIDO', 'DNI', 'Incorrecto', 30, 'dni@us.es', 'student', 'pbkdf2_sha256$1$00$00');

    CALL p_log_test('RN014', 'ERROR: Se permitió un DNI con formato inválido', 'FAIL');
END //
DELIMITER ;

-- Test RN015: El año académico está entre 2000 y 2100
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn015_academic_year()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN015', 'RN015: El año académico debe estar entre 2000 y 2100', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (20, 12, 'MD-T2025', 'Teoría', 1999);

    CALL p_log_test('RN015', 'ERROR: Se permitió un año académico fuera de rango', 'FAIL');
END //
DELIMITER ;

-- Test RN016: El curso de una asignatura está entre 1 y 6
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn016_course_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN016', 'RN016: El curso de una asignatura debe estar entre 1 y 6', 'PASS');

    CALL p_populate_grados();

    INSERT INTO subjects (subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
        VALUES (30, 3, 'Asignatura Fuera de Curso', 'AFC', 6, 0, 'Obligatoria');

    CALL p_log_test('RN016', 'ERROR: Se permitió un curso fuera de rango', 'FAIL');
END //
DELIMITER ;

-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_grados_tests()
BEGIN
    DELETE FROM test_results;

    CALL p_test_rn001_mh_requirement();
    CALL p_test_rn002_duplicate_grade();
    CALL p_test_rn003_professors_per_group();
    CALL p_test_rn004_student_group_limit();
    CALL p_test_rn005_grade_delta();
    CALL p_test_rn006_extra_group();
    CALL p_test_rn007_subject_enrollment();
    CALL p_test_rn008_min_age();
    CALL p_test_rn009_not_null_attributes();
    CALL p_test_rn010_subject_credits();
    CALL p_test_rn011_grade_range();
    CALL p_test_rn012_people_age();
    CALL p_test_rn013_degree_years();
    CALL p_test_rn014_dni_format();
    CALL p_test_rn015_academic_year();
    CALL p_test_rn016_course_range();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;

CALL p_run_grados_tests();
