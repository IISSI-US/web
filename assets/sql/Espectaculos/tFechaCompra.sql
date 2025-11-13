-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Compruebar que la fecha de compra en anterior a la fecha de
-- su representación
-- 

-- Crear el procedimiento almacenado para verificar la fecha de compra
DELIMITER //
CREATE OR REPLACE PROCEDURE pFechaCompraRepresentacion(representacionId INT, fHoraCompra DATETIME)
BEGIN
   DECLARE fechaHoraInicio DATETIME;  
   -- Obtener la fecha de la representación
   SELECT r.fechaHoraInicio INTO fechaHoraInicio
   FROM Representaciones r
   WHERE r.representacionId = representacionId;    
   -- Comprobar que la fecha de compra es menor que la fecha de la representación
   IF fHoraCompra >= fechaHoraInicio THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La fecha de compra debe ser menor que la fecha de la representación';
   END IF;
END //
DELIMITER ;

-- Crear el trigger para comprobar la fecha de compra antes de insertar en la tabla Entradas
DELIMITER //
CREATE OR REPLACE TRIGGER tCheckFechaCompraBeforeInsert
BEFORE INSERT ON Entradas
FOR EACH ROW
BEGIN
   CALL pFechaCompraRepresentacion(NEW.representacionId, NEW.fHoraCompra);
END //
DELIMITER ;

-- Crear el trigger para comprobar la fecha de compra antes de actualizar en la tabla Entradas
DELIMITER //
CREATE OR REPLACE TRIGGER tCheckFechaCompraBeforeUpdate
BEFORE UPDATE ON Entradas
FOR EACH ROW
BEGIN
   CALL pFechaCompraRepresentacion(NEW.representacionId, NEW.fHoraCompra);
END //
DELIMITER ;