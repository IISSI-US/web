---
layout: single
title: Ejercicio 6
toc: true
toc_label: "Contenido"
sidebar:
    nav: mc2mr
---

# Ejercicio 6: Herencia incompleta y solapada (RecursoHumano → Gerente | Ingeniero)
<!-- {: .fs-9 } -->

Especialización parcial con solapamiento permitido
<!-- {: .fs-6 .fw-300 } -->

---

## Diagrama UML (Clases)
![Diagrama de Clases](/mc2mr/ejercicio-06-herencia-incompleta-solapada-clases.png)

## Intensión relacional
```
RecursosHumanos(recursoId, nombre, email, fechaContratacion, esGerente, tamañoEquipo, presupuesto, esIngeniero, especialidad, añosExperiencia)
    PK(recursoId)
```

<!-- ## Diagrama de objetos
![Diagrama de Objetos](/mc2mr/ejercicio-06-herencia-incompleta-solapada-objetos.png) -->

## Extensión relacional
```text
RecursosHumanos = {
    (r1, 'Carlos Ruiz', 'carlos@empresa.com', 2020-01-15, true, 15, 500000.0, false, null, null),
    (r2, 'Laura Gómez', 'laura@empresa.com', 2021-03-10, false, null, null, true, 'Backend', 5),
    (r3, 'Miguel Torres', 'miguel@empresa.com', 2019-06-01, true, 8, 200000.0, true, 'Arquitectura', 10),
    (r4, 'Patricia López', 'patricia@empresa.com', 2022-09-15, false, null, null, false, null, null),
    (r5, 'Ana Martín', 'ana@empresa.com', 2020-05-20, true, 12, 350000.0, false, null, null),
    (r6, 'David Chen', 'david@empresa.com', 2021-11-08, false, null, null, true, 'Frontend', 3),
    (r7, 'Sofía Herrera', 'sofia@empresa.com', 2018-02-14, true, 20, 800000.0, true, 'DevOps', 12),
    (r8, 'Roberto Vega', 'roberto@empresa.com', 2023-01-10, false, null, null, true, 'Mobile', 2),
    (r9, 'Carmen Díaz', 'carmen@empresa.com', 2022-07-03, false, null, null, false, null, null),
    (r10, 'Luis Moreno', 'luis@empresa.com', 2019-09-25, true, 6, 180000.0, true, 'Security', 8)
}
```

---

## Álgebra relacional

### Enunciados

**1.** Obtener todos los recursos humanos que son gerentes

**2.** Obtener todos los recursos humanos que son ingenieros

**3.** Obtener recursos humanos que son tanto gerentes como ingenieros

**4.** Obtener el nombre y especialidad de ingenieros con más de 5 años de experiencia

**5.** Obtener gerentes con presupuesto superior a 300,000

**6.** Obtener recursos humanos contratados en 2021

**7.** Obtener el presupuesto promedio de todos los gerentes

**8.** Obtener el gerente con el equipo más grande

**9.** Obtener recursos humanos que no están especializados

**10.** Obtener todas las especialidades de ingenieros únicas

### Soluciones

**Renombramiento de relación:**

$$RH \leftarrow \Ren{RH(rid,nom,ema,fec,esG,tam,pre,esI,esp,exp)}(RecursosHumanos)$$

**Relaciones intermedias:**

$$Gerentes \leftarrow \Sel{esG = true}(RH)$$

$$Ingenieros \leftarrow \Sel{esI = true}(RH)$$

$$RecursosGenéricos \leftarrow \Sel{esG = false \land esI = false}(RH)$$

**1. Obtener todos los recursos humanos que son gerentes**

$$Gerentes$$

```
Resultado: {
    (r1, 'Carlos Ruiz', 'carlos@empresa.com', 2020-01-15, true, 15, 500000.0, false, null, null),
    (r3, 'Miguel Torres', 'miguel@empresa.com', 2019-06-01, true, 8, 200000.0, true, 'Arquitectura', 10),
    (r5, 'Ana Martín', 'ana@empresa.com', 2020-05-20, true, 12, 350000.0, false, null, null),
    (r7, 'Sofía Herrera', 'sofia@empresa.com', 2018-02-14, true, 20, 800000.0, true, 'DevOps', 12),
    (r10, 'Luis Moreno', 'luis@empresa.com', 2019-09-25, true, 6, 180000.0, true, 'Security', 8)
}
```

**2. Obtener todos los recursos humanos que son ingenieros**

$$Ingenieros$$

```
Resultado: {
    (r2, 'Laura Gómez', 'laura@empresa.com', 2021-03-10, false, null, null, true, 'Backend', 5),
    (r3, 'Miguel Torres', 'miguel@empresa.com', 2019-06-01, true, 8, 200000.0, true, 'Arquitectura', 10),
    (r6, 'David Chen', 'david@empresa.com', 2021-11-08, false, null, null, true, 'Frontend', 3),
    (r7, 'Sofía Herrera', 'sofia@empresa.com', 2018-02-14, true, 20, 800000.0, true, 'DevOps', 12),
    (r8, 'Roberto Vega', 'roberto@empresa.com', 2023-01-10, false, null, null, true, 'Mobile', 2),
    (r10, 'Luis Moreno', 'luis@empresa.com', 2019-09-25, true, 6, 180000.0, true, 'Security', 8)
}
```

**3. Obtener recursos humanos que son tanto gerentes como ingenieros**

$$Gerentes \Inter Ingenieros$$

```
Resultado: {
    (r3, 'Miguel Torres', 'miguel@empresa.com', 2019-06-01, true, 8, 200000.0, true, 'Arquitectura', 10),
    (r7, 'Sofía Herrera', 'sofia@empresa.com', 2018-02-14, true, 20, 800000.0, true, 'DevOps', 12),
    (r10, 'Luis Moreno', 'luis@empresa.com', 2019-09-25, true, 6, 180000.0, true, 'Security', 8)
}
```

**4. Obtener el nombre y especialidad de ingenieros con más de 5 años de experiencia**

$$\Proj{nom, esp}\left(\Sel{exp > 5}(Ingenieros)\right)$$

```
Resultado: {
    ('Miguel Torres', 'Arquitectura'),
    ('Sofía Herrera', 'DevOps'),
    ('Luis Moreno', 'Security')
}
```

**5. Obtener gerentes con presupuesto superior a 300,000**

$$\Sel{pre > 300000}(Gerentes)$$

```
Resultado: {
    (r1, 'Carlos Ruiz', 'carlos@empresa.com', 2020-01-15, true, 15, 500000.0, false, null, null),
    (r5, 'Ana Martín', 'ana@empresa.com', 2020-05-20, true, 12, 350000.0, false, null, null),
    (r7, 'Sofía Herrera', 'sofia@empresa.com', 2018-02-14, true, 20, 800000.0, true, 'DevOps', 12)
}
```

**6. Obtener recursos humanos contratados en 2021**

$$\Sel{fec \geq '2021-01-01' \land fec < '2022-01-01'}(RH)$$

```
Resultado: {
    (r2, 'Laura Gómez', 'laura@empresa.com', 2021-03-10, false, null, null, true, 'Backend', 5),
    (r6, 'David Chen', 'david@empresa.com', 2021-11-08, false, null, null, true, 'Frontend', 3)
}
```

**7. Obtener el presupuesto promedio de todos los gerentes**

$$presPromedio \leftarrow \Group{AVG(pre)}{}(Gerentes)$$

```
Resultado: {
    (406000.0)  -- (500000 + 200000 + 350000 + 800000 + 180000) / 5
}
```

**8. Obtener el gerente con el equipo más grande**

$$tamMax \leftarrow \Group{MAX(tam)}{}(Gerentes)$$

$$\Sel{tam = tamMax}(Gerentes)$$

```
Resultado: {
    (r7, 'Sofía Herrera', 'sofia@empresa.com', 2018-02-14, true, 20, 800000.0, true, 'DevOps', 12)
}
```

**9. Obtener recursos humanos que no están especializados**

$$RecursosGenéricos$$

```
Resultado: {
    (r4, 'Patricia López', 'patricia@empresa.com', 2022-09-15, false, null, null, false, null, null),
    (r9, 'Carmen Díaz', 'carmen@empresa.com', 2022-07-03, false, null, null, false, null, null)
}
```

**10. Obtener todas las especialidades de ingenieros únicas**

$$\Proj{esp}(Ingenieros)$$

```
Resultado: {
    ('Backend'),
    ('Arquitectura'),
    ('Frontend'),
    ('DevOps'),
    ('Mobile'),
    ('Security')
}
```
