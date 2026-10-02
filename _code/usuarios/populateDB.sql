-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Procedimiento para poblar la BD de Usuarios
-- 
USE UsersDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    DELETE FROM users;
    ALTER TABLE users AUTO_INCREMENT = 1;

    INSERT INTO users (full_name, gender, age, email) VALUES
        ('David Ruiz', 'MASCULINO', 45, 'druiz@us.es'),
        ('Carlos Arevalo', 'MASCULINO', 58, 'carevalo@us.es'),
        ('Margarita Cruz', 'FEMENINO', 58, 'mcruz@us.es'),
        ('Inma Hernandez', 'FEMENINO', 35, 'inmahernandez@us.es'),
        ('Alfonso Marquez', 'MASCULINO', 35, 'amarquez@us.es'),
        ('Daniel Ayala', 'MASCULINO', 28, 'dayala1@us.es'),
        ('Raquel Sampedro', 'FEMENINO', 55, 'rsampedro@gmail.com'),
        ('Marta Lopez', 'FEMENINO', 18, 'mlopez@mail.com'),
        ('David Ruiz', 'MASCULINO', 25, 'druiz@mail.com'),
        ('Andrea Gomez', 'OTRO', 42, 'agomez@mail.es'),
        ('Ernesto Murillo', 'OTRO', 55, 'emurillo@correo.es');
END //
DELIMITER ;

CALL p_populate();
