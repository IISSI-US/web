---
layout: default
title: Modelo Conceptual
parent: Espectáculos
nav_order: 2
---

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