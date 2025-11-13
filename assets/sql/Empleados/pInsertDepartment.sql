-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Procedimiento para insertar un nuevo Departamento
--

DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pInsertDepartment(
		p_nameDep VARCHAR(32), 
		p_city VARCHAR(64)) 
BEGIN
	INSERT INTO Departments (nameDep, city) VALUES (p_nameDep, p_city); 
END//
DELIMITER ;

CALL pPopulateDB();
CALL pInsertDepartment('Economía', 'Almeria'); 
-- Insertar departamento duplicado:
-- CALL pInsertDepartment ('Economía', 'Almeria'); 
