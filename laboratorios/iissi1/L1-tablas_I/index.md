---
layout: single
sidebar:
  nav: labs-iissi-1
title: "Lab1 - Creación de tablas"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---
> [Versión PDF disponible](./index.pdf)


<!-- # Creación de tablas SQL -->

## Objetivo

El objetivo de esta práctica es aprender las instrucciones SQL para crear las tablas de una base de datos. El alumno aprenderá a:

- Crear tablas mediante instrucciones SQL.
- Definir atributos con diferentes tipos de datos.
- Definir claves primarias.
- Definir claves ajenas e implementar relaciones 1:N y N:M.
- Definir campos con autoincremento.
- Definir valores por defecto para campos.

Se usará como base el documento de requisitos del laboratorio 1.

## Preparación del entorno

Si se ha instalado MariaDB siguiendo el procedimiento mostrado en el anexo de este documento, el SGBD ha quedado registrado como un servicio Windows, por lo que debería iniciarse automáticamente con el sistema operativo.

Iniciamos HeidiSQL y nos conectamos con el usuario iissi_user mediante la conexión creada en el laboratorio anterior. Seleccionamos la base de datos grados y abrimos la pestaña de Consulta. En esa pestaña podemos escribir código SQL para que se ejecute en la base de datos seleccionada. El contenido de la pestaña puede escribirse manualmente o ser un archivo .sql cargado:

![HeidiSQL](/assets/images/iissi1/laboratorios/fig/lab1-2/heidisql.png)

## Consideraciones de estilo

SQL no distingue entre mayúsculas y minúsculas, por lo que es posible que código de diferentes fuentes las usen de forma diferente. Nosotros seguiremos las siguientes normas para unificar el estilo del código:

- Las palabras reservadas del lenguaje SQL (es decir, todo lo que no son nombres definidos por nosotros) se escribirán enteramente en mayúsculas. Por ejemplo: `INSERT, UPDATE, DELETE`.
- Los nombres de tablas se escribirán con la primera letra en mayúsculas, en CamelCase[^1] si están formados por varias palabras, y en plural. Por ejemplo: `Degrees, Subjects, Photos, UserComments`.
- Los nombres de atributos, constraints, y otros elementos que no sean tablas, se escribirán completamente en minúsculas, en CamelCase si están formados por varias palabras. Por ejemplo: `degreeId, course, photoUrl, text`.
- El código estará escrito en inglés.

[^1]: El estilo CamelCase une varias palabras sin espacios, con la primera letra de cada una en mayúsculas: EstoEsUnEjemplo. La primera letra de todas puede estar en mayúsculas o minúsculas.

## Creación de tabla Degrees (Grados)

Primero implementamos en MariaDB la relación correspondiente a los grados:

```text
Degrees(degreeId, name, years)
	PK(degreeId)
	AK(name)
```

Para ello escribimos el siguiente código en la pestaña de Consulta:

```sql
DROP TABLE IF EXISTS Degrees;

CREATE TABLE Degrees(
	degreeId INT AUTO_INCREMENT,
	name VARCHAR(60),
	years INT DEFAULT(4),
	PRIMARY KEY (degreeId)
);
```

Observe lo siguiente:

- La primera línea, `DROP TABLE IF EXISTS Degrees;`, se encarga de que se borre la tabla si ya existía. Sin esta línea, se produciría un error si intentamos crear la tabla cuando ya existe (por ejemplo, porque haciendo pruebas queramos ejecutar el script varias veces). Es conveniente que, en un script de creación de tablas, lo primero que se haga sea eliminar todas las tablas si existen.
- El contenido dentro de `CREATE TABLE Degrees` contiene la definición de la tabla. Separamos con comas la definición de atributos o restricciones.
- `INT` y `VARCHAR` son tipos de datos. `VARCHAR` corresponde a un String, y el número indicado entre paréntesis es el número máximo de caracteres.
- En la última línea indicamos cuál es la clave primaria. Se indican entre paréntesis los atributos que forman parte de ella. Si una clave primaria estuviera formada por varios atributos, se incluirían todos separados por comas.
- Nos aseguramos de que los nombres de los IDs sean siempre diferentes (por ejemplo: degreeId, subjectId). Darle distintos nombres a los ID de todas las tablas evita problemas en caso de despistes.
- A los atributos marcados como `AUTO_INCREMENT` se les dará valor automáticamente siguiendo una secuencia. Los atributos marcados con `AUTO_INCREMENT` deben ser una clave, ya sea primaria o alternativa (que se verán en el siguiente boletín).
- Con `DEFAULT()` indicamos el valor por defecto de un atributo.

## Creación de tabla Subjects (Asignaturas)

Implementamos la relación correspondiente a las asignaturas:

```text
Subjects(subjectId, degreeId, name, acronym, credits, year, type)
	PK(subjectId)
	FK(degreeId)
	AK(name)
	AK(acronym)
```

con el siguiente código SQL:

```sql
DROP TABLE IF EXISTS Subjects;

CREATE TABLE Subjects(
	subjectId INT AUTO_INCREMENT,
	degreeId INT,
	name VARCHAR(100),
	acronym VARCHAR(8),
	credits INT,
	year INT,
	type VARCHAR(20),
	PRIMARY KEY (subjectId),
	FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId)
); 
```

Añada la eliminación de la tabla si existe antes de crearla y observe lo siguiente:

- Cambiamos la longitud máxima de campos `VARCHAR` según corresponda.
- Por ahora, no hay nada que evite que el campo `type` tome cualquier valor, en vez de los valores de enumerado definidos.
- Para definir una clave ajena, incluimos un atributo **del mismo tipo** que la clave que queremos referenciar, y usamos la sentencia `FOREIGN KEY`. La sentencia recibe primero los atributos que forman parte de la clave ajena, la tabla a la que referencian, y los atributos de la tabla que se referencian. Estos últimos deben ser una clave primaria o alternativa.
- El nombre de la clave ajena no tiene que ser igual que el de la clave primaria referenciada, pero es común que sea así.
- Si una clave ajena está formada por varios atributos, se escribirían entre paréntesis y separados por comas.
- En este caso hemos implementado una relación 1:N. Para estas relaciones, la clave ajena se añade en el lado N de la relación.
- La existencia de claves ajenas puede crear problemas, por ejemplo, si se intenta borrar o modificar una fila que es referenciada por otra mediante una clave ajena. Por defecto, no se permiten eliminar filas referenciadas en otras tablas.

## Creación de tabla Groups (Grupos)

Implementamos la relación correspondiente a los grupos:

```text
Groups(groupId, subjectId, name, activity, year)
	PK(groupId)
	FK(subjectId)
```

con el siguiente código SQL:

```sql
CREATE TABLE Groups(
	groupId INT AUTO_INCREMENT,
	name VARCHAR(30),
	activity VARCHAR(20),
	year INT,
	subjectId INT,
	PRIMARY KEY (groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId)
);
```

Añada la eliminación de la tabla si existe antes de crearla. Observe cómo la composición se implementa igual que una relación normal (una asignatura se compone de varios grupos). Sin embargo, se podría indicar que al borrar una asignatura, en vez de producirse error, deben borrarse los grupos que la referencian.

## Creación de la tabla Students (Alumnos)

Implementamos la relación correspondiente a los alumnos:

```text
Students(studentId, accessMethod, dni, firstName, surname, birthDate, email)
	PK(studentId)
	AK(dni)
	AK(email)
```

con el siguiente código SQL:

```sql
CREATE TABLE Students(
	studentId INT AUTO_INCREMENT,
	accessMethod VARCHAR(30),
	dni CHAR(9),
	firstName VARCHAR(100),
	surname VARCHAR(100),
	birthDate DATE,
	email VARCHAR(250),
	password VARCHAR(250),
	PRIMARY KEY (studentId)
);
```

Añada la eliminación de la tabla si existe antes de crearla y observe lo siguiente:

- Cuando se usa el tipo `CHAR` no se indica la longitud máxima del atributo, sino la exacta que tiene que tener, en este caso 9 caracteres. A diferencia de `VARCHAR`, en este caso no se permitiría introducir un dato con una longitud diferente a 9 caracteres.
- El tipo `DATE` permite guardar una fecha sin hora. Para guardar una hora se usaría el tipo `TIME`, y para una fecha con hora, el tipo `DATETIME`.
- Todavía no se ha implementado la relación N:M entre alumnos y grupos. Con una clave ajena en una o ambas tablas no se podría implementar bien la relación. Hace falta una tabla adicional.

Para implementar la relación N:M debemos crear una tabla adicional que contenga pares relacionados de alumnos y grupos. La creamos con el siguiente código:

```sql
CREATE TABLE GroupsStudents(
	groupStudentId INT AUTO_INCREMENT,
	groupId INT,
	studentId INT,
	PRIMARY KEY (groupStudentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId)
);
```

Añada la eliminación de la tabla si existe antes de crearla y observe lo siguiente:

- La tabla solo tiene los atributos necesarios para relacionar grupos con alumnos.
- El nombre de una tabla usada para representar una relación N:M es la unión de los nombres de las dos tablas que relaciona.
- Ahora mismo, sería posible introducir de forma repetida el mismo alumno asociado al mismo grupo. Esto es incorrecto, ya que un alumno solo puede pertenecer a un grupo una vez. En el siguiente boletín veremos cómo arreglar este problema mediante una restricción.

## Creación de la tabla Grades (Notas)

Implementamos la relación correspondiente a las notas:

```text
Grades(gradeId, studentId, groupId, value, gradeCall, withHonours)
	PK(gradeId)
	FK(studentId)
	FK(groupId)
```

con el siguiente código SQL:

```sql
CREATE TABLE Grades(
	gradeId INT AUTO_INCREMENT,
	value DECIMAL(4,2),
	gradeCall INT,
	withHonours BOOLEAN,
	studentId INT,
	groupId INT,
	PRIMARY KEY (gradeId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId)
);
```

Añada la eliminación de la tabla si existe antes de crearla y observe lo siguiente:

- Se ha usado el nombre de atributo `gradeCall` en vez de simplemente `call` (convocatoria) debido a que `call` es una palabra reservada en MariaDB, y no puede usarse como nombre ya que se produciría un error. Las palabras reservadas en MariaDB se pueden consultar en [el listado oficial](https://mariadb.com/docs/server/reference/sql-structure/sql-language-structure/reserved-words).
- El tipo `DECIMAL` es usado para definir números que pueden tener decimales. De sus dos parámetros, el primero indica el número total de dígitos, y el segundo, cuántos de ellos son decimales. Como la nota máxima es 10.00, y queremos que haya una precisión de dos cifras decimales, damos como parámetros `(4,2)`.
- El tipo `BOOLEAN` es usado para definir booleanos. Internamente se almacenan como valores numéricos 0 o 1.
- Varias de las palabras usadas para definir tipos en MariaDB son sinónimas y representan varias formas de escribir el mismo tipo. Por ejemplo, `INT` es sinónimo de `INTEGER`; `DECIMAL` es sinónimo de `DEC`, `NUMERIC` de `FIXED`; y `BOOLEAN` es sinónimo de `BOOL` o `TINYINT(1)`.
- Aparte de `DECIMAL`, existen los tipos `FLOAT` y `DOUBLE`. Estos tipos también permiten almacenar números decimales, pero usando números con coma flotante, una manera de representar los números decimales de forma aproximada (debido a los sistemas binarios usados por ordenadores) con una cantidad fija de bits. El tipo `DECIMAL` almacena los números de forma exacta, aunque a costa de usar más memoria y ser menos eficiente.

## Restricciones de borrado de tablas

Por defecto, las bases de datos SQL no permiten borrar una tabla mientras existan otras que la referencien mediante claves ajenas. Por ello, al principio de nuestros scripts de creación de tablas, las borraremos en caso de que ya existan **en orden contrario a su creación**. Ésto garantiza que, en el momento de borrar cada tabla, no existe ninguna otra que la referencie. En el caso de las tablas creadas en este boletín, resultaría:

```sql
DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS GroupsStudents;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Degrees;
```

Realizar estas operaciones al principio del script de creación de tablas permite poder ejecutarlos tantas veces como se desee, ya que si se intenta crear de nuevo una tabla cuando ésta ya existe se produciría un error.

Para poder utilizar el código de la pestaña Consulta, guárdelo con el nombre `tables.sql` por medio de Archivo → Guardar.
