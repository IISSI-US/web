---
title: "Usuarios"
author: "José Calderón, Fernando Sola, Daniel Ayala, Inma Hernández, Margarita Cruz, Carlos Arévalo y David Ruiz"
layout: single
sidebar:
  nav: req2sql
head_scripts:
  - /assets/js/sql-embed.js
toc: true
toc_label: "Contenido"
toc_sticky: true
pdf_version: true
---
# Requisitos

## Requisitos de información (RI)

### RI-1: Usuarios
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los usuarios: nombre, edad, email y género (masculino, femenino, otro). Todos los atributos son obligatorios salvo el género.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

## Reglas de negocio (RN)

### RN-1: Mayor de edad
- Como: Profesor de la asignatura
- Quiero: Que los usuarios del sistema sean mayores de edad
- Para: Que el estudiante practique con restricciones simples.

### RN-2: Unicidad del correo electrónico
  - Como: Profesor de la asignatura
  - Quiero: Que no existan dos usuarios en el sistema con el mismo correo electrónico
  - Para: Que el estudiante practique con restricciones simples.

## Requisitos funcionales (RF)

### RF-1: Informes simples de Usuarios
- Como: Profesor de la asignatura
- Quiero: Que el sistema sea capaz de generar los siguientes informes:
	- **RF01:** Usuarios ordenados por nombre de la A a la Z.
	- **RF02:** Nombre y correo de los usuarios de género femenino.
	- **RF03:** Nombre, edad y correo de los usuarios con dominio `@us.es`.
	- **RF04:** Edad media y total de usuarios.
	- **RF05:** Edad media y total de los usuarios con dominio `@us.es`.
- Para: Que el estudiante practique con consultas simples.

### RF-2: Informes complejos de Usuarios
- Como: Profesor de la asignatura
- Quiero: Que el sistema sea capaz de generar los siguientes informes:
	- **RF06:** Edad media y número de usuarios según el género.
	- **RF07:** Usuarios de mayor edad.
	- **RF08:** Usuarios de mayor edad según el género.
	- **RF09:** Edad media y total de usuarios según el dominio de su correo electrónico.
- Para: Que el estudiante practique con consultas complejas.

Los identificadores **RF01–RF09** se reutilizan en el álgebra relacional y en
`queries.sql` para localizar la solución y sus resultados.

## Pruebas de aceptación (PA)

### PA-1: Usuarios

  1. ✅ Crear un nuevo usuario con todos los datos correctos según las reglas de negocio
  2. ✅ Crear un nuevo usuario sin especificar el género.
  3. ❌ Crear un nuevo usuario sin nombre.
  4. ❌ Crear un nuevo usuario sin edad.
  5. ❌ Crear un nuevo usuario sin email.
  6. ❌ Crear un nuevo usuario con el correo repetido.
  7. ❌ Crear un nuevo usuario menor de edad.

# Modelo Conceptual

## Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/usuarios/usuarios-dc-base.png' | relative_url }})

# Modelo Relacional

```mr-table
-- Intensión
Usuarios = { usuarioId, nombre, edad, género, email }
	PK(usuarioId)
	AK(email)

-- Extensión
Usuarios = {
	(u1,  "David Ruiz",      45, MASCULINO, "druiz@us.es"),
	(u2,  "Carlos Arévalo",  58, MASCULINO, "carevalo@us.es"),
	(u3,  "Margarita Cruz",  58, FEMENINO,  "mcruz@us.es"),
	(u4,  "Inma Hernández",  35, FEMENINO,  "inmahernandez@us.es"),
	(u5,  "Alfonso Márquez", 35, MASCULINO, "amarquez@us.es"),
	(u6,  "Daniel Ayala",     28, MASCULINO, "dayala1@us.es"),
	(u7,  "Raquel Sampedro", 55, FEMENINO,  "rsampedro@gmail.com"),
	(u8,  "Marta López",     18, FEMENINO,  "mlopez@mail.com"),
	(u9,  "David Ruiz",      25, MASCULINO, "druiz@mail.com"),
	(u10, "Andrea Gómez",     27, NULL,      "agomez@mail.es"),
	(u11, "Ernesto Murillo",  55, OTRO,      "emurillo@correo.es")
}
```

## Álgebra relacional

- Renombrado de la relación Usuarios (corregido para incluir el atributo género):

$$
\Ren{U(uid,n,ed,g,em)}\left(Usuarios\right)
$$

- **RF01:** Usuarios ordenados por nombre. Las relaciones del álgebra relacional
	no tienen orden; la ordenación se aplica en la consulta SQL. El resultado
	esperado (ordenado también por correo cuando se repite el nombre) es:

```mr-table
UsuariosAlfabetico = { nombre, email }

UsuariosAlfabetico = {
		("Alfonso Marquez", "amarquez@us.es"),
		("Andrea Gomez", "agomez@mail.es"),
		("Carlos Arevalo", "carevalo@us.es"),
		("Daniel Ayala", "dayala1@us.es"),
		("David Ruiz", "druiz@mail.com"),
		("David Ruiz", "druiz@us.es"),
		("Ernesto Murillo", "emurillo@correo.es"),
		("Inma Hernandez", "inmahernandez@us.es"),
		("Margarita Cruz", "mcruz@us.es"),
		("Marta Lopez", "mlopez@mail.com"),
		("Raquel Sampedro", "rsampedro@gmail.com")
}
```

- **RF02:** Nombre y correo de las usuarias (género femenino):

$$
Mujeres \leftarrow \Proj{n,em}\big(\Sel{g=\text{FEMENINO}}(U)\big)
$$

```mr-table
Mujeres = { n, em }

Mujeres = {
	("Margarita Cruz", "mcruz@us.es"),
	("Inma Hernández", "inmahernandez@us.es"),
	("Raquel Sampedro", "rsampedro@gmail.com"),
	("Marta López", "mlopez@mail.com")
}
```

- **RF03:** Nombre, edad y correo de los usuarios con dominio “@us.es”:

$$
UsuariosUS \leftarrow \Proj{n,ed,em}\big(\Sel{\operatorname{dominio}(em)='us.es'}(U)\big)
$$

```mr-table
UsuariosUS = { n, ed, em }

UsuariosUS = {
	("David Ruiz", 45, "druiz@us.es"),
	("Carlos Arévalo", 58, "carevalo@us.es"),
	("Margarita Cruz", 58, "mcruz@us.es"),
	("Inma Hernández", 35, "inmahernandez@us.es"),
	("Alfonso Márquez", 35, "amarquez@us.es"),
	("Daniel Ayala", 28, "dayala1@us.es")
}
```

Asumimos una función $\operatorname{dominio}()$ que dado un email devuelve su dominio (la cadena tras la @).

- **RF04:** Edad media y total de usuarios:

$$
MedTotUsuarios \leftarrow \GroupUp{\rho_{media}(\operatorname{AVG}(ed)),\;\rho_{total}(\operatorname{COUNT}(*))}(U)
$$

```mr-table
MedTotUsuarios = { media, total }

MedTotUsuarios = {
	(39.91, 11)
}
```

- **RF05:** Edad media y total de los usuarios con dominio “@us.es”:

$$
MedTotUsuariosUS \leftarrow \GroupUp{\rho_{media}(\operatorname{AVG}(ed)),\;\rho_{total}(\operatorname{COUNT}(*))}(UsuariosUS)
$$

```mr-table
MedTotUsuariosUS = { media, total }

MedTotUsuariosUS = {
	(43.17, 6)
}
```

- **RF06:** Edad media y número de usuarios agrupados por género:

$$
MediaGenero \leftarrow \Group{g,\rho_{media}(\operatorname{AVG}(ed)),\rho_{total}(\operatorname{COUNT}(*))}{g}(U)
$$

```mr-table
MediaGenero = { g, media, total }

MediaGenero = {
	(MASCULINO, 38.20, 5),
	(FEMENINO, 41.50, 4),
	(OTRO, 55.00, 1),
	(NULL, 27.00, 1)
}
```

- **RF09:** Edad media y total de usuarios según el dominio del correo electrónico:

$$
MedTotDominio \leftarrow \Group{\operatorname{dominio}(em),\rho_{media}(\operatorname{AVG}(ed)),\;\rho_{total}(\operatorname{COUNT}(*))}{\operatorname{dominio}(em)}(U)
$$

```mr-table
MedTotDominio = { dominio, media, total }

MedTotDominio = {
	("us.es", 43.17, 6),
	("gmail.com", 55.00, 1),
	("mail.com", 21.50, 2),
	("mail.es", 27.00, 1),
	("correo.es", 55.00, 1)
}
```

- **RF07:** Edad del usuario de mayor edad:

$$
edadMayor \leftarrow \GroupUp{\rho_{mayor}(\operatorname{MAX}(ed))}(U)
$$

```mr-table
edadMayor = { mayor }

edadMayor = {
	(58)
}
```

- **RF07:** Usuarios de mayor edad:

$$
UsuariosMayores \leftarrow \Proj{uid,n,ed,g,em}\left(\Sel{ed = mayor}(U \times edadMayor)\right)
$$

```mr-table
UsuariosMayores = { uid, n, ed, g, em }

UsuariosMayores = {
	(u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es"),
	(u3, "Margarita Cruz", 58, FEMENINO, "mcruz@us.es")
}
```

- **RF08:** Edad máxima por género:

$$
MayoresGenero \leftarrow \Group{g,\rho_{mayor}(\operatorname{MAX}(ed))}{g}(U)
$$

```mr-table
MayoresGenero = { g, mayor }

MayoresGenero = {
	(MASCULINO, 58),
	(FEMENINO, 58),
	(OTRO, 55),
	(NULL, 27)
}
```

- **RF08:** Usuarios de mayor edad según el género:

$$
UsuariosMayoresGenero \leftarrow \Proj{uid,n,ed,g,em}\left(\Sel{ed = mayor}(U \NatJoin MayoresGenero)\right)
$$

```mr-table
UsuariosMayoresGenero = { uid, n, ed, g, em }

UsuariosMayoresGenero = {
	(u2, "Carlos Arévalo", 58, MASCULINO, "carevalo@us.es"),
	(u3, "Margarita Cruz", 58, FEMENINO, "mcruz@us.es"),
	(u11, "Ernesto Murillo", 55, OTRO, "emurillo@correo.es"),
	(u10, "Andrea Gómez", 27, NULL, "agomez@mail.es")
}
```

# Modelo Tecnológico

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

## Script SQL para crear la base de datos

{% include sql-embed.html src='/_code/usuarios/createDB.sql' label='usuarios/createDB.sql'  collapsed=true %}

## Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

{% include sql-embed.html src='/_code/usuarios/populateDB.sql' label='usuarios/populateDB.sql'  collapsed=true %}

## Consultas

Para crear las consultas que implementan los requisitos funcionales se puede usar el siguiente script:

{% include sql-embed.html src='/_code/usuarios/queries.sql' label='usuarios/queries.sql'  collapsed=true %}

## SQL avanzado

El script para obtener el dominio de un correo electrónico es el siguiente:

{% include sql-embed.html src='/_code/usuarios/fEmailDomain.sql' label='usuarios/fEmailDomain.sql' collapsed=true %}

El trigger del modelo base es el siguiente:

{% include sql-embed.html src='/_code/usuarios/tCheckAge.sql' label='usuarios/tCheckAge.sql'  collapsed=true %}

## Pruebas SQL

{% include sql-embed.html src='/_code/usuarios/tests.sql' label='usuarios/tests.sql' collapsed=true %}

**Fin de la versión 1.** A partir de aquí se proponen ampliaciones independientes.

# Para trabajar más

## Usar la fecha de nacimiento en lugar de la edad

Modifica los modelos conceptual, relacional y tecnológico para almacenar la fecha
de nacimiento en lugar de la edad. Calcula la edad cuando sea necesaria y rechaza
fechas futuras y usuarios menores de edad, tanto al insertar como al actualizar.

La función de edad debe tener en cuenta que depende de la fecha actual:

{% include sql-embed.html src='/_code/usuarios/fGetAge.sql' label='usuarios/fGetAge.sql' collapsed=true %}

Como referencia ejecutable, `version2.sql` crea la variante aislada `Users_v2DB`
y `tests_v2.sql` comprueba los casos límite:

{% include sql-embed.html src='/_code/usuarios/version2.sql' label='usuarios/version2.sql' collapsed=true %}

{% include sql-embed.html src='/_code/usuarios/tests_v2.sql' label='usuarios/tests_v2.sql' collapsed=true %}

## Añadir tutores

Amplía los modelos para representar la relación de tutoría y cumplir las
restricciones RA01–RA03 del diagrama. Actualiza el modelo relacional, el esquema
y las pruebas negativas.

![Diagrama de clases de Usuarios con tutores]({{ '/assets/images/iissi1/req2sql/usuarios/usuarios-dc-tutores.png' | relative_url }})

## Añadir parejas

Amplía los modelos para representar las parejas y cumplir las restricciones
RA01–RA04 del diagrama. Actualiza el modelo relacional, el esquema y las pruebas
negativas.

![Diagrama de clases de Usuarios con parejas]({{ '/assets/images/iissi1/req2sql/usuarios/usuarios-dc-parejas.png' | relative_url }})

> [Versión PDF disponible](./index.pdf)
