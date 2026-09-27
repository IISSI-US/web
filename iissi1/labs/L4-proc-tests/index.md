---
layout: single
sidebar:
  nav: labs-iissi-1
title: "Lab4 - Procedimientos almacenados y Tests SQL"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---
> [Versión PDF disponible](./index.pdf)


<!-- # Procedimientos almacenados y Tests SQL -->

## Objetivo

El objetivo de esta práctica es aprender a crear procedimientos almacenados en MariaDB y diseñar tests automatizados para validar las reglas de negocio implementadas en la base de datos. El alumno aprenderá a:

- Crear y ejecutar procedimientos almacenados.
- Usar parámetros de entrada (IN) y salida (OUT).
- Implementar lógica de control con manejadores de excepciones (EXCEPTION HANDLER).
- Diseñar tests negativos para validar restricciones.
- Crear tablas de resultados para almacenar el estado de los tests.
- Implementar procedimientos orquestadores para ejecutar baterías de tests.

Los procedimientos almacenados permiten encapsular lógica de negocio en el servidor de base de datos. Los tests automatizados garantizan que las reglas de negocio se cumplan correctamente y facilitan la detección temprana de errores.

## Preparación del entorno

Abre HeidiSQL y conéctate con el usuario `iissi_user` a la base de datos `GradesDB`. Asegúrate de haber ejecutado previamente los scripts `createDB.sql` y `populateDB.sql` de los laboratorios anteriores.

Crea un nuevo archivo `tests_constraints.sql` en tu repositorio donde implementarás los tests de este laboratorio.

## Control de versiones

Continuaremos trabajando con el repositorio `GradesDB` creado en L1. 

**Al inicio del laboratorio**, añade el archivo de tests y haz commit:

```bash
git add tests_constraints.sql
git commit -m "Añadido archivo tests_constraints.sql para L4"
```

**Al finalizar el laboratorio**, haz push al repositorio remoto:

```bash
git add tests_constraints.sql
git commit -m "Completado L4: Tests SQL para validación de reglas de negocio"
git push origin main
```

## Variables y parámetros en SQL

Antes de trabajar con procedimientos almacenados, es fundamental comprender los diferentes tipos de variables y parámetros que podemos usar en SQL, así como las convenciones de nomenclatura que emplearemos en este laboratorio.

### Variables locales (DECLARE)

Las variables locales se declaran dentro de procedimientos, funciones o bloques BEGIN...END mediante la palabra clave `DECLARE`. Estas variables:

- Solo existen dentro del bloque donde se declaran.
- Se destruyen al finalizar la ejecución del procedimiento o bloque.
- Deben declararse al principio del bloque, antes de cualquier instrucción ejecutable.
- Requieren especificar el tipo de dato (INT, VARCHAR, DECIMAL, etc.).

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE ejemplo_variables_locales()
BEGIN
    DECLARE v_contador INT DEFAULT 0;
    DECLARE v_nombre VARCHAR(100);
    DECLARE v_promedio DECIMAL(4,2);
    
    -- Asignar valores
    SET v_contador = 10;
    SELECT first_name INTO v_nombre FROM people WHERE person_id = 1;
    
    SELECT v_contador, v_nombre;
END //
DELIMITER ;
```

### Variables de usuario (@variable)

Las variables de usuario se identifican con el prefijo `@` y tienen características diferentes:

- Existen durante toda la sesión del usuario (persisten entre llamadas).
- No necesitan ser declaradas explícitamente.
- Se crean automáticamente al asignarles un valor.
- Pueden usarse fuera de procedimientos almacenados.
- Útiles para pasar valores entre procedimientos o para almacenar resultados.

```sql
-- Asignar valor directamente
SET @resultado = 100;

-- Asignar desde una consulta
SELECT AVG(grade_value) INTO @promedio_general FROM grades;

-- Usar en procedimientos
CALL p_student_average(6, @promedio_estudiante);

-- Consultar el valor
SELECT @promedio_estudiante;
```

### Parámetros de procedimientos

Los procedimientos pueden recibir parámetros de tres tipos:

**IN (entrada)**: Valores que se pasan al procedimiento. No pueden ser modificados por el procedimiento (o si se modifican, los cambios no se reflejan fuera).

```sql
CREATE OR REPLACE PROCEDURE ejemplo_in(
    IN p_student_id INT
)
BEGIN
    SELECT * FROM students WHERE student_id = p_student_id;
END;
```

**OUT (salida)**: Variables que el procedimiento usa para devolver valores. El valor inicial se ignora.

```sql
CREATE OR REPLACE PROCEDURE ejemplo_out(
    IN p_student_id INT,
    OUT p_average DECIMAL(4,2)
)
BEGIN
    SELECT AVG(grade_value) INTO p_average
    FROM grades
    WHERE student_id = p_student_id;
END;
```

**INOUT (entrada/salida)**: Combinación de ambos. El procedimiento recibe un valor y puede modificarlo.

```sql
CREATE OR REPLACE PROCEDURE ejemplo_inout(
    INOUT p_contador INT
)
BEGIN
    SET p_contador = p_contador + 1;
END;
```

### Convenciones de nomenclatura

Para mantener el código legible y organizado, seguiremos estas convenciones:

| Prefijo | Uso | Ejemplo | Descripción |
|---------|-----|---------|-------------|
| `v_` | Variables locales (DECLARE) | `v_student_id`, `v_total`, `v_name` | Variables declaradas dentro de procedimientos |
| `@` | Variables de usuario | `@result`, `@avg_grade` | Variables que persisten en la sesión |
| `p_` | Parámetros | `p_student_id`, `p_average`, `p_dni` | Parámetros IN, OUT o INOUT de procedimientos |

**Ejemplo completo aplicando las convenciones:**

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE p_calculate_and_store(
    IN p_student_id INT,          -- Parámetro de entrada
    OUT p_result DECIMAL(4,2)     -- Parámetro de salida
)
BEGIN
    DECLARE v_count INT;           -- Variable local
    DECLARE v_sum DECIMAL(6,2);    -- Variable local
    
    -- Contar notas del estudiante
    SELECT COUNT(*), SUM(grade_value) 
    INTO v_count, v_sum
    FROM grades
    WHERE student_id = p_student_id;
    
    -- Calcular promedio
    IF v_count > 0 THEN
        SET p_result = v_sum / v_count;
    ELSE
        SET p_result = 0;
    END IF;
    
    -- Guardar en variable de usuario para uso posterior
    SET @last_calculation = p_result;
END //
DELIMITER ;

-- Uso del procedimiento
CALL p_calculate_and_store(6, @average);
SELECT @average AS 'Promedio', @last_calculation AS 'Última calculada';
```

**Ventajas de estas convenciones:**

- **Claridad**: Se identifica fácilmente el origen y alcance de cada variable.
- **Mantenibilidad**: El código es más fácil de entender y modificar.
- **Prevención de errores**: Se evitan confusiones entre variables locales, parámetros y variables de usuario.
- **Consistencia**: Todo el código sigue el mismo estilo.

## Procedimientos almacenados: Conceptos básicos

Un procedimiento almacenado es un conjunto de instrucciones SQL que se almacenan en el servidor de base de datos con un nombre específico y que pueden ser ejecutadas mediante una llamada `CALL`. Los procedimientos pueden:

- Recibir parámetros de entrada (IN), salida (OUT) o entrada/salida (INOUT).
- Ejecutar consultas SQL complejas.
- Implementar lógica de control de flujo (IF, WHILE, CASE, etc.).
- Devolver resultados mediante SELECT, aunque no los usaremos con este propósito en la asignatura.
- Lanzar excepciones y manejar errores.

### Sintaxis básica

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE nombre_procedimiento(
    IN param1 TIPO,
    IN param2 TIPO,
    OUT resultado TIPO
)
BEGIN
    -- Cuerpo del procedimiento
    -- Instrucciones SQL
END //
DELIMITER ;
```

**Observe lo siguiente:**

- `DELIMITER //` cambia el delimitador de sentencias de `;` a `//` para permitir usar `;` dentro del procedimiento.
- `CREATE OR REPLACE PROCEDURE` crea el procedimiento o lo reemplaza si ya existe.
- `IN`, `OUT`, `INOUT` especifican el tipo de parámetro.
- El cuerpo va entre `BEGIN` y `END`.
- Se restaura el delimitador con `DELIMITER ;` al final.

### Ejemplo 1: Procedimiento para borrar notas de un alumno (RF-002)

Este procedimiento borra todas las notas de un estudiante dado su DNI. Muestra cómo usar variables locales y consultas dentro de un procedimiento.

{% include sql-embed.html src='_code/grades/p_delete_student_grades.sql' label='p_delete_student_grades.sql' collapsed=false %}

**Para ejecutarlo:**

```sql
-- Borrar las notas del estudiante con DNI '10000006F'
CALL p_delete_student_grades('10000006F');

-- Verificar que se borraron
SELECT * FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE p.dni = '10000006F';
```

**Observe lo siguiente:**

- Se declara una variable local `v_student_id` mediante `DECLARE` incluyendo su tipo.
- Se le asigna un valor mediante una consulta `SELECT ... INTO`. El valor asignado es el resultado de la consulta.
- La variable se usa posteriormente en la instrucción `DELETE` para borrar las notas del estudiante.
- En las instrucciones de código que forman parte del procedimiento (entre `BEGIN` y `END`), los puntos y coma pueden ser problemáticos, ya que el intérprete puede confundirlos con el fin del procedimiento. Para evitar esto, durante su definición **cambiamos el símbolo usado para delimitar instrucciones** a `//` mediante la sentencia `DELIMITER`. Al terminar de definir el procedimiento, reestablecemos `;` como delimitador.

### Ejemplo 2: Procedimiento para borrar todos los datos

Este procedimiento borra todos los datos de la base de datos respetando el orden de dependencias entre tablas. Es útil para limpiar la base de datos durante pruebas.

{% include sql-embed.html src='_code/grades/p_delete_all_data.sql' label='p_delete_all_data.sql' collapsed=false %}

**Para ejecutarlo:**

```sql
-- Borrar todos los datos (¡cuidado con esta operación!)
CALL p_delete_all_data();

-- Verificar que las tablas están vacías
SELECT COUNT(*) AS total_grades FROM grades;
SELECT COUNT(*) AS total_students FROM students;
SELECT COUNT(*) AS total_people FROM people;
```

**Observe lo siguiente:**

- El procedimiento no recibe parámetros de entrada (los paréntesis están vacíos).
- Se ejecutan múltiples instrucciones `DELETE` en secuencia.
- Es fundamental respetar el orden de las dependencias: primero se borran los datos de las tablas que dependen de otras (como `grades` que depende de `students` y `groups`), y al final las tablas independientes (como `people` y `degrees`).
- Este procedimiento es muy útil durante el desarrollo y las pruebas, pero debe usarse con precaución en producción.

### Ejemplo 3: Procedimiento para calcular el promedio de notas con parámetro OUT

Este procedimiento calcula la nota media de un estudiante y la devuelve mediante un parámetro de salida (OUT).

{% include sql-embed.html src='_code/grades/p_student_average.sql' label='p_student_average.sql' collapsed=false %}

**Para ejecutarlo:**

```sql
-- Consultar la nota media del estudiante con ID 6
CALL p_student_average(6, @avg_student_6);
SELECT @avg_student_6 AS 'Promedio del estudiante 6';

-- Consultar para varios estudiantes
CALL p_student_average(7, @avg_student_7);
CALL p_student_average(8, @avg_student_8);
SELECT @avg_student_6, @avg_student_7, @avg_student_8;
```

**Observe lo siguiente:**

- Este procedimiento usa un parámetro `OUT` para devolver el resultado calculado.
- Los parámetros `OUT` permiten que el procedimiento devuelva valores al código que lo invoca.
- La consulta `SELECT ... INTO` asigna directamente el resultado al parámetro de salida.
- Para recibir el valor devuelto, se usa una variable de usuario (prefijada con `@`) al llamar al procedimiento.
- Las variables de usuario persisten durante toda la sesión, por lo que pueden consultarse después de la llamada.
- A diferencia de las funciones, los procedimientos no pueden usarse directamente en consultas SELECT, pero son más flexibles para operaciones complejas.

### Ejemplo 4: Procedimiento para subir notas de un grupo

Este procedimiento incrementa en un 15% las notas de los estudiantes de un grupo específico en una convocatoria determinada, pero solo si la nota está entre 4.5 y 8. Demuestra el uso de `UPDATE` con condiciones y cálculos dentro de un procedimiento.

{% include sql-embed.html src='_code/grades/p_boost_group_grades.sql' label='p_boost_group_grades.sql' collapsed=false %}

**Para ejecutarlo:**

```sql
-- Ver las notas del grupo 1 antes de la actualización
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value;

-- Subir las notas del grupo 1 en la convocatoria 'Primera'
CALL p_boost_group_grades(1, 'Primera');

-- Verificar las notas después de la actualización
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value;
```

**Observe lo siguiente:**

- El procedimiento recibe dos parámetros `IN`: el identificador del grupo y la convocatoria.
- Se usa `UPDATE` con condiciones múltiples en la cláusula `WHERE` para seleccionar solo las notas que cumplen los criterios.
- `LEAST(grade_value * 1.15, 10.0)` garantiza que ninguna nota supere el máximo permitido (10.0), incluso después del incremento del 15%.
- `grade_value BETWEEN 4.5 AND 8.0` filtra solo las notas en el rango especificado.
- `ROW_COUNT()` devuelve el número de filas afectadas por el `UPDATE`; debe consultarse inmediatamente después de esta operación.
- El `SELECT` final informa del grupo procesado y del número de notas actualizadas.

### Ejemplo 5: Procedimiento para asignar matrículas de honor

Este procedimiento asigna matrícula de honor al top 5% de estudiantes de un grupo en una convocatoria específica, respetando la restricción de que solo puede haber un máximo del 5% de MH y que la nota debe ser >= 9. Demuestra el uso de subconsultas, `LIMIT` y cálculos dentro de procedimientos.

{% include sql-embed.html src='_code/grades/p_assign_honors.sql' label='p_assign_honors.sql' collapsed=false %}

**Para ejecutarlo:**

```sql
-- Ver las notas del grupo 1 antes de asignar MH
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, 
       g.with_honors, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value DESC;

-- Asignar matrículas de honor al grupo 1 en la convocatoria 'Primera'
CALL p_assign_honors(1, 'Primera');

-- Verificar las matrículas asignadas
SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, 
       g.with_honors, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera' AND g.with_honors = 1
ORDER BY g.grade_value DESC;
```

**Observe lo siguiente:**

- El procedimiento implementa la regla de negocio de que no puede haber más del 5% de matrículas de honor.
- **El 5% se calcula sobre el total de estudiantes matriculados en el grupo** (consultando `group_enrollments`), independientemente de si tienen o no calificación asignada.
- `FLOOR(v_total_students * 0.05)` trunca hacia abajo el cálculo del 5%, garantizando que nunca se supere el límite.
- Se usa `IF ... THEN ... ELSE ... END IF` para manejar el caso especial donde el 5% resulta en 0 estudiantes.
- Primero se quitan todas las MH existentes (`with_honors = 0`) para evitar inconsistencias.
- La tabla derivada `selected_grades` selecciona los `grade_id` de los mejores estudiantes y permite aplicar `ORDER BY ... LIMIT` de forma compatible con MariaDB.
- `ORDER BY grade_value DESC` ordena las notas de mayor a menor.
- `LIMIT v_max_honors` limita la selección al número máximo calculado.
- Solo se consideran notas >= 9.0, cumpliendo con la restricción de matrícula de honor.

## Tests automatizados: Estrategia

Los tests automatizados son fundamentales para garantizar que la base de datos cumple con todas las reglas de negocio definidas. En lugar de probar manualmente cada restricción, creamos procedimientos que intentan violar las reglas y verifican que el sistema las rechace correctamente.

### Estrategia de testing

Utilizaremos **tests negativos** para validar que las restricciones funcionan:

1. **Test negativo**: Intenta realizar una operación que viola una regla de negocio.
2. **Resultado esperado**: La base de datos rechaza la operación con un error.
3. **Test PASS**: Si se captura la excepción esperada.
4. **Test FAIL**: Si la operación se ejecuta sin error (la restricción no funciona).

Los **tests positivos** (operaciones válidas) se asumen validados si `populateDB.sql` se ejecuta sin errores, ya que ese script contiene datos que cumplen todas las reglas.

## Tests de restricciones declarativas

En este laboratorio se prueban las reglas implementadas hasta L2 mediante claves, atributos obligatorios y restricciones `CHECK`. Las reglas que requieren funciones o triggers se incorporarán a la batería completa en L5, después de construir esos objetos.

El archivo `tests_constraints.sql` contiene:

1. La tabla `test_results`.
2. El procedimiento auxiliar `p_log_test`.
3. Los tests de RN001 y RN009-RN016.
4. El procedimiento orquestador `p_run_constraint_tests`.

{% include sql-embed.html src='_code/grades/tests_constraints.sql' label='tests_constraints.sql' collapsed=false %}

## Ejecución de los tests

Ejecuta el script después de `createDB.sql` y `populateDB.sql`:

```sql
SOURCE tests_constraints.sql;
```

El resultado esperado es:

| Estado | Total |
|--------|------:|
| PASS | 9 |

Un resultado `PASS` indica que la base de datos rechazó la operación inválida. Un resultado `FAIL` indica que la operación fue aceptada y la restricción debe revisarse.

En L5 se crearán `functions.sql` y `triggers.sql`; después se ejecutará `tests.sql`, que amplía esta batería con las reglas procedurales y debe producir 16 resultados `PASS`.

## Push final

```bash
git add tests_constraints.sql
git commit -m "Completado L4: Tests SQL para validación de reglas de negocio"
git push origin main
```

## Resumen

En este laboratorio has aprendido:

- ✅ Crear procedimientos almacenados con `DELIMITER` y `CREATE OR REPLACE PROCEDURE`.
- ✅ Usar exception handlers (`DECLARE EXIT HANDLER FOR SQLEXCEPTION`).
- ✅ Diseñar tests negativos para validar restricciones.
- ✅ Crear tablas de resultados para tests automatizados.
- ✅ Implementar procedimientos orquestadores.
- ✅ Interpretar resultados de baterías de tests.

Los tests automatizados son herramientas fundamentales para mantener la calidad y consistencia de las bases de datos en entornos de producción.
