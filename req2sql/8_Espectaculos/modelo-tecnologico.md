---
layout: default
title: Modelo Tecnológico (MariaDB)
parent: Espectáculos
nav_order: 4
---

# Modelo tecnológico (MariaDB)

Para crear el esquema de la base de datos en MariaDB se puede usar el siguiente script:

## Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/Espectaculos/createDB.sql' | relative_url }}"></div>

## Script SQL para la carga inicial de datos

Para cargar los datos de prueba se puede usar el siguiente script:

<div class="sql-file" data-src="{{ '/silence-db/sql/Espectaculos/populateDB.sql' | relative_url }}"></div>

## Consultas

Para crear las consultas SQL de las expresiones en Álgebra relacional se puede usar el siguiente script:

<div class="sql-file" data-src="{{ '/silence-db/sql/Espectaculos/queries.sql' | relative_url }}"></div>

## SQL Avanzado

Para comprobar que la fecha de compra de una entrada es anterior a la fecha de la representación tenemos que usar triggers. El siguiente script muestra cómo se implementa un procedimiento almacenado que hace la comprobación y después se crean dos triggers, uno que hace la comprobación al insertar y otro al actualizar:

<div class="sql-file" data-src="{{ '/silence-db/sql/Espectaculos/tFechaCompra.sql' | relative_url }}"></div>
