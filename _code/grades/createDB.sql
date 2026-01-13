-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2024
-- Descripción: Script para crear la BD de Grados
-- 

DROP DATABASE IF EXISTS GradesDB;
CREATE DATABASE GradesDB;
USE GradesDB;

-- ============================================================================
-- Eliminamos tablas previas siguiendo el orden inverso de dependencias
-- ============================================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS teaching_loads;
DROP TABLE IF EXISTS group_enrollments;
DROP TABLE IF EXISTS subject_enrollments;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS degrees;
DROP TABLE IF EXISTS people;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- Tabla: people
-- ============================================================================
CREATE TABLE people (
    person_id INT AUTO_INCREMENT,
    dni CHAR(9) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    age TINYINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (person_id),
    CONSTRAINT rn_uq_people_dni UNIQUE (dni),
    CONSTRAINT rn_uq_people_email UNIQUE (email)
);

-- ============================================================================
-- Tabla: professors
-- ============================================================================
CREATE TABLE professors (
    professor_id INT,
    category VARCHAR(30) NOT NULL,
    PRIMARY KEY (professor_id),
    FOREIGN KEY (professor_id) REFERENCES people(person_id)
);

-- ============================================================================
-- Tabla: students
-- ============================================================================
CREATE TABLE students (
    student_id INT,
    access_method VARCHAR(20) NOT NULL,
    PRIMARY KEY (student_id),
    FOREIGN KEY (student_id) REFERENCES people(person_id)
);

-- ============================================================================
-- Tabla: degrees
-- ============================================================================
CREATE TABLE degrees (
    degree_id INT AUTO_INCREMENT,
    degree_name VARCHAR(80) NOT NULL,
    duration_years TINYINT NOT NULL,
    PRIMARY KEY (degree_id),
    CONSTRAINT rn_uq_degrees_name UNIQUE (degree_name)
);

-- ============================================================================
-- Tabla: subjects
-- ============================================================================
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT,
    degree_id INT NOT NULL,
    subject_name VARCHAR(120) NOT NULL,
    acronym VARCHAR(12) NOT NULL,
    credits TINYINT NOT NULL,
    course TINYINT NOT NULL,
    subject_type VARCHAR(30) NOT NULL,
    PRIMARY KEY (subject_id),
    CONSTRAINT rn_uq_subjects_name UNIQUE (subject_name),
    CONSTRAINT rn_uq_subjects_acronym UNIQUE (acronym),
    FOREIGN KEY (degree_id) REFERENCES degrees(degree_id)
);

-- ============================================================================
-- Tabla: subject_enrollments
-- ============================================================================
CREATE TABLE subject_enrollments (
    student_id INT,
    subject_id INT,
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- ============================================================================
-- Tabla: groups
-- ============================================================================
CREATE TABLE groups (
    group_id INT AUTO_INCREMENT,
    subject_id INT NOT NULL,
    group_name VARCHAR(40) NOT NULL,
    activity VARCHAR(15) NOT NULL,
    academic_year YEAR NOT NULL,
    PRIMARY KEY (group_id),
    CONSTRAINT rn_uq_groups_name UNIQUE (subject_id, group_name, academic_year),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- ============================================================================
-- Tabla: group_enrollments
-- ============================================================================
CREATE TABLE group_enrollments (
    student_id INT,
    group_id INT,
    PRIMARY KEY (student_id, group_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (group_id) REFERENCES groups(group_id)
);

-- ============================================================================
-- Tabla: teaching_loads
-- ============================================================================
CREATE TABLE teaching_loads (
    professor_id INT,
    group_id INT,
    credits DECIMAL(4,1) NOT NULL,
    PRIMARY KEY (professor_id, group_id),
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id),
    FOREIGN KEY (group_id) REFERENCES groups(group_id)
);

-- ============================================================================
-- Tabla: grades
-- ============================================================================
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT,
    student_id INT NOT NULL,
    group_id INT NOT NULL,
    grade_value DECIMAL(4,2) NOT NULL,
    exam_call VARCHAR(20) NOT NULL,
    with_honors BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (grade_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (group_id) REFERENCES groups(group_id)
);

-- ============================================================================
-- RESTRICCIONES (CHECK) SEGÚN EL MODELO
-- ============================================================================
ALTER TABLE people
    ADD CONSTRAINT rn12_people_age CHECK (age BETWEEN 16 AND 70),
    ADD CONSTRAINT rn14_people_dni CHECK (dni REGEXP '^[0-9]{8}[A-Za-z]$');

ALTER TABLE professors
    ADD CONSTRAINT rn20_professors_category CHECK (
        category IN ('Ayudante','AyudanteDoctor','Titular','Catedrático')
    );

ALTER TABLE students
    ADD CONSTRAINT rn19_students_access_method CHECK (
        access_method IN ('Selectividad','Ciclo','Mayor','Titulado','Extranjero')
    );

ALTER TABLE degrees
    ADD CONSTRAINT rn13_degree_duration CHECK (duration_years BETWEEN 3 AND 6);

ALTER TABLE subjects
    ADD CONSTRAINT rn10_subjects_credits CHECK (credits IN (6, 12)),
    ADD CONSTRAINT rn16_subjects_course CHECK (course BETWEEN 1 AND 6),
    ADD CONSTRAINT ck_subjects_type CHECK (
        subject_type IN ('Formación Básica','Obligatoria','Optativa')
    );

ALTER TABLE groups
    ADD CONSTRAINT rn15_groups_year CHECK (academic_year BETWEEN 2000 AND 2100),
    ADD CONSTRAINT ck_groups_activity CHECK (
        activity IN ('Teoría','Laboratorio')
    );

ALTER TABLE teaching_loads
    ADD CONSTRAINT rn21_teaching_loads_credits CHECK (credits > 0);

ALTER TABLE grades
    ADD CONSTRAINT rn11_grades_value CHECK (grade_value BETWEEN 0 AND 10),
    ADD CONSTRAINT rn08_grades_with_honors CHECK (
        with_honors = 0 OR grade_value >= 9
    ),
    ADD CONSTRAINT rn18_grades_exam_call CHECK (
        exam_call IN ('Primera','Segunda','Tercera','Extraordinaria')
    );

-- ============================================================================
-- TRIGGERS PARA LAS RN COMPLEJAS
-- ============================================================================

DELIMITER //

-- RN08: Un alumno no puede acceder por selectividad teniendo menos de 16 años
CREATE OR REPLACE TRIGGER t_biu_students_rn08
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
BEGIN
    DECLARE v_age TINYINT;
    IF NEW.access_method = 'Selectividad' THEN
        SELECT age INTO v_age FROM people WHERE person_id = NEW.student_id;
        IF v_age < 16 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN08: No se puede acceder por Selectividad con menos de 16 años';
        END IF;
    END IF;
END//

-- RN02: Un alumno solo puede tener notas en grupos a los que pertenece
CREATE OR REPLACE TRIGGER t_biu_grades_rn02
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM group_enrollments
    WHERE student_id = NEW.student_id
      AND group_id = NEW.group_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN02: El alumno no pertenece al grupo indicado';
    END IF;
END//

CREATE OR REPLACE TRIGGER t_biu_grades_rn01
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
    DECLARE v_subject_id INT;
    DECLARE v_academic_year YEAR;
    DECLARE v_exists INT;

    SELECT subject_id, academic_year INTO v_subject_id, v_academic_year
    FROM groups
    WHERE group_id = NEW.group_id;

    SELECT COUNT(*) INTO v_exists
    FROM grades g
    JOIN groups gr ON gr.group_id = g.group_id
    WHERE g.student_id = NEW.student_id
      AND g.exam_call = NEW.exam_call
      AND gr.subject_id = v_subject_id
      AND gr.academic_year = v_academic_year
      AND (NEW.grade_id IS NULL OR g.grade_id <> NEW.grade_id);

    IF v_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN01: Ya existe una nota para la misma asignatura, convocatoria y año académico';
    END IF;
END//

-- RN05: Una nota no puede modificarse en más de 4 puntos
CREATE OR REPLACE TRIGGER t_bu_grades_rn05
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
    IF ABS(NEW.grade_value - OLD.grade_value) > 4 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN05: No se puede modificar la nota en más de 4 puntos';
    END IF;
END//

-- RN03: Un grupo no puede tener más de 2 profesores
CREATE OR REPLACE TRIGGER t_bi_teaching_loads_rn03
BEFORE INSERT ON teaching_loads
FOR EACH ROW
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM teaching_loads
    WHERE group_id = NEW.group_id;

    IF v_count >= 2 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN03: El grupo ya tiene 2 profesores asignados';
    END IF;
END//

CREATE OR REPLACE TRIGGER t_bu_teaching_loads_rn03
BEFORE UPDATE ON teaching_loads
FOR EACH ROW
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM teaching_loads
    WHERE group_id = NEW.group_id
      AND NOT (professor_id = OLD.professor_id AND group_id = OLD.group_id);

    IF v_count >= 2 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN03: El grupo ya tiene 2 profesores asignados';
    END IF;
END//

-- Funciones auxiliares para límites de grupos
CREATE OR REPLACE FUNCTION f_student_group_limit(
    p_student_id INT,
    p_subject_id INT,
    p_activity VARCHAR(15),
    p_excluded_group INT
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_count INT;
    DECLARE v_result BOOLEAN DEFAULT FALSE;
    SELECT COUNT(*) INTO v_count
    FROM group_enrollments ge
    JOIN groups g ON g.group_id = ge.group_id
    WHERE ge.student_id = p_student_id
      AND g.subject_id = p_subject_id
      AND g.activity = p_activity
      AND (p_excluded_group IS NULL OR ge.group_id <> p_excluded_group);

    IF p_activity = 'Teoría' THEN
        SET v_result = (v_count >= 1);
    ELSEIF p_activity = 'Laboratorio' THEN
        SET v_result = (v_count >= 1);
    END IF;
    RETURN v_result;
END//

CREATE OR REPLACE FUNCTION f_is_student_enrolled(
    p_student_id INT,
    p_subject_id INT
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_exists INT;
    SELECT COUNT(*) INTO v_exists
    FROM subject_enrollments
    WHERE student_id = p_student_id
      AND subject_id = p_subject_id;
    RETURN v_exists > 0;
END//

CREATE OR REPLACE FUNCTION f_count_subject_groups(
    p_subject_id INT,
    p_activity VARCHAR(15),
    p_excluded_group INT
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_count INT;
    DECLARE v_result BOOLEAN DEFAULT FALSE;
    IF p_activity = 'Teoría' THEN
        SELECT COUNT(*) INTO v_count
        FROM groups
        WHERE subject_id = p_subject_id
          AND activity = 'Teoría'
          AND (p_excluded_group IS NULL OR group_id <> p_excluded_group);
        SET v_result = (v_count >= 1);
    ELSEIF p_activity = 'Laboratorio' THEN
        SELECT COUNT(*) INTO v_count
        FROM groups
        WHERE subject_id = p_subject_id
          AND activity = 'Laboratorio'
          AND (p_excluded_group IS NULL OR group_id <> p_excluded_group);
        SET v_result = (v_count >= 2);
    END IF;
    RETURN v_result;
END//

-- RN04: Límite de grupos de teoría y laboratorio por alumno y asignatura
CREATE OR REPLACE TRIGGER t_bi_group_enrollments_rn04
BEFORE INSERT ON group_enrollments
FOR EACH ROW
BEGIN
    DECLARE v_subject_id INT;
    DECLARE v_activity VARCHAR(15);
    SELECT subject_id, activity INTO v_subject_id, v_activity
    FROM groups
    WHERE group_id = NEW.group_id;

    IF NOT f_is_student_enrolled(NEW.student_id, v_subject_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN07: El alumno debe estar matriculado en la asignatura';
    END IF;

    IF f_student_group_limit(NEW.student_id, v_subject_id, v_activity, NULL) THEN
        IF v_activity = 'Teoría' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN04: Solo puede haber un grupo de teoría por asignatura y alumno';
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN04: Solo puede haber dos grupos de laboratorio por asignatura y alumno';
        END IF;
    END IF;
END//

CREATE OR REPLACE TRIGGER t_bu_group_enrollments_rn04
BEFORE UPDATE ON group_enrollments
FOR EACH ROW
BEGIN
    DECLARE v_subject_id INT;
    DECLARE v_activity VARCHAR(15);
    SELECT subject_id, activity INTO v_subject_id, v_activity
    FROM groups
    WHERE group_id = NEW.group_id;

    IF NOT f_is_student_enrolled(NEW.student_id, v_subject_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN07: El alumno debe estar matriculado en la asignatura';
    END IF;

    IF f_student_group_limit(NEW.student_id, v_subject_id, v_activity, OLD.group_id) THEN
        IF v_activity = 'Teoría' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN04: Solo puede haber un grupo de teoría por asignatura y alumno';
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN04: Solo puede haber dos grupos de laboratorio por asignatura y alumno';
        END IF;
    END IF;
END//

CREATE OR REPLACE TRIGGER t_bi_groups_rn06
BEFORE INSERT ON groups
FOR EACH ROW
BEGIN
    IF f_count_subject_groups(NEW.subject_id, NEW.activity, NULL) THEN
        IF NEW.activity = 'Teoría' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN06: Solo puede existir un grupo de teoría por asignatura';
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN06: Solo pueden existir dos grupos de laboratorio por asignatura';
        END IF;
    END IF;
END//

CREATE OR REPLACE TRIGGER t_bu_groups_rn06
BEFORE UPDATE ON groups
FOR EACH ROW
BEGIN
    IF f_count_subject_groups(NEW.subject_id, NEW.activity, OLD.group_id) THEN
        IF NEW.activity = 'Teoría' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN06: Solo puede existir un grupo de teoría por asignatura';
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN06: Solo pueden existir dos grupos de laboratorio por asignatura';
        END IF;
    END IF;
END//

DELIMITER ;