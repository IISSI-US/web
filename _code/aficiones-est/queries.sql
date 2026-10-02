-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Consultas de referencia para Aficiones estáticas
-- 

USE HobbiesStaticDB;

-- Usuarios con sus aficiones
SELECT u.user_id, h.hobby_id, u.full_name, u.age, u.email, h.hobby
FROM users u
JOIN user_hobbies h ON u.user_id = h.user_id;

CREATE OR REPLACE VIEW v_user_hobbies AS
SELECT u.user_id, h.hobby_id, u.full_name, u.age, u.email, h.hobby
FROM users u
JOIN user_hobbies h ON u.user_id = h.user_id;

-- Usuarios a los que les gusta el cine
SELECT full_name, age, email
FROM v_user_hobbies
WHERE hobby = 'CINE';

-- Usuarios sin aficiones
SELECT *
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM user_hobbies h WHERE h.user_id = u.user_id
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
