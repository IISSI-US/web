DELETE FROM Grades;
DELETE FROM GroupsStudents;
DELETE FROM Students;
DELETE FROM Groups;
DELETE FROM Subjects;
DELETE FROM Degrees;

INSERT INTO Degrees (degreeId, name, years) VALUES
	(1, 'Ingeniería del Software', 4),
	(2, 'Ingeniería del Computadores', 4),
	(3, 'Tecnologías Informáticas', 4);

INSERT INTO Subjects (subjectId, name, acronym, credits, year, type, degreeId) VALUES
	(1, 'Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1),
	(2, 'Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 1),
	(3, 'Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 1),
	(4, 'Ingeniería de Requisitos', 'IR', 6, 2, 'Obligatoria', 1),
	(5, 'Análisis y Diseño de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria', 1),
	(6, 'Introducción a la Matematica Discreta', 'IMD', 6, 1, 'Formacion Basica', 2),
	(7, 'Redes de Computadores', 'RC', 6, 2, 'Obligatoria', 2),
	(8, 'Teoría de Grafos', 'TG', 6, 3, 'Obligatoria', 2),
	(9, 'Aplicaciones de Soft Computing', 'ASC', 6, 4, 'Optativa', 2),
	(10, 'Fundamentos de Programación', 'FP', 12, 1, 'Formacion Basica', 3),
	(11, 'Lógica Informatica', 'LI', 6, 2, 'Optativa', 3),
	(12, 'Gestión y Estrategia Empresarial', 'GEE', 90, 3, 'Optativa', 3),
	(13, 'Trabajo de Fin de Grado', 'TFG', 12, 4, 'Obligatoria', 3);
	
INSERT INTO Groups (groupId, name, activity, year, subjectId) VALUES
	(1, 'T1', 'Teoria', 2018, 1),
	(2, 'T2', 'Teoria', 2018, 1),
	(3, 'L1', 'Laboratorio', 2018, 1),
	(4, 'L2', 'Laboratorio', 2018, 1),
	(5, 'L3', 'Laboratorio', 2018, 1),
	(6, 'T1', 'Teoria', 2019, 1),
	(7, 'T2', 'Teoria', 2019, 1),
	(8, 'L1', 'Laboratorio', 2019, 1),
	(9, 'L2', 'Laboratorio', 2019, 1),
	(10, 'Teor1', 'Teoria', 2018, 2),
	(11, 'Teor2', 'Teoria', 2018, 2),
	(12, 'Lab1', 'Laboratorio', 2018, 2),
	(13, 'Lab2', 'Laboratorio', 2018, 2),
	(14, 'Teor1', 'Teoria', 2019, 2),
	(15, 'Lab1', 'Laboratorio', 2019, 2),
	(16, 'Lab2', 'Laboratorio', 2019, 2),
	(17, 'T1', 'Teoria', 2019, 10),
	(18, 'T2', 'Teoria', 2019, 10),
	(19, 'T3', 'Teoria', 2019, 10),
	(20, 'L1', 'Laboratorio', 2019, 10),
	(21, 'L2', 'Laboratorio', 2019, 10),
	(22, 'L3', 'Laboratorio', 2019, 10),
	(23, 'L4', 'Laboratorio', 2019, 10),
	(24, 'Clase', 'Teoria', 2019, 12);
	
-- The passwords are securely hashed, they are the part of the email that goes before the @
-- e.g. the password for daniel@alum.us.es is daniel
INSERT INTO Students (studentId, accessMethod, dni, firstname, surname, birthdate, email) VALUES
	(1, 'Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 'daniel@alum.us.es'),
	(2, 'Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 'rafael@alum.us.es'),
	(3, 'Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 'gabriel@alum.us.es'),
	(4, 'Selectividad', '42345678A', 'Manuel', 'Fernández', '1994-01-01', 'manuel@alum.us.es'),
	(5, 'Selectividad', '52345678A', 'Joel', 'Gómez', '1995-01-01', 'joel@alum.us.es'),
	(6, 'Selectividad', '62345678A', 'Abel', 'López', '1996-01-01', 'abel@alum.us.es'),
	(7, 'Selectividad', '72345678A', 'Azael', 'González', '1997-01-01', 'azael@alum.us.es'),
	(8, 'Selectividad', '8345678A', 'Uriel', 'Martínez', '1998-01-01', 'uriel@alum.us.es'),
	(9, 'Selectividad', '92345678A', 'Gael', 'Sánchez', '1999-01-01', 'gael@alum.us.es'),
	(10, 'Titulado Extranjero', '12345678B', 'Noel', 'Álvarez', '1991-02-02', 'noel@alum.us.es'),
	(11, 'Titulado Extranjero', '22345678B', 'Ismael', 'Antúnez', '1992-02-02', 'ismael@alum.us.es'),
	(12, 'Titulado Extranjero', '32345678B', 'Nathanael', 'Antolinez', '1993-02-02', 'nathanael@alum.us.es'),
	(13, 'Titulado Extranjero', '42345678B', 'Ezequiel', 'Aznárez', '1994-02-02', 'ezequiel@alum.us.es'),
	(14, 'Titulado Extranjero', '52345678B', 'Ángel', 'Chávez', '1995-02-02', 'angel@alum.us.es'),
	(15, 'Titulado Extranjero', '62345678B', 'Matusael', 'Gutiérrez', '1996-02-02', 'matusael@alum.us.es'),
	(16, 'Titulado Extranjero', '72345678B', 'Samael', 'Gálvez', '1997-02-02', 'samael@alum.us.es'),
	(17, 'Titulado Extranjero', '82345678B', 'Baraquiel', 'Ibáñez', '1998-02-02', 'baraquiel@alum.us.es'),
	(18, 'Titulado Extranjero', '92345678B', 'Otoniel', 'Idiáquez', '1999-02-02', 'otoniel@alum.us.es'),
	(19, 'Titulado Extranjero', '12345678C', 'Niriel', 'Benítez', '1991-03-03', 'niriel@alum.us.es'),
	(20, 'Titulado Extranjero', '22345678C', 'Múriel', 'Bermúdez', '1992-03-03', 'muriel@alum.us.es'),
	(21, 'Titulado Extranjero', '32345678C', 'John', 'AII', '2000-01-01', 'john@alum.us.es');
	
INSERT INTO GroupsStudents (groupStudentId, groupId, studentId) VALUES
	(1, 1, 1),
	(2, 3, 1),
	(3, 7, 1),
	(4, 8, 1),
	(5, 10, 1),
	(6, 12, 1),
	(7, 2, 2),
	(8, 3, 2),
	(9, 10, 2),
	(10, 12, 2),
	(11, 18, 21),
	(12, 21, 21);
	
INSERT INTO Grades (gradeId, value, gradeCall, withHonours, studentId, groupId) VALUES
	(1, 4.50, 1, 0, 1, 1),
	(2, 3.25, 2, 0, 1, 1),
	(3, 9.95, 1, 0, 1, 7),
	(4, 7.5, 1, 0, 1, 10),
	(5, 2.50, 1, 0, 2, 2),
	(6, 5.00, 2, 0, 2, 2),
	(7, 10.00, 1, 1, 2, 10),
	(8, 0.00, 1, 0, 21, 18),
	(9, 1.25, 2, 0, 21, 18),
	(10, 0.5, 3, 0, 21, 18);