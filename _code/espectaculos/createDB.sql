--
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: script para crear el esquema de la BD
--

DROP DATABASE IF EXISTS	EspectaculosDB;
CREATE DATABASE EspectaculosDB;
USE EspectaculosDB;

-- Crear la tabla TiposEspectáculos
CREATE OR REPLACE TABLE show_types (
    show_type_id INT AUTO_INCREMENT,
    type_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (show_type_id)
);

-- Crear la tabla zonas
CREATE OR REPLACE TABLE areas (
    area_id INT AUTO_INCREMENT,
    area_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (area_id)
);

-- Crear la tabla precios
CREATE OR REPLACE TABLE prices (
    price_id INT AUTO_INCREMENT,
    area_id INT,
    show_type_id INT,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (price_id),
    FOREIGN KEY (area_id) REFERENCES areas(area_id),
    FOREIGN KEY (show_type_id) REFERENCES show_types(show_type_id),
    UNIQUE(area_id, show_type_id),
    CONSTRAINT ck_prices_nonnegative CHECK (price >= 0)
);

-- Crear la tabla localidades
CREATE OR REPLACE TABLE seats (
    seat_id INT AUTO_INCREMENT,
    area_id INT,
    seat_row INT,
    seat_number INT,
    PRIMARY KEY (seat_id),
    FOREIGN KEY (area_id) REFERENCES areas(area_id),
    UNIQUE (area_id, seat_row, seat_number)
);

-- Crear la tabla Espectáculos
CREATE OR REPLACE TABLE shows (
    show_id INT AUTO_INCREMENT,
    show_type_id INT,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    duration TIME,
    PRIMARY KEY (show_id),
    FOREIGN KEY (show_type_id) REFERENCES show_types(show_type_id)
);

-- Crear la tabla representaciones
CREATE OR REPLACE TABLE performances (
    performance_id INT AUTO_INCREMENT,
    show_id INT,
    start_datetime DATETIME NOT NULL,
    PRIMARY KEY (performance_id),
    FOREIGN KEY (show_id) REFERENCES shows(show_id),
    UNIQUE (show_id, start_datetime)
);

-- Crear la tabla entradas
CREATE OR REPLACE TABLE tickets (
    ticket_id INT AUTO_INCREMENT,
    performance_id INT,
    seat_id INT,
    purchase_datetime DATETIME,
    channel VARCHAR(255),
    purchase_price DECIMAL(10, 2),
    PRIMARY KEY (ticket_id),
    FOREIGN KEY (performance_id) REFERENCES performances(performance_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id),
    UNIQUE (performance_id, seat_id),
    CONSTRAINT rn02_tickets_invitation CHECK (
        (channel = 'Invitación' AND purchase_price = 0)
        OR (channel IN ('Web', 'Taquilla') AND purchase_price >= 0)
    )
);