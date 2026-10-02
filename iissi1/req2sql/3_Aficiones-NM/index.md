---
title: Aficiones-NM
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Requisitos

Este ejercicio amplía Usuarios con una relación N:M y un catálogo abierto de
aficiones.

## Requisitos de información

### RI-1: Usuarios
- Mismo que ejercicio de Usuarios

### RI-02: Aficiones
- Como: Profesor de la asignatura
- Quiero: Almacenar las aficiones de los usuarios en un catálogo abierto. Cada usuario puede tener varias aficiones o ninguna, y se pueden añadir nuevas aficiones sin modificar el esquema.
- Para: Que el estudiante tenga en cuenta este requisito en el modelo conceptual, relacional y tecnológico.

## Requisitos funcionales

### RF-03: Informes sobre aficiones
- Como: Profesor de la asignatura
- Quiero: Que el sistema sea capaz de generar los siguientes informes:
    - Listado de usuarios con sus aficiones.
    - Usuarios a los que le gusta el cine.
    - Usuarios que no tienen aficiones.
    - Número de aficiones de cada usuario.
    - Máximo número de aficiones que tiene un usuario.
    - Usuarios con el máximo número de aficiones.
- Para: Que el alumno realice consultas en Álgebra Relacional y SQL.

# Modelo Conceptual

## Diagrama de clases Aficiones-NM

Las aficiones se almacenan como entidad propia para permitir un catálogo abierto;
la relación Usuario–Afición es N:M.

![Diagrama de clases Aficiones-NM]({{ '/assets/images/iissi1/req2sql/aficiones-nm/aficiones-nm-dc.png' | relative_url }})

# Modelo Relacional

## Modelo relacional Aficiones-NM (tabla intermedia Usuario–Afición)

```mr-table
Usuarios = { usuarioId, nombre, edad, género, email }
	PK(usuarioId)
	AK(email)
Aficiones = { aficionId, afición }
	PK(aficionId)
UsuariosAficiones = { usuarioAficionId, usuarioId, aficiónId }
	PK(usuarioAficionId)
	FK(usuarioId) / Usuarios
	FK(aficiónId) / Aficiones
	AK(usuarioId, aficiónId)

Usuarios = {
    (u1,  "David Ruiz",      45, MASCULINO, "druiz@us.es"),
    (u2,  "Carlos Arévalo",  58, MASCULINO, "carevalo@us.es"),
    (u3,  "Margarita Cruz",  58, FEMENINO,  "mcruz@us.es"),
    (u4,  "Inma Hernández",  35, FEMENINO,  "inmahernandez@us.es"),
    (u5,  "Alfonso Márquez", 35, MASCULINO, "amarquez@us.es"),
    (u6,  "Daniel Ayala",    28, MASCULINO, "dayala1@us.es"),
    (u7,  "Raquel Sampedro", 55, FEMENINO,  "rsampedro@gmail.com"),
    (u8,  "Marta López",     18, FEMENINO,  "mlopez@mail.com"),
    (u9,  "David Ruiz",      25, MASCULINO, "druiz@mail.com"),
    (u10, "Andrea Gómez",    27, NULL,      "agomez@mail.es"),
    (u11, "Ernesto Murillo", 55, OTRO,      "emurillo@correo.es")
}

Aficiones = {
    (a1, "Cine"), (a2, "Deporte"), (a3, "Jugar al fútbol"),
    (a4, "Hacer senderismo"), (a5, "Montar a caballo")
}
UsuariosAficiones = {
    (ua1, u1, a3), (ua2, u1, a4), (ua3, u2, a1),
    (ua4, u2, a2), (ua5, u2, a3), (ua6, u4, a4),
    (ua7, u4, a2), (ua8, u4, a1), (ua9, u5, a3),
    (ua10, u6, a2), (ua11, u8, a3), (ua12, u8, a4),
    (ua13, u8, a1), (ua14, u8, a2), (ua15, u9, a3),
    (ua16, u9, a1), (ua17, u9, a2), (ua18, u10, a4),
    (ua19, u11, a5)
}
```

### Álgebra relacional

- Renombrado:

$$
\Ren{U(uid,nu,ed,g,em)}(Usuarios)
$$

$$
\Ren{A(aid,af)}(Aficiones)
$$

$$
\Ren{UA(uaid,uid,aid)}(UsuariosAficiones)
$$

- Usuarios con sus aficiones:

$$
UAA \leftarrow U \NatJoin UA \NatJoin A
$$

```mr-table
UAA = { uid, nu, ed, g, em, uaid, aid, af }

UAA = {
    (u1, "David Ruiz", 45, MASCULINO, "druiz@us.es", ua1, a3, "Jugar al fútbol"),
    (u1, "David Ruiz", 45, MASCULINO, "druiz@us.es", ua2, a4, "Hacer senderismo"),
    (u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es", ua3, a1, "Cine"),
    (u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es", ua4, a2, "Deporte"),
    (u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es", ua5, a3, "Jugar al fútbol"),
    (u4, "Inma Hernández", 35, FEMENINO, "inmahernandez@us.es", ua6, a4, "Hacer senderismo"),
    (u4, "Inma Hernández", 35, FEMENINO, "inmahernandez@us.es", ua7, a2, "Deporte"),
    (u4, "Inma Hernández", 35, FEMENINO, "inmahernandez@us.es", ua8, a1, "Cine"),
    (u5, "Alfonso Márquez", 35, MASCULINO, "amarquez@us.es", ua9, a3, "Jugar al fútbol"),
    (u6, "Daniel Ayala", 28, MASCULINO, "dayala1@us.es", ua10, a2, "Deporte"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", ua11, a3, "Jugar al fútbol"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", ua12, a4, "Hacer senderismo"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", ua13, a1, "Cine"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", ua14, a2, "Deporte"),
    (u9, "David Ruiz", 25, MASCULINO, "druiz@mail.com", ua15, a3, "Jugar al fútbol"),
    (u9, "David Ruiz", 25, MASCULINO, "druiz@mail.com", ua16, a1, "Cine"),
    (u9, "David Ruiz", 25, MASCULINO, "druiz@mail.com", ua17, a2, "Deporte"),
    (u10, "Andrea Gómez", 27, NULL, "agomez@mail.es", ua18, a4, "Hacer senderismo"),
    (u11, "Ernesto Murillo", 55, OTRO, "emurillo@correo.es", ua19, a5, "Montar a caballo")
}
```

- Usuarios a los que les gusta el cine:

$$
UCine \leftarrow \Proj{nu}\big(\Sel{af=\text{Cine}}(UAA)\big)
$$

```mr-table
UCine = { nu }

UCine = {
    ("Carlos Arévalo"),
    ("Inma Hernández"),
    ("Marta López"),
    ("David Ruiz")
}
```

- Usuarios sin aficiones:

$$
USinAfi \leftarrow \Proj{nu}\big(U \NatJoin (\Proj{uid}(U) - \Proj{uid}(UA))\big)
$$

```mr-table
USinAfi = { nu }

USinAfi = {
    ("Margarita Cruz"),
    ("Raquel Sampedro")
}
```

- Usuarios con todas las aficiones:

$$
UsuTodasAfi \leftarrow \Proj{nu,uid}\left(\left({\Proj{uid,aid}(UA)}\Div{\Proj{aid}(A)}\right) \NatJoin U\right)
$$

```mr-table
UsuTodasAfi = { nu, uid }

UsuTodasAfi = {}
```

# Modelo Tecnológico

## Ejercicio Aficiones-NM

### Script SQL para crear la base de datos

{% include sql-embed.html src='/_code/aficiones-nm/createDB.sql' label='aficiones-nm/createDB.sql' collapsed=true %}

### Script SQL para la carga inicial de datos

{% include sql-embed.html src='/_code/aficiones-nm/populateDB.sql' label='aficiones-nm/populateDB.sql' collapsed=true %}

### Consultas

{% include sql-embed.html src='/_code/aficiones-nm/queries.sql' label='aficiones-nm/queries.sql' collapsed=true %}

### SQL avanzado

{% include sql-embed.html src='/_code/aficiones-nm/procedures.sql' label='aficiones-nm/procedures.sql' collapsed=true %}

Realice un procedimiento para insertar en la tabla de usuarios e implemente la siguiente prueba de aceptación:

### Pruebas de aceptación

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

### Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

Realice el mismo procedimiento pero de forma transaccional:

### Pruebas SQL

{% include sql-embed.html src='/_code/aficiones-nm/tests.sql' label='aficiones-nm/tests.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
