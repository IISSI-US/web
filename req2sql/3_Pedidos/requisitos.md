---
layout: default
published: false
title: Requisitos
parent: Pedidos
nav_order: 1
---

# Catálogo de Requisitos

## Requisitos de información (RI)

### RI-1: Usuarios
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los usuarios: nombre, provincia y fecha de alta en el Sistema de Pedidos.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico

### RI-2: Productos
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los productos: descripción, precio y stock en el almacén.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico

### RI-3: Pedidos
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los pedidos: fecha de compra en la que el usuario hace el pedido y cantidad de productos que se piden.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico

## Reglas de negocio (RN)

### RN-1: Límite de pedidos
- Como: Profesor de la asignatura
- Quiero: Que un usuario no pueda hacer más de tres pedidos al día
- Para: Que el estudiante practique con restricciones simples

### RN-2: Agosto inhábil
- Como: Profesor de la asignatura
- Quiero: Que no se puedan hacer pedidos en el mes de agosto
- Para: Que el estudiante practique con restricciones simples

### RN-3: Stock suficiente
- Como: Profesor de la asignatura
- Quiero: Que solo se pueda realizar el pedido si hay stock suficiente
- Para: Que el estudiante practique con restricciones simples

## Pruebas de aceptación (PA)

### PA-1: Pedidos

  1. ✅ Crear un nuevo pedido con todos los datos correctos según las reglas de negocio.
  2. ❌ Crear un nuevo pedido sin especificar la cantidad de productos.
  3. ❌ Crear un nuevo pedido sin especificar la fecha de compra.
  4. ❌ Crear un nuevo pedido con más de tres pedidos al día.
  5. ❌ Crear un nuevo pedido en el mes de agosto.
  6. ❌ Crear un nuevo pedido sin stock suficiente.

