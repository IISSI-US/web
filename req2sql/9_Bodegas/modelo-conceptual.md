---
layout: default
title: Modelo Conceptual
parent: Bodegas
nav_order: 2
---

# Modelo conceptual


## Diagrama de clases

- Producción: cada Bodega produce 1..* Vino; cada Vino pertenece a 1 Bodega.
- Generalización: Vino se especializa en Joven y Crianza con partición {completa, disjunta}.
- Crianza–Cosecha: composición 1..* que modela las cosechas de un vino de crianza.
- Vino–Uva: relación M:N (elaboradoCon) entre Vino y Uva: un vino puede mezclar varias uvas y una uva intervenir en múltiples vinos.

![Diagrama de clases]({{ '/assets/images/req2sql/Bodegas/bodegas-dc.png' | relative_url }})

## Diagrama de objetos

Las instancias muestran dos bodegas (b1, b2) y cuatro vinos: j1, j2 (jóvenes) y c1, c2 (crianza), con sus cosechas y uvas.

- Producción: b1 produce j1 y c1; b2 produce j2 y c2.
- Composición de crianza: c1 tiene cosechas a1 y a2; c2 tiene a3 (respeta 1..*).
- Mezclas de uva: j1 → u3; j2 → u1; c1 → u1+u2; c2 → u1+u2, ilustrando la M:N Vino–Uva.
- El diagrama de objetos ejemplifica las cardinalidades y la especialización sin violar las RN indicadas en el diagrama de clases.

![Diagrama de objetos]({{ '/assets/images/req2sql/Bodegas/bodegas-do.png' | relative_url }})


## Posible extensión

- Jerarquía extendida: Vino se especializa en Joven, Crianza y Reserva {completa, disjunta}.
- Reserva compone 0..* Valoración (ranking: TipoRanking, puntuación 0..100); no puede haber dos valoraciones del mismo ranking para un mismo vino (RN‑6).
- Se mantienen Bodega–Vino (1..*), Crianza–Cosecha (1..*), y Vino–Uva (M:N) como en el modelo base.
- RN‑5: Reserva 36 meses (12–24 en barrica; resto en botella). Además, se mantienen RN‑1..RN‑4.

![Diagrama de clases (examen)]({{ '/assets/images/req2sql/Bodegas/bodegas-dc-examen.png' | relative_url }})