---
layout: default
published: false
title: Modelo Tecnológico (MariaDB)
parent: Apartamentos
nav_order: 4
---

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Apartamentos/createDB.sql' label='Apartamentos/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/sql/Apartamentos/populateDB.sql' label='Apartamentos/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/sql/Apartamentos/queries.sql' label='Apartamentos/queries.sql' collapsed=true %}
