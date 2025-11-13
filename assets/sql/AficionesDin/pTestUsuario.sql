-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimientos para PA de Usuarios
-- 

DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertarUsuario(
	p_nombre VARCHAR(64),
	p_genero ENUM('MASCULINO', 'FEMENINO', 'OTRO'),
	p_edad INTEGER,
	p_email VARCHAR(64))	
BEGIN
	INSERT INTO Usuarios(nombre, genero, edad, email)
	VALUES (p_nombre, p_genero, p_edad, p_email);
END;
//
DELIMITER ;

-- Test 001.1: Usuario con datos correctos
DELIMITER //
CREATE OR REPLACE PROCEDURE pTestUsuario_1()	
BEGIN
	CALL populateDB();
	CALL pInsertarUsuario('Paco Pérez', 'MASCULINO', 60, 'pperez@mail.com');
END; // DELIMITER ;

-- Test 001.2: Usuario sin género
DELIMITER //
CREATE OR REPLACE PROCEDURE pTestUsuario_2()	
BEGIN
	CALL populateDB();
	CALL pInsertarUsuario('Paco Pérez', null, 60, 'pperez@mail.com');
END;
//
DELIMITER ;

-- Test 001.3: Usuario con correo repetido
DELIMITER //
CREATE OR REPLACE PROCEDURE pTestUsuario_3()	
BEGIN
	CALL populateDB();
	CALL pInsertarUsuario('David Ruiz', 'MASCULINO', 22, 'druiz@us.es');
END;
//
DELIMITER ;
	
-- Test 001.4: Usuario menor de edad
DELIMITER //
CREATE OR REPLACE PROCEDURE pTestUsuario_4()	
BEGIN
	CALL populateDB();
	CALL pInsertarUsuario('David Ruiz', 'MASCULINO', 12, 'druiz@us.es');
END;
//
DELIMITER ;

CALL pTestUsuario_1();
CALL pTestUsuario_2();
CALL pTestUsuario_3();
CALL pTestUsuario_4();