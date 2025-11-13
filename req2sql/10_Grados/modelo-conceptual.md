---
layout: default
published: false
title: Modelo Conceptual
parent: Grados
nav_order: 2
---

## Modelo conceptual

![Diagrama de clases]({{ '/assets/images/req2sql/Grados/grados-dc.png' | relative_url }})

![Diagrama de objetos]({{ '/assets/images/req2sql/Grados/grados-do.png' | relative_url }})

### Comentario del diagrama de clases

El modelo implementa un sistema completo de gestión académica universitaria con grados, asignaturas, grupos y calificaciones.

- **Entidades académicas**: Grado, Asignatura, Grupo, Alumno, Nota.
- **Estructura curricular**: Un Grado incluye 1..* Asignaturas organizadas por cursos; una Asignatura pertenece a 1 Grado y se divide en 1..* Grupos (teoría/laboratorio).
- **Gestión de calificaciones**: Un Alumno obtiene 0..* Notas en diferentes Asignaturas; cada Nota está asociada a un Grupo específico con convocatoria y año académico.
- **Atributos clave**: Grado (nombre, años, créditos), Asignatura (nombre, acrónimo, tipo), Grupo (actividad, capacidad), Nota (valor, convocatoria, matrícula honor).
- **Restricciones complejas**: Máximo 6 convocatorias por asignatura; capacidad limitada por tipo de grupo (75 teoría, 25 laboratorio); nota ≥9 para matrícula de honor.

### Comentario del diagrama de objetos

Las instancias representan un escenario académico completo con estudiantes, asignaturas y calificaciones reales.

- **Grados**: Titulaciones con estructura curricular definida (años, créditos totales) y asignaturas distribuidas por cursos.
- **Asignaturas y grupos**: Materias con grupos de teoría y laboratorio, diferentes capacidades y horarios según actividad.
- **Alumnos**: Estudiantes matriculados con diferentes métodos de acceso y expedientes académicos variados.
- **Calificaciones**: Notas en múltiples convocatorias, algunas con matrícula de honor, reflejando progreso académico realista.
