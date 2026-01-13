-- El usuarios admin_grados tiene permisos de lectura y escritura

SELECT 'ADMIN: lectura people' AS escenario, COUNT(*) AS total_personas FROM people;
START TRANSACTION;
INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type)
VALUES (3, 'Admin Test', 'ADM', 6, 2, 'Obligatoria');
DELETE FROM subjects WHERE subject_name='Admin Test';
ROLLBACK;
SELECT 'ADMIN: escritura ok (rollback)' AS escenario;