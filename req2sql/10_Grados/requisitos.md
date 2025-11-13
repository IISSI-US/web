---
layout: default
published: false
title: Requisitos
parent: Grados
nav_order: 1
---

# Catálogo de Requisitos

Un centro universitario desea desarrollar un sistema para automatizar el servicio de gestión académica con la información relativa a alumnos y asignaturas impartidas en el centro, incluidas las notas. Iniciado el estudio del dominio del problema, de las necesidades de negocio y de la situación actual y realizadas varias entrevistas, se han desarrollado los siguientes requisitos que debe cumplir el sistema de información a desarrollar.

## Requisitos de información

### RI-001: Información sobre grados
- Como: Secretario
- Quiero: Disponer de la información correspondiente a los grados impartidos en el Centro: nombre, el número de años y el número de créditos que se calcula como el número de años multiplicado por 60. Varias asignaturas forman parte de un grado y una asignatura pertenece a un único grado
- Para: Poder realizar los planes de gestión docente

### RI-002: Información sobre asignaturas
- Como: Responsable docente
- Quiero: Disponer de la información correspondiente a las asignaturas impartidas en el centro: nombre, acrónimo, créditos, curso y tipo (Obligatoria, Optativa, Formación Básica). Cada asignatura está formada por grupos.
- Para: Poder realizar los planes de asignación docente

### RI-003: Información sobre grupos
- Como: Secretario
- Quiero: Disponer de la información correspondiente a los grupos de actividad de las asignaturas: nombre, año académico y créditos. La actividad que puede ser Teoría o Laboratorio. Un grupo de actividad de teoría debe tener al menos 15 alumnos, en el que se imparten clases de una asignatura y se obtienen notas para estos alumnos.
- Para: Poder conocer la disposición de los alumnos en grupos

### RI-004: Información sobre alumnos
- Como: Profesor
- Quiero: Disponer de la información correspondiente a los alumnos matriculados en el centro: DNI, nombre, apellidos, fecha de nacimiento, email y método de acceso que puede ser (Selectividad, Ciclo, Mayor, Titulado Extranjero). Un alumno obtiene una serie de notas correspondientes a cada asignatura, estas notas se asocian al grupo, de forma que, si hay varios grupos para un mismo año académico y asignatura, un alumno solo debe obtener una nota por convocatoria para uno de ellos. Cada nota está formada por un valor numérico entre 0.0 y 10.0, un número de convocatoria y debe constar si es matrícula de honor o no. Un alumno puede agotar hasta seis convocatorias para aprobar la asignatura.
- Para: Poder realizar las gestiones académicas correspondientes (matrícula, gestión de pagos...)

## Reglas de negocio

### RN-001: Matrícula de honor
- Como: Director del Centro
- Quiero: Para que una nota sea matrícula de honor es necesario que su valor sea igual o superior a 9
- Para: Poder cumplir la normativa de la propia Universidad

### RN-002: Nota por alumno
- Como: Director del Centro
- Quiero: Un alumno no puede tener más de una nota para la misma asignatura, convocatoria y año académico
- Para: Poder cumplir la normativa de la propia Universidad

### RN-003: Restricción de edad
- Como: Director del Centro
- Quiero: Un alumno no puede acceder por selectividad teniendo menos de 16 años
- Para: Poder cumplir la normativa de la propia Universidad

### RN-004: Alumno pertenece a grupo
- Como: Director del Centro
- Quiero: Un alumno no puede tener notas en grupos a los que no pertenece
- Para: Poder cumplir la normativa de la propia Universidad

### RN-005: Cambios bruscos en notas
- Como: Director del Centro
- Quiero: Una nota no puede alterarse de una vez en más de 4 puntos (aumentada o disminuida)
- Para: Evitar cambios bruscos accidentales en las notas

### RN-006: Alumnos máximos en grupos
- Como: Director del Centro
- Quiero: Un grupo de teoría no puede tener más de 75 alumnos, y uno de laboratorio no más de 25
- Para: Evitar clases con demasiados alumnos

### RN-007: Alumnos máximos en grupos
- Como: Director del Centro
- Quiero: Un grupo de teoría no puede tener más de 75 alumnos, y uno de laboratorio no más de 25
- Para: Evitar clases con demasiados alumnos

### RN-008: Acrónimos bien formados
- Como: Director del Centro
- Quiero: Un acrónimo tiene que estar bien formado, se entiende que lo está cuando coincide con las letras mayúsculas que aparecen en el nombre de la asignatura
- Para: Evitar acrónimos mal formados

### RN-009: Pertenencia de alumnos a grupos
- Como: Director del Centro
- Quiero: Un alumno no puede pertenecer a más de un grupo de teoría y a más de un grupo de prácticas de cada asignatura
- Para: Evitar duplicidad en las listas de clases

## Requisitos funcionales

### RF-001: Añadir nota
- Como: Profesor del centro
- Quiero: Añadir una nota a un alumno en una asignatura
- Para: Poder controlar las calificaciones de todos los alumnos

### RF-002: Borrar notas de alumno
- Como: Director del centro
- Quiero: Borrar todas las notas de un alumno con DNI dado
- Para: Eliminar expedientes académicos antiguos

### RF-003: Listado de alumnos
- Como: Director del centro
- Quiero: Disponer de un listado de alumnos por orden alfabético con nombre, apellidos, asignatura y grupo
- Para: Publicar un censo de alumnos

### RF-004: Listado de alumnos mayores
- Como: Director del centro
- Quiero: Disponer de un listado de los alumnos cuyo método de acceso sea mayor de 40 años
- Para: Analizar qué alumnos han entrado al centro por este método de acceso

### RF-005: Asignaturas de un grado y curso
- Como: Alumno
- Quiero: Conocer las asignaturas (nombre, acrónimo, créditos y tipo) de un grado para un curso concreto ordenadas por el acrónimo
- Para: Ver las asignaturas que se imparten en dicho curso

### RF-006: Expediente de alumno
- Como: Alumno
- Quiero: Conocer las notas finales de cada asignatura que ha cursado, es decir, las de mayor año y convocatoria
- Para: Conocer las asignaturas que le quedan por cursar

### RF-007: Nota media de alumno
- Como: Alumno
- Quiero: Conocer mi nota media actual
- Para: Poder ver mi progreso a lo largo del grado

### RF-008: Listado de asignaturas de un grado
- Como: Director del centro
- Quiero: Disponer de un listado de las asignaturas de un grado
- Para: Poder ver información sobre las asignaturas de un grado

## Pruebas de aceptación

### PA-001: Grados
1. ✅ Crear grado con datos correctos.
2. ❌ Crear grado con nombre vacío.
3. ❌ Crear grado con el mismo nombre que otro ya existente.
4. ❌ Crear grado con años incorrecto.
5. ✅ Actualizar grado con datos correctos.
6. ❌ Actualizar grado con nombre a None.
7. ❌ Actualizar grado con el mismo nombre que otro existente.
8. ❌ Actualizar grado con años incorrectos.
9. ✅ Eliminar grado.
10. ❌ Eliminar grado no existente.
11. ❌ Eliminar grado con asociaciones.
12. ✅ Crear una asignación entre grado y asignatura.
13. ❌ Crear una asignación entre grado y asignatura que ya existe
14. ❌ Crear una asignación entre grado y asignatura, con asignatura a None.
15. ❌ Crear una asignación entre grado y asignatura, con grado a None.
16. ✅ Actualizar una asignación entre grado y asignatura.
17. ❌ Actualizar una asignación entre grado y asignatura, con asignatura y grado ya existente.
18. ❌ Actualizar una asignación entre grado y asignatura, con asignatura a None.
19. ❌ Actualizar una asignación entre grado y asignatura, con grado a None.
20. ✅ Borrar una asignación entre grado y asignatura.
21. ❌ Borrar una asignación entre grado y asignatura, que no existe.

### PA-002: Asignaturas
1. ✅ Crear asignatura con datos correctos.
2. ❌ Crear asignatura con nombre vacío.
3. ❌ Crear asignatura con el mismo nombre que otra ya existente.
4. ❌ Crear asignatura con acrónimo vacío.
5. ❌ Crear asignatura con el mismo acrónimo que una ya existente.
6. ❌ Crear asignatura con créditos incorrectos.
7. ❌ Crear asignatura con curso incorrecto.
8. ❌ Crear asignatura con tipo incorrecto.
9. ✅ Actualizar asignatura con valores correctos.
10. ❌ Actualizar asignatura con el mismo nombre que otra.
11. ❌ Actualizar asignatura con nombre a None.
12. ❌ Actualizar asignatura con el mismo acrónimo que otra.
13. ❌ Actualizar asignatura con acrónimo a None.
14. ❌ Actualizar asignatura con créditos incorrectos.
15. ❌ Actualizar asignatura con curso incorrecto.
16. ❌ Actualizar asignatura con tipo incorrecto.
17. ✅ Borrar asignatura.
18. ❌ Borrar asignatura que ha sido borrada.
19. ❌ Borrar asignatura con datos.

### PA-003: Alumnos
1. ✅ Crear alumno con datos correctos.
2. ✅ Crear alumno con el mismo DNI, nombre y apellidos que un profesor.
3. ✅ Crear alumno con el mismo DNI, email, nombre y apellidos que un profesor.
4. ✅ Crear alumno con un solo apellido.
5. ❌ Crear alumno con el mismo DNI que otro.
6. ❌ Crear alumno con el mismo email que otro.
7. ❌ Crear alumno con fecha de nacimiento en futuro.
8. ❌ Crear alumno con formato de fecha de nacimiento incorrecto.
9. ❌ Crear alumno con email incorrecto.
10. ❌ Crear alumno con el mismo DNI que un profesor y diferente nombre y apellido.
11. ❌ Crear alumno con el mismo email que un profesor y diferente nombre y apellido.
12. ❌ Crear alumno con email incorrecto.
13. ❌ Crear alumno con método de acceso incorrecto.
14. ❌ Crear alumno con nombre vacío.
15. ❌ Crear alumno con apellidos vacío.
16. ❌ Crear alumno con email vacío.
17. ❌ Crear alumno con DNI vacío.
18. ✅ Actualizar alumno con datos correctos.
19. ✅ Actualizar alumno con un apellido.
20. ❌ Actualizar alumno con el mismo DNI que otro.
21. ❌ Actualizar alumno con el mismo email que otro.
22. ❌ Actualizar alumno con fecha de nacimiento incorrecta.
23. ❌ Actualizar alumno con fecha de nacimiento en futuro.
24. ❌ Actualizar alumno con email incorrecto.
25. ❌ Actualizar alumno con método de acceso incorrecto.
26. ❌ Actualizar alumno con nombre a None.
27. ❌ Actualizar alumno con apellidos a None.
28. ❌ Actualizar alumno con email a None.
29. ❌ Actualizar alumno con DNI a None.
30. ✅ Borrar alumno.
31. ❌ Borrar alumno que no existe.
32. ❌ Borrar alumno tiene datos asignados.
33. ✅ Crear una nota con valores correctos.
34. ❌ Crear una nota con el valor incorrecto.
35. ❌ Crear una nota con convocatoria incorrecta.
36. ❌ Crear una nota con esmatricula a True y valor menor a nueve.
37. ❌ Crear una nota para la misma asignatura y convocatoria.
38. ❌ Crear una nota con asignatura a None.
39. ❌ Crear una nota para una matrícula no cerrada.
40. ✅ Actualizar una nota con valores correctos.
41. ❌ Actualizar una nota con valor a None.
42. ❌ Actualizar una nota con convocatoria a None.
43. ❌ Actualizar una nota con esMatricula a None.
44. ❌ Actualizar una nota con la misma convocatoria y asignatura.
45. ❌ Actualizar una nota con asignatura a None.
46. ✅ Borrar una nota.
47. ❌ Borrar una nota que no existe.
48. ❌ Se asigna un alumno a dos grupos de teoría de la misma asignatura.
49. ✅ Se asigna un alumno a un grupo de laboratorio. El alumno ya tiene asignado un grupo de teoría de esa asignatura.
