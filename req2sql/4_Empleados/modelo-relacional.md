---
layout: default
title: Modelo Relacional
parent: Empleados
nav_order: 3
---

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

