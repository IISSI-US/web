-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para hacer la carga inicial del ejercicio de Usuarios
-- 


-- Primero dejamos la tabla de Usuarios vacía
DELETE FROM Usuarios;

-- Inserción de datos iniciales
INSERT INTO Usuarios(nombre, genero, edad, email)
VALUES
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
	('Ernesto Murillo', 'otro', 55, 'emurillo@correo.es');
