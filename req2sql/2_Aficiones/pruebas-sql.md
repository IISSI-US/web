---
layout: default
published: false
title: Pruebas SQL
parent: Aficiones
nav_order: 5
---

# Pruebas de aceptación SQL

**PA-001: Usuarios**
1. ✅ Insertar un usuario con datos correctos.
2. ✅ Insertar un usuario sin género.
3. ❌ Insertar un usuario con un email repetido.
4. ❌ Insertar un usuario menor de edad.

Para hacer esta prueba crearemos un procedimiento para insertar un único Usuario, después usamos este procedimiento para insertar los datos de la prueba, teniendo en cuenta que antes hay que hacer la carga inicial de datos.

<div class="sql-file" data-src="{{ '/silence-db/sql/AficionesDin/pTestUsuario.sql' | relative_url }}"></div>
