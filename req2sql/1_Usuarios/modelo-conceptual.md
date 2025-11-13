---
layout: default
published: false
title: Modelo Conceptual
parent: Usuarios
nav_order: 2
---

# Modelo conceptual

## Diagrama de clases

El modelo conceptual presenta la entidad Usuario como única clase del dominio, con atributos básicos de identificación y descripción personal.

- **Entidad principal**: Usuario con atributos nombre, edad, email y género (opcional).
- **Restricciones implícitas**: Email único para cada usuario; edad debe ser ≥ 18 años; género puede ser masculino, femenino u otro (o NULL).
- **Clave primaria**: Email actúa como identificador único natural.

![Diagrama de clases]({{ '/assets/images/req2sql/Usuarios/usuarios-dc.png' | relative_url }})

## Diagrama de objetos

El diagrama de objetos ilustra instancias concretas de usuarios con diferentes combinaciones de valores en los atributos.

- **Ejemplos representativos**: Usuarios con géneros diversos (masculino, femenino, otro, ausente), edades variadas (todas ≥ 18), emails únicos.
- **Casos límite**: Usuario sin género especificado, usuarios con edades justas en el límite mínimo.
- **Variabilidad**: Los ejemplos muestran la diversidad permitida en nombres, dominios de email y opciones de género.

![Diagrama de objetos]({{ '/assets/images/req2sql/Usuarios/usuarios-do.png' | relative_url }})
