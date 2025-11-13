---
layout: default
published: false
title: Modelo Tecnológico (MariaDB)
parent: Aficiones
nav_order: 4
---

# Modelo tecnológico (MariaDB)

## Versión Estática

### Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/createDB.sql' | relative_url }}"></div>

### Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/populateDB.sql' | relative_url }}"></div>

### Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesEst/queries.sql' | relative_url }}"></div>

## Versión Dinámica

### Script SQL para crear la base de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/createDB.sql' | relative_url }}"></div>

### Script SQL para la carga inicial de datos

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/populateDB.sql' | relative_url }}"></div>

### Consultas

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/queries.sql' | relative_url }}"></div>

### SQL Avanzado

Realice un procedimiento para insertar en la tabla de usuarios e implemente la siguiente prueba de aceptación:

# Pruebas de aceptación

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pTestUsuario.sql' | relative_url }}"></div>


# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevo.sql' | relative_url }}"></div>

Realice el mismo procedimiento pero de forma transaccional:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' | relative_url }}"></div>
