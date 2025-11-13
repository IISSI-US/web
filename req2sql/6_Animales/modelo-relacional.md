---
layout: default
published: false
title: Modelo Relacional
parent: Animales
nav_order: 3
---

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
