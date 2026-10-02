-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Procedimiento para poblar la BD de Aficiones Dinámicas
-- 
USE HobbiesDynamicDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    DELETE FROM user_hobby_links;
    DELETE FROM hobbies;
    DELETE FROM users;

    ALTER TABLE users AUTO_INCREMENT = 1;
    INSERT INTO users (full_name, gender, age, email) VALUES
        ('David Ruiz', 'MASCULINO', 45, 'druiz@us.es'),
        ('Carlos Arévalo', 'MASCULINO', 58, 'carevalo@us.es'),
        ('Margarita Cruz', 'FEMENINO', 58, 'mcruz@us.es'),
        ('Inma Hernández', 'FEMENINO', 35, 'inmahernandez@us.es'),
        ('Alfonso Márquez', 'MASCULINO', 35, 'amarquez@us.es'),
        ('Daniel Ayala', 'MASCULINO', 28, 'dayala1@us.es'),
        ('Raquel Sampedro', 'FEMENINO', 55, 'rsampedro@gmail.com'),
        ('Marta López', 'FEMENINO', 18, 'mlopez@mail.com'),
        ('David Ruiz', 'MASCULINO', 25, 'druiz@mail.com'),
        ('Andrea Gómez', 'OTRO', 42, 'agomez@mail.es'),
        ('Ernesto Murillo', 'OTRO', 55, 'emurillo@correo.es');

    ALTER TABLE hobbies AUTO_INCREMENT = 1;
    INSERT INTO hobbies (hobby_name) VALUES
        ('Leer'),
        ('Ir al cine'),
        ('Hacer deporte'),
        ('Hacer de comer'),
        ('Montar a caballo');

    ALTER TABLE user_hobby_links AUTO_INCREMENT = 1;
    INSERT INTO user_hobby_links (user_id, hobby_id) VALUES
        (1,3), (1,4),
        (2,3), (2,1), (2,2),
        (4,4), (4,2), (4,1),
        (5,3),
        (6,2),
        (8,3), (8,4), (8,1), (8,2),
        (9,3), (9,1), (9,2),
        (10,4),
        (11,5);
END //
DELIMITER ;

CALL p_populate();
