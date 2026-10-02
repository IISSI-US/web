-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2022
-- Descripción: Función que devuelve el numero de Employees de una localidad
--

DELIMITER //
CREATE OR REPLACE FUNCTION 
	f_num_employees(c VARCHAR(64)) RETURNS INT 
BEGIN 
	RETURN (
		SELECT COUNT(*)
		FROM employees e JOIN departments d
		ON (e.department_id = d.department_id)
		WHERE d.city = c
	); 
END//
DELIMITER ;

-- SELECT *, f_num_employees(d.city) num_employees
-- FROM departments d
-- ;