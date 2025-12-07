---
layout: single
title: "Lab2 - Restricciones en tablas"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---
> [Versión PDF disponible](./index.pdf)


<!-- # Restricciones en tablas SQL -->

## Objetivo

El objetivo de esta práctica es implementar restricciones en la creación de tablas mediante scripts SQL. El alumno aprenderá a:

- Añadir restricciones a los atributos al definir tablas.
- Definir claves alternativas.
- Implementar enumerados.
- Definir comportamientos en caso de borrado de una tabla relacionada.

En la práctica anterior se realizó un script SQL de creación de tablas con sus atributos y relaciones. Sin embargo, tal y como se crearon, las tablas permitían la introducción de valores no válidos en los atributos, como números negativos en algunos de ellos o valores que no forman parte de un enumerado. En esta práctica refinaremos las tablas para incluir restricciones de datos con las que implementar claves alternativas, enumerados, y reglas de negocio simples.

## Preparación del entorno

Conéctese a la base de datos y abra el archivo `tables.sql` usado en el laboratorio anterior.

## Restricciones en tabla Degrees

Las restricciones más comunes se pueden implementar mediante código en la misma línea en la que se define el atributo implicado, mientras que las que requieran una expresión que deba ser verdadera se indican por separado. Añadimos restricciones a la tabla Degrees de la siguiente manera:

```sql
CREATE TABLE Degrees(
	degreeId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL,
	years INT DEFAULT(4) NOT NULL,
	PRIMARY KEY (degreeId),
	CONSTRAINT invalidDegreeYear CHECK (years >=3 AND years <=5),
	CONSTRAINT uniqueDegreeName UNIQUE (name)
);
```

Observe lo siguiente:

- Mediante `NOT NULL` indicamos que un atributo no puede ser nulo, es decir, no tener valor. Los atributos marcados como clave primaria son `NOT NULL` por defecto. Sin embargo, puede indicarse como recordatorio y por consistencia.
- Las restricciones indicadas con `CONSTRAINT` indican expresiones que deben cumplirse. Escribimos el nombre de la constraint (que aparecerá en el mensaje de error si no se cumple), `CHECK`, y la expresión booleana que debe cumplirse. En este caso, la constraint comprueba que la cantidad de años del grado esté comprendida entre 3 y 5.
- Mediante `UNIQUE` indicamos que un atributo no puede tomar valores repetidos y debe ser único. Ésto lo convierte en clave alternativa. También puede indicarse en la misma línea que el atributo, pero es más descriptivo hacerlo como "constraint".

## Restricciones en la tabla Subjects

Añadimos restricciones a la tabla Subjects de la siguiente manera:

```sql
CREATE TABLE Subjects(
	subjectId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	acronym VARCHAR(8) NOT NULL,
	credits INT NOT NULL,
	year INT NOT NULL,
	type VARCHAR(20) NOT NULL,
	degreeId INT NOT NULL,
	PRIMARY KEY (subjectId),
	FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId),
	CONSTRAINT uniqueSubjectName UNIQUE (name),
	CONSTRAINT uniqueSubjectAcronym UNIQUE (acronym),
	CONSTRAINT negativeSubjectCredits CHECK (credits > 0),
	CONSTRAINT invalidSubjectCourse CHECK (year >= 1 AND year <= 5),
	CONSTRAINT invalidSubjectType CHECK (type IN ('Formacion Básica',
		'Optativa',
		'Obligatoria'))
);
```

Observe lo siguiente:

- La restricción `NOT NULL` es muy común, ya que por ahora ningún atributo es opcional.
- Una clave ajena también puede ser `NOT NULL`, indicando que la relación no es opcional. Es la diferencia entre multiplicidad 0..1 y multiplicidad 1.
- En la última constraint hemos implementado el atributo "type" como un enumerado, comprobando que su valor está en un conjunto de posibles valores.

## Restricciones en la tabla Groups

Añadimos restricciones a la tabla Groups de la siguiente manera:

```sql
CREATE TABLE Groups(
	groupId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
	activity VARCHAR(20) NOT NULL,
	year INT NOT NULL,
	subjectId INT NOT NULL,
	PRIMARY KEY (groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
	CONSTRAINT repeatedGroup UNIQUE (name, year, subjectId),
	CONSTRAINT negativeGroupYear CHECK (year > 0),
	CONSTRAINT invalidGroupActivity CHECK (activity IN ('Teoría','Laboratorio'))
);
```

Esta vez la restricción `UNIQUE` involucra a tres columnas que se han indicado entre paréntesis: `name`, `year`, y `subjectId`, indicando que no puede haber dos filas en las que la combinación de estos tres atributos sea la misma. De esta manera, logramos que no pueda haber dos grupos con el mismo nombre en la misma asignatura y el mismo año.

## Restricciones en las tablas Students y GroupsStudents

```sql
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
	UNIQUE (groupId, studentId)
);
```

Observe la restricción `UNIQUE` en la tabla GroupsStudents. Haciendo único el par de claves ajenas, hacemos que cada alumno solo pueda estar asociado a un grupo una vez.

## Restricciones en la tabla Grades

Añadimos restricciones a la tabla Grades de la siguiente manera:

```sql
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
	CONSTRAINT invalidGradeValue CHECK (value > = 0 AND value <= 10),
	CONSTRAINT invalidGradeCall CHECK (gradeCall >= 1 AND gradeCall <= 3),
	CONSTRAINT RN_002_duplicatedCallGrade UNIQUE (gradeCall, studentId, groupId)
);
```

Observe lo siguiente:

- Esta vez, la restricción `UNIQUE` se ha incluido como parte de una constraint. De esta manera se le da un nombre que se mostrará si no se cumple. En este caso, no hay que incluir la palabra reservada `CHECK`.
- Mediante la restricción de unicidad, nos aseguramos de que no haya varias notas para un mismo alumno, en una misma asignatura, en una misma convocatoria. Sin embargo, puede tener varias notas en convocatorias diferentes.

## Comportamientos en borrado para claves ajenas

Como se explicó en el boletín anterior, las claves ajenas imponen por defecto una restricción en el borrado de las filas relacionadas: por ejemplo, consideremos las tablas Degrees y Subjects, donde `degreeId` es clave primaria de Degrees y ajena de Subjects, relacionando las asignaturas con el grado en que se imparten.

En este caso, un grado no podría borrarse si hay al menos una asignatura que lo referencia mediante la clave ajena `degreeId` de Subject. Sin embargo, este comportamiento de la clave ajena se puede cambiar mediante instrucciones SQL:

- `ON DELETE RESTRICT` impide el borrado en la fila referenciada. Es el comportamiento por defecto.
- `ON DELETE CASCADE` borra la fila de la clave ajena cuando la fila referenciada se borra (borrado en cascada, de ahí su nombre).
- `ON DELETE SET NULL` establece la clave ajena a `NULL` cuando la fila referenciada se borra. Sólo es posible si la clave ajena no tiene la restricción `NOT NULL`, es decir, para multiplicidad 0..1.
- `ON DELETE SET DEFAULT` establece la clave ajena a su valor por defecto cuando la fila referenciada se borra. Sólo es posible si se ha definido un valor por defecto para la clave ajena mediante `DEFAULT()`.

En el caso de la relación entre Subjects y Groups, para implementar la relación de composición, que implica que se borren los grupos de la asignatura cuando esta es borrada de la base de datos, debemos modificar la declaración de la tabla Groups:

```sql
FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId) ON DELETE CASCADE,
```

Observe cómo se ha añadido la instrucción `ON DELETE CASCADE` a la declaración de clave ajena de `subjectId`, lo que provocará que se borren los grupos de la asignatura si se borra la asignatura referenciada.

Guardar los cambios del archivo `tables.sql` para utilizarlo en próximos laboratorios.


