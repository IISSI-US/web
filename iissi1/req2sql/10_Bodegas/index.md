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

# Requisitos

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

### RN-5: Especialización de vinos
- Como: Profesor de la asignatura
- Quiero: Que cada vino pertenezca exactamente a uno de los subtipos Joven o Crianza.
- Para: Reflejar la especialización completa y disjunta del modelo conceptual. La clave de cada subtipo es también clave foránea a Vinos.

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

# Modelo Conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/bodegas/bodegas-dc.png' | relative_url }})

## Posible extensión

- Jerarquía extendida: Vino se especializa en Joven, Crianza y Reserva {completa, disjunta}.
- Reserva compone 0..* Valoración (ranking: TipoRanking, puntuación 0..100); no puede haber dos valoraciones del mismo ranking para un mismo vino (RN‑6).
- Se mantienen Bodega–Vino (1..*), Crianza–Cosecha (1..*), y Vino–Uva (M:N) como en el modelo base.
- RN‑5: Reserva 36 meses (12–24 en barrica; resto en botella). Además, se mantienen RN‑1..RN‑4.

![Diagrama de clases (examen)]({{ '/assets/images/iissi1/req2sql/bodegas/bodegas-dc-examen.png' | relative_url }})

# Modelo Relacional

```mr-table
Bodegas = { bodegaId, nombre, denominaciónOrigen }
    PK(bodegaId)
    AK(nombre)
Vinos = { vinoId, bodegaId, nombre, grados }
    PK(vinoId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Jóvenes = { vinoId, tiempoBarrica, tiempoBotella }
    PK(vinoId)
    FK(vinoId) / Vinos
Crianzas = { vinoId, tiempoBarrica, tiempoBotella }
    PK(vinoId)
    FK(vinoId) / Vinos
Uvas = { uvaId, nombre }
    PK(uvaId)
    AK(nombre)
Cosechas = { cosechaId, crianzaId, año, calidad }
    PK(cosechaId)
    FK(crianzaId) / Crianzas
    AK(cosechaId, crianzaId, año)
VinosUvas = { vinoUvaId, vinoId, uvaId }
    PK(vinoUvaId)
    FK(vinoId) / Vinos
    FK(uvaId) / Uvas
    AK(vinoId, uvaId)
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

La especialización se representa con tablas de subtipo: `Jóvenes.vinoId` y
`Crianzas.vinoId` son PK y FK a `Vinos.vinoId`. Los triggers impiden que el mismo
vino aparezca en ambos subtipos.

## Álgebra relacional

-Renombrado:

$$
B = \Ren{B\left(bid,nb,do\right)}\left(Bodegas\right)
$$

$$
V = \Ren{V\left(vid,bid,nv,g\right)}\left(Vinos\right)
$$ 

$$
J = \Ren{J\left(vid,tba,tbo\right)}\left(Jóvenes\right)
$$ 

$$
C = \Ren{C\left(vid,tba,tbo\right)}\left(Crianzas\right)
$$

$$
U = \Ren{U\left(uid,nu\right)}\left(Uvas\right)
$$

$$
Co = \Ren{Co\left(coid,vid,a,c\right)}\left(Cosechas\right)
$$ 

$$
VU = \Ren{VU\left(vuid,vid,uid\right)}\left(VinosUvas\right)
$$

- Seleccionar todas las bodegas con denominación de origen Rioja:

$$
Riojas \leftarrow \Sel{do=\text{'Rioja'}}\left(B\right)
$$

```mr-table
Riojas = { bid, nb, do }

Riojas = {
    (b1, "Bodegas El Sol", "Rioja")
}
```

- Listado de vinos con sus uvas:

$$
VVUU \leftarrow \left(V \NatJoin VU \NatJoin U\right)
$$

```mr-table
VVUU = {vid, bid, nv, g, vuid, uid, nu}

VVUU = {
    (v1, b1, "Vino Blanco Joven", 12, vu1, u3, "Albarino"),
    (v2, b2, "Vino Tinto Joven", 13, vu2, u1, "Tempranillo"),
    (v3, b1, "Vino Crianza Especial", 14, vu3, u2, "Garnacha"),
    (v3, b1, "Vino Crianza Especial", 14, vu4, u1, "Tempranillo"),
    (v4, b2, "Vino Crianza Reserva", 13.5, vu5, u2, "Garnacha"),
    (v4, b2, "Vino Crianza Reserva", 13.5, vu6, u1, "Tempranillo")
}
```

- Crianzas con sus cosechas:

$$
CCo \leftarrow \left(V \NatJoin C \NatJoin Co\right)
$$

```mr-table
CCo = {vid, bid, nv, g, tba, tbo, coid, a, c}

CCo = {
    (v3, b1, "Vino Crianza Especial", 14, 6, 18, c1, 2020, "Excelente"),
    (v3, b1, "Vino Crianza Especial", 14, 6, 18, c2, 2019, "Buena"),
    (v4, b2, "Vino Crianza Reserva", 13.5, 12, 12, c3, 2018, "Muy buena")
}
```

- Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas:

$$
BV \leftarrow \left(B \NatJoin V\right)
$$

```mr-table
BV = { bid, nb, do, vid, nv, g }

BV = {
    (b1, "Bodegas El Sol", "Rioja", v1, "Vino Blanco Joven", 12),
    (b2, "Bodegas La Luna", "Ribera del Duero", v2, "Vino Tinto Joven", 13),
    (b1, "Bodegas El Sol", "Rioja", v3, "Vino Crianza Especial", 14),
    (b2, "Bodegas La Luna", "Ribera del Duero", v4, "Vino Crianza Reserva", 13.5)
}
```

$$
BodegasJovenes \leftarrow \Proj{bid,nb}\left(BV \NatJoin J\right)
$$

```mr-table
BodegasJovenes = { bid, nb }

BodegasJovenes = {
    (b1, "Bodegas El Sol"),
    (b2, "Bodegas La Luna")
}
```

$$
BodegasCrianzas \leftarrow \Proj{bid,nb}\left(BV \NatJoin C\right)
$$

```mr-table
BodegasCrianzas = { bid, nb }

BodegasCrianzas = {
    (b1, "Bodegas El Sol"),
    (b2, "Bodegas La Luna")
}
```

$$
BodegasJovenes \Inter BodegasCrianzas
$$

```mr-table
BodegasJovenesCrianzas = { bid, nb }

BodegasJovenesCrianzas = {
    (b1, "Bodegas El Sol"),
    (b2, "Bodegas La Luna")
}
```

- Nombre de las bodegas y vinos que están compuestos, al menos, con uva "Tempranillo":

$$
BT \leftarrow \Proj{nb,nv}\left(\Sel{nu=\text{'Tempranillo'}}\left(BV \NatJoin VU \NatJoin U\right)\right)
$$

```mr-table
BT = { nb, nv }

BT = {
    ("Bodegas La Luna", "Vino Tinto Joven"),
    ("Bodegas El Sol", "Vino Crianza Especial"),
    ("Bodegas La Luna", "Vino Crianza Reserva")
}
```

- Total de cosechas por vino de crianza:

$$
TotalCosechasCrianza \leftarrow \Group{vid,\rho_{total}(\operatorname{COUNT}(*))}{vid}\left(C \NatJoin Co\right)
$$

```mr-table
TotalCosechasCrianza = { vid, total }

TotalCosechasCrianza = {
    (v3, 2),
    (v4, 1)
}
```

- Nombre del vino joven con más grados:

$$
maxGrados \leftarrow \GroupUp{\rho_{maxG}(\operatorname{MAX}(g))}\left(V \NatJoin J\right)
$$

```mr-table
maxGrados = { maxG }

maxGrados = {
    (13)
}
```

$$
VinoMasGrados \leftarrow \Proj{nv}\left(\Sel{g=maxG}\left((V \NatJoin J) \times maxGrados\right)\right)
$$

```mr-table
VinoMasGrados = { nv }

VinoMasGrados = {
    ("Vino Tinto Joven")
}
```

- Número de vinos crianza por cosecha:

$$
NumCCo \leftarrow \Group{a,\rho_{total}(\operatorname{COUNT}(vid))}{a}\left(Co\right)
$$

```mr-table
NumCCo = { a, total }

NumCCo = {
    (2018, 1),
    (2019, 1),
    (2020, 1)
}
```

- Bodegas con más vinos:

$$
BodegasNumVinos \leftarrow \Group{bid,nb,\rho_{total}(\operatorname{COUNT}(vid))}{bid,nb}\left(BV\right)
$$

```mr-table
BodegasNumVinos = { bid, nb, total }

BodegasNumVinos = {
    (b1, "Bodegas El Sol", 2),
    (b2, "Bodegas La Luna", 2)
}
```

$$
maxVinos \leftarrow \GroupUp{\rho_{maxTotal}(\operatorname{MAX}(total))}(BodegasNumVinos)
$$

```mr-table
maxVinos = { maxTotal }

maxVinos = {
    (2)
}
```

$$
BodegasMasVinos \leftarrow \Proj{bid,nb}\left(\Sel{total=maxTotal}\left(BodegasNumVinos \times maxVinos\right)\right)
$$

```mr-table
BodegasMasVinos = { bid, nb }

BodegasMasVinos = {
    (b1, "Bodegas El Sol"),
    (b2, "Bodegas La Luna")
}
```

- Vinos que tienen, al menos, las mismas uvas que el vino 'v1':

$$
VinosUvasV1 \leftarrow \Proj{vid,nv}\left(\left({\Proj{vid,uid}\left(VU\right)}\Div{\Proj{uid}\left(\Sel{vid=v1}\left(VU\right)\right)}\right) \NatJoin V\right)
$$

```mr-table
VinosUvasV1 = { vid, nv }

VinosUvasV1 = {
    (v1, "Vino Blanco Joven")
}
```

# Modelo Tecnológico

## Script SQL para crear la base de datos

{% include sql-embed.html src='/_code/bodegas/createDB.sql' label='bodegas/createDB.sql' collapsed=true %}

## Triggers de especialización

{% include sql-embed.html src='/_code/bodegas/triggers.sql' label='bodegas/triggers.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/_code/bodegas/populateDB.sql' label='bodegas/populateDB.sql' collapsed=true %}

`populateDB.sql` contiene al menos una cosecha por Crianza. La estructura de
tablas puede enlazar cada cosecha solo con una Crianza y limitar una cosecha por
año, pero no puede exigir declarativamente que toda Crianza insertada a mano
tenga una fila hija en `Cosechas`; eso requeriría una operación transaccional de
alta, que queda fuera de este flujo introductorio.

## Consultas

{% include sql-embed.html src='/_code/bodegas/queries.sql' label='bodegas/queries.sql' collapsed=true %}

## Pruebas SQL

{% include sql-embed.html src='/_code/bodegas/tests.sql' label='bodegas/tests.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
