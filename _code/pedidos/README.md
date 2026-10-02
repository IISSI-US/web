# Pedidos

Ejercicio de req2sql importado desde `Pedidos` de IISSI-US/silence-db,
commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`. SQL y pruebas originales
conservados; los ajustes didácticos se realizarán después de la migración.

Desde la raíz de Web:

```bash
make -C _code load-pedidos
make -C _code test-pedidos
bash _scripts/export_exercise.sh pedidos
```

La carga recrea `OrdersDB`. Usar una instancia de prácticas. Se puede indicar
la conexión mediante `MYSQL="mariadb --socket=/ruta/al/socket -u usuario"`.
Desde este directorio también se puede ejecutar `mariadb < loadDB.sql`,
`mariadb < runTests.sql` y `mariadb < queries.sql`.

El cargador mantiene la selección y el orden del original. Los demás SQL son
auxiliares y no se añaden automáticamente a la carga. `assertTests.sql` exige
los 8 resultados PASS de la suite heredada y convierte fallos o resultados
incompletos en un error del cliente. Esto no amplía su cobertura funcional.

El UML se integra en `_diagrams/pedidos/diagrams.puml`, con el estilo compartido
`final.iuml`. No se migran el frontend, endpoints ni configuraciones de Silence.

Refinamiento pendiente: [Pedidos: implementar y probar las reglas publicadas de pedidos y stock](https://github.com/IISSI-US/web/issues/58).
