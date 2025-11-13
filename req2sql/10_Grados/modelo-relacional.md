---
layout: default
published: false
title: Modelo Relacional
parent: Grados
nav_order: 3
---

# Modelo relacional

## Intensión

```
Degrees(degreeId, name, duration)
	PK(degreeId)
Subjects(subjectId, departmentId, gradeId, name, acronym, credits, year, type)
	PK(subjectId)
	FK(departmentId) / Departments
	FK(gradeId) / Degrees
Groups(groupId, subjectId, name, activity, academicYear)
	PK(groupId)
	FK(subjectId) / Subjects
Students(studentId, accessMethod, dni, firstname, surname, birthDate, email)
	PK(studentId)
	AK(dni)
	AK(email)
Grades(gradeId, studentId, groupId, value, call, withHonours)
	PK(gradeId)
	FK(studentId) / Students
	FK(groupId) / Groups
StudentsGroups(studentGroupId, studentId, groupId)
	PK(studentGroupId)
	FK(studentId) / Students
	FK(groupId) / Groups
```

## Álgebra relacional (ejemplos)

- Asignaturas con sus grupos:

$$
SG \leftarrow Subjects \NatJoin Groups
$$

- Matrícula de estudiantes con sus grupos:

$$
Mat \leftarrow Students \NatJoin StudentsGroups \NatJoin Groups
$$

- Media de calificaciones por estudiante:

$$
\Group{\operatorname{AVG}(value)}{studentId}(Grades)
$$
