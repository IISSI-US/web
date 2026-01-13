SELECT 'TEACHER: lectura notas' AS escenario, COUNT(*) AS total_notas FROM grades;
START TRANSACTION;
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6,1,6.5,'Primera',0);
ROLLBACK;
SELECT 'TEACHER: escritura en grades revertida' AS escenario;

INSERT INTO people (dni, first_name, last_name, age, email)
VALUES ('99999999Z','Teacher','Bloqueado',30,'bloqueado@us.es');