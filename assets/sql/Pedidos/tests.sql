-- 
-- Autor: Carlos Arévalo
-- Fecha creación: Noviembre de 2020
-- Fecha modificación: Noviembre 2025 (David Ruiz)
-- Descripción: Pruebas de procedimientos, funciones y disparadores para el ejercicio de Pedidos
-- 

-- Inicialización de la BD con estado consistente
USE PedidosDB;

-- TABLA DE RESULTADOS DE TESTS
CREATE OR REPLACE TABLE test_results (
	test_id VARCHAR(10) NOT NULL PRIMARY KEY,
	test_name VARCHAR(200) NOT NULL,
	test_message VARCHAR(500) NOT NULL,
	test_status ENUM('PASS', 'FAIL', 'ERROR') NOT NULL,
	execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PROCEDIMIENTO AUXILIAR PARA LOGGING
DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
	IN p_test_id VARCHAR(10),
	IN p_message VARCHAR(500),
	IN p_status ENUM('PASS', 'FAIL', 'ERROR')
)
BEGIN
	INSERT INTO test_results(test_id, test_name, test_message, test_status)
	VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;

-- 1. Integridad declarativa
-- name obligatorio
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_1_1()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('1.1', 'users: name NOT NULL', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO users(name, province, start_date) 
	VALUES (NULL, 'X Nuevo:name obligatorio', NOW()); -- NOK

	CALL p_log_test('1.1', 'ERROR: name NULL permitido', 'FAIL');
END //
-- startDate obligatorio
CREATE OR REPLACE PROCEDURE p_test_1_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('1.2', 'users: start_date NOT NULL', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO users(name, province, start_date) 
	VALUES ('Nuevo', 'X Nuevo: startDate Obligatorio', NULL); -- NOK 
	CALL p_log_test('1.2', 'ERROR: start_date NULL permitido', 'FAIL');
END//
-- usuario correcto
CREATE OR REPLACE PROCEDURE p_test_1_3()
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		CALL p_log_test('1.3', 'ERROR: Fallo al insertar usuario válido', 'FAIL');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO users(name, province, start_date) 
	VALUES ('Nuevo', '* Nuevo: Admitido', NOW()); -- OK
	CALL p_log_test('1.3', 'users: Inserción válida admitida', 'PASS');
END//
-- name único
CREATE OR REPLACE PROCEDURE p_test_1_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('1.4', 'users: name UNIQUE', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO users(name, province, start_date) 
	VALUES ('TestDup', '* Nuevo: Repetido', NOW());
	
	INSERT INTO users(name, province, start_date) 
	VALUES ('TestDup', '* Nuevo: Repetido2', NOW());

	CALL p_log_test('1.4', 'ERROR: name duplicado permitido', 'FAIL');
END //
-- 2b. Productos --> Valores obligatorios (RN-2a);
-- Precio no puede ser nulo
CREATE OR REPLACE PROCEDURE p_test_2_1()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('2.1', 'price NOT NULL', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO products(description, price, stock) 
	VALUES ('Mi Band 3', NULL, 50); -- NOK
	CALL p_log_test('2.1', 'ERROR: precio NULL permitido', 'FAIL');
END//
-- Precio >= 0
CREATE OR REPLACE PROCEDURE p_test_2_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('2.2', 'products: price >= 0', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO products(description, price, stock) 
	VALUES ('Mi Band 3', -1, 50); -- NOK
	CALL p_log_test('2.2', 'ERROR: price negativo permitido', 'FAIL');
END//
--- Stock >= 0
CREATE OR REPLACE PROCEDURE p_test_2_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('2.3', 'products: stock >= 0', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO products(description, price, stock) 
	VALUES ('Mi Band 3', 5, -1); -- NOK
	CALL p_log_test('2.3', 'ERROR: stock negativo permitido', 'FAIL');
END//
-- 2c. Pedidos --> Valores por defecto (RN-3a): Cant=1; purchaseDate=now()
-- valor por amount=1
CREATE OR REPLACE PROCEDURE p_test_3_1()
BEGIN
	DECLARE v_amount INT;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		CALL p_log_test('3.1', 'ERROR: Fallo al probar valor por defecto', 'FAIL');

	CALL p_create_db();
	CALL p_populate_db();
	
	-- Omitir amount para que use el DEFAULT
	INSERT INTO orders(user_id, product_id, purchase_date)
	VALUES (8, 2, CURDATE());
	
	SELECT amount INTO v_amount 
	FROM orders 
	WHERE order_id = LAST_INSERT_ID();

	IF v_amount = 1 THEN
		CALL p_log_test('3.1', 'orders: amount DEFAULT 1', 'PASS');
	ELSE
		CALL p_log_test('3.1', 'ERROR: amount por defecto no es 1', 'FAIL');
	END IF;
END//
-- 3. Integridad referencial (FKs): Usuario inexistente, Producto inexistentes
-- Usuario inexistente
CREATE OR REPLACE PROCEDURE p_test_4_1()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('4.1', 'FK: user_id debe existir en users', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO orders(user_id, product_id, amount)
	VALUES (99, 2, 1);
	CALL p_log_test('4.1', 'ERROR: FK user_id no validada', 'FAIL');
END //
-- Producto inexistente
CREATE OR REPLACE PROCEDURE p_test_4_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('4.2', 'FK: product_id debe existir en products', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO orders(user_id, product_id, amount)
	VALUES (8, 99, 1);
	CALL p_log_test('4.2', 'ERROR: FK product_id no validada', 'FAIL');
END//
-- 3b. Al borrar Usuario
CREATE OR REPLACE PROCEDURE p_test_4_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('4.3', 'FK: DELETE users con orders protegido', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	DELETE FROM users WHERE user_id = 8; -- NOK
	
	CALL p_log_test('4.3', 'ERROR: DELETE users con orders permitido', 'FAIL');
END //
-- 3d. Al borrar Producto
CREATE OR REPLACE PROCEDURE p_test_4_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('4.4', 'FK: DELETE products con orders protegido', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	DELETE FROM products WHERE product_id = 2; -- NOK
	
	CALL p_log_test('4.4', 'ERROR: DELETE products con orders permitido', 'FAIL');
END //
-- 4. Checks: Cant>=1 AND Cant<=10 (RN-3b)
-- amount=0
CREATE OR REPLACE PROCEDURE p_test_3_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('3.2', 'orders: amount >= 1', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO orders(user_id, product_id, amount)
	VALUES (8, 3, 0);
	CALL p_log_test('3.2', 'ERROR: amount = 0 permitido', 'FAIL');
END//
-- amount>10
CREATE OR REPLACE PROCEDURE p_test_3_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('3.3', 'orders: amount <= 10', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO orders(user_id, product_id, amount)
	VALUES (8, 3, 11);
	CALL p_log_test('3.3', 'ERROR: amount > 10 permitido', 'FAIL');
END//
-- 5. Checks: (Mes(Pedido)<>Agosto) (RN-3c)
CREATE OR REPLACE PROCEDURE p_test_3_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('3.4', 'orders: MONTH(purchase_date) <> 8', 'PASS');

	CALL p_create_db();
	CALL p_populate_db();
	
	INSERT INTO orders(user_id, product_id, amount, purchase_date)
	VALUES (8, 3, 1, '2020-08-01');
	CALL p_log_test('3.4', 'ERROR: pedido en agosto permitido', 'FAIL');
END//
-- Ejecutar todos los tests
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
	DELETE FROM test_results;
	
	-- Tests de Usuarios (RN-1a, RN-1b)
	CALL p_test_1_1();
	CALL p_test_1_2();
	CALL p_test_1_3();
	CALL p_test_1_4();
	
	-- Tests de Productos (RN-2a, RN-2b, RN-2c)
	CALL p_test_2_1();
	CALL p_test_2_2();
	CALL p_test_2_3();
	
	-- Tests de Pedidos (RN-3a, RN-3b, RN-3c)
	CALL p_test_3_1();
	CALL p_test_3_2();
	CALL p_test_3_3();
	CALL p_test_3_4();
	
	-- Tests de Integridad Referencial
	CALL p_test_4_1();
	CALL p_test_4_2();
	CALL p_test_4_3();
	CALL p_test_4_4();
	
	-- Mostrar resultados detallados
	SELECT test_id AS 'ID', 
	       test_name AS 'Test', 
	       test_status AS 'Estado',
	       test_message AS 'Mensaje'
	FROM test_results
	ORDER BY test_id;
	
END//
DELIMITER ;