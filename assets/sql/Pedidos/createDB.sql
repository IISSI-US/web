-- 
-- Autores: Inma Hernández, David Ruiz, y Daniel Ayala
-- Fecha creación: Noviembre de 2019
-- Fecha modificación: Noviembre 2020 (Carlos Arévalo)
--                     Noviembre 2025 (David Ruiz)
-- Descripción: Script para crear la BD del ejercicio de Pedidos
-- 

DROP DATABASE IF EXISTS PedidosDB;
CREATE DATABASE PedidosDB;
USE PedidosDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_create_db()
BEGIN
	-- Borrar tablas en orden correcto (FK primero)
	DROP TABLE IF EXISTS orders;
	DROP TABLE IF EXISTS products;
	DROP TABLE IF EXISTS users;

	-- Relación: Usuarios
	CREATE TABLE users(
		user_id INT NOT NULL AUTO_INCREMENT,
		name VARCHAR(63) NOT NULL,
		province VARCHAR(63), 
		start_date DATE NOT NULL,
		PRIMARY KEY(user_id),
		CONSTRAINT RN_1a_name_not_null CHECK (name IS NOT NULL), -- RN-1a
		CONSTRAINT RN_1b_name_unique UNIQUE(name) -- RN-1b
	);

	-- Relación: Productos
	CREATE TABLE products(
		product_id INT NOT NULL AUTO_INCREMENT,
		description VARCHAR(128),
		price DECIMAL(6,2) NOT NULL,
		stock INT,
		PRIMARY KEY(product_id),
		CONSTRAINT RN_2a_price_not_null CHECK (price IS NOT NULL), -- RN-2a
		CONSTRAINT RN_2b_price_range CHECK (price >= 0), -- RN-2b
		CONSTRAINT RN_2c_positive_stock CHECK (stock >= 0) -- RN-2c
	);

	-- Relación: Pedidos
	CREATE TABLE orders(
		order_id INT NOT NULL AUTO_INCREMENT,
		user_id INT NOT NULL,
		product_id INT NOT NULL,
		amount INT DEFAULT 1,
		purchase_date DATE DEFAULT (CURRENT_DATE),
		PRIMARY KEY(order_id),
		FOREIGN KEY(user_id) REFERENCES users(user_id),
		FOREIGN KEY(product_id) REFERENCES products(product_id), 
		CONSTRAINT RN_3a_amount_default CHECK (amount IS NOT NULL), -- RN-3a
		CONSTRAINT RN_3b_amount_range CHECK (amount BETWEEN 1 AND 10), -- RN-3b
		CONSTRAINT RN_3c_month_not_august CHECK (MONTH(purchase_date) <> 8) -- RN-3c
	);
END //
DELIMITER ;

CALL p_create_db();

