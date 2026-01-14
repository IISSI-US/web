---
layout: single
sidebar:
  nav: labs-iissi-1
title: Anexo B - Scripts SQL
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
head_scripts:
  - /assets/js/sql-embed.js
---

<!-- # Anexo B: Scripts SQL de la base de datos GradesDB -->

Este anexo contiene todos los scripts SQL necesarios para trabajar con la base de datos **GradesDB** utilizada en los laboratorios de IISSI-1.

## Creación de la base de datos

Script principal para crear el esquema de la base de datos, incluyendo todas las tablas, claves, restricciones, funciones y disparadores (triggers).

{% include sql-embed.html src='_code/grades/createDB.sql' label='createDB.sql' collapsed=false %}

## Carga inicial de datos

Script para poblar la base de datos con datos de ejemplo para las pruebas.

{% include sql-embed.html src='_code/grades/populateDB.sql' label='populateDB.sql' collapsed=true %}

## Carga adicional de datos

Script con datos adicionales para ampliación de las pruebas.

{% include sql-embed.html src='_code/grades/populateDB2.sql' label='populateDB2.sql' collapsed=true %}

## Consultas de ejemplo

Ejemplos de consultas SQL sobre la base de datos GradesDB.

{% include sql-embed.html src='_code/grades/queries.sql' label='queries.sql' collapsed=true %}

## Permisos y usuarios

Script para configurar los permisos y crear los usuarios necesarios para trabajar con la base de datos.

{% include sql-embed.html src='_code/grades/grants.sql' label='grants.sql' collapsed=true %}

## Tests

Script con procedimientos de prueba para validar el funcionamiento de la base de datos.

{% include sql-embed.html src='_code/grades/tests.sql' label='tests.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
