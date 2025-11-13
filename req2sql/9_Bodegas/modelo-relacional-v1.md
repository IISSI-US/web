---
layout: default
title: Modelo Relacional (v1)
parent: Bodegas
nav_order: 3
---

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
