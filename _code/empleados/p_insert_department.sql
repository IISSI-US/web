-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para insertar un nuevo Departamento
--

DELIMITER //
CREATE OR REPLACE PROCEDURE 
	p_insert_department(
		p_name_dep VARCHAR(32), 
		p_city VARCHAR(64)) 
BEGIN
	INSERT INTO departments (name_dep, city) VALUES (p_name_dep, p_city); 
END//
DELIMITER ;

-- CALL p_populate();
-- CALL p_insert_department('Economía', 'Almeria'); 

-- Insertar departamento duplicado:
-- CALL p_insert_department ('Economía', 'Almeria'); 
