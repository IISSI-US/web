---
layout: default
title: Requisitos
parent: Bodegas
nav_order: 1
---

# Catálogo de Requisitos 

## Requisitos de información (RI)

### RI-1: Bodega
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de las bodegas: nombre y denominación de origen.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

### RI-2: Vino
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de los vinos: nombre, grados de alcohol y Uvas que lo componen. Los vinos pueden ser de Jóvenes o Crianzas, en función al tiempo que pasen en barrica y botella. Además, para los vinos Crianzas, se debe almacenar las cosechas.
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

### RI-3: Uvas
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de las uvas: nombre (Tempranillo, Garnacha, Carbernet Sauvignon, ...)
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

### RI-4: Cosechas
- Como: Profesor de la asignatura
- Quiero: Poder almacenar la siguiente información de las cosechas: año y calidad (Excelente, Muy buena, Buena, Normal, Mala)
- Para: Que el estudiante realice a partir de este requisito el modelo conceptual, relacional y tecnológico.

## Reglas de negocio (RN)

### RN-1: Unicidad
- Como: Profesor de la asignatura
- Quiero: Que no se repitan el nombre de las bodegas, vinos o uvas en el sistema
- Para: Que el estudiante practique con restricciones simples.

### RN-2: Tiempo de crianza
- Como: Profesor de la asignatura
- Quiero: Que el tiempo de crianza de un vino Crianza sea de al menos 24 meses, de los cuales entre 6 y 12 meses son en barrica y el resto en botella. El vino joven generalmente no pasa tiempo en barrica, o si lo hace, es muy breve (menos de 6 meses)
- Para: Que el estudiante practique con restricciones simples.

### RN-3: Graduación alcohólica
- Como: Profesor de la asignatura
- Quiero: Que la graduación alcohólica de un vino suele estar entre los 10 y 15 grados
- Para: Que el estudiante practique con restricciones complejas.

### RN-4: Cosechas
- Como: Profesor de la asignatura
- Quiero: Cada vino de crianza tiene como máximo una cosecha por año, y tiene al menos una cosecha
- Para: Que el estudiante practique con restricciones complejas.

## Requisitos funcionales (RF)

### RF-1: Informes simples de Bodegas
- Como: Profesor de la asignatura
- Quiero: Seleccionar todas las bodegas con denominación de origen Rioja. Listado de vinos con sus uvas. Crianazas con sus cosechas. Mostrar todas las bodegas que producen vinos tanto jóvenes como crianzas. Nombre de las bodegas y vinos que están compuestos, al menos, con uva 'Tempranillo'. Total de crianzas por cosecha. Nombre del vino joven con más grados
- Para: Que el estudiante practique con consultas simples.

## Pruebas de aceptación (PA)

### PA-1: Bodegas
1. ✅ Crear una nueva bodega con todos los datos correctos según las reglas de negocio
2. ❌ Crear una nueva bodega sin nombre.
3. ❌ Crear una nueva bodega con el nombre repetido.
4. ❌ Crear una nueva bodega sin denominación de origen.


### PA-2: Vinos
1. ✅ Crear un nuevo vino Joven con todos los datos correctos según las reglas de negocio
2. ✅ Crear un nuevo vino Crianza con todos los datos correctos según las reglas de negocio
3. ❌ Crear un nuevo vino Joven sin nombre.
4. ❌ Crear un nuevo vino Crianza sin nombre.
5. ❌ Crear un nuevo vino Joven con el nombre repetido.
6. ❌ Crear un nuevo vino Crianza con el nombre repetido.
7. ❌ Crear un nuevo vino Joven sin grados de alcohol.
8. ❌ Crear un nuevo vino Crianza sin grados de alcohol.
9. ❌ Crear un nuevo vino Joven con graduación incorrecta.
10. ❌ Crear un nuevo vino Crianza con graduación incorrecta.
11. ❌ Crear un nuevo vino Joven sin bodega.
12. ❌ Crear un nuevo vino Crianza sin bodega.
