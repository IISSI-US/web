
--
-- Usuarios, roles y permisos para la BD de Grados
--
USE GradesDB;

CREATE TABLE IF NOT EXISTS credentials (
    credential_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    role ENUM('admin','teacher','student') NOT NULL DEFAULT 'student',
    password_hash VARCHAR(256) NOT NULL DEFAULT '',
    CONSTRAINT ak_email UNIQUE(email)
);

-- INSERT INTO credentials (email, role)
-- VALUES
--     ('druiz@us.es', 'admin'),
--     ('inmahernandez@us.es', 'teacher'),
--     ('david.romero@alum.us.es', 'student');

-- -- Comentado para Silence
-- -- ROLES

-- -- Admin: todos los privilegios sobre la BD
-- CREATE ROLE IF NOT EXISTS role_admin;

-- -- Teacher: lectura de toda la BD y escritura limitada en 'grades'
-- CREATE ROLE IF NOT EXISTS role_teacher;

-- -- Student: lectura de toda la BD
-- CREATE ROLE IF NOT EXISTS role_student;

-- -- 3) PRIVILEGIOS A LOS ROLES (en este orden)
-- -- Admin (total sobre la BD)
-- GRANT ALL PRIVILEGES ON GradesDB.* TO role_admin;

-- -- Teacher:
-- --   - Lectura de toda la BD (para que pueda navegar y hacer SELECT en todas las tablas)
-- --   - Modificaciones SOLO en 'grades'
-- GRANT SELECT ON GradesDB.* TO role_teacher;
-- GRANT INSERT, UPDATE ON GradesDB.grades TO role_teacher;

-- -- Student: solo lectura en toda la BD
-- GRANT SELECT ON GradesDB.* TO role_student;

-- -- USUARIOS y asignación de roles

-- CREATE USER IF NOT EXISTS 'admin_grados'@'%' IDENTIFIED BY 'druiz';
-- GRANT role_admin TO 'admin_grados'@'%';

-- CREATE USER IF NOT EXISTS 'teacher_grados'@'%' IDENTIFIED BY 'inmahernandez';
-- GRANT role_teacher TO 'teacher_grados'@'%';

-- CREATE USER IF NOT EXISTS 'student_grados'@'%' IDENTIFIED BY 'david.romero';
-- GRANT role_student TO 'student_grados'@'%';

-- -- Activar ROL por defecto (clave para que funcione al iniciar sesión)
-- -- Al iniciar sesión desde HeidiSQL odesde la línea de comando, debe activarse el rol
-- -- por defecto para que el usuario tenga los permisos asignados al rol.

-- -- Ejecuta los siguientes escenarios de test
-- -- SET ROLE role_admin TO 'admin_grados'@'%';
-- -- SOURCE test_admin.sql;

-- -- SET ROLE role_teacher TO 'teacher_grados'@'%';
-- -- SOURCE test_teacher.sql;

-- -- SET ROLE role_student TO 'student_grados'@'%';  
-- -- SOURCE test_student.sql;
