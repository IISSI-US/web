-- Todas las asignaturas
SELECT *
    FROM Subjects;

-- Asignatura con acrónimo ‘FP’.
SELECT *
    FROM Subjects
    WHERE acronym='FP';

-- Nombres y acrónimos de todas las asignaturas
SELECT name, acronym
    FROM Subjects;

-- Media de las notas del grupo con ID 18.
SELECT AVG(VALUE)
    FROM Grades
    WHERE groupId=18;       

-- Total de créditos de las asignaturas del grado de Tecnologías Informáticas (ID 3).
SELECT SUM(credits)
    FROM Subjects
    WHERE degreeId=3;

-- Notas con valor menor que 4 o mayor que 6.
SELECT *
    FROM Grades
    WHERE value <4 OR value >6;

-- Nombres de grupos diferentes
SELECT DISTINCT NAME
    FROM Groups;

-- Máxima nota del alumno con ID 1
SELECT MAX(VALUE)
    FROM Grades
    WHERE studentId=1;

-- Alumnos con un apellido igual al acrónimo de alguna asignatura
SELECT *
    FROM Students
    WHERE surname IN (SELECT acronym FROM Subjects);

-- IDs de alumnos del curso 2019.
SELECT DISTINCT(StudentId)
    FROM GroupsStudents
    WHERE groupId IN (SELECT groupId FROM Groups WHERE year = 2019);   

-- Alumnos con un DNI terminado en la letra C. Observe cómo % representa cualquier cantidad de caracteres. 
SELECT *
    FROM Students
    WHERE dni LIKE(' %C');

-- Alumnos con un nombre de 6 letras. Observe cómo _ representa un caracter cualquiera.
SELECT *
    FROM Students
    WHERE firstName LIKE('______'); -- 6 guiones bajos

-- Alumnos nacidos antes de 1995
SELECT *
    FROM Students
    WHERE YEAR(birthdate) <1995;

-- Alumnos nacidos entre enero y febrero
SELECT *
    FROM Students
    WHERE (MONTH(birthdate) >= 1 AND MONTH(birthdate) <= 2);