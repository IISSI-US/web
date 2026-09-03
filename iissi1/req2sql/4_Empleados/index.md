---
title: Empleados
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Empleados


## Requisitos


# Catálogo de Requisitos

Se pretende realizar un pequeño sistema de información para gestionar los empleados de los departamentos de una empresa. Cada empleado pertenece a un departamento y puede tener un jefe. Cada departamento pertenece a una localidad. Cada empleado tiene un salario y una comisión, además se almacena la fecha de inicio y de finalización de su contrato.

## Requisitos de información (RI)

### RI-01: Departamentos
- **Como:** Profesor de la asignatura
- **Quiero:** Poder almacenar la siguiente información de los departamentos: nombre del departamento(obligatorio) y localidad(opcional)
- **Para:** Que el alumno practique con un sistema de información sencillo

### RI-02: Empleados
- **Como:** Profesor de la asignatura
- **Quiero:** Poder almacenar la siguiente información de los empleados: nombre (obligatorio y único), salario, comisión, fecha de inicio y finalización del contrato (opcionales), jefe (opcional) y departamento al que pertenece (obligatorio)
- **Para:** Que el alumno practique con un sistema de información sencillo

## Reglas de negocio (RN)

### RN-01: Departamentos
- **Como:** Profesor de la asignatura
- **Quiero:** Un departamento no puede tener más de cinco empleados y la combinación nombre y localidad no puede repetirse
- **Para:** Que el alumno practique con restricciones simples

### RN-02: Empleados
- **Como:** Profesor de la asignatura
- **Quiero:** Un empleado no puede ser jefe de si mismo, la comisión es un porcentaje del salario y no puede ser negativa, ni modificarse en más de un 20% de golpe
- **Para:** Que el alumno practique con restricciones simples

## Modelo Conceptual


# Modelo conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Empleados/empleados-dc.png' | relative_url }})

# Modelo relacional

## Intensión

```
Departamentos(departamentoId, nombre, localidad)
	PK(departamentoId)
	AK(nombre, localidad)
Empleados(empleadoId, departamentoId, jefeId, nombre, salario, fechaInicio, fechaFin, comision)
	PK(empleadoId)
	FK(departamentoId) / Departamentos
	FK(jefeId) / Empleados
	AK(nombre)
```

## Extensión

```
Departamentos = {
	(d1, 'Arte', 'Cádiz'),
	(d2, 'Historia', null),
	(d3, 'Informática', 'Sevilla')
}
Empleados = {
	(e1, d1, NULL, 'Pedro', 2300.00, '2017-09-15', NULL, 0.2),
	(e2, d1, NULL, 'Jose', 2500.00, '2018-08-15', NULL, 0.5),
	(e3, d2, NULL, 'Lola', 2300.00, '2018-08-15', NULL, 0.3),
	(e4, d1, e1, 'Luis', 1300.00, '2018-08-15', '2018-11-15', 0),
	(e5, d1, e1, 'Ana', 1300.00, '2018-08-15', '2018-11-15', 0)
}
```

## Álgebra relacional

- Renombrado de relaciones para acortar las expresiones en álgebra relacional:

$$
\Ren{D(dId, n, l)}(Departamentos)
$$

$$
\Ren{E(eId, dId, jId, n, s, FI, Ff, c)}(Empleados)
$$

- Empleados con sueldo < 2000:

$$
\Sel{s<2000}(E)
$$

- Fechas de alta y baja:

$$
\Proj{fI,fF}(E)
$$

- Sueldo entre 2000 y 3000:

$$
\Sel{2000<s<3000}(E)
$$

- Producto cartesiano:

$$
E \times D
$$

- Join Empleados–Departamentos:

$$
E \NatJoin D
$$

- Departamentos con empleados:

$$
\Proj{dId}(E)
$$

- Departamentos sin empleados:

$$
\Proj{dId}(D) \Diff \Proj{dId}(E)
$$

- Estadísticas globales de salario:

$$
\GroupUp{\operatorname{COUNT}(*),\;\operatorname{MIN}(s),\;\operatorname{MAX}(s),\;\operatorname{AVG}(s),\;\operatorname{SUM}(s)}(E)
$$

- Estadísticas de salario por departamento:

$$
\Group{\operatorname{COUNT}(*),\;\operatorname{MIN}(s),\;\operatorname{MAX}(s),\;\operatorname{AVG}(s),\;\operatorname{SUM}(s)}{dId}(E)
$$

- Estadísticas de salarios por departamento con al menos dos empleados:

$$
   Dep2 \leftarrow \Proj{dId} \left( \Sel{\operatorname{COUNT}(*) \geq 2} \left( \Group{\operatorname{COUNT}(*)}{dId}(E) \right) \right)
$$

$$
   \Group{\operatorname{COUNT}(*),\;\operatorname{MIN}(s),\;\operatorname{MAX}(s),\;\operatorname{AVG}(s),\;\operatorname{SUM}(s)}{dId}(E \NatJoin Dep2)
$$


## Modelo Tecnológico (MariaDB)


# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/create_db.sql' label='Empleados/create_db.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/populate_db.sql' label='Empleados/populate_db.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/queries.sql' label='Empleados/queries.sql' collapsed=true %}

## SQL Avanzado

### Procedimientos almacenados

Realice procedimientos para insertar en las tablas Departments y Employees:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/p_insert_department.sql' label='Empleados/p_insert_department.sql' collapsed=true %}

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/p_insert_employee.sql' label='Empleados/p_insert_employee.sql' collapsed=true %}

Realice un procedimiento para igualar las comisiones de todos los empleados al valor de la comisión media:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/p_equate_fees.sql' label='Empleados/p_equate_fees.sql' collapsed=true %}

Implemente un procedimiento que aplique un aumento a la comisión de un empleado en particular:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/p_raise_fee.sql' label='Empleados/p_raise_fee.sql' collapsed=true %}

### Funciones

Implemente una función que devuelva el número de empleados de una localidad concreta:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/f_num_employees.sql' label='Empleados/f_num_employees.sql' collapsed=true %}

Implemente una función que calcule la media de las comisiones de los empleados y use esa función dentro de un procedimiento almacenado para igualar las comisiones de todos los empleados al valor de la comisión media:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/f_avg_fee.sql' label='Empleados/f_avg_fee.sql' collapsed=true %}

### Cursores

Utilice un cursor para recorrer todos los empleados y calcular el valor acumulado de los salarios:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/f_sum_salaries.sql' label='Empleados/f_sum_salaries.sql' collapsed=true %}

### Triggers (disparadores)

Implemente un disparador para evitar que un empleado sea su propio jefe:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/t_self_boss.sql' label='Empleados/t_self_boss.sql' collapsed=true %}

Implemente un disparador que evite que modifique la comisión de un empleado en más de un 20%:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/t_change_fee.sql' label='Empleados/t_change_fee.sql' collapsed=true %}

Implemente un disparador que evite que un departamento tenga más de cinco empleados:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/t_max_employees_department.sql' label='Empleados/t_max_employees_department.sql' collapsed=true %}

Implemente un disparador que en caso de insertar un empleado sin fecha de inicio, le ponga como fecha de inicio la fecha actual:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Empleados/sql/t_default_start_date.sql' label='Empleados/t_default_start_date.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
