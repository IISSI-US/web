---
title: Animales
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Animales


## Requisitos


# Catálogo de Requisitos 

## Objetivos

### Obj-1: Objetivo 1
- Responsable: Responsable de CAA
- Descripción: Llevar a cabo el ingreso de un animal, abandonado en la vía pública o entregado por una persona, en cuyo caso habría que identificarla, clasificándolo por razas y especies
- Para: Mantener los animales custodiados y ofrecerlos en adopción a personas interesadas

### Obj-2: Objetivo 2
- Responsable: Responsable de CAA
- Descripción: Gestionar consultas de animales disponibles y adjudicar adopciones
- Para: Adjudicar cuanto antes los animales existentes y disminuir costes de mantenimiento del CAD

## Requisitos de información (RI)

### RI-1: Animales
- Como: Operario de Recogida de Animales
- Quiero: Conocer el nombre de cada especie y nombre de cada raza dentro de una especie. Un animal ingresado puede tener un nombre y, opcionalmente, un microchip. Siempre se especificará la fecha y hora del ingreso y una descripción adicional del animal. Si lo ha entregado una persona se la identificará (especificando nombre, dirección y email); en caso contrario se especificará como abandono del animal en la vía pública, describiendo, obligatoriamente, el lugar y hora del hallazgo
- Para: Ingresar cada mascota con la clasificación adecuada y/o conocer datos sobre el hallazgo

### RI-2: Adopciones
- Como: Operario de Adopciones
- Quiero: Registrar adopciones especificando persona que realiza la adopción de un animal disponible y fecha y hora en que se produce
- Para: Dejar constancia de las adopciones realizadas por el CAD

## Reglas de negocio (RN)

### RN-1: Límite de adopciones
- Como: Responsable del CAA
- Quiero: Que una persona no pueda adoptar más de dos animales abandonados en un mes
- Para: Poder evitar que se concentren adopciones en personas

### RN-2: Datos obligatorios según tipo de ingreso
- Como: Responsable de la Oficina
- Quiero: Si un animal es hallado “abandonado” en la vía pública, entonces es obligatorio especificar el “lugar, fecha y hora de encuentro”, en caso contrario se trata de una “entrega” y hay que identificar la persona que la realiza (nombre, dirección y email)
- Para: Facilitar las búsquedas de sus dueños

# Modelo conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Animales/animales-dc.png' | relative_url }})

# Modelo relacional

```mr-table
Especies = { especieId, especie }
	PK(especieId)
	AK(especie)
Razas = { razaId, especieId, raza }
	PK(razaId)
	FK(especieId) / Especies
	AK(especieId, raza)
Animales = { animalId, razaId, chip, nombre, descripcion }
	PK(animalId)
	FK(razaId) / Razas
	AK(chip)
Personas = { personaId, nombre, direccion, email }
	PK(personaId)
	AK(email)
Ingresos = { ingresoId, personaId, animalId, fechaHoraEntrega }
	PK(ingresoId)
	FK(personaId) / Personas
	FK(animalId) / Animales
	AK(ingresoId, animalId)
Entregas = { ingresoId }
	PK(ingresoId)
	FK(ingresoId) / Ingresos
Abandonos = { ingresoId, fechaHoraAbandono, lugar }
	PK(ingresoId)
	FK(ingresoId) / Ingresos
Adopciones = { adopcionId, personaId, animalId, fechaHoraAdopcion }
	PK(adopcionId)
	FK(personaId) / Personas
	FK(animalId) / Animales
	-- Una persona no puede adoptar más de dos animales abandonados en un mes.

Especies = {
	(e1, "Canino"),
	(e2, "Felino")
}

Razas = {
	(r1, e1, "Labrador"),
	(r2, e1, "Pastor Alemán"),
	(r3, e2, "Siamesa")
}

Animales = {
	(a1, r1, "12345", "Max", "Perro marrón"),
	(a2, r1, "67890", "Rocky", "Perro negro"),
	(a3, r3, "54321", "Luna", "Gata gris")
}

Personas = {
	(p1, "Ana García", "Calle Sol 1", "ana@example.com"),
	(p2, "Luis Pérez", "Calle Luna 2", "luis@example.com"),
	(p3, "Marta López", "Calle Mar 3", "marta@example.com")
}

Ingresos = {
	(i1, p1, a1, "2024-09-15 10:00"),
	(i2, p3, a2, "2024-10-01 09:30"),
	(i3, p2, a3, "2024-10-05 18:15")
}

Entregas = {
	(i1),
	(i3)
}

Abandonos = {
	(i2, "2024-10-01 08:45", "Parque de María Luisa")
}

Adopciones = {
	(ad1, p2, a1, "2024-10-20 12:00"),
	(ad2, p3, a2, "2024-10-22 17:30"),
	(ad3, p1, a3, "2024-11-03 11:00")
}
```

## Álgebra relacional

- Renombrado:

$$
P \leftarrow \Ren{P(pid,pn,dir,email)}(Personas)
$$

$$
A \leftarrow \Ren{A(aid,rid,chip,an,desc)}(Animales)
$$

$$
Ad \leftarrow \Ren{Ad(adid,pid,aid,fha)}(Adopciones)
$$

$$
I \leftarrow \Ren{I(iid,pid,aid,fhe)}(Ingresos)
$$

- Personas que adoptan animales:

$$
PerAdoAni \leftarrow P \NatJoin Ad \NatJoin A
$$

```mr-table
PerAdoAni = { pid, pn, dir, email, adid, aid, fha, rid, chip, an, desc }

PerAdoAni = {
	(p2, "Luis Pérez", "Calle Luna 2", "luis@example.com", ad1, a1, "2024-10-20 12:00", r1, "12345", "Max", "Perro marrón"),
	(p3, "Marta López", "Calle Mar 3", "marta@example.com", ad2, a2, "2024-10-22 17:30", r1, "67890", "Rocky", "Perro negro"),
	(p1, "Ana García", "Calle Sol 1", "ana@example.com", ad3, a3, "2024-11-03 11:00", r3, "54321", "Luna", "Gata gris")
}
```

- Personas que entregan animales:

$$
PerEntAni \leftarrow P \NatJoin I \NatJoin A
$$

```mr-table
PerEntAni = { pid, pn, dir, email, iid, aid, fhe, rid, chip, an, desc }

PerEntAni = {
	(p1, "Ana García", "Calle Sol 1", "ana@example.com", i1, a1, "2024-09-15 10:00", r1, "12345", "Max", "Perro marrón"),
	(p3, "Marta López", "Calle Mar 3", "marta@example.com", i2, a2, "2024-10-01 09:30", r1, "67890", "Rocky", "Perro negro"),
	(p2, "Luis Pérez", "Calle Luna 2", "luis@example.com", i3, a3, "2024-10-05 18:15", r3, "54321", "Luna", "Gata gris")
}
```

- Personas que entregan animales abandonados:

$$
PerEntAniAba \leftarrow P \NatJoin I \NatJoin \Ren{Ab(iid,fhab,lugar)}(Abandonos) \NatJoin A
$$

```mr-table
PerEntAniAba = { pid, pn, dir, email, iid, aid, fhe, fhab, lugar, rid, chip, an, desc }

PerEntAniAba = {
	(p3, "Marta López", "Calle Mar 3", "marta@example.com", i2, a2, "2024-10-01 09:30", "2024-10-01 08:45", "Parque de María Luisa", r1, "67890", "Rocky", "Perro negro")
}
```

- Adopciones en octubre:

$$
\Sel{Mes(fha)=\text{Octubre}}(PerAdoAni)
$$

```mr-table
AdopcionesOctubre = { pid, pn, dir, email, adid, aid, fha, rid, chip, an, desc }

AdopcionesOctubre = {
	(p2, "Luis Pérez", "Calle Luna 2", "luis@example.com", ad1, a1, "2024-10-20 12:00", r1, "12345", "Max", "Perro marrón"),
	(p3, "Marta López", "Calle Mar 3", "marta@example.com", ad2, a2, "2024-10-22 17:30", r1, "67890", "Rocky", "Perro negro")
}
```

- Adopciones por especie:

$$
\Group{especieId,especie,\rho_{total}(\operatorname{COUNT}(*))}{especieId,especie}(PerAdoAni \NatJoin Razas \NatJoin Especies)
$$

```mr-table
AdopcionesPorEspecie = { especieId, especie, total }

AdopcionesPorEspecie = {
	(e1, "Canino", 2),
	(e2, "Felino", 1)
}
```

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Animales/sql/createDB.sql' label='Animales/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Animales/sql/populateDB.sql' label='Animales/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Animales/sql/queries.sql' label='Animales/queries.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
