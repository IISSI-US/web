-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Animales
-- 

DROP DATABASE IF EXISTS AnimalesDB;
CREATE DATABASE AnimalesDB;
USE AnimalesDB;

-- Tabla species
CREATE OR REPLACE TABLE species (
    species_id INT AUTO_INCREMENT,
    species_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (species_id),
    UNIQUE KEY (species_name)
);

-- Tabla razas
CREATE OR REPLACE TABLE breeds (
    breed_id INT AUTO_INCREMENT,
    species_id INT,
    breed_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (breed_id),
    FOREIGN KEY (species_id) REFERENCES species(species_id),
    UNIQUE KEY (species_id, breed_name)
);

-- Tabla Animales
CREATE OR REPLACE TABLE animals (
    animal_id INT AUTO_INCREMENT,
    breed_id INT,
    chip VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    PRIMARY KEY (animal_id),
    FOREIGN KEY (breed_id) REFERENCES breeds(breed_id),
    UNIQUE KEY (chip)
);

-- Tabla personas
CREATE OR REPLACE TABLE people (
    person_id INT AUTO_INCREMENT,
    name VARCHAR(255),
    address VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (person_id),
    UNIQUE KEY (email)
);

-- Tabla ingresos
CREATE OR REPLACE TABLE admissions (
    admission_id INT AUTO_INCREMENT,
    person_id INT,
    animal_id INT,
    delivery_datetime DATETIME NOT NULL,
    PRIMARY KEY (admission_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id),
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id),
    UNIQUE KEY (animal_id)
);

-- Tabla entregas
CREATE OR REPLACE TABLE deliveries (
    admission_id INT,
    PRIMARY KEY (admission_id),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

-- Tabla abandonos
CREATE OR REPLACE TABLE abandonments (
    admission_id INT,
    abandonment_datetime DATETIME NOT NULL, -- RN-02
    place VARCHAR(255) NOT NULL,           -- RN-02
    PRIMARY KEY (admission_id),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

-- Tabla adopciones
CREATE OR REPLACE TABLE adoptions (
    adoption_id INT AUTO_INCREMENT,
    person_id INT,
    animal_id INT,
    adoption_datetime DATETIME,
    PRIMARY KEY (adoption_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id),
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id),
    CONSTRAINT uq_adoptions_animal UNIQUE (animal_id)
    -- UNIQUE KEY (person_id, MONTH(adoption_datetime)) Esto no se puede hacer
    -- cuando se crea la tabla, hay que hacerlo con triggers y  procedures
);