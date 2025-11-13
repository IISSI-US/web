---
layout: default
published: false
title: Transacciones
parent: Aficiones
nav_order: 6
---

# Transacciones

Realice un procedimiento para insertar una afición a un usuario nuevo, es decir, que inserte en las tres tablas:

{% include sql-embed.html src='/assets/sql/AficionesEst/createDB.sql' label='AficionesEst/createDB.sql' collapsed=true %}

Realice el mismo procedimiento pero de forma transaccional:

{% include sql-embed.html src='/assets/sql/AficionesEst/populateDB.sql' label='AficionesEst/populateDB.sql' collapsed=true %}
