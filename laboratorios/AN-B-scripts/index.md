---
layout: single
title: Anexo B - Scripts
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
---

<!-- # Anexo B: Scripts de creación y poblado -->

## Creación de tablas

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE pCreateDB()
BEGIN
    DROP TABLE IF EXISTS Grades;
    DROP TABLE IF EXISTS GroupsStudents;
    DROP TABLE IF EXISTS Students;
    DROP TABLE IF EXISTS Groups;
    DROP TABLE IF EXISTS Subjects;
    DROP TABLE IF EXISTS Degrees;

    CREATE TABLE Degrees(
        degreeId INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(60) NOT NULL,
        years INT DEFAULT(4) NOT NULL,
        PRIMARY KEY (degreeId),
        CONSTRAINT invalidDegreeYear CHECK (years >=3 AND years <=5),
        CONSTRAINT uniqueDegreeName UNIQUE (name)
    );

    CREATE TABLE Subjects(
        subjectId INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(100) NOT NULL,
        acronym VARCHAR(8) NOT NULL,
        credits INT NOT NULL,
        year INT NOT NULL,
        type VARCHAR(20) NOT NULL,
        degreeId INT NOT NULL,
        PRIMARY KEY (subjectId),
        FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId) ON DELETE CASCADE,
        CONSTRAINT uniqueSubjectName UNIQUE (NAME),
        CONSTRAINT uniqueSubjectAcronym UNIQUE (acronym),
        CONSTRAINT negativeSubjectCredits CHECK (credits >0),
        CONSTRAINT invalidSubjectCourse CHECK (year >= 1 AND year <= 5),
        CONSTRAINT invalidSubjectType CHECK (type IN ('Formacion Básica', 'Optativa', 'Obligatoria'))
    );

    CREATE TABLE Groups(
        groupId INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(30) NOT NULL,
        activity VARCHAR(20) NOT NULL,
        year INT NOT NULL,
        subjectId INT NOT NULL,
        PRIMARY KEY (groupId),
        FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId) ON DELETE CASCADE,
        CONSTRAINT repeatedGroup UNIQUE (name, year, subjectId),
        CONSTRAINT negativeGroupYear CHECK (year >0),
        CONSTRAINT invalidGroupActivity CHECK (activity IN ('Teoría','Laboratorio'))
    );

    CREATE TABLE Students(
        studentId INT NOT NULL AUTO_INCREMENT,
        accessMethod VARCHAR(30) NOT NULL,
        dni CHAR(9) NOT NULL,
        firstName VARCHAR(100) NOT NULL,
        surname VARCHAR(100) NOT NULL,
        birthDate DATE NOT NULL,
        email VARCHAR(250) NOT NULL,
        password VARCHAR(250) NOT NULL,
        PRIMARY KEY (studentId),
        CONSTRAINT uniqueStudentDni UNIQUE (dni),
        CONSTRAINT uniqueStudentEmail UNIQUE (email),	
        CONSTRAINT invalidStudentAccessMethod CHECK (accessMethod IN
        ('Selectividad','Ciclo','Mayor','Titulado Extranjero'))
    );

    CREATE TABLE GroupsStudents(
        groupStudentId INT NOT NULL AUTO_INCREMENT,
        groupId INT NOT NULL,
        studentId INT NOT NULL,
        PRIMARY KEY (groupStudentId),
        FOREIGN KEY (groupId) REFERENCES Groups (groupId),
        FOREIGN KEY (studentId) REFERENCES Students (studentId),
	    CONSTRAINT uniqueStudentInGroup UNIQUE (groupId, studentId)
    );

    CREATE TABLE Grades(
        gradeId INT NOT NULL AUTO_INCREMENT,
        value DECIMAL(4,2) NOT NULL,
        gradeCall INT NOT NULL,
        withHonours BOOLEAN NOT NULL,
        studentId INT NOT NULL,
        groupId INT NOT NULL,
        PRIMARY KEY (gradeId),
        FOREIGN KEY (studentId) REFERENCES Students (studentId),
        FOREIGN KEY (groupId) REFERENCES Groups (groupId),
        CONSTRAINT invalidGradeValue CHECK (value >= 0 AND value <= 10),
        CONSTRAINT invalidGradeCall CHECK (gradeCall >= 1 AND gradeCall <= 3),
        CONSTRAINT RN_002_duplicatedCallGrade UNIQUE (gradeCall, studentId, groupId)
    );
END //
DELIMITER ;

CALL pCreateDB();
```


##  Poblado de la base de datos con datos de ejemplo

```sql

DELIMITER //
CREATE OR REPLACE PROCEDURE pPopulateDB()
BEGIN
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
        (1, 'Disenyo y Pruebas', 'DP', 12, 3, 'Obligatoria', 1),
        (2, 'Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 1),
        (3, 'Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 1),
        (4, 'Ingeniería de Requisitos', 'IR', 6, 2, 'Obligatoria', 1),
        (5, 'Análisis y Disenyo de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria', 1),
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
    -- The password is the firstName of the student in lowercase
    INSERT INTO Students (studentId, accessMethod, dni, firstname, surname, birthdate, email, password) VALUES
        (1, 'Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 'daniel@alum.us.es',
        'pbkdf2:sha256:260000$0LpbZLwrBMrF75Qm$6cbbbc8a724d3d50130823a68832bf942b55a4b759073e3992c37462a7f24561'),
        (2, 'Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 'rafael@alum.us.es',
        'pbkdf2:sha256:260000$9EkVFY3iVp8Eu0HN$d47eb54106ccaf297e709c940a2794edf4e9d55cb1f80f9c6f3cf3a4566fe28e'),
        (3, 'Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 'gabriel@alum.us.es',
        'pbkdf2:sha256:260000$UMHc2KNxoYEdhYlF$c91a1a9580aaa82c88f480713e0d8d634a07d8331e8be207e50322482baffc30'),
        (4, 'Selectividad', '42345678A', 'Manuel', 'Fernández', '1994-01-01', 'manuel@alum.us.es',
        'pbkdf2:sha256:260000$MpMKMoCs3UV8kN8s$19ff3657bf214470899039fc72c374d605fc5a78eb5f0add8ece7a5f47d82d56'),
        (5, 'Selectividad', '52345678A', 'Joel', 'Gómez', '1995-01-01', 'joel@alum.us.es',
        'pbkdf2:sha256:260000$9ztm8YSaVDVM0BSi$dec6867bebf1cea305bbe4f4d08fcaf1bac6bd7df3e2b00e54e58da5d36c956c'),
        (6, 'Selectividad', '62345678A', 'Abel', 'López', '1996-01-01', 'abel@alum.us.es',
        'pbkdf2:sha256:260000$oNiu1XXcI2PCTqur$775ff46d9e3e7541384a002c2e34f658c18afaa60c2e1c1e87c5cf397e3973bd'),
        (7, 'Selectividad', '72345678A', 'Azael', 'González', '1997-01-01', 'azael@alum.us.es',
        'pbkdf2:sha256:260000$aDnGT8KdrfQCqZOM$c66483fbfb987110c4f00aacc0419ae377792e5eaa77aa44df5d2461125892a7'),
        (8, 'Selectividad', '8345678A', 'Uriel', 'Martínez', '1998-01-01', 'uriel@alum.us.es',
        'pbkdf2:sha256:260000$bLYUcDpZmwZu48M1$588bf4810e8e0199662c263dcff6a835eb00bae186303ed869336cd86d85e90a'),
        (9, 'Selectividad', '92345678A', 'Gael', 'Sánchez', '1999-01-01', 'gael@alum.us.es',
        'pbkdf2:sha256:260000$khFjryU3TZcN8X6H$93e0c2e7f12223578a921186f508d64515744f23c6adb0f47eb06f8797c14eee'),
        (10, 'Titulado Extranjero', '12345678B', 'Noel', 'Álvarez', '1991-02-02', 'noel@alum.us.es',
        'pbkdf2:sha256:260000$2hsD3mXCtebAgKFm$8ffb9c4b5c13d7295759b339129814a8e8b80eed112717603e72adff4be576b8'),
        (11, 'Titulado Extranjero', '22345678B', 'Ismael', 'Antúnez', '1992-02-02', 'ismael@alum.us.es',
        'pbkdf2:sha256:260000$cA8vEtOdHisoLNPn$9ed1096132a4543d4dc9752d37c49a2c417ed1657cf25f37d942dce363380ddf'),
        (12, 'Titulado Extranjero', '32345678B', 'Nathan', 'Antolinez', '1993-02-02', 'nathan@alum.us.es',
        'pbkdf2:sha256:260000$DtPZrhfSlMtZlAqV$fd1304597de91cd38ce83babb5796f67cf5bf1b8d90d647c4e680b8d9fc47f2b'),
        (13, 'Titulado Extranjero', '42345678B', 'Juan', 'Aznárez', '1994-02-02', 'ezequiel@alum.us.es',
        'pbkdf2:sha256:260000$y6nTsEajbFppukY3$0df69fce011a41fd4a5fe3a6b5700dbc89e4f54865ef8113424ac01a471bc6f2'),
        (14, 'Titulado Extranjero', '52345678B', 'Ángel', 'Chávez', '1995-02-02', 'angel@alum.us.es',
        'pbkdf2:sha256:260000$trco7HTaSmVdOFDP$3895162b022c5075a30e1fdb8a40ed5d70a0b005b2e9f7539c3937caad21f061'),
        (15, 'Ciclo', '62345678B', 'Matusael', 'Gutiérrez', '1996-02-02', 'matusael@alum.us.es',
        'pbkdf2:sha256:260000$laqqQJJr3MCogaKK$07785bc3f250e9c79e3710bd5b3a0061a2046a66f448168e01cc3dfab5b9a53e'),
        (16, 'Ciclo', '72345678B', 'Samael', 'Gálvez', '1997-02-02', 'samael@alum.us.es',
        'pbkdf2:sha256:260000$HHyKbQnRKCCcJJbH$4336745652b887653f01448a9b222e8416cbe405a4de9ad33c16b3ba8e8e4db7'),
        (17, 'Ciclo', '82345678B', 'Baraquiel', 'Ibányez', '1998-02-02', 'baraquiel@alum.us.es',
        'pbkdf2:sha256:260000$9zcWPfuuqqjE9rQ3$a3b6e5ec00a3e2dd5a5a2bbbc0e67ab00045bdc9169b0be24c0c8c73d6f79847'),
        (18, 'Ciclo', '92345678B', 'Otoniel', 'Idiáquez', '1999-02-02', 'otoniel@alum.us.es',
        'pbkdf2:sha256:260000$6IuN7njjCSfITN6V$c273483d9f90f048f000df36c365e0c52b82f9c34702e4c22fa21a1c01fa56a6'),
        (19, 'Ciclo', '12345678C', 'Niriel', 'Benítez', '1991-03-03', 'niriel@alum.us.es',
        'pbkdf2:sha256:260000$HMcymPHesA42cWhm$08b7baf2b360975fe845fce57308bf4023b249af6e31b0923dad47f6995d0de0'),
        (20, 'Titulado Extranjero', '22345678C', 'Múriel', 'Bermúdez', '1992-03-03', 'muriel@alum.us.es',
        'pbkdf2:sha256:260000$ZgR32yAcKuHZvuPD$8a96374d50e95f2c675320dbc738f8be8508b9f32adeb23cbbb484b64fa26369'),
        (21, 'Mayor', '32345678C', 'John', 'AII', '2000-01-01', 'john@alum.us.es',
        'pbkdf2:sha256:260000$DHsexphtg7WPmtu6$ded77c3a918373d397a466658a5750073052567badde543e7c9835f70b2d792a');

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
END //
DELIMITER ;

CALL pPopulateDB();
```