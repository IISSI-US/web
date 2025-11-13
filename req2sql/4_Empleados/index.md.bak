---
title: Empleados
layout: single
sidebar:
  nav: req2sql
toc: true
---

# Empleados

\n## Requisitos\n

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
\n## Modelo Conceptual\n

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
\n## Modelo Relacional\n

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

\n## Modelo Tecnológico (MariaDB)\n

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
\n## Empleados\n

# title: Empleados

\n## Requisitos\n

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
\n## Modelo Conceptual\n

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
\n## Modelo Relacional\n

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

\n## Modelo Tecnológico (MariaDB)\n

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
\n## Empleados\n

# Empleados
{: .fs-9 }

Sistema de recursos humanos con jerarquías organizacionales y auto-referencias
{: .fs-6 .fw-300 }

---

Este ejercicio modela un sistema de recursos humanos que incluye:

- **Empleados** con información personal y profesional
- **Jerarquías organizacionales** (jefe-subordinado)
- **Departamentos** y asignaciones

**Conceptos de BD cubiertos**: Auto-referencias, jerarquías, agregación, cardinalidades complejas, restricciones temporales.

# Objetivos de Aprendizaje

Al completar este ejercicio serás capaz de:

- ✅ Modelar asociaciones recursivas
- ✅ Implementar jerarquías organizacionales en bases de datos
- ✅ Manejar cardinalidades complejas (1:N recursivas)
- ✅ Aplicar restricciones de integridad en jerarquías
- ✅ Diseñar consultas recursivas con álgebra relacional
- ✅ Implementar triggers para mantener consistencia jerárquica

---

Este ejercicio presenta los siguiente desafíos:

- **Auto-referencias**: Un empleado puede ser jefe de otros empleados
- **Consultas recursivas**: Encontrar todos los subordinados de un jefe
- **Restricciones temporales**: Validar fechas de contratación/promoción
- **Integridad referencial**: Evitar ciclos en la jerarquía

---

Las auto-referencias son conceptualmente complejas. Dedica tiempo extra a entender cómo se modelan antes de pasar al esquema relacional.
