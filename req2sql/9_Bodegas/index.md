---
layout: default
title: Bodegas
nav_order: 80
has_children: true
has_toc: false
---

# Bodegas
{: .fs-9 }


Este ejercicio modela un sistema de gestión bodegas con vinos con denominación de origen.

**Conceptos de BD cubiertos**: Múltiples versiones de modelado.

---

# Objetivos de Aprendizaje

Al completar este ejercicio serás capaz de:

- ✅ Comparar diferentes estrategias de modelado relacional
- ✅ Evaluar trade-offs entre versiones de esquemas
- ✅ Aplicar restricciones de integridad avanzadas

---

# Características 

- **Dos versiones de modelado**: Permite comparar diferentes enfoques de herencia
- **Doble implementación**: SQL para ambas versiones relacionales
- **Múltiples tipos de pruebas**: SQL y HTTP

---

# Comparación de Versiones

| Aspecto | Versión 1 | Versión 2 |
|---------|-----------|----------|
| **Enfoque** | Una tabla por jerarquía | Una tabla por subclase |
| **Ventajas** | Menos tablas, consultas simples | Mayor especialización |
| **Desventajas** | Atributos NULL | Más tablas, JOINs complejos |
| **Uso ideal** | Jerarquías simples | Especializaciones marcadas |

---

**Sugerencia**: Este es el ejercicio más completo y avanzado. Compara cuidadosamente las dos versiones para entender cuándo usar cada enfoque de modelado relacional.
