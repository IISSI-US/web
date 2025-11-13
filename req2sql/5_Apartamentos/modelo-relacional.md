---
layout: default
published: false
title: Modelo Relacional
parent: Apartamentos
nav_order: 3
---

# Modelo relacional

## Intensión

Opción A: una relación por subclase (partición completa y disjunta):

```
Usuarios(usuarioId, dni, nombre, apellidos, correo, contrasena, direccion, telefono)
	PK(usuarioId)
	AK(correo)
	AK(dni)
Huespedes(usuarioId)
	PK(usuarioId)
	FK(usuarioId) / Usuarios
Propietarios(usuarioId, fCompra)
	PK(usuarioId)
	FK(usuarioId) / Usuarios
```

Opción B: una sola relación con booleanos (partición completa y solapada):

```
Usuarios(usuarioId, dni, nombre, apellidos, correo, contrasena, direccion, telefono, fCompra, esPropietario, esHuesped)
	PK(usuarioId)
	AK(correo)
	AK(dni)
```

Estructura común del dominio:

```
ZonasTuristicas(zonaId, zona)
	PK(zonaId)
Alojamientos(alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima)
	PK(alojamientoId)
	FK(propietarioId) / Propietarios
	FK(zonaId) / ZonasTuristicas
Reservas(reservaId, huespedId, alojamientoId, checkIn, checkOut, comentario, valoracion)
	PK(reservaId)
	FK(huespedId) / Huespedes
	FK(alojamientoId) / Alojamientos
Fotos(fotoId, alojamientoId, titulo, fotoURL)
	PK(fotoId)
	FK(alojamientoId) / Alojamientos
Servicios(servicioId, alojamientoId, tipoServicio, disponible)
	PK(servicioId)
	FK(alojamientoId) / Alojamientos
```

## Extensión (fragmento)

```
ZonasTuristicas = { (z1, "Costa del Sol") }
Alojamientos = { (a1, p1, z1, "Calle Mayor 10", 3, 2, 6) }
Reservas = { (r1, h1, a1, "2024-10-01", "2024-10-10", "Excelente estancia", 1) }
Servicios = { (s1, a1, "Wifi", true), (s2, a1, "Piscina", true) }
Fotos = { (f1, a1, "Salón", "Siempre-viva-salon.jpg"), (f2, a1, "Cocina", "Siempre-viva-cocina.jpg") }
```

## Álgebra relacional

- Alojamientos con sus propietarios y zonas:

$$
APZ \leftarrow Alojamientos \NatJoin Propietarios \NatJoin ZonasTuristicas
$$

- Alojamientos con fotos:

$$
AF \leftarrow Alojamientos \NatJoin Fotos
$$

- Alojamientos con servicios:

$$
AS \leftarrow Alojamientos \NatJoin Servicios
$$

- Alojamientos con reservas:

$$
AR \leftarrow Alojamientos \NatJoin Reservas
$$

- Alojamientos con propietarios, zona, fotos, servicios y reservas:

$$
APZFRS \leftarrow APZ \NatJoin Fotos \NatJoin Servicios \NatJoin Reservas
$$

- Alojamientos con piscina:

$$
APiscina \leftarrow Alojamientos \NatJoin (\Sel{tipoServicio=\text{'Piscina'} \wedge disponible=\text{true}}(Servicios))
$$

- Reservas en la Costa del Sol:

$$
ReservasCS \leftarrow \Proj{alojamientoId}(AR \NatJoin \Sel{zona=\text{'Costa del Sol'}}(ZonasTuristicas))
$$

- Dormitorios y baños de alojamientos con Wifi:

$$
\Proj{numDormitorios,numBanos}(\Sel{tipoServicio=\text{Wifi} \wedge disponible=\text{true}}(AS))
$$

- Propietarios en una zona concreta:

$$
\Proj{nombre}(\Sel{zona=\text{Playa}}(APZ))
$$

- Valoración media por alojamiento:

$$
\Group{\operatorname{AVG}(valoracion)}{alojamientoId}(AR)
$$

- Número de servicios por alojamiento:

$$
\Group{\operatorname{COUNT}(*)}{alojamientoId}(AS)
$$

- Número de fotos por alojamiento:

$$
\Group{\operatorname{COUNT}(*)}{alojamientoId}(AF)
$$

- Número de reservas por huésped:

$$
\Group{\operatorname{COUNT}(*)}{huespedId}(Reservas)
$$
