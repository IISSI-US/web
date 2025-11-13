/* Consultas, para probar las consultas una a una debe ejecutar 
Shift+Control+F9  con el cursor en la línea que contiene la consulta */

/* Employees con un sueldo inferior a 2000 euros */
SELECT *
FROM Employees
WHERE salary < 2000;

/* Employees con un sueldo inferior a 2000 euros */
SELECT nameEmp, salary
FROM Employees
WHERE salary < 2000;

/* Fechas de alta y baja de los empeados como una lista */
SELECT ALL startDate, endDate
FROM Employees;

/* Fechas de alta y baja de los empeados como un conjunto */
SELECT DISTINCT startDate, endDate
FROM Employees;

/* Conjunto de Employees con un salary en [2000,3000] */
/* Opción 1 */
SELECT DISTINCT nameEmp, salary 
FROM Employees
WHERE salary >=2000 AND salary <=3000;
/* Opción 2 */
SELECT DISTINCT nameEmp, salary
FROM Employees
WHERE salary BETWEEN 2000 AND 3000;

/* Conjunto de Employees con salary de 1000, 2500 o 3000 euros */
SELECT DISTINCT nameEmp, salary
FROM Employees
WHERE salary IN (1000,2500,3000);

/* Lista de Employees con una 'o' en la segunda posición de su nameEmp
o que son jefes */
SELECT *
FROM Employees
WHERE nameEmp LIKE '_o%' OR bossId IS NULL;

/* Lista de Employees ordenada por departmentId y luego por nameEmp */
SELECT *
FROM Employees
ORDER BY departmentId, nameEmp ASC;

/* Producto cartesiano de Employees y Departments */
SELECT *
FROM Employees, Departments;

/* Employees y Departments en los que trabajan. Natural join */
/* Opción 1: */
SELECT nameEmp, salary, startDate, nameDep
FROM Employees E, Departments D
WHERE E.departmentId=D.departmentId;
/* Opción 2: */
SELECT nameEmp, salary, startDate, nameDep
FROM Employees NATURAL JOIN Departments;

/* Join parciales */
/* Para hacer una prueba borramos el departamento de Ana */ 
UPDATE Employees SET departmentId=NULL WHERE employeeId=5;

/* En el left join se devuelve a Ana, aunque no tenga departamento */
SELECT nameEmp, salary, startDate, nameDep
FROM Employees E
  LEFT JOIN Departments D
  ON E.departmentId=D.departmentId;
  
/* En el right join se devuelve el Departamento de Arte, aunque no tenga Employees */
SELECT nameEmp, salary, startDate, nameDep
FROM Employees E
  RIGHT JOIN Departments D
  ON E.departmentId=D.departmentId;
  
/* Ejemplo de unión de left y right join, devuelve el full join */
SELECT *
FROM Employees E
	LEFT JOIN Departments D
	ON E.departmentId=D.departmentId
UNION
SELECT *
FROM Employees E
	RIGHT JOIN Departments D
	ON E.departmentId=D.departmentId;
	
/* Departments sin Employees */
SELECT *
FROM Departments D
WHERE NOT EXISTS (
	SELECT * FROM Employees E
	WHERE D.departmentId=E.departmentId
);

/* Departments con Employees */
SELECT *
FROM Departments D
WHERE EXISTS (
	SELECT * FROM Employees E
	WHERE D.departmentId=E.departmentId
);

/* Estadísticas salarys de los Employees */
SELECT COUNT(*), MIN(salary), MAX(salary), AVG(salary), SUM(salary)
FROM Employees;

/* Estadísticas salarys por departamento */
SELECT departmentId,
	COUNT(*),
	AVG(salary) angSalary,
	AVG(salary * (1+fee)) salaryConfee,
	SUM(salary) gastosalarys
FROM Employees
GROUP BY departmentId;

/* Estadísticas salarys por departamento con al menos dos empleado*/
SELECT departmentId,
	COUNT(*), 
	AVG(salary) salaryMedio,
	AVG(salary * (1+fee)) salaryConfee,
	SUM(salary) gastosalarys
FROM Employees
GROUP BY departmentId HAVING COUNT(*)>1;
/* Opción 2: Usando la vista EmployeesDepartments */
CREATE OR REPLACE VIEW vEmployeesDepartments AS
SELECT * 
FROM Employees NATURAL JOIN Departments; 

SELECT nameDep,
	COUNT(*), 
	AVG(salary) salaryMedio,
	AVG(salary * (1+fee)) salaryConfee,
	SUM(salary) gastosalarys
FROM vEmployeesDepartments
GROUP BY departmentId HAVING COUNT(*)>1;

/* Employees con salary mayor que la media de su departamento*/ 
SELECT * FROM Employees
WHERE salary >
ALL (SELECT AVG(salary)
       FROM Employees
       GROUP BY departmentId);
       
/* Departamento con más Employees */
/* Opción 1 */
SELECT departmentId FROM Employees
GROUP BY departmentId HAVING COUNT(*)>= ALL 
   ( SELECT COUNT(*) 
     FROM Employees 
     GROUP BY departmentId
    );

/* Opción 2 */
SELECT departmentId FROM Employees
GROUP BY departmentId HAVING COUNT(*) =
   ( SELECT MAX(total) FROM
      ( SELECT COUNT(*) AS total
        FROM Employees
        GROUP BY departmentId
       ) NumEmployees
   );
   

/* Vista con las estadísticas de los Employees por Departamento */
CREATE OR REPLACE VIEW vStatEmployees AS 
SELECT departmentId,
	COUNT(*) AS numEmployees,
	AVG(salary) salaryMedio,
	AVG(salary * (1+fee)) salaryWithfee,
	SUM(salary) totalSalary
FROM Employees
GROUP BY departmentId;

/* Número de Employees que tiene el departamento con más Employees */
SELECT MAX(numEmployees)
FROM vStatEmployees;
