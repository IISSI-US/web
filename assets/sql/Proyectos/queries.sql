-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2024
-- Descripción: Script con las consultas
-- 

-- Empleados con roles en proyectos:
SELECT e.nombre, r.nombre rol, pc.fInicio, pc.fFin
FROM Empleados e JOIN PeriodosCargos pc
	ON e.empleadoId = pc.empleadoId JOIN Roles r
	ON r.rolId  = pc.rolId
;

-- Empleados con tareas en proyectos:
SELECT e.nombre, t.descripcion, pt.fInicio, pt.fFin
FROM Empleados e JOIN PeriodosTareas pt
	ON e.empleadoId = pt.empleadoId JOIN Tareas t
	ON t.tareaId = pt.tareaId
;

-- Empleados que trabajan en proyectos (roles o tareas):
SELECT e.nombre, r.nombre rol, pc.fInicio, pc.fFin
FROM Empleados e JOIN PeriodosCargos pc
	ON e.empleadoId = pc.empleadoId JOIN Roles r
	ON r.rolId  = pc.rolId
UNION 
SELECT e.nombre, t.descripcion, pt.fInicio, pt.fFin
FROM Empleados e JOIN PeriodosTareas pt
	ON e.empleadoId = pt.empleadoId JOIN Tareas t
	ON t.tareaId = pt.tareaId
;

-- Empleados que trabajan en proyectos (roles y tareas):
SELECT e.nombre, r.nombre rol, t.descripcion
FROM Empleados e JOIN PeriodosCargos pc
	ON e.empleadoId = pc.empleadoId JOIN Roles r
	ON r.rolId  = pc.rolId JOIN PeriodosTareas pt
	ON e.empleadoId = pt.empleadoId JOIN Tareas t
	ON t.tareaId = pt.tareaId
;

-- Tareas asignadas a empleados en el proyecto 1:
SELECT e.nombre, t.descripcion, pt.fInicio, pt.fFin
FROM Empleados e JOIN PeriodosTareas pt
	ON e.empleadoId = pt.empleadoId JOIN Tareas t
	ON t.tareaId = pt.tareaId
WHERE t.proyectoId = 1
;

-- Número de tareas asignadas a los empleados del proyecto 1:
SELECT e.empleadoId, e.nombre, count(*)
FROM Empleados e JOIN PeriodosTareas pt
	ON e.empleadoId = pt.empleadoId JOIN Tareas t
	ON t.tareaId = pt.tareaId
WHERE t.proyectoId = 1
GROUP BY e.empleadoId
;

-- Listado de Roles asignados a los proyectos:
SELECT e.empleadoId, e.nombre, r.nombre rol, pc.fInicio, pc.fFin
FROM Empleados e JOIN PeriodosCargos pc
	ON e.empleadoId = pc.empleadoId JOIN Roles r
	ON r.rolId  = pc.rolId
GROUP BY e.empleadoId
;

-- Listado de tareas de los proyectos:
SELECT e.empleadoId, e.nombre, t.descripcion, pt.fInicio, pt.fFin
FROM Empleados e JOIN PeriodosTareas pt
	ON e.empleadoId = pt.empleadoId JOIN Tareas t
	ON t.tareaId = pt.tareaId
GROUP BY e.empleadoId
;

-- Número de subtareas de cada tareas de los proyectos:
SELECT t.tareaId, COUNT(*)
FROM Tareas t LEFT JOIN Subtareas s
	ON t.tareaId = s.tareaId
GROUP BY t.tareaId
;

-- Empleados con subtareas en proyectos:
SELECT e.nombre, t.descripcion, pt.fInicio, pt.fFin
FROM Empleados e JOIN PeriodosTareas pt
	ON e.empleadoId = pt.empleadoId JOIN Tareas t
	ON t.tareaId = pt.tareaId JOIN Subtareas s
	ON t.tareaId = s.tareaId
;

