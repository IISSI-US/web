-- Usuarios, roles y permisos de MariaDB para acceso SQL directo (RNF001).
-- Las contraseñas siguen la convención utilizada en el entorno de prácticas.

CREATE ROLE IF NOT EXISTS grades_admin;
CREATE ROLE IF NOT EXISTS grades_teacher;
CREATE ROLE IF NOT EXISTS grades_student;

GRANT ALL PRIVILEGES ON GradesDB.* TO grades_admin;

GRANT SELECT ON GradesDB.* TO grades_teacher;
GRANT INSERT, UPDATE, DELETE ON GradesDB.grades TO grades_teacher;

GRANT SELECT ON GradesDB.* TO grades_student;

CREATE USER IF NOT EXISTS 'admin_grades'@'localhost' IDENTIFIED BY 'grades$admin';
CREATE USER IF NOT EXISTS 'teacher_grades'@'localhost' IDENTIFIED BY 'grades$teacher';
CREATE USER IF NOT EXISTS 'student_grades'@'localhost' IDENTIFIED BY 'grades$student';

GRANT grades_admin TO 'admin_grades'@'localhost';
GRANT grades_teacher TO 'teacher_grades'@'localhost';
GRANT grades_student TO 'student_grades'@'localhost';
GRANT grades_admin TO 'iissi_user'@'localhost';

SET DEFAULT ROLE grades_admin FOR 'admin_grades'@'localhost';
SET DEFAULT ROLE grades_teacher FOR 'teacher_grades'@'localhost';
SET DEFAULT ROLE grades_student FOR 'student_grades'@'localhost';
SET DEFAULT ROLE grades_admin FOR 'iissi_user'@'localhost';
