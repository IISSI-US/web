---
layout: single
sidebar:
  nav: labs-iissi-1
title: "Lab5 - Procedimientos, funciones y disparadores"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---
> [Versión PDF disponible](./index.pdf)


<!-- # Procedimientos, funciones y disparadores -->

## Objetivo

El objetivo de esta práctica es implementar disparadores y procedimientos en SQL. El alumno aprenderá a:

- Usar procedimientos y funciones para definir un conjunto de órdenes reutilizable.
- Usar disparadores para implementar restricciones complejas y reglas de negocio.

## Preparación del entorno

Conéctese a la base de datos "grados" y ejecute en ella los scripts de `pCreateDB` y `pPopulateDB` del Anexo B.

Cree un archivo `triggers.sql` para la escritura de los disparadores y un archivo `procedures.sql` para los procedimientos y funciones.

## Procedimientos

Un procedimiento es un conjunto de sentencias SQL a las que se les asigna un nombre y que reciben unos parámetros, de manera análoga a las funciones de otros lenguajes. La principal diferencia entre un procedimiento y una función en SQL es que los primeros no devuelven ningún valor, mientras que las segundas tienen un valor de retorno.

Generalmente, se emplean para definir un conjunto de instrucciones reutilizable que se espera emplear a menudo. Por ejemplo, para implementar el requisito funcional RF-002, por el cual se pide borrar las notas de un alumno con un DNI dado:

<!-- ![procedures-1](/assets/images/iissi1/laboratorios/fig/lab1-7/procedures-1.PNG) -->

```sql
-- RF-002: Borrar las notas de un alumno con un DNI dado
DELIMITER //
CREATE OR REPLACE PROCEDURE procDeleteGrades(studentDni CHAR(9))
BEGIN
	DECLARE id INT;
	SET id = (SELECT studentId s FROM Students s WHERE s.dni=studentDni);
	DELETE FROM Grades WHERE studentId=id;
END //
DELIMITER ;
```

Observe lo siguiente:

- En las instrucciones de código que forman parte del procedimiento (entre `BEGIN` y `END`), los puntos y coma pueden ser problemáticos, ya que el intérprete puede confundirlos con el fin del procedimiento. Para evitar esto, durante su definición **cambiamos el símbolo usado para delimitar instrucciones** a `//` mediante la sentencia `DELIMITER`. Al terminar de definir el procedimiento, reestablecemos `;` como delimitador.
- La primera instrucción, `CREATE OR REPLACE PROCEDURE`, **declara el procedimiento que se va a definir** y lo reemplaza si ya existe uno con ese nombre.
- Por consistencia, y para distinguirlos visualmente más facilmente de las funciones, todos los nombres de procedimientos que definamos **empezarán por `proc`**.
- Se indican los parámetros de entrada **entre paréntesis, incluyendo el tipo de los mismos**. Si hay más de un parámetro, éstos son separados por comas.
- Dentro de un procedimiento **se pueden declarar variables** mediante `DECLARE` incluyendo su tipo, y se les puede asignar un valor mediante `SET`. El valor a asignar puede ser el resultado de una consulta SQL.
- En este procedimiento, buscamos la ID del estudiante que tiene el DNI proporcionado, la almacenamos en una variable y eliminamos todas las notas del estudiante cuya ID hemos almacenado.

Los procedimientos almacenados pueden ser llamados mediante `CALL`, por ejemplo:

<!-- ![call-1](/assets/images/iissi1/laboratorios/fig/lab1-7/call-1.PNG) -->

```sql
CALL procDeleteGrades('12345678A');
```

A continuación, crearemos un procedimiento que borre todos los datos de la base de datos:

<!-- ![procedures-2](/assets/images/iissi1/laboratorios/fig/lab1-7/procedures-2.PNG) -->

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE procDeleteData()
BEGIN
	DELETE FROM Grades;
	DELETE FROM GroupsStudents;
	DELETE FROM Students;
	DELETE FROM Groups;
	DELETE FROM Subjects;
	DELETE FROM Degrees;
END //
DELIMITER ;
```

A modo de ejercicio, implemente el requisito funcional RF-001 para añadir la nota de un alumno en un grupo.

## Funciones

Las funciones son muy parecidas a los procedimientos, pero se diferencian de ellos en que las funciones sí pueden devolver valores, por lo que deben declarar su tipo de retorno. Las funciones SQL pueden usarse para obtener datos que requieran varias instrucciones SQL y se quieran consultar a menudo.

Mediante una función SQL podemos implementar el requisito funcional RF-007 para obtener la nota media de un alumno:

<!-- ![functions-1](/assets/images/iissi1/laboratorios/fig/lab1-7/functions-1.PNG) -->

```sql
DELIMITER //
CREATE OR REPLACE FUNCTION avgGrade(studentId INT) RETURNS DOUBLE
BEGIN
	DECLARE avgStudentGrade DOUBLE;
	SET avgStudentGrade = (SELECT AVG(value) FROM Grades
		WHERE Grades.studentId = studentId);
	RETURN avgStudentGrade;
END //
DELIMITER ;
```

Observe lo siguiente:

- El comienzo de la declaración es similar, sustituyendo `PROCEDURE` por `FUNCTION` e indicando los parámetros de entrada si los hay, pero se debe indicar el tipo que retorna la función mediante `RETURNS`.
- Al igual que en los procedimientos, se pueden declarar y asignar valores a variables mediante `DECLARE` y `SET`.
- Mediante la instrucción `RETURN` devolvemos el resultado. Puede devolverse una variable o el resultado de una consulta directamente.
- Como en los procedimientos, se debe realizar el cambio de delimitador para que el intérprete no confunda los `;` del interior de la función con el final de la misma.

Al contrario que los procedimientos, las funciones se pueden usar en cualquier lugar en el que se podría usar una variable, como consultas, o el cuerpo de procedimientos/funciones/disparadores. Para consultar el valor de una función, en lugar de usar `CALL`, podemos hacer una consulta `SELECT`:

<!-- ![functions-3](/assets/images/iissi1/laboratorios/fig/lab1-7/functions-3.PNG) -->

```sql
SELECT avgGrade(2);
```

![functions-4](/assets/images/iissi1/laboratorios/fig/lab1-7/functions-4.png)

También podemos consultarla como si fuera una columna más, por ejemplo, para obtener el nombre y los apellidos de un alumno junto con su nota media:

<!-- ![functions-2](/assets/images/iissi1/laboratorios/fig/lab1-7/functions-2.PNG) -->

```sql
SELECT s.firstName, s.surname, avgGrade(s.studentId) FROM Students s;
```

A modo de ejercicio, implemente el resto de requisitos funcionales del dominio:
- RF-003: Obtener un listado de alumnos por orden alfabético con nombre, apellidos, asignatura y grupo.
- RF-004: Obtener un listado de los alumnos cuyo método de acceso sea mayor de 40 años (Mayor).
- RF-005: Obtener las asignaturas (nombre, acrónimo, créditos y tipo) de un grado para un curso concreto ordenadas por el acrónimo.
- RF-006: Obtener, por DNI, las notas finales de cada asignatura que ha cursado un alumno, es decir, las de mayor año y convocatoria.
- RF-008: Obtener un listado de las asignaturas de un grado.

## Disparadores

Mediante los disparadores (triggers) podemos asociar la ejecución de código a la inserción, modificación, o borrado de filas en una tabla. Esto nos puede servir, por ejemplo, para comprobar restricciones complejas e implementar reglas de negocio. 

Como ejemplo, implementamos la regla de negocio RN-001, según la cual, para obtener matrícula de honor la nota debe ser mayor o igual a 9:

<!-- ![triggers-1](/assets/images/iissi1/laboratorios/fig/lab1-7/triggers-1.PNG) -->

```sql
DELIMITER //
CREATE OR REPLACE TRIGGER RN001_triggerWithHonours
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    IF (new.withHonours = 1 AND new.value < 9.0) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 
        'You cannot insert a grade with honours whose value is less than 9';
    END IF;
END//
DELIMITER ;
```

Observe lo siguiente:

- Se debe cambiar el delimitador al igual que en los casos anteriores.
- Mediante `BEFORE INSERT ON Grades` indicamos que el disparador debe ejecutarse **justo antes de insertar filas** en la tabla Grades. Podríamos sustituir `BEFORE` por `AFTER`, pero en este caso, para cuando se lanzara el disparador, la nota ya habría sido insertada.
- En vez de `INSERT` podrían usarse `UPDATE` o `DELETE` para vincular disparadores a la actualización o borrado de filas, respectivamente.
- Con un `INSERT` podríamos insertar varias filas a la vez. Algo similar ocurre con `UPDATE` y `DELETE`. Con `FOR EACH ROW` indicamos que el disparador debe ejecutarse **por cada fila afectada**.
- Con `new` hacemos referencia a **la fila que está siendo insertada**, tanto si el disparador se ejecuta antes como después de insertarla.
- Mediante `SIGNAL` podemos hacer que se produzcan errores, **cancelándose la inserción de la fila**. El número después de `SQLSTATE` corresponde al código de error. Existe [una gran cantidad de códigos de error](https://mariadb.com/docs/server/reference/error-codes/mariadb-error-code-reference), aunque el usual para los errores personalizados es 45000. Con `SET message_text` indicamos cuál es el mensaje del error. Es muy útil incluir un mensaje **tan descriptivo como sea posible**.
- Sería conveniente que se hiciera la comprobación no sólo al insertar una nota, sino al actualizarla. Para que sea así, habría que repetir el trigger, cambiando el nombre y sustituyendo `INSERT` por `UPDATE`.

Como buena práctica, podemos encapsular la funcionalidad del disparador en un procedimiento y crear un disparador para cada una de las operaciones que queramos que se cubran: INSERT y UPDATE:

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE pWithHonours
(withHonours INT, value DECIMAL(4,2))
BEGIN
    IF (withHonours = 1 AND value < 9.0) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 
        'A grade with honours can not have a value less than 9';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER RN001I_triggerWithHonours
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    CALL pWithHonours(new.withHonours, new.value);
END//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER RN001U_triggerWithHonours
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    CALL pWithHonours(new.withHonours, new.value);
END//
DELIMITER ;
```

El disparador anterior es simple, ya que solo contiene la comprobación de un valor y el lanzamiento de un error. Implementemos ahora un disparador que implementa la regla de negocio RN-004, por la que no se puede poner a un alumno una nota en un grupo al que no pertenece:

<!-- ![triggers-2](/assets/images/iissi1/laboratorios/fig/lab1-7/triggers-2.PNG) -->

```sql
DELIMITER //
CREATE OR REPLACE TRIGGER RN004_triggerGradeStudentGroup
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    DECLARE isInGroup INT;
    SET isInGroup = (SELECT COUNT(*) 
        FROM GroupsStudents
            WHERE studentId = new.studentId AND groupId = new.groupId);
    IF(isInGroup < 1) THEN
        SIGNAL SQLSTATE '45000' SET message_text = 
    	    'A student cannot have grades for groups in which they are not registered';
    END IF;
END//
DELIMITER ;
```

Pruebe el disparador anterior y observe lo siguiente:

- Se pueden declarar y asignar variables mediante `DECLARE` y `SET` al igual que en los procedimientos y funciones.
- En este caso, buscamos el número de asignaciones a grupos que coinciden con el estudiante y el grupo al que se está intentando asignar la nota. Si no hay ninguna, es porque el estudiante no está en ese grupo, y se lanza un error.

Como ejercicio, modifique el disparador anterior para que use un procedimiento y defina disparadores tanto para la inserción como para la actualización de filas.

A continuación creamos un disparador que implementa la regla de negocio RN-005: cada vez que se actualice una nota, comprueba si ésta se ha subido en más de 4 puntos. En ese caso, se muestra un error con el nombre del estudiante y la diferencia de la nota nueva con respecto a la antigua:

<!-- ![triggers-3](/assets/images/iissi1/laboratorios/fig/lab1-7/triggers-3.PNG) -->

```sql
DELIMITER //
CREATE OR REPLACE TRIGGER RN005_triggerGradesChangeDifference
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    DECLARE difference DECIMAL(4,2);
    DECLARE student ROW TYPE OF Students;
    SET difference = new.value - old.value;
    IF(difference > 4) THEN
        SELECT * INTO student FROM Students WHERE studentId = new.studentId;
        SET @error_message = CONCAT('You cannot add ', difference, 
            ' points to a grade for the student',
            student.firstName, ' ', student.surname);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_message;
    END IF;
END//
DELIMITER ;
```

Observe lo siguiente:

- En este caso no se ha asignado el disparador a la inserción de filas, sino a la modificación de una fila, mediante `BEFORE UPDATE ON`.
- Una de las variables declaradas tiene como tipo una fila de la tabla Students, indicado mediante `ROW TYPE OF`. Así, podemos acceder a cualquier atributo del estudiante que almacenemos en esa variable.
- Se le asigna un valor mediante una consulta `SELECT` que sabemos que sólo devolverá una fila.
- La asignación en el caso de variables que representan filas se debe hacer de una forma diferente: incluyendo `INTO student` dentro de la consulta.
- Podemos hacer referencia a la fila tanto antes de la actualización (`new`) como después (`old`).
- Para crear un mensaje personalizado que requiera concatenar varias partes, usamos `CONCAT`. Como `CONCAT` no se puede usar en la misma instrucción en la que lanzamos el error, creamos primero el mensaje en una variable y luego lo usamos.
- La variable en la que hemos guardado el mensaje no se ha declarado antes, y tiene en su nombre el símbolo '@'. Si se usa una variable de esta forma, en vez de ser una variable local es una variable a nivel de usuario, que sigue existiendo y teniendo el mismo valor fuera del disparador. La hemos usado por comodidad a la hora de guardar y usar rápidamente el mensaje de error.

Podemos probar el disparador intentando subir una nota más de 4 puntos:

<!-- ![triggers-error-1](/assets/images/iissi1/laboratorios/fig/lab1-7/triggers-error-1.PNG) -->

A continuación, modificaremos el último disparador para que, en vez de lanzarse un error, la nota sólo sea aumentada en 4 puntos:

<!-- ![triggers-4](/assets/images/iissi1/laboratorios/fig/lab1-7/triggers-4.PNG) -->

```sql
DELIMITER //
CREATE OR REPLACE TRIGGER RN005_triggerGradesChangeDifference
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    DECLARE difference DECIMAL(4,2);
    SET difference = new.value - old.value;
    IF(difference > 4) THEN
        SET new.value = old.value + 4;
    END IF;
END//
DELIMITER ;
```

Pruebe el disparador anterior y observe cómo se puede reemplazar el valor de los atributos siendo actualizados con `new`.

Finalmente, implemente las reglas de negocio:
- RN-003, que evita que un alumno que accede por selectividad tenga menos de 16 años.
- RN-006, que evita que un grupo de teoría tenga mas de 75 alumnos y uno de laboratorio más de 25.
- RN-007, que evita que un alumno pertenezca a más de un grupo de teoría y a más de un grupo de laboratorio de la misma asignatura.
