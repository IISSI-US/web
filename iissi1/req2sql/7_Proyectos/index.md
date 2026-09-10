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

# Proyectos


## Requisitos


# Catálogo de Requisitos

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


# Modelo conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Proyectos/proyectos-dc.png' | relative_url }})

# Modelo relacional

## Intensión

```mr-table
Proyectos = { proyectoId, nombre, presupuesto }
	PK(proyectoId)
Roles = { rolId, proyectoId, nombre }
	PK(rolId)
	FK(proyectoId) / Proyectos
Tareas = { tareaId, proyectoId, orden, id, descripcion, estimacion }
	PK(tareaId)
	FK(proyectoId) / Proyectos
	AK(proyectoId, orden)
Subtareas = { subtareaId, tareaId, orden }
	PK(subtareaId, tareaId)
	FK(tareaId) / Tareas
	AK(subtareaId, orden)
Empleados = { empleadoId, dni, nombre }
	PK(empleadoId)
	AK(dni)
PeriodosCargos = { periodoCargoId, empleadoId, rolId, fInicio, fFin }
	PK(periodoCargoId)
	FK(empleadoId) / Empleados
	FK(rolId) / Roles
	AK(empleadoId, rolId)
PeriodosTareas = { periodoTareaId, empleadoId, tareaId, fInicio, fFin }
	PK(periodoTareaId)
	FK(empleadoId) / Empleados
	FK(tareaId) / Tareas
	AK(empleadoId, tareaId)

Proyectos = {
	(1, "Portal de alquileres", 50000.00),
	(2, "Gestor interno", 90000.00)
}

Roles = {
	(r1, 1, "Director"),
	(r2, 1, "Analista"),
	(r3, 2, "Responsable de pruebas")
}

Tareas = {
	(t1, 1, 1, "T-01", "Diseño del modelo", 40),
	(t2, 1, 2, "T-02", "Implementación de API", 80),
	(t3, 2, 1, "T-10", "Plan de pruebas", 60)
}

Subtareas = {
	(st1, t2, 1),
	(st2, t2, 2),
	(st3, t3, 1)
}

Empleados = {
	(e1, "11111111A", "Ana García"),
	(e2, "22222222B", "Luis Pérez"),
	(e3, "33333333C", "Marta López")
}

PeriodosCargos = {
	(pc1, e1, r1, "2024-01-01", NULL),
	(pc2, e2, r2, "2024-01-15", NULL),
	(pc3, e3, r3, "2024-02-01", NULL)
}

PeriodosTareas = {
	(pt1, e2, t1, "2024-02-01", "2024-02-15"),
	(pt2, e3, t2, "2024-02-16", NULL),
	(pt3, e1, t3, "2024-03-01", NULL)
}
```

## Álgebra relacional

- Renombrado:

$$
P \leftarrow \Ren{P(pid,pn,pres)}(Proyectos)
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
	(e1, "11111111A", "Ana García", pc1, r1, "2024-01-01", NULL, 1, "Director"),
	(e2, "22222222B", "Luis Pérez", pc2, r2, "2024-01-15", NULL, 1, "Analista"),
	(e3, "33333333C", "Marta López", pc3, r3, "2024-02-01", NULL, 2, "Responsable de pruebas")
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
	(e3, "33333333C", "Marta López", pt2, t2, "2024-02-16", NULL, 1, 2, "T-02", "Implementación de API", 80),
	(e1, "11111111A", "Ana García", pt3, t3, "2024-03-01", NULL, 2, 1, "T-10", "Plan de pruebas", 60)
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
	(e1, "Ana García", 2),
	(e2, "Luis Pérez", 1),
	(e3, "Marta López", 1),
	(e3, "Marta López", 2)
}
```

- Empleados que trabajan en proyectos (roles y tareas):

$$
EP \leftarrow \Proj{eid,en,pid}(ER) \Inter \Proj{eid,en,pid}(ET)
$$

```mr-table
EP = { eid, en, pid }

EP = {
	(e2, "Luis Pérez", 1)
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
	(e3, "33333333C", "Marta López", pt2, t2, "2024-02-16", NULL, 1, 2, "T-02", "Implementación de API", 80)
}
```

- Número de tareas por empleado (proyecto 1):

$$
NumTareasEmpleadoP1 \leftarrow \Group{eid,en,\rho_{total}(\operatorname{COUNT}(*))}{eid,en}(TareasEmpleadoP1)
$$

```mr-table
NumTareasEmpleadoP1 = { eid, en, total }

NumTareasEmpleadoP1 = {
	(e2, "Luis Pérez", 1),
	(e3, "Marta López", 1)
}
```

- Listado de roles por proyecto:

$$
ProyectosRoles \leftarrow P \NatJoin R
$$

```mr-table
ProyectosRoles = { pid, pn, pres, rid, rn }

ProyectosRoles = {
	(1, "Portal de alquileres", 50000.00, r1, "Director"),
	(1, "Portal de alquileres", 50000.00, r2, "Analista"),
	(2, "Gestor interno", 90000.00, r3, "Responsable de pruebas")
}
```

- Listado de tareas por proyecto:

$$
ProyectosTareas \leftarrow P \NatJoin T
$$

```mr-table
ProyectosTareas = { pid, pn, pres, tid, ord, cod, tdesc, est }

ProyectosTareas = {
	(1, "Portal de alquileres", 50000.00, t1, 1, "T-01", "Diseño del modelo", 40),
	(1, "Portal de alquileres", 50000.00, t2, 2, "T-02", "Implementación de API", 80),
	(2, "Gestor interno", 90000.00, t3, 1, "T-10", "Plan de pruebas", 60)
}
```

- Número de subtareas por tarea:

$$
NumSubtareas \leftarrow \Group{tid,\rho_{total}(\operatorname{COUNT}(*))}{tid}(T \NatJoin ST)
$$

```mr-table
NumSubtareas = { tid, total }

NumSubtareas = {
	(t2, 2),
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
	(e3, "33333333C", "Marta López", pt2, t2, "2024-02-16", NULL, 1, 2, "T-02", "Implementación de API", 80, st1, 1),
	(e3, "33333333C", "Marta López", pt2, t2, "2024-02-16", NULL, 1, 2, "T-02", "Implementación de API", 80, st2, 2),
	(e1, "11111111A", "Ana García", pt3, t3, "2024-03-01", NULL, 2, 1, "T-10", "Plan de pruebas", 60, st3, 1)
}
```

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Proyectos/sql/createDB.sql' label='Proyectos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Proyectos/sql/populateDB.sql' label='Proyectos/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Proyectos/sql/queries.sql' label='Proyectos/queries.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
