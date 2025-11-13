-- 
-- Autor: Carlos Arévalo
-- Fecha creación: Noviembre de 2020
-- Fecha modificación: Noviembre 2025 (David Ruiz)
-- Descripción: Consultas SQL de ejemplo para el ejercicio de Pedidos
-- 

USE PedidosDB;

-- 1. Usuarios de Sevilla
SELECT * 
FROM users 
WHERE province = 'Sevilla';

-- 2. Usuarios que no son de Sevilla
SELECT * 
FROM users 
WHERE province <> 'Sevilla';

-- 3. Malagueños y sevillanos
SELECT name 
FROM users 
WHERE province IN ('Sevilla', 'Málaga');

-- 4. Nombre de los usuarios, descripción del producto, cantidad solicitada y total en euros del pedido
SELECT name, description, amount, amount * price AS total_order 
FROM users 
NATURAL JOIN orders 
NATURAL JOIN products;

-- 5. Usuarios sin Pedidos
-- (a) Opción 1
SELECT name, user_id 
FROM users
EXCEPT  
SELECT name, user_id 
FROM users 
NATURAL JOIN orders;

-- (b) Opción 2
SELECT name, user_id 
FROM users U 
WHERE NOT EXISTS (
	SELECT * 
	FROM orders O 
	WHERE O.user_id = U.user_id
);

-- 6. Usuarios que han comprado todos los productos
-- (a) Como doble diferencia, según la equivalencia algebráica de teoría
SELECT name 
FROM users 
NATURAL JOIN (
	SELECT user_id 
	FROM orders
	EXCEPT
	SELECT X.user_id 
	FROM (
		SELECT O.user_id, P.product_id 
		FROM orders O, products P
		EXCEPT
		SELECT user_id, product_id 
		FROM orders 
		NATURAL JOIN products
	) X
) Y;

-- (b) Con NOT EXISTS
SELECT name 
FROM users U
WHERE NOT EXISTS (
	SELECT * 
	FROM products P
	WHERE NOT EXISTS (
		SELECT * 
		FROM orders O
		WHERE O.product_id = P.product_id
		AND O.user_id = U.user_id
	)
);

-- 7. Nombre de usuario con sus pedidos
SELECT name, SUM(amount * price) AS money_orders 
FROM orders 
NATURAL JOIN users 
NATURAL JOIN products
GROUP BY name
ORDER BY 2 DESC;

-- 8. Producto con su número de pedidos
SELECT description, COUNT(order_id) AS amount_orders 
FROM orders 
NATURAL JOIN users 
NATURAL JOIN products
GROUP BY description
ORDER BY 2 DESC;

-- 9. Creación de vistas y consultas sobre ellas
-- (a) Resumen de pedidos por provincia (totales, media, desviación típica, máximo, minimo)
CREATE OR REPLACE VIEW v_province_stat AS
SELECT province, 
	COUNT(*) AS num_orders,
	SUM(amount) AS sum_amount,
	MAX(amount) AS max_amount,
	MIN(amount) AS min_amount, 
	AVG(amount) AS avg_amount,
	STD(amount) AS std_amount,
	SUM(price * amount) AS sum_money_orders,
	MAX(price * amount) AS max_money_orders,
	MIN(price * amount) AS min_money_orders,
	AVG(price * amount) AS avg_money_orders,
	STD(price * amount) AS std_money_orders
FROM orders 
NATURAL JOIN products 
NATURAL JOIN users
GROUP BY province
ORDER BY province ASC;

-- (b) Resumen de pedidos por producto (totales, medias, máximo, minimo) 
CREATE OR REPLACE VIEW v_product_stat AS
SELECT description, 
	COUNT(*) AS num_orders,
	SUM(amount) AS sum_amount,
	MAX(amount) AS max_amount,
	MIN(amount) AS min_amount, 
	AVG(amount) AS avg_amount,
	STD(amount) AS std_amount,
	SUM(price * amount) AS sum_money_orders,
	MAX(price * amount) AS max_money_orders,
	MIN(price * amount) AS min_money_orders,
	AVG(price * amount) AS avg_money_orders,
	STD(price * amount) AS std_money_orders
FROM orders 
NATURAL JOIN products
GROUP BY description
ORDER BY description ASC;

-- (c) Resumen de pedidos por usuarios (totales, medias, máximo, minimo)
CREATE OR REPLACE VIEW v_user_stat AS
SELECT name, 
	COUNT(*) AS num_orders,
	SUM(amount) AS sum_amount,
	MAX(amount) AS max_amount,
	MIN(amount) AS min_amount, 
	AVG(amount) AS avg_amount,
	STD(amount) AS std_amount,
	SUM(price * amount) AS sum_money_orders,
	MAX(price * amount) AS max_money_orders,
	MIN(price * amount) AS min_money_orders,
	AVG(price * amount) AS avg_money_orders,
	STD(price * amount) AS std_money_orders
FROM orders 
NATURAL JOIN users 
NATURAL JOIN products
GROUP BY name
ORDER BY name ASC;

-- (d) Usuario que ha comprado más y menos
-- Opción 1 (MAX, MIN)
SELECT name, sum_money_orders 
FROM v_user_stat
WHERE sum_money_orders = (SELECT MAX(sum_money_orders) FROM v_user_stat);

SELECT name, sum_money_orders 
FROM v_user_stat
WHERE sum_money_orders = (SELECT MIN(sum_money_orders) FROM v_user_stat);

-- Opción 2 (ALL)
SELECT name, sum_money_orders 
FROM v_user_stat
WHERE sum_money_orders >= ALL (SELECT sum_money_orders FROM v_user_stat);

SELECT name, sum_money_orders 
FROM v_user_stat
WHERE sum_money_orders <= ALL (SELECT sum_money_orders FROM v_user_stat);

-- (e) Pedido de mayor y menor cuantía
-- Opción 1 (MAX, MIN)
SELECT order_id, user_id, amount * price AS sum_money_orders 
FROM orders 
NATURAL JOIN products
WHERE amount * price = (SELECT MAX(amount * price) FROM orders NATURAL JOIN products);

SELECT order_id, user_id, amount * price AS sum_money_orders 
FROM orders 
NATURAL JOIN products
WHERE amount * price = (SELECT MIN(amount * price) FROM orders NATURAL JOIN products);

-- Opción 2 (ALL)
SELECT order_id, user_id, amount * price AS sum_money_orders 
FROM orders 
NATURAL JOIN products
WHERE amount * price >= ALL (SELECT amount * price FROM orders NATURAL JOIN products);

SELECT order_id, user_id, amount * price AS sum_money_orders 
FROM orders 
NATURAL JOIN products
WHERE amount * price <= ALL (SELECT amount * price FROM orders NATURAL JOIN products);

-- (b) Resumen de pedidos por producto (totales, medias, máximo, minimo) 
CREATE OR REPLACE VIEW V_Product_Stat AS
SELECT description, 
	COUNT(*) AS numOrders,
	SUM(amount) AS sumAmount,
	MAX(amount) AS maxAmount,
	MIN(amount) AS minAmount, 
	AVG(amount) AS avgAmount,
	STD(amount) AS stdAmount,
	SUM(price * amount) AS sumMoneyOrders,
	MAX(price * amount) AS maxMoneyOrders,
	MIN(price * amount) AS minMoneyOrders,
	AVG(price * amount) AS avgMoneyOrders,
	STD(price * amount) AS stdMoneyOrders
FROM Orders 
NATURAL JOIN Products
GROUP BY description
ORDER BY description ASC;

-- (c) Resumen de pedidos por usuarios (totales, medias, máximo, minimo)
CREATE OR REPLACE VIEW V_User_Stat AS
SELECT name, 
	COUNT(*) AS numOrders,
	SUM(amount) AS sumAmount,
	MAX(amount) AS maxAmount,
	MIN(amount) AS minAmount, 
	AVG(amount) AS avgAmount,
	STD(amount) AS stdAmount,
	SUM(price * amount) AS sumMoneyOrders,
	MAX(price * amount) AS maxMoneyOrders,
	MIN(price * amount) AS minMoneyOrders,
	AVG(price * amount) AS avgMoneyOrders,
	STD(price * amount) AS stdMoneyOrders
FROM Orders 
NATURAL JOIN Users 
NATURAL JOIN Products
GROUP BY name
ORDER BY name ASC;

-- (d) Usuario que ha comprado más y menos
-- Opción 1 (MAX, MIN)
SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders = (SELECT MAX(sumMoneyOrders) FROM V_User_Stat);

SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders = (SELECT MIN(sumMoneyOrders) FROM V_User_Stat);

-- Opción 2 (ALL)
SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders >= ALL (SELECT sumMoneyOrders FROM V_User_Stat);

SELECT name, sumMoneyOrders 
FROM V_User_Stat
WHERE sumMoneyOrders <= ALL (SELECT sumMoneyOrders FROM V_User_Stat);

-- (e) Pedido de mayor y menor cuantía
-- Opción 1 (MAX, MIN)
SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price = (SELECT MAX(amount * price) FROM Orders NATURAL JOIN Products);

SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price = (SELECT MIN(amount * price) FROM Orders NATURAL JOIN Products);

-- Opción 2 (ALL)
SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price >= ALL (SELECT amount * price FROM Orders NATURAL JOIN Products);

SELECT orderId, userId, amount * price AS sumMoneyOrders 
FROM Orders 
NATURAL JOIN Products
WHERE amount * price <= ALL (SELECT amount * price FROM Orders NATURAL JOIN Products);

