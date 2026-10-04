---
title: Aficiones-1N
layout: single
sidebar:
  nav: req2sql
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---

# Requisitos

Este ejercicio amplía Usuarios con una relación 1:N y un conjunto cerrado de
aficiones.

## Requisitos de información

### RI-1: Usuarios
- Mismo que ejercicio de Usuarios

### RI-02: Aficiones
- Como: Profesor de la asignatura
- Quiero: Almacenar las aficiones de los usuarios, que pueden ser literatura, cine, deporte o gastronomía. Cada usuario puede tener varias aficiones o ninguna.
- Para: Que el estudiante tenga en cuenta este requisito en el modelo conceptual, relacional y tecnológico

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

## Diagrama de clases Aficiones-1N

![Diagrama de clases Aficiones-1N (variante estática)]({{ '/assets/images/iissi1/req2sql/aficiones-1n/aficiones-1n-dc.png' | relative_url }})

# Modelo Relacional

## Aficiones como relación 1:N con catálogo cerrado

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
    (u10, "Andrea Gómez",    27, NULL,      "agomez@mail.es"),
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

#### Consultas

1. Obtener los usuarios con sus aficiones.
2. Obtener los usuarios a los que les gusta el cine.
3. Obtener los usuarios sin aficiones.
4. Calcular el número de aficiones por usuario.
5. Calcular el máximo número de aficiones que tiene un usuario.
6. Obtener los usuarios con el máximo número de aficiones.
7. Obtener los usuarios con todas las aficiones de la relación.

#### Soluciones

- Renombrado:

$$
\Ren{U(uid,nu,ed,g,em)}(Usuarios)
$$

$$
\Ren{A(aid,uid,af)}(Aficiones)
$$

**1. Usuarios con sus aficiones:**

$$
UA \leftarrow U \NatJoin A
$$

$$
UsuariosAficiones \leftarrow \Proj{nu,ed,g,af}(UA)
$$

```mr-table
UsuariosAficiones = { nu, ed, g, af }

UsuariosAficiones = {
    ("David Ruiz", 45, MASCULINO, "Deporte"),
    ("David Ruiz", 45, MASCULINO, "Gastronomía"),
    ("Carlos Arévalo", 58, MASCULINO, "Deporte"),
    ("Carlos Arévalo", 58, MASCULINO, "Literatura"),
    ("Carlos Arévalo", 58, MASCULINO, "Cine"),
    ("Inma Hernández", 35, FEMENINO, "Gastronomía"),
    ("Inma Hernández", 35, FEMENINO, "Cine"),
    ("Inma Hernández", 35, FEMENINO, "Literatura"),
    ("Alfonso Márquez", 35, MASCULINO, "Deporte"),
    ("Daniel Ayala", 28, MASCULINO, "Cine"),
    ("Marta López", 18, FEMENINO, "Deporte"),
    ("Marta López", 18, FEMENINO, "Gastronomía"),
    ("Marta López", 18, FEMENINO, "Literatura"),
    ("Marta López", 18, FEMENINO, "Cine"),
    ("David Ruiz", 25, MASCULINO, "Deporte"),
    ("David Ruiz", 25, MASCULINO, "Literatura"),
    ("David Ruiz", 25, MASCULINO, "Cine"),
    ("Andrea Gómez", 27, NULL, "Gastronomía")
}
```

**2. Usuarios a los que les gusta el cine:**

$$
UCine \leftarrow \Proj{nu}\left(\Sel{af=\text{Cine}}(UA)\right)
$$

```mr-table
UCine = { nu }

UCine = {
    ("Carlos Arévalo"),
    ("Inma Hernández"),
    ("Daniel Ayala"),
    ("Marta López"),
    ("David Ruiz")
}
```

**3. Usuarios sin aficiones:**

$$
USinAfi \leftarrow \Proj{nu}\left(U \NatJoin \left(\Proj{uid}(U) -\Proj{uid}(A)\right)\right)
$$

```mr-table
USinAfi = { nu }

USinAfi = {
    ("Margarita Cruz"),
    ("Raquel Sampedro"),
    ("Ernesto Murillo")
}
```

**4. Número de aficiones por usuario:**

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

**5. Máximo número de aficiones por usuario:**

$$
MaxAfi \leftarrow \GroupUp{\rho_{maxAfi}(\operatorname{MAX}(total))}(NumAfiUsu)
$$

```mr-table
MaxAfi = { maxAfi }

MaxAfi = {
    (4)
}
```

**6. Usuarios con el máximo número de aficiones:**

$$
UsuMaxAfi \leftarrow \Proj{uid,nu}(U \NatJoin \Sel{total=maxAfi}(NumAfiUsu \times MaxAfi))
$$

```mr-table
UsuMaxAfi = { uid, nu }

UsuMaxAfi = {
    (u8, "Marta López")
}
```

**7. Usuarios con todas las aficiones presentes en el conjunto:**

$$
UsuTodasAfi \leftarrow \Proj{uid,nu}\left(\left(\Proj{uid,af}(UA) \Div \Proj{af}(UA)\right) \NatJoin U\right)
$$

```mr-table
UsuTodasAfi = { uid, nu }

UsuTodasAfi = {
    (u8, "Marta López")
}
```

# Modelo Tecnológico

## Ejercicio Aficiones-1N

### Script SQL para crear la base de datos

{% include sql-embed.html src='/_code/aficiones-1n/createDB.sql' label='aficiones-1n/createDB.sql' collapsed=true %}

### Script SQL para la carga inicial de datos

{% include sql-embed.html src='/_code/aficiones-1n/populateDB.sql' label='aficiones-1n/populateDB.sql' collapsed=true %}

### Consultas

{% include sql-embed.html src='/_code/aficiones-1n/queries.sql' label='aficiones-1n/queries.sql' collapsed=true %}

### SQL avanzado

{% include sql-embed.html src='/_code/aficiones-1n/fCinePorDeporte.sql' label='aficiones-1n/fCinePorDeporte.sql' collapsed=true %}

### Pruebas SQL

{% include sql-embed.html src='/_code/aficiones-1n/tests.sql' label='aficiones-1n/tests.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
