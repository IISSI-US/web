---
layout: single
title: "Asociación reflexiva 1:N"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---

## Modelo Conceptual

![Diagrama de clases]({{ '/assets/images/iissi1/mc2mr/asociacion-reflexiva-1n-clases.png' | relative_url }})

## Modelo Relacional

```mr-table
-- Intensión
Empleados = { empleadoId, jefeId, nombre, edad, genero, salario }
    PK(empleadoId)
    FK(jefeId)/Empleados

-- Extensión
Empleados = {
    (e1, null, 'Ana Torres', 52, 'FEMENINO', 95000.0),
    (e2, e1, 'Bruno Díaz', 42, 'MASCULINO', 72000.0),
    (e3, e1, 'Carla Ruiz', 39, 'FEMENINO', 70000.0),
    (e4, e2, 'Diego Martín', 29, 'MASCULINO', 52000.0),
    (e5, e2, 'Elena Gómez', 33, 'NO_BINARIO', 51000.0),
    (e6, e3, 'Fabio Ortiz', 24, 'MASCULINO', 44000.0),
    (e7, e3, 'Gabriela Soto', 23, 'FEMENINO', 46000.0),
    (e8, e4, 'Héctor Vega', 22, 'MASCULINO', 52000.0),
    (e9, null, 'Isabel Núñez', 45, 'FEMENINO', 58000.0),
    (e10, null, 'Javier Silva', 36, 'MASCULINO', 54000.0)
}
```

## Álgebra relacional

### Enunciados

1. Obtener los empleados que dependen directamente de Ana Torres.
2. Mostrar cada empleado junto con el nombre de su jefe directo.
3. Obtener los empleados cuyo jefe directo es una mujer.
4. Obtener los empleados que tienen subordinados directos.
5. Obtener los empleados con salario superior a 60 000.
6. Obtener los empleados cuyo jefe tiene más de 40 años.
7. Obtener los empleados cuyo género coincide con el de su jefe directo.
8. Obtener los empleados que cobran menos que su jefe directo.
9. Obtener los jefes que supervisan a todos los empleados con salario inferior a 47 000.
10. Obtener el número de subordinados directos de cada jefe.
11. Obtener el salario medio de los empleados por género.

### Soluciones

**Renombramiento de relación:**

$$E \leftarrow \Ren{E(eid,jid,nom,edad,gen,sal)}(Empleados)$$

**Relaciones auxiliares:**

$$Jefes \leftarrow \Ren{Jefes(jefeId,nomJefe,edadJefe,genJefe,salJefe)}\left(\Proj{eid,nom,edad,gen,sal}(E)\right)$$

$$Subordinados \leftarrow \Ren{Subordinados(jefeId,eid,nom,edad,gen,sal)}\left(\Proj{jid,eid,nom,edad,gen,sal}(E)\right)$$

$$EmplConJefe \leftarrow Jefes \NatJoin Subordinados$$

**1. Empleados que dependen directamente de Ana Torres**

$$\Sel{jid = e1}(E)$$

```mr-table
Resultado = { eid, jid, nom, edad, gen, sal }

Resultado = {
    (e2, e1, 'Bruno Díaz', 42, 'MASCULINO', 72000.0),
    (e3, e1, 'Carla Ruiz', 39, 'FEMENINO', 70000.0)
}
```


**2. Cada empleado junto con el nombre de su jefe directo**

$$\Proj{nomJefe,nom}(EmplConJefe)$$

```mr-table
Resultado = { nomJefe, nom }

Resultado = {
    ('Ana Torres', 'Bruno Díaz'),
    ('Ana Torres', 'Carla Ruiz'),
    ('Bruno Díaz', 'Diego Martín'),
    ('Bruno Díaz', 'Elena Gómez'),
    ('Carla Ruiz', 'Fabio Ortiz'),
    ('Carla Ruiz', 'Gabriela Soto'),
    ('Diego Martín', 'Héctor Vega')
}
```

**3. Empleados cuyo jefe directo es una mujer**

$$\Proj{nomJefe,nom}\left(\Sel{genJefe = 'FEMENINO'}(EmplConJefe)\right)$$

```mr-table
Resultado = { nomJefe, nom }

Resultado = {
    ('Ana Torres', 'Bruno Díaz'),
    ('Ana Torres', 'Carla Ruiz'),
    ('Carla Ruiz', 'Fabio Ortiz'),
    ('Carla Ruiz', 'Gabriela Soto')
}
```

**4. Empleados que tienen subordinados directos**

$$JefesConSubordinados \leftarrow \Proj{jefeId,nomJefe,edadJefe,genJefe,salJefe}(EmplConJefe)$$

```mr-table
Resultado = { jefeId, nomJefe, edadJefe, genJefe, salJefe }

Resultado = {
    (e1, 'Ana Torres', 52, 'FEMENINO', 95000.0),
    (e2, 'Bruno Díaz', 42, 'MASCULINO', 72000.0),
    (e3, 'Carla Ruiz', 39, 'FEMENINO', 70000.0),
    (e4, 'Diego Martín', 29, 'MASCULINO', 52000.0)
}
```

**5. Empleados con salario superior a 60 000**

$$\Sel{sal > 60000}(E)$$

```mr-table
Resultado = { eid, jid, nom, edad, gen, sal }

Resultado = {
    (e1, null, 'Ana Torres', 52, 'FEMENINO', 95000.0),
    (e2, e1, 'Bruno Díaz', 42, 'MASCULINO', 72000.0),
    (e3, e1, 'Carla Ruiz', 39, 'FEMENINO', 70000.0)
}
```

**6. Empleados cuyo jefe tiene más de 40 años**

$$\Sel{edadJefe > 40}(EmplConJefe)$$

```mr-table
Resultado = { jefeId, nomJefe, edadJefe, genJefe, salJefe, eid, nom, edad, gen, sal }

Resultado = {
    (e1, 'Ana Torres', 52, 'FEMENINO', 95000.0, e2, 'Bruno Díaz', 42, 'MASCULINO', 72000.0),
    (e1, 'Ana Torres', 52, 'FEMENINO', 95000.0, e3, 'Carla Ruiz', 39, 'FEMENINO', 70000.0),
    (e2, 'Bruno Díaz', 42, 'MASCULINO', 72000.0, e4, 'Diego Martín', 29, 'MASCULINO', 52000.0),
    (e2, 'Bruno Díaz', 42, 'MASCULINO', 72000.0, e5, 'Elena Gómez', 33, 'NO_BINARIO', 51000.0)
}
```

**7. Empleados cuyo género coincide con el de su jefe**

$$\Proj{nom,nomJefe,gen}\left(\Sel{gen = genJefe}(EmplConJefe)\right)$$

```mr-table
Resultado = { nom, nomJefe, gen }

Resultado = {
    ('Carla Ruiz', 'Ana Torres', 'FEMENINO'),
    ('Diego Martín', 'Bruno Díaz', 'MASCULINO'),
    ('Gabriela Soto', 'Carla Ruiz', 'FEMENINO'),
    ('Héctor Vega', 'Diego Martín', 'MASCULINO')
}
```

**8. Empleados que cobran menos que su jefe**

$$\Proj{nom,sal,nomJefe,salJefe}\left(\Sel{sal < salJefe}(EmplConJefe)\right)$$

```mr-table
Resultado = { nom, sal, nomJefe, salJefe }

Resultado = {
    ('Bruno Díaz', 72000.0, 'Ana Torres', 95000.0),
    ('Carla Ruiz', 70000.0, 'Ana Torres', 95000.0),
    ('Diego Martín', 52000.0, 'Bruno Díaz', 72000.0),
    ('Elena Gómez', 51000.0, 'Bruno Díaz', 72000.0),
    ('Fabio Ortiz', 44000.0, 'Carla Ruiz', 70000.0),
    ('Gabriela Soto', 46000.0, 'Carla Ruiz', 70000.0)
}
```

**9. Jefes que supervisan a todos los empleados con salario inferior a 47 000**

$$EmpleadosBaratos \leftarrow \Proj{eid}\left(\Sel{sal < 47000}(E)\right)$$

$$JefesDeTodos \leftarrow \Proj{jefeId,eid}(EmplConJefe) \Div EmpleadosBaratos$$

$$\Proj{eid,nom,edad,gen,sal}\left(JefesDeTodos \JoinR{jefeId = eid} E\right)$$

```mr-table
Resultado = { eid, nom, edad, gen, sal }

Resultado = {
    (e3, 'Carla Ruiz', 39, 'FEMENINO', 70000.0)
}
```

**10. Número de subordinados directos de cada jefe**

$$SubordinadosPorJefe \leftarrow \Group{jefeId,\rho_{numSubordinados}(COUNT(eid))}{jefeId}(EmplConJefe)$$

$$\Proj{jefeId,nom,numSubordinados}\left(SubordinadosPorJefe \JoinR{jefeId = eid} E\right)$$

```mr-table
Resultado = { jefeId, nom, numSubordinados }

Resultado = {
    (e1, 'Ana Torres', 2),
    (e2, 'Bruno Díaz', 2),
    (e3, 'Carla Ruiz', 2),
    (e4, 'Diego Martín', 1)
}
```

**11. Salario medio de los empleados por género**

$$\Group{gen,\rho_{salarioMedio}(AVG(sal))}{gen}(E)$$

```mr-table
Resultado = { gen, salarioMedio }

Resultado = {
    ('FEMENINO', 67250.0),
    ('MASCULINO', 54800.0),
    ('NO_BINARIO', 51000.0)
}
```

### [Relax](https://dbis-uibk.github.io/relax/calc/gist/16d41d7b093a206c95c41f0717c5ac30)

```
-- Empleados que dependen directamente de Ana Torres
-- σ jefeId = 'e1' (Empleados)


-- Empleados y sus jefes directos
-- Empleados ⨝ Empleados.empleadoId = Jefes.jefeId ρ Jefes (Empleados)

-- Empleados cuyo jefe directo es una mujer
-- Empleados ⨝ Empleados.empleadoId = Jefes.jefeId (σ genero = 'FEMENINO' (ρ Jefes (Empleados)))

-- Empleados que tienen subordinados directos
-- π jefeId (Empleados) ⨝ jefeId = empleadoId Empleados

-- Empleados con salario superior a 60000
-- σ salario > 60000 (Empleados)

-- Empleados cuyo jefe tiene más de 40 años
-- Empleados ⨝ Empleados.empleadoId = Jefes.jefeId (σ edad > 40 (ρ Jefes (Empleados)))

-- Empleados cuyo género coincide con el de su jefe directo
-- Empleados ⨝ Empleados.genero = Jefes.genero and Empleados.empleadoId = Jefes.jefeId ρ Jefes (Empleados)

-- Empleados que cobran menos que su jefe
-- Empleados ⨝ Empleados.salario < Jefes.salario and Empleados.empleadoId = Jefes.jefeId ρ Jefes (Empleados)

-- Jefes que supervisan a todos los empleados con salario inferior a 47000
-- EmpleadosBaratos = π empleadoId (σ salario < 47000 (Empleados))
-- JefesDeTodos = π jefeId, empleadoId (Empleados) ÷ EmpleadosBaratos
-- JefesDeTodos ⨝ jefeId = empleadoId Empleados

-- EmplConJefe = Jefes ⨝ Subordinados
-- Jefes = ρ jefeId←empleadoId, nombreJefe←nombreEmpleado, edadJefe←edad, generoJefe←genero, salarioJefe←salario (π empleadoId, nombreEmpleado, edad, genero, salario (Empleados))
-- Subordinados = π jefeId, empleadoId, nombreEmpleado, edad, genero, salario (Empleados)

-- Número de subordinados directos por jefe
-- SubordinadosPorJefe = γ jefeId; count(empleadoId) → numSubordinados (EmplConJefe)
-- π jefeId, nombreEmpleado, numSubordinados (SubordinadosPorJefe ⨝ jefeId = empleadoId Empleados)

-- Salario medio de los empleados por género
-- γ genero; avg(salario) → salarioMedio (Empleados)
```

> [Versión PDF disponible](./index.pdf)
