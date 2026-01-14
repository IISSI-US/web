---
layout: single
sidebar:
  nav: labs-iissi-1
title: "Lab8 - Transacciones"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---

<!-- # Transacciones -->

## Objetivo
El objetivo de esta práctica es implementar transacciones en SQL. El alumno aprenderá a:

- Activar/desactivar el `AUTOCOMMIT`.
- Control de transacciones en procedimientos almacenados.
- Diferenciar entre procedimientos transaccionales o no transaccionales.

---

## AUTOCOMMIT
En primer lugar vamos a ilustrar el concepto de transacción como Unidad Lógica de Trabajo. MariaDB, por defecto, fuerza un COMMIT automático después de cada instrucción. Esto está controlado por la variable de entorno `AUTOCOMMIT`, que por defecto está en `ON` (`AUTOCOMMIT=1`).

![AUTOCOMMIT]({{ '/assets/images/iissi1/laboratorios/fig/lab1-8/autocommit.png' | relative_url }})

Para manejar transacciones que agrupan modificaciones sobre la BD emitiendo varias sentencias es necesario desactivar esta opción, con el comando `SET AUTOCOMMIT=0`, además de controlar el inicio de la transacción, con la instrucción `START TRANSACTION`, y la terminación confirmando (`COMMIT` o `COMMIT WORK`) o cancelando (`ROLLBACK` o `ROLLBACK WORK`). Hay que tener en cuenta que, estando en una transacción activa, si se produce una excepción grave (`SQLEXCEPTION`) y no se controla mediante código, entonces la transacción abortaría (`ROLLBACK` implícito).

Para comprobar que por defecto cada instrucción se realiza por separado, es suficiente con ejecutar un fragmento de código que incluya algunas que se realicen satisfactoriamente y otras que no. Por ejemplo, el siguiente código que introduce varias notas, siendo la tercera errónea. Al terminar de ejecutarse, puede observarse que las dos primeras notas sí se han introducido:

```sql
SET AUTOCOMMIT=1;
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(4.50, 3, 0, 1, 1);
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(7.50, 1, 0, 1, 3);
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(-7.50, 1, 0, 2, 2);
```

Si queremos que todas las instrucciones se ejecuten en una transacción, debemos desactivar la opción `AUTOCOMMIT` y colocar el código dentro de una transacción:

```sql
SET AUTOCOMMIT=0;
START TRANSACTION;
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(4.50, 3, 0, 1, 1);
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(7.50, 1, 0, 1, 3);
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(-7.50, 1, 0, 2, 2);
COMMIT;
```

Sin embargo, se está ejecutando un script SQL sin código para el control de excepciones, por lo que la ejecución sigue, quedando la transacción activa incluso si se produce un error. Incluso si terminamos el bloque con `ROLLBACK WORK`, el error producido evitará que se siga ejecutando código, y no se evitará que se introduzcan las dos primeras notas. Para lograr el resultado deseado (que solo se realice el bloque de instrucciones si no hay errores, y que se deshagan todos los cambios si se producen), es necesario colocar el código SQL dentro de un procedimiento.

---

## Control de transacciones en un procedimiento SQL almacenado

En este apartado se maneja un procedimiento almacenado SQL que maneja una transacción y controla excepciones (`SQLEXCEPTIONS` o `WARNINGS`). Para ello crearemos un procedimiento almacenado que inserta un nuevo grado y una nueva asignatura en la base de datos asociada al nuevo grado. Deseamos que si ocurre algún error no se inserte ni el grado ni la asignatura. Sin embargo, con una versión inicial podemos confirmar que este no es el caso. Por ejemplo, si el nombre de la asignatura está repetido, el grado seguirá insertado:

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE pInsertDegreeSubject(
    degreeName VARCHAR(60), 
    degreeYears INT, 
    subjectName VARCHAR(100), 
    subjectAcronym VARCHAR(8), 
    subjectCredits INT, 
    subjectYear INT, 
    subjectType VARCHAR(20)
)
BEGIN
    DECLARE newDegreeId INT;
    INSERT INTO Degrees (name, years) VALUES (degreeName, degreeYears);
    SET newDegreeId = (SELECT degreeId FROM Degrees WHERE name=degreeName);
    INSERT INTO Subjects (degreeId, name, acronym, credits, year, type)
        VALUES (newDegreeId, subjectName, subjectAcronym, subjectCredits, subjectYear, subjectType);
END //
DELIMITER ;

CALL pInsertDegreeSubject('Nuevo Grado', 4, 'Lógica Informática', 'LI', 60, 3, 'Obligatoria');
```

A continuación, creamos un nuevo procedimiento transaccional desde donde se llama al anterior procedimiento de inserción de grado y asignatura, de forma que si se produce un error, se realizará un rollback:

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE pNewDegreeSubjectTransactional(
    degreeName VARCHAR(60), 
    degreeYears INT, 
    subjectName VARCHAR(100), 
    subjectAcronym VARCHAR(8), 
    subjectCredits INT, 
    subjectYear INT, 
    subjectType VARCHAR(20)
)
BEGIN
    START TRANSACTION;
    tblock: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;
        CALL pInsertDegreeSubject(degreeName, degreeYears, subjectName, subjectAcronym,
		subjectCredits, subjectYear, subjectType);
        COMMIT;
    END tblock;
END //
DELIMITER ;

CALL pNewDegreeSubjectTransactional('Nuevo Grado', 4, 'Lógica Informática', 'LI', 60, 3, 'Obligatoria');
```

Observe lo siguiente:
- Si se realiza la misma llamada al procedimiento con datos erróneos, no se introduce ni el grado ni la asignatura.
- El contenido del procedimiento se ha introducido en un bloque denominado "tblock". Esto es necesario para poder definir qué hacer en caso de error.
- Mediante `DECLARE EXIT HANDLER` se define cómo tratar excepciones que se produzcan. En nuestro caso, hacemos rollback y dejamos que la excepción se lance.
- Solo si se llega al final de la transacción se hace commit.

---

## Transacciones concurrentes

El uso de forma conjunta de HeidiSQL y Silence nos permite observar cómo los cambios no se hacen efectivos fuera de la transacción hasta que se hace commit.

Reinicie la base de datos y ejecute el siguiente código para iniciar una transacción e insertar dos notas sin llegar a cerrar la transacción:

```sql
SET AUTOCOMMIT=0; 
START TRANSACTION;
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(4.50, 3, 0, 1, 1);
INSERT INTO Grades (value, gradeCall, withHonours, studentId, groupId) VALUES
	(7.50, 1, 0, 1, 3);
SELECT * FROM Grades;
```

Observe que los resultados obtenidos por la consulta incluyen las notas añadidas justo antes:

![Resultados]({{ '/assets/images/iissi1/laboratorios/fig/lab1-8/resultados.png' | relative_url }})

Sin realizar commit, use Silence para pedir un listado de las notas mediante la consulta `GET {{BASE}}/grades`. Observe cómo las notas nuevas no aparecen en el listado. Ya que no se ha hecho commit, los cambios son solo visibles dentro de la transacción, mientras que fuera de ella (es decir, en otras transacciones) la base de datos permanece igual que antes de comenzar la transacción.

Por último, ejecute la instrucción `COMMIT` en SQL y vuelva a realizar la petición http. Observe que ahora sí aparecen las nuevas notas al haberse realizado los cambios de la transacción.


> [Versión PDF disponible](./index.pdf)
