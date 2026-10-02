# Aficiones-1N

Ejercicio de req2sql importado desde `AficionesEst` de IISSI-US/silence-db,
commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`. El género es opcional,
como especifica el requisito heredado de Usuarios; `populateDB.sql` incluye un
usuario sin género y `tests.sql` contiene solo pruebas negativas.

Desde la raíz de Web:

```bash
(cd _code/aficiones-1n && mariadb < loadDB.sql)
(cd _code/aficiones-1n && mariadb < tests.sql)
bash _scripts/export_diagrams.sh aficiones-1n
```

La carga recrea `Hobbies1NDB`, con catálogo cerrado y relación 1:N. Usar una instancia de prácticas. Se puede indicar
la conexión con las opciones habituales de `mariadb`.
Desde este directorio también se puede ejecutar `mariadb < loadDB.sql`,
`mariadb < tests.sql` y `mariadb < queries.sql`.

El cargador mantiene la selección y el orden del original. Los demás SQL son
auxiliares y no se añaden automáticamente a la carga. `tests.sql` muestra los
resultados PASS/FAIL/ERROR para que el alumnado los revise.

El UML se integra en `_diagrams/aficiones-1n/diagrams.puml`, con el estilo compartido
`final.iuml`. No se migran el frontend, endpoints ni configuraciones de Silence.

Refinamiento pendiente: [Aficiones: alinear el género opcional y las pruebas en ambas variantes](https://github.com/IISSI-US/web/issues/57).
