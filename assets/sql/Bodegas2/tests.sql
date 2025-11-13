--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Pruebas de aceptación en SQL para Bodegas y Vinos
-- 

-- Inicialización de la BD con estado consistente
USE Bodegas2DB;

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

-- ====================
-- TESTS DE BODEGAS
-- ====================

-- 1. Crear una nueva bodega con todos los datos correctos según las reglas de negocio
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_bodega_1()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('B.1', 'bodegas: Crear bodega válida', 'FAIL');

	CALL p_populate_db();
	INSERT INTO bodegas(nombre, denominacion_origen) VALUES ('Bodega la Nueva', 'Rias Baixas');
	CALL p_log_test('B.1', 'bodegas: Crear bodega válida', 'PASS');
END //
DELIMITER ;

-- 2. Crear una nueva bodega sin nombre.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_bodega_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('B.2', 'bodegas: nombre NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO bodegas(nombre, denominacion_origen) VALUES (NULL, 'Rias Baixas');
	CALL p_log_test('B.2', 'ERROR: nombre NULL permitido', 'FAIL');
END //
DELIMITER ;

-- 3. Crear una nueva bodega con el nombre repetido.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_bodega_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('B.3', 'bodegas: nombre UNIQUE', 'PASS');

	CALL p_populate_db();
	INSERT INTO bodegas(nombre, denominacion_origen) VALUES ('Bodega la Nueva', 'Rias Baixas');
	INSERT INTO bodegas(nombre, denominacion_origen) VALUES ('Bodega la Nueva', 'Rias Baixas');
	CALL p_log_test('B.3', 'ERROR: nombre duplicado permitido', 'FAIL');
END //
DELIMITER ;
	
-- 4. Crear una nueva bodega sin denominación de origen.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_bodega_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('B.4', 'bodegas: denominacion_origen NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO bodegas(nombre, denominacion_origen) VALUES ('Bodega la Nueva', NULL);
	CALL p_log_test('B.4', 'ERROR: denominacion_origen NULL permitido', 'FAIL');
END //
DELIMITER ;

-- ====================
-- TESTS DE VINOS
-- ====================

-- 1. Crear un nuevo vino Joven con todos los datos correctos según las reglas de negocio
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_1()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.1', 'jovenes: Crear joven válido', 'FAIL');

	CALL p_populate_db();
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j10', 1, 'Vino nuevo Joven', 11, 0, 12);
	CALL p_log_test('V.1', 'jovenes: Crear joven válido', 'PASS');
END//
DELIMITER ;

-- 2. Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_2()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.2', 'crianzas: Crear crianza válida', 'FAIL');

	CALL p_populate_db();
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_log_test('V.2', 'crianzas: Crear crianza válida', 'PASS');
END//
DELIMITER ;

-- 3. Crear un nuevo vino Joven sin nombre.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_3()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.3', 'jovenes: nombre NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j10', 1, NULL, 11, 0, 12);
	CALL p_log_test('V.3', 'ERROR: nombre NULL permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 4. Crear un nuevo vino Crianza sin nombre.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_4()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.4', 'crianzas: nombre NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c10', 1, NULL, 11, 12, 12);
	CALL p_log_test('V.4', 'ERROR: nombre NULL permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 5. Crear un nuevo vino Joven con el nombre repetido.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_5()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.5', 'jovenes: nombre UNIQUE', 'PASS');

	CALL p_populate_db();
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j10', 1, 'Vino nuevo Joven', 11, 0, 12);
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j11', 1, 'Vino nuevo Joven', 11, 0, 12);
	CALL p_log_test('V.5', 'ERROR: nombre duplicado permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 6. Crear un nuevo vino Crianza con el nombre repetido.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_6()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.6', 'crianzas: nombre UNIQUE', 'PASS');

	CALL p_populate_db();
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c11', 1, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_log_test('V.6', 'ERROR: nombre duplicado permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 7. Crear un nuevo vino Joven sin grados de alcohol.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_7()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.7', 'jovenes: grados NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j10', 1, 'Vino nuevo Joven', NULL, 0, 12);
	CALL p_log_test('V.7', 'ERROR: grados NULL permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 8. Crear un nuevo vino Crianza sin grados de alcohol.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_8()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.8', 'crianzas: grados NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c10', 1, 'Vino nuevo Crianza', NULL, 12, 12);
	CALL p_log_test('V.8', 'ERROR: grados NULL permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 9. Crear un nuevo vino Joven con graduación incorrecta.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_9()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.9', 'jovenes: grados CHECK (10-15)', 'PASS');

	CALL p_populate_db();
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j10', 1, 'Vino nuevo Joven', 9, 0, 12);
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j11', 1, 'Vino nuevo Joven', 16, 0, 12);
	CALL p_log_test('V.9', 'ERROR: grados fuera de rango permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 10. Crear un nuevo vino Crianza con graduación incorrecta.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_10()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.10', 'crianzas: grados CHECK (10-15)', 'PASS');

	CALL p_populate_db();
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c10', 1, 'Vino nuevo Crianza', 9, 12, 12);
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c11', 1, 'Vino nuevo Crianza', 16, 12, 12);
	CALL p_log_test('V.10', 'ERROR: grados fuera de rango permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 11. Crear un nuevo vino Joven sin bodega.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_11()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.11', 'jovenes: bodega_id NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO jovenes (joven_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('j10', NULL, 'Vino nuevo Joven', 10, 0, 12);
	CALL p_log_test('V.11', 'ERROR: bodega_id NULL permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 12. Crear un nuevo vino Crianza sin bodega.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_12()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.12', 'crianzas: bodega_id NOT NULL', 'PASS');

	CALL p_populate_db();
	INSERT INTO crianzas (crianza_id, bodega_id, nombre, grados, tiempo_barrica, tiempo_botella) 
	VALUES ('c10', NULL, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_log_test('V.12', 'ERROR: bodega_id NULL permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 2. Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_2()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.2', 'crianzas: Crear crianza válida', 'FAIL');

	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_log_test('V.2', 'crianzas: Crear crianza válida', 'PASS');
END//
DELIMITER ;

-- 3. Crear un nuevo vino Joven sin nombre.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_3()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.3', 'jovenes: nombre NOT NULL', 'PASS');

	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, null, 11, 0, 12);
	CALL p_log_test('V.3', 'ERROR: nombre NULL permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 4. Crear un nuevo vino Crianza sin nombre.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_4()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.4', 'crianzas: nombre NOT NULL', 'PASS');

	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, null, 11, 12, 12);
	CALL p_log_test('V.4', 'ERROR: nombre NULL permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 5. Crear un nuevo vino Joven con el nombre repetido.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_5()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.5', 'jovenes: nombre UNIQUE', 'PASS');

	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, 'Vino nuevo Joven', 11, 0, 12);
	CALL p_insert_joven('j11', 1, 'Vino nuevo Joven', 11, 0, 12);
	CALL p_log_test('V.5', 'ERROR: nombre duplicado permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 6. Crear un nuevo vino Crianza con el nombre repetido.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_6()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.6', 'crianzas: nombre UNIQUE', 'PASS');

	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_insert_crianza('c11', 1, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_log_test('V.6', 'ERROR: nombre duplicado permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 7. Crear un nuevo vino Joven sin grados de alcohol.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_7()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.7', 'jovenes: grados NOT NULL', 'PASS');

	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, 'Vino nuevo Joven', null, 0, 12);
	CALL p_log_test('V.7', 'ERROR: grados NULL permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 8. Crear un nuevo vino Crianza sin grados de alcohol.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_8()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.8', 'crianzas: grados NOT NULL', 'PASS');

	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', null, 12, 12);
	CALL p_log_test('V.8', 'ERROR: grados NULL permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 9. Crear un nuevo vino Joven con graduación incorrecta.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_9()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.9', 'jovenes: grados CHECK (10-15)', 'PASS');

	CALL p_populate_db();
	CALL p_insert_joven('j10', 1, 'Vino nuevo Joven', 9, 0, 12);
	CALL p_insert_joven('j11', 1, 'Vino nuevo Joven', 16, 0, 12);
	CALL p_log_test('V.9', 'ERROR: grados fuera de rango permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 10. Crear un nuevo vino Crianza con graduación incorrecta.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_10()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.10', 'crianzas: grados CHECK (10-15)', 'PASS');

	CALL p_populate_db();
	CALL p_insert_crianza('c10', 1, 'Vino nuevo Crianza', 9, 12, 12);
	CALL p_insert_crianza('c11', 1, 'Vino nuevo Crianza', 16, 12, 12);
	CALL p_log_test('V.10', 'ERROR: grados fuera de rango permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- 11. Crear un nuevo vino Joven sin bodega.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_11()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.11', 'jovenes: bodega_id NOT NULL', 'PASS');

	CALL p_populate_db();
	CALL p_insert_joven('j10', null, 'Vino nuevo Joven', 10, 0, 12);
	CALL p_log_test('V.11', 'ERROR: bodega_id NULL permitido en jovenes', 'FAIL');
END//
DELIMITER ;

-- 12. Crear un nuevo vino Crianza sin bodega.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_vino_12()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('V.12', 'crianzas: bodega_id NOT NULL', 'PASS');

	CALL p_populate_db();
	CALL p_insert_crianza('c10', null, 'Vino nuevo Crianza', 11, 12, 12);
	CALL p_log_test('V.12', 'ERROR: bodega_id NULL permitido en crianzas', 'FAIL');
END//
DELIMITER ;

-- ====================
-- EJECUTAR TODOS LOS TESTS
-- ====================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN
	-- Limpiar resultados anteriores
	DELETE FROM test_results;
	
	-- Tests de Bodegas
	CALL p_test_bodega_1();
	CALL p_test_bodega_2();
	CALL p_test_bodega_3();
	CALL p_test_bodega_4();
	
	-- Tests de Vinos
	CALL p_test_vino_1();
	CALL p_test_vino_2();
	CALL p_test_vino_3();
	CALL p_test_vino_4();
	CALL p_test_vino_5();
	CALL p_test_vino_6();
	CALL p_test_vino_7();
	CALL p_test_vino_8();
	CALL p_test_vino_9();
	CALL p_test_vino_10();
	CALL p_test_vino_11();
	CALL p_test_vino_12();
	
	-- Mostrar resultados
	SELECT * FROM test_results ORDER BY test_id;
	
	-- Resumen
	SELECT 
		test_status,
		COUNT(*) as count
	FROM test_results
	GROUP BY test_status;
END //
DELIMITER ;

-- Ejecutar todos los tests
CALL p_run_all_tests();
