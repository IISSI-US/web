# Pedidos

Ejercicio de req2sql importado desde `Pedidos` de IISSI-US/silence-db,
commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`. SQL y pruebas originales
conservados; los ajustes didácticos se realizarán después de la migración.

Desde la raíz de Web:

```bash
(cd _code/pedidos && mariadb < loadDB.sql)
(cd _code/pedidos && mariadb < tests.sql)
bash _scripts/export_diagrams.sh pedidos
```

La carga recrea `OrdersDB`. Usar una instancia de prácticas y configurar la
conexión con las opciones habituales de `mariadb`.
Desde este directorio también se puede ejecutar `mariadb < loadDB.sql`,
`mariadb < tests.sql` y `mariadb < queries.sql`.

El cargador mantiene la selección y el orden del original. Los demás SQL son
auxiliares y no se añaden automáticamente a la carga. `tests.sql` muestra los
resultados PASS/FAIL/ERROR para que el alumnado los revise.

El UML se integra en `_diagrams/pedidos/diagrams.puml`, con el estilo compartido
`final.iuml`. No se migran el frontend, endpoints ni configuraciones de Silence.

Refinamiento pendiente: [Pedidos: implementar y probar las reglas publicadas de pedidos y stock](https://github.com/IISSI-US/web/issues/58).
