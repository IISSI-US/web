---
layout: default
title: Modelo Relacional
parent: Pedidos
nav_order: 3
---

# Modelo relacional

## Intensión

```
Usuarios(usuarioId, nombre, provincia, fechaAlta)
	PK(usuarioId)
Productos(productoId, descripcion, precio, stock)
	PK(productoId)
Pedidos(pedidoId, usuarioId, productoId, fechaCompra, cantidad)
	PK(pedidoId)
	FK(usuarioId) / Usuarios
	FK(productoId) / Productos
```

## Extensión

```
Usuarios = {
	(u1, "David Ruiz", "Sevilla", "2018-05-18"),
	(u2, "Marta López", "Málaga", "2018-06-12"),
	(u3, "Raquel Lobato", "Granada", "2018-12-01"),
	(u4, "Antonio Gómez", "Sevilla", "2018-03-11"),
	(u5, "Inma Hernández", "Málaga", "2018-04-12"),
	(u6, "Jimena Martín", "Granada", "2018-05-13"),
	(u7, "Carlos Rivero", "Huelva", "2018-09-07"),
	(u8, "Carlos Arévalo", "Málaga", "2018-09-07")
}
Productos = {
	(p1, "Mi Band 3", 19.90, 50),
	(p2, "Mi Band 4", 29.90, 20),
	(p3, "Pulsera compatible con Mi Band 3 y 4", 9.90, 150),
	(p4, "Mi Scooter", 349.90, 25),
	(p5, "Rueda trasera de respuesto Mi Scooter", 19.90, 50),
	(p6, "Rueda delantera de respuesto Mi Scooter", 59.90, 50)
}
Pedidos = {
	(pe1, u1, p1, "2019-05-13", 2),
	(pe2, u1, p3, "2019-05-13", 2),
	(pe3, u2, p2, "2019-06-11", 3),
	(pe4, u2, p3, "2019-06-11", 1),
	(pe5, u3, p4, "2019-06-15", 2),
	(pe6, u4, p5, "2019-06-18", 1),
	(pe7, u4, p6, "2019-06-18", 1),
	(pe8, u5, p4, "2019-12-15", 2),
	(pe9, u7, p1, "2019-12-15", 1),
	(pe10, u7, p2, "2019-12-16", 1),
	(pe11, u7, p3, "2019-12-17", 1),
	(pe12, u7, p4, "2019-12-18", 1),
	(pe13, u7, p5, "2019-12-19", 1),
	(pe14, u7, p6, "2019-12-20", 1),
	(pe15, u8, p1, "2019-12-15", 1)
}
```

## Álgebra relacional

Renombrado:

$$
U(uId,n,p,fa) \leftarrow Usuarios(usuarioId,nombre,provincia,fechaAlta)\\
$$

$$
P(pId,d,p,s) \leftarrow Productos(productoId,descripcion,precio,stock)\\
$$

$$
Ped(pedId,uId,pId,fc,c) \leftarrow Pedidos(pedidoId,usuarioId,productoId,fechaCompra,cantidad)
$$

Listados y consultas:

- Todos los pedidos con sus usuarios y productos:

$$
UPP \leftarrow U \NatJoin Ped \NatJoin P
$$

- Pedidos de usuarios de Málaga:

$$
\Sel{U.p=\text{Málaga}}(UPP)
$$

- Descripción y stock de productos con stock < 100:

$$
\Proj{P.d,P.s}(\Sel{P.s<100}(P))
$$

- Número de pedidos por usuario:

$$
\Group{\operatorname{COUNT}(pedId)}{uId}(U \NatJoin Ped)
$$

- Importe total por usuario:

$$
\Group{\operatorname{SUM}(P.p\cdot Ped.c)}{uId}(P \NatJoin Ped)
$$

- Pedidos por mes:

$$
\Group{\operatorname{COUNT}(pedId)}{\operatorname{MES}(Ped.fc)}(Ped)
$$

- Usuario que más gasta cada mes:

$$
\Group{U.n,\;\operatorname{MAX}(P.p\cdot Ped.c)}{\operatorname{MES}(Ped.fc)}(U \NatJoin P \NatJoin Ped)
$$

- Mes de máxima recaudación:

$$
\GroupUp{\operatorname{MAX}(P.p\cdot Ped.c)}(P \NatJoin Ped)
$$
