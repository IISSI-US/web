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
- Usar parámetros de entrada (IN) en procedimientos.
- Implementar lógica de control de flujo (IF, WHILE, etc.).
- Diseñar tests negativos para validar restricciones.
- Usar manejadores de excepciones (EXCEPTION HANDLER).
- Crear tablas de resultados para almacenar el estado de los tests.
- Implementar procedimientos orquestadores para ejecutar baterías de tests.

Los procedimientos almacenados permiten encapsular lógica de negocio en el servidor de base de datos, mejorando el rendimiento y la seguridad. Los tests automatizados garantizan que las reglas de negocio se cumplan correctamente y facilitan la detección temprana de errores.

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

**Durante el laboratorio**, haz commits progresivos:

```bash
git add tests.sql
git commit -m "Añadida tabla test_results y procedimiento auxiliar"
git commit -m "Añadidos tests para RN001-RN005"
git commit -m "Completados todos los tests y procedimiento orquestador"
```

**Al finalizar el laboratorio**, haz push al repositorio remoto:

```bash
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

## Tests automatizados: Validación de reglas de negocio

Los tests automatizados son fundamentales para garantizar que la base de datos cumple con todas las reglas de negocio definidas. En lugar de probar manualmente cada restricción, creamos procedimientos que intentan violar las reglas y verifican que el sistema las rechace correctamente.

### Estrategia de testing

Utilizaremos **tests negativos** para validar que las restricciones funcionan:

1. **Test negativo**: Intenta realizar una operación que viola una regla de negocio.
2. **Resultado esperado**: La base de datos rechaza la operación con un error.
3. **Test PASS**: Si se captura la excepción esperada.
4. **Test FAIL**: Si la operación se ejecuta sin error (la restricción no funciona).

Los **tests positivos** (operaciones válidas) se asumen validados si `populateDB.sql` se ejecuta sin errores, ya que ese script contiene datos que cumplen todas las reglas.

### Estructura del archivo tests.sql

El archivo debe contener:

```sql
-- 
-- Autor: [Tu Nombre]
-- Fecha: Enero 2026
-- Descripción: Tests automatizados para validar reglas de negocio de GradesDB
-- 

USE GradesDB;

-- 1. Tabla para almacenar resultados
-- 2. Procedimiento auxiliar para registrar resultados
-- 3. Procedimientos de test (uno por regla de negocio)
-- 4. Procedimiento orquestador para ejecutar todos los tests
```

## Tabla de resultados

Primero creamos una tabla para almacenar los resultados de cada test ejecutado:

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
- `test_status`: Estado del test (PASS, FAIL, ERROR).
- `execution_time`: Marca temporal de cuándo se ejecutó.

## Procedimiento auxiliar para registrar resultados

Creamos un procedimiento que facilita insertar resultados en la tabla:

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

- Este procedimiento simplifica el registro de cada test.
- `SUBSTRING_INDEX(p_message, ':', 1)` extrae el ID de la regla del mensaje.
- Se usa tanto para tests que pasan como para los que fallan.

## Implementación de tests negativos

A continuación veremos ejemplos de tests para diferentes tipos de restricciones.

### Test RN001: Matrícula de honor requiere nota >= 9

Esta regla de negocio establece que solo se puede marcar una nota como matrícula de honor si su valor es 9 o superior.

```sql
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

- `DECLARE EXIT HANDLER FOR SQLEXCEPTION`: Captura cualquier error SQL y ejecuta una acción.
- Si la actualización falla (como esperamos), el handler registra un PASS.
- Si la actualización tiene éxito (no debería), se ejecuta la línea final registrando un FAIL.
- Llamamos a `p_populate_grados()` para tener datos frescos en cada test.

### Test RN002: No se permiten notas duplicadas por asignatura/convocatoria

La RN017 establece que un alumno no puede tener más de una nota para la misma asignatura, convocatoria y año académico.

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

- El estudiante 6 ya tiene una nota en el grupo 1 para la primera convocatoria.
- Intentamos insertar otra nota para la misma combinación.
- El trigger `t_biu_grades_rn01` debe rechazar esta operación.

### Test RN003: Un grupo no puede tener más de 2 profesores

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

- El grupo 1 ya tiene dos profesores asignados en `populateDB.sql`.
- Intentamos asignar un tercer profesor (ID 5).
- El trigger `t_bi_teaching_loads_rn03` debe rechazar esta operación.

### Test RN006: No más de un grupo de teoría y dos de laboratorio por asignatura y año

```sql
-- Test RN006: No puede haber más de un grupo de teoría por asignatura y año académico
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn006_extra_group()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN006', 'RN006: No se permite crear un segundo grupo de teoría para la asignatura', 'PASS');

    CALL p_populate_grados();

    INSERT INTO groups (group_id, subject_id, group_name, activity, academic_year)
        VALUES (100, 11, 'T2', 'Teoría', 2024);

    CALL p_log_test('RN006', 'ERROR: Se creó un segundo grupo de teoría para la misma asignatura', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- La asignatura 11 (IISSI-1) ya tiene un grupo de teoría (T1) para el año 2024.
- Intentamos crear un segundo grupo de teoría (T2) para la misma asignatura y año.
- El trigger `t_bi_groups_rn06` debe rechazar esta operación.

### Test RN010: Los créditos de una asignatura solo pueden ser 6 o 12

```sql
-- Test RN010: Los créditos de una asignatura pueden ser 6 o 12
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn010_subject_credits()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN010', 'RN010: Los créditos de una asignatura pueden ser 6 o 12', 'PASS');

    CALL p_populate_grados();

    INSERT INTO subjects (subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
        VALUES (100, 3, 'Asignatura Créditos Inválidos', 'ACI', 8, 2, 'Obligatoria');

    CALL p_log_test('RN010', 'ERROR: Se permitió una asignatura con créditos inválidos', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- Intentamos crear una asignatura con 8 créditos, que no está permitido.
- El CHECK constraint `rn10_subjects_credits` debe rechazar esta operación.
- Los CHECK constraints validan que los valores cumplan condiciones específicas.

### Test RN014: El DNI debe tener formato correcto (8 dígitos + letra)

```sql
-- Test RN014: El DNI está formado por 8 números y una letra
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn014_dni_format()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN014', 'RN014: El DNI debe tener 8 dígitos y una letra', 'PASS');

    CALL p_populate_grados();

    INSERT INTO people (person_id, dni, first_name, last_name, age, email)
        VALUES (200, 'INVALIDO', 'DNI', 'Incorrecto', 30, 'dni@us.es');

    CALL p_log_test('RN014', 'ERROR: Se permitió un DNI con formato inválido', 'FAIL');
END //
DELIMITER ;
```

**Observe lo siguiente:**

- El DNI 'INVALIDO' no cumple el patrón requerido.
- El CHECK constraint `rn14_people_dni` usa una expresión regular (REGEXP) para validar.
- Las expresiones regulares permiten validar formatos complejos.

## Procedimiento orquestador

Para ejecutar todos los tests de una vez, creamos un procedimiento orquestador:

```sql
-- =============================================================
-- ORQUESTADOR
-- =============================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_grados_tests()
BEGIN
    -- Limpiar resultados anteriores
    DELETE FROM test_results;

    -- Ejecutar todos los tests
    CALL p_test_rn001_mh_requirement();
    CALL p_test_rn002_duplicate_grade();
    CALL p_test_rn003_professors_per_group();
    CALL p_test_rn006_extra_group();
    CALL p_test_rn010_subject_credits();
    CALL p_test_rn014_dni_format();
    -- ... más tests

    -- Mostrar resultados
    SELECT * FROM test_results ORDER BY execution_time, test_id;
    
    -- Resumen por estado
    SELECT test_status, COUNT(*) AS total 
    FROM test_results 
    GROUP BY test_status;
END //
DELIMITER ;
```

**Para ejecutar todos los tests:**

```sql
CALL p_run_grados_tests();
```

**Observe lo siguiente:**

- El orquestador limpia resultados anteriores antes de ejecutar.
- Llama a cada procedimiento de test individual.
- Muestra un reporte completo al final.
- Incluye un resumen por estado (PASS/FAIL/ERROR).

## Interpretación de resultados

Después de ejecutar `CALL p_run_grados_tests();`, obtendrás dos tablas:

### Tabla 1: Resultados detallados

| test_id | test_name | test_message | test_status | execution_time |
|---------|-----------|--------------|-------------|----------------|
| RN001 | RN001 | RN001: La MH requiere nota >= 9 | PASS | 2026-01-14 10:30:01 |
| RN002 | RN002 | RN002: No se permiten notas duplicadas... | PASS | 2026-01-14 10:30:02 |
| RN003 | RN003 | RN003: No se permite añadir un tercer... | PASS | 2026-01-14 10:30:03 |

### Tabla 2: Resumen

| test_status | total |
|-------------|-------|
| PASS | 16 |
| FAIL | 0 |

**Interpretación:**

- **PASS**: La restricción funciona correctamente y rechazó la operación inválida.
- **FAIL**: La restricción NO funciona, permitió una operación que debería rechazar (¡error en el diseño!).
- **ERROR**: Error inesperado durante la ejecución del test.

Si todos los tests muestran PASS, significa que todas las reglas de negocio están correctamente implementadas.

## Mejores prácticas

1. **Aislamiento de tests**: Cada test debe llamar a `p_populate_grados()` para tener datos frescos.
2. **Nombres descriptivos**: Los IDs y mensajes deben identificar claramente qué regla validan.
3. **Cobertura completa**: Crea un test para cada regla de negocio (RN001-RN017).
4. **Tests atómicos**: Cada procedimiento debe validar una sola regla.
5. **Documentación**: Comenta cada test explicando qué valida y por qué.
6. **Mantenimiento**: Actualiza los tests cuando cambien las reglas de negocio.

## Ejercicios propuestos

Completa los tests para las siguientes reglas de negocio:

1. **RN004**: Un alumno no puede pertenecer a más de un grupo de teoría y dos de laboratorio por asignatura.
2. **RN005**: Una nota no puede alterarse en más de 4 puntos.
3. **RN007**: Un alumno solo puede pertenecer a grupos de asignaturas en las que está matriculado.
4. **RN008**: Un alumno no puede acceder por selectividad con menos de 16 años.
5. **RN009**: Los atributos obligatorios no pueden ser NULL.
6. **RN011**: El valor de la nota debe estar entre 0 y 10.
7. **RN012**: La edad de las personas debe estar entre 16 y 70 años.
8. **RN013**: Los años de un grado deben estar entre 3 y 6.
9. **RN015**: El año académico debe estar entre 2000 y 2100.
10. **RN016**: El curso de una asignatura debe estar entre 1 y 6.

**Pista**: Sigue la estructura de los ejemplos mostrados. Cada test debe:
- Intentar violar la regla correspondiente.
- Capturar la excepción esperada (PASS).
- Registrar FAIL si la operación tiene éxito.

## Push final

Una vez completado el laboratorio con todos los tests implementados:

```bash
git add tests.sql
git commit -m "Completado L4: Procedimientos almacenados y tests SQL"
git push origin main
```

## Resumen

En este laboratorio has aprendido:

- ✅ Crear procedimientos almacenados con parámetros IN/OUT.
- ✅ Implementar lógica de control de flujo en procedimientos.
- ✅ Diseñar tests negativos para validar restricciones.
- ✅ Usar exception handlers para capturar errores.
- ✅ Crear tablas de resultados para tests automatizados.
- ✅ Implementar procedimientos orquestadores.
- ✅ Interpretar resultados de baterías de tests.

Los procedimientos almacenados y los tests automatizados son herramientas fundamentales para mantener la calidad y consistencia de las bases de datos en entornos de producción.

