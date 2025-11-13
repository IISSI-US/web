-- 
-- Autor: David Ruiz
-- Fecha: Noviembre de 2024
-- Descripción: script para crear el esquema de la BD
-- 

-- Crear la base de datos
DROP DATABASE IF EXISTS ProyectosDB;
CREATE DATABASE ProyectosDB;
USE ProyectosDB;

-- Crear la tabla Proyectos
CREATE OR REPLACE TABLE Proyectos (
    proyectoId INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    presupuesto DECIMAL(15, 2) NOT NULL
);

-- Crear la tabla Roles
CREATE OR REPLACE TABLE Roles (
    rolId INT AUTO_INCREMENT PRIMARY KEY,
    proyectoId INT,
    nombre VARCHAR(255) NOT NULL,
    FOREIGN KEY (proyectoId) REFERENCES Proyectos(proyectoId)
);

-- Crear la tabla Tareas
CREATE OR REPLACE TABLE Tareas (
    tareaId INT AUTO_INCREMENT PRIMARY KEY,
    proyectoId INT,
    orden INT NOT NULL,
    id CHAR(12) NOT NULL,
    descripcion TEXT NOT NULL,
    estimacion INT NOT NULL,
    FOREIGN KEY (proyectoId) REFERENCES Proyectos(proyectoId),
    UNIQUE (tareaId, orden)
);

-- Crear la tabla Subtareas
CREATE OR REPLACE TABLE Subtareas (
    subtareaId INT AUTO_INCREMENT,
    tareaId INT,
    orden INT NOT NULL,
    PRIMARY KEY (subtareaId, tareaId),
    FOREIGN KEY (tareaId) REFERENCES Tareas(tareaId),
    UNIQUE (subtareaId, orden)
);

-- Crear la tabla Empleados
CREATE OR REPLACE TABLE Empleados (
    empleadoId INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(255) NOT NULL
);

-- Crear la tabla PeriodosCargos
CREATE OR REPLACE TABLE PeriodosCargos (
    periodoCargoId INT AUTO_INCREMENT PRIMARY KEY,
    empleadoId INT,
    rolId INT,
    fInicio DATE NOT NULL,
    fFin DATE,
    FOREIGN KEY (empleadoId) REFERENCES Empleados(empleadoId),
    FOREIGN KEY (rolId) REFERENCES Roles(rolId),
    UNIQUE (empleadoId, rolId)
);

-- Crear la tabla PeriodosTareas
CREATE OR REPLACE TABLE PeriodosTareas (
    periodoTareaId INT AUTO_INCREMENT PRIMARY KEY,
    empleadoId INT,
    tareaId INT,
    fInicio DATE NOT NULL,
    fFin DATE,
    FOREIGN KEY (empleadoId) REFERENCES Empleados(empleadoId),
    FOREIGN KEY (tareaId) REFERENCES Tareas(tareaId),
    UNIQUE (empleadoId, tareaId)
);
