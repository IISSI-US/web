---
layout: default
published: false
title: Modelo Relacional
parent: Espectáculos
nav_order: 3
---

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
