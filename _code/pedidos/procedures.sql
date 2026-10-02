-- 
-- Autores: Daniel Ayala, Inma Hernández, David Ruiz
-- Fecha: Noviembre 2025
-- Descripción: Funciones y procedimientos auxiliares para Pedidos
-- 

USE OrdersDB;

-- Unidades vendidas de un producto
DELIMITER //
CREATE OR REPLACE FUNCTION f_get_sold_units(p_product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COALESCE(SUM(amount), 0)
        FROM orders
        WHERE product_id = p_product_id
    );
END //
DELIMITER ;

-- Importe total entre dos fechas
DELIMITER //
CREATE OR REPLACE FUNCTION f_purchase_between_dates(p_date1 DATE, p_date2 DATE)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COALESCE(SUM(amount * price), 0)
        FROM orders o
        JOIN products p ON p.product_id = o.product_id
        WHERE purchase_date BETWEEN p_date1 AND p_date2
    );
END //
DELIMITER ;

-- Producto más vendido en un año dado
DELIMITER //
CREATE OR REPLACE FUNCTION f_best_seller(p_year INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT product_id
        FROM orders o
        JOIN products p ON p.product_id = o.product_id
        WHERE YEAR(purchase_date) = p_year
        GROUP BY product_id
        ORDER BY SUM(amount) DESC
        LIMIT 1
    );
END //
DELIMITER ;

-- Dinero gastado por un usuario
DELIMITER //
CREATE OR REPLACE FUNCTION f_spent_money_user(p_user_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COALESCE(SUM(amount * price), 0)
        FROM orders o
        JOIN products p ON p.product_id = o.product_id
        WHERE o.user_id = p_user_id
    );
END //
DELIMITER ;

-- Stock de un producto
DELIMITER //
CREATE OR REPLACE FUNCTION f_get_stock(p_product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT stock
        FROM products
        WHERE product_id = p_product_id
    );
END //
DELIMITER ;

-- Crear pedido con fecha y cantidad (defaults manejados por la tabla)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_order(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_amount INT,
    IN p_purchase_date DATE
)
BEGIN
    INSERT INTO orders(user_id, product_id, amount, purchase_date)
    VALUES (p_user_id, p_product_id, IFNULL(p_amount, 1), IFNULL(p_purchase_date, CURRENT_DATE()));
END //
DELIMITER ;

-- Cambiar precios en un porcentaje
DELIMITER //
CREATE OR REPLACE PROCEDURE p_change_prices(IN p_fraction DECIMAL(6,4))
BEGIN
    UPDATE products
    SET price = price + price * p_fraction;
END //
DELIMITER ;

-- Crear vista de pedidos de un usuario en un año
DELIMITER //
CREATE OR REPLACE PROCEDURE p_create_orders_view(IN p_full_name VARCHAR(64), IN p_orders_year INT)
BEGIN
    DECLARE v_user_id INT;
    SELECT user_id INTO v_user_id FROM users WHERE full_name = p_full_name;
    IF v_user_id IS NOT NULL THEN
        SET @sql = CONCAT('CREATE OR REPLACE VIEW vOrders', REPLACE(p_full_name, ' ', ''), p_orders_year, ' AS\n',
                          'SELECT * FROM orders WHERE user_id = ', v_user_id, ' AND YEAR(purchase_date) = ', p_orders_year, ';');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

-- Crear vistas para usuarios con al menos N pedidos en un año
DELIMITER //
CREATE OR REPLACE PROCEDURE p_create_orders_views(IN p_min_orders INT, IN p_orders_year INT)
BEGIN
    DECLARE v_full_name VARCHAR(64);
    DECLARE v_done BOOLEAN DEFAULT FALSE;

    DECLARE cur CURSOR FOR
        SELECT full_name
        FROM users u
        JOIN orders o ON o.user_id = u.user_id
        WHERE YEAR(o.purchase_date) = p_orders_year
        GROUP BY full_name
        HAVING COUNT(*) >= p_min_orders;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_full_name;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        CALL p_create_orders_view(v_full_name, p_orders_year);
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;
