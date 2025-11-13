---
layout: default
title: Modelo Relacional (v2)
parent: Bodegas
nav_order: 4
---

# Modelo relacional

## Versión 2: Una relación para cada subclase

### Intensión

```
Bodegas(bodegaId, nombre, denominaciónOrigen)
    PK(bodegaId)
    AK(nombre)
Jóvenes(jovenId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella)
    PK(jovenId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Crianzas(crianzaId, bodegaId, nombre, grados, tiempoBarrica, tiempoBotella)
    PK(crianzaId)
    FK(bodegaId) / Bodegas
    AK(nombre)
Uvas(uvaId, nombre)
    PK(uvaId)
    AK(nombre)
Cosechas(cosechaId, crianzaId, año, calidad)
    PK(cosechaId)
    FK(crianzaId) / Crianzas
    AK(cosechaId, crianzaId, año)
VinosUvas(vinoUvaId, jovenId*, crianzaId*, uvaId)
    PK(vinoUvaId)
    FK(jovenId) / Jóvenes
    FK(crianzaId) / Crianzas
    FK(uvaId) / Uvas
    AK(jovenId, uvaId)
    AK(crianzaId, uvaId)
    * Restricción: jovenId y crianzaId deben ser disjuntos.
```

### Extensión

```
Bodegas = {
    (b1, "Bodegas El Sol", "Rioja"),
    (b2, "Bodegas La Luna", "Ribera del Duero")      
}
Jóvenes = {
    (j1, b1, "Vino Blanco Joven", 12, 6, 0),
    (j2, b2, "Vino Tinto Joven", 13, 0, 12),
}
Crianzas = {
    (c1, b1, "Vino Crianza Especial", 14, 6, 18),
    (c2, b2, "Vino Crianza Reserva", 13.5, 12, 12)
}
Uvas = {
    (u1, "Tempranillo"),
    (u2, "Garnacha"),
    (u3, "Albarino")
}
Cosechas = {
    (co1, c1, 2020, "Excelente"),
    (co2, c1, 2019, "Buena"),
    (co3, c2, 2018, "Muy buena")
}
VinosUvas = {
    (vu1, j1, null, u3),
    (vu2, j2, null, u1),
    (vu3, null, c1, u2),
    (vu4, null, c1, u1),
    (vu5, null, c2, u2),
    (vu6, null, c2, u1)
}
```
