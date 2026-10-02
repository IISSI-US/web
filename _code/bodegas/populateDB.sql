-- 
-- Autor: David Ruiz
-- Fecha: Noviembre 2024
-- Descripción: Procedimiento para poblar la BD de Bodegas
-- 
USE BodegasDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    DELETE FROM wine_grapes;
    DELETE FROM harvests;
    DELETE FROM young_wines;
    DELETE FROM aged_wines;
    DELETE FROM wines;
    DELETE FROM grapes;
    DELETE FROM wineries;
    SET FOREIGN_KEY_CHECKS = 1;

    INSERT INTO wineries (winery_id, winery_name, origin_designation) VALUES
        (1, 'Bodegas El Sol', 'Rioja'),
        (2, 'Bodegas La Luna', 'Ribera del Duero');

    INSERT INTO wines (wine_id, winery_id, wine_name, alcohol_percent) VALUES
        (1, 1, 'Vino Blanco Joven', 12.0),
        (2, 2, 'Vino Tinto Joven', 13.0),
        (3, 1, 'Vino Crianza Especial', 14.0),
        (4, 2, 'Vino Crianza Reserva', 13.5);

    INSERT INTO young_wines (wine_id, barrel_months, bottle_months) VALUES
        (1, 0, 6),
        (2, 0, 12);

    INSERT INTO aged_wines (wine_id, barrel_months, bottle_months) VALUES
        (3, 6, 18),
        (4, 12, 12);

    INSERT INTO grapes (grape_id, grape_name) VALUES
        (1, 'Tempranillo'),
        (2, 'Garnacha'),
        (3, 'Albarino');

    INSERT INTO harvests (harvest_id, wine_id, harvest_year, quality) VALUES
        (1, 3, 2020, 'Excelente'),
        (2, 3, 2019, 'Buena'),
        (3, 4, 2018, 'Muy buena');

    INSERT INTO wine_grapes (wine_id, grape_id) VALUES
        (1, 3),
        (2, 1),
        (3, 2),
        (3, 1),
        (4, 2),
        (4, 1);
END //
DELIMITER ;

CALL p_populate();
