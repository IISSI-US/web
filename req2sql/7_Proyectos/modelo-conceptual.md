---
layout: default
published: false
title: Modelo Conceptual
parent: Proyectos
nav_order: 2
---

# Modelo conceptual

## Diagrama de clases

- **Proyecto**: compone un conjunto ordenado de **Tarea** y también “posee” los **Rol** del proyecto, con un ciclo de vida ligado al proyecto.
- **Tarea**: se descompone en subtareas ordenadas mediante auto-composición, formando una estructura jerárquica.
- **Relación Tarea–Empleado**: cada **Tarea** tiene como mucho un **Empleado** responsable (0..1), mientras que un empleado puede llevar varias tareas. **PeriodoTarea** modela el intervalo temporal de esa responsabilidad.
- **Relación Empleado–Rol**: **Empleado** y **Rol** se relacionan en una cardinalidad N:M. 
- **PeriodoCargo** añade las fechas de vigencia del cargo (con `fFin` opcional). 
- El tipo de rol se restringe mediante el enumerado **Cargo** (Director, Analista, ResponsablePruebas, etc.).

![Diagrama de clases]({{ '/assets/images/req2sql/Proyectos/proyectos-dc.png' | relative_url }})

## Diagrama de objetos

- **p1:Proyecto** contiene **Tarea1**–**Tarea4**. **Tarea3** se descompone en **Tarea31** y **Tarea32**, ilustrando la jerarquía.
- **Asignación de responsables**:
    - **juan** → **Tarea1**
    - **maría** → **Tarea2**
    - **carlos** → **Tarea3**
    - **ana** → **Tarea4**  
    Cada par (**Tarea**, **Empleado**) tiene su **PeriodoTarea** con fechas de inicio y fin.
- Los empleados están vinculados a roles (por ejemplo, **juan**–**director**, **maría**–**analista**). 
- Se observa que un empleado puede ejercer varios roles en el tiempo (por ejemplo, **maría** puede asumir también **tester**) y que cada tarea tiene un único responsable vigente, respetando las cardinalidades.

![Diagrama de objetos]({{ '/assets/images/req2sql/Proyectos/proyectos-do.png' | relative_url }})
