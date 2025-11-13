-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para crear la BD del ejercicio de Aficiones
-- 

-- Crear la base de datos
DROP DATABASE if EXISTS AficionesDinamicoDB;
CREATE DATABASE AficionesDinamicoDB;
USE AficionesDinamicoDB;


-- Procidimiento para crear la BD
DELIMITER //
CREATE OR REPLACE PROCEDURE createDB()
BEGIN
	-- Tabla de Usuarios, no cambia nada
	CREATE OR REPLACE TABLE Usuarios(
		usuarioId INT AUTO_INCREMENT NOT NULL,
		nombre VARCHAR(64) NOT NULL,
		genero ENUM('MASCULINO', 'FEMENINO', 'OTRO'),
		edad INTEGER NOT NULL,
		email VARCHAR(64) NOT NULL,
		PRIMARY KEY(usuarioId),
		CONSTRAINT RN_1_EdadAdulta CHECK (edad>=18), -- RN-1
		UNIQUE (email) -- RN-2
	);
	-- Tabla de Aficiones
	CREATE OR REPLACE TABLE Aficiones(
		aficionId INT AUTO_INCREMENT NOT NULL,
		aficion VARCHAR(128),
		PRIMARY KEY(aficionId)
	);
	-- Tabla que mapea la asociación N:M entre Usuarios y Aficiones
	CREATE OR REPLACE TABLE UsuariosAficiones(
		usuarioAficionId INT AUTO_INCREMENT NOT NULL,
		usuarioId INT NOT NULL,
		aficionId INT NOT NULL,
		PRIMARY KEY (usuarioAficionId),
		FOREIGN KEY (usuarioId) REFERENCES Usuarios(usuarioId),
		FOREIGN KEY (aficionId) REFERENCES Aficiones(aficionId),
		UNIQUE (usuarioId, aficionId)
	);
END;
//
DELIMITER ;

-- Llamada para ejecutar el procedimiento
CALL createDB();
