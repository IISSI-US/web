--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Procedimiento para poblar la BD de espectáculos
--

USE EspectaculosDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    DELETE FROM tickets;
    DELETE FROM performances;
    DELETE FROM shows;
    DELETE FROM seats;
    DELETE FROM prices;
    DELETE FROM areas;
    DELETE FROM show_types;
    ALTER TABLE tickets AUTO_INCREMENT = 1;
    ALTER TABLE performances AUTO_INCREMENT = 1;
    ALTER TABLE shows AUTO_INCREMENT = 1;
    ALTER TABLE seats AUTO_INCREMENT = 1;
    ALTER TABLE prices AUTO_INCREMENT = 1;
    ALTER TABLE areas AUTO_INCREMENT = 1;
    ALTER TABLE show_types AUTO_INCREMENT = 1;
    SET FOREIGN_KEY_CHECKS = 1;

    INSERT INTO show_types (show_type_id, type_name) VALUES
        (1, 'Concierto')
    ;
    INSERT INTO areas (area_id, area_name) VALUES
        (1, 'Patio'),
        (2, 'Primera Balcón')
    ;
    INSERT INTO prices (price_id, area_id, show_type_id, price) VALUES
        (1, 1, 1, 50),
        (2, 2, 1, 100)
    ;
    INSERT INTO seats (seat_id, area_id, seat_row, seat_number) VALUES
        (1, 1, 5, 12),
        (2, 2, 1, 6)
    ;
    INSERT INTO shows (show_id, show_type_id, name, description, duration) VALUES
        (1, 1, 'Concierto de ACDC', 'Festival', '02:30:00')
    ;
    INSERT INTO performances (performance_id, show_id, start_datetime) VALUES
        (1, 1, '2024-10-15 20:00:00'),
        (2, 1, '2024-10-16 20:00:00')
    ;
    INSERT INTO tickets (ticket_id, performance_id, seat_id, purchase_datetime, channel, purchase_price) VALUES
        (1, 1, 1, '2024-10-10 18:00:00', 'Web', 50),
        (2, 2, 2, '2024-10-11 15:00:00', 'Invitación', 0)
    ;

    -- Insertar datos generados con IA:
    INSERT INTO show_types (type_name) VALUES
        ('Teatro'),
        ('Danza')
    ;
    INSERT INTO areas (area_name) VALUES
        ('Segunda Balcón'),
        ('Primera Terraza'),
        ('Segunda Terraza')
    ;
    INSERT INTO prices (area_id, show_type_id, price) VALUES
        (3, 2, 80),
        (4, 2, 60),
        (5, 2, 40),
        (3, 3, 120),
        (4, 3, 100),
        (5, 3, 80)
    ;
    -- Insertar 3 localidade de cada zona con numero de fila y butaca aleatorios:
    INSERT INTO seats (area_id, seat_row, seat_number) VALUES
        (3, 5, 12),
        (3, 6, 10),
        (3, 7, 8),
        (4, 1, 6),
        (4, 2, 4),
        (4, 3, 2),
        (5, 1, 6),
        (5, 2, 4),
        (5, 3, 2)
    ;

    -- Insertar 3 espectáculos de cada tipo:
    INSERT INTO shows (show_type_id, name, description, duration) VALUES
        (2, 'El lago de los cisnes', 'Ballet', '02:00:00'),
        (2, 'El cascanueces', 'Ballet', '02:30:00'),
        (2, 'La bella durmiente', 'Ballet', '02:30:00'),
        (3, 'La casa de Bernarda Alba', 'Drama', '02:00:00'),
        (3, 'La vida es sueño', 'Drama', '02:30:00'),
        (3, 'La casa de los espíritus', 'Drama', '02:30:00')
    ;
    -- Insertar 3 representaciones de cada espectaculo:
    INSERT INTO performances (show_id, start_datetime) VALUES
        (2, '2024-10-17 20:00:00'),
        (2, '2024-10-18 20:00:00'),
        (2, '2024-10-19 20:00:00'),
        (3, '2024-10-20 20:00:00'),
        (3, '2024-10-21 20:00:00'),
        (3, '2024-10-22 20:00:00')
    ;
    -- Insertar 3 entradas de cada representacion, si son de channel Invitación el price es 0:
    INSERT INTO tickets (performance_id, seat_id, purchase_datetime, channel, purchase_price) VALUES
        (3, 1, '2024-10-10 18:00:00', 'Web', 80),
        (3, 2, '2024-10-11 15:00:00', 'Invitación', 0),
        (3, 3, '2024-10-12 12:00:00', 'Taquilla', 80),
        (4, 2, '2024-10-10 18:00:00', 'Web', 60),
        (4, 3, '2024-10-11 15:00:00', 'Invitación', 0),
        (4, 4, '2024-10-12 12:00:00', 'Taquilla', 60),
        (5, 5, '2024-10-10 18:00:00', 'Web', 40),
        (5, 6, '2024-10-11 15:00:00', 'Invitación', 0),
        (5, 7, '2024-10-12 12:00:00', 'Taquilla', 40),
        (6, 8, '2024-10-10 18:00:00', 'Web', 120),
        (6, 1, '2024-10-11 15:00:00', 'Invitación', 0),
        (6, 2, '2024-10-12 12:00:00', 'Taquilla', 120),
        (7, 3, '2024-10-10 18:00:00', 'Web', 100),
        (7, 4, '2024-10-11 15:00:00', 'Invitación', 0),
        (7, 5, '2024-10-12 12:00:00', 'Taquilla', 100),
        (8, 4, '2024-10-10 18:00:00', 'Web', 80),
        (8, 5, '2024-10-11 15:00:00', 'Invitación', 0),
        (8, 6, '2024-10-12 12:00:00', 'Taquilla', 80)
    ;











END //
DELIMITER ;

CALL p_populate();
