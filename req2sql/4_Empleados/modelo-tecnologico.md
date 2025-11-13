---
layout: default
title: Modelo Tecnológico (MariaDB)
parent: Empleados
nav_order: 4
---

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/createDB.sql' | relative_url }}"></div>

## Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/populateDB.sql' | relative_url }}"></div>

## Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/queries.sql' | relative_url }}"></div>

## SQL Avanzado

### Procedimientos almacenados

Realice procedimientos para insertar en las tablas Departments y Employees:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/pInsertDepartment.sql' | relative_url }}"></div>

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/pInsertEmployee.sql' | relative_url }}"></div>

Realice un procedimiento para igualar las comisiones de todos los empleados al valor de la comisión media:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/pEquateFees.sql' | relative_url }}"></div>

Implemente un procedimiento que aplique un aumento a la comisión de un empleado en particular:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/pRaiseFee.sql' | relative_url }}"></div>

### Funciones

Implemente una función que devuelva el número de empleados de una localidad concreta:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/fNumEmployees.sql' | relative_url }}"></div>

Implemente una función que calcule la media de las comisiones de los empleados y use esa función dentro de un procedimiento almacenado para igualar las comisiones de todos los empleados al valor de la comisión media:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/fAvgFee.sql' | relative_url }}"></div>

### Cursores

Utilice un cursor para recorrer todos los empleados y calcular el valor acumulado de los salarios:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/fSumSalaries.sql' | relative_url }}"></div>

### Triggers (disparadores)

Implemente un disparador para evitar que un empleado sea su propio jefe:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/tSelfBoss.sql' | relative_url }}"></div>

Implemente un disparador que evite que modifique la comisión de un empleado en más de un 20%:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/tChangeFee.sql' | relative_url }}"></div>

Implemente un disparador que evite que un departamento tenga más de cinco empleados:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/tMaxEmployeesDepartment.sql' | relative_url }}"></div>

Implemente un disparador que en caso de insertar un empleado sin fecha de inicio, le ponga como fecha de inicio la fecha actual:

<div class="sql-file" data-src="{{ '/silence-db/sql/Empleados/tDefaultStartDate.sql' | relative_url }}"></div>
