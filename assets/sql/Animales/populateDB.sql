-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para poblar la BD del ejercicio de Animales
-- 

-- Insertar datos en la tabla Especies
INSERT INTO Especies (especieId, especie) VALUES
    (1, 'Canino'),
    (2, 'Felino');

-- Insertar datos en la tabla Razas
INSERT INTO Razas (razaId, especieId, raza) VALUES
    (1, 1, 'Labrador'),
    (2, 1, 'Pastor Alemán'),
    (3, 2, 'Siamesa');

-- Insertar datos en la tabla Animales
INSERT INTO Animales (animalId, razaId, chip, nombre, descripcion) VALUES
    (1, 1, '12345', 'Max', 'Perro color marrón'),
    (2, 1, '67890', 'Rocky', 'Perro negro'),
    (3, 2, '54321', 'Luna', 'Gato gris');

-- Insertar datos en la tabla Personas
INSERT INTO Personas (personaId, nombre, direccion, email) VALUES
    (1, 'Carlos García', 'Calle False 123', 'carlosgarcia@example.com'),
    (2, 'Laura Martínez', 'Avenida Siempre Viva 456', 'lauramartinez@example.com');

-- Insertar datos en la tabla Ingresos
INSERT INTO Ingresos (ingresoId, personaId, animalId, fechaHoraEntrega) VALUES
    (1, 1, 2, '2024-09-30 15:00:00'),
    (2, 1, 1, '2024-07-30 15:00:00');

-- Insertar datos en la tabla Entregas
INSERT INTO Entregas (ingresoId) VALUES
    (1);

-- Insertar datos en la tabla Abandonos
INSERT INTO Abandonos (ingresoId, fechaHoraAbandono, lugar) VALUES
    (2, '2024-07-30 14:30:00', 'Parque Central');

-- Insertar datos en la tabla Adopciones
INSERT INTO Adopciones (ingresoId, personaId, animalId, fechaHoraAdopcion) VALUES
    (1, 2, 3, '2024-10-05 00:00:00'),
    (2, 2, 1, '2024-10-10 00:00:00');

-- Datos adicionales
-- Insertar dos razas de perros y otra de gatos
INSERT INTO Razas (razaId, especieId, raza) VALUES
    (4, 1, 'Bulldog'),
    (5, 1, 'Dálmata'),
    (6, 2, 'Persa');

-- Insertar 2 bulldogs, 1 dálmata y 1 persa:
INSERT INTO Animales (animalId, razaId, chip, nombre, descripcion) VALUES
    (4, 4, '11111', 'Rex', 'Perro blanco'),
    (5, 4, '22222', 'Bobby', 'Perro marrón'),
    (6, 5, '33333', 'Pongo', 'Perro blanco con manchas negras'),
    (7, 6, '44444', 'Misi', 'Gato blanco');

-- Insertar 2 personas más:
INSERT INTO Personas (personaId, nombre, direccion, email) VALUES
    (3, 'Ana López', 'Calle Falsa 456', 'alopez@mail.com'),
    (4, 'Juan Pérez', 'Avenida Siempre Viva 789', 'jperez@mail.com');

-- Insertar un ingreso para los 5 animales con fechas y horas distintas:
INSERT INTO Ingresos (ingresoId, personaId, animalId, fechaHoraEntrega) VALUES
    (3, 3, 4, '2024-10-15 15:00:00'),
    (4, 3, 5, '2024-10-15 15:30:00'),
    (5, 3, 6, '2024-10-15 16:00:00'),
    (6, 4, 7, '2024-10-15 16:30:00');

INSERT INTO Entregas (ingresoId) VALUES
    (4),
    (6);

INSERT INTO Abandonos (ingresoId, fechaHoraAbandono, lugar) VALUES
    (3, '2024-07-30 14:30:00', 'Parque Norte'),
    (5, '2024-07-30 14:30:00', 'Parque Sur');

INSERT INTO Adopciones (ingresoId, personaId, animalId, fechaHoraAdopcion) VALUES
    (3, 3, 4, '2024-10-05 00:00:00'),
    (4, 3, 5, '2024-10-10 00:00:00'),
    (5, 3, 6, '2024-10-15 00:00:00'),
    (6, 4, 7, '2024-10-20 00:00:00');

