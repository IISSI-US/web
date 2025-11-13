-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para hacer la carga inicial de Aficiones dinámico
-- 

-- Procedimiento para hacer la carga inicial de la BD.
DELIMITER //
CREATE OR REPLACE PROCEDURE populateDB()
BEGIN
	-- Primero dejamos la DB vacía
	DELETE FROM UsuariosAficiones;
	DELETE FROM Usuarios;
	DELETE FROM Aficiones;
	
	-- Inserción de datos iniciales de Usuarios
	-- Reseteamos la PK a 1
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
	INSERT INTO Aficiones(aficion)
	VALUES
		('Leer'),
		('Ir al cine'),
		('Hacer deporte'),
		('Hacer de comer'),
		('Montar a caballo'); -- nueva aficion de ejemplo
	-- Inserción de asociaciones entre usuarios y aficiones
	ALTER TABLE UsuariosAficiones AUTO_INCREMENT=1;
	INSERT INTO UsuariosAficiones(usuarioId,aficionId)
	VALUES
		(1,3), (1,4),
		(2,3), (2,1), (2,2),
		(4,4), (4,2), (4,1),
		(5,3),
		(6,2),
		(8,3), (8,4), (8,1),	(8,2),
		(9,3), (9,1), (9,2),
		(10,4),
		(11,5);
END;
//
DELIMITER ;

-- Llamada al procedimiento
CALL populateDB();
