-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Script para crear la BD del ejercicio de Usuarios
-- 

DROP DATABASE IF EXISTS UsersDB;
CREATE DATABASE UsersDB;
USE UsersDB;

-- =========================================================================
-- Eliminamos tablas previas
-- =========================================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================================
-- Tabla: users
-- =========================================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    full_name VARCHAR(120) NOT NULL,
    gender ENUM('MASCULINO','FEMENINO','OTRO') NOT NULL,
    age TINYINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id),
    CONSTRAINT rn01_users_adult_age CHECK (age >= 18),
    CONSTRAINT rn02_users_unique_email UNIQUE (email)
);
