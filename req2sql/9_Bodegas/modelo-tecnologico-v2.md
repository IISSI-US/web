---
layout: default
published: false
title: Modelo Tecnológico (v2)
parent: Bodegas
nav_order: 6
---

# Modelo tecnológico. Versión 2: Una relación para cada subclase

## Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/Bodegas/createDB.sql' label='Bodegas/createDB.sql' collapsed=true %}

## Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/sql/Bodegas/populateDB.sql' label='Bodegas/populateDB.sql' collapsed=true %}

## Consultas

{% include sql-embed.html src='/assets/sql/Bodegas/queries.sql' label='Bodegas/queries.sql' collapsed=true %}

## SQL Avanzado

Realice un disparador que compruebe que en la tabla VinosUvas no se insertan tuplas con valores para jovenId y crianzaId simultáneamente:

{% include sql-embed.html src='/assets/sql/Bodegas2/createDB.sql' label='Bodegas2/createDB.sql' collapsed=true %}


