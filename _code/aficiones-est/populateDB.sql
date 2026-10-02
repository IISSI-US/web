-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Procedimiento para poblar la BD de Aficiones estáticas
-- 
USE HobbiesStaticDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    DELETE FROM user_hobbies;
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

    ALTER TABLE user_hobbies AUTO_INCREMENT = 1;
    INSERT INTO user_hobbies (user_id, hobby) VALUES
        (1,'DEPORTE'), (1,'GASTRONOMIA'),
        (2,'DEPORTE'), (2,'LITERATURA'), (2,'CINE'),
        (4,'GASTRONOMIA'), (4,'CINE'), (4,'LITERATURA'),
        (5,'DEPORTE'),
        (6,'CINE'),
        (8,'DEPORTE'), (8,'GASTRONOMIA'), (8,'LITERATURA'), (8,'CINE'),
        (9,'DEPORTE'), (9,'LITERATURA'), (9,'CINE'),
        (10,'GASTRONOMIA');
END //
DELIMITER ;

CALL p_populate();
