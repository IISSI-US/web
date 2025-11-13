---
layout: default
title: Modelo Relacional
parent: Proyectos
nav_order: 3
---

# Modelo relacional

## Intensión

```
Proyectos(proyectoId, nombre, presupuesto)
	PK(proyectoId)
Roles(rolId, proyectoId, nombre)
	PK(rolId)
	FK(proyectoId) / Proyectos
Tareas(tareaId, proyectoId, orden, id, descripcion, estimacion)
	PK(tareaId)
	FK(proyectoId) / Proyectos
	AK(proyectoId, orden)
Subtareas(subtareaId, tareaId, orden)
	PK(subtareaId, tareaId)
	FK(tareaId) / Tareas
	AK(subtareaId, orden)
Empleados(empleadoId, dni, nombre)
	PK(empleadoId)
	AK(dni)
PeriodosCargos(periodoCargoId, empleadoId, rolId, fInicio, fFin)
	PK(periodoCargoId)
	FK(empleadoId) / Empleados
	FK(rolId) / Roles
	AK(empleadoId, rolId)
PeriodosTareas(periodoTareaId, empleadoId, tareaId, fInicio, fFin)
	PK(periodoTareaId)
	FK(empleadoId) / Empleados
	FK(tareaId) / Tareas
	AK(empleadoId, tareaId)
```

## Álgebra relacional

- Empleados con roles en proyectos:

$$
ER \leftarrow Empleados \NatJoin PeriodosCargos \NatJoin Roles
$$

- Empleados con tareas en proyectos:

$$
ET \leftarrow Empleados \NatJoin PeriodosTareas \NatJoin Tareas
$$

- Empleados que trabajan en proyectos (roles o tareas):

$$
EP \leftarrow ER \Union ET
$$

- Empleados que trabajan en proyectos (roles y tareas):

$$
EP \leftarrow ER \Inter ET
$$

- Tareas asignadas a empleados en el proyecto 1:

$$
TareasEmpleadoP1 \leftarrow \Sel{proyectoId=1}(ET)
$$

- Número de tareas por empleado (proyecto 1):

$$
NumTareasEmpleadoP1 \leftarrow \Group{\operatorname{COUNT}(*)}{empleadoId}(TareasEmpleadoP1)
$$

- Listado de roles por proyecto:

$$
ProyectosRoles \leftarrow \Group{\ }{empleadoId}(ER)
$$

- Listado de tareas por proyecto:

$$
ProyectosTareas \leftarrow \Group{\ }{empleadoId}(ET)
$$

- Número de subtareas por tarea:

$$
Subtareas \leftarrow \Group{\operatorname{COUNT}(*)}{tareaId}(Tareas \NatJoin Subtareas)
$$

- Empleados con subtareas:

$$
EST \leftarrow ET \NatJoin Subtareas
$$
