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

Crea un nuevo archivo `tests.sql` en tu repositorio donde implementarás los tests de este laboratorio.

## Control de versiones

Continuaremos trabajando con el repositorio `GradesDB` creado en L1. 

**Al inicio del laboratorio**, añade el archivo de tests y haz commit:

```bash
git add tests.sql
git commit -m "Añadido archivo tests.sql para L4"
```

**Al finalizar el laboratorio**, haz push al repositorio remoto:

```bash
git add tests.sql
git commit -m "Completado L4: Tests SQL para validación de reglas de negocio"
git push origin main
```

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

### Ejemplo 1: Procedimiento para calcular el promedio de notas de un alumno

Este procedimiento recibe el ID de un estudiante y calcula su nota media.

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE p_calculate_student_average(
    IN p_student_id INT,
    OUT p_average DECIMAL(4,2)
)
BEGIN
    SELECT AVG(g.grade_value) INTO p_average
    FROM grades g
    JOIN groups gr ON gr.group_id = g.group_id
    WHERE g.student_id = p_student_id;
END //
DELIMITER ;
```

**Para ejecutarlo:**

```sql
-- Llamada con variable de salida
CALL p_calculate_student_average(6, @avg_student_6);
SELECT @avg_student_6 AS 'Promedio del estudiante 6';
```

**Observe lo siguiente:**

- `p_student_id` es un parámetro de entrada que especifica qué estudiante consultar.
- `p_average` es un parámetro de salida donde se almacena el resultado.
- `SELECT ... INTO` asigna el resultado de la consulta a la variable de salida.
- Las variables de usuario en MySQL/MariaDB se prefijan con `@`.

### Ejemplo 2: Procedimiento para añadir una nota con validación

Este procedimiento añade una nota verificando que el estudiante pertenece al grupo.

```sql
DELIMITER //
CREATE OR REPLACE PROCEDURE p_add_grade(
    IN p_student_id INT,
    IN p_group_id INT,
    IN p_grade_value DECIMAL(4,2),
    IN p_exam_call VARCHAR(20),
    IN p_with_honors BOOLEAN
)
BEGIN
    DECLARE v_enrolled INT DEFAULT 0;
    
    -- Verificar que el estudiante pertenece al grupo
    SELECT COUNT(*) INTO v_enrolled
    FROM group_enrollments
    WHERE student_id = p_student_id
      AND group_id = p_group_id;
    
    IF v_enrolled = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El estudiante no pertenece al grupo';
    END IF;
    
    -- Insertar la nota
    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (p_student_id, p_group_id, p_grade_value, p_exam_call, p_with_honors);
    
END //
DELIMITER ;
```

**Para ejecutarlo:**

```sql
-- Añadir nota al estudiante 6 en el grupo 1
CALL p_add_grade(6, 1, 8.5, 'Segunda', 0);
```

**Observe lo siguiente:**

- Se declara una variable local `v_enrolled` para almacenar resultados temporales.
- `IF ... THEN ... END IF` permite implementar lógica condicional.
- `SIGNAL SQLSTATE` lanza una excepción personalizada si la condición no se cumple.
- El procedimiento valida las condiciones antes de insertar datos.

## Tests automatizados: Estrategia

Los tests automatizados son fundamentales para garantizar que la base de datos cumple con todas las reglas de negocio definidas. En lugar de probar manualmente cada restricción, creamos procedimientos que intentan violar las reglas y verifican que el sistema las rechace correctamente.

### Estrategia de testing

Utilizaremos **tests negativos** para validar que las restricciones funcionan:

1. **Test negativo**: Intenta realizar una operación que viola una regla de negocio.
2. **Resultado esperado**: La base de datos rechaza la operación con un error.
3. **Test PASS**: Si se captura la excepción esperada.
4. **Test FAIL**: Si la operación se ejecuta sin error (la restricción no funciona).

Los **tests positivos** (operaciones válidas) se asumen validados si `populateDB.sql` se ejecuta sin errores, ya que ese script contiene datos que cumplen todas las reglas.

## Estructura del archivo tests.sql

El archivo `tests.sql` que vamos a crear contendrá:

```sql
--
-- Autor: [Tu Nombre]
-- Fecha: Enero 2026
-- Descripción: Tests negativos para la BD de Grados
--
USE GradesDB;

-- 1. Tabla de resultados (test_results)
-- 2. Procedimiento auxiliar (p_log_test)
-- 3. Tests individuales (p_test_rn001, p_test_rn002, ...)
-- 4. Procedimiento orquestador (p_run_grados_tests)
-- 5. Llamada al orquestador
```

## Tabla de resultados

La tabla `test_results` almacena los resultados de cada test ejecutado:

```sql
-- =============================================================
-- TABLA DE RESULTADOS
-- =============================================================
CREATE OR REPLACE TABLE test_results (
    test_id VARCHAR(20) PRIMARY KEY,
    test_name VARCHAR(200) NOT NULL,
    test_message VARCHAR(500) NOT NULL,
    test_status ENUM('PASS','FAIL','ERROR') NOT NULL,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Observe lo siguiente:**

- `test_id`: Identificador único del test (ej: 'RN001', 'RN002').
- `test_name`: Nombre descriptivo extraído del mensaje.
- `test_message`: Mensaje completo que describe el test.
- `test_status`: Estado del test:
  - `PASS`: El test pasó (la restricción funcionó)
  - `FAIL`: El test falló (la restricción NO funciona)
  - `ERROR`: Error inesperado
- `execution_time`: Marca temporal de ejecución.

## Procedimiento auxiliar

El procedimiento `p_log_test` facilita insertar resultados:

```sql
-- =============================================================
-- PROCEDIMIENTO AUXILIAR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
    IN p_test_id VARCHAR(20),
    IN p_message VARCHAR(500),
    IN p_status ENUM('PASS','FAIL','ERROR')
)
BEGIN
    INSERT INTO test_results(test_id, test_name, test_message, test_status)
    VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Recibe el ID, mensaje y estado del test.
- `SUBSTRING_INDEX(p_message, ':', 1)` extrae el nombre antes del primer `:`.
- Ejemplo: `'RN001: La MH requiere nota >= 9'` → extrae `'RN001'`.

## Tests (RN001 - RN016)

A continuación implementaremos los 16 tests, uno para cada regla de negocio. Copia cada uno en tu archivo `tests.sql`.

### Test RN001: Matrícula de honor requiere nota >= 9

```sql
-- =============================================================
-- TESTS (RN001 - RN016)
-- =============================================================

-- Test RN001: Matrícula de honor requiere nota >= 9
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn001_mh_requirement()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN001', 'RN001: La MH requiere nota >= 9', 'PASS');

    CALL p_populate_grados();

    UPDATE grades SET with_honors = 1 WHERE grade_id = 21;

    CALL p_log_test('RN001', 'ERROR: Se permitió MH con nota inferior a 9', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- `DECLARE EXIT HANDLER FOR SQLEXCEPTION`: Captura cualquier error SQL.
- Si el UPDATE falla (esperado), el handler registra PASS.
- Si el UPDATE tiene éxito (no debería), se registra FAIL.
- `grade_id = 21` tiene nota 6.2 (< 9), por lo que no puede ser MH.

### Test RN002: No se permiten notas duplicadas

```sql
-- Test RN002: No se permiten notas duplicadas por asignatura/convocatoria
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn002_duplicate_grade()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN002', 'RN002: No se permiten notas duplicadas por asignatura/convocatoria', 'PASS');

    CALL p_populate_grados();

    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (101, 6, 1, 6.0, 'Primera', 0);

    CALL p_log_test('RN002', 'ERROR: Se permitió duplicar nota en la misma convocatoria', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- El estudiante 6 ya tiene nota en grupo 1, convocatoria 'Primera'.
- El trigger `t_biu_grades_rn01` debe detectar y rechazar esta duplicación.

### Test RN003: Máximo 2 profesores por grupo

```sql
-- Test RN003: Un grupo no puede tener más de 2 profesores
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn003_professors_per_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN003', 'RN003: No se permite añadir un tercer profesor al grupo', 'PASS');

    CALL p_populate_grados();

    INSERT INTO teaching_loads (professor_id, group_id, credits) VALUES (5, 1, 1.0);

    CALL p_log_test('RN003', 'ERROR: Se asignó un tercer profesor al grupo', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- El grupo 1 ya tiene 2 profesores (IDs 1 y 2).
- Intentamos asignar el profesor 5 como tercero.
- El trigger `t_bi_teaching_loads_rn03` debe rechazar esto.

### Test RN004: Límite de grupos por alumno

```sql
-- Test RN004: Un alumno no puede pertenecer a más de un grupo de teoría y uno de laboratorio por asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn004_student_group_limit()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN004', 'RN004: Un alumno no puede pertenecer a más grupos de los permitidos', 'PASS');

    CALL p_populate_grados();

    INSERT INTO group_enrollments (student_id, group_id) VALUES (6, 3);

    CALL p_log_test('RN004', 'ERROR: Se permitió un alumno en más grupos de los permitidos', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- El estudiante 6 ya está en grupo 2 (L1 - laboratorio).
- El grupo 3 es L2 (también laboratorio) de la misma asignatura.
- Solo se permite 1 grupo de laboratorio por asignatura.

### Test RN005: Cambios bruscos en notas

```sql
-- Test RN005: Una nota no puede alterarse en más de 4 puntos
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn005_grade_delta()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN005', 'RN005: No se puede modificar la nota en más de 4 puntos', 'PASS');

    CALL p_populate_grados();

    UPDATE grades SET grade_value = 0.5 WHERE grade_id = 1;

    CALL p_log_test('RN005', 'ERROR: Se permitió modificar la nota en más de 4 puntos', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- `grade_id = 1` tiene valor 9.8.
- Intentamos cambiarla a 0.5 (diferencia de 9.3 puntos).
- El trigger `t_bu_grades_rn05` valida que la diferencia sea ≤ 4.

### Test RN006: Grupos por asignatura y año

```sql
-- Test RN006: No puede haber más de un grupo de teoría y dos de laboratorio por asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn006_extra_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN006', 'RN006: No se permite crear un segundo grupo de teoría para la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (11, 11, 'T2', 'Teoría', 2024);

    CALL p_log_test('RN006', 'ERROR: Se creó un segundo grupo de teoría para la misma asignatura', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- La asignatura 11 (IISSI-1) ya tiene grupo T1 de teoría en 2024.
- Intentamos crear T2 (segundo grupo de teoría).
- El trigger `t_bi_groups_rn06` debe rechazar esto.

### Test RN007: Matrícula previa requerida

```sql
-- Test RN007: Un alumno sólo puede pertenecer a grupos de asignaturas en las que está matriculado
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn007_subject_enrollment()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN007', 'RN007: No se puede añadir a un grupo sin matrícula en la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (102, '20000002B', 'Test', 'Alumno', 20, 'nuevo@alum.us.es');
    INSERT INTO students (student_id, access_method) VALUES (102, 'Selectividad');
    INSERT INTO group_enrollments (student_id, group_id) VALUES (102, 1);

    CALL p_log_test('RN007', 'ERROR: Se permitió unir a un grupo sin matrícula en la asignatura', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Creamos estudiante 102.
- NO lo matriculamos en la asignatura (`subject_enrollments`).
- Intentamos añadirlo directamente al grupo 1.
- El trigger debe rechazar esto.

### Test RN008: Edad mínima para selectividad

```sql
-- Test RN008: Un alumno no puede acceder por selectividad con menos de 16 años
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn008_min_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN008', 'RN008: No se permite Selectividad con menos de 16 años', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (104, '20000004D', 'Test', 'Menor', 15, 'menor@alum.us.es');
    INSERT INTO students (student_id, access_method) VALUES (104, 'Selectividad');

    CALL p_log_test('RN008', 'ERROR: Se permitió Selectividad para un menor', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Persona de 15 años.
- Método de acceso 'Selectividad'.
- El trigger `t_biu_students_rn08` debe rechazar esto.

### Test RN009: Atributos NOT NULL

```sql
-- Test RN009: Los atributos obligatorios no pueden quedar a NULL
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn009_not_null_attributes()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN009', 'RN009: Los atributos obligatorios no pueden quedar a NULL', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (103, '20000003C', NULL, 'Campos', 22, 'null@alum.us.es');

    CALL p_log_test('RN009', 'ERROR: Se permitió dejar atributos obligatorios a NULL', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- `first_name` es NOT NULL.
- Intentamos insertar NULL.
- El constraint de la columna debe rechazar esto.

### Test RN010: Créditos válidos

```sql
-- Test RN010: Los créditos de una asignatura pueden ser 6 o 12
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn010_subject_credits()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN010', 'RN010: Los créditos de una asignatura pueden ser 6 o 12', 'PASS');

    CALL p_populate_grados();

    INSERT INTO subjects (subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
        VALUES (31, 3, 'Asignatura Créditos Inválidos', 'ACI', 8, 2, 'Obligatoria');

    CALL p_log_test('RN010', 'ERROR: Se permitió una asignatura con créditos inválidos', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Créditos = 8 (no permitido).
- El CHECK constraint `rn10_subjects_credits` valida `credits IN (6, 12)`.

### Test RN011: Rango de notas

```sql
-- Test RN011: El valor de la nota está comprendido entre 0 y 10
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn011_grade_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN011', 'RN011: La nota debe estar entre 0 y 10', 'PASS');

    CALL p_populate_grados();

    INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
        VALUES (201, 6, 1, 11.0, 'Primera', 0);

    CALL p_log_test('RN011', 'ERROR: Se permitió una nota fuera de rango', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Valor 11.0 (fuera del rango 0-10).
- El CHECK constraint `rn11_grades_value` debe rechazar esto.

### Test RN012: Edad de personas

```sql
-- Test RN012: La edad de las personas está entre 16 y 70 años
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn012_people_age()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN012', 'RN012: La edad de las personas debe estar entre 16 y 70', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (105, '20000005E', 'Edad', 'Fuera', 80, 'edad@us.es');

    CALL p_log_test('RN012', 'ERROR: Se permitió una edad fuera de rango', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Edad = 80 (fuera del rango 16-70).
- El CHECK constraint `rn12_people_age` debe rechazar esto.

### Test RN013: Duración de grados

```sql
-- Test RN013: Los años de un grado están entre 3 y 6
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn013_degree_years()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN013', 'RN013: Los grados deben tener entre 3 y 6 años', 'PASS');

    CALL p_populate_grados();

    INSERT INTO degrees (degree_id, degree_name, duration_years)
        VALUES (10, 'Grado Experimental', 2);

    CALL p_log_test('RN013', 'ERROR: Se permitió un grado con años fuera de rango', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Duración = 2 años (fuera del rango 3-6).
- El CHECK constraint `rn13_degree_duration` debe rechazar esto.

### Test RN014: Formato de DNI

```sql
-- Test RN014: El DNI está formado por 8 números y una letra
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn014_dni_format()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN014', 'RN014: El DNI debe tener 8 dígitos y una letra', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (106, 'INVALIDO', 'DNI', 'Incorrecto', 30, 'dni@us.es');

    CALL p_log_test('RN014', 'ERROR: Se permitió un DNI con formato inválido', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- DNI 'INVALIDO' no cumple el patrón.
- El CHECK constraint `rn14_people_dni` usa REGEXP: `'^[0-9]{8}[A-Za-z]$'`.

### Test RN015: Rango de año académico

```sql
-- Test RN015: El año académico está entre 2000 y 2100
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn015_academic_year()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN015', 'RN015: El año académico debe estar entre 2000 y 2100', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (20, 12, 'MD-T2025', 'Teoría', 1999);

    CALL p_log_test('RN015', 'ERROR: Se permitió un año académico fuera de rango', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Año 1999 (fuera del rango 2000-2100).
- El CHECK constraint `rn15_groups_year` debe rechazar esto.

### Test RN016: Rango de curso

```sql
-- Test RN016: El curso de una asignatura está entre 1 y 6
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn016_course_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN016', 'RN016: El curso de una asignatura debe estar entre 1 y 6', 'PASS');

    CALL p_populate_grados();

    INSERT INTO subjects (subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
        VALUES (30, 3, 'Asignatura Fuera de Curso', 'AFC', 6, 0, 'Obligatoria');

    CALL p_log_test('RN016', 'ERROR: Se permitió un curso fuera de rango', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Curso = 0 (fuera del rango 1-6).
- El CHECK constraint `rn16_subjects_course` debe rechazar esto.

## Procedimiento orquestador

El procedimiento `p_run_grados_tests` ejecuta todos los tests y muestra resultados:

```sql
-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_grados_tests()
BEGIN
    DELETE FROM test_results;

    CALL p_test_rn001_mh_requirement();
    CALL p_test_rn002_duplicate_grade();
    CALL p_test_rn003_professors_per_group();
    CALL p_test_rn004_student_group_limit();
    CALL p_test_rn005_grade_delta();
    CALL p_test_rn006_extra_group();
    CALL p_test_rn007_subject_enrollment();
    CALL p_test_rn008_min_age();
    CALL p_test_rn009_not_null_attributes();
    CALL p_test_rn010_subject_credits();
    CALL p_test_rn011_grade_range();
    CALL p_test_rn012_people_age();
    CALL p_test_rn013_degree_years();
    CALL p_test_rn014_dni_format();
    CALL p_test_rn015_academic_year();
    CALL p_test_rn016_course_range();

    SELECT * FROM test_results ORDER BY execution_time, test_id;
    SELECT test_status, COUNT(*) AS total FROM test_results GROUP BY test_status;
END //
DELIMITER ;
```

**Observe lo siguiente:**

- `DELETE FROM test_results`: Limpia ejecuciones anteriores.
- Llama a los 16 tests en orden.
- Primera consulta: resultados detallados.
- Segunda consulta: resumen por estado.

## Ejecución de los tests

Al final del archivo añade:

```sql
CALL p_run_grados_tests();
```

Para ejecutar todos los tests:
1. Abre `tests.sql` en HeidiSQL.
2. Presiona F9 o haz clic en "Ejecutar".
3. Observa los resultados.

## Interpretación de resultados

Obtendrás dos tablas de resultados:

### Tabla 1: Resultados detallados

| test_id | test_name | test_message | test_status | execution_time |
|---------|-----------|--------------|-------------|----------------|
| RN001 | RN001 | RN001: La MH requiere nota >= 9 | PASS | 2026-01-14 10:30:01 |
| RN002 | RN002 | RN002: No se permiten notas duplicadas... | PASS | 2026-01-14 10:30:02 |
| ... | ... | ... | ... | ... |

### Tabla 2: Resumen

| test_status | total |
|-------------|-------|
| PASS | 16 |

**Interpretación:**

- **PASS** ✅: La restricción funciona (rechazó operación inválida).
- **FAIL** ❌: La restricción NO funciona (permitió operación inválida).
- **ERROR** ⚠️: Error inesperado.

**Resultado esperado**: Los 16 tests deben mostrar PASS.

## Push final

```bash
git add tests.sql
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
