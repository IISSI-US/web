# Usuarios

SQL del ejercicio publicado en req2sql, importado de Usuarios en el commit
`73eae3ab2c8aed323f825d68bb1096c68c929f1a` de IISSI-US/silence-db.
No necesita el framework Silence.

Desde la raíz de Web:

```bash
(cd _code/usuarios && mariadb < loadDB.sql)
(cd _code/usuarios && mariadb < tests.sql)
```

La carga recrea `UsersDB`: usar una instancia de prácticas y configurar la
conexión con las opciones habituales de `mariadb`.
También se puede ejecutar `mariadb < loadDB.sql` y `mariadb < tests.sql`
desde `_code/usuarios`. Las consultas se ejecutan desde ese mismo directorio
con `mariadb < queries.sql`.

`loadDB.sql` carga esquema, trigger, funciones y población. Los ejemplos válidos
están en la población; `tests.sql` ejecuta las cinco pruebas negativas y
muestra sus resultados PASS/FAIL/ERROR para revisión manual.
`version2.sql` crea y carga una variante ejecutable en `Users_v2DB`, independiente
de `UsersDB`; `tests_v2.sql` prueba el límite de 18 años y las fechas futuras.
Ejecutar `mariadb < version2.sql` y luego `mariadb < tests_v2.sql` desde este
directorio. `avatars.sql` es una extensión
opcional; sus imágenes del frontend no forman parte de la migración y no se carga
por defecto.

Las tres vistas UML (base, tutores y parejas) están integradas en
`_diagrams/usuarios/diagrams.puml` y usan el estilo compartido `final.iuml`.
Desde la raíz de Web: `bash _scripts/export_diagrams.sh usuarios`.
La página utiliza la vista base; las ampliaciones se conservan como recursos.

## Pendiente de refinamiento

Incidencias registradas para la revisión posterior:

- [Usuarios: ampliar las pruebas para cubrir los criterios de aceptación](https://github.com/IISSI-US/web/issues/55)
- [Usuarios: reconciliar requisitos funcionales y consultas SQL de referencia](https://github.com/IISSI-US/web/issues/56)
