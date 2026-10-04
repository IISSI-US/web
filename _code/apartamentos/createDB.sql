-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Apartamentos
-- 

DROP DATABASE IF EXISTS ApartamentosDB;
CREATE DATABASE ApartamentosDB;
USE ApartamentosDB;

-- Creación de tablas
CREATE OR REPLACE TABLE users (
    user_id INT PRIMARY KEY,
    national_id VARCHAR(20) UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    address VARCHAR(100),
    phone VARCHAR(20),
    purchase_date DATE,
    is_owner BOOLEAN,
    is_guest BOOLEAN
);

CREATE OR REPLACE TABLE tourist_areas (
    area_id INT PRIMARY KEY,
    area_name VARCHAR(100)
);

CREATE OR REPLACE TABLE accommodations (
    accommodation_id INT PRIMARY KEY,
    owner_id INT NOT NULL,
    area_id INT NOT NULL,
    address VARCHAR(100),
    bedrooms INT,
    bathrooms INT,
    max_occupancy INT,
    CONSTRAINT ck_accommodations_capacity CHECK (
        bedrooms > 0 AND bathrooms > 0 AND max_occupancy > 0
    ),
    FOREIGN KEY (owner_id) REFERENCES users(user_id),
    FOREIGN KEY (area_id) REFERENCES tourist_areas(area_id)
);

CREATE OR REPLACE TABLE reservations (
    reservation_id INT PRIMARY KEY,
    guest_id INT NOT NULL,
    accommodation_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    comment TEXT,
    rating INT,
    CONSTRAINT rn01_reservations_dates CHECK (check_in < check_out),
    CONSTRAINT rn02_reservations_rating CHECK (
        rating IS NULL OR rating BETWEEN 1 AND 5
    ),
    FOREIGN KEY (guest_id) REFERENCES users(user_id),
    FOREIGN KEY (accommodation_id) REFERENCES accommodations(accommodation_id)
);

CREATE OR REPLACE TABLE photos (
    photo_id INT PRIMARY KEY,
    accommodation_id INT,
    title VARCHAR(100),
    photo_url VARCHAR(255),
    FOREIGN KEY (accommodation_id) REFERENCES accommodations(accommodation_id)
);

CREATE OR REPLACE TABLE services (
    service_id INT PRIMARY KEY,
    accommodation_id INT,
    service_type ENUM('Wifi', 'Piscina', 'Garaje', 'AireAcondicionado'),
    available BOOLEAN,
    FOREIGN KEY (accommodation_id) REFERENCES accommodations(accommodation_id)
);
