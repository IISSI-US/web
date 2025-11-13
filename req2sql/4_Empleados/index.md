---
layout: default
title: Empleados
nav_order: 40
has_children: true
has_toc: false
---

# Empleados
{: .fs-9 }

Sistema de recursos humanos con jerarquías organizacionales y auto-referencias
{: .fs-6 .fw-300 }

---

Este ejercicio modela un sistema de recursos humanos que incluye:

- **Empleados** con información personal y profesional
- **Jerarquías organizacionales** (jefe-subordinado)
- **Departamentos** y asignaciones

**Conceptos de BD cubiertos**: Auto-referencias, jerarquías, agregación, cardinalidades complejas, restricciones temporales.

# Objetivos de Aprendizaje

Al completar este ejercicio serás capaz de:

- ✅ Modelar asociaciones recursivas
- ✅ Implementar jerarquías organizacionales en bases de datos
- ✅ Manejar cardinalidades complejas (1:N recursivas)
- ✅ Aplicar restricciones de integridad en jerarquías
- ✅ Diseñar consultas recursivas con álgebra relacional
- ✅ Implementar triggers para mantener consistencia jerárquica

---

Este ejercicio presenta los siguiente desafíos:

- **Auto-referencias**: Un empleado puede ser jefe de otros empleados
- **Consultas recursivas**: Encontrar todos los subordinados de un jefe
- **Restricciones temporales**: Validar fechas de contratación/promoción
- **Integridad referencial**: Evitar ciclos en la jerarquía

---

Las auto-referencias son conceptualmente complejas. Dedica tiempo extra a entender cómo se modelan antes de pasar al esquema relacional.
