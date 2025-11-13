---
layout: default
title: Modelo Tecnológico (MariaDB)
parent: Usuarios
nav_order: 4
---

# Modelo tecnológico (MariaDB)

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

## Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios/createDB.sql' | relative_url }}"></div>

## Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios/populateDB.sql' | relative_url }}"></div>

## Consultas

Para crear las consultas que implementan los requisitos funcionales se puede usar el siguiente script:

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios/queries.sql' | relative_url }}"></div>

## SQL Avanzado

Tenemos que implementar una función que calcula la edad de un usuario a partir de su fecha de nacimiento, y un trigger que comprueba que la fecha de nacimiento es anterior a la fecha actual y, además el usuario es mayor de edad.

El script para la función es el siguiente:

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios/fGetAge.sql' | relative_url }}"></div>

El script para el trigger es el siguiente:

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios/tCheckAge.sql' | relative_url }}"></div>

## Fecha de nacimiento en lugar de la edad

En la creación de la tabla ahora hay que añadir que sustituir la edad por la fecha de nacimiento, pero ya no se puede comprobar que el Usuario es mayor de edad con un simple CHECK, y es necesario usar un TRIGGER, además para calcular la edad definiremos una función:

Ahora el script para la creación de la tabla es el siguiente:

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios2/createDB.sql' | relative_url }}"></div>

Los datos de prueba son los mismos que en el caso anterior pero sustituyendo la fecha de nacimiento por la edad:

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios2/populateDB.sql' | relative_url }}"></div>

Para las consultas podemos usar la función definida para calcular la edad o crear una vista de la tabla Usuarios que tendrá la edad siempre actualizada.

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios2/queries.sql' | relative_url }}"></div>

El trigger quedaría de la siguiente forma:

<div class="sql-file" data-src="{{ '/silence-db/sql/Usuarios2/tCheckAge.sql' | relative_url }}"></div>