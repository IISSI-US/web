-- 
-- Autores: Inma Hernández, David Ruiz, Daniel Ayala
-- Fecha: Noviembre 2025
-- Descripción: Script para crear la BD del ejercicio de Pedidos
-- 

DROP DATABASE IF EXISTS OrdersDB;
CREATE DATABASE OrdersDB;
USE OrdersDB;

-- =============================================================
-- Eliminamos tablas previas (orden inverso de dependencias)
-- =============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- Tabla: users
-- =============================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    full_name VARCHAR(63) NOT NULL,
    province VARCHAR(63),
    start_date DATE NOT NULL,
    PRIMARY KEY (user_id),
    CONSTRAINT rn01_users_name_not_null CHECK (full_name IS NOT NULL),
    CONSTRAINT rn02_users_name_unique UNIQUE (full_name)
);

-- =============================================================
-- Tabla: products
-- =============================================================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT,
    description VARCHAR(128),
    price DECIMAL(8,2) NOT NULL,
    stock INT,
    PRIMARY KEY (product_id),
    CONSTRAINT rn03_products_price_not_null CHECK (price IS NOT NULL),
    CONSTRAINT rn04_products_price_nonnegative CHECK (price >= 0),
    CONSTRAINT rn05_products_stock_nonnegative CHECK (stock >= 0)
);

-- =============================================================
-- Tabla: orders
-- =============================================================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    amount INT DEFAULT 1,
    purchase_date DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT rn06_orders_amount_not_null CHECK (amount IS NOT NULL),
    CONSTRAINT rn07_orders_amount_range CHECK (amount BETWEEN 1 AND 10),
    CONSTRAINT rn08_orders_month_not_august CHECK (MONTH(purchase_date) <> 8)
);
