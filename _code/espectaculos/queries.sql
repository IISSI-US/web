--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Consultas SQL correspondientes al álgebra relacional de Espectáculos
--

USE EspectaculosDB;

-- PZT: precios por zona y tipo de espectáculo
CREATE OR REPLACE VIEW v_prices_areas_types AS
SELECT p.price_id, p.area_id, p.show_type_id, p.price,
       z.area_name, te.type_name
FROM prices p
JOIN areas z ON z.area_id = p.area_id
JOIN show_types te
  ON te.show_type_id = p.show_type_id;

SELECT * FROM v_prices_areas_types;

-- PZTRL: localidades por zona y tipo de espectáculo
SELECT p.*, l.seat_id, l.seat_row, l.seat_number
FROM v_prices_areas_types p
JOIN seats l ON l.area_id = p.area_id;

-- numER: Número de entradas por representación
SELECT r.performance_id, COUNT(*) AS total
FROM tickets e
JOIN performances r ON r.performance_id = e.performance_id
GROUP BY r.performance_id;

-- RE: representaciones con sus espectáculos
CREATE OR REPLACE VIEW v_performances_shows AS
SELECT r.performance_id, r.show_id, r.start_datetime,
       e.show_type_id, e.name, e.description, e.duration
FROM performances r
JOIN shows e ON e.show_id = r.show_id;

SELECT * FROM v_performances_shows;

-- numRE: Número de representaciones por espectáculo
SELECT show_id, COUNT(*) AS total
FROM v_performances_shows
GROUP BY show_id;

-- Recaudaciones: Recaudación por representación
SELECT performance_id, SUM(purchase_price) AS revenue
FROM tickets
GROUP BY performance_id;

-- LocR1: localidades vendidas en la representación 1
SELECT performance_id, COUNT(seat_id) AS total
FROM tickets
WHERE performance_id = 1
GROUP BY performance_id;

-- EntradasInvitacion: entradas por invitación
SELECT r.*, en.ticket_id, en.seat_id,
       en.purchase_datetime, en.channel, en.purchase_price
FROM v_performances_shows r
JOIN tickets en ON en.performance_id = r.performance_id
WHERE en.channel = 'Invitación';

-- Consultas adicionales

-- localidades disponibles por zona
SELECT z.area_id, l.seat_id, z.area_name, l.seat_row, l.seat_number
FROM seats l
JOIN areas z ON z.area_id = l.area_id;

-- Número de localidades vendidas para la representación 3
SELECT COUNT(*) AS total
FROM tickets
WHERE performance_id = 3;

-- entradas por invitación agrupadas por espectáculo
SELECT r.show_id, COUNT(*) AS total
FROM v_performances_shows r
JOIN tickets en ON en.performance_id = r.performance_id
WHERE en.channel = 'Invitación'
GROUP BY r.show_id;
