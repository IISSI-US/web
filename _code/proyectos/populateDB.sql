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

    INSERT INTO projects (project_id, name, budget) VALUES
        (1,'Proyecto A', 100000)
    ;

    -- Insertar datos de ejemplo en la tabla roles
    INSERT INTO roles (role_id, project_id, name) VALUES
        (1, 1, 'Director'),
        (2, 1, 'Analista'),
        (3, 1, 'Responsable de pruebas')
    ;

    -- Insertar datos de ejemplo en la tabla tareas
    INSERT INTO tasks (task_id, project_id, position, task_code, description, estimate) VALUES
        (1, 1, 1, 'T-DI', 'Diseño de interfaz', 30),
        (2, 1, 2, 'T-DB', 'Desarrollo de BackEnd', 50),
        (3, 1, 3, 'T-T', 'Testing', 225),
        (4, 1, 4, 'T-TPU', 'Pruebas unitarias', 150),
        (5, 1, 5, 'T-TPI', 'Pruebas de integración', 75),
        (6, 1, 6, 'T-D', 'Despliegue', 10)
    ;

    -- Insertar datos de ejemplo en la tabla subtareas
    INSERT INTO subtasks (subtask_id, task_id, position) VALUES
        (4, 3, 1),
        (5, 3, 2)
    ;

    -- Insertar datos de ejemplo en la tabla empleados
    INSERT INTO employees (employee_id, national_id, name) VALUES
        (1, '12345678A', 'Juan Pérez'),
        (2, '87654321B', 'María López'),
        (3, '11223344C', 'Carlos García'),
        (4, '44332211D', 'Ana Rueda')
    ;

    -- Insertar datos de ejemplo en la tabla role_periods
    INSERT INTO role_periods (role_period_id, employee_id, role_id, start_date, end_date) VALUES
        (1, 1, 1, '2023-12-01', null),
        (2, 2, 2, '2024-01-01', null),
        (3, 3, 3, '2024-01-01', null),
        (4, 4, 3, '2024-01-01', null)
    ;

    -- Insertar datos de ejemplo en la tabla role_periods
    INSERT INTO task_periods (task_period_id, employee_id, task_id, start_date, end_date) VALUES
        (1, 1, 1, '2024-01-01', '2024-01-30'),
        (2, 2, 2, '2024-02-01', '2024-03-15'),
        (3, 3, 3, '2024-03-01', '2024-04-30'),
        (4, 4, 4, '2024-05-01', '2024-06-15')
    ;

END //
DELIMITER ;

CALL p_populate();
