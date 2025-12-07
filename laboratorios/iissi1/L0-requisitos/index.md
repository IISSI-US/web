---
layout: single
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

**RI004 - Información sobre alumnos**
- **Como**: Profesor
- **Quiero**: Disponer de la información correspondiente a los alumnos matriculados en el centro: DNI, nombre, apellidos, fecha de nacimiento, email, contraseña y método de acceso que puede ser (Selectividad, Ciclo, Mayor, Titulado Extranjero). Un alumno obtiene una serie de notas correspondientes a cada asignatura, estas notas se asocian al grupo, de forma que, si hay varios grupos para un mismo año académico y asignatura, un alumno solo debe obtener una nota por convocatoria para uno de ellos. Cada nota está formada por un valor numérico entre 0.0 y 10.0, un número de convocatoria y debe constar si es matrícula de honor o no
- **Para**: Poder realizar las gestiones académicas correspondientes (matrícula, gestión de pagos...)

### Reglas de negocio

**RN001 - Matrícula de honor**
- **Como**: Director del Centro
- **Quiero**: Para que una nota sea matrícula de honor es necesario que su valor sea igual o superior a 9
- **Para**: Poder cumplir la normativa de la propia Universidad

**RN002 - Nota por alumno**
- **Como**: Director del Centro
- **Quiero**: Un alumno no puede tener más de una nota para la misma asignatura, convocatoria y año académico
- **Para**: Poder cumplir la normativa de la propia Universidad

**RN003 - Restricción de edad**
- **Como**: Director del Centro
- **Quiero**: Un alumno no puede acceder por selectividad teniendo menos de 16 años
- **Para**: Poder cumplir la normativa de la propia Universidad

**RN004 - Alumno pertenece a grupo**
- **Como**: Director del Centro
- **Quiero**: Un alumno no puede tener notas en grupos a los que no pertenece
- **Para**: Poder cumplir la normativa de la propia Universidad

**RN005 - Cambios bruscos en notas**
- **Como**: Director del Centro
- **Quiero**: Una nota no puede alterarse de una vez en más de 4 puntos (aumentada o disminuida)
- **Para**: Evitar cambios bruscos accidentales en las notas

**RN006 - Alumnos máximos en grupos**
- **Como**: Director del Centro
- **Quiero**: Un grupo de teoría no puede tener más de 75 alumnos, y uno de laboratorio no más de 25
- **Para**: Evitar clases con demasiados alumnos

**RN007 - Pertenencia de alumnos a grupos**
- **Como**: Director del Centro
- **Quiero**: Un alumno no puede pertenecer a más de un grupo de teoría y a más de un grupo de prácticas de cada asignatura
- **Para**: Evitar duplicidad en las listas de clases

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

### Diagrama de clases

![Diagrama de clases y asociaciones](/assets/images/laboratorios/fig/req/d_conceptual.svg)

![Diagrama de clases (enumerados)](/assets/images/laboratorios/fig/req/enum.svg)

### Diagrama de objetos

![Diagrama de objetos](/assets/images/laboratorios/fig/req/d_objetos.svg)

## Modelo Relacional

### Intensión


```text
Degrees(degreeId, name, years)
    PK(degreeId)

Subjects(subjectId, degreeId, name, acronym, credits, year, type)
    PK(subjectId)
    FK(degreeId) / Degrees

Groups(groupId, subjectId, name, activity, year)
    PK(groupId)
    FK(subjectId) / Subjects

Students(studentId, accessMethod, dni, firstName, surname, birthDate, email, password)
    PK(studentId)

Grades(gradeId, studentId, groupId, value, gradeCall, withHonours)
    PK(gradeId)
    FK(studentId) / Students
    FK(groupId) / Groups

GroupsStudents(groupStudentId, studentId, groupId)
    PK(groupStudentId)
    FK(studentId) / Students
    FK(groupId) / Groups
```

### Extensión
```python
Degrees = {
    (d1, "Ingeniería del Software", 4),
    (d2, "Ingeniería del Computadores", 4),
    (d3, "Tecnologías Informáticas", 4)
}

Subjects = {
    (s1, d3, "Fundamentos de Programación", "FP", 12, 1, "Formacion Básica"),
    (s2, d3, "Lógica Informática", "LI", 6, 2, "Optativa")
}

Groups = {
    (g1, s1, "T1", "Teoría", 2019),
    (g2, s1, "L1", "Laboratorio", 2019),
    (g3, s1, "L2", "Laboratorio", 2019)
}

Students = {
    (st1, "Selectividad", "12345678A", "Daniel", "Pérez", "1991-01-01", "daniel@alum.us.es", "pw1"),
    (st2, "Selectividad", "22345678A", "Rafael", "Ramírez", "1992-01-01", "rafael@alum.us.es", "pw2"),
    (st3, "Selectividad", "32345678A", "Gabriel", "Hernández", "1993-01-01", "gabriel@alum.us.es", "pw3")
}

GroupsStudents = {
    (gs1, g1, st1),
    (gs2, g3, st1)
}

Grades = {
    (gr1, 4.50, 1, 0, st1, g1),
    (gr2, 5.00, 1, 0, st2, g1),
    (gr3, 6.00, 1, 0, st3, g1),
    (gr4, 7.00, 2, 0, st1, g1),
    (gr5, 9.00, 2, 1, st2, g1),
    (gr6, 9.00, 2, 0, st3, g1),
    (gr7, 10.00, 3, 0, st1, g3),
    (gr8, 5.50, 3, 0, st2, g3),
    (gr9, 6.00, 2, 1, st3, g3)
}
```

## Pruebas de aceptación
### Grados
- ✅ Crear grado con datos correctos. 
- ❌ Crear grado con nombre vacío. 
- ❌ Crear grado con el mismo nombre que otro ya existente. 
- ❌ Crear grado con años incorrecto. 
- ✅ Actualizar grado con datos correctos. 
- ❌ Actualizar grado con nombre a None. 
- ❌ Actualizar grado con el mismo nombre que otro existente. 
- ❌ Actualizar grado con años incorrectos. 
- ✅ Eliminar grado. 
- ❌ Eliminar grado no existente. 
- ❌ Eliminar grado con relaciones. 

### Asignaturas
- ✅ Crear asignatura con datos correctos. 
- ❌ Crear asignatura con nombre vacío. 
- ❌ Crear asignatura con el mismo nombre que otra ya existente. 
- ❌ Crear asignatura con acrónimo vacío. 
- ❌ Crear asignatura con el mismo acrónimo que una ya existente. 
- ❌ Crear asignatura con créditos incorrectos. 
- ❌ Crear asignatura con curso incorrecto. 
- ❌ Crear asignatura con tipo incorrecto. 
- ✅ Actualizar asignatura con valores correctos. 
- ❌ Actualizar asignatura con el mismo nombre que otra. 
- ❌ Actualizar asignatura con nombre a None. 
- ❌ Actualizar asignatura con el mismo acrónimo que otra. 
- ❌ Actualizar asignatura con acrónimo a None. 
- ❌ Actualizar asignatura con créditos incorrectos. 
- ❌ Actualizar asignatura con curso incorrecto. 
- ❌ Actualizar asignatura con tipo incorrecto. 
- ✅ Borrar asignatura. 
- ❌ Borrar asignatura que ha sido borrada. 
- ❌ Borrar asignatura con relaciones. 
- ❌ Crear una asignación entre grado y asignatura, con grado a None. 
- ❌ Actualizar una asignación entre grado y asignatura, con grado a None. 

### Alumnos
- ✅ Crear alumno con datos correctos. 
- ❌ Crear alumno con el mismo DNI que otro. 
- ❌ Crear alumno con el mismo email que otro. 
- ❌ Crear alumno con formato de fecha de nacimiento incorrecto. 
- ❌ Crear alumno con método de acceso incorrecto. 
- ❌ Crear alumno con nombre vacío. 
- ❌ Crear alumno con apellidos vacío. 
- ❌ Crear alumno con email vacío. 
- ❌ Crear alumno con DNI vacío. 
- ✅ Actualizar alumno con datos correctos. 
- ❌ Actualizar alumno con el mismo DNI que otro. 
- ❌ Actualizar alumno con el mismo email que otro. 
- ❌ Actualizar alumno con formato de fecha de nacimiento incorrecto. 
- ❌ Actualizar alumno con método de acceso incorrecto. 
- ❌ Actualizar alumno con nombre vacío. 
- ❌ Actualizar alumno con apellidos vacío. 
- ❌ Actualizar alumno con email vacío. 
- ❌ Actualizar alumno con DNI vacío. 
- ✅ Borrar alumno. 
- ❌ Borrar alumno que no existe. 
- ❌ Borrar alumno con relaciones. 
