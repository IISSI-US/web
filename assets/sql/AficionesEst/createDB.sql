-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para crear la BD del ejercicio de Aficiones estático
-- 

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS AficionesEstaticoDB;
USE AficionesEstaticoDB;

-- Procidimiento para crear la tabla de Usuarios
DELIMITER //
CREATE OR REPLACE PROCEDURE createDB()
BEGIN
	DROP TABLE IF EXISTS Aficiones;
	DROP TABLE IF EXISTS Usuarios;
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
		usuarioId INT NOT NULL,
		aficion ENUM('LITERATURA', 'CINE', 'DEPORTE', 'GASTRONOMIA'),
		PRIMARY KEY(aficionId),
		FOREIGN KEY(usuarioId) 
			REFERENCES Usuarios(usuarioId)
			ON DELETE CASCADE,
		-- No existe un requisito explícito, pero asumimos que un mismo 
		-- usuario no puede tener aficiones repetidas
		UNIQUE (usuarioId,aficion)
	);	
END;
//
DELIMITER ;

-- Llamada para ejecutar el procedimiento
CALL createDB();

