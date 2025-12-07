---
layout: single
sidebar:
  nav: labs-iissi-1
title: "Lab0 - Requisitos"
pdf_version: true
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
---
> [Versión PDF disponible](./index.pdf)

<!-- # Requisitos -->

## Introducción

Un centro universitario desea desarrollar un sistema para automatizar el servicio de gestión académica con la información relativa a alumnos y asignaturas impartidas en el centro, incluidas las notas. Iniciado el estudio del dominio del problema, de las necesidades de negocio y de la situación actual y realizadas varias entrevistas, se han desarrollado los siguientes requisitos que debe cumplir el sistema de información a desarrollar.

## Catálogo de requisitos

### Requisitos de información

**RI001 - Información sobre grados**
- **Como**: Secretario
- **Quiero**: Disponer de la información correspondiente a los grados impartidos en el Centro: nombre y número de años. Varias asignaturas forman parte de un grado y una asignatura pertenece a un único grado
- **Para**: Poder realizar los planes de gestión docente

**RI002 - Información sobre asignaturas**
- **Como**: Responsable docente
- **Quiero**: Disponer de la información correspondiente a las asignaturas impartidas en el centro: nombre, acrónimo, créditos, curso y tipo (Obligatoria, Optativa, Formación Básica). Cada asignatura está formada por grupos
- **Para**: Poder realizar los planes de asignación docente

**RI003 - Información sobre grupos**
- **Como**: Secretario
- **Quiero**: Disponer de la información correspondiente a los grupos de actividad de las asignaturas: nombre, año académico y actividad. La actividad que puede ser Teoría o Laboratorio.
- **Para**: Poder conocer la disposición de los alumnos en grupos

**RI004 - Información sobre profesores**
- **Como**: Director del centro
- **Quiero**: Disponer de la información correspondiente a los profesores del centro: DNI, nombre, apellidos, edad, email y categoría (Ayudante, Ayudante Doctor, Titular, Catedrático). Un profesor imparte docencia en grupos, y esta docencia tiene asociada una carga de créditos
- **Para**: Poder realizar los planes de asignación docente y gestionar cargas de trabajo

**RI005 - Información sobre alumnos**
- **Como**: Profesor
- **Quiero**: Disponer de la información correspondiente a los alumnos matriculados en el centro: DNI, nombre, apellidos, edad, email y método de acceso (Selectividad, Ciclo, Mayor, Titulado, Extranjero). Un alumno se matricula en asignaturas, pertenece a grupos y obtiene notas en dichos grupos
- **Para**: Poder realizar las gestiones académicas correspondientes (matrícula, gestión de pagos...)

**RI006 - Información sobre notas**
- **Como**: Profesor
- **Quiero**: Disponer de la información sobre las notas de los alumnos: valor numérico (0.0-10.0), convocatoria (Primera, Segunda, Tercera, Extraordinaria) y si es matrícula de honor. Las notas están asociadas a un alumno y a un grupo específico
- **Para**: Realizar el seguimiento académico de los estudiantes

### Reglas de negocio

**RN001 - Matrícula de honor**
- **Como**: Director del Centro
- **Quiero**: Para que una nota sea matrícula de honor es necesario que su valor sea igual o superior a 9
- **Para**: Poder cumplir la normativa de la propia Universidad

**RN002 - Nota por alumno**
- **Como**: Director del Centro
- **Quiero**: Un alumno no puede tener más de una nota para la misma asignatura, convocatoria y año académico
- **Para**: Poder cumplir la normativa de la propia Universidad

**RN003 - Profesores por grupo**
- **Como**: Director del Centro
- **Quiero**: Un grupo no puede tener más de 2 profesores
- **Para**: Controlar la asignación docente

**RN004 - Pertenencia de alumnos a grupos**
- **Como**: Director del Centro
- **Quiero**: Un alumno no puede pertenecer a más de un grupo de teoría y a más de un grupo de laboratorio de cada asignatura
- **Para**: Evitar duplicidad en las listas de clases

**RN005 - Cambios bruscos en notas**
- **Como**: Director del Centro
- **Quiero**: Una nota no puede alterarse de una vez en más de 4 puntos (aumentada o disminuida)
- **Para**: Evitar cambios bruscos accidentales en las notas

**RN006 - Grupos por asignatura**
- **Como**: Director del Centro
- **Quiero**: De cada asignatura, no puede haber más de un grupo de teoría y dos de laboratorio
- **Para**: Controlar la oferta docente

**RN007 - Alumno matriculado en grupo**
- **Como**: Director del Centro
- **Quiero**: Un alumno sólo puede pertenecer a grupos de las asignaturas en las que está matriculado
- **Para**: Mantener consistencia en las matrículas

**RN008 - Restricción de edad para selectividad**
- **Como**: Director del Centro
- **Quiero**: Un alumno no puede acceder por selectividad teniendo menos de 16 años
- **Para**: Poder cumplir la normativa de la propia Universidad

**RN009 - Atributos obligatorios**
- **Como**: Director del Centro
- **Quiero**: Todos los atributos son obligatorios
- **Para**: Mantener la integridad de los datos

**RN010 - Créditos de asignatura**
- **Como**: Director del Centro
- **Quiero**: Los créditos de una asignatura pueden ser 6 o 12
- **Para**: Cumplir con el plan de estudios

**RN011 - Rango de notas**
- **Como**: Director del Centro
- **Quiero**: El valor de la nota está comprendido entre 0 y 10
- **Para**: Mantener el sistema de calificación estándar

**RN012 - Edad de las personas**
- **Como**: Director del Centro
- **Quiero**: La edad de las personas es mayor o igual a 16 años y menor o igual a 70 años
- **Para**: Establecer límites razonables

**RN013 - Años del grado**
- **Como**: Director del Centro
- **Quiero**: Los años de un grado están entre 3 y 6
- **Para**: Cumplir con la normativa universitaria

**RN014 - Formato del DNI**
- **Como**: Director del Centro
- **Quiero**: El DNI está formado por 8 números y una letra
- **Para**: Validar la identidad correctamente

**RN015 - Rango año académico**
- **Como**: Director del Centro
- **Quiero**: El año académico es un valor comprendido entre 2000 y 2100
- **Para**: Establecer límites temporales razonables

**RN016 - Curso de asignatura**
- **Como**: Director del Centro
- **Quiero**: El curso de una asignatura está comprendido entre 1 y 6
- **Para**: Corresponder con la duración máxima de los grados

## Requisitos funcionales

**RF001 - Añadir nota**
- **Como**: Profesor del centro
- **Quiero**: Añadir una nota a un alumno en un grupo
- **Para**: Poder controlar las calificaciones de todos los alumnos

**RF002 - Borrar notas de alumno**
- **Como**: Director del centro
- **Quiero**: Borrar todas las notas de un alumno con DNI dado
- **Para**: Eliminar expedientes académicos antiguos

**RF003 - Listado de alumnos**
- **Como**: Director del centro
- **Quiero**: Disponer de un listado de alumnos por orden alfabético con nombre, apellidos, asignatura y grupo
- **Para**: Publicar un censo de alumnos

**RF004 - Listado de alumnos mayores**
- **Como**: Director del centro
- **Quiero**: Disponer de un listado de los alumnos cuyo método de acceso sea mayor de 40 años (Mayor)
- **Para**: Analizar qué alumnos han entrado al centro por este método de acceso

**RF005 - Asignaturas de un grado y curso**
- **Como**: Alumno
- **Quiero**: Conocer las asignaturas (nombre, acrónimo, créditos y tipo) de un grado para un curso concreto ordenadas por el acrónimo
- **Para**: Ver las asignaturas que se imparten en dicho curso

**RF006 - Expediente de alumno**
- **Como**: Alumno
- **Quiero**: Conocer las notas finales de cada asignatura que ha cursado, es decir, las de mayor año y convocatoria
- **Para**: Conocer las asignaturas que le quedan por cursar

**RF007 - Nota media de alumno**
- **Como**: Alumno
- **Quiero**: Conocer mi nota media actual
- **Para**: Poder ver mi progreso a lo largo del grado

**RF008 - Listado de asignaturas de un grado**
- **Como**: Director del centro
- **Quiero**: Disponer de un listado de las asignaturas de un grado
- **Para**: Poder ver información sobre las asignaturas de un grado

## Diagramas de clases

### Jerarquía de personas

![Diagrama de jerarquía de personas](/assets/images/iissi1/laboratorios/fig/req/d_jerarquia.svg)

### Estructura académica y profesores

![Diagrama de estructura académica](/assets/images/iissi1/laboratorios/fig/req/d_academico.svg)

### Alumnos, matrículas y evaluación

![Diagrama de alumnos y evaluación](/assets/images/iissi1/laboratorios/fig/req/d_alumnos.svg)

### Tipos enumerados

![Diagrama de tipos enumerados](/assets/images/iissi1/laboratorios/fig/req/d_enum.svg)

## Modelo Relacional

### Intensión

```text
Grados(gradoId, nombre, años)
    PK(gradoId)

Asignaturas(asignaturaId, gradoId, nombre, acrónimo, créditos, curso, tipo)
    PK(asignaturaId)
    FK(gradoId) / Grados

Grupos(grupoId, asignaturaId, nombre, actividad, añoAcadémico)
    PK(grupoId)
    FK(asignaturaId) / Asignaturas

Personas(personaId, dni, nombre, apellidos, edad, email)
    PK(personaId)

Alumnos(alumnoId, métodoAcceso)
    PK(alumnoId)
    FK(alumnoId) / Personas

Profesores(profesorId, categoría)
    PK(profesorId)
    FK(profesorId) / Personas

Notas(notaId, alumnoId, grupoId, valor, convocatoria, esMH)
    PK(notaId)
    FK(alumnoId) / Alumnos
    FK(grupoId) / Grupos

GruposAlumnos(grupoAlumnoId, alumnoId, grupoId)
    PK(grupoAlumnoId)
    FK(alumnoId) / Alumnos
    FK(grupoId) / Grupos

Cargas(cargaId, profesorId, grupoId, créditos)
    PK(cargaId)
    FK(profesorId) / Profesores
    FK(grupoId) / Grupos

Matrículas(matrículaId, alumnoId, asignaturaId)
    PK(matrículaId)
    FK(alumnoId) / Alumnos
    FK(asignaturaId) / Asignaturas
```

### Extensión

```python
Grados = {
    (1, "Ingeniería del Software", 4),
    (2, "Ingeniería de Computadores", 4),
    (3, "Tecnologías Informáticas", 4)
}

Asignaturas = {
    (1, 3, "Fundamentos de Programación", "FP", 12, 1, "Formación Básica"),
    (2, 3, "Cálculo Infinitesimal y Numérico", "CIN", 6, 1, "Formación Básica"),
    (10, 3, "Análisis y Diseño de Datos y Algoritmos", "ADDA", 12, 2, "Obligatoria"),
    (11, 3, "Introducción a la Ingeniería del Software y los Sistemas de Información I", "IISSI-1", 6, 2, "Obligatoria"),
    (15, 3, "Introducción a la Ingeniería del Software y los Sistemas de Información II", "IISSI-2", 6, 2, "Obligatoria")
}

Grupos = {
    (1, 11, "T1", "Teoría", 2024),
    (2, 11, "L1", "Laboratorio", 2024),
    (3, 11, "L2", "Laboratorio", 2024)
}

Personas = {
    (1, "00000001A", "David", "Ruiz", 50, "druiz@us.es"),
    (2, "00000002B", "Inma", "Hernández", 40, "inmahernandez@us.es"),
    (3, "00000003C", "Fernando", "Sola", 28, "fsola@us.es"),
    (6, "10000006F", "David", "Romero", 22, "david.romero@alum.us.es"),
    (7, "10000007G", "Lucía", "Molina", 21, "lucia.molina@alum.us.es"),
    (8, "10000008H", "Hugo", "Paredes", 20, "hugo.paredes@alum.us.es"),
    (16, "10000016R", "Pablo", "Vidal", 22, "pablo.vidal@alum.us.es"),
    (25, "10000025A", "Paula", "Bermejo", 21, "paula.bermejo@alum.us.es")
}

Profesores = {
    (1, "Catedrático"),
    (2, "Titular"),
    (3, "AyudanteDoctor")
}

Alumnos = {
    (6, "Selectividad"),
    (7, "Selectividad"),
    (8, "Selectividad"),
    (16, "Selectividad"),
    (25, "Selectividad")
}

Matrículas = {
    (1, 6, 11),
    (2, 7, 11),
    (3, 8, 11),
    (4, 16, 11),
    (5, 25, 11)
}

GruposAlumnos = {
    (1, 6, 1),
    (2, 7, 1),
    (3, 8, 1),
    (4, 16, 1),
    (5, 25, 1),
    (6, 6, 2),
    (7, 7, 2),
    (8, 8, 2),
    (9, 16, 3),
    (10, 25, 3)
}

Cargas = {
    (1, 1, 1, 3.0),
    (2, 2, 1, 3.0),
    (3, 3, 2, 3.0)
}

Notas = {
    (1, 6, 1, 9.8, "Primera", 1),
    (2, 7, 1, 9.2, "Primera", 1),
    (3, 8, 1, 5.4, "Primera", 0),
    (11, 16, 1, 4.2, "Primera", 0),
    (20, 25, 1, 4.7, "Primera", 0),
    (21, 16, 1, 6.2, "Segunda", 0),
    (30, 25, 1, 4.3, "Segunda", 0),
    (35, 25, 1, 5.7, "Tercera", 0)
}
```

### Descripción de escenarios

La extensión relacional representa varios escenarios que ilustran el funcionamiento del sistema de gestión académica:

**Escenario 1: Organización académica**
- El grado de "Tecnologías Informáticas" (id=3) contiene asignaturas de primer curso (FP, CIN) y segundo curso (IISSI-1, IISSI-2, ADDA)
- La asignatura IISSI-1 está organizada en 3 grupos: 1 de teoría (T1) y 2 de laboratorio (L1, L2)

**Escenario 2: Jerarquía de personas**
- Se definen 8 personas en el sistema, diferenciadas entre profesores (ids 1-3) y alumnos (ids 6-8, 16, 25)
- Los profesores tienen diferentes categorías: Catedrático (David Ruiz), Titular (Inma Hernández) y AyudanteDoctor (Fernando Sola)
- Todos los alumnos accedieron al grado por Selectividad

**Escenario 3: Asignación docente**
- El grupo de teoría T1 tiene docencia compartida entre dos profesores (Catedrático y Titular), con 3 créditos cada uno
- El grupo de laboratorio L1 es impartido por un único profesor (AyudanteDoctor) con 3 créditos
- Cumple la restricción RN03: ningún grupo tiene más de 2 profesores

**Escenario 4: Matrículas y pertenencia a grupos**
- Los 5 alumnos están matriculados en IISSI-1 y pertenecen al grupo de teoría T1
- Los alumnos se distribuyen en laboratorios: 3 en L1 (ids 6, 7, 8) y 2 en L2 (ids 16, 25)
- Cumple RN04 y RN07: cada alumno pertenece a un solo grupo de teoría y un solo grupo de laboratorio de la asignatura en la que está matriculado

**Escenario 5: Evaluación y convocatorias**
- **Primera convocatoria**: 2 alumnos obtienen matrícula de honor (9.8 y 9.2), 1 aprobado (5.4) y 2 suspensos (4.2 y 4.7)
- **Segunda convocatoria**: El alumno 16 mejora su nota de 4.2 a 6.2 (aprueba), mientras que el alumno 25 se mantiene suspenso (4.3)
- **Tercera convocatoria**: El alumno 25 finalmente aprueba con un 5.7
- Cumple RN01: cada alumno tiene una única nota por convocatoria
- Cumple RN05: los cambios de nota entre convocatorias no superan 4 puntos (ej: alumno 16 pasa de 4.2 a 6.2, diferencia de 2 puntos)
- Cumple RN001: las matrículas de honor tienen valores ≥ 9

## Pruebas de aceptación

Las siguientes pruebas verifican que el sistema rechaza correctamente operaciones que violan las reglas de negocio:

### Grados (RN013)

- ❌ **Crear grado con duración fuera de rango**: Intentar crear un grado con 2 o 7 años (debe estar entre 3 y 6)

### Asignaturas (RN010, RN016)

- ❌ **Crear asignatura con créditos incorrectos**: Intentar crear una asignatura con 3, 4, 8 o 9 créditos (solo se permiten 6 o 12)
- ❌ **Crear asignatura con curso fuera de rango**: Intentar crear una asignatura en curso 0 o 7 (debe estar entre 1 y 6)

### Grupos (RN006, RN015)

- ❌ **Crear segundo grupo de teoría**: Intentar crear un segundo grupo de teoría para IISSI-1 (solo se permite 1)
- ❌ **Crear tercer grupo de laboratorio**: Intentar crear un tercer grupo de laboratorio para IISSI-1 (solo se permiten 2)
- ❌ **Crear grupo con año académico fuera de rango**: Intentar crear un grupo con año 1999 o 2101 (debe estar entre 2000 y 2100)

### Personas (RN009, RN012, RN014)

- ❌ **Crear persona con atributos NULL**: Intentar crear una persona con nombre NULL
- ❌ **Crear persona con edad fuera de rango**: Intentar crear una persona con 15 o 71 años (debe estar entre 16 y 70)
- ❌ **Crear persona con DNI inválido**: Intentar crear una persona con DNI "INVALIDO" (debe tener 8 dígitos y una letra)

### Profesores (RN003)

- ❌ **Asignar tercer profesor a un grupo**: Intentar asignar un tercer profesor al grupo T1 que ya tiene dos (máximo 2 profesores por grupo)

### Alumnos (RN008)

- ❌ **Crear alumno menor de 16 por Selectividad**: Intentar crear un alumno de 15 años con método de acceso "Selectividad"

### Matrículas (RN007)

- ❌ **Añadir alumno a grupo sin matrícula**: Intentar añadir un alumno a un grupo de IISSI-1 sin estar matriculado en la asignatura

### Pertenencia a grupos (RN004)

- ❌ **Alumno en dos grupos de teoría**: Intentar añadir un alumno que ya está en T1 a otro grupo de teoría de la misma asignatura
- ❌ **Alumno en dos grupos de laboratorio**: Intentar añadir un alumno que ya está en L1 a un segundo grupo de laboratorio (máximo 1 de cada tipo)

### Notas (RN001, RN002, RN005, RN011)

- ❌ **Nota duplicada por convocatoria**: Intentar insertar una segunda nota para el alumno 6 en Primera convocatoria (ya existe)
- ❌ **Nota para alumno fuera del grupo**: Intentar registrar una nota del alumno 6 en un grupo al que no pertenece
- ❌ **Modificar nota en más de 4 puntos**: Intentar cambiar la nota del alumno 6 de 9.8 a 0.5 (diferencia de 9.3 puntos)
- ❌ **Matrícula de honor con nota < 9**: Intentar marcar como MH la nota 6.2 del alumno 16
- ❌ **Nota fuera de rango**: Intentar insertar una nota con valor 11.0 o -1.0 (debe estar entre 0 y 10)


