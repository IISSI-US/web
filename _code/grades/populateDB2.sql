--
-- Autor: David Ruiz
-- Fecha: Enero 2026
-- Descripción: Datos adicionales para GradesDB para cubrir consultas de L3
--              Este script añade datos sin borrar los existentes de populateDB.sql
--
USE GradesDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate_grados_extra()
BEGIN
    -- Eliminar datos adicionales si ya existen (hacer el procedimiento idempotente)
    DELETE FROM grades WHERE grade_id >= 36;
    DELETE FROM teaching_loads WHERE group_id >= 4;
    DELETE FROM group_enrollments WHERE group_id >= 4;
    DELETE FROM subject_enrollments WHERE subject_id >= 18 OR (student_id >= 6 AND subject_id IN (1, 2, 10));
    DELETE FROM groups WHERE group_id >= 4;
    DELETE FROM subjects WHERE subject_id >= 18;

    -- Añadir más asignaturas a otros grados para consultas de agregación
    INSERT INTO subjects (
        subject_id,
        degree_id,
        subject_name,
        acronym,
        credits,
        course,
        subject_type
    ) VALUES
        -- Ingeniería del Software (degree_id = 1)
        (18, 1, 'Fundamentos de Programación Orientada a Objetos', 'FPOO', 12, 1, 'Formación Básica'),
        (19, 1, 'Bases de Datos', 'BD', 6, 2, 'Obligatoria'),
        (20, 1, 'Ingeniería del Software', 'IS', 6, 2, 'Obligatoria'),
        (21, 1, 'Sistemas de Información', 'SI', 6, 3, 'Obligatoria'),
        (22, 1, 'Gestión de Proyectos', 'GP', 6, 3, 'Obligatoria'),
        (23, 1, 'Calidad del Software', 'CS', 6, 3, 'Obligatoria'),
        -- Ingeniería de Computadores (degree_id = 2)
        (24, 2, 'Fundamentos de Computadores', 'FC', 12, 1, 'Formación Básica'),
        (25, 2, 'Sistemas Digitales', 'SD', 6, 2, 'Obligatoria'),
        (26, 2, 'Arquitectura de Computadores Avanzada', 'ACA', 6, 3, 'Obligatoria'),
        -- Más asignaturas para TI (degree_id = 3)
        (27, 3, 'Fundamentos de Ingeniería del Software', 'FIS', 6, 3, 'Obligatoria'),
        (28, 3, 'Desarrollo de Sistemas de Información', 'DSI', 6, 3, 'Obligatoria'),
        (29, 3, 'Seguridad Informática', 'SEG', 6, 4, 'Optativa');

    -- Añadir más grupos para consultas de DISTINCT, COUNT, etc.
    -- IMPORTANTE: Respetando RN006 (máx. 1 grupo teoría y 2 laboratorio por asignatura)
    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year) VALUES
        -- Grupos para FP (subject_id = 1) - 1 teoría + 2 laboratorio
        (4, 1, 'T1', 'Teoría', 2024),
        (5, 1, 'L1', 'Laboratorio', 2024),
        (6, 1, 'L2', 'Laboratorio', 2024),
        -- Grupos para ADDA (subject_id = 10) - 1 teoría + 2 laboratorio
        (7, 10, 'T1', 'Teoría', 2024),
        (8, 10, 'L1', 'Laboratorio', 2024),
        (9, 10, 'L2', 'Laboratorio', 2024),
        -- Grupos para CIN (subject_id = 2) - 1 teoría + 2 laboratorio
        (10, 2, 'T1', 'Teoría', 2024),
        (11, 2, 'L1', 'Laboratorio', 2024),
        (12, 2, 'L2', 'Laboratorio', 2024),
        -- Grupos para MD (subject_id = 12) - 1 teoría + 2 laboratorio
        (13, 12, 'T1', 'Teoría', 2024),
        (14, 12, 'L1', 'Laboratorio', 2024),
        (15, 12, 'L2', 'Laboratorio', 2024),
        -- Grupos de años anteriores para consultas de rango
        (16, 11, 'T1', 'Teoría', 2023),
        (17, 11, 'L1', 'Laboratorio', 2023),
        (18, 1, 'T1', 'Teoría', 2023),
        (19, 10, 'T1', 'Teoría', 2023),
        (20, 11, 'T1', 'Teoría', 2022),
        (21, 1, 'T1', 'Teoría', 2022),
        (22, 11, 'T1', 'Teoría', 2021),
        (23, 1, 'T1', 'Teoría', 2020);

    -- Matricular estudiantes en asignaturas adicionales (ANTES de añadirlos a grupos)
    -- RN07: Un alumno sólo puede pertenecer a grupos de asignaturas en las que está matriculado
    INSERT INTO subject_enrollments (student_id, subject_id) VALUES
        (6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
        (11, 1), (12, 1), (13, 1), (14, 1), (15, 1),
        (16, 1), (17, 1), (18, 1), (19, 1), (20, 1),
        (6, 10), (7, 10), (8, 10), (9, 10), (10, 10),
        (11, 10), (12, 10), (13, 10), (14, 10), (15, 10),
        (6, 2), (7, 2), (8, 2), (9, 2), (10, 2);

    -- Más matrículas en grupos para LEFT JOIN y análisis
    INSERT INTO group_enrollments (student_id, group_id) VALUES
        -- Estudiantes en grupos de FP (subject_id = 1)
        (6, 4), (7, 4), (8, 4), (9, 4), (10, 4),
        (11, 4), (12, 4), (13, 4), (14, 4), (15, 4),
        (16, 4), (17, 4), (18, 4), (19, 4), (20, 4),
        (6, 5), (7, 5), (8, 5), (9, 5), (10, 5),
        (16, 6), (17, 6), (18, 6), (19, 6), (20, 6),
        -- Estudiantes en grupos de ADDA (subject_id = 10)
        (6, 7), (7, 7), (8, 7), (9, 7), (10, 7),
        (11, 7), (12, 7), (13, 7), (14, 7), (15, 7),
        (6, 8), (7, 8), (8, 8), (9, 8), (10, 8),
        -- Estudiantes en grupos de CIN (subject_id = 2)
        (6, 10), (7, 10), (8, 10), (9, 10), (10, 10),
        (6, 11), (7, 11), (8, 11);

    -- Más cargas docentes (RN003: máximo 2 profesores por grupo)
    INSERT INTO teaching_loads (professor_id, group_id, credits) VALUES
        (1, 4, 3.0),
        (2, 5, 1.5),
        (3, 6, 1.5),
        (4, 7, 6.0),
        (1, 8, 1.5),
        (2, 9, 1.5),
        (3, 10, 3.0),
        (4, 11, 1.5);

    -- Más notas para consultas diversas
    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors) VALUES
        -- Notas en grupo 4 (FP Teoría 2024)
        (36, 6, 4, 7.5, 'Primera', 0),
        (37, 7, 4, 8.2, 'Primera', 0),
        (38, 8, 4, 6.5, 'Primera', 0),
        (39, 9, 4, 9.5, 'Primera', 1),
        (40, 10, 4, 9.8, 'Primera', 1),
        (41, 11, 4, 7.0, 'Primera', 0),
        (42, 12, 4, 8.5, 'Primera', 0),
        (43, 13, 4, 9.0, 'Primera', 0),
        (44, 14, 4, 9.2, 'Primera', 1),
        (45, 15, 4, 8.8, 'Primera', 0),
        (46, 16, 4, 7.8, 'Primera', 0),
        (47, 17, 4, 8.0, 'Primera', 0),
        (48, 18, 4, 9.1, 'Primera', 1),
        (49, 19, 4, 8.7, 'Primera', 0),
        (50, 20, 4, 9.3, 'Primera', 1),
        -- Notas en grupo 7 (ADDA Teoría 2024)
        (51, 6, 7, 6.0, 'Primera', 0),
        (52, 7, 7, 7.5, 'Primera', 0),
        (53, 8, 7, 5.5, 'Primera', 0),
        (54, 9, 7, 8.5, 'Primera', 0),
        (55, 10, 7, 7.8, 'Primera', 0),
        (56, 11, 7, 6.2, 'Primera', 0),
        (57, 12, 7, 7.0, 'Primera', 0),
        (58, 13, 7, 8.0, 'Primera', 0),
        (59, 14, 7, 7.2, 'Primera', 0),
        (60, 15, 7, 6.8, 'Primera', 0),
        -- Notas en grupo 10 (CIN Teoría 2024)
        (61, 6, 10, 5.5, 'Primera', 0),
        (62, 7, 10, 6.0, 'Primera', 0),
        (63, 8, 10, 7.5, 'Primera', 0),
        (64, 9, 10, 8.0, 'Primera', 0),
        (65, 10, 10, 6.5, 'Primera', 0);

END //
DELIMITER ;

-- Ejecutar el procedimiento
CALL p_populate_grados_extra();
