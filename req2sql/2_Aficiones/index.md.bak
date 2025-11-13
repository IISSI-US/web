---
title: Aficiones
layout: single
sidebar:
  nav: req2sql
toc: true
---

# Aficiones

\n## Requisitos\n

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
\n## Modelo Conceptual\n

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
\n## Modelo Relacional\n

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

\n## Modelo Tecnológico (MariaDB)\n

# Modelo tecnológico (MariaDB)

## Versión Estática

### Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/createDB.sql' | relative_url }}"></div>

### Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/populateDB.sql' | relative_url }}"></div>

### Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/queries.sql' | relative_url }}"></div>

## Versión Dinámica

### Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/createDB.sql' | relative_url }}"></div>

### Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/populateDB.sql' | relative_url }}"></div>

### Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/queries.sql' | relative_url }}"></div>

### SQL Avanzado

Realice un procedimiento para insertar en la tabla de usuarios e implemente la siguiente prueba de aceptación:

# Pruebas de aceptación

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pTestUsuario.sql' | relative_url }}"></div>


# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevo.sql' | relative_url }}"></div>

Realice el mismo procedimiento pero de forma transaccional:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' | relative_url }}"></div>
\n## Pruebas SQL\n

# Pruebas de aceptación SQL

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

Para hacer esta prueba crearemos un procedimiento para insertar un único Usuario, después usamos este procedimiento para insertar los datos de la prueba, teniendo en cuenta que antes hay que hacer la carga inicial de datos.

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pTestUsuario.sql' | relative_url }}"></div>
\n## Transacciones\n

# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevo.sql' | relative_url }}"></div>

Realice el mismo procedimiento pero de forma transaccional:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' | relative_url }}"></div>
\n## Aficiones\n

# title: Aficiones

\n## Requisitos\n

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
\n## Modelo Conceptual\n

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
\n## Modelo Relacional\n

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

\n## Modelo Tecnológico (MariaDB)\n

# Modelo tecnológico (MariaDB)

## Versión Estática

### Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/createDB.sql' | relative_url }}"></div>

### Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/populateDB.sql' | relative_url }}"></div>

### Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/queries.sql' | relative_url }}"></div>

## Versión Dinámica

### Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/createDB.sql' | relative_url }}"></div>

### Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/populateDB.sql' | relative_url }}"></div>

### Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/queries.sql' | relative_url }}"></div>

### SQL Avanzado

Realice un procedimiento para insertar en la tabla de usuarios e implemente la siguiente prueba de aceptación:

# Pruebas de aceptación

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pTestUsuario.sql' | relative_url }}"></div>


# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevo.sql' | relative_url }}"></div>

Realice el mismo procedimiento pero de forma transaccional:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' | relative_url }}"></div>
\n## Pruebas SQL\n

# Pruebas de aceptación SQL

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

Para hacer esta prueba crearemos un procedimiento para insertar un único Usuario, después usamos este procedimiento para insertar los datos de la prueba, teniendo en cuenta que antes hay que hacer la carga inicial de datos.

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pTestUsuario.sql' | relative_url }}"></div>
\n## Transacciones\n

# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevo.sql' | relative_url }}"></div>

Realice el mismo procedimiento pero de forma transaccional:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' | relative_url }}"></div>
\n## Aficiones\n

# Aficiones
{: .fs-9 }

Base de datos para gestionar aficiones estáticas/cerradas y dinámicas/abiertas.

{: .fs-6 .fw-300 }

- **Aficiones estáticas** (se eligen de un conjunto cerrado)
- **Aficiones dinámicas** (conjunto abierto)

**Conceptos de BD cubiertos**: enumerados, asociaciones 0..*, asociaciones *..*, composiciones, transacciones.

---

# Objetivos de Aprendizaje

Al completar este ejercicio serás capaz de:

- ✅ Implementar enumerados, composiciones, asociaciones 0..*, asociaciones *..*
- ✅ Aplicar restricciones de integridad
- ✅ Implementar transacciones de forma sistemática


