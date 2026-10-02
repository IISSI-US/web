-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2024
-- Descripción: script para crear el esquema de la BD
-- 

-- Crear la base de datos
DROP DATABASE IF EXISTS ProyectosDB;
CREATE DATABASE ProyectosDB;
USE ProyectosDB;

-- Crear la tabla proyectos
CREATE OR REPLACE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    budget DECIMAL(15, 2) NOT NULL,
    CONSTRAINT ck_projects_budget CHECK (budget > 0)
);

-- Crear la tabla roles
CREATE OR REPLACE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    name VARCHAR(255) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Crear la tabla tareas
CREATE OR REPLACE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    position INT NOT NULL,
    task_code CHAR(12) NOT NULL,
    description TEXT NOT NULL,
    estimate INT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    CONSTRAINT uq_tasks_project_position UNIQUE (project_id, position),
    CONSTRAINT uq_tasks_project_code UNIQUE (project_id, task_code),
    CONSTRAINT ck_tasks_position CHECK (position > 0),
    CONSTRAINT ck_tasks_estimate CHECK (estimate > 0)
);

-- Crear la tabla subtareas
CREATE OR REPLACE TABLE subtasks (
    subtask_id INT,
    task_id INT NOT NULL,
    position INT NOT NULL,
    PRIMARY KEY (subtask_id),
    FOREIGN KEY (subtask_id) REFERENCES tasks(task_id),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id),
    CONSTRAINT uq_subtasks_task_position UNIQUE (task_id, position),
    CONSTRAINT ck_subtasks_position CHECK (position > 0)
);

-- Crear la tabla empleados
CREATE OR REPLACE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    national_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL
);

-- Crear la tabla role_periods
CREATE OR REPLACE TABLE role_periods (
    role_period_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    role_id INT,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    UNIQUE (employee_id, role_id),
    CONSTRAINT ck_role_periods_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

-- Crear la tabla task_periods
CREATE OR REPLACE TABLE task_periods (
    task_period_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    task_id INT,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id),
    UNIQUE (employee_id, task_id),
    CONSTRAINT ck_task_periods_dates CHECK (end_date IS NULL OR end_date >= start_date)
);
