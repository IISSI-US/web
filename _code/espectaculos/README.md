# Espectaculos

Ejercicio de req2sql importado desde `Espectaculos` de IISSI-US/silence-db,
commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`. SQL y pruebas originales
conservados; los ajustes didácticos se realizarán después de la migración.

Desde la raíz de Web:

```bash
(cd _code/espectaculos && mariadb < loadDB.sql)
(cd _code/espectaculos && mariadb < tests.sql)
bash _scripts/export_diagrams.sh espectaculos
```

La carga recrea `EspectaculosDB`. Usar una instancia de prácticas y configurar la
conexión con las opciones habituales de `mariadb`.
Desde este directorio también se puede ejecutar `mariadb < loadDB.sql`,
`mariadb < tests.sql` y `mariadb < queries.sql`.

Los atributos y referencias obligatorios se declaran `NOT NULL`. Los triggers
validan la fecha de compra al insertar o actualizar una entrada, pero no
revalidan entradas existentes cuando se modifica la fecha de una representación;
un cambio de fecha puede dejar una compra posterior a la nueva representación.
La suite usa handlers genéricos `SQLEXCEPTION` para mantener el patrón
introductorio de PASS/FAIL.

La sintaxis de trigger `BEFORE INSERT OR UPDATE` se ha probado con MariaDB
12.3.3. La versión mínima compatible no se ha determinado.

El UML se integra en `_diagrams/espectaculos/diagrams.puml`, con el estilo compartido
`final.iuml`. No se migran el frontend, endpoints ni configuraciones de Silence.

Alcance y limitaciones del refinamiento: [issue #63](https://github.com/IISSI-US/web/issues/63).
