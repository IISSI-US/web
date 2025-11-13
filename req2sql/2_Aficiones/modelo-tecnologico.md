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

{% include sql-embed.html src='/assets/sql/AficionesEst/createDB.sql' label='AficionesEst/createDB.sql' collapsed=true %}

### Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/sql/AficionesEst/populateDB.sql' label='AficionesEst/populateDB.sql' collapsed=true %}

### Consultas

{% include sql-embed.html src='/assets/sql/AficionesEst/queries.sql' label='AficionesEst/queries.sql' collapsed=true %}

## Versión Dinámica

### Script SQL para crear la base de datos

{% include sql-embed.html src='/assets/sql/AficionesDin/createDB.sql' label='AficionesDin/createDB.sql' collapsed=true %}

### Script SQL para la carga inicial de datos

{% include sql-embed.html src='/assets/sql/AficionesDin/populateDB.sql' label='AficionesDin/populateDB.sql' collapsed=true %}

### Consultas

{% include sql-embed.html src='/assets/sql/AficionesDin/queries.sql' label='AficionesDin/queries.sql' collapsed=true %}

### SQL Avanzado

Realice un procedimiento para insertar en la tabla de usuarios e implemente la siguiente prueba de aceptación:

# Pruebas de aceptación

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

{% include sql-embed.html src='/assets/sql/AficionesDin/pTestUsuario.sql' label='AficionesDin/pTestUsuario.sql' collapsed=true %}


# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

{% include sql-embed.html src='/assets/sql/AficionesDin/pInsertarAficionUsuarioNuevo.sql' label='AficionesDin/pInsertarAficionUsuarioNuevo.sql' collapsed=true %}

Realice el mismo procedimiento pero de forma transaccional:

{% include sql-embed.html src='/assets/sql/AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' label='AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' collapsed=true %}
