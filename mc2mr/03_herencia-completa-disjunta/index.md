---
layout: single
title: "Especialización completa y disjunta"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
sidebar:
  nav: mc2mr
---

## Modelo Conceptual
![Diagrama de Clases](/mc2mr/ejercicio-03-herencia-completa-disjunta-clases.png)

## Modelo Relacional. Intensión
```
Empleados(personaId, nombre, fechaNacimiento, numeroEmpleado, salario)
    PK(personaId)
    AK(numeroEmpleado)

Estudiantes(personaId, nombre, fechaNacimiento, numeroMatricula, añoIngreso)
    PK(personaId)
    AK(numeroMatricula)
```

<!-- ## Diagrama de objetos
![Diagrama de Objetos](/mc2mr/ejercicio-03-herencia-completa-disjunta-objetos.png) -->

## Modelo Relacional. Extensión
```text
Empleados = {
    (p1, 'Juan Pérez', 1985-03-15, 'E001', 50000.0),
    (p3, 'Carlos Ruiz', 1978-11-08, 'E002', 65000.0),
    (p5, 'Roberto Silva', 1982-09-30, 'E003', 58000.0),
    (p7, 'David Torres', 1975-06-25, 'E004', 72000.0)
}

Estudiantes = {
    (p2, 'Ana García', 2000-07-22, 'M2023001', 2023),
    (p4, 'María López', 1999-04-12, 'M2023002', 2023),
    (p6, 'Laura Martín', 2001-01-18, 'M2024001', 2024),
    (p8, 'Elena Vázquez', 2000-12-03, 'M2024002', 2024)
}
```

## Álgebra Relacional

Para simplificar la notación hacemos los siguientes renombrados:

$$Emp \leftarrow \Ren{Emp(pid,n,fn,ne,s)}(Empleados)$$

$$Est \leftarrow \Ren{Est(pid,n,fn,nm,ai)}(Estudiantes)$$

### Enunciados de consultas:

1. **Todos los empleados**
2. **Todos los estudiantes**
3. **Todas las personas (unión de empleados y estudiantes)**
4. **Empleados con salario mayor a 60,000**
5. **Estudiantes que ingresaron en 2023**
6. **Personas jóvenes (nacidas después de 1990)**
7. **Empleados más jóvenes que estudiantes**
8. **Salario promedio de empleados**
9. **Número de estudiantes por año de ingreso**
10. **Empleados con salario superior al promedio**

---

### Soluciones:

**1. Todos los empleados (ya disponible directamente)**

$$Emp$$

```
Resultado: {
  (p1, 'Juan Pérez', 1985-03-15, 'E001', 50000.0),
  (p3, 'Carlos Ruiz', 1978-11-08, 'E002', 65000.0),
  (p5, 'Roberto Silva', 1982-09-30, 'E003', 58000.0),
  (p7, 'David Torres', 1975-06-25, 'E004', 72000.0)
}
```

**2. Todos los estudiantes (ya disponible directamente)**

$$Est$$

```
Resultado: {
  (p2, 'Ana García', 2000-07-22, 'M2023001', 2023),
  (p4, 'María López', 1999-04-12, 'M2023002', 2023),
  (p6, 'Laura Martín', 2001-01-18, 'M2024001', 2024),
  (p8, 'Elena Vázquez', 2000-12-03, 'M2024002', 2024)
}
```

**3. Todas las personas (unión de empleados y estudiantes)**

$$\Proj{pid,n,fn}(Emp) \Union \Proj{pid,n,fn}(Est)$$

```
Resultado: {
  (p1, 'Juan Pérez', 1985-03-15),
  (p2, 'Ana García', 2000-07-22),
  (p3, 'Carlos Ruiz', 1978-11-08),
  (p4, 'María López', 1999-04-12),
  (p5, 'Roberto Silva', 1982-09-30),
  (p6, 'Laura Martín', 2001-01-18),
  (p7, 'David Torres', 1975-06-25),
  (p8, 'Elena Vázquez', 2000-12-03)
}
```

**4. Empleados con salario mayor a 60,000**

$$\Proj{n, ne, s}(\Sel{s > 60000}(Emp))$$

```
Resultado: {
  ('Carlos Ruiz', 'E002', 65000.0),
  ('David Torres', 'E004', 72000.0)
}
```

**5. Estudiantes que ingresaron en 2023**

$$\Proj{n, nm}(\Sel{ai = 2023}(Est))$$

```
Resultado: {
  ('Ana García', 'M2023001'),
  ('María López', 'M2023002')
}
```

**6. Personas jóvenes (nacidas después de 1990)**

$$Per \leftarrow \Proj{n, fn}(Emp) \Union \Proj{n, fn}(Est)$$

$$\Sel{fn > 1990-01-01}(Per)$$

```
Resultado: {
  ('Ana García', 2000-07-22),
  ('María López', 1999-04-12),
  ('Laura Martín', 2001-01-18),
  ('Elena Vázquez', 2000-12-03)
}
```

**7. Empleados más jóvenes que estudiantes**

$$\Sel{Emp.fn > Est.fn}(Emp \times Est)$$

```
Resultado: ∅ (conjunto vacío)
-- Ningún empleado es más joven que ningún estudiante
-- Todos los empleados nacieron entre 1975-1985
-- Todos los estudiantes nacieron entre 1999-2001
```

**8. Salario promedio de empleados**

$$salProm \leftarrow \Group{AVG(s)}{}(Emp)$$

```
Resultado: {
  (61250.0)  -- (50000 + 65000 + 58000 + 72000) / 4
}
```

**9. Número de estudiantes por año de ingreso**

$$\Group{ai, COUNT(pid)}{ai}(Est)$$

```
Resultado: {
  (2023, 2),
  (2024, 2)
}
```

**10. Empleados con salario superior al promedio**

$$\Proj{n, ne, s}(\Sel{s > salProm}(Emp))$$

```
Resultado: {
  ('Carlos Ruiz', 'E002', 65000.0),
  ('David Torres', 'E004', 72000.0)
}
```
