-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: script para crear el esquema de la BD
-- 

DROP DATABASE IF EXISTS	EspectaculosDB;
CREATE DATABASE EspectaculosDB;
USE EspectaculosDB;

-- Crear la tabla TiposEspectáculos
CREATE OR REPLACE TABLE TiposEspectaculos (
    tipoEspectaculoId INT AUTO_INCREMENT,
    tipo VARCHAR(255) NOT NULL,
    PRIMARY KEY (tipoEspectaculoId)
);

-- Crear la tabla Zonas
CREATE OR REPLACE TABLE Zonas (
    zonaId INT AUTO_INCREMENT,
    nombreZona VARCHAR(255) NOT NULL,
    PRIMARY KEY (zonaId)
);

-- Crear la tabla Precios
CREATE OR REPLACE TABLE Precios (
    precioId INT AUTO_INCREMENT,
    zonaId INT,
    tipoEspectaculoId INT,
    precio DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (precioId),
    FOREIGN KEY (zonaId) REFERENCES Zonas(zonaId),
    FOREIGN KEY (tipoEspectaculoId) REFERENCES TiposEspectaculos(tipoEspectaculoId),
    UNIQUE(zonaId, tipoEspectaculoId)
);

-- Crear la tabla Localidades
CREATE OR REPLACE TABLE Localidades (
    localidadId INT AUTO_INCREMENT,
    zonaId INT,
    numFila INT,
    numButaca INT,
    PRIMARY KEY (localidadId),
    FOREIGN KEY (zonaId) REFERENCES Zonas(zonaId),
    UNIQUE (zonaId, numFila, numButaca)
);

-- Crear la tabla Espectáculos
CREATE OR REPLACE TABLE Espectaculos (
    espectaculoId INT AUTO_INCREMENT,
    tipoEspectaculoId INT,
    nombre VARCHAR(255) NOT NULL,
    denominacion VARCHAR(255),
    duracion TIME,
    PRIMARY KEY (espectaculoId),
    FOREIGN KEY (tipoEspectaculoId) REFERENCES TiposEspectaculos(tipoEspectaculoId)
);

-- Crear la tabla Representaciones
CREATE OR REPLACE TABLE Representaciones (
    representacionId INT AUTO_INCREMENT,
    espectaculoId INT,
    fechaHoraInicio DATETIME NOT NULL,
    PRIMARY KEY (representacionId),
    FOREIGN KEY (espectaculoId) REFERENCES Espectaculos(espectaculoId),
    UNIQUE (espectaculoId, fechaHoraInicio)
);

-- Crear la tabla Entradas
CREATE OR REPLACE TABLE Entradas (
    entradaId INT AUTO_INCREMENT,
    representacionId INT,
    localidadId INT,
    fHoraCompra DATETIME,
    canal VARCHAR(255),
    pCompra DECIMAL(10, 2),
    PRIMARY KEY (entradaId),
    FOREIGN KEY (representacionId) REFERENCES Representaciones(representacionId),
    FOREIGN KEY (localidadId) REFERENCES Localidades(localidadId),
    UNIQUE (representacionId, localidadId)
);