/* Consultas, para probar las consultas una a una debe ejecutar 
Shift+Control+F9  con el cursor en la línea que contiene la consulta */

/* Employees con un sueldo inferior a 2000 euros */
SELECT *
FROM employees
WHERE salary < 2000;

/* Employees con un sueldo inferior a 2000 euros */
SELECT name_emp, salary
FROM employees
WHERE salary < 2000;

/* Fechas de alta y baja de los empeados como una lista */
SELECT ALL start_date, end_date
FROM employees;

/* Fechas de alta y baja de los empeados como un conjunto */
SELECT DISTINCT start_date, end_date
FROM employees;

/* Conjunto de employees con un salary en [2000,3000] */
/* Opción 1 */
SELECT DISTINCT name_emp, salary 
FROM employees
WHERE salary >=2000 AND salary <=3000;
/* Opción 2 */
SELECT DISTINCT name_emp, salary
FROM employees
WHERE salary BETWEEN 2000 AND 3000;

/* Conjunto de employees con salary de 1000, 2500 o 3000 euros */
SELECT DISTINCT name_emp, salary
FROM employees
WHERE salary IN (1000,2500,3000);

/* Lista de employees con una 'o' en la segunda posición de su name_emp
o que son jefes */
SELECT *
FROM employees
WHERE name_emp LIKE '_o%' OR boss_id IS NULL;

/* Lista de employees ordenada por department_id y luego por name_emp */
SELECT *
FROM employees
ORDER BY department_id, name_emp ASC;

/* Producto cartesiano de employees y departments */
SELECT *
FROM employees, departments;

/* Opción 1: */
SELECT name_emp, salary, start_date, name_dep
FROM employees e, departments d
WHERE e.department_id=d.department_id;
/* Opción 2: */
SELECT name_emp, salary, start_date, name_dep
FROM employees NATURAL JOIN departments;

/* Join parciales */
/* LEFT JOIN conserva todos los empleados, incluso si no tienen departamento */
SELECT e.employee_id, e.name_emp, d.department_id, d.name_dep
FROM employees e
	LEFT JOIN departments d
  ON e.department_id=d.department_id;
  
/* RIGHT JOIN conserva igualmente todos los departamentos */
SELECT e.employee_id, e.name_emp, d.department_id, d.name_dep
FROM employees e
  RIGHT JOIN departments d
  ON e.department_id=d.department_id;
  
/* Ejemplo de unión de left y right join, devuelve el full join */
SELECT e.employee_id, e.name_emp, d.department_id, d.name_dep
FROM employees e
	LEFT JOIN departments d
	ON e.department_id=d.department_id
UNION
SELECT e.employee_id, e.name_emp, d.department_id, d.name_dep
FROM employees e
	RIGHT JOIN departments d
	ON e.department_id=d.department_id;
	
/* departments sin employees */
SELECT *
FROM departments d
WHERE NOT EXISTS (
	SELECT * FROM employees e
	WHERE d.department_id=e.department_id
);

/* departments con employees */
SELECT *
FROM departments d
WHERE EXISTS (
	SELECT * FROM employees e
	WHERE d.department_id=e.department_id
);

/* Estadísticas salarys de los employees */
SELECT COUNT(*), MIN(salary), MAX(salary), AVG(salary), SUM(salary)
FROM employees;

/* Estadísticas salarys por departamento */
SELECT e.department_id,
	COUNT(*),
	AVG(e.salary) avg_salary,
	AVG(e.salary * (1+e.fee)) salary_with_fee,
	SUM(e.salary) total_salaries
FROM employees e
JOIN departments d ON d.department_id=e.department_id
GROUP BY e.department_id;

/* Estadísticas salarys por departamento con al menos dos empleado*/
	SELECT e.department_id,
	COUNT(*), 
	AVG(e.salary) avg_salary,
	AVG(e.salary * (1+e.fee)) salary_with_fee,
	SUM(e.salary) total_salaries
FROM employees e
JOIN departments d ON d.department_id=e.department_id
GROUP BY e.department_id HAVING COUNT(*)>1;
/* Opción 2: Usando la vista employees_departments */
CREATE OR REPLACE VIEW v_employees_departments AS
SELECT * 
FROM employees NATURAL JOIN departments; 

SELECT name_dep,
	COUNT(*), 
	AVG(salary) avg_salary,
	AVG(salary * (1+fee)) salary_with_fee,
	SUM(salary) total_salaries
FROM v_employees_departments
GROUP BY department_id HAVING COUNT(*)>1;

/* employees con salary mayor que la media de su departamento*/ 
SELECT * FROM employees
WHERE salary >
ALL (SELECT AVG(e2.salary)
       FROM employees e2
	JOIN departments d2 ON d2.department_id=e2.department_id
	GROUP BY e2.department_id);
       
/* Departamento con más employees */
/* Opción 1 */
SELECT e.department_id FROM employees e
JOIN departments d ON d.department_id=e.department_id
GROUP BY e.department_id HAVING COUNT(*)>= ALL
   ( SELECT COUNT(*) 
	FROM employees e2
	JOIN departments d2 ON d2.department_id=e2.department_id
	GROUP BY e2.department_id
    );

/* Opción 2 */
SELECT e.department_id FROM employees e
JOIN departments d ON d.department_id=e.department_id
GROUP BY e.department_id HAVING COUNT(*) =
   ( SELECT MAX(total) FROM
      ( SELECT COUNT(*) AS total
	FROM employees e2
	JOIN departments d2 ON d2.department_id=e2.department_id
	GROUP BY e2.department_id
       ) num_employees
   );
   

/* Vista con las estadísticas de los employees por Departamento */
CREATE OR REPLACE VIEW v_stat_employees AS 
SELECT e.department_id,
	COUNT(*) AS num_employees,
	AVG(e.salary) avg_salary,
	AVG(e.salary * (1+e.fee)) salary_with_fee,
	SUM(e.salary) total_salary
FROM employees e
JOIN departments d ON d.department_id=e.department_id
GROUP BY e.department_id;

/* Número de employees que tiene el departamento con más employees */
SELECT MAX(num_employees)
FROM v_stat_employees;
