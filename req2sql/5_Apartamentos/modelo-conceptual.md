---
layout: default
title: Modelo Conceptual
parent: Apartamentos
nav_order: 2
---

# Modelo conceptual

## Diagrama de clases

El modelo gestiona el alquiler de apartamentos turísticos con propietarios, huéspedes y reservas.

- **Entidades principales**: Propietario, Alojamiento, Huésped, Reserva.
- **Asociaciones clave**: Un Propietario posee 0..* Alojamientos; un Alojamiento pertenece a un Propietario. Un Huésped puede realizar 0..* Reservas; una Reserva corresponde a 1 Huésped y 1 Alojamiento.
- **Atributos importantes**: Apartamento (dirección, capacidad, precio/noche), Reserva (fechas inicio/fin, precio total), Propietario/Huésped (datos personales).
- **Restricciones temporales**: Las reservas no pueden solaparse para un mismo apartamento; fechas de inicio < fechas fin.

![Diagrama de clases]({{ '/assets/images/req2sql/Apartamentos/apartamentos-dc.png' | relative_url }})

## Diagrama de objetos

Los objetos ilustran escenarios reales de gestión de alquileres con diferentes patrones de uso.

Marta es propietaria de un alojamiento que es reservado por Juan. El alojamiento tiene WIFI y PISCINA, está en la Costa del Sol y dispone de 2 fotos. Las fechas de compra y de reserva son coherentes.

![Diagrama de objetos]({{ '/assets/images/req2sql/Apartamentos/apartamentos-do.png' | relative_url }})