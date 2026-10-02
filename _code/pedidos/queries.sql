-- 
-- Autores: Inma Hernández, David Ruiz, Daniel Ayala
-- Fecha: Noviembre 2025
-- Descripción: Consultas de referencia para Pedidos
-- 

USE OrdersDB;

-- Usuarios de Sevilla
SELECT * FROM users WHERE province = 'Sevilla';

-- Usuarios que no son de Sevilla
SELECT * FROM users WHERE province <> 'Sevilla';

-- Productos agotados o sin stock
SELECT * FROM products WHERE stock = 0;

-- Pedidos de un usuario concreto
SELECT * FROM orders WHERE user_id = 1;

-- Usuarios sin pedidos
SELECT *
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.user_id
);

-- Usuarios que han comprado todos los productos
SELECT u.user_id, u.full_name
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM products p
    WHERE NOT EXISTS (
        SELECT 1 FROM orders o
        WHERE o.user_id = u.user_id AND o.product_id = p.product_id
    )
);
