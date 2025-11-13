---
layout: default
published: false
title: Modelo Tecnológico (v2)
parent: Bodegas
nav_order: 6
---

# Modelo tecnológico. Versión 2: Una relación para cada subclase

## Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/Bodegas2/createDB.sql' | relative_url }}"></div>

## Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/Bodegas2/populateDB.sql' | relative_url }}"></div>

## Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/Bodegas2/queries.sql' | relative_url }}"></div>

## SQL Avanzado

Realice un disparador que compruebe que en la tabla VinosUvas no se insertan tuplas con valores para jovenId y crianzaId simultáneamente:

<div class="sql-file" data-src="{{ '/silence-db/sql/Bodegas2/triggers.sql' | relative_url }}"></div>


