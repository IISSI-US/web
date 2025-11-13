---
layout: default
title: Transacciones
parent: Aficiones
nav_order: 6
---

# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevo.sql' | relative_url }}"></div>

Realice el mismo procedimiento pero de forma transaccional:

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pInsertarAficionUsuarioNuevoTrans.sql' | relative_url }}"></div>