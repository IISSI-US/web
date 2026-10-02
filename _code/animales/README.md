# Animales

Ejercicio de req2sql importado desde `Animales` de IISSI-US/silence-db,
commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`. SQL y pruebas originales
conservados; los ajustes didácticos se realizarán después de la migración.

Desde la raíz de Web:

```bash
make -C _code load-animales
make -C _code test-animales
bash _scripts/export_exercise.sh animales
```

La carga recrea `AnimalesDB`. Usar una instancia de prácticas. Se puede indicar
la conexión mediante `MYSQL="mariadb --socket=/ruta/al/socket -u usuario"`.
Desde este directorio también se puede ejecutar `mariadb < loadDB.sql`,
`mariadb < runTests.sql` y `mariadb < queries.sql`.

El cargador mantiene la selección y el orden del original. Los demás SQL son
auxiliares y no se añaden automáticamente a la carga. `assertTests.sql` exige
los 4 resultados PASS de la suite heredada y convierte fallos o resultados
incompletos en un error del cliente. Esto no amplía su cobertura funcional.

El UML se integra en `_diagrams/animales/diagrams.puml`, con el estilo compartido
`final.iuml`. No se migran el frontend, endpoints ni configuraciones de Silence.

Refinamiento pendiente: [Animales: revisar obligatoriedad, tipos de ingreso y adopciones al actualizar](https://github.com/IISSI-US/web/issues/61).
