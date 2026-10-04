--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Procedimiento para poblar la BD de proyectos
--

USE ProyectosDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    DELETE FROM task_periods;
    DELETE FROM role_periods;
    DELETE FROM subtasks;
    DELETE FROM tasks;
    DELETE FROM roles;
    DELETE FROM employees;
    DELETE FROM projects;
    SET FOREIGN_KEY_CHECKS = 1;

    INSERT INTO projects (project_id, name, description, budget) VALUES
        (1, 'Portal de alquileres', 'Plataforma de alquiler de viviendas', 50000),
        (2, 'Gestor interno', 'Herramientas internas del equipo', 90000)
    ;

    -- Insertar datos de ejemplo en la tabla roles
    INSERT INTO roles (role_id, project_id, name) VALUES
        (1, 1, 'Director'),
        (2, 1, 'Analista'),
        (3, 2, 'Responsable de pruebas')
    ;

    -- Insertar datos de ejemplo en la tabla tareas
    INSERT INTO tasks (task_id, project_id, position, task_code, description, estimate) VALUES
        (1, 1, 1, 'T-01', 'Diseño del modelo', 40),
        (2, 1, 2, 'T-02', 'Implementación de API', 80),
        (3, 2, 1, 'T-10', 'Plan de pruebas', 60),
        (4, 1, 3, 'T-03', 'Pruebas unitarias', 30),
        (5, 1, 4, 'T-04', 'Pruebas de integración', 25),
        (6, 2, 2, 'T-11', 'Validación del plan de pruebas', 30)
    ;

    -- Insertar datos de ejemplo en la tabla subtareas
    INSERT INTO subtasks (subtask_id, task_id, position) VALUES
        (4, 2, 1),
        (5, 4, 1),
        (6, 3, 1)
    ;

    -- Insertar datos de ejemplo en la tabla empleados
    INSERT INTO employees (employee_id, national_id, name) VALUES
        (1, '11111111A', 'Ana García'),
        (2, '22222222B', 'Luis Pérez'),
        (3, '33333333C', 'Marta López'),
        (4, '44332211D', 'Ana Rueda')
    ;

    -- Insertar datos de ejemplo en la tabla role_periods
    INSERT INTO role_periods (role_period_id, employee_id, role_id, start_date, end_date) VALUES
        (1, 1, 1, '2024-01-01', '2024-01-31'),
        (2, 1, 1, '2024-02-01', null),
        (3, 2, 2, '2024-01-15', null),
        (4, 3, 3, '2024-02-01', null),
        (5, 4, 1, '2024-03-01', null)
    ;

    -- Insertar datos de ejemplo en la tabla task_periods
    INSERT INTO task_periods (task_period_id, employee_id, task_id, start_date, end_date) VALUES
        (1, 2, 1, '2024-02-01', '2024-02-15'),
        (2, 1, 1, '2024-02-16', '2024-02-28'),
        (3, 2, 1, '2024-03-01', '2024-03-15'),
        (4, 2, 2, '2024-02-16', null),
        (5, 3, 3, '2024-03-01', null),
        (6, 2, 4, '2024-02-20', null)
    ;

END //
DELIMITER ;

CALL p_populate();
