-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Script para crear la BD de Bodegas
-- 

DROP DATABASE IF EXISTS BodegasDB;
CREATE DATABASE BodegasDB;
USE BodegasDB;

-- =============================================================
-- Eliminamos tablas previas (orden inverso de dependencias)
-- =============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS wine_grapes;
DROP TABLE IF EXISTS harvests;
DROP TABLE IF EXISTS young_wines;
DROP TABLE IF EXISTS aged_wines;
DROP TABLE IF EXISTS wines;
DROP TABLE IF EXISTS grapes;
DROP TABLE IF EXISTS wineries;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- Tabla: wineries
-- =============================================================
CREATE TABLE wineries (
    winery_id INT AUTO_INCREMENT,
    winery_name VARCHAR(255) NOT NULL,
    origin_designation VARCHAR(255) NOT NULL,
    PRIMARY KEY (winery_id),
    CONSTRAINT rn01_wineries_unique_name UNIQUE (winery_name)
);

-- =============================================================
-- Tabla: wines
-- =============================================================
CREATE TABLE wines (
    wine_id INT AUTO_INCREMENT,
    winery_id INT NOT NULL,
    wine_name VARCHAR(255) NOT NULL,
    alcohol_percent DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (wine_id),
    FOREIGN KEY (winery_id) REFERENCES wineries(winery_id),
    CONSTRAINT rn01_wines_unique_name UNIQUE (wine_name),
    CONSTRAINT rn03_wines_alcohol_range CHECK (alcohol_percent BETWEEN 10 AND 15)
);

-- =============================================================
-- Tabla: young_wines
-- =============================================================
CREATE TABLE young_wines (
    wine_id INT,
    barrel_months TINYINT NOT NULL,
    bottle_months TINYINT NOT NULL,
    PRIMARY KEY (wine_id),
    FOREIGN KEY (wine_id) REFERENCES wines(wine_id),
    CONSTRAINT rn02_young_wines_age CHECK (
        barrel_months <= 6 AND barrel_months + bottle_months <= 12
    )
);

-- =============================================================
-- Tabla: aged_wines
-- =============================================================
CREATE TABLE aged_wines (
    wine_id INT,
    barrel_months TINYINT NOT NULL,
    bottle_months TINYINT NOT NULL,
    PRIMARY KEY (wine_id),
    FOREIGN KEY (wine_id) REFERENCES wines(wine_id),
    CONSTRAINT rn02_aged_wines_age CHECK (
        barrel_months >= 6 AND barrel_months + bottle_months >= 24
    )
);

-- =============================================================
-- Tabla: grapes
-- =============================================================
CREATE TABLE grapes (
    grape_id INT AUTO_INCREMENT,
    grape_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (grape_id),
    CONSTRAINT rn01_grapes_unique_name UNIQUE (grape_name)
);

-- =============================================================
-- Tabla: harvests
-- =============================================================
CREATE TABLE harvests (
    harvest_id INT AUTO_INCREMENT,
    wine_id INT NOT NULL,
    harvest_year YEAR NOT NULL,
    quality VARCHAR(100) NOT NULL,
    PRIMARY KEY (harvest_id),
    FOREIGN KEY (wine_id) REFERENCES wines(wine_id) ON DELETE CASCADE,
    CONSTRAINT rn04_harvests_unique_year UNIQUE (wine_id, harvest_year)
);

-- =============================================================
-- Tabla: wine_grapes
-- =============================================================
CREATE TABLE wine_grapes (
    wine_id INT,
    grape_id INT,
    PRIMARY KEY (wine_id, grape_id),
    CONSTRAINT fk_wine_grapes_wine FOREIGN KEY (wine_id) REFERENCES wines(wine_id),
    CONSTRAINT fk_wine_grapes_grape FOREIGN KEY (grape_id) REFERENCES grapes(grape_id)
);
