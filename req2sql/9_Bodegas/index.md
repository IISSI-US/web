---
title: Bodegas
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Bodegas


## Requisitos


# Catálogo de Requisitos 

## Requisitos de información (RI)

### RI-1: Bodega
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de las bodegas: nombre y denominación de origen.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

### RI-2: Vino
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los vinos: nombre, grados de alcohol y Uvas que lo componen. Los vinos pueden ser de Jóvenes o Crianzas, en función al tiempo que pasen en barrica y botella. Además, para los vinos Crianzas, se debe almacenar las cosechas.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

### RI-3: Uvas
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de las uvas: nombre (Tempranillo, Garnacha, Carbernet Sauvignon, ...)
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

### RI-4: Cosechas
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de las cosechas: año y calidad (Excelente, Muy buena, Buena, Normal, Mala)
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

## Reglas de negocio (RN)

### RN-1: Unicidad
- Como: Profesor de la asignatura
- Quiero: Que no se repitan el nombre de las bodegas, vinos o uvas en el sistema
- Para: Que el estudiante practique con restricciones simples.

### RN-2: Tiempo de crianza
- Como: Profesor de la asignatura
- Quiero: Que el tiempo de crianza de un vino Crianza sea de al menos 24 meses, de los cuales entre 6 y 12 meses son en barrica y el resto en botella. El vino joven generalmente no pasa tiempo en barrica, o si lo hace, es muy breve (menos de 6 meses)
- Para: Que el estudiante practique con restricciones simples.

### RN-3: Graduación alcohólica
- Como: Profesor de la asignatura
- Quiero: Que la graduación alcohólica de un vino suele estar entre los 10 y 15 grados
- Para: Que el estudiante practique con restricciones complejas.

### RN-4: Cosechas
- Como: Profesor de la asignatura
- Quiero: Cada vino de crianza tiene como máximo una cosecha por año, y tiene al menos una cosecha
- Para: Que el estudiante practique con restricciones complejas.

## Requisitos funcionales (RF)

### RF-1: Informes simples de Bodegas
- Como: Profesor de la asignatura
- Quiero: Seleccionar todas las bodegas con denominación de origen Rioja. Listado de vinos con sus uvas. Crianazas con sus cosechas. Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas. Nombre de las bodegas y vinos que están compuestos, al menos, con uva 'Tempranillo'. Total de crianzas por cosecha. Nombre del vino joven con más grados
- Para: Que el estudiante practique con consultas simples.

## Pruebas de aceptación (PA)

### PA-1: Bodegas
1. ✅ Crear una nueva bodega con todos los datos correctos según las reglas de negocio
2. ❌ Crear una nueva bodega sin nombre.
3. ❌ Crear una nueva bodega con el nombre repetido.
4. ❌ Crear una nueva bodega sin denominación de origen.


### PA-2: Vinos
1. ✅ Crear un nuevo vino Joven con todos los datos correctos según las reglas de negocio
2. ✅ Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
3. ❌ Crear un nuevo vino Joven sin nombre.
4. ❌ Crear un nuevo vino Crianza sin nombre.
5. ❌ Crear un nuevo vino Joven con el nombre repetido.
6. ❌ Crear un nuevo vino Crianza con el nombre repetido.
7. ❌ Crear un nuevo vino Joven sin grados de alcohol.
8. ❌ Crear un nuevo vino Crianza sin grados de alcohol.
9. ❌ Crear un nuevo vino Joven con graduación incorrecta.
10. ❌ Crear un nuevo vino Crianza con graduación incorrecta.
11. ❌ Crear un nuevo vino Joven sin bodega.
12. ❌ Crear un nuevo vino Crianza sin bodega.

## Modelo Conceptual


# Modelo conceptual


## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Bodegas/bodegas-dc.png' | relative_url }})

## Posible extensión

- Jerarquía extendida: Vino se especializa en Joven, Crianza y Reserva {completa, disjunta}.
- Reserva compone 0..* Valoración (ranking: TipoRanking, puntuación 0..100); no puede haber dos valoraciones del mismo ranking para un mismo vino (RN‑6).
- Se mantienen Bodega–Vino (1..*), Crianza–Cosecha (1..*), y Vino–Uva (M:N) como en el modelo base.
- RN‑5: Reserva 36 meses (12–24 en barrica; resto en botella). Además, se mantienen RN‑1..RN‑4.

![Diagrama de clases (examen)]({{ '/assets/images/iissi1/req2sql/Bodegas/bodegas-dc-examen.png' | relative_url }})

## Modelo Relacional (v1)


# Modelo relacional

## Versión 1: Una relación para cada clase de la jerarquía

### Intensión

```
Bodegas(bodegaId, nombre, denominaciónOrigen)
    PK(bodegaId)
    AK(nombre)
Vinos(vinoId, bodegaId, nombre, grados)
    PK(vinoId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Jóvenes(vinoId, tiempoBarrica, tiempoBotella)
    PK(vinoId)
    FK(vinoId) / Vinos
Crianzas(vinoId, tiempoBarrica, tiempoBotella)
    PK(vinoId)
    FK(vinoId) / Vinos
Uvas(uvaId, nombre)
    PK(uvaId)
    AK(nombre)
Cosechas(cosechaId, crianzaId, año, calidad)
    PK(cosechaId)
    FK(crianzaId) / Crianzas
    AK(cosechaId, crianzaId, año)
VinosUvas(vinoUvaId, vinoId, uvaId)
    PK(vinoUvaId)
    FK(vinoId) / Vinos
    FK(uvaId) / Uvas
    AK(vinoId, uvaId)
```

### Extensión

```
Bodegas = {
    (b1, "Bodegas El Sol", "Rioja"),
    (b2, "Bodegas La Luna", "Ribera del Duero")      
}
Vinos = {
    (v1, b1, "Vino Blanco Joven", 12),
    (v2, b2, "Vino Tinto Joven", 13),
    (v3, b1, "Vino Crianza Especial", 14),
    (v4, b2, "Vino Crianza Reserva", 13.5)
}
Jóvenes = { (v1, 0, 6), (v2, 0, 12) }
Crianzas = { (v3, 6, 18), (v4, 12, 12) }
Uvas = {
    (u1, "Tempranillo"),
    (u2, "Garnacha"),
    (u3, "Albarino")
}
Cosechas = {
    (c1, v3, 2020, "Excelente"),
    (c2, v3, 2019, "Buena"),
    (c3, v4, 2018, "Muy buena")
}
VinosUvas = {
    (vu1, v1, u3),
    (vu2, v2, u1),
    (vu3, v3, u2),
    (vu4, v3, u1),
    (vu5, v4, u2),
    (vu6, v4, u1)
}
```

### Álgebra relacional

-Renombrado:

$$
B = \Ren{B(bid,nb,do)}(Bodegas)
$$

$$
V = \Ren{V(vid,bid,nv,g)}(Vinos)
$$ 

$$
J = \Ren{J(vid,tba,tbo)}(Jóvenes)
$$ 

$$
C = \Ren{C(vid,tba,tbo)}(Crianzas)
$$

$$
U = \Ren{U(uid,nu)}(Uvas)
$$

$$
Co = \Ren{Co(coid,vid,a,c)}(Cosechas)
$$ 

$$
VU = \Ren{VU(vuid,vid,uid)}(VinosUvas)
$$

- Seleccionar todas las bodegas con denominación de origen Rioja:

$$
Riojas \leftarrow \Sel{do=\text{'Rioja'}}(B)
$$

- Listado de vinos con sus uvas:

$$
VVUU \leftarrow V \NatJoin VU \NatJoin U
$$

La intensión de la relación derivada VVUU sería la unión de los conjuntos de atributos de las relaciones V, VU y U:

```
Intensión(VVUU) = {vid, bid, nv, g, vuid, uid, nu}
```

La extensión de VVUU quedaría con las siguientes tuplas:

```
Extensión(VVUU) = {
    (1, 1, "Vino Blanco Joven", 12, 1, 3, "Albarino"),
    (2, 2, "Vino Tinto Joven", 13, 2, 1, "Tempranillo"),
    (3, 1, "Vino Crianza Especial", 14, 4, 2, "Garnacha"),
    (3, 1, "Vino Crianza Especial", 14, 5, 1, "Tempranillo"),
    (4, 2, "Vino Crianza Reserva", 13.5, 6, 2, "Garnacha"),
    (4, 2, "Vino Crianza Reserva", 13.5, 7, 1, "Tempranillo")
}
```

- Crianzas con sus cosechas:

$$
CCo \leftarrow V \NatJoin Co
$$

En este caso, la intensión de la relación derivada CCo sería la unión de los conjuntos de atributos de las relaciones C y Co, y la extensión tendría las siguientes tuplas:

```
Intensión(CCo) = {vid, bid, nv, g, coid, a, c}

Extensión(CCo) = {
    (3, 1, "Vino Crianza Especial", 14, 1, 2020, "Excelente"),
    (3, 1, "Vino Crianza Especial", 14, 2, 2019, "Buena"),
    (4, 2, "Vino Crianza Reserva", 13.5, 3, 2018, "Muy buena")
}
```

- Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas:

$$
BV \leftarrow B \NatJoin V
$$

- Nombre de las bodegas y vinos que están compuestos, al menos, con uva "Tempranillo":

$$
BT \leftarrow \Proj{nb,nv}\big(\Sel{nu=\text{'Tempranillo'}}(BV \NatJoin VU \NatJoin U)\big)
$$

- Total de cosechas por vino de crianza:

$$
TotalCrianzas \leftarrow \Group{\operatorname{COUNT}(*)}{coid}(C \NatJoin Co)
$$

- Nombre del vino joven con más grados:

$$
max \leftarrow \GroupUp{\operatorname{MAX}(g)}(V \NatJoin J)
$$

$$
VinoMasGrados \leftarrow \Proj{nv}\big(\Sel{g=max}(V \NatJoin J)\big)
$$

- Número de vinos crianza por cosecha:

$$
NumCCo \leftarrow \Group{\operatorname{COUNT}(vid)}{coid}(Co)
$$

- Bodegas con más vinos:

$$
BodegasMasVinos \leftarrow \GroupUp{\operatorname{MAX}(n)}\left(\Ren{n \leftarrow \operatorname{COUNT}(vid)}\left(\Group{\operatorname{COUNT}(vid)}{bid}(BV)\right)\right)
$$

- Vinos que tienen, al menos, las mismas uvas que el vino 'v1':

$$
VinosUvasV1 \leftarrow \Proj{vid,nv}\left(\frac{\Proj{vid,uid}(VU)}{\Proj{uid}\big(\Sel{vid=v1}(VU)\big)} \NatJoin V\right)
$$

## Versión 2: Una relación para cada subclase

### Intensión

```
Bodegas(bodegaId, nombre, denominaciónOrigen)
    PK(bodegaId)
    AK(nombre)
Jóvenes(jovenId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella)
    PK(jovenId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Crianzas(crianzaId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella)
    PK(crianzaId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Uvas(uvaId, nombre)
    PK(uvaId)
    AK(nombre)
Cosechas(cosechaId, crianzaId, año, calidad)
    PK(cosechaId)
    FK(crianzaId) / Crianzas
    AK(cosechaId, crianzaId, año)
VinosUvas(vinoUvaId, jovenId*, crianzaId*, uvaId)
    PK(vinoUvaId)
    FK(jovenId) / Jóvenes
    FK(crianzaId) / Crianzas
    FK(uvaId) / Uvas
    AK(jovenId, uvaId)
    AK(crianzaId, uvaId)
    * Restricción: jovenId y crianzaId deben ser disjuntos.
```

### Extensión

```
Bodegas = {
    (b1, "Bodegas El Sol", "Rioja"),
    (b2, "Bodegas La Luna", "Ribera del Duero")      
}
Jóvenes = {
    (j1, b1, "Vino Blanco Joven", 12, 6, 0),
    (j2, b2, "Vino Tinto Joven", 13, 0, 12),
}
Crianzas = {
    (c1, b1, "Vino Crianza Especial", 14, 6, 18),
    (c2, b2, "Vino Crianza Reserva", 13.5, 12, 12)
}
Uvas = {
    (u1, "Tempranillo"),
    (u2, "Garnacha"),
    (u3, "Albarino")
}
Cosechas = {
    (co1, c1, 2020, "Excelente"),
    (co2, c1, 2019, "Buena"),
    (co3, c2, 2018, "Muy buena")
}
VinosUvas = {
    (vu1, j1, null, u3),
    (vu2, j2, null, u1),
    (vu3, null, c1, u2),
    (vu4, null, c1, u1),
    (vu5, null, c2, u2),
    (vu6, null, c2, u1)
}
```

## Modelo Relacional (v2)


# Modelo relacional

## Versión 2: Una relación para cada subclase

### Intensión

```
Bodegas(bodegaId, nombre, denominaciónOrigen)
    PK(bodegaId)
    AK(nombre)
Jóvenes(jovenId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella)
    PK(jovenId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Crianzas(crianzaId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella)
    PK(crianzaId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Uvas(uvaId, nombre)
    PK(uvaId)
    AK(nombre)
Cosechas(cosechaId, crianzaId, año, calidad)
    PK(cosechaId)
    FK(crianzaId) / Crianzas
    AK(cosechaId, crianzaId, año)
VinosUvas(vinoUvaId, jovenId*, crianzaId*, uvaId)
    PK(vinoUvaId)
    FK(jovenId) / Jóvenes
    FK(crianzaId) / Crianzas
    FK(uvaId) / Uvas
    AK(jovenId, uvaId)
    AK(crianzaId, uvaId)
    * Restricción: jovenId y crianzaId deben ser disjuntos.
```

### Extensión

```
Bodegas = {
    (b1, "Bodegas El Sol", "Rioja"),
    (b2, "Bodegas La Luna", "Ribera del Duero")      
}
Jóvenes = {
    (j1, b1, "Vino Blanco Joven", 12, 6, 0),
    (j2, b2, "Vino Tinto Joven", 13, 0, 12),
}
Crianzas = {
    (c1, b1, "Vino Crianza Especial", 14, 6, 18),
    (c2, b2, "Vino Crianza Reserva", 13.5, 12, 12)
}
Uvas = {
    (u1, "Tempranillo"),
    (u2, "Garnacha"),
    (u3, "Albarino")
}
Cosechas = {
    (co1, c1, 2020, "Excelente"),
    (co2, c1, 2019, "Buena"),
    (co3, c2, 2018, "Muy buena")
}
VinosUvas = {
    (vu1, j1, null, u3),
    (vu2, j2, null, u1),
    (vu3, null, c1, u2),
    (vu4, null, c1, u1),
    (vu5, null, c2, u2),
    (vu6, null, c2, u1)
}
```

## Modelo Tecnológico (v1)


# Modelo tecnológico. Versión 1: Una relación para cada clase de la jerarquía

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas/sql/createDB.sql' label='Bodegas/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas/sql/populateDB.sql' label='Bodegas/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas/sql/queries.sql' label='Bodegas/queries.sql' collapsed=true %}


## Modelo Tecnológico (v2)


# Modelo tecnológico. Versión 2: Una relación para cada subclase

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas2/sql/createDB.sql' label='Bodegas2/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas2/sql/populateDB.sql' label='Bodegas2/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas2/sql/queries.sql' label='Bodegas2/queries.sql' collapsed=true %}

## SQL Avanzado

Realice un disparador que compruebe que en la tabla VinosUvas no se insertan tuplas con valores para jovenId y crianzaId simultáneamente:

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas2/sql/triggers.sql' label='Bodegas2/triggers.sql' collapsed=true %}



## Pruebas SQL



# Pruebas SQL

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Bodegas2/sql/tests.sql' label='Bodegas2/tests.sql' collapsed=true %}


## Pruebas HTTP



# Pruebas HTTP

<div class="http-file" data-src="{{ '/silence-db/tests/Bodegas/bodegas.http' | relative_url }}"></div>

<div class="http-file" data-src="{{ '/silence-db/tests/Bodegas/vinos.http' | relative_url }}"></div>

> [Versión PDF disponible](./index.pdf)
