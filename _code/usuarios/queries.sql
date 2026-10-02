-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Consultas de referencia para la BD de Usuarios
-- 

USE UsersDB;

-- RF01: Usuarios ordenados alfabéticamente
SELECT *
FROM users
ORDER BY full_name ASC;

-- RF02: Nombre y correo de las usuarias
SELECT full_name, email
FROM users
WHERE gender = 'FEMENINO';

-- RF03: Usuarios con dominio corporativo us.es
SELECT full_name, age, email
FROM users
WHERE email LIKE '%@us.es';

-- RF04: Estadísticas globales de edad
SELECT AVG(age) AS average_age, COUNT(*) AS total_users
FROM users;

-- RF05: Estadísticas de edad y total por dominio
SELECT f_get_email_domain(email) AS email_domain,
       AVG(age) AS average_age,
       COUNT(*) AS total_users
FROM users
GROUP BY email_domain
ORDER BY total_users DESC;

-- RF06: Distribución por género
SELECT gender, AVG(age) AS average_age, COUNT(*) AS total_users
FROM users
GROUP BY gender;

-- RF07: Usuarios de mayor edad
SELECT *
FROM users
WHERE age = (SELECT MAX(age) FROM users);

-- RF08: Usuario de mayor edad por género
SELECT u1.*
FROM users u1
WHERE age = (
    SELECT MAX(u2.age)
    FROM users u2
    WHERE u2.gender = u1.gender
);
