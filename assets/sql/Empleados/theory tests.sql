-- PRUEBAS
-- Para la correcta realización de estas pruebas, la base de datos debe estar inicialmente vacía (sin datos)


-- CALL pInsertDepartment('Economía', 'Almeria'); 
-- Insertar departamento duplicado: descomentar la siguiente línea
-- CALL pInsertDepartment ('Economía', 'Almeria'); 

--Insertar Empleado con fecha de inicio nula
CALL pInsertEmployee(1, NULL, 'Daniel', 500, NULL, '2020-09-15', 0.2); 
CALL pInsertEmployee(1, NULL, 'Elena', 1500, NULL, '2020-09-15', 0.2); 
CALL pInsertEmployee(1, NULL, 'Florian', 5000, NULL, '2020-09-15', 0.2); 
CALL pInsertEmployee(1, NULL, 'Gema', 7500, NULL, '2020-09-15', 0.2); 
CALL pInsertEmployee(1, NULL, 'Helena', 5100, NULL, '2020-09-15', 0.2); 

select * from Employees;

--Procedimiemnto pIgualarComisiones: ejecutar las siguientes líneas una por una observando el resultado
select employeeId, fee from Employees;
CALL pIgualarComisiones(); 
select employeeId, fee from Employees;

--Procedimiento pSubirComisionEmpleado: ejecutar las siguientes líneas una por una observando el resultado
select fee from Employees where employeeId = 1;
CALL pRaiseFee(1, 0.1);
select fee from Employees where employeeId = 1;

-- Función fNumEpleados

-- Si usamos la función de agregación COUNT, se cuentan los NULL
SELECT city, COUNT(*)
FROM Departments
GROUP BY localidad;
-- Si usamos la fución que acabamos de definir, no se cuentan los NULL
SELECT city, fNumEmployees(localidad)
FROM Departments
GROUP BY city;

-- Trigger tEmpleadoPropioJefeU 
UPDATE Employees SET bossId=5
WHERE employeeId = 5;

-- Trigger tCambiosComision 
UPDATE Employees SET fee=0.9
WHERE employeeId = 5; 

-- Función fSumaSalarios
SELECT fSumSalaries();
