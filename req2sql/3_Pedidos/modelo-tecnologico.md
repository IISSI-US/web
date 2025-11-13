---
layout: default
published: false
title: Modelo Tecnológico (MariaDB)
parent: Pedidos
nav_order: 4
---

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Pedidos/createDB.sql' label='Pedidos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/sql/Pedidos/populateDB.sql' label='Pedidos/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/sql/Pedidos/queries.sql' label='Pedidos/queries.sql' collapsed=true %}

## Procedimientos

{% include sql-embed.html src='/assets/sql/Pedidos/procedures.sql' label='Pedidos/procedures.sql' collapsed=true %}

## Tests

{% include sql-embed.html src='/assets/sql/Pedidos/tests.sql' label='Pedidos/tests.sql' collapsed=true %}

