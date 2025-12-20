---
title: Animales
layout: single
sidebar:
  nav: req2sql
toc: true
toc_sticky: true
pdf_version: true
---
> [Versión PDF disponible](./index.pdf)


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

## Modelo Conceptual


# Modelo conceptual

## Diagrama de clases

El modelo representa la gestión del CAA.

- **Entidades principales**: Animal, Ingreso que puede ser una la Entrega de un animal o tratarse de un Abandono. Adopción es una clase asociación entre Persona e Ingreso
- **Asociaciones clave**: Una Persona puede hacer 0..* Ingresos (Entrega/Abandono), y solo puede hacer una adopción.

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Animales/animales-dc.png' | relative_url }})

## Diagrama de objetos

Las instancias reflejan el siguiente escenario: Carlos hace dos ingresos: Rocky (Entrega/Pastor Alemán) y Max (Abandono/Labrador). Laura adopta a Max y también a Luna (Gata siamesa).

![Diagrama de objetos]({{ '/assets/images/iissi1/req2sql/Animales/animales-do.png' | relative_url }})

## Modelo Relacional


# Modelo relacional

## Intensión

```
Especies(especieId, especie)
	PK(especieId)
	AK(especie)
Razas(razaId, especieId, raza)
	PK(razaId)
	FK(especieId) / Especies
	AK(especieId, raza)
Animales(animalId, razaId, chip, nombre, descripcion)
	PK(animalId)
	FK(razaId) / Razas
	AK(chip)
Personas(personaId, nombre, direccion, email)
	PK(personaId)
	AK(email)
Ingresos(ingresoId, personaId, animalId, fechaHoraEntrega)
	PK(ingresoId)
	FK(personaId) / Personas
	FK(animalId) / Animales
	AK(ingresoId, animalId)
Entregas(ingresoId)
	PK(ingresoId)
	FK(ingresoId) / Ingresos
Abandonos(ingresoId, fechaHoraAbandono, lugar)
	PK(ingresoId)
	FK(ingresoId) / Ingresos
	FK(animalId) / Animales
	AK(ingresoId, animalId)
Adopciones(adopcionId, personaId, animalId, fechaHoraAdopcion)
	PK(adopcionId)
	FK(personaId) / Personas
	FK(animalId) / Animales
	AK(personaId, Mes(fechaHoraAdopcion))
```

## Extensión (fragmento)

```
Especies = { (e1, "Canino"), (e2, "Felino") }
Razas = { (r1, e1, "Labrador"), (r2, e1, "Pastor Alemán"), (r3, e2, "Siamesa") }
Animales = { (a1, r1, "12345", "Max", "Perro marrón"), (a2, r1, "67890", "Rocky", "Perro negro"), (a3, r2, "54321", "Luna", "Gato gris") }
```

## Álgebra relacional

- Personas que adoptan animales:

$$
PerAdoAni \leftarrow Personas \NatJoin Adopciones \NatJoin Animales
$$

- Personas que entregan animales:

$$
PerEntAni \leftarrow Personas \NatJoin Ingresos \NatJoin Animales
$$

- Personas que entregan animales abandonados:

$$
PerEntAniAba \leftarrow Personas \NatJoin Ingresos \NatJoin Abandonos \NatJoin Animales
$$

- Adopciones en octubre:

$$
\Sel{Mes(fechaHoraAdopcion)=\text{Octubre}}(PerAdoAni)
$$

- Adopciones por especie:

$$
\Group{\operatorname{COUNT}(*)}{especieId}(PerAdoAni \NatJoin Razas \NatJoin Especies)
$$

## Modelo Tecnológico (MariaDB)


# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Animales/sql/createDB.sql' label='Animales/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Animales/sql/populateDB.sql' label='Animales/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/Animales/sql/queries.sql' label='Animales/queries.sql' collapsed=true %}
