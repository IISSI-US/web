---
layout: single
title: "Lab3 - Datos y consultas simples"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---
> [Versión PDF disponible](./index.pdf)


<!-- # Manejo de datos y consultas simples -->

## Objetivo

El objetivo de esta práctica es manejar los datos almacenados en la base de datos mediante scripts SQL. El alumno aprenderá a:

- Usar `INSERT` para insertar filas.
- Usar `UPDATE` para actualizar filas.
- Usar `DELETE` para borrar filas.
- Usar `SELECT` para consultar filas.

Hasta ahora hemos creado las tablas que darán soporte a los datos, pero no hemos introducido datos en ellas, ni los hemos manejado. En esta práctica usaremos instrucciones para insertar, alterar, borrar y consultar las filas de cada tabla.

## Preparación del entorno

Conéctese a la base de datos y ejecute el archivo `tables.sql` contra la base de datos `grados`. Cree un archivo `queries.sql` en el que se escribirán las instrucciones que se irán desarrollando en esta práctica. Antes de cada ejecución de sus consultas, se recomienda ejecutar el script de creación de tablas, para que éstas se encuentren en un estado controlado antes de la consulta o modificación.

## INSERT

Para insertar filas en una tabla, usamos `INSERT` de la siguiente manera:

<!-- ![INSERT ejemplo](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-1.PNG) -->

```sql
INSERT INTO Degrees VALUES (NULL, 'Tecnologías Informáticas', 4);
```

Observe lo siguiente:

- Se indica primero el nombre de la tabla, y luego los valores de la fila separados por comas y entre paréntesis.
- Por defecto, hay que introducir los valores en el orden que tienen en la tabla.
- Al ID le damos valor `NULL`, para que se le de un valor automático con incremento. Si diéramos un número, se usaría ese en vez del generado automáticamente.
- Al escribir cadenas de texto deben usarse comillas simples. Aunque MariaDB técnicamente permite usar comillas dobles, no están aconsejadas ya que en lenguajes y SGBD similares causan errores.

Añadamos algunas filas a todas las tablas:

<!-- ![INSERT varias filas](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-2.PNG) -->

```sql
INSERT INTO Degrees (name, years) VALUES
	('Ingeniería del Software', 4),
	('Ingeniería del Computadores', 4),
	('Tecnologías Informáticas', 4);

INSERT INTO Subjects (name, acronym, credits, year, type, degreeId) VALUES
	('Fundamentos de Programación', 'FP', 12, 1, 'Formacion Básica', 3),
	('Lógica Informática', 'LI', 6, 2, 'Optativa', 3);
	
INSERT INTO Groups (name, activity, year, subjectId) VALUES
	('T1', 'Teoría', 2019, 1),
	('L1', 'Laboratorio', 2019, 1),
	('L2', 'Laboratorio', 2019, 1);
	
INSERT INTO Students (accessMethod, dni, firstname, surname, birthdate, email, password) VALUES
	('Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 
		'daniel@alum.us.es', 'password1'),
	('Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 
		'rafael@alum.us.es', 'password2'),
	('Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 
		'gabriel@alum.us.es', 'password3');

INSERT INTO GroupsStudents (groupId, studentId) VALUES
	(1, 1),
	(3, 1);
	
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(4.50, 1, 0, 1, 1),
	(5.00, 1, 0, 2, 1),
	(6.00, 1, 0, 3, 1),
	(7.00, 2, 0, 1, 1),
	(9.00, 2, 1, 2, 1),
	(9.00, 2, 0, 3, 1),
	(10.00, 3, 0, 1, 3),
	(5.50, 3, 0, 2, 3),
	(6.00, 2, 1, 3, 3);
```

Observe lo siguiente:

- Hemos añadido a las sentencias `INSERT`, antes de los valores, las columnas a las que vamos a dar valor. A las columnas no indicadas se les da valor `NULL` (o el default). El orden de las columnas especificadas no tiene por qué coincidir con el que tienen en la tabla, pero sí debe ser coherente con los valores que se indiquen a continuación.
- En un mismo `INSERT` a una tabla se pueden introducir varias filas separadas por comas.
- Las fechas se introducen como cadenas, siguiendo el formato `YYYY-MM-DD`.
- Los booleanos se introducen como valores numéricos 0 o 1.

## UPDATE

Para modificar una o varias filas, usamos `UPDATE` de la siguiente manera:

<!-- ![UPDATE ejemplo](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-3.PNG) -->

```sql
UPDATE Students 
	SET birthdate = '1998-01-01', surname='Fernández' 
	WHERE studentId = 3;
```

Observe lo siguiente:

- Se pueden actualizar varios atributos a la vez.
- La query tiene tres partes: la tabla afectada, los atributos que van a ser modificados, y una condición limitando las filas afectadas.
- Si omitimos la cláusula `WHERE`, todas las filas serán actualizadas. Cuidado.

Las actualizaciones también pueden usar los valores antiguos al dar nuevos valores, por ejemplo, la siguiente actualización reduce a la mitad los créditos de todas las asignaturas:

<!-- ![UPDATE con cálculo](src/fig/lab1-4/queries-4.PNG) -->

```sql
UPDATE Subjects
	SET credits = credits/2;
```

## DELETE

Para borrar filas de una tabla se usa la instrucción `DELETE FROM`. Podemos borrar filas de la siguiente manera:

<!-- ![DELETE ejemplo](src/fig/lab1-4/queries-5.PNG) -->

```sql
DELETE FROM Grades
	WHERE gradeId = 1;
```

Observe lo siguiente:

- La query tiene dos partes: la tabla afectada, y una condición limitando las filas borradas.
- **¡Cuidado!** Si omitimos la cláusula `WHERE`, todas las filas de la tabla serán borradas.
- Por defecto, no se puede borrar una fila que esté referenciada por otra mediante una clave ajena. Habría primero que eliminar la referencia.

Si queremos que al borrar una fila se borren aquellas filas que la referencian mediante claves ajenas (en vez de producirse un error), tenemos que activar el borrado en cascada mediante `ON DELETE CASCADE`, como se explicó en el boletín anterior. Nótese que, en cualquier caso, se mantiene la integridad referencial de la base de datos, impidiéndose que existan referencias a filas que no existen.

## SELECT

La consulta de datos de una base de datos es fundamental. El resultado de este tipo de consultas es siempre una tabla con filas y columnas determinadas por la consulta.

Por ejemplo, podríamos seleccionar los nombres y apellidos de alumnos de acceso por selectividad de la siguiente manera:

![SELECT ejemplo](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-7-2.PNG)

Observe lo siguiente:

- La query tiene tres partes: las columnas a obtener, las tablas implicadas (puede haber varias), y una condición (opcional) limitando las filas seleccionadas.
- Si queremos obtener todas las columnas presentes en la tabla seleccionada, podemos usar `*`: `SELECT * FROM...`.
- Fíjese en que hemos dado un alias "s" a la tabla Students, de manera que no es necesario repetir el nombre de la tabla al referirnos a sus columnas. Esto es especialmente útil cuando hay varias tablas implicadas en la consulta.

Las columnas a seleccionar no tienen por qué ser sólo las ya existentes en las tablas. Podemos definir cálculos a devolver como columnas. Por ejemplo:

<!-- ![SELECT con cálculo](src/fig/lab1-4/queries-8.PNG) -->

```sql
SELECT s.credits > 3
	FROM Subjects s
;
```
En ese caso, el valor devuelto será un boolean, indicando si en cada fila el número de créditos es mayor que 3.

También podemos pedir valores agregados (sumas, medias, etc.). Pedir estos valores implica que solo se devolverá una fila. Si además solo se pide una columna, se devolverá un valor único:

![SELECT agregados](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-9-2.PNG)

Observe lo que ocurre cuando se piden como columnas valores agregados junto con una columna de la tabla:

![SELECT agregados y columna](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-10-2.PNG)

Al pedirse valores agregados, solo se devuelve una fila, que corresponde al valor en cuestión calculado para toda la tabla. El nombre devuelto es simplemente el de la primera de las filas. No tiene sentido pedir valores agregados junto con atributos que cambian de fila a fila.

Uno de los valores agregados más útiles es `COUNT`. En su variante más común, cuenta el número de filas devueltas:

![SELECT COUNT](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-11-2.PNG)

Sin embargo, podemos incluir una expresión que limite las filas que se están contando:

![SELECT COUNT con condición](/assets/images/iissi1/laboratorios/fig/lab1-4/queries-12-2.PNG)

## Vistas

En ocasiones, es útil guardar los resultados de una consulta para luego utilizarlos en otras consultas como si fueran una tabla más. De esta manera se simplifica en gran medida la creación de consultas anidadas complejas. Esto se puede hacer mediante vistas, en las que damos un nombre a una consulta `SELECT` que luego se puede usar como si fuera una tabla.

Por ejemplo, podríamos crear una vista que contenga las notas del grupo con ID 1:

<!-- ![Vista ejemplo](src/fig/lab1-4/vistas-1.png) -->

```sql
CREATE OR REPLACE VIEW vGradesGroup1 AS
	SELECT * FROM Grades g WHERE g.groupId = 1
;
```

Y a continuación usarla en diferentes consultas:

<!-- ![Vista consultas](src/fig/lab1-4/vistas-2.png) -->

```sql
SELECT MAX(v.value) FROM vGradesGroup1 v;
SELECT COUNT(*) FROM vGradesGroup1 v;
SELECT * FROM vGradesGroup1 v WHERE v.gradeCall = 1;
```

También podemos usar una vista dentro de otra:

<!-- ![Vista anidada](src/fig/lab1-4/vistas-3.png) -->

```sql
CREATE OR REPLACE VIEW vGradesGroup1Call1 AS
	SELECT * FROM vGradesGroup1 v WHERE v.gradeCall = 1;
	
SELECT * FROM vGradesGroup1Call1 v;
```

## Consultas varias

La posibilidades a la hora de realizar consultas son casi ilimitadas. A continuación se realizarán una serie de consultas que cubren muchos de los casos posibles. Antes de ejecutar las consultas, ejecute el script de introducción de datos de ejemplo del [anexo](#anexo-b-scripts-de-creación-y-poblado) que inserta una mayor cantidad de datos en las tablas.

- Todas las asignaturas.

<!-- ![Consulta todas las asignaturas](src/fig/lab1-4/consultas-1.png) -->

```sql
SELECT * 
	FROM Subjects s
;
```

- Asignatura con acrónimo `FP`.

<!-- ![Consulta acrónimo FP](src/fig/lab1-4/consultas-2.png) -->

```sql
SELECT * 
	FROM Subjects s
	WHERE s.acronym = 'FP'
;
```

- Nombres y acrónimos de todas las asignaturas.

<!-- ![Consulta nombres y acrónimos](src/fig/lab1-4/consultas-3.png) -->

```sql
SELECT s.name, s.acronym 
	FROM Subjects s
;
```

- Media de las notas del grupo con ID 18.

<!-- ![Consulta media grupo 18](src/fig/lab1-4/consultas-4.png) -->

```sql
SELECT AVG(g.value) 
	FROM Grades g
	WHERE g.groupId = 18
;
```

- Total de créditos de las asignaturas del grado de Tecnologías Informáticas (ID 3).

<!-- ![Consulta créditos TI](src/fig/lab1-4/consultas-5.png) -->

```sql
SELECT SUM(s.credits) 
	FROM Subjects s 
	WHERE s.degreeId = 3
;
```

- Notas con valor menor que 4 o mayor que 6.

<!-- ![Consulta notas <4 o >6](src/fig/lab1-4/consultas-6.png) -->

```sql
SELECT * 
	FROM Grades g
	WHERE g.value < 4 OR g.value > 6
;
```

- Nombres de grupos diferentes.

<!-- ![Consulta nombres grupos distintos](src/fig/lab1-4/consultas-7.png) -->

```sql
SELECT DISTINCT g.name 
	FROM Groups g
;
```

- Máxima nota del alumno con ID 1.

<!-- ![Consulta máxima nota alumno 1](src/fig/lab1-4/consultas-8.png) -->

```sql
SELECT MAX(g.value) 
	FROM Grades g
	WHERE g.studentId = 1
;
```

- Alumnos con un apellido igual al acrónimo de alguna asignatura.

<!-- ![Consulta apellido igual acrónimo](src/fig/lab1-4/consultas-9.png) -->

```sql
SELECT * 
	FROM Students st
	WHERE st.surname IN (SELECT sb.acronym FROM Subjects sb)
;
```

- IDs de alumnos del curso 2019.

<!-- ![Consulta IDs alumnos 2019](src/fig/lab1-4/consultas-10.png) -->

```sql
SELECT DISTINCT(gs.studentId) 
	FROM GroupsStudents gs
	WHERE gs.groupId IN (SELECT g.groupId FROM Groups g WHERE g.year = 2019)
;
```

- Alumnos con un DNI terminado en la letra C. Observe cómo `%` representa cualquier cantidad de caracteres.

<!-- ![Consulta DNI termina en C](src/fig/lab1-4/consultas-11.png) -->

```sql
SELECT *
	FROM Students s
	WHERE s.dni LIKE('%C')
;
```

- Alumnos con un nombre de 6 letras. Observe cómo `_` representa un caracter cualquiera.

<!-- ![Consulta nombre 6 letras](src/fig/lab1-4/consultas-12.png) -->

```sql
SELECT *
	FROM Students s
	WHERE s.firstName LIKE('______') -- 6 guiones bajos	
;
```

- Alumnos nacidos antes de 1995.

<!-- ![Consulta nacidos antes 1995](src/fig/lab1-4/consultas-13.png) -->

```sql
SELECT *
	FROM Students s
	WHERE YEAR(s.birthdate) < 1995
;
```

- Alumnos nacidos entre enero y febrero.

<!-- ![Consulta nacidos enero-febrero](src/fig/lab1-4/consultas-14.png) -->

```sql
SELECT *
	FROM Students s
	WHERE (MONTH(s.birthdate) >= 1 AND MONTH(s.birthdate) <= 2)
;
```

Observe cómo en las dos últimas consultas es posible incluir otra consulta dentro de la condición de la primera, en lugar de usar valores establecidos a mano.

## Ejercicios

Puede practicar las consultas implementando las siguientes:

- Nombre de las asignaturas que son obligatorias.
- Media de las notas del grupo con ID 19, usando el agregador `AVG`.
- La misma consulta anterior, sin usar `AVG`.
- Cantidad de nombres de grupo diferentes.
- Notas entre 4 y 6, inclusive.
- Notas con valor igual o superior a 9, pero que no son matrícula de honor. Cree una vista para las notas que son matrícula de honor.
