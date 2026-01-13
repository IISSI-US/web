---
layout: single
title: "Lab2 - Restricciones en tablas"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---

<!-- # Restricciones en tablas SQL -->

## Objetivo

El objetivo de esta práctica es aprender a implementar restricciones de integridad en las tablas de una base de datos. El alumno aprenderá a:

- Añadir columnas adicionales a tablas existentes con ALTER TABLE.
- Implementar restricciones CHECK para validar rangos y valores permitidos.
- Definir restricciones UNIQUE para garantizar unicidad de valores.
- Implementar tipos ENUM para atributos con valores predefinidos.
- Aplicar reglas de negocio mediante restricciones de base de datos.

En el laboratorio anterior creamos el esquema relacional básico de la base de datos GradesDB con sus tablas, claves primarias y claves ajenas. En este laboratorio completaremos el diseño añadiendo las restricciones de integridad que implementan las reglas de negocio documentadas en el laboratorio L0 (Requisitos).

## Preparación del entorno

Abre HeidiSQL y conéctate con el usuario `iissi_user` a la base de datos `GradesDB`. Abre el archivo `createdb.sql` que creaste en el laboratorio anterior. Trabajaremos añadiendo código al final de este archivo, después de la creación de todas las tablas.

## Control de versiones

Continuaremos trabajando con el repositorio `GradesDB` creado en L1. Tras completar cada sección de restricciones, haz commit:

```bash
git add -A
git commit -m "Añadidas restricciones CHECK/UNIQUE para [nombre_tabla]"
```

## Restricciones de integridad: conceptos

Las restricciones de integridad garantizan que los datos almacenados en la base de datos cumplan ciertas reglas de negocio. SQL proporciona varios mecanismos:

- **CHECK**: Valida que un valor cumpla una expresión booleana (rangos, patrones, etc.)
- **UNIQUE**: Garantiza que no haya valores duplicados (claves alternativas)
- **ENUM**: Define un conjunto cerrado de valores permitidos para un atributo
- **NOT NULL**: Impide valores nulos (ya lo usamos en L1)

Estas restricciones se pueden definir al crear la tabla (inline) o añadirse posteriormente con `ALTER TABLE`.

## Restricciones en la tabla `people`

La tabla `people` almacena información básica de todas las personas del sistema (tanto estudiantes como profesores). Implementaremos restricciones para validar la edad (RN12) y el formato del DNI (RN14), además de garantizar unicidad.

```sql
ALTER TABLE people
    ADD CONSTRAINT rn12_people_age CHECK (age BETWEEN 16 AND 70),
    ADD CONSTRAINT rn14_people_dni CHECK (dni REGEXP '^[0-9]{8}[A-Za-z]$'),
    ADD CONSTRAINT rn_uq_people_dni UNIQUE (dni),
    ADD CONSTRAINT rn_uq_people_email UNIQUE (email);
```

Observaciones:

- `CHECK (age BETWEEN 16 AND 70)` valida que la edad esté en el rango permitido.
- `REGEXP '^[0-9]{8}[A-Za-z]$'` verifica el formato del DNI:
  - `^` inicio de cadena
  - `[0-9]{8}` exactamente 8 dígitos
  - `[A-Za-z]` una letra (mayúscula o minúscula)
  - `$` fin de cadena
- El nombre de la constraint (`rn12_people_age`) facilita identificar qué regla de negocio se viola si ocurre un error.

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla people"`.
{: .notice--info}

## Restricciones en la tabla `professors`

```sql
ALTER TABLE professors
    ADD CONSTRAINT rn20_professors_category CHECK (
        category IN ('Ayudante','AyudanteDoctor','Titular','Catedrático')
    );
```

Observaciones:

- `IN (lista)` valida que el valor esté en la lista de valores permitidos.
- Implementa el tipo enumerado `CategoríaProfesor` del modelo conceptual.
- Si se intenta insertar un valor no válido, se rechazará la operación.

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla professors"`.
{: .notice--info}

## Restricciones en la tabla `students`

```sql
ALTER TABLE students
    ADD CONSTRAINT rn19_students_access_method CHECK (
        access_method IN ('Selectividad','Ciclo','Mayor','Titulado','Extranjero')
    );
```

Observaciones:

- Implementa el tipo enumerado `MétodoAcceso` del modelo conceptual.
- Define los cinco métodos de acceso válidos al centro universitario.

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla students"`.
{: .notice--info}

## Restricciones en la tabla `degrees`

```sql
ALTER TABLE degrees
    ADD CONSTRAINT rn13_degree_duration CHECK (duration_years BETWEEN 3 AND 6),
    ADD CONSTRAINT rn_uq_degrees_name UNIQUE (degree_name);
```

Observaciones:

- RN13 valida que la duración esté entre 3 y 6 años según la normativa universitaria.
- No puede haber dos grados con el mismo nombre.
- Evita duplicados accidentales.

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla degrees"`.
{: .notice--info}

## Restricciones en la tabla `subjects`

```sql
ALTER TABLE subjects
    ADD CONSTRAINT rn10_subjects_credits CHECK (credits IN (6, 12)),
    ADD CONSTRAINT rn16_subjects_course CHECK (course BETWEEN 1 AND 6),
    ADD CONSTRAINT ck_subjects_type CHECK (
        subject_type IN ('Formación Básica','Obligatoria','Optativa')
    ),
    ADD CONSTRAINT rn_uq_subjects_name UNIQUE (subject_name),
    ADD CONSTRAINT rn_uq_subjects_acronym UNIQUE (acronym);
```

Observaciones:

- RN10 solo permite asignaturas de 6 o 12 créditos (sistema ECTS).
- RN16 valida que el curso esté entre 1 y 6 (máxima duración de un grado).
- El constraint del tipo implementa el enumerado `TipoAsignatura` del diagrama conceptual.
- Tanto el nombre completo como el acrónimo deben ser únicos.

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla subjects"`.
{: .notice--info}

## Restricciones en la tabla `groups`

```sql
ALTER TABLE groups
    ADD CONSTRAINT rn15_groups_year CHECK (academic_year BETWEEN 2000 AND 2100),
    ADD CONSTRAINT ck_groups_activity CHECK (
        activity IN ('Teoría','Laboratorio')
    ),
    ADD CONSTRAINT rn_uq_groups_name UNIQUE (subject_id, group_name, academic_year);
```

Observaciones:

- RN15 establece un rango temporal razonable para los años académicos.
- El constraint de actividad implementa el enumerado `TipoActividad` del modelo conceptual.
- La clave alternativa compuesta permite grupos con el mismo nombre en diferentes asignaturas o años:
  - ✅ IISSI-1, T1, 2024
  - ✅ IISSI-1, T1, 2025 (mismo grupo, diferente año)
  - ✅ ADDA, T1, 2024 (mismo nombre, diferente asignatura)
  - ❌ IISSI-1, T1, 2024 (duplicado exacto)

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla groups"`.
{: .notice--info}

## Restricciones en la tabla `teaching_loads`

```sql
ALTER TABLE teaching_loads
    ADD CONSTRAINT rn21_teaching_loads_credits CHECK (credits > 0);
```

Observaciones:

- RN21 garantiza que las cargas docentes sean positivas.
- Un profesor debe impartir al menos algún crédito en un grupo.

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla teaching_loads"`.
{: .notice--info}

## Restricciones en la tabla `grades`

```sql
ALTER TABLE grades
    ADD CONSTRAINT rn11_grades_value CHECK (grade_value BETWEEN 0 AND 10),
    ADD CONSTRAINT rn08_grades_with_honors CHECK (
        with_honors = 0 OR grade_value >= 9
    ),
    ADD CONSTRAINT rn18_grades_exam_call CHECK (
        exam_call IN ('Primera','Segunda','Tercera','Extraordinaria')
    );
```

Observaciones:

- RN11 valida que las notas estén en el rango estándar (0 a 10).
- RN08 implementa la regla: si `with_honors = 1`, entonces `grade_value >= 9`.
  - La expresión `with_honors = 0 OR grade_value >= 9` se cumple si:
    - No es matrícula de honor (with_honors = 0), o
    - Si es matrícula de honor, la nota es >= 9
- RN18 implementa el enumerado `Convocatoria` del modelo conceptual.

Recuerda: al finalizar este apartado, haz commit: `git add -A && git commit -m "Añadidas restricciones para tabla grades"`.
{: .notice--info}

## Verificación de restricciones

Para verificar que las restricciones funcionan correctamente, ejecuta el script `createdb.sql` completo:

1. En HeidiSQL, abre el archivo `createdb.sql`.
2. Ejecuta todo el script (F9 o botón "Ejecutar").
3. Si hay errores, revisa el mensaje y corrige el código.

Una vez creada la base de datos con todas las restricciones, prueba a violar alguna de ellas para verificar que funcionan:

**Ejemplo 1: Intentar insertar una persona con edad fuera de rango**

```sql
INSERT INTO people (person_id, dni, first_name, last_name, age, email)
VALUES (100, '99999999Z', 'Juan', 'Test', 15, 'juan@test.es');
```

**Error esperado**: `Check constraint 'rn12_people_age' is violated`

**Ejemplo 2: Intentar insertar una asignatura con créditos inválidos**

```sql
INSERT INTO subjects (subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
VALUES (100, 1, 'Test', 'TST', 8, 1, 'Obligatoria');
```

**Error esperado**: `Check constraint 'rn10_subjects_credits' is violated`

**Ejemplo 3: Intentar insertar un DNI duplicado**

Primero inserta una persona válida:

```sql
INSERT INTO people (person_id, dni, first_name, last_name, age, email)
VALUES (101, '88888888A', 'Ana', 'Test', 25, 'ana@test.es');
```

Ahora intenta insertar otra con el mismo DNI:

```sql
INSERT INTO people (person_id, dni, first_name, last_name, age, email)
VALUES (102, '88888888A', 'Pedro', 'Test', 30, 'pedro@test.es');
```

**Error esperado**: `Duplicate entry '88888888A' for key 'rn_uq_people_dni'`

## Resumen de restricciones implementadas

En este laboratorio hemos implementado las siguientes restricciones:

### Restricciones CHECK (rangos y valores permitidos)

| Constraint | Tabla | RN | Descripción |
|---|---|---|---|
| `rn12_people_age` | people | RN12 | Edad entre 16 y 70 años |
| `rn14_people_dni` | people | RN14 | DNI con formato 8 dígitos + letra |
| `rn20_professors_category` | professors | RN20 | Categoría válida |
| `rn19_students_access_method` | students | RN19 | Método de acceso válido |
| `rn13_degree_duration` | degrees | RN13 | Duración entre 3 y 6 años |
| `rn10_subjects_credits` | subjects | RN10 | Créditos 6 o 12 |
| `rn16_subjects_course` | subjects | RN16 | Curso entre 1 y 6 |
| `ck_subjects_type` | subjects | - | Tipo de asignatura válido |
| `rn15_groups_year` | groups | RN15 | Año académico 2000-2100 |
| `ck_groups_activity` | groups | - | Actividad Teoría/Laboratorio |
| `rn21_teaching_loads_credits` | teaching_loads | RN21 | Créditos > 0 |
| `rn11_grades_value` | grades | RN11 | Nota entre 0 y 10 |
| `rn08_grades_with_honors` | grades | RN01 | MH requiere nota ≥ 9 |
| `rn18_grades_exam_call` | grades | RN18 | Convocatoria válida |

### Restricciones UNIQUE (claves alternativas)

| Constraint | Tabla | Atributos | Descripción |
|---|---|---|---|
| `rn_uq_people_dni` | people | dni | DNI único |
| `rn_uq_people_email` | people | email | Email único |
| `rn_uq_degrees_name` | degrees | degree_name | Nombre de grado único |
| `rn_uq_subjects_name` | subjects | subject_name | Nombre de asignatura único |
| `rn_uq_subjects_acronym` | subjects | acronym | Acrónimo único |
| `rn_uq_groups_name` | groups | subject_id, group_name, academic_year | Combinación única |

## Conclusión

En este laboratorio hemos completado el diseño de la base de datos GradesDB añadiendo restricciones de integridad que:

1. Validan los datos antes de ser insertados o actualizados.
2. Implementan las reglas de negocio documentadas en L0.
3. Garantizan la calidad y consistencia de los datos.
4. Proporcionan mensajes de error descriptivos cuando se violan las reglas.

## Push final

Una vez completado todo el laboratorio, haz el push de los cambios:

```bash
git add -A
git commit -m "Completado L2: restricciones CHECK y UNIQUE"
git push
```

> [Versión PDF disponible](./index.pdf)
