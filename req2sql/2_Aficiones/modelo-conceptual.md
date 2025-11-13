---
layout: default
published: false
title: Modelo Conceptual
parent: Aficiones
nav_order: 2
---

# Modelo conceptual (Versión estática)

## Diagrama de clases
En la versión estática, las aficiones se modelan como un dominio cerrado (enumeración) con valores prefijados: literatura, cine, deporte y gastronomía. El modelo extiende el ejercicio de Usuarios permitiendo asociar a cada usuario cero, una o varias aficiones del conjunto anterior.

- Estructura: Usuario mantiene sus atributos (por ejemplo, nombre, edad, email, género) y posee un atributo multivaluado/colección de tipo «Afición» (enumerado).
- Multiplicidades: Un Usuario puede tener 0..* aficiones; cada valor de la enumeración puede estar asociado a 0..* usuarios. Al ser enumeración, «Afición» no se representa como entidad independiente, sino como tipo.
- Reglas implícitas: No debe haber duplicados de una misma afición para un usuario; sólo se permiten valores del dominio definido.

![Diagrama de clases (estático)]({{ '/assets/images/req2sql/Aficiones/aficiones-est-dc.png' | relative_url }})

## Diagrama de objetos 

El diagrama de objetos ejemplifica varios usuarios con colecciones de aficiones tomadas del dominio cerrado. Se observan casos de:

- Usuario con varias aficiones (p. ej., {Cine, Deporte}).
- Usuario con una única afición (p. ej., {Literatura}).
- Usuario sin aficiones (conjunto vacío).
- Usuarios con el mismo nombre pero con emails distintos (u1, u9)

![Diagrama de objetos (estático)]({{ '/assets/images/req2sql/Aficiones/aficiones-est-do.png' | relative_url }})

# Modelo conceptual (Versión dinámica)

## Diagrama de clases

En la versión dinámica, las aficiones se convierten en entidad propia para permitir un catálogo abierto y gestionable. Normalmente aparecen las entidades Usuario y Afición, y una asociación Usuario–Afición para resolver la relación *..**.

<!-- - Estructura típica: Usuario (…atributos…) —< UsuarioAfición >— Afición (por ejemplo, id, nombre de la afición). La clase asociativa puede incluir metadatos (p. ej., fechaAlta), aunque no es el caso. -->
- Multiplicidades: Un Usuario puede estar asociado a 0..* aficiones y una Afición puede estar asociada a 0..* usuarios, en el modelo relacional se resolverá a través de una relación/entidad/tabla UsuarioAfición.
- Reglas implícitas: Unicidad del par (Usuario, Afición) para evitar duplicados. Posibilidad de CRUD sobre el catálogo de aficiones.

![Diagrama de clases (dinámico)]({{ '/assets/images/req2sql/Aficiones/aficiones-din-dc.png' | relative_url }})

## Diagrama de objetos

El diagrama de objetos muestra instancias de Usuario enlazadas a instancias de Afición mediante vínculos explícitos de la asociación. Se ven:

- Usuarios con varias aficiones y usuarios sin ninguna.
- Aficiones compartidas por varios usuarios y aficiones únicas.

Estos ejemplos ponen de relieve la diferencia clave respecto a la versión estática: el conjunto de aficiones no está cerrado y puede crecer.

![Diagrama de objetos (dinámico)]({{ '/assets/images/req2sql/Aficiones/aficiones-din-do.png' | relative_url }})
