---
title: Modelo Tecnológico (MariaDB)
published: false
parent: Usuarios
---

# Modelo tecnológico (MariaDB)

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Usuarios/createDB.sql' label='Usuarios/createDB.sql'  collapsed=true %}

## Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

{% include sql-embed.html src='/assets/sql/Usuarios/populateDB.sql' label='Usuarios/populateDB.sql'  collapsed=true %}

## Consultas

Para crear las consultas que implementan los requisitos funcionales se puede usar el siguiente script:

{% include sql-embed.html src='/assets/sql/Usuarios/queries.sql' label='Usuarios/queries.sql'  collapsed=true %}

## SQL Avanzado

Tenemos que implementar una función que calcula la edad de un usuario a partir de su fecha de nacimiento, y un trigger que comprueba que la fecha de nacimiento es anterior a la fecha actual y, además el usuario es mayor de edad.

El script para la función es el siguiente:

{% include sql-embed.html src='/assets/sql/Usuarios/fGetAge.sql' label='Usuarios/fGetAge.sql'  collapsed=true %}

El script para el trigger es el siguiente:

{% include sql-embed.html src='/assets/sql/Usuarios/tCheckAge.sql' label='Usuarios/tCheckAge.sql'  collapsed=true %}

## Fecha de nacimiento en lugar de la edad

En la creación de la tabla ahora hay que añadir que sustituir la edad por la fecha de nacimiento, pero ya no se puede comprobar que el Usuario es mayor de edad con un simple CHECK, y es necesario usar un TRIGGER, además para calcular la edad definiremos una función:

Ahora el script para la creación de la tabla es el siguiente:

{% include sql-embed.html src='/assets/sql/Usuarios2/createDB.sql' label='Usuarios2/createDB.sql'  collapsed=true %}

Los datos de prueba son los mismos que en el caso anterior pero sustituyendo la fecha de nacimiento por la edad:

{% include sql-embed.html src='/assets/sql/Usuarios2/populateDB.sql' label='Usuarios2/populateDB.sql'  collapsed=true %}

Para las consultas podemos usar la función definida para calcular la edad o crear una vista de la tabla Usuarios que tendrá la edad siempre actualizada.

{% include sql-embed.html src='/assets/sql/Usuarios2/queries.sql' label='Usuarios2/queries.sql'  collapsed=true %}

El trigger quedaría de la siguiente forma:

{% include sql-embed.html src='/assets/sql/Usuarios2/tCheckAge.sql' label='Usuarios2/tCheckAge.sql'  collapsed=true %}
