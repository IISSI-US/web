-- Variante didáctica de Usuarios con fecha de nacimiento.
-- Se ejecuta en una base independiente y no modifica UsersDB.

DROP DATABASE IF EXISTS Users_v2DB;
CREATE DATABASE Users_v2DB;
USE Users_v2DB;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    full_name VARCHAR(120) NOT NULL,
    gender ENUM('MASCULINO','FEMENINO','OTRO') NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id),
    CONSTRAINT rn02_users_unique_email UNIQUE (email)
);

DELIMITER //
CREATE OR REPLACE FUNCTION f_get_age_from_birth_date(p_birth_date DATE)
RETURNS TINYINT
NOT DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_birth_date, CURDATE());
END //

CREATE OR REPLACE PROCEDURE p_populate_users_v2()
BEGIN
    DELETE FROM users;
    ALTER TABLE users AUTO_INCREMENT = 1;

    INSERT INTO users (full_name, gender, birth_date, email) VALUES
        ('David Ruiz', 'MASCULINO', '1979-05-18', 'druiz@us.es'),
        ('Carlos Arevalo', 'MASCULINO', '1966-06-12', 'carevalo@us.es'),
        ('Margarita Cruz', 'FEMENINO', '1966-12-01', 'mcruz@us.es'),
        ('Inma Hernandez', 'FEMENINO', '1989-03-11', 'inmahernandez@us.es'),
        ('Alfonso Marquez', 'MASCULINO', '1989-04-12', 'amarquez@us.es'),
        ('Daniel Ayala', 'MASCULINO', '1996-05-13', 'dayala1@us.es'),
        ('Raquel Sampedro', 'FEMENINO', '1969-09-07', 'rsampedro@gmail.com'),
        ('Marta Lopez', 'FEMENINO', '2006-09-07', 'mlopez@mail.com'),
        ('David Ruiz', 'MASCULINO', '1999-09-07', 'druiz@mail.com'),
        ('Andrea Gomez', 'OTRO', '1982-01-10', 'agomez@mail.es'),
        ('Ernesto Murillo', 'OTRO', '1969-02-15', 'emurillo@correo.es');
END //

CREATE OR REPLACE TRIGGER t_bi_users_v2_birth_date
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN01: La fecha de nacimiento no puede ser futura';
    ELSEIF TIMESTAMPDIFF(YEAR, NEW.birth_date, CURDATE()) < 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN01: Los usuarios deben ser mayores de edad';
    END IF;
END //

CREATE OR REPLACE TRIGGER t_bu_users_v2_birth_date
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN01: La fecha de nacimiento no puede ser futura';
    ELSEIF TIMESTAMPDIFF(YEAR, NEW.birth_date, CURDATE()) < 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN01: Los usuarios deben ser mayores de edad';
    END IF;
END //
DELIMITER ;

CALL p_populate_users_v2();

-- RF01: Usuarios ordenados alfabéticamente
SELECT * FROM users ORDER BY full_name ASC;

-- RF02: Nombre y correo de las usuarias
SELECT full_name, email
FROM users
WHERE gender = 'FEMENINO';

-- RF03: Usuarios con dominio us.es
SELECT full_name, f_get_age_from_birth_date(birth_date) AS age, email
FROM users
WHERE email LIKE '%@us.es';

-- RF04: Estadísticas globales de edad
SELECT AVG(f_get_age_from_birth_date(birth_date)) AS average_age,
       COUNT(*) AS total_users
FROM users;

-- RF05: Estadísticas de edad y total por dominio
SELECT SUBSTRING_INDEX(email, '@', -1) AS email_domain,
       AVG(f_get_age_from_birth_date(birth_date)) AS average_age,
       COUNT(*) AS total_users
FROM users
GROUP BY email_domain
ORDER BY total_users DESC;

-- RF06: Distribución por género
SELECT gender,
       AVG(f_get_age_from_birth_date(birth_date)) AS average_age,
       COUNT(*) AS total_users
FROM users
GROUP BY gender;

-- RF07: Usuarios de mayor edad
SELECT u1.*
FROM users u1
WHERE f_get_age_from_birth_date(u1.birth_date) = (
    SELECT MAX(f_get_age_from_birth_date(u2.birth_date))
    FROM users u2
);

-- RF08: Usuario de mayor edad por género
SELECT u1.*
FROM users u1
WHERE f_get_age_from_birth_date(u1.birth_date) = (
    SELECT MAX(f_get_age_from_birth_date(u2.birth_date))
    FROM users u2
    WHERE u2.gender = u1.gender
);

