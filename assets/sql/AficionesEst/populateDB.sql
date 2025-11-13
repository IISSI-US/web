-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para hacer la carga inicial de Aficiones estático
-- 

-- Procedimiento para hacer la carga inicial de la tabla de Usuarios
DELIMITER //
CREATE OR REPLACE PROCEDURE populateDB()
BEGIN
	-- Primero dejamos la tabla de Usuarios vacía
	DELETE FROM Usuarios;
	-- Inserción de datos iniciales de Usuarios
	ALTER TABLE Usuarios AUTO_INCREMENT=1;
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
	-- Inserción de datos iniciales de Aficiones
	ALTER TABLE Aficiones AUTO_INCREMENT=1;
	INSERT INTO Aficiones(usuarioId, aficion)
	VALUES
		(1,'DEPORTE'), (1,'GASTRONOMIA'),
		(2,'DEPORTE'), (2,'LITERATURA'), (2,'CINE'),
		(4,'GASTRONOMIA'), (4,'CINE'), (4,'LITERATURA'),
		(5,'DEPORTE'),
		(6,'CINE'),
		(8,'DEPORTE'), (8,'GASTRONOMIA'), (8,'LITERATURA'),	(8,'CINE'),
		(9,'DEPORTE'), (9,'LITERATURA'), (9,'CINE'),
		(10,'GASTRONOMIA');
END;
//
DELIMITER ;

-- Llamada al procedimiento
CALL populateDB();
