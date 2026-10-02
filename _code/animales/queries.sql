--
-- Autor: David Ruiz
-- Fecha: Septiembre 2026
-- Descripción: Consultas SQL correspondientes al álgebra relacional de Animales
--

USE AnimalesDB;

-- PerAdoAni: personas que adoptan animales
CREATE OR REPLACE VIEW v_people_adoptions_animals AS
SELECT p.person_id AS pid, p.name AS pn, p.address AS dir, p.email,
       ad.adoption_id AS adid, ad.animal_id AS aid,
       ad.adoption_datetime AS fha,
       a.breed_id AS rid, a.chip, a.name AS an, a.description AS `desc`
FROM people p
JOIN adoptions ad ON ad.person_id = p.person_id
JOIN animals a ON a.animal_id = ad.animal_id;

SELECT * FROM v_people_adoptions_animals;

-- PerEntAni: personas que entregan animales
CREATE OR REPLACE VIEW v_people_admissions_animals AS
SELECT p.person_id AS pid, p.name AS pn, p.address AS dir, p.email,
       i.admission_id AS iid, i.animal_id AS aid, i.delivery_datetime AS fhe,
       a.breed_id AS rid, a.chip, a.name AS an, a.description AS `desc`
FROM people p
JOIN admissions i ON i.person_id = p.person_id
JOIN animals a ON a.animal_id = i.animal_id;

SELECT * FROM v_people_admissions_animals;

-- PerEntAniAba: personas que entregan animales abandonados
SELECT pe.pid, pe.pn, pe.dir, pe.email, pe.iid, pe.aid, pe.fhe,
       ab.abandonment_datetime AS fhab, ab.place,
       pe.rid, pe.chip, pe.an, pe.`desc`
FROM v_people_admissions_animals pe
JOIN abandonments ab ON ab.admission_id = pe.iid;

-- AdopcionesOctubre: adopciones realizadas en octubre
SELECT *
FROM v_people_adoptions_animals
WHERE MONTH(fha) = 10;

-- AdopcionesPorEspecie: Número de adopciones por especie
SELECT e.species_id, e.species_name, COUNT(*) AS total
FROM v_people_adoptions_animals pa
JOIN breeds r ON r.breed_id = pa.rid
JOIN species e ON e.species_id = r.species_id
GROUP BY e.species_id, e.species_name;
