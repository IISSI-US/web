--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para poblar la BD del ejercicio de Bodegas
--

delimiter //
CREATE OR REPLACE PROCEDURE p_populate_db()
BEGIN
	-- Vaciar tablas
	DELETE FROM vinos_uvas;
	DELETE FROM cosechas;
	DELETE FROM jovenes;
	DELETE FROM crianzas;
	DELETE FROM vinos;
	DELETE FROM uvas;
	DELETE FROM bodegas;
	-- Insertar datos en Bodegas
	INSERT INTO bodegas (bodega_id, nombre, denominacion_origen) VALUES 
	(1, 'Bodegas El Sol', 'Rioja'),
	(2, 'Bodegas La Luna', 'Ribera del Duero');
	
	-- Insertar datos en Vinos
	INSERT INTO vinos (vino_id, bodega_id, nombre, grados) VALUES 
	(1, 1, 'Vino Blanco Joven', 12),
	(2, 2, 'Vino Tinto Joven', 13),
	(3, 1, 'Vino Crianza Especial', 14),
	(4, 2, 'Vino Crianza Reserva', 13.5);
	
	-- Insertar datos en Jóvenes
	INSERT INTO jovenes (vino_id, tiempo_barrica, tiempo_botella) VALUES 
	(1, 0, 6),
	(2, 0, 12);
	
	-- Insertar datos en Crianzas
	INSERT INTO crianzas (vino_id, tiempo_barrica, tiempo_botella) VALUES 
	(3, 6, 18),
	(4, 12, 12);
	
	-- Insertar datos en Uvas
	INSERT INTO uvas (uva_id, nombre) VALUES 
	(1, 'Tempranillo'),
	(2, 'Garnacha'),
	(3, 'Albarino');
	
	-- Insertar datos en Cosechas
	INSERT INTO cosechas (cosecha_id, vino_id, año, calidad) VALUES 
	(1, 3, 2020, 'Excelente'),
	(2, 3, 2019, 'Buena'),
	(3, 4, 2018, 'Muy buena');
	
	-- Insertar datos en VinosUvas
	INSERT INTO vinos_uvas (vino_uva_id, vino_id, uva_id) VALUES 
	(1, 1, 3),
	(2, 2, 1),
	(3, 3, 2),
	(4, 3, 1),
	(5, 4, 2),
	(6, 4, 1);
/*	
	-- Insertar datos adicionales en Vinos
	INSERT INTO Vinos (vinoId, bodegaId, nombre, grados) VALUES 
	(5, 1, 'Vino Blanco Reserva', 12.5),
	(6, 2, 'Vino Tinto Gran Reserva', 14),
	(7, 1, 'Vino Rosado Joven', 11.5),
	(8, 2, 'Vino Blanco Crianza', 13),
	(9, 1, 'Vino Tinto Crianza', 13.5),
	(10, 2, 'Vino Blanco Gran Reserva', 12.5),
	(11, 1, 'Vino Rosado Crianza', 12),
	(12, 2, 'Vino Tinto Reserva', 14),
	(13, 1, 'Vino Blanco Joven Especial', 11.5),
	(14, 2, 'Vino Tinto Joven Especial', 13);
	
	-- Insertar datos adicionales en Jóvenes
	INSERT INTO Jovenes (vinoId, tiempoBarrica, tiempoBotella) VALUES 
	(5, 0, 6),
	(7, 0, 12),
	(13, 3, 9),
	(14, 3, 6);
	
	-- Insertar datos adicionales en Crianzas
	INSERT INTO Crianzas (vinoId, tiempoBarrica, tiempoBotella) VALUES 
	(6, 6, 18),
	(8, 6, 18),
	(9, 6, 18),
	(10, 12, 12),
	(11, 12, 12),
	(12, 12, 12);
	
	-- Insertar datos adicionales en Cosechas para vinos de crianza
	INSERT INTO Cosechas (cosechaId, vinoId, año, calidad) VALUES 
	(4, 6, 2021, 'Excelente'),
	(5, 6, 2020, 'Muy buena'),
	(6, 6, 2019, 'Buena'),
	(7, 8, 2021, 'Excelente'),
	(8, 8, 2020, 'Muy buena'),
	(9, 8, 2019, 'Buena'),
	(10, 9, 2021, 'Excelente'),
	(11, 9, 2020, 'Muy buena'),
	(12, 9, 2019, 'Buena'),
	(13, 9, 2018, 'Regular'),
	(14, 10, 2021, 'Excelente'),
	(15, 10, 2020, 'Muy buena'),
	(16, 10, 2019, 'Buena'),
	(17, 10, 2018, 'Regular'),
	(18, 11, 2021, 'Excelente'),
	(19, 11, 2020, 'Muy buena'),
	(20, 11, 2019, 'Buena'),
	(21, 12, 2021, 'Excelente'),
	(22, 12, 2020, 'Muy buena'),
	(23, 12, 2019, 'Buena');
	
	-- Insertar datos adicionales en Uvas
	INSERT INTO Uvas (uvaId, nombre) VALUES 
	(4, 'Cabernet Sauvignon'),
	(5, 'Merlot'),
	(6, 'Syrah');
	
	-- Insertar datos adicionales en UvasVinos para vinos de crianza
	INSERT INTO VinosUvas (vinoId, uvaId) VALUES 
	(6, 1),
	(6, 2),
	(8, 3),
	(8, 4),
	(9, 5),
	(9, 1),
	(9, 2),
	(10, 3),
	(10, 4),
	(11, 5),
	(11, 1),
	(12, 2),
	(12, 3);
	
	-- Insertar datos adicionales en UvasVinos para vinos jóvenes
	INSERT INTO VinosUvas (vinoId, uvaId) VALUES 
	(5, 1),
	(5, 2),
	(7, 3),
	(7, 4),
	(13, 5),
	(13, 1),
	(14, 2);
*/
END;
//
delimiter ;

CALL p_populate_db();