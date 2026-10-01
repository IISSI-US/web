---
layout: single
title: "Asociaciones 1:N"
pdf_version: true
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
---
## Modelo Conceptual

![Diagrama de Clases]({{ '/assets/images/iissi1/mc2mr/asociaciones-1n-clases.png' | relative_url }})

## Modelo Relacional.

La transformación UML → Relacional genera tres relaciones con claves primarias y foráneas:

```mr-table
-- Intensión
Universidades = { universidadId, nombre, dirección, fundación }
    PK(universidadId)

Centros = { centroId, universidadId, nombre, código, presupuesto }
    PK(centroId)
    FK(universidadId)/Universidades
    
Estudiantes = { estudianteId, centroId, matrícula, nombre, edad, promedio }
    PK(estudianteId)
    AK(matrícula)
    FK(centroId)/Centros

-- Extensión

Universidades = {  
  (u1, 'Universidad de Sevilla', 'Calle San Fernando, 4, Sevilla', 1505-07-12),  
  (u2, 'Universidad de Granada', 'Avenida del Hospicio, s/n, Granada', 1531-07-14)  
}

Centros = {  
  (c1, u1, 'Escuela Técnica Superior de Ingeniería', 'ETSI', 8200000.50),
  (c2, u1, 'Facultad de Derecho', 'FD', 4300000.25),
  (c3, u1, 'Facultad de Medicina', 'FM', 7600000.75),
  (c4, u2, 'Facultad de Ciencias Económicas y Empresariales', 'FCEE', 4800000.00),
  (c5, u2, 'Escuela Técnica Superior de Ingenierías Informática y de Telecomunicación', 'ETSIIT', 6900000.20)
}

Estudiantes = {  
  (e1, c1, '2023001', 'Carmen', 20, 8.7),
  (e2, c1, '2023002', 'Pablo', 21, 8.1),
  (e3, c2, '2023003', 'Lucía', 41, 9.2),
  (e4, c2, '2023004', 'Álvaro', 41, 7.8),
  (e5, c3, '2023005', 'Elena', 20, 9.5),
  (e6, c4, '2023006', 'Javier', 23, 8.9),
  (e7, c5, '2023007', 'Sofía', 21, 9.1),
  (e8, c5, '2023008', 'Daniel', 19, 8.3)
}
```

## Álgebra Relacional

Para simplificar la notación hacemos los siguientes renombrados:

$$ U \leftarrow \Ren{U(uid,un,d,f)}(Universidades)$$

$$ C \leftarrow \Ren{C(cid,uid,cn,c,pres)}(Centros)$$

$$ E \leftarrow \Ren{E(eid,cid,m,en,e,p)}(Estudiantes)$$

### Enunciados de consultas:

1. **Estudiantes con edad mayor a 20 años**
2. **Centros con presupuesto superior a 5 millones**
3. **Nombres y edades de estudiantes**
4. **Universidades fundadas antes del año 1550**
5. **Estudiantes con promedio mayor o igual a 9.0**
6. **Centros de la Universidad de Sevilla (uid = u1)**
7. **Estudiantes con información de sus centros**
8. **Número de estudiantes por centro**
9. **Promedio de calificaciones por centro**
10. **Mejor promedio por universidad**
11. **Centros que tienen a todos los estudiantes con edad mayor de 40 años**

---

### Soluciones:

**1. Estudiantes con edad mayor a 20 años**

$$\Sel{e > 20}(E)$$

```mr-table
Resultado = { eid, cid, m, en, e, p }

Resultado = {
  (e2, c1, '2023002', 'Pablo', 21, 8.1),
  (e3, c2, '2023003', 'Lucía', 41, 9.2),
  (e4, c2, '2023004', 'Álvaro', 41, 7.8),
  (e6, c4, '2023006', 'Javier', 23, 8.9),
  (e7, c5, '2023007', 'Sofía', 21, 9.1)
}
```

**2. Centros con presupuesto superior a 5 millones**

$$\Sel{pres > 5000000}(C)$$

```mr-table
Resultado = { cid, uid, cn, c, pres }

Resultado = {
  (c1, u1, 'Escuela Técnica Superior de Ingeniería', 'ETSI', 8200000.50),
  (c3, u1, 'Facultad de Medicina', 'FM', 7600000.75),
  (c5, u2, 'Escuela Técnica Superior de Ingenierías Informática y de Telecomunicación', 'ETSIIT', 6900000.20)
}
```

**3. Nombres y edades de estudiantes**

$$\Proj{en, e}(E)$$

```mr-table
Resultado = { en, e }

Resultado = {
  ('Carmen', 20), ('Pablo', 21), ('Lucía', 41), ('Álvaro', 41),
  ('Elena', 20), ('Javier', 23), ('Sofía', 21), ('Daniel', 19)
}
```

**4. Universidades fundadas antes del año 1550**

$$\Sel{f < 1550-01-01}(U)$$

```mr-table
Resultado = { uid, un, d, f }

Resultado = {
  (u1, 'Universidad de Sevilla', 'Calle San Fernando, 4, Sevilla', 1505-07-12),
  (u2, 'Universidad de Granada', 'Avenida del Hospicio, s/n, Granada', 1531-07-14)
}
```

**5. Estudiantes con promedio mayor o igual a 9.0**

$$\Sel{p \geq 9.0}(E)$$

```mr-table
Resultado = { eid, cid, m, en, e, p }

Resultado = {
  (e3, c2, '2023003', 'Lucía', 41, 9.2),
  (e5, c3, '2023005', 'Elena', 20, 9.5),
  (e7, c5, '2023007', 'Sofía', 21, 9.1)
}
```

**6. Centros de la Universidad de Sevilla (uid = u1)**

$$\Sel{uid = u1}(C)$$

```mr-table
Resultado = { cid, uid, cn, c, pres }

Resultado = {
  (c1, u1, 'Escuela Técnica Superior de Ingeniería', 'ETSI', 8200000.50),
  (c2, u1, 'Facultad de Derecho', 'FD', 4300000.25),
  (c3, u1, 'Facultad de Medicina', 'FM', 7600000.75)
}
```

**7. Estudiantes con información de sus centros**

$$E \NatJoin C$$

```mr-table
Resultado = { eid, cid, m, en, e, p, uid, cn, c, pres }

Resultado = {
  (e1, c1, '2023001', 'Carmen', 20, 8.7, u1, 'Escuela Técnica Superior de Ingeniería', 'ETSI', 8200000.50),
  (e2, c1, '2023002', 'Pablo', 21, 8.1, u1, 'Escuela Técnica Superior de Ingeniería', 'ETSI', 8200000.50),
  (e3, c2, '2023003', 'Lucía', 41, 9.2, u1, 'Facultad de Derecho', 'FD', 4300000.25),
  (e4, c2, '2023004', 'Álvaro', 41, 7.8, u1, 'Facultad de Derecho', 'FD', 4300000.25),
  (e5, c3, '2023005', 'Elena', 20, 9.5, u1, 'Facultad de Medicina', 'FM', 7600000.75),
  (e6, c4, '2023006', 'Javier', 23, 8.9, u2, 'Facultad de Ciencias Económicas y Empresariales', 'FCEE', 4800000.00),
  (e7, c5, '2023007', 'Sofía', 21, 9.1, u2, 'Escuela Técnica Superior de Ingenierías Informática y de Telecomunicación', 'ETSIIT', 6900000.20),
  (e8, c5, '2023008', 'Daniel', 19, 8.3, u2, 'Escuela Técnica Superior de Ingenierías Informática y de Telecomunicación', 'ETSIIT', 6900000.20)
}
```

**8. Número de estudiantes por centro**

$$\Group{cid,\rho_{total}(COUNT(eid))}{cid}(E)$$

```mr-table
Resultado = { cid, total }

Resultado = {
  (c1, 2), (c2, 2), (c3, 1), (c4, 1), (c5, 2)
}
```

**9. Promedio de calificaciones por centro**

$$\Group{cid,\rho_{media}(AVG(p))}{cid}(E)$$

```mr-table
Resultado = { cid, media }

Resultado = {
  (c1, 8.4), (c2, 8.5), (c3, 9.5), (c4, 8.9), (c5, 8.7)
}
```

**10. Mejor promedio por universidad**

$$\Group{uid,\rho_{mejor}(MAX(p))}{uid}(E \NatJoin C \NatJoin U)$$

```mr-table
Resultado = { uid, mejor }

Resultado = {
  (u1, 9.5), (u2, 9.1)
}
```

**11. Centros que tienen a todos los estudiantes con edad mayor de 40 años**

$$EstudiantesMayores40 \leftarrow \Proj{eid}\left(\Sel{e > 40}(E)\right)$$

$$CentrosConTodos \leftarrow (\Proj{cid,eid}(E) \Div EstudiantesMayores40) \NatJoin C$$

```mr-table
Resultado = { cid, uid, cn, c, pres }

Resultado = {
  (c2, u1, 'Facultad de Derecho', 'FD', 4300000.25)
}
```

### [Relax](https://dbis-uibk.github.io/relax/calc/gist/ed676104ddf97da32072088f817dd626)

```
-- Estudiantes con edad mayor a 20 años
-- σ edad>20 (Estudiantes)Centros con presupuesto superior a 5 millones

-- Nombres y edades de estudiantes
-- π nombreEstudiante,edad (Estudiantes)

-- Universidades fundadas antes del año 1550

-- Estudiantes con promedio mayor o igual a 9.0
-- σ promedio ≥ 9.0 (Estudiantes)

-- Centros de la Universidad de Sevilla (uid = u1)
-- σ universidadId='u1' (Centros)

-- Estudiantes con información de sus centros
-- Estudiantes ⨝ Centros

-- Número de estudiantes por centro
-- γ centroId; count(estudianteId) → total (Estudiantes)

-- Promedio de calificaciones por centro
-- γ centroId; avg(promedio) → media (Estudiantes)

-- Mejor promedio por universidad
-- ECU = Estudiantes ⨝ Centros ⨝ Universidades
-- γ universidadId; max(promedio) → mejor (ECU)

-- Centros que tienen a todos los estudiantes con edad mayor de 40 años
-- EstudiantesMayores40 = π estudianteId (σ edad > 40 (Estudiantes))
-- CentrosConTodos = (π centroId, estudianteId (Estudiantes) ÷ EstudiantesMayores40)
-- CentrosConTodos ⨝ Centros
```

> [Versión PDF disponible](./index.pdf)
