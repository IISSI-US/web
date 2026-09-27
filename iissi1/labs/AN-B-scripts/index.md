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

Script principal para crear el esquema de la base de datos, incluyendo las tablas, claves y restricciones declarativas.

{% include sql-embed.html src='_code/grades/createDB.sql' label='createDB.sql' collapsed=false %}

## Funciones

Funciones auxiliares utilizadas por los triggers para implementar las reglas de negocio que requieren consultar otras filas o tablas.

{% include sql-embed.html src='_code/grades/functions.sql' label='functions.sql' collapsed=true %}

## Triggers

Disparadores que implementan las reglas de negocio no expresables mediante restricciones declarativas. Deben cargarse después de `functions.sql`.

{% include sql-embed.html src='_code/grades/triggers.sql' label='triggers.sql' collapsed=true %}

## Carga inicial de datos

Script para poblar la base de datos con datos de ejemplo para las pruebas.

{% include sql-embed.html src='_code/grades/populateDB.sql' label='populateDB.sql' collapsed=true %}

## Carga adicional de datos

Script con datos adicionales para ampliación de las pruebas.

{% include sql-embed.html src='_code/grades/populateDB2.sql' label='populateDB2.sql' collapsed=true %}

## Consultas de ejemplo

Ejemplos de consultas SQL sobre la base de datos GradesDB.

{% include sql-embed.html src='_code/grades/queries.sql' label='queries.sql' collapsed=true %}

## Autenticación y permisos

Script administrativo para crear los usuarios y roles de MariaDB usados en el acceso SQL directo y asignarles los permisos de RNF001. Debe ejecutarse por separado con una cuenta que disponga de `CREATE USER`, `CREATE ROLE` y `GRANT OPTION`.

{% include sql-embed.html src='_code/grades/grants.sql' label='grants.sql' collapsed=true %}

## Tests de restricciones declarativas

Batería utilizada en L4 antes de incorporar las funciones y triggers.

{% include sql-embed.html src='_code/grades/tests_constraints.sql' label='tests_constraints.sql' collapsed=true %}

## Tests completos

Batería completa utilizada en L5 después de cargar `functions.sql` y `triggers.sql`.

{% include sql-embed.html src='_code/grades/tests.sql' label='tests.sql' collapsed=true %}

> [Versión PDF disponible](./index.pdf)
