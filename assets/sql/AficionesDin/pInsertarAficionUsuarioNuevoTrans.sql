-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento transaccional
-- 

DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertarAficionesUsuarioNuevoTrans(
   p_nombre VARCHAR(64),
	p_genero ENUM('MASCULINO', 'FEMENINO', 'OTRO'),
	p_edad INTEGER,
	p_email VARCHAR(64),
	p_aficion VARCHAR(128))	
BEGIN
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
      -- En caso de error, deshacer la transacción
      ROLLBACK;
      -- Esta línea no es necesaria
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al ejecutar la transacción';
   END;
   -- Iniciar la transacción
   START TRANSACTION;
	   -- Insertar en las tres tablas
	   CALL pInsertarAficionUsuarioNuevo(p_nombre, p_genero, p_edad, p_email, p_aficion);
	   -- Confirmar la transacción
   COMMIT;
END;
//
DELIMITER ;

CALL populateDB();
CALL pInsertarAficionesUsuarioNuevoTrans('Paco Pérez', 'MASCULINO', 60, 'pperez@mail.com', 'Libros de aventuras épicas');
-- Esta inserción debe fallar: usuario repetido
CALL pInsertarAficionesUsuarioNuevoTrans('Paco Pérez', 'MASCULINO', 60, 'pperez@mail.com', 'Libros de aventuras épicas');
-- Esta inserción debe fallar: email repetido
CALL pInsertarAficionesUsuarioNuevoTrans('David Ruiz', 'MASCULINO', 12, 'druiz@us.es', 'Jugar al fútbol');