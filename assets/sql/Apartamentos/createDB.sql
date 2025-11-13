-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Apartamentos
-- 

DROP DATABASE IF EXISTS ApartamentosDB;
CREATE DATABASE ApartamentosDB;
USE ApartamentosDB;

-- Creación de tablas
CREATE OR REPLACE TABLE Usuarios (
    usuarioId INT PRIMARY KEY,
    dni VARCHAR(20) UNIQUE,
    nombre VARCHAR(50),
    apellidos VARCHAR(50),
    correo VARCHAR(100) UNIQUE,
    contrasena VARCHAR(100),
    direccion VARCHAR(100),
    telefono VARCHAR(20),
    fCompra DATE,
    esPropietario BOOLEAN,
    esHuesped BOOLEAN
);

CREATE OR REPLACE TABLE ZonasTuristicas (
    zonaId INT PRIMARY KEY,
    zona VARCHAR(100)
);

CREATE OR REPLACE TABLE Alojamientos (
    alojamientoId INT PRIMARY KEY,
    propietarioId INT,
    zonaId INT,
    direccion VARCHAR(100),
    numDormitorios INT,
    numBaños INT,
    ocupacionMaxima INT,
    FOREIGN KEY (propietarioId) REFERENCES Usuarios(usuarioId),
    FOREIGN KEY (zonaId) REFERENCES ZonasTuristicas(zonaId)
);

CREATE OR REPLACE TABLE Reservas (
    reservaId INT PRIMARY KEY,
    huespedId INT,
    alojamientoId INT,
    checkIn DATE,
    checkOut DATE,
    comentario TEXT,
    valoracion INT,
    FOREIGN KEY (huespedId) REFERENCES Usuarios(usuarioId),
    FOREIGN KEY (alojamientoId) REFERENCES Alojamientos(alojamientoId)
);

CREATE OR REPLACE TABLE Fotos (
    fotoId INT PRIMARY KEY,
    alojamientoId INT,
    titulo VARCHAR(100),
    fotoURL VARCHAR(255),
    FOREIGN KEY (alojamientoId) REFERENCES Alojamientos(alojamientoId)
);

CREATE OR REPLACE TABLE Servicios (
    servicioId INT PRIMARY KEY,
    alojamientoId INT,
    tipoServicio ENUM('Wifi', 'Piscina', 'Garaje', 'AireAcondicionado'),
    disponible BOOLEAN,
    FOREIGN KEY (alojamientoId) REFERENCES Alojamientos(alojamientoId)
);
