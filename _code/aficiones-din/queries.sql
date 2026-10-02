-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Consultas de referencia para Aficiones Dinámicas
-- 

USE HobbiesDynamicDB;

-- Usuarios con sus aficiones
SELECT u.user_id, l.user_hobby_id, u.full_name, u.age, u.email, h.hobby_name
FROM users u
JOIN user_hobby_links l ON u.user_id = l.user_id
JOIN hobbies h ON h.hobby_id = l.hobby_id;

CREATE OR REPLACE VIEW v_user_hobbies AS
SELECT u.user_id, l.user_hobby_id, u.full_name, u.age, u.email, h.hobby_name
FROM users u
JOIN user_hobby_links l ON u.user_id = l.user_id
JOIN hobbies h ON h.hobby_id = l.hobby_id;

-- Usuarios a los que les gusta el cine
SELECT full_name, age, email
FROM v_user_hobbies
WHERE hobby_name LIKE '%cine%';

-- Usuarios sin aficiones
SELECT *
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM user_hobby_links l WHERE l.user_id = u.user_id
);

-- Número de aficiones por usuario
CREATE OR REPLACE VIEW v_user_hobby_count AS
SELECT user_id, full_name, email, COUNT(*) AS total
FROM v_user_hobbies
GROUP BY user_id;

SELECT * FROM v_user_hobby_count;

-- Máximo número de aficiones
SELECT MAX(total) AS max_hobbies FROM v_user_hobby_count;

-- Usuarios con el máximo número de aficiones
SELECT * FROM v_user_hobby_count
WHERE total = (SELECT MAX(total) FROM v_user_hobby_count);
