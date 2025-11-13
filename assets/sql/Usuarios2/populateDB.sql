--
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para hacer la carga inicial de Usuarios2
--

-- Procedimiento para hacer la carga inicial de la tabla de Usuarios
DELIMITER //
CREATE OR REPLACE PROCEDURE populateDB()
BEGIN
	-- Primero dejamos la tabla de Usuarios vacía
	DELETE FROM Usuarios;
	-- Inserción de datos iniciales
INSERT INTO Usuarios(nombre, genero, fechaNacimiento, email)
VALUES
	('David Ruiz',      'MASCULINO', '1977-05-12', 'druiz@us.es'),      
  	('Carlos Arévalo',  'MASCULINO', '1965-08-23', 'carevalo@us.es'),   
  	('Margarita Cruz',  'FEMENINO',  '1968-02-10', 'mcruz@us.es'),      
  	('Inma Hernández',  'FEMENINO',  '1985-11-30', 'inmahernandez@us.es'), 
  	('Alfonso Márquez', 'MASCULINO', '1988-03-15', 'amarquez@us.es'),   
  	('Daniel Ayala',    'MASCULINO', '1994-09-07', 'dayala1@us.es'),    
  	('Raquel Sampedro', 'FEMENINO',  '1963-01-19', 'rsampedro@gmail.com'),
  	('Marta López',     'FEMENINO',  '2002-06-25', 'mlopez@mail.com'),  
  	('Andrea Gómez',    'OTRO',      '1991-12-03', 'agomez@mail.es'),   
  	('Ernesto Murillo', 'OTRO',      '1949-07-21', 'emurillo@correo.es')
; 

END;
//
DELIMITER ;

-- Llamada al procedimiento
CALL populateDB();
