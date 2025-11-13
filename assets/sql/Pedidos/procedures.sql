-- 
-- Autores: Daniel Ayala, Inma Hernández y David Ruiz
-- Fecha creación: Noviembre de 2019
-- Fecha modificación: Noviembre 2020 (Carlos Arévalo)
--                     Noviembre 2025 (David Ruiz)
-- Descripción: Procedimientos, funciones y disparadores para el ejercicio de Pedidos
-- 

USE PedidosDB;

-- Función que dado el ID del producto devuelva el número de unidades vendidas
DELIMITER //
CREATE OR REPLACE FUNCTION f_get_sold_units(p_product_id INT) 
RETURNS INT
BEGIN
	RETURN (
		SELECT SUM(amount) 
		FROM orders 
		WHERE orders.product_id = p_product_id
	);
END //
DELIMITER ;

-- Función que devuelva el importe total de ventas entre dos fechas dadas
DELIMITER //
CREATE OR REPLACE FUNCTION f_purchase_between_dates(p_date1 DATE, p_date2 DATE) 
RETURNS DECIMAL
BEGIN
	RETURN (
		SELECT SUM(amount * price)
		FROM orders 
		NATURAL JOIN products
		WHERE (purchase_date >= p_date1 AND purchase_date <= p_date2)
	);
END //
DELIMITER ;

-- Función que, dado un año, devuelva el id del producto más vendido en ese año
DELIMITER //
CREATE OR REPLACE FUNCTION f_best_seller(p_year INT) 
RETURNS INT
BEGIN
	RETURN (
		SELECT product_id 
		FROM orders 
		NATURAL JOIN products
		WHERE YEAR(purchase_date) = p_year
		GROUP BY product_id
		ORDER BY SUM(amount) DESC
		LIMIT 1
	);					
END //
DELIMITER ;

-- Función que, dado un ID de usuario, devuelva el dinero que ha gastado en todos sus pedidos
DELIMITER //
CREATE OR REPLACE FUNCTION f_spent_money_user(p_user_id INT) 
RETURNS DOUBLE
BEGIN
	RETURN (
		SELECT SUM(amount * price)
		FROM orders 
		NATURAL JOIN products
		WHERE (orders.user_id = p_user_id)
	);
END //
DELIMITER ;

-- Función que, dado un ID de producto, devuelva su stock
DELIMITER //
CREATE OR REPLACE FUNCTION f_get_stock(p_product_id INT) 
RETURNS INT
BEGIN
	RETURN (
		SELECT stock
		FROM products
		WHERE (products.product_id = p_product_id)
	);
END //
DELIMITER ;

-- Procedimiento que, dado un usuario, un producto, y una cantidad, 
-- cree un pedido con la fecha actual y la cantidad dada
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_order(
	p_user_id INT, 
	p_product_id INT, 
	p_amount INT, 
	p_purchase_date DATE
)
BEGIN
	INSERT INTO orders(user_id, product_id, amount, purchase_date)
	VALUES (p_user_id, p_product_id, IFNULL(p_amount, 1), IFNULL(p_purchase_date, CURRENT_DATE()));
END //
DELIMITER ;

-- Procedimiento que, dado un porcentaje (ej. -0.2) modifique los precios 
-- según el porcentaje dado (con -0.2, un precio de 10€ pasaría a ser de 8€)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_change_prices(p_fraction DOUBLE)
BEGIN
	UPDATE products 
	SET price = price + price * p_fraction;
END //
DELIMITER ;

-- Procedimiento que, dado un nombre de usuario y un año, crea una vista 
-- vOrders<Nombre><Año> que contiene los pedidos realizados por el usuario en ese año
-- Recuerde que un nombre puede contener espacios
DELIMITER //
CREATE OR REPLACE PROCEDURE p_create_orders_view(p_name VARCHAR(64), p_orders_year INT)
BEGIN
	DECLARE v_user_id INT;
	SET v_user_id = (SELECT users.user_id FROM users WHERE users.name = p_name);
	EXECUTE IMMEDIATE CONCAT(
		'CREATE OR REPLACE VIEW vOrders', REPLACE(p_name, ' ', ''), p_orders_year, ' AS
		SELECT * FROM orders WHERE user_id = ', v_user_id, ' AND YEAR(purchase_date) = ', p_orders_year, ';'
	);
END //
DELIMITER ;

-- Procedimiento que, dado un entero N y un año, crea la vista anterior 
-- para ese año y todos los usuarios que han realizado más de N pedidos
DELIMITER //
CREATE OR REPLACE PROCEDURE p_create_orders_views(p_min_orders INT, p_orders_year INT)
BEGIN 
	DECLARE v_user_name VARCHAR(64);
	DECLARE v_done BOOLEAN DEFAULT FALSE; 
	DECLARE users_with_orders CURSOR FOR
		SELECT name 
		FROM users 
		NATURAL JOIN orders 
		WHERE YEAR(purchase_date) = p_orders_year
		GROUP BY name
		HAVING COUNT(*) >= p_min_orders; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done := TRUE; 
	
	OPEN users_with_orders;
	read_loop: LOOP 
		FETCH users_with_orders INTO v_user_name; 
		IF v_done THEN 
			LEAVE read_loop; 
		END IF; 
		CALL p_create_orders_view(v_user_name, p_orders_year);
	END LOOP; 
	CLOSE users_with_orders;
END //
DELIMITER ;
 
