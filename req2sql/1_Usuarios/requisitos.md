---
layout: default
title: Requisitos
parent: Usuarios
nav_order: 1
---

# Catálogo de Requisitos 

## Requisitos de información (RI)

### RI-1: Usuarios
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los usuarios: nombre, edad, email y género (masculino, femenino, otro). Todos los atributos son obligatorios salvo el género.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

## Reglas de negocio (RN)

### RN-1: Mayor de edad
- Como: Profesor de la asignatura
- Quiero: Que los usuarios del sistema sean mayores de edad
- Para: Que el estudiante practique con restricciones simples.

### RN-2: Unicidad del correo electrónico
  - Como: Profesor de la asignatura
  - Quiero: Que no existan dos usuarios en el sistema con el mismo correo electrónico
  - Para: Que el estudiante practique con restricciones simples.

## Requisitos funcionales (RF)

### RF-1: Informes simples de Usuarios
- Como: Profesor de la asignatura
- Quiero: Que el sistema sea capaz de generar los siguientes informes:
    - Usuarios ordenados por nombre de la A a la Z
    - Nombre y correo de los usuarios de género femenino.
    - Nombre, edad y correo de los usuarios con dominio '@us.es'.
    - Edad media y total de usuarios.
    - Edad media y total de los usuarios con dominio '@us.es'.
- Para: Que el estudiante practique con consultas simples.

### RF-2: Informes complejos de Usuarios
- Como: Profesor de la asignatura
- Quiero: Que el sistema sea capaz de generar los siguientes informes:
    - Edad media de los usuarios según el género.
    - Número de usuarios según el género.
    - Edad media de los usuarios según el género.
    - Total de usuarios según el género.
    - Usuarios de mayor edad.
    - Usuarios de mayor edad según el género.
    - Edad media y total de usuarios según el dominio de su correo electrónico.
- Para: Que el estudiante practique con consultas complejas.

## Pruebas de aceptación (PA)

### PA-1: Usuarios

  1. ✅ Crear un nuevo usuario con todos los datos correctos según las reglas de negocio
  2. ✅ Crear un nuevo usuario sin especificar el género.
  3. ❌ Crear un nuevo usuario sin nombre.
  4. ❌ Crear un nuevo usuario sin edad.
  5. ❌ Crear un nuevo usuario sin email.
  6. ❌ Crear un nuevo usuario con el correo repetido.
  7. ❌ Crear un nuevo usuario menor de edad.
