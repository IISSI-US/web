---
title: Espectáculos
layout: single
sidebar:
  nav: req2sql
toc: true
toc_sticky: true
pdf_version: true
---
> [Versión PDF disponible](./index.pdf)


# Espectáculos


## Requisitos


# Catálogo de Requisitos 

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

## Modelo Conceptual


# Modelo conceptual

## Diagrama de clases

- Estructura por composición: TipoEspectáculo contiene Espectáculo; Espectáculo compone sus Representación; Zona compone sus Localidad.
- Precios: relación M:N entre Zona y TipoEspectáculo materializada por la clase de asociación Precio (importe vigente).
- Entradas y ocupación: relación M:N entre Localidad y Representación materializada por la clase de asociación Entrada (fechaHoraCompra, canal, precioCompra).
- Enumeraciones: TipoCanal {WEB, TAQUILLA, INVITACIÓN} y TipoZona {Patio, 1ª/2ª de Balcón, 1ª/2ª de Terraza} restringen valores.

![Diagrama de clases]({{ '/assets/images/req2sql/Espectaculos/espectaculos-dc.png' | relative_url }})

## Diagrama de objetos

- acdc:Espectáculo pertenece a concierto:TipoEspectáculo y tiene dos representaciones (r1, r2) en días consecutivos, cumpliendo la RN‑1.
- Zonas y localidades: patio y 1ª de balcón contienen las localidades l1 y l2, respectivamente.
- Precios por zona y tipo: cincuenta=50€ para (Patio, Concierto) y cien=100€ para (1ª Balcón, Concierto).
- Entradas vendidas: e1 (WEB) ocupa l1 en r1 por 50€; e2 (INVITACIÓN) ocupa l2 en r2 por 0€; ambas materializan la ocupación (Localidad, Representación).

![Diagrama de objetos]({{ '/assets/images/req2sql/Espectaculos/espectaculos-do.png' | relative_url }})

## Modelo Relacional


# Modelo relacional

## Intensión

```
TiposEspectaculos(tipoEspectaculoId, tipo)
	PK(tipoEspectaculoId)
Zonas(zonaId, nombreZona)
	PK(zonaId)
Precios(precioId, zonaId, tipoEspectaculoId, precio)
	PK(precioId)
	FK(zonaId) / Zonas
	FK(tipoEspectaculoId) / TiposEspectaculos
Localidades(localidadId, zonaId, numFila, numButaca)
	PK(localidadId)
	FK(zonaId) / Zonas
	AK(zonaId, numFila, numButaca)
Espectaculos(espectaculoId, tipoEspectaculoId, nombre, denominacion, duracion)
	PK(espectaculoId)
	FK(tipoEspectaculoId) / TiposEspectaculos
Representaciones(representacionId, espectaculoId, fechaHoraInicio)
	PK(representacionId)
	FK(espectaculoId) / Espectaculos
	AK(espectaculoId, fechaHoraInicio)
Entradas(entradaId, representacionId, localidadId, fHoraCompra, canal, pCompra)
	PK(entradaId)
	FK(representacionId) / Representaciones
	FK(localidadId) / Localidades
	AK(representacionId, localidadId)
```

## Extensión (fragmento)

```
TiposEspectaculos = { (te1, "Concierto") }
Zonas = { (z1, "Patio"), (z2, "Primera Balcón") }
Precios = { (p1, z1, te1, 50), (p2, z2, te1, 100) }
Localidades = { (l1, z1, 5, 12), (l2, z2, 1, 6) }
Espectaculos = { (e1, te1, "Concierto de ACDC", "Festival", 2.5) }
Representaciones = { (r1, e1, "2024-10-15 20:00"), (r2, e1, "2024-10-16 20:00") }
Entradas = { (en1, r1, l1, "2024-10-10 18:00", "Web", 50), (en2, r2, l2, "2024-10-11 15:00", "Invitación", 0) }
```

## Álgebra relacional

- Precios por zona y tipo:

$$
PZT \leftarrow Precios \NatJoin Zonas \NatJoin TiposEspectaculos
$$

- Localidades por zona/tipo/representación:

$$
PZTRL \leftarrow PZT \NatJoin Localidades
$$

- Entradas por representación:

$$
numER \leftarrow \Group{\operatorname{COUNT}(*)}{representacionId}(Entradas \NatJoin Representaciones)
$$

- Representaciones con espectáculos:

$$
RE \leftarrow Representaciones \NatJoin Espectaculos
$$

- Número de representaciones por espectáculo:

$$
numRE \leftarrow \Group{\operatorname{COUNT}(*)}{espectaculoId}(Representaciones \NatJoin Espectaculos)
$$

- Recaudación por representación:

$$
Recaudaciones \leftarrow \Group{\operatorname{SUM}(pCompra)}{representacionId}(Entradas)
$$

- Localidades vendidas en r3:

$$
LocR3 \leftarrow \Group{\operatorname{COUNT}(localidadId)}{representacionId}(\Sel{representacionId=3}(Entradas))
$$

- Entradas por invitación:

$$
EntradasInvitacion \leftarrow \Sel{canal=\text{Invitacion}}(RE \NatJoin Entradas)
$$

## Modelo Tecnológico (MariaDB)


# Modelo tecnológico (MariaDB)

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Espectaculos/createDB.sql' label='Espectaculos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

{% include sql-embed.html src='/assets/sql/Espectaculos/populateDB.sql' label='Espectaculos/populateDB.sql' collapsed=true %}

## Consultas

Para crear las consultas SQL de las expresiones en Álgebra relacional se puede usar el siguiente script:

{% include sql-embed.html src='/assets/sql/Espectaculos/queries.sql' label='Espectaculos/queries.sql' collapsed=true %}

## SQL Avanzado

Para comprobar que la fecha de compra de una entrada es anterior a la fecha de la representación tenemos que usar triggers. El siguiente script muestra cómo se implementa un procedimiento almacenado que hace la comprobación y después se crean dos triggers, uno que hace la comprobación al insertar y otro al actualizar:

{% include sql-embed.html src='/assets/sql/Espectaculos/tFechaCompra.sql' label='Espectaculos/tFechaCompra.sql' collapsed=true %}
