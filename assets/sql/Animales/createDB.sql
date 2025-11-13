-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Animales
-- 

DROP DATABASE IF EXISTS AnimalesDB;
CREATE DATABASE AnimalesDB;
USE AnimalesDB;

-- Tabla Especies
CREATE OR REPLACE TABLE Especies (
    especieId INT AUTO_INCREMENT,
    especie VARCHAR(255) NOT NULL,
    PRIMARY KEY (especieId),
    UNIQUE KEY (especie)
);

-- Tabla Razas
CREATE OR REPLACE TABLE Razas (
    razaId INT AUTO_INCREMENT,
    especieId INT,
    raza VARCHAR(255) NOT NULL,
    PRIMARY KEY (razaId),
    FOREIGN KEY (especieId) REFERENCES Especies(especieId),
    UNIQUE KEY (especieId, raza)
);

-- Tabla Animales
CREATE OR REPLACE TABLE Animales (
    animalId INT AUTO_INCREMENT,
    razaId INT,
    chip VARCHAR(255) NOT NULL,
    nombre VARCHAR(255),
    descripcion TEXT,
    PRIMARY KEY (animalId),
    FOREIGN KEY (razaId) REFERENCES Razas(razaId),
    UNIQUE KEY (chip)
);

-- Tabla Personas
CREATE OR REPLACE TABLE Personas (
    personaId INT AUTO_INCREMENT,
    nombre VARCHAR(255),
    direccion VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (personaId),
    UNIQUE KEY (email)
);

-- Tabla Ingresos
CREATE OR REPLACE TABLE Ingresos (
    ingresoId INT AUTO_INCREMENT,
    personaId INT,
    animalId INT,
    fechaHoraEntrega DATETIME,
    PRIMARY KEY (ingresoId),
    FOREIGN KEY (personaId) REFERENCES Personas(personaId),
    FOREIGN KEY (animalId) REFERENCES Animales(animalId),
    UNIQUE KEY (ingresoId, animalId)
);

-- Tabla Entregas
CREATE OR REPLACE TABLE Entregas (
    ingresoId INT,
    PRIMARY KEY (ingresoId),
    FOREIGN KEY (ingresoId) REFERENCES Ingresos(ingresoId)
);

-- Tabla Abandonos
CREATE OR REPLACE TABLE Abandonos (
    ingresoId INT,
    fechaHoraAbandono DATETIME,
    lugar VARCHAR(255),
    PRIMARY KEY (ingresoId),
    FOREIGN KEY (ingresoId) REFERENCES Ingresos(ingresoId)
);

-- Tabla Adopciones
CREATE OR REPLACE TABLE Adopciones (
    ingresoId INT,
    personaId INT,
    animalId INT,
    fechaHoraAdopcion DATETIME,
    PRIMARY KEY (ingresoId),
    FOREIGN KEY (personaId) REFERENCES Personas(personaId),
    FOREIGN KEY (animalId) REFERENCES Animales(animalId)
    -- UNIQUE KEY (personaId, MONTH(fechaHoraAdopcion)) Esto no se puede hacer
    -- cuando se crea la tabla, hay que hacerlo con triggers y  procedures
);