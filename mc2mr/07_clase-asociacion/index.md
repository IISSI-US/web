---
layout: single
title: Ejercicio 7
toc: true
toc_label: "Contenido"
sidebar:
    nav: mc2mr
---

# Ejercicio 7: Clase Asociación: Estudiante ↔ Curso con Inscripción
<!-- {: .fs-9 } -->

Asociaciones con atributos propios y multiplicidad
<!-- {: .fs-6 .fw-300 } -->

---

## Diagrama UML (Clases)
![Diagrama de Clases](/mc2mr/ejercicio-07-clase-asociacion-clases.png)

## Intensión relacional
```
Estudiantes(estudianteId, nombre, email, fechaNacimiento)
    PK(estudianteId)

Cursos(cursoId, nombre, codigo, creditos)
    PK(cursoId)
    AK(codigo)

Inscripciones(inscripcionId, estudianteId, cursoId, fechaInscripcion, calificacionFinal, estado)
    PK(inscripcionId)
    FK(estudianteId)/Estudiantes
    FK(cursoId)/Cursos
    AK(estudianteId,cursoId) -- el modelo no lo indica, pero parece lógico
```

<!-- ## Diagrama de objetos
![Diagrama de Objetos](/mc2mr/ejercicio-07-clase-asociacion-objetos.png) -->

## Extensión relacional
```text
Estudiantes = {
    (e1, 'Ana García', 'ana@universidad.edu', 2000-05-15),
    (e2, 'Carlos López', 'carlos@universidad.edu', 1999-11-22),
    (e3, 'María González', 'maria@universidad.edu', 2001-03-08),
    (e4, 'David Martín', 'david@universidad.edu', 2000-09-12),
    (e5, 'Laura Herrera', 'laura@universidad.edu', 1999-07-25),
    (e6, 'Pablo Ruiz', 'pablo@universidad.edu', 2001-01-30)
}

Cursos = {
    (c1, 'Programación en Java', 'CS101', 4),
    (c2, 'Bases de Datos', 'CS201', 3),
    (c3, 'Algoritmos y Estructuras', 'CS102', 4),
    (c4, 'Sistemas Operativos', 'CS301', 3),
    (c5, 'Desarrollo Web', 'CS250', 2),
    (c6, 'Inteligencia Artificial', 'CS401', 4)
}

Inscripciones = {
    (i1, e1, c1, 2023-08-15, 8.5, 'Completado'),
    (i2, e2, c2, 2023-08-15, 9.2, 'Completado'),
    (i3, e2, c1, 2023-08-20, null, 'En Curso'),
    (i4, e3, c1, 2023-08-15, 7.8, 'Completado'),
    (i5, e3, c3, 2023-09-01, 9.5, 'Completado'),
    (i6, e4, c2, 2023-08-20, 6.2, 'Completado'),
    (i7, e4, c4, 2023-09-10, null, 'En Curso'),
    (i8, e5, c1, 2023-08-15, 9.8, 'Completado'),
    (i9, e5, c5, 2023-09-05, 8.9, 'Completado'),
    (i10, e6, c3, 2023-09-01, null, 'En Curso'),
    (i11, e1, c2, 2023-09-15, null, 'En Curso'),
    (i12, e3, c5, 2023-09-20, 7.5, 'Completado')
}
```

---

## Álgebra relacional

### Enunciados

**1.** Obtener todos los estudiantes inscritos en el curso 'Programación en Java'

**2.** Obtener todas las inscripciones completadas con calificación superior a 8.0

**3.** Obtener el nombre y email de estudiantes que están actualmente en cursos en estado 'En Curso'

**4.** Obtener todos los cursos en los que está inscrita 'María González'

**5.** Obtener la calificación promedio de todos los cursos completados

**6.** Obtener estudiantes que han completado más de 2 cursos

**7.** Obtener el curso con más inscripciones

**8.** Obtener estudiantes nacidos en el año 2000

**9.** Obtener cursos que no tienen ninguna inscripción

**10.** Obtener la inscripción con la calificación más alta

### Soluciones

**Renombramiento de relaciones:**

$$E \leftarrow \Ren{E(eid,nom,ema,fna)}(Estudiantes)$$

$$C \leftarrow \Ren{C(cid,nom,cod,cre)}(Cursos)$$

$$I \leftarrow \Ren{I(iid,eid,cid,fin,cal,est)}(Inscripciones)$$

**1. Obtener todos los estudiantes inscritos en el curso 'Programación en Java'**

$$CJ \leftarrow \Sel{nom = 'Programación en Java'}(C)$$

$$EJids \leftarrow \Proj{eid}(I \Join CJ)$$

$$EJids \Join E$$

```
Resultado: {
    (e1, 'Ana García', 'ana@universidad.edu', 2000-05-15),
    (e2, 'Carlos López', 'carlos@universidad.edu', 1999-11-22),
    (e3, 'María González', 'maria@universidad.edu', 2001-03-08),
    (e5, 'Laura Herrera', 'laura@universidad.edu', 1999-07-25)
}
```

**2. Obtener todas las inscripciones completadas con calificación superior a 8.0**

$$\Sel{est = 'Completado' \land cal > 8.0}(I)$$

```
Resultado: {
    (i1, e1, c1, 2023-08-15, 8.5, 'Completado'),
    (i2, e2, c2, 2023-08-15, 9.2, 'Completado'),
    (i5, e3, c3, 2023-09-01, 9.5, 'Completado'),
    (i8, e5, c1, 2023-08-15, 9.8, 'Completado'),
    (i9, e5, c5, 2023-09-05, 8.9, 'Completado')
}
```

**3. Obtener el nombre y email de estudiantes que están actualmente en cursos en estado 'En Curso'**

$$EstEnCursoIDS \leftarrow \Proj{eid}\left(\Sel{est = 'En Curso'}(I)\right)$$

$$\Proj{nom, ema}(EstEnCursoIDS \Join E)$$

```
Resultado: {
    ('Carlos López', 'carlos@universidad.edu'),
    ('David Martín', 'david@universidad.edu'),
    ('Pablo Ruiz', 'pablo@universidad.edu'),
    ('Ana García', 'ana@universidad.edu')
}
```

**4. Obtener todos los cursos en los que está inscrita 'María González'**

$$
\Proj{C.cid, c.nom, c.cod, c.cre}\left(\Sel{E.nom='\\text{María González}'}(E \Join I \Join C)\right)
$$

```
Resultado: {
    (c1, 'Programación en Java', 'CS101', 4),
    (c3, 'Algoritmos y Estructuras', 'CS102', 4),
    (c5, 'Desarrollo Web', 'CS250', 2)
}
```

**5. Obtener la calificación promedio de todos los cursos completados**

$$calPromedio \leftarrow \Group{AVG(cal)}{}\left(\Sel{est = 'Completado'}(I)\right)$$

```
Resultado: {
    (8.46)  -- (8.5 + 9.2 + 7.8 + 9.5 + 6.2 + 9.8 + 8.9 + 7.5) / 8
}
```

**6. Obtener estudiantes que han completado más de 2 cursos**

$$EstComIDS \leftarrow \Group{eid, \Ren{numCursos}COUNT(*)}{eid}\left(\Sel{est = 'Completado'}(I)\right)$$

$$EstMasDosIDS \leftarrow \Proj{eid}\left(\Sel{numCursos > 2}(EstComIDS)\right)$$

$$EstMasDosIDS \Join E$$

```
Resultado: {
    (e3, 'María González', 'maria@universidad.edu', 2001-03-08)
}
```

**7. Obtener el curso con más inscripciones**

$$InsPorCurso \leftarrow \Group{cid, \Ren{numIns}COUNT(*)}{cid}(I)$$

$$maxIns \leftarrow \Group{MAX(numIns)}{}(InsPorCurso)$$

$$CursoPopularID \leftarrow \Proj{cid}\left(\Sel{numIns = maxIns}(InsPorCurso)\right)$$

$$CursoPopularID \Join C$$

```
Resultado: {
    (c1, 'Programación en Java', 'CS101', 4)
}
```

**8. Obtener estudiantes nacidos en el año 2000**

$$\Sel{fna \geq '2000-01-01' \land fna < '2001-01-01'}(E)$$

```
Resultado: {
    (e1, 'Ana García', 'ana@universidad.edu', 2000-05-15),
    (e4, 'David Martín', 'david@universidad.edu', 2000-09-12)
}
```

**9. Obtener cursos que no tienen ninguna inscripción**

$$CursosConInsID \leftarrow \Proj{cid}(I)$$

$$C - CursosConInsID$$

```
Resultado: {
    (c6, 'Inteligencia Artificial', 'CS401', 4)
}
```

**10. Obtener la inscripción con la calificación más alta**

$$calMax \leftarrow \Group{MAX(cal)}{}(\Sel{est = 'Completado'}(I))$$

$$\Sel{cal = calMax}(I)$$

```
Resultado: {
    (i8, e5, c1, 2023-08-15, 9.8, 'Completado')
}
```
