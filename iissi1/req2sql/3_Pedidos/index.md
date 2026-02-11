---
title: Pedidos
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Pedidos


## Requisitos


# Catálogo de Requisitos

## Requisitos de información (RI)

### RI-1: Usuarios
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los usuarios: nombre, provincia y fecha de alta en el Sistema de Pedidos.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico

### RI-2: Productos
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los productos: descripción, precio y stock en el almacén.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico

### RI-3: Pedidos
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los pedidos: fecha de compra en la que el usuario hace el pedido y cantidad de productos que se piden.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico

## Reglas de negocio (RN)

### RN-1: Límite de pedidos
- Como: Profesor de la asignatura
- Quiero: Que un usuario no pueda hacer más de tres pedidos al día
- Para: Que el estudiante practique con restricciones simples

### RN-2: Agosto inhábil
- Como: Profesor de la asignatura
- Quiero: Que no se puedan hacer pedidos en el mes de agosto
- Para: Que el estudiante practique con restricciones simples

### RN-3: Stock suficiente
- Como: Profesor de la asignatura
- Quiero: Que solo se pueda realizar el pedido si hay stock suficiente
- Para: Que el estudiante practique con restricciones simples

## Pruebas de aceptación (PA)

### PA-1: Pedidos

  1. ✅ Crear un nuevo pedido con todos los datos correctos según las reglas de negocio.
  2. ❌ Crear un nuevo pedido sin especificar la cantidad de productos.
  3. ❌ Crear un nuevo pedido sin especificar la fecha de compra.
  4. ❌ Crear un nuevo pedido con más de tres pedidos al día.
  5. ❌ Crear un nuevo pedido en el mes de agosto.
  6. ❌ Crear un nuevo pedido sin stock suficiente.


## Modelo Conceptual


# Modelo conceptual

## Diagrama de clases 

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Pedidos/pedidos-dc.png' | relative_url }})

# Modelo relacional

## Intensión

```text
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

```text
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
\Ren{U(uId,n,p,fa)}{Usuarios(usuarioId,nombre,provincia,fechaAlta)}
$$

$$
\Ren{P(pId,d,p,s)}{Productos(productoId,descripcion,precio,stock)}
$$

$$
\Ren{Ped(pedId,uId,pId,fc,c)}{Pedidos(pedidoId,usuarioId,productoId,fechaCompra,cantidad)}
$$

Listados y consultas:

- **Todos los pedidos con sus usuarios y productos**: Join natural entre las tres tablas para obtener información completa de cada pedido.

$$
UPP \leftarrow U \NatJoin Ped \NatJoin P
$$

- **Pedidos de usuarios de Málaga**: Filtramos los pedidos completos (UPP) seleccionando solo aquellos cuyo usuario tiene provincia Málaga.

$$
\Sel{U.p=\text{Málaga}}(UPP)
$$

- **Descripción y stock de productos con stock < 100**: Proyectamos solo la descripción y stock de aquellos productos cuyo stock es inferior a 100 unidades.

$$
\Proj{P.d,P.s}\left(\Sel{P.s<100}(P)\right)
$$

- **Número de pedidos por usuario**: Agrupamos por usuario (uId) y contamos cuántos pedidos tiene cada uno. El join con U asegura incluir a todos los usuarios que han hecho pedido.

$$
\Group{uId, \operatorname{COUNT}(pedId)}{uId}(U \NatJoin Ped)
$$

- **Importe total por usuario**: Agrupamos por usuario y sumamos el importe de todos sus pedidos (precio × cantidad). Solo incluye usuarios con pedidos.

$$
\Group{uId, \operatorname{SUM}(P.p\cdot Ped.c)}{uId}(P \NatJoin Ped)
$$

- **Pedidos por mes**: Agrupamos por mes (extrayendo el mes de la fecha de compra) y contamos cuántos pedidos hubo en cada mes.

$$
\Group{\operatorname{MES}(Ped.fc), \operatorname{COUNT}(pedId)}{\operatorname{MES}(Ped.fc)}(Ped)
$$

- **Usuario que más gasta cada mes**: Primero calculamos el gasto total de cada usuario por mes. Luego obtenemos el máximo gasto de cada mes. Finalmente, filtramos para quedarnos solo con los usuarios cuyo gasto coincide con el máximo de su mes.

$$
GPUM(uId, mes, totalGasto) \leftarrow \Group{uId, \operatorname{MES}(Ped.fc), \operatorname{SUM}(P.p\cdot Ped.c)}{uId, \operatorname{MES}(Ped.fc)}(U \NatJoin P \NatJoin Ped)
$$

$$
MGPM(mes, maxGasto) \leftarrow \Group{mes, \operatorname{MAX}(totalGasto)}{mes}(GPUM)
$$

$$
\Proj{U.n, GPUM.mes, GPUM.totalGasto}(\Sel{GPUM.totalGasto = MGPM.maxGasto}(GPUM \NatJoin MGPM \NatJoin U))
$$

- **Mes de máxima recaudación**: Primero calculamos la recaudación total de cada mes (sumando el importe de todos los pedidos). Luego obtenemos el mes con mayor recaudación.

$$
RPM(mes, recaudacion) \leftarrow \Group{\operatorname{MES}(Ped.fc), \operatorname{SUM}(P.p\cdot Ped.c)}{\operatorname{MES}(Ped.fc)}(P \NatJoin Ped)
$$

$$
\Proj{RPM.mes, RPM.recaudacion}(\Sel{RPM.recaudacion = \operatorname{MAX}(RPM.recaudacion)}(RPM))
$$


Enlaces:
- [GIST](https://gist.github.com/druizcortes/24cc0583792178fe778335eb95b5e3d9)
- [RELAX Calculator](https://dbis-uibk.github.io/relax/calc/gist/24cc0583792178fe778335eb95b5e3d9)
- Expresiones:

```text
 U = rho uId<-usuarioId, n<-nombre, prov<-provincia, fa<-fechaAlta (Usuarios)
P = rho pId<-productoId, d<-descripcion, pr<-precio, st<-stock (Productos)
Ped = rho pedId<-pedidoId, uId<-usuarioId, pId<-productoId, fc<-fechaCompra, c<-cantidad (Pedidos)
UPP = U join Ped join P

Q1_UPP = UPP
-- Q1_UPP

Q2_PedidosMalaga = sigma prov='Malaga' (UPP)
-- Q2_PedidosMalaga

Q3_StockBajo = pi d, st (sigma st < 100 (P))
-- Q3_StockBajo

Q4_NumPedidosUsuario = gamma uId, n ; count(pedId) -> total (U join Ped)
-- Q4_NumPedidosUsuario

Importes = pi uId, n, importe <- pr * c (UPP)
Q5_ImporteTotalUsuario = gamma uId, n ; sum(importe) -> totalGasto (Importes)
-- Q5_ImporteTotalUsuario

PedMes = pi pedId, mes <- month(fc) (Ped)
Q6_PedidosPorMes = gamma mes ; count(pedId) -> total (PedMes)
-- Q6_PedidosPorMes

ImportesMesUsuario = pi uId, n, mes <- month(fc), importe <- pr * c (UPP)
GPUM = gamma uId, n, mes ; sum(importe) -> totalGasto (ImportesMesUsuario)
MGPM = gamma mes ; max(totalGasto) -> maxGasto (GPUM)
Q7_MasGastaPorMes = pi n, mes, totalGasto (sigma totalGasto = maxGasto (GPUM join MGPM))
-- Q7_MasGastaPorMes

ImportesMes = pi mes <- month(fc), importe <- pr * c (UPP)
RPM = gamma mes ; sum(importe) -> recaudacion (ImportesMes)
MaxRecaudacion = gamma ; max(recaudacion) -> maxRec (RPM)
Q8_MesMaxRecaudacion = pi mes, recaudacion (sigma recaudacion = maxRec (RPM join MaxRecaudacion))
Q8_MesMaxRecaudacion

```

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Pedidos/sql/createDB.sql' label='Pedidos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Pedidos/sql/populateDB.sql' label='Pedidos/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Pedidos/sql/queries.sql' label='Pedidos/queries.sql' collapsed=true %}

## Procedimientos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Pedidos/sql/procedures.sql' label='Pedidos/procedures.sql' collapsed=true %}

## Tests

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Pedidos/sql/tests.sql' label='Pedidos/tests.sql' collapsed=true %}


> [Versión PDF disponible](./index.pdf)
