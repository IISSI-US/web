-- 
-- Autores: Inma Hernández, David Ruiz, y Daniel Ayala
-- Fecha creación: Noviembre de 2019
-- Fecha modificación: Noviembre 2020 (Carlos Arévalo)
--                     Noviembre 2025 (David Ruiz)
-- Descripción: Script para hacer la carga inicial del ejercicio de Pedidos
-- 

USE PedidosDB;
-- Procedimiento para cargar datos iniciales (útil para tests)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate_db()
BEGIN
	DELETE FROM orders;
	DELETE FROM products;
	DELETE FROM users;

	-- Datos de Usuarios 
	INSERT INTO users(name, province, start_date) 
	VALUES 
		('David Ruiz', 'Sevilla', '2018-05-18'),
		('Marta López', 'Málaga', '2018-06-12'),
		('Raquel Lobato', 'Granada', '2018-12-01'),
		('Antonio Gómez', 'Sevilla', '2018-03-11'),
		('Inma Hernández', 'Málaga', '2018-04-12'),
		('Jimena Martín', 'Granada', '2018-05-13'),
		('Carlos Rivero', 'Huelva', '2018-09-07'),
		('Carlos Arévalo', 'Málaga', '2018-09-07');

	-- Datos de Productos 
	INSERT INTO products(description, price, stock) 
	VALUES
		('Mi Band 3', 19.90, 50),
		('Mi Band 4', 29.90, 20),
		('Pulsera compatible con Mi Band 3 y 4', 9.90, 150),
		('Mi Scooter', 349.90, 25),
		('Rueda trasera de respuesto Mi Scooter', 19.90, 50),
		('Rueda delantera de respuesto Mi Scooter', 59.90, 50);
		
	-- Datos de Pedidos 
	INSERT INTO orders(user_id, product_id, amount, purchase_date) 
	VALUES 
		(1, 1, 2, '2019-05-13'),
		(1, 3, 2, '2019-05-13'),
		(2, 2, 3, '2019-06-11'),
		(2, 3, 1, '2019-06-11'),
		(3, 4, 2, '2019-06-15'),
		(4, 5, 1, '2019-06-18'),
		(4, 6, 1, '2019-06-18'),	
		(5, 4, 2, '2019-12-15'),
		(7, 1, 1, '2019-12-15'),
		(7, 2, 1, '2019-12-16'),
		(7, 3, 1, '2019-12-17'),
		(7, 4, 1, '2019-12-18'),
		(7, 5, 1, '2019-12-19'),
		(7, 6, 1, '2019-12-20'),
		(8, 1, 1, '2019-12-15');
END //
DELIMITER ;

CALL p_populate_db();

