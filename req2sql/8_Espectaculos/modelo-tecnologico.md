---
layout: default
published: false
title: Modelo Tecnológico (MariaDB)
parent: Espectáculos
nav_order: 4
---

# Modelo tecnológico (MariaDB)

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Espectaculos/createDB.sql' label='Espectaculos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

{% include sql-embed.html src='/assets/sql/Espectaculos/populateDB.sql' label='Espectaculos/populateDB.sql' collapsed=true %}

## Consultas

Para crear las consultas SQL de las expresiones en Álgebra relacional se puede usar el siguiente script:

{% include sql-embed.html src='/assets/sql/Espectaculos/queries.sql' label='Espectaculos/queries.sql' collapsed=true %}

## SQL Avanzado

Para comprobar que la fecha de compra de una entrada es anterior a la fecha de la representación tenemos que usar triggers. El siguiente script muestra cómo se implementa un procedimiento almacenado que hace la comprobación y después se crean dos triggers, uno que hace la comprobación al insertar y otro al actualizar:

{% include sql-embed.html src='/assets/sql/Espectaculos/tFechaCompra.sql' label='Espectaculos/tFechaCompra.sql' collapsed=true %}
