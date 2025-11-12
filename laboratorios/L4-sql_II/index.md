---
layout: single
title: "Lab4 - Consultas avanzadas"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
---

<!-- # Consultas avanzadas -->

## Objetivo

El objetivo de esta práctica es realizar consultas `SELECT` avanzadas en las que sean necesarios nuevos comandos. El alumno aprenderá a:

- Usar `ORDER BY`, `LIMIT` y `OFFSET` para devolver filas ordenadas, limitadas, y con paginación.
- Usar `JOIN` para agregar columnas de varias tablas.
- Usar `GROUP BY` para agrupar filas.

## Preparación del entorno

Conéctese a la base de datos "grados" y ejecute los scripts `pCreateDB` y `pPopulateDB` del Anexo B.

Cree un archivo `queries-2.sql` para la escritura de las consultas.

## ORDER BY, LIMIT, y OFFSET

Las consultas hasta ahora han devuelto las filas ordenadas según el orden en el que fueron almacenadas. Si queremos ordenarlas podemos usar `ORDER BY`. Obtenemos las notas ordenadas por valor (de menor a mayor) de la siguiente manera:

<!-- ![consultas-1](src/fig/lab1-5/consultas-1.png) -->

```sql
SELECT * 
   FROM Grades g
   ORDER BY g.value
;
```

Podemos realizar consultas más sofisticadas. Por ejemplo, obtenemos las notas aprobadas, ordenadas por el apellido del alumno que las obtuvo en orden inverso:

<!-- ![consultas-2](src/fig/lab1-5/consultas-2.png) -->

```sql
SELECT * 
   FROM Grades g
   WHERE g.value >= 5
	ORDER BY (SELECT s.surname
	         FROM Students s
	         WHERE s.studentId = g.studentId) 
	DESC
;
```

Observe lo siguiente:

- `ORDER BY` se coloca después de `WHERE`, si lo hay. Si no, donde iría `WHERE`.
- En `ORDER BY` podemos usar cualquier expresión aplicable a una fila, incluso otras consultas que devuelvan un valor.
- El orden es ascendente (`ASC`) por defecto. Si queremos que sea descendente, tenemos que incluir `DESC`. 

En muchas ocasiones, no es necesario obtener todas las filas resultantes de una consulta, sino solo unas pocas (por ejemplo, porque se muestre una página con unos pocos resultados). Para limitar los resultados obtenidos, usamos `LIMIT`. Obtenemos las 5 mejores notas:

<!-- ![consultas-3](src/fig/lab1-5/consultas-3.png) -->

```sql
SELECT * 
	FROM Grades g
	ORDER BY g.value DESC
	LIMIT 5
;
```

Podemos indicar también que queremos las primeras filas a partir de una posición. Por ejemplo, si queremos paginar las notas, y queremos obtener la segunda página de 5 notas, usamos la siguiente consulta:

<!-- ![consultas-4](src/fig/lab1-5/consultas-4.png) -->

```sql
SELECT * 
	FROM Grades g
	ORDER BY g.value DESC
	LIMIT 5 OFFSET 5
;
```

Observe cómo a `OFFSET` no se le indica una página, sino el número de filas a partir de las cuales se empiezan a devolver resultados. Si quisiéramos la tercera página (con 5 notas por página), sería `OFFSET 10`.

## JOIN

Hasta ahora, las consultas `SELECT` han involucrado una tabla (indicada con `FROM`). Si indicamos varias tablas se obtiene el producto cartesiano, es decir, todas las posibles combinaciones de filas entre las tablas:

<!-- ![consultas-5](src/fig/lab1-5/consultas-5.png) -->

```sql
SELECT * FROM Groups, GroupsStudents, Students;
```

Ejecute la query anterior. El resultado contiene todas las columnas de las tablas y 6048 filas, correspondientes a todas las posibles combinaciones de filas de las tablas. Normalmente se desean las combinaciones de filas que están relacionadas por alguna columna, normalmente una que es clave primaria en una tabla y ajena en la otra. De esta forma podemos ampliar las filas de una tabla con columnas de otra.

Para obtener la unión de filas de tablas diferentes a partir de uno o varios atributos, usamos `JOIN`:

<!-- ![consultas-6](src/fig/lab1-5/consultas-6.png) -->

```sql
SELECT *
	FROM GROUPS g
	JOIN GroupsStudents gs ON (g.groupId = gs.groupId)
	JOIN Students s ON (gs.studentId = s.studentId)
;
```

Observe lo siguiente:

- Indicamos la tabla cuya información hay que unir a las filas, seguido de cómo se unirán las filas.
- Al haber varias tablas con columnas del mismo nombre, siempre debemos indicar la tabla de la que proviene la columna. En este caso, da igual si usamos una u otra tabla en cada unión.
- Pueden unirse varias tablas a la vez.
- Si un grupo no tiene alumnos, no aparecerá. Igualmente, si un alumno no tiene grupos, no aparecerá. Pueden usarse variantes de `JOIN` para que se devuelvan todas las filas de una tabla añadiendo, **si la hay**, información de la otra. Son los comandos `LEFT JOIN`, `RIGHT JOIN` y similares, consultables en [la página de MariaDB](https://mariadb.com/docs/server/mariadb-quickstart-guides/mariadb-join-guide).

Cuando se quieren unir tablas que tienen un nombre de columna en común, en lugar de especificar manualmente las columnas sobre las que se realiza la operación `JOIN`, se puede usar en su lugar `NATURAL JOIN`, que realiza la operación automáticamente. Ésto es especialmente útil para unir dos o más tablas mediante relaciones de claves ajenas, ya que tienen el mismo nombre en ambas tablas relacionadas.

Así, la consulta anterior se puede escribir como:

<!-- ![consultas-7](src/fig/lab1-5/consultas-7.png) -->

```sql
SELECT *
	FROM Groups
	NATURAL JOIN GroupsStudents 
	NATURAL JOIN Students
;
```

## GROUP BY

Algunas de las consultas realizadas hasta ahora obtenían valores agregados mediante comandos como `MAX`, `COUNT`, o `AVG`. De esta forma, podíamos obtener un solo máximo, mínimo, etc. Sin embargo, puede ser necesario obtener varias medidas agregadas correspondientes a varios grupos. Para ello usamos `GROUP BY`. Para obtener la nota media de cada alumno junto con su nombre y apellidos, realizamos la siguiente consulta:

<!-- ![consultas-8](src/fig/lab1-5/consultas-8.png) -->

```sql
SELECT s.firstName, s.surname, AVG(g.value)
	FROM Students s
	JOIN Grades g ON (s.studentId = g.studentId)
	GROUP BY s.studentId
;
```

Observe lo siguiente:

- Indicamos con `GROUP BY` el criterio por el que formar grupos.
- Los atributos a seleccionar se seleccionarán por cada grupo. Los atributos no agregados se tomarán de la primera fila del grupo.
- Como sabemos que el nombre y el apellido de los alumnos de cada grupo de filas es el mismo, es correcto pedirlos.

A continuación, realizamos una petición que obtenga la nota media en cada convocatoria de cada asignatura de 2018, teniendo en cuenta solo los aprobados:

<!-- ![consultas-9](src/fig/lab1-5/consultas-9.png) -->

```sql
CREATE OR REPLACE VIEW ViewSubjectGrades AS
	SELECT st.studentId, st.firstName, st.surname,
	  sb.subjectId, sb.name, gd.value, gd.gradeCall, 
	  gp.year
	FROM Students st
	JOIN Grades gd ON (st.studentId = gd.studentId)
	JOIN Groups gp ON (gd.groupId = gp.groupId)
	JOIN Subjects sb ON (gp.subjectId = sb.subjectId)
;

SELECT v.gradeCall, v.name, AVG(v.value)
	FROM ViewSubjectGrades v
	WHERE v.value >= 5 AND v.year = 2018
	GROUP BY v.gradeCall, v.subjectId
;
```

Observe lo siguiente:

- No existe ninguna tabla que contenga las notas de cada alumno en cada asignatura, ya que las notas están asociadas a grupos, y los grupos a asignaturas. En vez de crear una consulta muy complicada, creamos primero una vista que junte la información de varias tablas para disponer cómodamente de las notas de cada alumno en cada asignatura.
- Podemos filtrar las filas antes de agruparlas.
- Podemos agrupar según dos criterios, de manera que los grupos se crearán con filas que tengan el mismo valor en todos los atributos especificados.

Por último, obtenemos la nota media de las asignaturas con más de 2 notas (en todos los años):

<!-- ![consultas-10](src/fig/lab1-5/consultas-10.png) -->

```sql
SELECT v.name, AVG(v.value), COUNT(*)
	FROM ViewSubjectGrades v
	GROUP BY v.name
	HAVING COUNT(*) > 2
;
```

Observe cómo filtramos los grupos con una condición en `HAVING`. No lo confunda con `WHERE`, que filtra las filas **antes de agruparlas**.

## Consultas varias

- Número de alumnos nacidos en cada año.

```sql
SELECT YEAR(s.birthdate), COUNT(*)
  FROM Students s
  GROUP BY YEAR(s.birthdate)
;
```

- Número de alumnos por grado en el curso 2019.

```sql
-- Vista con los estudiantes de cada grado
CREATE OR REPLACE VIEW ViewDegreeStudents AS
	SELECT Students.*, Degrees.*, Groups.year
	FROM Students
	JOIN GroupsStudents ON (Students.studentId = GroupsStudents.studentId)
	JOIN Groups ON (GroupsStudents.groupId = Groups.groupId)
	JOIN Subjects ON (Groups.subjectId = Subjects.subjectId)
	JOIN Degrees ON (Subjects.degreeId = Degrees.degreeId)
;
	
SELECT name, COUNT(DISTINCT(studentId))
	FROM ViewDegreeStudents
	WHERE year = 2019
	GROUP BY degreeId
;
```

- Nota máxima de cada alumno, con el nombre y apellidos.

```sql
SELECT v.firstName, v.surname, MAX(v.value)
	FROM ViewSubjectGrades v
	GROUP BY v.studentId
;
```

- Nombre y número de grupos de teoría de las 3 asignaturas con mayor número de grupos de teoría en el año 2019.

```sql
-- Vista con los grupos de cada asignatura
CREATE OR REPLACE VIEW ViewSubjectGroups AS
	SELECT sb.*, gp.name AS groupName, gp.activity, gp.year AS groupYear
	FROM Subjects sb JOIN Groups gp ON (sb.subjectId = gp.subjectId)
;

SELECT v.name, COUNT(*)
	FROM ViewSubjectGroups v
	WHERE v.groupYear = 2019 AND v.activity = 'Teoria'
	GROUP BY v.subjectId
	ORDER BY COUNT(*) DESC LIMIT 3
;
```

- Nombre y apellidos de alumnos por año que tuvieron una nota media mayor que la nota media del año.

```sql
-- Vista con la nota media anual
CREATE OR REPLACE VIEW ViewAvgGradesYear AS
	SELECT v.year, AVG(v.value) AS average
	FROM ViewSubjectGrades v
	GROUP BY v.year
;
	
SELECT v.firstName, v.surname, v.year AS yearAvg, AVG(v.value) AS studentAverage
	FROM ViewSubjectGrades v
	GROUP BY v.studentId, v.year
	HAVING (studentAverage > (SELECT vAvg.average 
		FROM ViewAvgGradesYear vAvg
		WHERE vAvg.year = yearAvg)
);
```

- Nombre de asignaturas que pertenecen a un grado con más de 4 asignaturas.

```sql
-- Vista con el numero de asignaturas de cada grado
CREATE OR REPLACE VIEW ViewDegreeNumSubjects AS
	SELECT s.degreeId, COUNT(*) AS numSubjects
	FROM Subjects s
	GROUP BY s.degreeId
;

SELECT name 
	FROM Subjects sb
	JOIN ViewDegreeNumSubjects v ON (sb.degreeId = v.degreeId)
	WHERE v.numSubjects > 4
;
```

## Ejercicios

Puede practicar las consultas implementando las siguientes:

- Número de suspensos de cada alumno, dando nombre y apellidos.
- La tercera página de 3 grupos, ordenados según su año por orden descendente.
- Un listado de los grupos, añadiendo el acrónimo de la asignatura a la que pertenecen y el nombre del grado.
- Número de métodos de acceso diferentes de los alumnos de cada grupo, dando el id del grupo.
- Nota ponderada por créditos de cada alumno, dando nombre y apellidos, del curso 2019 en la primera convocatoria. Pista: modifique la vista ViewSubjectGrades añadiendo el atributo que falta. La nota ponderada es igual a la suma de cada nota multiplicada por los créditos de su asignatura, dividida entre la suma de todos los créditos de las asignaturas.

