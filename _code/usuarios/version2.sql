-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Variante didáctica de Usuarios donde se guarda la fecha de nacimiento
--              y la edad se calcula con una función. No se usa en el proyecto real,
--              solo como ejemplo para alumnos.
-- 

USE UsersDB;

-- =====================================================================
-- Ejemplo de tabla con fecha de nacimiento en lugar de campo age entero
-- =====================================================================
-- DROP TABLE IF EXISTS users;
-- CREATE TABLE users (
--     user_id INT AUTO_INCREMENT,
--     full_name VARCHAR(120) NOT NULL,
--     gender ENUM('MASCULINO','FEMENINO','OTRO') NOT NULL,
--     birth_date DATE NOT NULL,
--     email VARCHAR(255) NOT NULL,
--     PRIMARY KEY (user_id),
--     CONSTRAINT rn01_users_adult_age CHECK (TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) >= 18),
--     CONSTRAINT rn02_users_unique_email UNIQUE (email)
-- );

-- =====================================================================
-- Populate alternativo usando birth_date
-- =====================================================================
-- DELIMITER //
-- CREATE OR REPLACE PROCEDURE p_populate_users_v2()
-- BEGIN
--     DELETE FROM users;
--     ALTER TABLE users AUTO_INCREMENT = 1;

--     INSERT INTO users (full_name, gender, birth_date, email) VALUES
--         ('David Ruiz', 'MASCULINO', '1979-05-18', 'druiz@us.es'),
--         ('Carlos Arévalo', 'MASCULINO', '1966-06-12', 'carevalo@us.es'),
--         ('Margarita Cruz', 'FEMENINO', '1966-12-01', 'mcruz@us.es'),
--         ('Inma Hernández', 'FEMENINO', '1989-03-11', 'inmahernandez@us.es'),
--         ('Alfonso Márquez', 'MASCULINO', '1989-04-12', 'amarquez@us.es'),
--         ('Daniel Ayala', 'MASCULINO', '1996-05-13', 'dayala1@us.es'),
--         ('Raquel Sampedro', 'FEMENINO', '1969-09-07', 'rsampedro@gmail.com'),
--         ('Marta López', 'FEMENINO', '2006-09-07', 'mlopez@mail.com'),
--         ('David Ruiz', 'MASCULINO', '1999-09-07', 'druiz@mail.com'),
--         ('Andrea Gómez', 'OTRO', '1982-01-10', 'agomez@mail.es'),
--         ('Ernesto Murillo', 'OTRO', '1969-02-15', 'emurillo@correo.es');
-- END //
-- DELIMITER ;

-- =====================================================================
-- Función para calcular la edad a partir de la fecha de nacimiento
-- =====================================================================
DELIMITER //
CREATE OR REPLACE FUNCTION f_get_age_from_birth_date(p_birth_date DATE)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_birth_date, CURDATE());
END //
DELIMITER ;

-- =====================================================================
-- Ejemplos de uso
-- =====================================================================
-- SELECT full_name, birth_date, f_get_age_from_birth_date(birth_date) AS age
-- FROM users;
--
-- INSERT INTO users (full_name, gender, birth_date, email)
-- VALUES ('Alumno Ejemplo', 'MASCULINO', '2000-05-10', 'ejemplo@us.es');

-- =====================================================================
-- Consultas adaptadas a birth_date (en lugar de age)
-- =====================================================================
-- RF01: Usuarios ordenados alfabéticamente
-- SELECT * FROM users ORDER BY full_name ASC;

-- RF02: Nombre y correo de las usuarias
-- SELECT full_name, email FROM users WHERE gender = 'FEMENINO';

-- RF03: Usuarios con dominio us.es
-- SELECT full_name, f_get_age_from_birth_date(birth_date) AS age, email
-- FROM users
-- WHERE email LIKE '%@us.es';

-- RF04: Estadísticas globales de edad
-- SELECT AVG(f_get_age_from_birth_date(birth_date)) AS average_age, COUNT(*) AS total_users
-- FROM users;

-- RF05: Estadísticas de edad y total por dominio
-- SELECT f_get_email_domain(email) AS email_domain,
--        AVG(f_get_age_from_birth_date(birth_date)) AS average_age,
--        COUNT(*) AS total_users
-- FROM users
-- GROUP BY email_domain
-- ORDER BY total_users DESC;

-- RF06: Distribución por género
-- SELECT gender,
--        AVG(f_get_age_from_birth_date(birth_date)) AS average_age,
--        COUNT(*) AS total_users
-- FROM users
-- GROUP BY gender;

-- RF07: Usuarios de mayor edad
-- SELECT * FROM users
-- WHERE f_get_age_from_birth_date(birth_date) = (
--     SELECT MAX(f_get_age_from_birth_date(birth_date)) FROM users
-- );

-- RF08: Usuario de mayor edad por género
-- SELECT u1.*
-- FROM users u1
-- WHERE f_get_age_from_birth_date(birth_date) = (
--     SELECT MAX(f_get_age_from_birth_date(birth_date))
--     FROM users u2
--     WHERE u2.gender = u1.gender
-- );

