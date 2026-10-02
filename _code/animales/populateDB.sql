--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Procedimiento para poblar la BD de Animales
--

USE AnimalesDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    DELETE FROM adoptions;
    DELETE FROM abandonments;
    DELETE FROM deliveries;
    DELETE FROM admissions;
    DELETE FROM people;
    DELETE FROM animals;
    DELETE FROM breeds;
    DELETE FROM species;
    SET FOREIGN_KEY_CHECKS = 1;

    INSERT INTO species (species_id, species_name) VALUES
        (1, 'Canino'),
        (2, 'Felino');

    -- Insertar datos en la tabla razas
    INSERT INTO breeds (breed_id, species_id, breed_name) VALUES
        (1, 1, 'Labrador'),
        (2, 1, 'Pastor Alemán'),
        (3, 2, 'Siamesa');

    -- Insertar datos en la tabla Animales
    INSERT INTO animals (animal_id, breed_id, chip, name, description) VALUES
        (1, 1, '12345', 'Max', 'Perro color marrón'),
        (2, 1, '67890', 'Rocky', 'Perro negro'),
        (3, 2, '54321', 'Luna', 'Gato gris');

    -- Insertar datos en la tabla personas
    INSERT INTO people (person_id, name, address, email) VALUES
        (1, 'Carlos García', 'Calle False 123', 'carlosgarcia@example.com'),
        (2, 'Laura Martínez', 'Avenida Siempre Viva 456', 'lauramartinez@example.com');

    -- Insertar datos en la tabla ingresos
    INSERT INTO admissions (admission_id, person_id, animal_id, delivery_datetime) VALUES
        (1, 1, 2, '2024-09-30 15:00:00'),
        (2, 1, 1, '2024-07-30 15:00:00');

    -- Insertar datos en la tabla entregas
    INSERT INTO deliveries (admission_id) VALUES
        (1);

    -- Insertar datos en la tabla abandonos
    INSERT INTO abandonments (admission_id, abandonment_datetime, place) VALUES
        (2, '2024-07-30 14:30:00', 'Parque Central');

    -- Insertar datos en la tabla adopciones
    INSERT INTO adoptions (adoption_id, person_id, animal_id, adoption_datetime) VALUES
        (1, 2, 3, '2024-10-05 00:00:00'),
        (2, 2, 1, '2024-10-10 00:00:00');

    -- Datos adicionales
    -- Insertar dos razas de perros y otra de gatos
    INSERT INTO breeds (breed_id, species_id, breed_name) VALUES
        (4, 1, 'Bulldog'),
        (5, 1, 'Dálmata'),
        (6, 2, 'Persa');

    -- Insertar 2 bulldogs, 1 dálmata y 1 persa:
    INSERT INTO animals (animal_id, breed_id, chip, name, description) VALUES
        (4, 4, '11111', 'Rex', 'Perro blanco'),
        (5, 4, '22222', 'Bobby', 'Perro marrón'),
        (6, 5, '33333', 'Pongo', 'Perro blanco con manchas negras'),
        (7, 6, '44444', 'Misi', 'Gato blanco');

    -- Insertar 2 personas más:
    INSERT INTO people (person_id, name, address, email) VALUES
        (3, 'Ana López', 'Calle Falsa 456', 'alopez@mail.com'),
        (4, 'Juan Pérez', 'Avenida Siempre Viva 789', 'jperez@mail.com');

    -- Insertar un ingreso para los 5 animales con fechas y horas distintas:
    INSERT INTO admissions (admission_id, person_id, animal_id, delivery_datetime) VALUES
        (3, 3, 4, '2024-10-15 15:00:00'),
        (4, 3, 5, '2024-10-15 15:30:00'),
        (5, 3, 6, '2024-10-15 16:00:00'),
        (6, 4, 7, '2024-10-15 16:30:00');

    INSERT INTO deliveries (admission_id) VALUES
        (4),
        (6);

    INSERT INTO abandonments (admission_id, abandonment_datetime, place) VALUES
        (3, '2024-07-30 14:30:00', 'Parque Norte'),
        (5, '2024-07-30 14:30:00', 'Parque Sur');

    INSERT INTO adoptions (adoption_id, person_id, animal_id, adoption_datetime) VALUES
        (3, 3, 4, '2024-10-05 00:00:00'),
        (4, 3, 5, '2024-10-10 00:00:00'),
        (5, 3, 6, '2024-10-15 00:00:00'),
        (6, 4, 7, '2024-10-20 00:00:00');


END //
DELIMITER ;

CALL p_populate();
