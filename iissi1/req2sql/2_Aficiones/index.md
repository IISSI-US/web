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

### Intensión

```
Usuarios(usuarioId, nombre, edad, género, email)
	PK(usuarioId)
	AK(email)
Aficiones(aficionId, usuarioId, afición)
	PK(aficionId)
	FK(usuarioId) / Usuarios
	AK(usuarioId, afición)
```

### Extensión

```
Usuarios = { u1..u11 como en el ejercicio de Usuarios }
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

- Usuarias a las que les gusta el cine: 

$$
UCine \leftarrow \Sel{af=\text{CINE}}(UA)
$$

- Usuarios sin aficiones: 

$$
UsuSinAfi \leftarrow \Proj{uid,nu}\big(U \NatJoin (\Proj{uid}(U) \Diff \Proj{uid}(A))\big)
$$

- Número de aficiones por usuario: 

$$
NumAfiUsu \leftarrow \Group{\operatorname{COUNT}(*)}{uid}(UA)
$$


---

## Variante dinámica (tabla intermedia usuario–afición)

### Intensión

```
Usuarios(usuarioId, nombre, edad, género, email)
	PK(usuarioId)
	AK(email)
Aficiones(aficionId, afición)
	PK(aficionId)
UsuariosAficiones(usuarioAficionId, usuarioId, aficiónId)
	PK(usuarioAficionId)
	FK(usuarioId) / Usuarios
	FK(aficiónId) / Aficiones
	AK(usuarioId, aficiónId)
```

### Extensión

```
Usuarios = { u1..u11 como en el ejercicio de Usuarios }

Aficiones = { 
    (a1, "Cine"), (a2, "Deporte"), (a3, "Jugar al fútbol"), 
    (a4, "Hacer senderismo"), (a5, "Montar a caballo") 
}
UsuariosAficiones = { 
    (u1,a3), (u1,a4), (u2,a1), (u2,a2), (u2,a3), (u4,a4), 
    (u4,a2), (u4,a1), (u5,a3), (u6,a2), (u8,a3), (u8,a4), 
    (u8,a1), (u8,a2), (u9,a3), (u9,a1), (u9,a2), (u10,a4), 
    (u11,a5) 
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
\Ren{UA(uid,aid)}(UsuariosAficiones)
$$

- Usuarios con sus aficiones: 

$$
UAA \leftarrow U \NatJoin UA \NatJoin A
$$

- Usuarios a los que les gusta el cine: 

$$
UCine \leftarrow \Proj{nu}\big(\Sel{af=\text{CINE}}(UAA)\big)
$$

- Usuarios sin aficiones: 

$$
USinAfi \leftarrow \Proj{nu}\big(U \NatJoin (\Proj{uid}(U) \Diff \Proj{uid}(UA))\big)
$$

- Usuarios con todas las aficiones: 

$$
UsuTodasAfi \leftarrow \Proj{nu,uid}\left(\frac{UA}{\Proj{aid}(A)} \NatJoin U\right)
$$


## Modelo Tecnológico (MariaDB)


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
