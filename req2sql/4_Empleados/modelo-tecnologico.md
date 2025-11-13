---
layout: default
published: false
title: Modelo Tecnológico (MariaDB)
parent: Empleados
nav_order: 4
---

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Empleados/createDB.sql' label='Empleados/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/sql/Empleados/populateDB.sql' label='Empleados/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/sql/Empleados/queries.sql' label='Empleados/queries.sql' collapsed=true %}

## SQL Avanzado

### Procedimientos almacenados

Realice procedimientos para insertar en las tablas Departments y Employees:

{% include sql-embed.html src='/assets/sql/Empleados/pInsertDepartment.sql' label='Empleados/pInsertDepartment.sql' collapsed=true %}

{% include sql-embed.html src='/assets/sql/Empleados/pInsertEmployee.sql' label='Empleados/pInsertEmployee.sql' collapsed=true %}

Realice un procedimiento para igualar las comisiones de todos los empleados al valor de la comisión media:

{% include sql-embed.html src='/assets/sql/Empleados/pEquateFees.sql' label='Empleados/pEquateFees.sql' collapsed=true %}

Implemente un procedimiento que aplique un aumento a la comisión de un empleado en particular:

{% include sql-embed.html src='/assets/sql/Empleados/pRaiseFee.sql' label='Empleados/pRaiseFee.sql' collapsed=true %}

### Funciones

Implemente una función que devuelva el número de empleados de una localidad concreta:

{% include sql-embed.html src='/assets/sql/Empleados/fNumEmployees.sql' label='Empleados/fNumEmployees.sql' collapsed=true %}

Implemente una función que calcule la media de las comisiones de los empleados y use esa función dentro de un procedimiento almacenado para igualar las comisiones de todos los empleados al valor de la comisión media:

{% include sql-embed.html src='/assets/sql/Empleados/fAvgFee.sql' label='Empleados/fAvgFee.sql' collapsed=true %}

### Cursores

Utilice un cursor para recorrer todos los empleados y calcular el valor acumulado de los salarios:

{% include sql-embed.html src='/assets/sql/Empleados/fSumSalaries.sql' label='Empleados/fSumSalaries.sql' collapsed=true %}

### Triggers (disparadores)

Implemente un disparador para evitar que un empleado sea su propio jefe:

{% include sql-embed.html src='/assets/sql/Empleados/tSelfBoss.sql' label='Empleados/tSelfBoss.sql' collapsed=true %}

Implemente un disparador que evite que modifique la comisión de un empleado en más de un 20%:

{% include sql-embed.html src='/assets/sql/Empleados/tChangeFee.sql' label='Empleados/tChangeFee.sql' collapsed=true %}

Implemente un disparador que evite que un departamento tenga más de cinco empleados:

{% include sql-embed.html src='/assets/sql/Empleados/tMaxEmployeesDepartment.sql' label='Empleados/tMaxEmployeesDepartment.sql' collapsed=true %}

Implemente un disparador que en caso de insertar un empleado sin fecha de inicio, le ponga como fecha de inicio la fecha actual:

{% include sql-embed.html src='/assets/sql/Empleados/tDefaultStartDate.sql' label='Empleados/tDefaultStartDate.sql' collapsed=true %}
