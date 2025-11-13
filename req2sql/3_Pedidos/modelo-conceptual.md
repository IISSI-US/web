---
layout: default
title: Modelo Conceptual
parent: Pedidos
nav_order: 2
---

# Modelo conceptual

## Diagrama de clases 

El modelo extiende el dominio de Usuarios incorporando las entidades Producto y Pedido para gestionar un sistema de comercio básico.

- **Entidades principales**: Usuario, Producto, Pedido.
- **asociaciones**: Un Usuario puede realizar 0..* Pedidos; un Pedido pertenece a 1 Usuario. Un Pedido incluye 1..* Productos; un Producto puede estar en 0..* Pedidos.
- **Restricciones de negocio**: Stock suficiente antes de crear pedido; máximo 3 pedidos por día por usuario; no pedidos en agosto.

![Diagrama de clases]({{ '/assets/images/req2sql/Pedidos/pedidos-dc.png' | relative_url }})

## Diagrama de objetos

Los objetos ejemplifican escenarios típicos de uso del sistema de pedidos con diferentes patrones de compra.

- **Instancias de usuarios**: Varios usuarios (u1,u2) con pedidos realizados en fechas diferentes.
- **Productos**: Artículos con stock y precio variable (p1,p2,p3).
- **Pedidos**: Diferentes cantidades, fechas válidas (no agosto), respetando límite diario (se utiliza la notación para objetos anónimos _).
- **Vínculos**: Conexiones entre usuarios-pedidos y pedidos-productos mostrando las cardinalidades del modelo.

![Diagrama de objetos]({{ '/assets/images/req2sql/Pedidos/pedidos-do.png' | relative_url }})