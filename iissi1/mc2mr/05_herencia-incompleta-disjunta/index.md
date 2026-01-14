---
layout: single
title: " Herencia incompleta y disjunta"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---

## Modelo Conceptual
![Diagrama de Clases]({{ '/assets/images/iissi1/mc2mr/ejercicio-05-herencia-incompleta-disjunta-clases.png' | relative_url }})

## Modelo Relacional. Intensión
```
** Versión 1: Una relación con discriminante

Vehículos(vehículoId, marca, modelo, año, clase, numeroPuertas, tipoTransmisión, cilindrada, tipoManillar)
    PK(vehículoId)
    ** clase puede ser 'C', 'M' o 'V'

Versión 2: Una relación por cada entidad

Vehículos(vehículoId, marca, modelo, año, clase)
    PK(vehículoId)

Coches(VehículoId, númeroPuertas, tipoTransmisión)
    PK(vehículoId)
    FK(vehículoId)/Vehículos

Motos(vehículoId, cilindrada, tipoManillar)
    PK(vehículoId)
    FK(vehículoId)/Vehículos

** Al ser disjunta los IDs de Coches y Motos tienes que ser disjuntos
```

## Modelo Relacional. Extensión
```text
** Versión 1:
Vehículos = {
    (v1, 'Ford', 'F-150', 2021, 'V', null, null, null, null),
    (v2, 'Toyota', 'Corolla', 2022, 'C', 4, 'Automática', null, null),
    (v3, 'Honda', 'CBR', 2023, 'M', null, null, 600, 'Deportivo'),
    (v4, 'BMW', '320i', 2023, 'C', 4, 'Manual', null, null),
    (v5, 'Yamaha', 'R1', 2022, 'M', null, null, 1000, 'Deportivo'),
    (v6, 'Chevrolet', 'Silverado', 2020, 'V', null, null, null, null),
    (v7, 'Audi', 'A4', 2023, 'C', 2, 'Automática', null, null),
    (v8, 'Kawasaki', 'Ninja', 2021, 'M', null, null, 650, 'Cruiser'),
    (v9, 'Mercedes', 'Sprinter', 2022, 'V', null, null, null, null),
    (v10, 'Honda', 'Civic', 2023, 'C', 4, 'CVT', null, null),
    (v11, 'Ducati', 'Panigale', 2023, 'M', null, null, 1200, 'Deportivo'),
    (v12, 'Nissan', 'Titan', 2021, 'V', null, null, null, null)
}

** Versión 2:
Vehículos = {
    (v1, 'Ford', 'F-150', 2021),
    (v2, 'Toyota', 'Corolla', 2022),
    (v3, 'Honda', 'CBR', 2023),
    (v4, 'BMW', '320i', 2023),
    (v5, 'Yamaha', 'R1', 2022),
    (v6, 'Chevrolet', 'Silverado', 2020),
    (v7, 'Audi', 'A4', 2023),
    (v8, 'Kawasaki', 'Ninja', 2021),
    (v9, 'Mercedes', 'Sprinter', 2022),
    (v10, 'Honda', 'Civic', 2023),
    (v11, 'Ducati', 'Panigale', 2023),
    (v12, 'Nissan', 'Titan', 2021)
}

Coches = {
    (v2, 4, 'Automática'),
    (v4, 4, 'Manual'),
    (v7, 2, 'Automática'),
    (v10, 4, 'CVT')
}

Motos = {
    (v3, 'Honda', 'CBR', 2023, 600, 'Deportivo'),
    (v5, 'Yamaha', 'R1', 2022, 1000, 'Deportivo'),
    (v8, 'Kawasaki', 'Ninja', 2021, 650, 'Cruiser'),
    (v11, 'Ducati', 'Panigale', 2023, 1200, 'Deportivo'),
}
```

## Álgebra relacional

### Enunciados

**1.** Obtener todos los vehículos que son coches

**2.** Obtener todos los vehículos que son motos

**3.** Obtener todos los vehículos genéricos (que no son ni coches ni motos)

**4.** Obtener la marca y modelo de todas las motos con cilindrada mayor a 800cc

**5.** Obtener todos los coches con transmisión automática

**6.** Obtener vehículos fabricados en 2023

**7.** Obtener la cilindrada promedio de todas las motos

**8.** Obtener el coche más antiguo

**9.** Obtener todas las marcas que fabrican tanto coches como motos

**10.** Obtener vehículos que no son especializados (solo vehículos genéricos)

---

### Soluciones (versión 1)

**Renombramiento de relación:**

$$ V \leftarrow \Ren{V(vid,mar,mod,año,cla,pue,tra,cil,man)}(Vehículos)$$

**Relaciones intermedias:**

$$Coches \leftarrow \Sel{cla = 'C'}(V)$$

$$Motos \leftarrow \Sel{cla = 'M'}(V)$$

$$VehículosGenéricos \leftarrow \Sel{cla = 'V'}(V)$$

**1. Obtener todos los vehículos que son coches**

$$Coches$$

```
Resultado: {
    (v2, 'Toyota', 'Corolla', 2022, 'C', 4, 'Automática', null, null),
    (v4, 'BMW', '320i', 2023, 'C', 4, 'Manual', null, null),
    (v7, 'Audi', 'A4', 2023, 'C', 2, 'Automática', null, null),
    (v10, 'Honda', 'Civic', 2023, 'C', 4, 'CVT', null, null)
}
```

**2. Obtener todos los vehículos que son motos**

$$Motos$$

```
Resultado: {
    (v3, 'Honda', 'CBR', 2023, 'M', null, null, 600, 'Deportivo'),
    (v5, 'Yamaha', 'R1', 2022, 'M', null, null, 1000, 'Deportivo'),
    (v8, 'Kawasaki', 'Ninja', 2021, 'M', null, null, 650, 'Cruiser'),
    (v11, 'Ducati', 'Panigale', 2023, 'M', null, null, 1200, 'Deportivo')
}
```

**3. Obtener todos los vehículos genéricos (que no son ni coches ni motos)**

$$VehículosGenéricos$$

```
Resultado: {
    (v1, 'Ford', 'F-150', 2021, 'V', null, null, null, null),
    (v6, 'Chevrolet', 'Silverado', 2020, 'V', null, null, null, null),
    (v9, 'Mercedes', 'Sprinter', 2022, 'V', null, null, null, null),
    (v12, 'Nissan', 'Titan', 2021, 'V', null, null, null, null)
}
```

**4. Obtener la marca y modelo de todas las motos con cilindrada mayor a 800cc**

$$\Proj{mar, mod}(\Sel{cil > 800}(Motos))$$

```
Resultado: {
    ('Yamaha', 'R1'),
    ('Ducati', 'Panigale')
}
```

**5. Obtener todos los coches con transmisión automática**

$$\Sel{tra = 'Automática'}(Coches)$$

```
Resultado: {
    (v2, 'Toyota', 'Corolla', 2022, 'C', 4, 'Automática', null, null),
    (v7, 'Audi', 'A4', 2023, 'C', 2, 'Automática', null, null)
}
```

**6. Obtener vehículos fabricados en 2023**

$$\Sel{año = 2023}(V)$$

```
Resultado: {
    (v3, 'Honda', 'CBR', 2023, 'M', null, null, 600, 'Deportivo'),
    (v4, 'BMW', '320i', 2023, 'C', 4, 'Manual', null, null),
    (v7, 'Audi', 'A4', 2023, 'C', 2, 'Automática', null, null),
    (v10, 'Honda', 'Civic', 2023, 'C', 4, 'CVT', null, null),
    (v11, 'Ducati', 'Panigale', 2023, 'M', null, null, 1200, 'Deportivo')
}
```

**7. Obtener la cilindrada promedio de todas las motos**

$$cilPromedio \leftarrow \Group{AVG(cil)}{}(Motos)$$

```
Resultado: {
    (862.5)  -- (600 + 1000 + 650 + 1200) / 4
}
```

**8. Obtener el coche más antiguo**

$$añoMin \leftarrow \Group{MIN(año)}{}(Coches)$$

$$\Sel{año = añoMin}(Coches)$$

```
Resultado: {
    (v2, 'Toyota', 'Corolla', 2022, 'C', 4, 'Automática', null, null)
}
```

**9. Obtener todas las marcas que fabrican tanto coches como motos**

$$\Proj{mar}(Coches) \Inter \Proj{mar}(Motos)$$

```
Resultado: {
    ('Honda')
}
```

**10. Obtener vehículos que no son especializados (solo vehículos genéricos)**

$$VehículosGenéricos$$

```
Resultado: {
    (v1, 'Ford', 'F-150', 2021, 'V', null, null, null, null),
    (v6, 'Chevrolet', 'Silverado', 2020, 'V', null, null, null, null),
    (v9, 'Mercedes', 'Sprinter', 2022, 'V', null, null, null, null),
    (v12, 'Nissan', 'Titan', 2021, 'V', null, null, null, null)
}
```

### Soluciones (versión 2)

**Renombramiento de relación:**

$$ V \leftarrow \Ren{V(vid,mar,mod,año)}(Vehículos)$$

$$ C \leftarrow \Ren{C(vid,pue,tra)}(Vehículos)$$

$$ M \leftarrow \Ren{M(vid,cil,man)}(Vehículos)$$

**1. Obtener todos los vehículos que son coches**

$$ V \Join C $$

**2. Obtener todos los vehículos que son motos**

$$ V \Join M $$

**3. Obtener todos los vehículos genéricos (que no son ni coches ni motos)**

$$ V \setminus C \setminus M$$

**4. Obtener la marca y modelo de todas las motos con cilindrada mayor a 800cc**

$$\Proj{mar, mod}(\Sel{cil > 800}(V \Join M))$$

**5. Obtener todos los coches con transmisión automática**

$$\Sel{tra = 'Automática'}(V \Join C)$$

**6. Obtener vehículos fabricados en 2023**

$$\Sel{año = 2023}(V)$$

**7. Obtener la cilindrada promedio de todas las motos**

$$cilPromedio \leftarrow \Group{AVG(cil)}{}(M)$$

**8. Obtener el coche más antiguo**

$$añoMin \leftarrow \Group{MIN(año)}{}(C)$$

$$\Sel{año = añoMin}(V \Join C)$$

**9. Obtener todas las marcas que fabrican tanto coches como motos**

$$\Proj{mar}(V \Join C \Join M) $$

**10. Obtener vehículos que no son especializados (solo vehículos genéricos)**

$$ V $$

> [Versión PDF disponible](./index.pdf)
