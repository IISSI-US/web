-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento que inserte una aficion a un usuario nuevo
-- 

DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertarAficionUsuarioNuevo(
	p_nombre VARCHAR(64),
	p_genero ENUM('MASCULINO', 'FEMENINO', 'OTRO'),
	p_edad INTEGER,
	p_email VARCHAR(64),
	p_aficion VARCHAR(128))	
BEGIN
	DECLARE v_usuarioId INT;
	DECLARE v_aficionId INT;
	-- Insertar el usuario
	CALL pInsertarUsuario(p_nombre, p_genero, p_edad, p_email);
	-- Obtener el id del usuario insertado
	SET v_usuarioId = LAST_INSERT_ID();
	-- Insertar la aficion
	INSERT INTO Aficiones(aficion)
	VALUES (p_aficion);
	-- Obtener el id de la aficion insertada
	SET v_aficionId = LAST_INSERT_ID();
	-- Insertar la relacion entre el usuario y la aficion
	INSERT INTO UsuariosAficiones(usuarioId, aficionId)
	VALUES (v_usuarioId, v_aficionId);
END;
//
DELIMITER ;

CALL populateDB();
CALL pInsertarAficionUsuarioNuevo('Paco Pérez', 'MASCULINO' , 60, 'pperez@mail.com', 'Libros de aventuras épicas');