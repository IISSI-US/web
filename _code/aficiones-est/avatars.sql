-- Script para agregar columna de avatar a la tabla users y actualizar con URLs de avatares
-- Autor: David Ruiz
-- Fecha: Noviembre 2025

USE HobbiesStaticDB;

-- Agregar columna avatar_url
ALTER TABLE users ADD COLUMN avatar_url VARCHAR(500);

-- Actualizar avatares para usuarios existentes
UPDATE users SET avatar_url =  'druiz.jpg' WHERE user_id = 1;
UPDATE users SET avatar_url =  'carevalo.jpg' WHERE user_id = 2;
UPDATE users SET avatar_url =  'mcruz.jpg' WHERE user_id = 3;              
UPDATE users SET avatar_url =  'inmahernandez.jpg' WHERE user_id = 4;
UPDATE users SET avatar_url =  'amarquez.jpg' WHERE user_id = 5;
UPDATE users SET avatar_url =  'dayala1.jpg' WHERE user_id = 6;
UPDATE users SET avatar_url =  'rsampedro.jpg' WHERE user_id = 7;
UPDATE users SET avatar_url =  'mlopez.jpg' WHERE user_id = 8;
UPDATE users SET avatar_url =  'druiz2.jpg' WHERE user_id = 9;
UPDATE users SET avatar_url =  'agomez.jpg' WHERE user_id = 10; 
UPDATE users SET avatar_url =  'emurillo.jpg' WHERE user_id = 11;
