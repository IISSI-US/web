---
layout: default
published: false
title: Requisitos
parent: Animales
nav_order: 1
---

# Catálogo de Requisitos 

## Objetivos

### Obj-1: Objetivo 1
- Responsable: Responsable de CAA
- Descripción: Llevar a cabo el ingreso de un animal, abandonado en la vía pública o entregado por una persona, en cuyo caso habría que identificarla, clasificándolo por razas y especies
- Para: Mantener los animales custodiados y ofrecerlos en adopción a personas interesadas

### Obj-2: Objetivo 2
- Responsable: Responsable de CAA
- Descripción: Gestionar consultas de animales disponibles y adjudicar adopciones
- Para: Adjudicar cuanto antes los animales existentes y disminuir costes de mantenimiento del CAD

## Requisitos de información (RI)

### RI-1: Animales
- Como: Operario de Recogida de Animales
- Quiero: Conocer el nombre de cada especie y nombre de cada raza dentro de una especie. Un animal ingresado puede tener un nombre y, opcionalmente, un microchip. Siempre se especificará la fecha y hora del ingreso y una descripción adicional del animal. Si lo ha entregado una persona se la identificará (especificando nombre, dirección y email); en caso contrario se especificará como abandono del animal en la vía pública, describiendo, obligatoriamente, el lugar y hora del hallazgo
- Para: Ingresar cada mascota con la clasificación adecuada y/o conocer datos sobre el hallazgo

### RI-2: Adopciones
- Como: Operario de Adopciones
- Quiero: Registrar adopciones especificando persona que realiza la adopción de un animal disponible y fecha y hora en que se produce
- Para: Dejar constancia de las adopciones realizadas por el CAD

## Reglas de negocio (RN)

### RN-1: Límite de adopciones
- Como: Responsable del CAA
- Quiero: Que una persona no pueda adoptar más de dos animales abandonados en un mes
- Para: Poder evitar que se concentren adopciones en personas

### RN-2: Datos obligatorios según tipo de ingreso
- Como: Responsable de la Oficina
- Quiero: Si un animal es hallado “abandonado” en la vía pública, entonces es obligatorio especificar el “lugar, fecha y hora de encuentro”, en caso contrario se trata de una “entrega” y hay que identificar la persona que la realiza (nombre, dirección y email)
- Para: Facilitar las búsquedas de sus dueños
