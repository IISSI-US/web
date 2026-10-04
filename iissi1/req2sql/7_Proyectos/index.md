---
title: Proyectos
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Requisitos

La trascripción que aparece a continuación corresponde a una entrevista a una ingeniera de software que necesita un
sistema de información para ayudarle en la gestión de sus proyectos.

- Pregunta: Bien, coménteme cuál sería el principal objetivo del sistema que usted necesita.
- Respuesta: Bueno, básicamente lo que quiero es un gestor de proyectos sencillo, que me permita gestionar las tareas
  asociadas y asignárselas a los empleados.
- P: Empecemos entonces por los proyectos, ¿qué información quiere que gestione el sistema sobre ellos?
- R: Básicamente, el nombre del proyecto, una descripción y el presupuesto que tiene. Puede que luego sea interesante
  añadirle más información, pero de momento me valdría con eso.
- P: De acuerdo, ha hablado antes de tareas. ¿Me puede explicar ese concepto?
- R: Sí, claro. Nosotros descomponemos los proyectos en tareas, lo que se conoce como WBS (Work Breakdown Structure).
  Cada tarea tiene un identificador que usamos para referirnos a ella, p.e. la tarea T-28F. También tienen una descripción
  y una estimación del coste de su realización. En el caso de que una tarea sea muy compleja, puede descomponerse en
  subtareas, que también pueden descomponerse recursivamente.
- P: Entiendo, ¿esas tareas tienen algún orden especial?
- R: El que le vayamos dando al crearlas, aunque luego podríamos cambiarlo.
- P: Entiendo, un proyecto tiene una secuencia de tareas que a su vez pueden tener una secuencia de subtareas y así
  recursivamente. Debemos conocer el orden. ¿Qué más hay que saber sobre las tareas?
- R: Pues que una vez que creamos la WBS, vamos asignando las tareas a los empleados.
- P: ¿En qué consiste una asignación de una tarea a un empleado?
- R: Básicamente, se encarga a un empleado la realización de una tarea con una fecha de inicio y otra de fin.
- P: ¿A cuántos empleados se le asigna una misma tarea?
- R: Cuando decidimos a quién asignársela, a uno sólo. Nuestras tareas simples están pensadas para que las pueda realizar
  un solo empleado.
- P: ¿Qué es una tarea simple?
- R: Una tarea que no está descompuesta en tareas más simples.
- P: Entiendo, sólo se asignan tareas simples, ¿no es así?
- R: Bueno, no necesariamente. Podemos asignar tareas complejas para su supervisión.
- P: Entiendo, se puede asignar cualquier tarea (compleja o simple) a cualquier empleado.
- R: Sí, aunque eso depende del rol que tenga el empleado en el proyecto.
- P: Explíqueme eso.
- R: Bueno, en cada proyecto se definen una serie de roles y cada empleado puede desempeñar distintos roles en distintos
  proyectos. Por ejemplo, uno puede ser el director de un proyecto y a la vez ser el responsable de pruebas de otro
  proyecto.
- P: Entiendo, ¿un mismo empleado puede jugar más de un rol en un mismo proyecto?
- R: No es frecuente, pero podría ocurrir, especialmente en proyectos pequeños.
- P: Una vez establecido un rol de un empleado en un proyecto, ¿puede cambiar?
- R: Sí, reasignamos los empleados según los proyectos que van saliendo.
- P: Entonces, le interesa saber desde qué fecha hasta qué fecha un empleado ha desempeñado un rol en un proyecto
  ¿no?
- R: Sí, quiero saber qué empleados han ido pasando por cada proyecto y en qué fechas.
- P: Entiendo que cada rol está asociado a un cargo predefinido, ¿es así?
- R: Sí, claro. Los nombres de los roles coinciden con los cargos habituales: director, analista, responsable de pruebas, etc.
  Tenemos definidos los roles según la norma ISO-9001.
- P: Muy bien, creo que con eso tengo para una primera versión. Gracias.

# Modelo Conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/proyectos/proyectos-dc.png' | relative_url }})

# Modelo Relacional

## Intensión

```mr-table
Proyectos = { proyectoId, nombre, descripcion, presupuesto }
	PK(proyectoId)
Roles = { rolId, proyectoId, nombre }
	PK(rolId)
	FK(proyectoId) / Proyectos
Tareas = { tareaId, proyectoId, orden, id, descripcion, estimacion }
	PK(tareaId)
	FK(proyectoId) / Proyectos
	AK(proyectoId, orden)
Subtareas = { subtareaId, tareaId, orden }
	PK(subtareaId)
	FK(subtareaId) / Tareas
	FK(tareaId) / Tareas
	AK(tareaId, orden)
Empleados = { empleadoId, dni, nombre }
	PK(empleadoId)
	AK(dni)
PeriodosCargos = { periodoCargoId, empleadoId, rolId, fInicio, fFin }
	PK(periodoCargoId)
	FK(empleadoId) / Empleados
	FK(rolId) / Roles
PeriodosTareas = { periodoTareaId, empleadoId, tareaId, fInicio, fFin }
	PK(periodoTareaId)
	FK(empleadoId) / Empleados
	FK(tareaId) / Tareas

Proyectos = {
	(1, "Portal de alquileres", "Plataforma de alquiler de viviendas", 50000.00),
	(2, "Gestor interno", "Herramientas internas del equipo", 90000.00)
}

Roles = {
	(r1, 1, "Director"),
	(r2, 1, "Analista"),
	(r3, 2, "Responsable de pruebas")
}

Tareas = {
	(t1, 1, 1, "T-01", "Diseño del modelo", 40),
	(t2, 1, 2, "T-02", "Implementación de API", 80),
	(t3, 2, 1, "T-10", "Plan de pruebas", 60),
	(t4, 1, 3, "T-03", "Pruebas unitarias", 30),
	(t5, 1, 4, "T-04", "Pruebas de integración", 25),
	(t6, 2, 2, "T-11", "Validación del plan de pruebas", 30)
}

Subtareas = {
	(t4, t2, 1),
	(t5, t4, 1),
	(t6, t3, 1)
}

Empleados = {
	(e1, "11111111A", "Ana García"),
	(e2, "22222222B", "Luis Pérez"),
	(e3, "33333333C", "Marta López"),
	(e4, "44332211D", "Ana Rueda")
}

PeriodosCargos = {
	(pc1, e1, r1, "2024-01-01", "2024-01-31"),
	(pc2, e1, r1, "2024-02-01", NULL),
	(pc3, e2, r2, "2024-01-15", NULL),
	(pc4, e3, r3, "2024-02-01", NULL),
	(pc5, e4, r1, "2024-03-01", NULL)
}

PeriodosTareas = {
	(pt1, e2, t1, "2024-02-01", "2024-02-15"),
	(pt2, e1, t1, "2024-02-16", "2024-02-28"),
	(pt3, e2, t1, "2024-03-01", "2024-03-15"),
	(pt4, e2, t2, "2024-02-16", NULL),
	(pt5, e3, t3, "2024-03-01", NULL),
	(pt6, e2, t4, "2024-02-20", NULL)
}
```

RN-01: La descripción del proyecto y las referencias obligatorias no admiten
valores nulos. RN-02: Los periodos pueden repetirse en el historial; su fecha de
fin es opcional y, si existe, no precede a la fecha de inicio; las fechas son
inclusivas. RN-03: Los periodos de una tarea no se solapan. RN-04: Cada subtarea
pertenece al mismo proyecto que su tarea padre. RN-05: Varios empleados pueden
desempeñar el mismo rol simultáneamente.

## Álgebra relacional

- Renombrado:

$$
P \leftarrow \Ren{P(pid,pn,pdesc,pres)}(Proyectos)
$$

$$
R \leftarrow \Ren{R(rid,pid,rn)}(Roles)
$$

$$
T \leftarrow \Ren{T(tid,pid,ord,cod,tdesc,est)}(Tareas)
$$

$$
E \leftarrow \Ren{E(eid,dni,en)}(Empleados)
$$

$$
PC \leftarrow \Ren{PC(pcid,eid,rid,fi,ff)}(PeriodosCargos)
$$

$$
PT \leftarrow \Ren{PT(ptid,eid,tid,fi,ff)}(PeriodosTareas)
$$

$$
ST \leftarrow \Ren{ST(stid,tid,sord)}(Subtareas)
$$

- Empleados con roles en proyectos:

$$
ER \leftarrow E \NatJoin PC \NatJoin R
$$

```mr-table
ER = { eid, dni, en, pcid, rid, fi, ff, pid, rn }

ER = {
	(e1, "11111111A", "Ana García", pc1, r1, "2024-01-01", "2024-01-31", 1, "Director"),
	(e1, "11111111A", "Ana García", pc2, r1, "2024-02-01", NULL, 1, "Director"),
	(e2, "22222222B", "Luis Pérez", pc3, r2, "2024-01-15", NULL, 1, "Analista"),
	(e3, "33333333C", "Marta López", pc4, r3, "2024-02-01", NULL, 2, "Responsable de pruebas"),
	(e4, "44332211D", "Ana Rueda", pc5, r1, "2024-03-01", NULL, 1, "Director")
}
```

- Empleados con tareas en proyectos:

$$
ET \leftarrow E \NatJoin PT \NatJoin T
$$

```mr-table
ET = { eid, dni, en, ptid, tid, fi, ff, pid, ord, cod, tdesc, est }

ET = {
	(e2, "22222222B", "Luis Pérez", pt1, t1, "2024-02-01", "2024-02-15", 1, 1, "T-01", "Diseño del modelo", 40),
	(e1, "11111111A", "Ana García", pt2, t1, "2024-02-16", "2024-02-28", 1, 1, "T-01", "Diseño del modelo", 40),
	(e2, "22222222B", "Luis Pérez", pt3, t1, "2024-03-01", "2024-03-15", 1, 1, "T-01", "Diseño del modelo", 40),
	(e2, "22222222B", "Luis Pérez", pt4, t2, "2024-02-16", NULL, 1, 2, "T-02", "Implementación de API", 80),
	(e3, "33333333C", "Marta López", pt5, t3, "2024-03-01", NULL, 2, 1, "T-10", "Plan de pruebas", 60),
	(e2, "22222222B", "Luis Pérez", pt6, t4, "2024-02-20", NULL, 1, 3, "T-03", "Pruebas unitarias", 30)
}
```

- Empleados que trabajan en proyectos (roles o tareas):

$$
EP \leftarrow \Proj{eid,en,pid}(ER) \Union \Proj{eid,en,pid}(ET)
$$

```mr-table
EP = { eid, en, pid }

EP = {
	(e1, "Ana García", 1),
	(e2, "Luis Pérez", 1),
	(e3, "Marta López", 2),
	(e4, "Ana Rueda", 1)
}
```

- Empleados que trabajan en proyectos (roles y tareas):

$$
EP \leftarrow \Proj{eid,en,pid}(ER) \Inter \Proj{eid,en,pid}(ET)
$$

```mr-table
EP = { eid, en, pid }

EP = {
	(e1, "Ana García", 1),
	(e2, "Luis Pérez", 1),
	(e3, "Marta López", 2)
}
```

- Tareas asignadas a empleados en el proyecto 1:

$$
TareasEmpleadoP1 \leftarrow \Sel{pid=1}(ET)
$$

```mr-table
TareasEmpleadoP1 = { eid, dni, en, ptid, tid, fi, ff, pid, ord, cod, tdesc, est }

TareasEmpleadoP1 = {
	(e2, "22222222B", "Luis Pérez", pt1, t1, "2024-02-01", "2024-02-15", 1, 1, "T-01", "Diseño del modelo", 40),
	(e1, "11111111A", "Ana García", pt2, t1, "2024-02-16", "2024-02-28", 1, 1, "T-01", "Diseño del modelo", 40),
	(e2, "22222222B", "Luis Pérez", pt3, t1, "2024-03-01", "2024-03-15", 1, 1, "T-01", "Diseño del modelo", 40),
	(e2, "22222222B", "Luis Pérez", pt4, t2, "2024-02-16", NULL, 1, 2, "T-02", "Implementación de API", 80),
	(e2, "22222222B", "Luis Pérez", pt6, t4, "2024-02-20", NULL, 1, 3, "T-03", "Pruebas unitarias", 30)
}
```

- Número de tareas por empleado (proyecto 1):

$$
NumTareasEmpleadoP1 \leftarrow \Group{eid,en,\rho_{total}(\operatorname{COUNT}(*))}{eid,en}(TareasEmpleadoP1)
$$

```mr-table
NumTareasEmpleadoP1 = { eid, en, total }

NumTareasEmpleadoP1 = {
	(e1, "Ana García", 1),
	(e2, "Luis Pérez", 4)
}
```

- Listado de roles por proyecto:

$$
ProyectosRoles \leftarrow P \NatJoin R
$$

```mr-table
ProyectosRoles = { pid, pn, pdesc, pres, rid, rn }

ProyectosRoles = {
	(1, "Portal de alquileres", "Plataforma de alquiler de viviendas", 50000.00, r1, "Director"),
	(1, "Portal de alquileres", "Plataforma de alquiler de viviendas", 50000.00, r2, "Analista"),
	(2, "Gestor interno", "Herramientas internas del equipo", 90000.00, r3, "Responsable de pruebas")
}
```

- Listado de tareas por proyecto:

$$
ProyectosTareas \leftarrow P \NatJoin T
$$

```mr-table
ProyectosTareas = { pid, pn, pdesc, pres, tid, ord, cod, tdesc, est }

ProyectosTareas = {
	(1, "Portal de alquileres", "Plataforma de alquiler de viviendas", 50000.00, t1, 1, "T-01", "Diseño del modelo", 40),
	(1, "Portal de alquileres", "Plataforma de alquiler de viviendas", 50000.00, t2, 2, "T-02", "Implementación de API", 80),
	(2, "Gestor interno", "Herramientas internas del equipo", 90000.00, t3, 1, "T-10", "Plan de pruebas", 60),
	(1, "Portal de alquileres", "Plataforma de alquiler de viviendas", 50000.00, t4, 3, "T-03", "Pruebas unitarias", 30),
	(1, "Portal de alquileres", "Plataforma de alquiler de viviendas", 50000.00, t5, 4, "T-04", "Pruebas de integración", 25),
	(2, "Gestor interno", "Herramientas internas del equipo", 90000.00, t6, 2, "T-11", "Validación del plan de pruebas", 30)
}
```

- Número de subtareas por tarea:

$$
NumSubtareas \leftarrow \Group{tid,\rho_{total}(\operatorname{COUNT}(*))}{tid}(T \NatJoin ST)
$$

```mr-table
NumSubtareas = { tid, total }

NumSubtareas = {
	(t2, 1),
	(t4, 1),
	(t3, 1)
}
```

- Empleados con subtareas:

$$
EST \leftarrow ET \NatJoin ST
$$

```mr-table
EST = { eid, dni, en, ptid, tid, fi, ff, pid, ord, cod, tdesc, est, stid, sord }

EST = {
	(e2, "22222222B", "Luis Pérez", pt4, t2, "2024-02-16", NULL, 1, 2, "T-02", "Implementación de API", 80, t4, 1),
	(e2, "22222222B", "Luis Pérez", pt6, t4, "2024-02-20", NULL, 1, 3, "T-03", "Pruebas unitarias", 30, t5, 1),
	(e3, "33333333C", "Marta López", pt5, t3, "2024-03-01", NULL, 2, 1, "T-10", "Plan de pruebas", 60, t6, 1)
}
```

# Modelo Tecnológico

## Script SQL para crear la base de datos

{% include sql-embed.html src='/_code/proyectos/createDB.sql' label='proyectos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/_code/proyectos/populateDB.sql' label='proyectos/populateDB.sql' collapsed=true %}

## Triggers de integridad

{% include sql-embed.html src='/_code/proyectos/triggers.sql' label='proyectos/triggers.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/_code/proyectos/queries.sql' label='proyectos/queries.sql' collapsed=true %}

## Pruebas SQL

{% include sql-embed.html src='/_code/proyectos/tests.sql' label='proyectos/tests.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
