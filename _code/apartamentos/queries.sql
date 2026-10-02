--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Consultas SQL correspondientes al álgebra relacional de Apartamentos
--

USE ApartamentosDB;

-- APZ: alojamientos con sus propietarios y zonas
CREATE OR REPLACE VIEW v_accommodations_owners_areas AS
SELECT a.accommodation_id, a.owner_id, a.area_id, a.address,
       a.bedrooms, a.bathrooms, a.max_occupancy,
       p.purchase_date, z.area_name
FROM accommodations a
JOIN users p ON p.user_id = a.owner_id
JOIN tourist_areas z ON z.area_id = a.area_id
WHERE p.is_owner = TRUE;

SELECT * FROM v_accommodations_owners_areas;

-- AF: alojamientos con fotos
CREATE OR REPLACE VIEW v_accommodations_photos AS
SELECT a.accommodation_id, a.owner_id, a.area_id, a.address,
       a.bedrooms, a.bathrooms, a.max_occupancy,
       f.photo_id, f.title, f.photo_url
FROM accommodations a
JOIN photos f ON f.accommodation_id = a.accommodation_id;

SELECT * FROM v_accommodations_photos;

-- AS: alojamientos con servicios
CREATE OR REPLACE VIEW v_accommodations_services AS
SELECT a.accommodation_id, a.owner_id, a.area_id, a.address,
       a.bedrooms, a.bathrooms, a.max_occupancy,
       sv.service_id, sv.service_type, sv.available
FROM accommodations a
JOIN services sv ON sv.accommodation_id = a.accommodation_id;

SELECT * FROM v_accommodations_services;

-- AR: alojamientos con reservas
CREATE OR REPLACE VIEW v_accommodations_reservations AS
SELECT a.accommodation_id, a.owner_id, a.area_id, a.address,
       a.bedrooms, a.bathrooms, a.max_occupancy,
       r.reservation_id, r.guest_id, r.check_in, r.check_out,
       r.comment, r.rating
FROM accommodations a
JOIN reservations r ON r.accommodation_id = a.accommodation_id;

SELECT * FROM v_accommodations_reservations;

-- APZFRS: alojamientos con propietarios, zona, fotos, servicios y reservas
SELECT a.accommodation_id, a.owner_id, a.area_id, a.address,
       a.bedrooms, a.bathrooms, a.max_occupancy,
       a.purchase_date, a.area_name,
       f.photo_id, f.title, f.photo_url,
       s.service_id, s.service_type, s.available,
       r.reservation_id, r.guest_id, r.check_in, r.check_out,
       r.comment, r.rating
FROM v_accommodations_owners_areas a
JOIN photos f ON f.accommodation_id = a.accommodation_id
JOIN services s ON s.accommodation_id = a.accommodation_id
JOIN reservations r ON r.accommodation_id = a.accommodation_id;

-- APiscina: alojamientos con piscina disponible
SELECT a.accommodation_id, a.owner_id, a.area_id, a.address,
       a.bedrooms, a.bathrooms, a.max_occupancy,
       a.service_id, a.service_type, a.available
FROM v_accommodations_services a
WHERE a.service_type = 'Piscina'
  AND a.available = TRUE;

-- ReservasCS: alojamientos reservados en la Costa del Sol
SELECT DISTINCT a.accommodation_id
FROM v_accommodations_reservations a
JOIN tourist_areas z ON z.area_id = a.area_id
WHERE z.area_name = 'Costa del Sol';

-- AlojamientosWifi: Dormitorios y baños de alojamientos con Wifi
SELECT DISTINCT bedrooms, bathrooms
FROM v_accommodations_services
WHERE service_type = 'Wifi'
  AND available = TRUE;

-- PropietariosPlaya: Propietarios con alojamientos en la zona Playa
SELECT DISTINCT p.first_name
FROM accommodations a
JOIN users p ON p.user_id = a.owner_id
JOIN tourist_areas z ON z.area_id = a.area_id
WHERE p.is_owner = TRUE
  AND z.area_name = 'Playa';

-- ValoracionMediaAlojamiento: Valoración media por alojamiento
SELECT accommodation_id, AVG(rating) AS media
FROM v_accommodations_reservations
GROUP BY accommodation_id;

-- NumServiciosAlojamiento: Número de servicios por alojamiento
SELECT accommodation_id, COUNT(*) AS total
FROM v_accommodations_services
GROUP BY accommodation_id;

-- NumFotosAlojamiento: Número de fotos por alojamiento
SELECT accommodation_id, COUNT(*) AS total
FROM v_accommodations_photos
GROUP BY accommodation_id;

-- NumReservasHuesped: Número de reservas por huésped
SELECT guest_id, COUNT(*) AS total
FROM v_accommodations_reservations
GROUP BY guest_id;

-- Consultas adicionales

-- Propietarios con alojamientos en Sierra Nevada
SELECT DISTINCT p.first_name, p.last_name
FROM v_accommodations_owners_areas a
JOIN users p ON p.user_id = a.owner_id
WHERE a.area_name = 'Sierra Nevada';

-- alojamientos con valoraciones mayores o iguales a 4
SELECT a.*
FROM accommodations a
JOIN v_accommodations_reservations r ON r.accommodation_id = a.accommodation_id
WHERE r.rating >= 4;

-- Valoración promedio de todos los alojamientos
SELECT AVG(rating) AS average_rating
FROM v_accommodations_reservations;

-- Número de alojamientos por zona turística
SELECT area_id, COUNT(*) AS accommodation_count
FROM v_accommodations_owners_areas
GROUP BY area_id;

-- Fecha de compra más antigua entre los propietarios
SELECT MIN(purchase_date) AS earliest_purchase_date
FROM users
WHERE is_owner = TRUE;
