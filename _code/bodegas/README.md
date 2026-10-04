# Bodegas

Ejercicio de req2sql importado desde `Bodegas` de IISSI-US/silence-db,
commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`. SQL y pruebas originales
conservados; los ajustes didácticos se realizarán después de la migración.

Desde la raíz de Web:

```bash
(cd _code/bodegas && mariadb < loadDB.sql)
(cd _code/bodegas && mariadb < tests.sql)
bash _scripts/export_diagrams.sh bodegas
```

La carga recrea `BodegasDB`, instala las restricciones adicionales y carga los
datos positivos de ejemplo. Usar una instancia de prácticas y configurar la
conexión con las opciones habituales de `mariadb`.
Desde este directorio también se puede ejecutar `mariadb < loadDB.sql`,
`mariadb < tests.sql` y `mariadb < queries.sql`.

El cargador instala triggers de disjunción antes de cargar el ejemplo. La suite
contiene casos negativos de las RN; cada test restablece el populate y muestra
el resultado PASS/FAIL/ERROR. Con esta traducción por tres tablas, el populate
incluye cosechas para cada Crianza; el esquema no puede imponer esa existencia
mínima frente a inserciones manuales arbitrarias.

El UML se integra en `_diagrams/bodegas/diagrams.puml`, con el estilo compartido
`final.iuml`. No se migran el frontend, endpoints ni configuraciones de Silence.

Refinamiento pendiente: [Bodegas: alinear tiempos de crianza, especialización y cosechas](https://github.com/IISSI-US/web/issues/64).
