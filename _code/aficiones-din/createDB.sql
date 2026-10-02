-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Script para crear la BD de Aficiones Dinámicas
-- 

DROP DATABASE IF EXISTS HobbiesDynamicDB;
CREATE DATABASE HobbiesDynamicDB;
USE HobbiesDynamicDB;

-- =============================================================
-- Eliminamos tablas previas
-- =============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS user_hobby_links;
DROP TABLE IF EXISTS hobbies;
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
-- Tabla: hobbies
-- =============================================================
CREATE TABLE hobbies (
    hobby_id INT AUTO_INCREMENT,
    hobby_name VARCHAR(128) NOT NULL,
    PRIMARY KEY (hobby_id)
);

-- =============================================================
-- Tabla: user_hobby_links
-- =============================================================
CREATE TABLE user_hobby_links (
    user_hobby_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    hobby_id INT NOT NULL,
    PRIMARY KEY (user_hobby_id),
    CONSTRAINT fk_user_hobby_links_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_user_hobby_links_hobby FOREIGN KEY (hobby_id) REFERENCES hobbies(hobby_id),
    CONSTRAINT rn03_user_hobby_unique UNIQUE (user_id, hobby_id)
);
