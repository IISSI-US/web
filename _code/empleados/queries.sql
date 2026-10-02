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

/* employees y departments en los que trabajan. Natural join */
/* Opción 1: */
SELECT name_emp, salary, start_date, name_dep
FROM employees e, departments d
WHERE e.department_id=d.department_id;
/* Opción 2: */
SELECT name_emp, salary, start_date, name_dep
FROM employees NATURAL JOIN departments;

/* Join parciales */
/* Para hacer una prueba borramos el departamento de Ana */ 
UPDATE employees SET department_id=NULL WHERE employee_id=5;

/* En el left join se devuelve a Ana, aunque no tenga departamento */
SELECT name_emp, salary, start_date, name_dep
FROM employees e
  LEFT JOIN departments d
  ON e.department_id=d.department_id;
  
/* En el right join se devuelve el Departamento de Arte, aunque no tenga employees */
SELECT name_emp, salary, start_date, name_dep
FROM employees e
  RIGHT JOIN departments d
  ON e.department_id=d.department_id;
  
/* Ejemplo de unión de left y right join, devuelve el full join */
SELECT *
FROM employees e
	LEFT JOIN departments d
	ON e.department_id=d.department_id
UNION
SELECT *
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
SELECT department_id,
	COUNT(*),
	AVG(salary) avg_salary,
	AVG(salary * (1+fee)) salary_with_fee,
	SUM(salary) total_salaries
FROM employees
GROUP BY department_id;

/* Estadísticas salarys por departamento con al menos dos empleado*/
SELECT department_id,
	COUNT(*), 
	AVG(salary) avg_salary,
	AVG(salary * (1+fee)) salary_with_fee,
	SUM(salary) total_salaries
FROM employees
GROUP BY department_id HAVING COUNT(*)>1;
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
ALL (SELECT AVG(salary)
       FROM employees
       GROUP BY department_id);
       
/* Departamento con más employees */
/* Opción 1 */
SELECT department_id FROM employees
GROUP BY department_id HAVING COUNT(*)>= ALL 
   ( SELECT COUNT(*) 
     FROM employees 
     GROUP BY department_id
    );

/* Opción 2 */
SELECT department_id FROM employees
GROUP BY department_id HAVING COUNT(*) =
   ( SELECT MAX(total) FROM
      ( SELECT COUNT(*) AS total
        FROM employees
        GROUP BY department_id
       ) num_employees
   );
   

/* Vista con las estadísticas de los employees por Departamento */
CREATE OR REPLACE VIEW v_stat_employees AS 
SELECT department_id,
	COUNT(*) AS num_employees,
	AVG(salary) avg_salary,
	AVG(salary * (1+fee)) salary_with_fee,
	SUM(salary) total_salary
FROM employees
GROUP BY department_id;

/* Número de employees que tiene el departamento con más employees */
SELECT MAX(num_employees)
FROM v_stat_employees;
