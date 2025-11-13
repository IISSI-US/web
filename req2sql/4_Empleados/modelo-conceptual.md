---
layout: default
title: Modelo Conceptual
parent: Empleados
nav_order: 2
---

# Modelo conceptual

## Diagrama de clases

El modelo representa una estructura organizacional con empleados distribuidos en departamentos.

- **Entidades principales**: Empleado, Departamento.
- **Asociaciones**: Un Empleado pertenece a 1 Departamento; un Departamento tiene 1..* Empleados.
- **Roles**: Los empleados puedes ser Jefes o Subordinados, de forma que un Subordinado tiene 0..1 Jefes y un Jefe tiene 0..* Subordinados
- **Restricciones**: un empleado no puede ser su propio jefe, la comisión es un porcentaje, los nombres de los empleados son únicos, las fechas de inicio y fin de contrato deben ser coherentes, la tupla (nombre, localidad) de un departamento no puede repetirse, y los departamentos no pueden tener más de 5 empleados.

![Diagrama de clases]({{ '/assets/images/req2sql/Empleados/empleados-dc.png' | relative_url }})

## Diagrama de objetos

Las instancias muestran la diversidad de empleados y la organización departamental de la universidad.

- **Departamentos**: Diferentes departamentos múltiples empleados asignados (d1, d2, d3).
- **Empleados**: Cinco empleados, Juan es Jefe de Luis y Ana, José y Lola no tiene jeje, y el departamento d3 no tiene ningún empleado.

![Diagrama de objetos]({{ '/assets/images/req2sql/Empleados/empleados-do.png' | relative_url }})