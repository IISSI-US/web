---
title: Espectáculos
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Requisitos

La transcripción que aparece a continuación corresponde a una entrevista realizada al gerente de un teatro para determinar los objetivos y requisitos de una aplicación web que gestione la programación anual de espectáculos y venta de entradas a dichos espectáculos.

## Entrevista

- Cuestión: Para empezar, hábleme de los espectáculos. Me interesa conocer la información que debe gestionarse por parte de la aplicación web.
  - Respuesta: De acuerdo, los espectáculos que se programan en nuestro teatro pueden ser de distinto tipo (p.e. “Concierto”, “Opera”, .. ). Cada espectáculo es de un tipo.

- Cuestión: ¿Qué información desea recoger de los espectáculos?
  - Respuesta: Básicamente, su denominación, tipo, duración y fecha y hora en las que se representan. Un espectáculo puede tener varias representaciones.

- Cuestión: ¿Puede haber más de una representación el mismo día?
  - Respuesta: Sí, hay días con más de una representación pero nunca del mismo espectáculo.

- Cuestión: ¿Algo más acerca de los espectáculos?
  - Respuesta: Se me olvidaba, también quiero guardar el precio. Cada tipo de espectáculo tiene un precio de la entrada.

- Cuestión: ¿El precio varía según tipo de espectáculo?
  - Respuesta: Sí, pero también depende de la zona del teatro donde esté situada la localidad.

- Cuestión: Acláreme esto, por favor.
  - Respuesta: El teatro está dividido en zonas. Las localidades más caras corresponden a la zona mejor situada, es decir la zona de “Patio”. Otras zonas son "1 de Balcón", "1 de Terraza" etc. Cada zona tiene distinto precio.

- Cuestión: En definitiva ¿el precio depende del tipo de espectáculo y zona del teatro?
  - Respuesta: Así es. También quiero conocer las localidades vendidas para cada representación.

- Cuestión: ¿Hablamos de las entradas?
  - Respuesta: Una entrada es una localidad para una representación. Dentro de cada zona las localidades se identifican por fila y butaca (p.e. “fila 2, butaca 3 de Patio”, “fila 2, butaca 3 de 1 de Balcón”, ...)

- Cuestión: ¿Quiere que se puedan adquirir las entradas únicamente a través de la web?
  - Respuesta: No, seguiremos vendiendo entradas en taquilla. Además algunas entadas se regalan como invitación. Necesito saber el medio o canal por el que se han adquirido las entradas ya sea web, taquilla o invitación.

- Cuestión: ¿Qué información quiere almacenar de las entradas?
  - Respuesta: La fecha y hora de compra, el canal por el que se ha adquirido, representación, fila y butaca que le corresponde y el precio de compra al que se ha adquirido ya que puede variar con el paso del tiempo.

- Cuestión: ¿Algo más?
  - Respuesta: Creo que en principio es todo. Como ya le comenté, queremos que tanto la planificación de espectáculos como la venta de entradas estén gestionados por la aplicación y se puedan consultar a través de Internet.

# Modelo Conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/espectaculos/espectaculos-dc.png' | relative_url }})

# Modelo Relacional

## Intensión

```mr-table
TiposEspectaculos = { tipoEspectaculoId, tipo }
	PK(tipoEspectaculoId)
Zonas = { zonaId, nombreZona }
	PK(zonaId)
Precios = { precioId, zonaId, tipoEspectaculoId, precio }
	PK(precioId)
	FK(zonaId) / Zonas
	FK(tipoEspectaculoId) / TiposEspectaculos
Localidades = { localidadId, zonaId, numFila, numButaca }
	PK(localidadId)
	FK(zonaId) / Zonas
	AK(zonaId, numFila, numButaca)
Espectaculos = { espectaculoId, tipoEspectaculoId, nombre, denominacion, duracion }
	PK(espectaculoId)
	FK(tipoEspectaculoId) / TiposEspectaculos
Representaciones = { representacionId, espectaculoId, fechaHoraInicio }
	PK(representacionId)
	FK(espectaculoId) / Espectaculos
	AK(espectaculoId, fechaHoraInicio)
Entradas = { entradaId, representacionId, localidadId, fHoraCompra, canal, pCompra }
	PK(entradaId)
	FK(representacionId) / Representaciones
	FK(localidadId) / Localidades
	AK(representacionId, localidadId)

TiposEspectaculos = {
	(te1, "Concierto"),
	(te2, "Danza"),
	(te3, "Teatro")
}

Zonas = {
	(z1, "Patio"),
	(z2, "Primera Balcón"),
	(z3, "Segunda Balcón"),
	(z4, "Primera Terraza"),
	(z5, "Segunda Terraza")
}

Precios = {
	(p1, z1, te1, 50),
	(p2, z2, te1, 100),
	(p3, z3, te2, 80),
	(p4, z4, te2, 60),
	(p5, z5, te2, 40),
	(p6, z3, te3, 120),
	(p7, z4, te3, 100),
	(p8, z5, te3, 80)
}

Localidades = {
	(l1, z1, 5, 12),
	(l2, z2, 1, 6),
	(l3, z3, 5, 12),
	(l4, z3, 6, 10),
	(l5, z3, 7, 8),
	(l6, z4, 1, 6),
	(l7, z4, 2, 4),
	(l8, z4, 3, 2),
	(l9, z5, 1, 6),
	(l10, z5, 2, 4),
	(l11, z5, 3, 2)
}

Espectaculos = {
	(e1, te1, "Concierto de ACDC", "Festival", 2.5),
	(e2, te2, "El lago de los cisnes", "Ballet", 2.0),
	(e3, te2, "El cascanueces", "Ballet", 2.5),
	(e4, te2, "La bella durmiente", "Ballet", 2.5),
	(e5, te3, "La casa de Bernarda Alba", "Drama", 2.0),
	(e6, te3, "La vida es sueño", "Drama", 2.5),
	(e7, te3, "La casa de los espíritus", "Drama", 2.5)
}

Representaciones = {
	(r1, e1, "2024-10-15 20:00"),
	(r2, e1, "2024-10-16 20:00"),
	(r3, e2, "2024-10-17 20:00"),
	(r4, e2, "2024-10-18 20:00"),
	(r5, e2, "2024-10-19 20:00"),
	(r6, e3, "2024-10-20 20:00"),
	(r7, e3, "2024-10-21 20:00"),
	(r8, e3, "2024-10-22 20:00"),
	(r9, e4, "2024-10-23 20:00"),
	(r10, e5, "2024-10-24 20:00"),
	(r11, e6, "2024-10-25 20:00"),
	(r12, e7, "2024-10-26 20:00")
}

Entradas = {
	(en1, r1, l1, "2024-10-10 18:00", "Web", 50),
	(en2, r2, l2, "2024-10-11 15:00", "Invitación", 0),
	(en3, r3, l1, "2024-10-10 18:00", "Web", 80),
	(en4, r3, l2, "2024-10-11 15:00", "Invitación", 0),
	(en5, r3, l3, "2024-10-12 12:00", "Taquilla", 80),
	(en6, r4, l2, "2024-10-10 18:00", "Web", 60),
	(en7, r4, l3, "2024-10-11 15:00", "Invitación", 0),
	(en8, r4, l4, "2024-10-12 12:00", "Taquilla", 60),
	(en9, r5, l5, "2024-10-10 18:00", "Web", 40),
	(en10, r5, l6, "2024-10-11 15:00", "Invitación", 0),
	(en11, r5, l7, "2024-10-12 12:00", "Taquilla", 40),
	(en12, r6, l8, "2024-10-10 18:00", "Web", 120),
	(en13, r6, l1, "2024-10-11 15:00", "Invitación", 0),
	(en14, r6, l2, "2024-10-12 12:00", "Taquilla", 120),
	(en15, r7, l3, "2024-10-10 18:00", "Web", 100),
	(en16, r7, l4, "2024-10-11 15:00", "Invitación", 0),
	(en17, r7, l5, "2024-10-12 12:00", "Taquilla", 100),
	(en18, r8, l4, "2024-10-10 18:00", "Web", 80),
	(en19, r8, l5, "2024-10-11 15:00", "Invitación", 0),
	(en20, r8, l6, "2024-10-12 12:00", "Taquilla", 80),
	(en21, r9, l3, "2024-10-17 18:00", "Web", 120),
	(en22, r9, l6, "2024-10-18 15:00", "Invitación", 0),
	(en23, r9, l9, "2024-10-19 12:00", "Taquilla", 80),
	(en24, r10, l3, "2024-10-18 18:00", "Web", 120),
	(en25, r10, l6, "2024-10-19 15:00", "Invitación", 0),
	(en26, r10, l9, "2024-10-20 12:00", "Taquilla", 80),
	(en27, r11, l3, "2024-10-19 18:00", "Web", 120),
	(en28, r11, l6, "2024-10-20 15:00", "Invitación", 0),
	(en29, r11, l9, "2024-10-21 12:00", "Taquilla", 80),
	(en30, r12, l3, "2024-10-20 18:00", "Web", 120),
	(en31, r12, l6, "2024-10-21 15:00", "Invitación", 0),
	(en32, r12, l9, "2024-10-22 12:00", "Taquilla", 80)
}
```

## Álgebra relacional

- Precios por zona y tipo:

$$
PZT \leftarrow Precios \NatJoin Zonas \NatJoin TiposEspectaculos
$$

```mr-table
PZT = { precioId, zonaId, tipoEspectaculoId, precio, nombreZona, tipo }

PZT = {
	(p1, z1, te1, 50, "Patio", "Concierto"),
	(p2, z2, te1, 100, "Primera Balcón", "Concierto"),
	(p3, z3, te2, 80, "Segunda Balcón", "Danza"),
	(p4, z4, te2, 60, "Primera Terraza", "Danza"),
	(p5, z5, te2, 40, "Segunda Terraza", "Danza"),
	(p6, z3, te3, 120, "Segunda Balcón", "Teatro"),
	(p7, z4, te3, 100, "Primera Terraza", "Teatro"),
	(p8, z5, te3, 80, "Segunda Terraza", "Teatro")
}
```

- Localidades por zona/tipo/representación:

$$
PZTRL \leftarrow PZT \NatJoin Localidades
$$

```mr-table
PZTRL = { precioId, zonaId, tipoEspectaculoId, precio, nombreZona, tipo, localidadId, numFila, numButaca }

PZTRL = {
	(p1, z1, te1, 50, "Patio", "Concierto", l1, 5, 12),
	(p2, z2, te1, 100, "Primera Balcón", "Concierto", l2, 1, 6),
	(p3, z3, te2, 80, "Segunda Balcón", "Danza", l3, 5, 12),
	(p3, z3, te2, 80, "Segunda Balcón", "Danza", l4, 6, 10),
	(p3, z3, te2, 80, "Segunda Balcón", "Danza", l5, 7, 8),
	(p6, z3, te3, 120, "Segunda Balcón", "Teatro", l3, 5, 12),
	(p6, z3, te3, 120, "Segunda Balcón", "Teatro", l4, 6, 10),
	(p6, z3, te3, 120, "Segunda Balcón", "Teatro", l5, 7, 8),
	(p4, z4, te2, 60, "Primera Terraza", "Danza", l6, 1, 6),
	(p4, z4, te2, 60, "Primera Terraza", "Danza", l7, 2, 4),
	(p4, z4, te2, 60, "Primera Terraza", "Danza", l8, 3, 2),
	(p7, z4, te3, 100, "Primera Terraza", "Teatro", l6, 1, 6),
	(p7, z4, te3, 100, "Primera Terraza", "Teatro", l7, 2, 4),
	(p7, z4, te3, 100, "Primera Terraza", "Teatro", l8, 3, 2),
	(p5, z5, te2, 40, "Segunda Terraza", "Danza", l9, 1, 6),
	(p5, z5, te2, 40, "Segunda Terraza", "Danza", l10, 2, 4),
	(p5, z5, te2, 40, "Segunda Terraza", "Danza", l11, 3, 2),
	(p8, z5, te3, 80, "Segunda Terraza", "Teatro", l9, 1, 6),
	(p8, z5, te3, 80, "Segunda Terraza", "Teatro", l10, 2, 4),
	(p8, z5, te3, 80, "Segunda Terraza", "Teatro", l11, 3, 2)
}
```

- Entradas por representación:

$$
numER \leftarrow \Group{representacionId,\rho_{total}(\operatorname{COUNT}(*))}{representacionId}(Entradas \NatJoin Representaciones)
$$

```mr-table
numER = { representacionId, total }

numER = {
	(r1, 1),
	(r2, 1),
	(r3, 3),
	(r4, 3),
	(r5, 3),
	(r6, 3),
	(r7, 3),
	(r8, 3),
	(r9, 3),
	(r10, 3),
	(r11, 3),
	(r12, 3)
}
```

- Representaciones con espectáculos:

$$
RE \leftarrow Representaciones \NatJoin Espectaculos
$$

```mr-table
RE = { representacionId, espectaculoId, fechaHoraInicio, tipoEspectaculoId, nombre, denominacion, duracion }

RE = {
	(r1, e1, "2024-10-15 20:00", te1, "Concierto de ACDC", "Festival", 2.5),
	(r2, e1, "2024-10-16 20:00", te1, "Concierto de ACDC", "Festival", 2.5),
	(r3, e2, "2024-10-17 20:00", te2, "El lago de los cisnes", "Ballet", 2.0),
	(r4, e2, "2024-10-18 20:00", te2, "El lago de los cisnes", "Ballet", 2.0),
	(r5, e2, "2024-10-19 20:00", te2, "El lago de los cisnes", "Ballet", 2.0),
	(r6, e3, "2024-10-20 20:00", te2, "El cascanueces", "Ballet", 2.5),
	(r7, e3, "2024-10-21 20:00", te2, "El cascanueces", "Ballet", 2.5),
	(r8, e3, "2024-10-22 20:00", te2, "El cascanueces", "Ballet", 2.5),
	(r9, e4, "2024-10-23 20:00", te2, "La bella durmiente", "Ballet", 2.5),
	(r10, e5, "2024-10-24 20:00", te3, "La casa de Bernarda Alba", "Drama", 2.0),
	(r11, e6, "2024-10-25 20:00", te3, "La vida es sueño", "Drama", 2.5),
	(r12, e7, "2024-10-26 20:00", te3, "La casa de los espíritus", "Drama", 2.5)
}
```

- Número de representaciones por espectáculo:

$$
numRE \leftarrow \Group{espectaculoId,\rho_{total}(\operatorname{COUNT}(*))}{espectaculoId}(Representaciones \NatJoin Espectaculos)
$$

```mr-table
numRE = { espectaculoId, total }

numRE = {
	(e1, 2),
	(e2, 3),
	(e3, 3),
	(e4, 1),
	(e5, 1),
	(e6, 1),
	(e7, 1)
}
```

- Recaudación por representación:

$$
Recaudaciones \leftarrow \Group{representacionId,\rho_{recaudacion}(\operatorname{SUM}(pCompra))}{representacionId}(Entradas)
$$

```mr-table
Recaudaciones = { representacionId, recaudacion }

Recaudaciones = {
	(r1, 50),
	(r2, 0),
	(r3, 160),
	(r4, 120),
	(r5, 80),
	(r6, 240),
	(r7, 200),
	(r8, 160),
	(r9, 200),
	(r10, 200),
	(r11, 200),
	(r12, 200)
}
```

- Localidades vendidas en r1:

$$
LocR1 \leftarrow \Group{representacionId,\rho_{total}(\operatorname{COUNT}(localidadId))}{representacionId}(\Sel{representacionId=r1}(Entradas))
$$

```mr-table
LocR1 = { representacionId, total }

LocR1 = {
	(r1, 1)
}
```

- Entradas por invitación:

$$
EntradasInvitacion \leftarrow \Sel{canal=\text{Invitación}}(RE \NatJoin Entradas)
$$

```mr-table
EntradasInvitacion = { representacionId, espectaculoId, fechaHoraInicio, tipoEspectaculoId, nombre, denominacion, duracion, entradaId, localidadId, fHoraCompra, canal, pCompra }

EntradasInvitacion = {
	(r2, e1, "2024-10-16 20:00", te1, "Concierto de ACDC", "Festival", 2.5, en2, l2, "2024-10-11 15:00", "Invitación", 0),
	(r3, e2, "2024-10-17 20:00", te2, "El lago de los cisnes", "Ballet", 2.0, en4, l2, "2024-10-11 15:00", "Invitación", 0),
	(r4, e2, "2024-10-18 20:00", te2, "El lago de los cisnes", "Ballet", 2.0, en7, l3, "2024-10-11 15:00", "Invitación", 0),
	(r5, e2, "2024-10-19 20:00", te2, "El lago de los cisnes", "Ballet", 2.0, en10, l6, "2024-10-11 15:00", "Invitación", 0),
	(r6, e3, "2024-10-20 20:00", te2, "El cascanueces", "Ballet", 2.5, en13, l1, "2024-10-11 15:00", "Invitación", 0),
	(r7, e3, "2024-10-21 20:00", te2, "El cascanueces", "Ballet", 2.5, en16, l4, "2024-10-11 15:00", "Invitación", 0),
	(r8, e3, "2024-10-22 20:00", te2, "El cascanueces", "Ballet", 2.5, en19, l5, "2024-10-11 15:00", "Invitación", 0),
	(r9, e4, "2024-10-23 20:00", te2, "La bella durmiente", "Ballet", 2.5, en22, l6, "2024-10-18 15:00", "Invitación", 0),
	(r10, e5, "2024-10-24 20:00", te3, "La casa de Bernarda Alba", "Drama", 2.0, en25, l6, "2024-10-19 15:00", "Invitación", 0),
	(r11, e6, "2024-10-25 20:00", te3, "La vida es sueño", "Drama", 2.5, en28, l6, "2024-10-20 15:00", "Invitación", 0),
	(r12, e7, "2024-10-26 20:00", te3, "La casa de los espíritus", "Drama", 2.5, en31, l6, "2024-10-21 15:00", "Invitación", 0)
}
```

# Modelo Tecnológico

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

## Script SQL para crear la base de datos

{% include sql-embed.html src='/_code/espectaculos/createDB.sql' label='espectaculos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

{% include sql-embed.html src='/_code/espectaculos/populateDB.sql' label='espectaculos/populateDB.sql' collapsed=true %}

## Consultas

Para crear las consultas SQL de las expresiones en Álgebra relacional se puede usar el siguiente script:

{% include sql-embed.html src='/_code/espectaculos/queries.sql' label='espectaculos/queries.sql' collapsed=true %}

## SQL avanzado

Para implementar las restricciones que no pueden expresarse de forma declarativa usamos triggers. El siguiente script comprueba RN-01 y la condición temporal de RN-02; la otra condición de RN-02, relativa al precio de las invitaciones, se declara en `createDB.sql`:

{% include sql-embed.html src='/_code/espectaculos/triggers.sql' label='espectaculos/triggers.sql' collapsed=true %}

## Pruebas SQL

{% include sql-embed.html src='/_code/espectaculos/tests.sql' label='espectaculos/tests.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
