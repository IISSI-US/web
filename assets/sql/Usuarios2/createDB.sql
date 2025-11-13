--
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Script para crear la BD del ejercicio de Usuarios2
--

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS UsuariosDB2; 
USE UsuariosDB2;
-- Procidimiento para crear la tabla de Usuarios
DELIMITER //
CREATE OR REPLACE PROCEDURE createDB()
BEGIN
	DROP TABLE IF EXISTS Usuarios;
	CREATE OR REPLACE TABLE Usuarios(
		usuarioId INT AUTO_INCREMENT NOT NULL,
		nombre VARCHAR(64) NOT NULL,
		genero ENUM('MASCULINO', 'FEMENINO', 'OTRO'),
		fechaNacimiento DATE NOT NULL,
		email VARCHAR(64) NOT NULL,
		PRIMARY KEY(usuarioId),
		UNIQUE (email) -- RN-2
		-- Para comprobar que el Usuario es mayor de edad hace falta un Trigger
	);
END //
DELIMITER ; 
	
-- Llamada para ejecutar el procedimiento
CALL createDB();
