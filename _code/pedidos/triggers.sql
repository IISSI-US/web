--
-- Descripción: Reglas de pedidos que dependen de varias filas o tablas
--
USE OrdersDB;

DELIMITER //
CREATE OR REPLACE TRIGGER t_bi_orders_rn01_daily_limit
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE v_daily_orders INT DEFAULT 0;

    IF NEW.purchase_date IS NOT NULL THEN
        SELECT COUNT(*) INTO v_daily_orders
        FROM orders
        WHERE user_id = NEW.user_id
          AND purchase_date = NEW.purchase_date;

        IF v_daily_orders >= 3 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN01: Un usuario no puede realizar más de tres pedidos al día';
        END IF;
    END IF;
END //

CREATE OR REPLACE TRIGGER t_bi_orders_rn03_available_stock
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.product_id IS NOT NULL
       AND NEW.amount IS NOT NULL
       AND NEW.purchase_date IS NOT NULL THEN
        UPDATE products
        SET stock = stock - NEW.amount
        WHERE product_id = NEW.product_id
          AND stock >= NEW.amount;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN03: Stock insuficiente para realizar el pedido';
        END IF;
    END IF;
END //
DELIMITER ;
