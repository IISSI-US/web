---
layout: single
title: "Composición y 1:N"
pdf_version: true
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
---
> [Versión PDF disponible](./index.pdf)

## Modelo Conceptual

![Diagrama de Clases](/assets/images/iissi1/mc2mr/ejercicio-01-universidad-clases.png)

## Intensión (Esquema Relacional)

La transformación UML → Relacional genera tres relaciones con claves primarias y foráneas:

```
Universidades(universidadId, nombre, dirección, fundación)
    PK(universidadId)

Centros(centroId, universidadId, nombre, código, presupuesto)
    PK(centroId)
    FK(universidadId)/Universidades
    
Estudiantes(estudianteId, centroId, matrícula, nombre, edad, promedio)
    PK(estudianteId)
    AK(matrícula)
    FK(centroId)/Centros
```

---

<!-- ## Diagrama UML (Objetos)
![Diagrama de Objetos](/assets/images/iissi1/mc2mr/ejercicio-01-universidad-objetos.png)

--- -->

## Extensión (Datos de ejemplo)

```
Universidades = {  
  (u1, 'UNAM', 'Ciudad de México', 1910-09-22),  
  (u2, 'ITESM', 'Monterrey', 1943-01-01)  
}

Centros = {  
  (f1, u1, 'Ingeniería', 'FI01', 5000000.50),  
  (f2, u1, 'Derecho', 'FD02', 3500000.25),  
  (f3, u1, 'Medicina', 'FM03', 7500000.75),  
  (f4, u2, 'Negocios', 'EN01', 4200000.00),  
  (f5, u2, 'Ingeniería', 'IE02', 6100000.20)  
}

Estudiantes = {  
  (e1, f1, '2023001', 'Ana', 20, 8.7),  
  (e2, f1, '2023002', 'Luis', 21, 8.1),  
  (e3, f2, '2023003', 'María', 19, 9.2),  
  (e4, f2, '2023004', 'Carlos', 22, 7.8),  
  (e5, f3, '2023005', 'Elena', 20, 9.5),  
  (e6, f4, '2023006', 'Roberto', 23, 8.9),  
  (e7, f5, '2023007', 'Sofia', 21, 9.1),  
  (e8, f5, '2023008', 'Diego', 19, 8.3)  
}
```

## Álgebra Relacional

Para simplificar la notación hacemos los siguientes renombrados:

$$ U \leftarrow \Ren{U(uid,n,d,f)}(Universidades)$$

$$ C \leftarrow \Ren{C(cid,uid,n,c,p)}(Centros)$$

$$ E \leftarrow \Ren{E(eid,cid,m,n,e,p)}(Estudiantes)$$

### Enunciados de consultas:

1. **Estudiantes con edad mayor a 20 años**
2. **Centros con presupuesto superior a 5 millones**
3. **Nombres y edades de estudiantes**
4. **Universidades fundadas después del año 2000**
5. **Estudiantes con promedio mayor o igual a 9.0**
6. **Centros de la Universidad Nacional (uid = u1)**
7. **Estudiantes con información de sus centros**
8. **Número de estudiantes por centro**
9. **Promedio de calificaciones por centro**
10. **Mejor promedio por universidad**

---

### Soluciones:

**1. Estudiantes con edad mayor a 20 años**

$$\Sel{edad > 20}(E)$$

```
Resultado: {
  (e2, f1, '2023002', 'Luis', 21, 8.1), 
  (e4, f2, '2023004', 'Carlos', 22, 7.8), 
  (e6, f4, '2023006', 'Roberto', 23, 8.9), 
  (e7, f5, '2023007', 'Sofia', 21, 9.1), 
  (e8, f5, '2023008', 'Diego', 19, 8.3)
}
```

**2. Centros con presupuesto superior a 5 millones**

$$\Sel{p > 5000000}(C)$$

```
Resultado: {
  (f3, u1, 'Medicina', 'FM03', 7500000.75), 
  (f5, u2, 'Ingeniería', 'IE02', 6100000.20)
}
```

**3. Nombres y edades de estudiantes**

$$\Proj{n, e}(E)$$

```
Resultado: {
  ('Ana', 20), ('Luis', 21), ('María', 19), ('Carlos', 22), 
  ('Elena', 20), ('Roberto', 23), ('Sofia', 21), ('Diego', 19)
}
```

**4. Universidades fundadas después del año 2000**

$$\Sel{f > 2000-01-01}(U)$$

```
Resultado: {
  (u2, 'ITESM', 'Monterrey', 2001-01-01)
}
```

**5. Estudiantes con promedio mayor o igual a 9.0**

$$\Sel{p \geq 9.0}(E)$$

```
Resultado: {
  (e3, f2, '2023003', 'María', 19, 9.2),
  (e5, f3, '2023005', 'Elena', 20, 9.5),
  (e7, f5, '2023007', 'Sofia', 21, 9.1)
}
```

**6. Centros de la Universidad Nacional (uid = u1)**

$$\Sel{uid = u1}(C)$$

```
Resultado: {
  (f1, u1, 'Ingeniería', 'FI01', 5000000.50),
  (f2, u1, 'Derecho', 'FD02', 3500000.25),
  (f3, u1, 'Medicina', 'FM03', 7500000.75)
}
```

**7. Estudiantes con información de sus centros**

$$E \NatJoin C$$

```
Resultado: {
  (e1, f1, u1, '2023001', 'Ana', 20, 8.7, 'Ingeniería', 'FI01', 5000000.50),
  (e2, f1, u1, '2023002', 'Luis', 21, 8.4, 'Ingeniería', 'FI01', 5000000.50),
  (e3, f2, u1, '2023003', 'María', 19, 9.2, 'Derecho', 'FD02', 3500000.25),
  ...
}
```

**8. Número de estudiantes por centro**

$$\Group{cid,COUNT(eid)}{cid}(E)$$

```
Resultado: {
  (f1, 3), (f2, 2), (f3, 1), (f4, 1), (f5, 1)
}
```

**9. Promedio de calificaciones por centro**

$$\Group{cid,AVG(p)}{cid}(E)$$

```
Resultado: {
  (f1, 8.43), (f2, 8.5), (f3, 9.5), (f4, 8.9), (f5, 9.1)
}
```

**10. Mejor promedio por universidad**

$$\Group{U.uid,MAX(E.p)}{U.uid}(E \NatJoin C \NatJoin U)$$

```
Resultado: {
  (u1, 9.5), (u2, 9.1)
}
```
