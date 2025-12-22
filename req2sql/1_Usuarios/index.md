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
## Requisitos

# Catálogo de Requisitos 

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
    - Usuarios ordenados por nombre de la A a la Z
    - Nombre y correo de los usuarios de género femenino.
    - Nombre, edad y correo de los usuarios con dominio '@us.es'.
    - Edad media y total de usuarios.
    - Edad media y total de los usuarios con dominio '@us.es'.
- Para: Que el estudiante practique con consultas simples.

### RF-2: Informes complejos de Usuarios
- Como: Profesor de la asignatura
- Quiero: Que el sistema sea capaz de generar los siguientes informes:
    - Edad media de los usuarios según el género.
    - Número de usuarios según el género.
    - Edad media de los usuarios según el género.
    - Total de usuarios según el género.
    - Usuarios de mayor edad.
    - Usuarios de mayor edad según el género.
    - Edad media y total de usuarios según el dominio de su correo electrónico.
- Para: Que el estudiante practique con consultas complejas.

## Pruebas de aceptación (PA)

### PA-1: Usuarios

  1. ✅ Crear un nuevo usuario con todos los datos correctos según las reglas de negocio
  2. ✅ Crear un nuevo usuario sin especificar el género.
  3. ❌ Crear un nuevo usuario sin nombre.
  4. ❌ Crear un nuevo usuario sin edad.
  5. ❌ Crear un nuevo usuario sin email.
  6. ❌ Crear un nuevo usuario con el correo repetido.
  7. ❌ Crear un nuevo usuario menor de edad.

## Modelo Conceptual


### Diagrama de clases

![Diagrama de clases]({{ '/assets/images/iissi1/req2sql/Usuarios/usuarios-dc.png' | relative_url }})

## Modelo Relacional

### Intensión

```
Usuarios(usuarioId, nombre, género, edad, email)
	PK(usuarioId)
	AK(email)
```

### Extensión

```
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
	(u10, "Andrea Gómez",     27, OTRO,      "agomez@mail.es"),
	(u11, "Ernesto Murillo",  55, OTRO,      "emurillo@correo.es")
}
```

## Álgebra relacional

- Renombrado de la relación Usuarios (corregido para incluir el atributo género):

$$
\Ren{U(uid,n,g,ed,em)}\left(Usuarios\right)
$$

- Nombre y correo de las usuarias (género femenino):

$$
Mujeres \leftarrow \Proj{n,em}\big(\Sel{g=\text{FEMENINO}}(U)\big)
$$

- Nombre, edad y correo de los usuarios con dominio “@us.es”:

$$
UsuariosUS \leftarrow \Proj{n,ed,em}\big(\Sel{\operatorname{dominio}(em)='us.es'}(U)\big)
$$

Asumimos una función $\operatorname{dominio}(\cdot)$ que dado un email devuelve su dominio (la cadena tras la @).

- Edad media y total de usuarios:

$$
MedTotUsuarios \leftarrow \GroupUp{\operatorname{AVG}(ed),\;\operatorname{COUNT}(*)}(U)
$$

- Edad media y total de los usuarios con dominio “@us.es”:

$$
MedTotUsuariosUS \leftarrow \GroupUp{\operatorname{AVG}(ed),\;\operatorname{COUNT}(*)}(UsuariosUS)
$$

- Edad media de los usuarios agrupada por género:

$$
MediaGenero \leftarrow \Group{\operatorname{AVG}(ed)}{g}(U)
$$

- Número de usuarios agrupados por género:

$$
TotalGenero \leftarrow \Group{\operatorname{COUNT}(*)}{g}(U)
$$

- Edad media y total de usuarios según el dominio del correo electrónico:

$$
MedTotDominio \leftarrow \Group{\operatorname{AVG}(ed),\;\operatorname{COUNT}(*)}{\operatorname{dominio}(em)}(U)
$$

- Edad del usuario de mayor edad:

$$
edadMayor \leftarrow \GroupUp{\operatorname{MAX}(ed)}(U)
$$

- Edad máxima por género:

$$
MayoresGenero \leftarrow \Group{\operatorname{MAX}(ed)}{g}(U)
$$

## Pruebas HTTP

Para llevar a cabo las pruebas HTTP usaremos silence, que nos facilitará la labor. Hay que tener en cuenta los siguientes aspectos:

- Configurar el proyecto para trabajar con la BD de Usuarios. En el archivo `settings.py` hay que proporcionar los datos de la conexión a la BD y los archivos SQL para crear la BD.
- Ejecutar `silence createdb`.
- Ejecutar `silence createapi`. Esto crea un archivo JSON en la carpeta `endpoints/auto` por cada tabla en la que se define el API Rest para acceder a la BD.
- En el primer cuatrimestre no usamos autenticación, por lo que hay que modificar el API creado automáticamente, haciendo una copia, para poner el atributo `auth_required` a false en todos los casos.
- Ejecutar `silence createtest`. Este comando crea un archivo `.http` en la carpeta `tests/auto` para cada tabla de la BD. Estos tests generados automáticamente sirven de guía para personalizar los tests.

A partir de las pruebas de aceptación definidas en el catálogo de requisitos las peticiones HTTP serían:

<div class="http-file" data-src="{{ '/silence-db/tests/Usuarios/usuarios.http' | relative_url }}"></div>

La respuesta que se obtendría para cada petición es la siguiente:

<div class="http-file" data-src="{{ '/silence-db/tests/Usuarios/usuarios.response' | relative_url }}"></div>

## Modelo Tecnológico (MariaDB)

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

### Script SQL para crear la base de datos

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Usuarios/sql/createDB.sql' label='Usuarios/createDB.sql'  collapsed=true %}

### Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Usuarios/sql/populateDB.sql' label='Usuarios/populateDB.sql'  collapsed=true %}

### Consultas

Para crear las consultas que implementan los requisitos funcionales se puede usar el siguiente script:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Usuarios/sql/queries.sql' label='Usuarios/queries.sql'  collapsed=true %}

### SQL Avanzado

Tenemos que implementar una función que calcula la edad de un usuario a partir de su fecha de nacimiento, y un trigger que comprueba que la fecha de nacimiento es anterior a la fecha actual y, además el usuario es mayor de edad.

El script para la función es el siguiente:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Usuarios/sql/fGetAge.sql' label='Usuarios/fGetAge.sql'  collapsed=true %}

El script para el trigger es el siguiente:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Usuarios/sql/tCheckAge.sql' label='Usuarios/tCheckAge.sql'  collapsed=true %}

### Fecha de nacimiento en lugar de la edad

En la creación de la tabla ahora hay que añadir que sustituir la edad por la fecha de nacimiento, pero ya no se puede comprobar que el Usuario es mayor de edad con un simple CHECK, y es necesario usar un TRIGGER, además para calcular la edad definiremos una función. 

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/Usuarios/sql/version2.sql' label='Usuarios/version2.sql'  collapsed=true %}


<!-- Ahora el script para la creación de la tabla es el siguiente:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/_sql/_Usuarios2/createDB.sql' label='Usuarios2/createDB.sql'  collapsed=true %}

Los datos de prueba son los mismos que en el caso anterior pero sustituyendo la fecha de nacimiento por la edad:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/_sql/_Usuarios2/populateDB.sql' label='Usuarios2/populateDB.sql'  collapsed=true %}

Para las consultas podemos usar la función definida para calcular la edad o crear una vista de la tabla Usuarios que tendrá la edad siempre actualizada.

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/_sql/_Usuarios2/queries.sql' label='Usuarios2/queries.sql'  collapsed=true %}

El trigger quedaría de la siguiente forma:

{% include sql-embed.html src='https://raw.githubusercontent.com/IISSI-US/silence-db/main/_sql/_Usuarios2/tCheckAge.sql' label='Usuarios2/tCheckAge.sql'  collapsed=true %} -->

> [Versión PDF disponible](./index.pdf)
