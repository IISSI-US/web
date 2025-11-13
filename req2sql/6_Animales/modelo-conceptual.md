---
layout: default
title: Modelo Conceptual
parent: Animales
nav_order: 2
---

# Modelo conceptual

## Diagrama de clases

El modelo representa la gestión del CAA.

- **Entidades principales**: Animal, Ingreso que puede ser una la Entrega de un animal o tratarse de un Abandono. Adopción es una clase asociación entre Persona e Ingreso
- **Asociaciones clave**: Una Persona puede hacer 0..* Ingresos (Entrega/Abandono), y solo puede hacer una adopción.

![Diagrama de clases]({{ '/assets/images/req2sql/Animales/animales-dc.png' | relative_url }})

## Diagrama de objetos

Las instancias reflejan el siguiente escenario: Carlos hace dos ingresos: Rocky (Entrega/Pastor Alemán) y Max (Abandono/Labrador). Laura adopta a Max y también a Luna (Gata siamesa).

![Diagrama de objetos]({{ '/assets/images/req2sql/Animales/animales-do.png' | relative_url }})
