-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Script para crear la BD de Aficiones estáticas
-- 

DROP DATABASE IF EXISTS HobbiesStaticDB;
CREATE DATABASE HobbiesStaticDB;
USE HobbiesStaticDB;

-- =============================================================
-- Eliminamos tablas previas
-- =============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS user_hobbies;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- Tabla: users
-- =============================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    full_name VARCHAR(64) NOT NULL,
    gender ENUM('MASCULINO','FEMENINO','OTRO') NOT NULL,
    age TINYINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id),
    CONSTRAINT rn01_users_adult_age CHECK (age >= 18),
    CONSTRAINT rn02_users_unique_email UNIQUE (email)
);

-- =============================================================
-- Tabla: user_hobbies
-- =============================================================
CREATE TABLE user_hobbies (
    hobby_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    hobby ENUM('LITERATURA','CINE','DEPORTE','GASTRONOMIA') NOT NULL,
    PRIMARY KEY (hobby_id),
    CONSTRAINT fk_user_hobbies_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT rn03_user_hobbies_unique UNIQUE (user_id, hobby)
);
