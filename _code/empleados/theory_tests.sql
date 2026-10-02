-- PRUEBAS -- OBSOLETO: AHORA ESTÁN EN tests/tests.sql
-- Para la correcta realización de estas pruebas, la base de datos debe estar inicialmente vacía (sin datos)


-- CALL p_insert_department('Economía', 'Almeria'); 
-- Insertar departamento duplicado: descomentar la siguiente línea
-- CALL p_insert_department ('Economía', 'Almeria'); 

--Insertar Empleado con fecha de inicio nula
CALL p_insert_employee(1, NULL, 'Daniel', 500, NULL, '2020-09-15', 0.2); 
CALL p_insert_employee(1, NULL, 'Elena', 1500, NULL, '2020-09-15', 0.2); 
CALL p_insert_employee(1, NULL, 'Florian', 5000, NULL, '2020-09-15', 0.2); 
CALL p_insert_employee(1, NULL, 'Gema', 7500, NULL, '2020-09-15', 0.2); 
CALL p_insert_employee(1, NULL, 'Helena', 5100, NULL, '2020-09-15', 0.2); 

select * from employees;

--Procedimiento p_equate_fees: ejecutar las siguientes líneas una por una observando el resultado
select employee_id, fee from employees;
CALL p_equate_fees(); 
select employee_id, fee from employees;

--Procedimiento p_raise_fee: ejecutar las siguientes líneas una por una observando el resultado
select fee from employees where employee_id = 1;
CALL p_raise_fee(1, 0.1);
select fee from employees where employee_id = 1;

-- Función f_num_employees

-- Si usamos la función de agregación COUNT, se cuentan los NULL
SELECT city, COUNT(*)
FROM departments
GROUP BY city;
-- Si usamos la fución que acabamos de definir, no se cuentan los NULL
SELECT city, f_num_employees(city)
FROM departments
GROUP BY city;

-- Trigger t_bu_self_boss 
UPDATE employees SET boss_id=5
WHERE employee_id = 5;

-- Trigger t_change_fee 
UPDATE employees SET fee=0.9
WHERE employee_id = 5; 

-- Función f_sum_salaries
SELECT f_sum_salaries();
