---
title: Apartamentos
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Apartamentos


## Requisitos


# Catálogo de Requisitos

La transcripción que aparece a continuación corresponde a una entrevista con una emprendedora que quiere crear una empresa de gestión de alquileres de apartamentos turísticos.

## Entrevista

- Pregunta (P): Bien, ¿qué necesita que haga el portal web a desarrollar?
  - Respuesta (R): Bueno, por un lado permitir que los usuarios con alojamientos disponibles los puedan publicar y, por otro lado, que los usuarios que busquen alquilar un alojamiento los puedan buscar por una determinada zona (Costa de la Luz, Costa del Sol, etc.), ver las fotos y solicitar una reserva.

- P: Muy bien, empecemos por los apartamentos.
  - R: Hablemos mejor de alojamientos, no todos son apartamentos, también hay casas rurales y otros tipos distintos.

- P: ¿Pero se tratan todos de la misma forma?
  - R: Sí, para nosotros son iguales.

- P: Bien, pues dígame que información quiere guardar de los alojamientos.
  - R: Pues la dirección, sus características y muchas fotos.

- P: ¿Cuáles son las características?
  - R: Pues el número de dormitorios, el número de baños, la ocupación máxima y si tiene aire acondicionado, wifi, piscina y garaje. Y quien es el propietario, claro. Ah, y la zona turística en la que se encuentra, como le dije antes.

- P: Muy bien, y ¿qué información necesita de los usuarios?
  - R: Bueno, de los usuarios necesito el DNI, nombre y apellidos, correo electrónico, una contraseña para acceder, una dirección y un teléfono de contacto.

- P: ¿Considera usuarios tanto a los propietarios como a los que solicitan reservas?
  - R: Sí, porque los propietarios también pueden reservar. Simplemente, si un usuario es propietario, al entrar al portal podrá gestionar sus alojamientos y hacer reservas. Si no tiene alojamientos, sólo podrá hacer reservas.

- P: Muy bien, hábleme de las reservas.
  - R: Bueno, una reserva la hace un usuario sobre un alojamiento, con una fecha de check-in y una fecha de check-out.

- P: ¿Check-in, check-out?
  - R: Sí, entrada y salida, es como se suele hablar en este sector, ¿sabe?

- P: OK, fecha de check-in y fecha de check-out.
  - R: Eso es, tenga en cuenta que el mismo día de check-out se puede hacer un check-in de otra reserva, pero no puede haber más solape de reservas que ese.

- P: ¿Me lo puede explicar?
  - R: Sí claro, dos reservas de un mismo alojamiento no se pueden solapar salvo en el día de check-out de una y el de check-in de la siguiente.

- P: Lo entiendo, debemos controlar el solape de reservas. ¿Algo más sobre reservas?
  - R: Bueno, si la reserva se confirma por parte del propietario y el usuario, me gustaría que el usuario pudiera añadir comentarios con una valoración.

- P: ¿Qué tipo de valoración?
  - R: Por el momento me vale una de esas de estrellitas, de una a cinco estrellas, ¿sabe de qué le hablo?

- P: Sí, de acuerdo, una valoración de 1 a 5 que se visualiza como estrellas.
  - R: Eso es.

- P: ¿Más funcionalidades que necesite del portal?
  - R: Quedan muchos más temas por tratar, como la disponibilidad, la gestión de los pagos, etc., pero para una primera versión creo que puede ser suficiente.

# Modelo conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Apartamentos/apartamentos-dc.png' | relative_url }})

# Modelo relacional

## Opción A: una relación por subclase (partición completa y disjunta):

```mr-table
Usuarios = { usuarioId, dni, nombre, apellidos, correo, contrasena, direccion, telefono }
	PK(usuarioId)
	AK(correo)
	AK(dni)
Usuarios = {
	(u1, "12345678A", "Ana", "García", "ana@example.com", "pwd1", "Calle Sol 1", "600111222"),
	(u2, "87654321B", "Luis", "Pérez", "luis@example.com", "pwd2", "Calle Luna 2", "600333444")
}

Huespedes = { huespedId }
	PK(huespedId)
	FK(huespedId) / Usuarios
Huespedes = {
	(u2)
}

Propietarios = { propietarioId, fCompra }
	PK(propietarioId)
	FK(propietarioId) / Usuarios
Propietarios = {
	(u1, "2020-05-10")
}

ZonasTuristicas = { zonaId, zona }
	PK(zonaId)
ZonasTuristicas = {
	(z1, "Costa del Sol")
}

Alojamientos = { alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima }
	PK(alojamientoId)
	FK(propietarioId) / Propietarios
	FK(zonaId) / ZonasTuristicas
Alojamientos = {
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6)
}

Reservas = { reservaId, huespedId, alojamientoId, checkIn, checkOut, comentario, valoracion }
	PK(reservaId)
	FK(huespedId) / Huespedes
	FK(alojamientoId) / Alojamientos
Reservas = {
	(r1, u2, a1, "2024-10-01", "2024-10-10", "Excelente estancia", 1)
}

Fotos = { fotoId, alojamientoId, titulo, fotoURL }
	PK(fotoId)
	FK(alojamientoId) / Alojamientos
Fotos = {
	(f1, a1, "Salón", "Siempre-viva-salon.jpg"),
	(f2, a1, "Cocina", "Siempre-viva-cocina.jpg")
}

Servicios = { servicioId, alojamientoId, tipoServicio, disponible }
	PK(servicioId)
	FK(alojamientoId) / Alojamientos
Servicios = {
	(s1, a1, "Wifi", true),
	(s2, a1, "Piscina", true)
}
```

## Álgebra relacional

- Alojamientos con sus propietarios y zonas:

$$
APZ \leftarrow Alojamientos \NatJoin Propietarios \NatJoin ZonasTuristicas
$$

```mr-table
APZ = { alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima, fCompra, zona }

APZ = {
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, "2020-05-10", "Costa del Sol")
}
```

- Alojamientos con fotos:

$$
AF \leftarrow Alojamientos \NatJoin Fotos
$$

```mr-table
AF = { alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima, fotoId, titulo, fotoURL }

AF = {
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, f1, "Salón", "Siempre-viva-salon.jpg"),
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, f2, "Cocina", "Siempre-viva-cocina.jpg")
}
```

- Alojamientos con servicios:

$$
AS \leftarrow Alojamientos \NatJoin Servicios
$$

```mr-table
AS = { alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima, servicioId, tipoServicio, disponible }

AS = {
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, s1, "Wifi", true),
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, s2, "Piscina", true)
}
```

- Alojamientos con reservas:

$$
AR \leftarrow Alojamientos \NatJoin Reservas
$$

```mr-table
AR = { alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima, reservaId, huespedId, checkIn, checkOut, comentario, valoracion }

AR = {
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, r1, u2, "2024-10-01", "2024-10-10", "Excelente estancia", 1)
}
```

- Alojamientos con propietarios, zona, fotos, servicios y reservas:

$$
APZFRS \leftarrow APZ \NatJoin Fotos \NatJoin Servicios \NatJoin Reservas
$$

```mr-table
APZFRS = { alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima, fCompra, zona, fotoId, titulo, fotoURL, servicioId, tipoServicio, disponible, reservaId, huespedId, checkIn, checkOut, comentario, valoracion }

APZFRS = {
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, "2020-05-10", "Costa del Sol", f1, "Salón", "Siempre-viva-salon.jpg", s1, "Wifi", true, r1, u2, "2024-10-01", "2024-10-10", "Excelente estancia", 1),
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, "2020-05-10", "Costa del Sol", f1, "Salón", "Siempre-viva-salon.jpg", s2, "Piscina", true, r1, u2, "2024-10-01", "2024-10-10", "Excelente estancia", 1),
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, "2020-05-10", "Costa del Sol", f2, "Cocina", "Siempre-viva-cocina.jpg", s1, "Wifi", true, r1, u2, "2024-10-01", "2024-10-10", "Excelente estancia", 1),
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, "2020-05-10", "Costa del Sol", f2, "Cocina", "Siempre-viva-cocina.jpg", s2, "Piscina", true, r1, u2, "2024-10-01", "2024-10-10", "Excelente estancia", 1)
}
```

- Alojamientos con piscina:

$$
APiscina \leftarrow Alojamientos \NatJoin (\Sel{tipoServicio=\text{'Piscina'} \wedge disponible=\text{true}}(Servicios))
$$

```mr-table
APiscina = { alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBanos, ocupacionMaxima, servicioId, tipoServicio, disponible }

APiscina = {
	(a1, u1, z1, "Calle Mayor 10", 3, 2, 6, s2, "Piscina", true)
}
```

- Reservas en la Costa del Sol:

$$
ReservasCS \leftarrow \Proj{alojamientoId}(AR \NatJoin \Sel{zona=\text{'Costa del Sol'}}(ZonasTuristicas))
$$

```mr-table
ReservasCS = { alojamientoId }

ReservasCS = {
	(a1)
}
```

- Dormitorios y baños de alojamientos con Wifi:

$$
\Proj{numDormitorios,numBanos}(\Sel{tipoServicio=\text{Wifi} \wedge disponible=\text{true}}(AS))
$$

```mr-table
AlojamientosWifi = { numDormitorios, numBanos }

AlojamientosWifi = {
	(3, 2)
}
```

- Propietarios en una zona concreta:

$$
\Proj{nombre}(\Sel{zona=\text{Playa}}(APZ))
$$

```mr-table
PropietariosPlaya = { nombre }

PropietariosPlaya = {}
```

- Valoración media por alojamiento:

$$
\Group{alojamientoId,\rho_{media}(\operatorname{AVG}(valoracion))}{alojamientoId}(AR)
$$

```mr-table
ValoracionMediaAlojamiento = { alojamientoId, media }

ValoracionMediaAlojamiento = {
	(a1, 1.00)
}
```

- Número de servicios por alojamiento:

$$
\Group{alojamientoId,\rho_{total}(\operatorname{COUNT}(*))}{alojamientoId}(AS)
$$

```mr-table
NumServiciosAlojamiento = { alojamientoId, total }

NumServiciosAlojamiento = {
	(a1, 2)
}
```

- Número de fotos por alojamiento:

$$
\Group{alojamientoId,\rho_{total}(\operatorname{COUNT}(*))}{alojamientoId}(AF)
$$

```mr-table
NumFotosAlojamiento = { alojamientoId, total }

NumFotosAlojamiento = {
	(a1, 2)
}
```

- Número de reservas por huésped:

$$
\Group{huespedId,\rho_{total}(\operatorname{COUNT}(*))}{huespedId}(Reservas)
$$

```mr-table
NumReservasHuesped = { huespedId, total }

NumReservasHuesped = {
	(u2, 1)
}
```

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Apartamentos/sql/createDB.sql' label='Apartamentos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Apartamentos/sql/populateDB.sql' label='Apartamentos/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Apartamentos/sql/queries.sql' label='Apartamentos/queries.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
