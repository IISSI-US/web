--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Consultas SQL correspondientes al álgebra relacional de proyectos
--

USE ProyectosDB;

-- ER: empleados con roles en proyectos
CREATE OR REPLACE VIEW v_employee_roles AS
SELECT e.employee_id AS eid, e.national_id, e.name AS en,
       pc.role_period_id AS pcid, pc.role_id AS rid,
       pc.start_date AS fi, pc.end_date AS ff,
       r.project_id AS pid, r.name AS rn
FROM employees e
JOIN role_periods pc ON pc.employee_id = e.employee_id
JOIN roles r ON r.role_id = pc.role_id;

SELECT * FROM v_employee_roles;

-- ET: empleados con tareas en proyectos
CREATE OR REPLACE VIEW v_employee_tasks AS
SELECT e.employee_id AS eid, e.national_id, e.name AS en,
       pt.task_period_id AS ptid, pt.task_id AS tid,
       pt.start_date AS fi, pt.end_date AS ff,
       t.project_id AS pid, t.position AS ord, t.task_code AS cod,
       t.description AS tdesc, t.estimate AS est
FROM employees e
JOIN task_periods pt ON pt.employee_id = e.employee_id
JOIN tasks t ON t.task_id = pt.task_id;

SELECT * FROM v_employee_tasks;

-- EP: empleados que trabajan en proyectos, por rol o por tarea
SELECT eid, en, pid
FROM v_employee_roles
UNION
SELECT eid, en, pid
FROM v_employee_tasks;

-- EP: empleados que trabajan en proyectos, tanto por rol como por tarea
SELECT eid, en, pid
FROM v_employee_roles
INTERSECT
SELECT eid, en, pid
FROM v_employee_tasks;

-- TareasEmpleadoP1: tareas asignadas a empleados en el proyecto 1
SELECT *
FROM v_employee_tasks
WHERE pid = 1;

-- NumTareasEmpleadoP1: Número de tareas por empleado en el proyecto 1
SELECT eid, en, COUNT(*) AS total
FROM v_employee_tasks
WHERE pid = 1
GROUP BY eid, en;

-- ProyectosRoles: roles de cada proyecto
SELECT p.project_id AS pid, p.name AS pn, p.budget AS pres,
       r.role_id AS rid, r.name AS rn
FROM projects p
JOIN roles r ON r.project_id = p.project_id;

-- ProyectosTareas: tareas de cada proyecto
SELECT p.project_id AS pid, p.name AS pn, p.budget AS pres,
       t.task_id AS tid, t.position AS ord, t.task_code AS cod,
       t.description AS tdesc, t.estimate AS est
FROM projects p
JOIN tasks t ON t.project_id = p.project_id;

-- NumSubtareas: Número de subtareas por tarea
SELECT t.task_id AS tid, COUNT(*) AS total
FROM tasks t
JOIN subtasks st ON st.task_id = t.task_id
GROUP BY t.task_id;

-- EST: empleados con subtareas
SELECT et.*, st.subtask_id AS stid, st.position AS sord
FROM v_employee_tasks et
JOIN subtasks st ON st.task_id = et.tid;
