---
title: Aficiones
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Aficiones


## Requisitos


# Catálogo de Requisitos

Añada los siguientes requisitos al ejercicio Usuarios:

## RI-1: Usuarios
- Mismo que ejercicio de Usuarios

## RI-02: Aficiones
- Como: Profesor de la asignatura
- Quiero: Almacenar las aficiones de los usuarios, que pueden ser: literatura, cine, deporte o gastronomía. Los usuarios pueden varias aficiones o ninguna.
- Para: Que el estudiante tenga en cuenta este requisito en el modelo conceptual, relacional y tecnológico

## RF-03: Informes sobre aficiones
- Como: Profesor de la asignatura
- Quiero: Que el sistema sea capaz de generar los siguientes informes:
    - Listado de usuarios con sus aficiones.
    - Usuarios a los que le gusta el cine.
    - Usuarios que no tienen aficiones.
    - Número de aficiones de cada usuario.
    - Máximo número de aficiones que tiene un usuario.
    - Usuarios con el máximo número de aficiones.
- Para: Que el alumno realice consultas en Álgebra Relacional y SQL.

## Modificación solicitada: 

Modifique el RI-02 de la versión estática/cerrada del ejercicio de Aficiones para que las aficiones de los Usuarios sean dinámicas/abierta.

## Modelo Conceptual


# Modelo conceptual (Versión estática)

## Diagrama de clases

![Diagrama de clases (estático)]({{ '/assets/images/iissi1/req2sql/Aficiones/aficiones-est-dc.png' | relative_url }})

# Modelo conceptual (Versión dinámica)

## Diagrama de clases

En la versión dinámica, las aficiones se convierten en entidad propia para permitir un catálogo abierto y gestionable. Normalmente aparecen las entidades Usuario y Afición, y una asociación Usuario–Afición para resolver la relación *..**.

![Diagrama de clases (dinámico)]({{ '/assets/images/iissi1/req2sql/Aficiones/aficiones-din-dc.png' | relative_url }})

# Modelo relacional

## Variante estática (Aficiones como atributos en su relación)

```mr-table
Usuarios = { usuarioId, nombre, edad, género, email }
	PK(usuarioId)
	AK(email)
Aficiones = { aficionId, usuarioId, afición }
	PK(aficionId)
	FK(usuarioId) / Usuarios
	AK(usuarioId, afición)
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
    (u10, "Andrea Gómez",    27, OTRO,      "agomez@mail.es"),
    (u11, "Ernesto Murillo", 55, OTRO,      "emurillo@correo.es")
}
Aficiones = {
    (a1, u1, "Deporte"), 
    (a2, u1, "Gastronomía"),
    (a3, u2, "Deporte"), 
    (a4, u2, "Literatura"), 
    (a5, u2, "Cine"),
    (a6, u4, "Gastronomía"), 
    (a7, u4, "Cine"), 
    (a8, u4, "Literatura"),
    (a9, u5, "Deporte"), 
    (a10, u6, "Cine"),
    (a11, u8, "Deporte"), 
    (a12, u8, "Gastronomía"), 
    (a13, u8, "Literatura"), 
    (a14, u8, "Cine"),
    (a15, u9, "Deporte"), 
    (a16, u9, "Literatura"), 
    (a17, u9, "Cine"),
    (a18, u10, "Gastronomía")
}
```

### Álgebra relacional

- Renombrado:

$$
\Ren{U(uid,nu,ed,g,em)}(Usuarios)
$$

$$
\Ren{A(aid,uid,af)}(Aficiones)
$$

- Usuarios con sus aficiones: 

$$
UA \leftarrow U \NatJoin A
$$

```mr-table
UA = { uid, nu, ed, g, em, aid, af }

UA = {
    (u1, "David Ruiz", 45, MASCULINO, "druiz@us.es", a1, "Deporte"),
    (u1, "David Ruiz", 45, MASCULINO, "druiz@us.es", a2, "Gastronomía"),
    (u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es", a3, "Deporte"),
    (u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es", a4, "Literatura"),
    (u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es", a5, "Cine"),
    (u4, "Inma Hernández", 35, FEMENINO, "inmahernandez@us.es", a6, "Gastronomía"),
    (u4, "Inma Hernández", 35, FEMENINO, "inmahernandez@us.es", a7, "Cine"),
    (u4, "Inma Hernández", 35, FEMENINO, "inmahernandez@us.es", a8, "Literatura"),
    (u5, "Alfonso Márquez", 35, MASCULINO, "amarquez@us.es", a9, "Deporte"),
    (u6, "Daniel Ayala", 28, MASCULINO, "dayala1@us.es", a10, "Cine"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", a11, "Deporte"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", a12, "Gastronomía"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", a13, "Literatura"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", a14, "Cine"),
    (u9, "David Ruiz", 25, MASCULINO, "druiz@mail.com", a15, "Deporte"),
    (u9, "David Ruiz", 25, MASCULINO, "druiz@mail.com", a16, "Literatura"),
    (u9, "David Ruiz", 25, MASCULINO, "druiz@mail.com", a17, "Cine"),
    (u10, "Andrea Gómez", 27, OTRO, "agomez@mail.es", a18, "Gastronomía")
}
```

- Usuarios a los que les gusta el cine:

$$
UCine \leftarrow \Sel{af=\text{Cine}}(UA)
$$

```mr-table
UCine = { uid, nu, ed, g, em, aid, af }

UCine = {
    (u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es", a5, "Cine"),
    (u4, "Inma Hernández", 35, FEMENINO, "inmahernandez@us.es", a7, "Cine"),
    (u6, "Daniel Ayala", 28, MASCULINO, "dayala1@us.es", a10, "Cine"),
    (u8, "Marta López", 18, FEMENINO, "mlopez@mail.com", a14, "Cine"),
    (u9, "David Ruiz", 25, MASCULINO, "druiz@mail.com", a17, "Cine")
}
```

- Usuarios sin aficiones: 

$$
UsuSinAfi \leftarrow \Proj{uid,nu}\big(U \NatJoin (\Proj{uid}(U) -\Proj{uid}(A))\big)
$$

```mr-table
UsuSinAfi = { uid, nu }

UsuSinAfi = {
    (u3, "Margarita Cruz"),
    (u7, "Raquel Sampedro"),
    (u11, "Ernesto Murillo")
}
```

- Número de aficiones por usuario: 

$$
NumAfiUsu \leftarrow \Group{uid,\rho_{total}(\operatorname{COUNT}(*))}{uid}(UA)
$$

```mr-table
NumAfiUsu = { uid, total }

NumAfiUsu = {
    (u1, 2),
    (u2, 3),
    (u4, 3),
    (u5, 1),
    (u6, 1),
    (u8, 4),
    (u9, 3),
    (u10, 1)
}
```

## Variante dinámica (tabla intermedia usuario–afición)

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
    (u10, "Andrea Gómez",    27, OTRO,      "agomez@mail.es"),
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
    (u10, "Andrea Gómez", 27, OTRO, "agomez@mail.es", ua18, a4, "Hacer senderismo"),
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
UsuTodasAfi \leftarrow \Proj{nu,uid}\left(\left(\frac{\Proj{uid,aid}(UA)}{\Proj{aid}(A)}\right) \NatJoin U\right)
$$

```mr-table
UsuTodasAfi = { nu, uid }

UsuTodasAfi = {}
```

# Modelo tecnológico (MariaDB)

## Versión Estática

### Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesEst/sql/createDB.sql' label='AficionesEst/createDB.sql' collapsed=true %}

### Script SQL para la carga inicial de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesEst/sql/populateDB.sql' label='AficionesEst/populateDB.sql' collapsed=true %}

### Consultas

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesEst/sql/queries.sql' label='AficionesEst/queries.sql' collapsed=true %}

## Versión Dinámica

### Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/createDB.sql' label='AficionesDin/createDB.sql' collapsed=true %}

### Script SQL para la carga inicial de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/populateDB.sql' label='AficionesDin/populateDB.sql' collapsed=true %}

### Consultas

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/queries.sql' label='AficionesDin/queries.sql' collapsed=true %}

### SQL Avanzado

Realice un procedimiento para insertar en la tabla de usuarios e implemente la siguiente prueba de aceptación:

# Pruebas de aceptación

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/pTestUsuario.sql' label='AficionesDin/pTestUsuario.sql' collapsed=true %}


# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/pInsertarAficionUsuarioNuevo.sql' label='AficionesDin/pInsertarAficionUsuarioNuevo.sql' collapsed=true %}

Realice el mismo procedimiento pero de forma transaccional:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/pInsertarAficionUsuarioNuevoTrans.sql' label='AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' collapsed=true %}

## Pruebas SQL


# Pruebas de aceptación SQL

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

Para hacer esta prueba crearemos un procedimiento para insertar un único Usuario, después usamos este procedimiento para insertar los datos de la prueba, teniendo en cuenta que antes hay que hacer la carga inicial de datos.

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/pTestUsuario.sql' label='AficionesDin/pTestUsuario.sql' collapsed=true %}

## Transacciones


# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/pInsertarAficionUsuarioNuevo.sql' label='AficionesDin/pInsertarAficionUsuarioNuevo.sql' collapsed=true %}

Realice el mismo procedimiento pero de forma transaccional:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/AficionesDin/sql/pInsertarAficionUsuarioNuevoTrans.sql' label='AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
