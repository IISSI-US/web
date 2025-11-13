---
layout: default
published: false
title: Modelo Tecnológico (MariaDB)
parent: Animales
nav_order: 4
---

# Modelo tecnológico (MariaDB)

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Animales/createDB.sql' label='Animales/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/sql/Animales/populateDB.sql' label='Animales/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/sql/Animales/queries.sql' label='Animales/queries.sql' collapsed=true %}
