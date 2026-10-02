# Usuarios

SQL del ejercicio publicado en req2sql, importado de Usuarios en el commit
`73eae3ab2c8aed323f825d68bb1096c68c929f1a` de IISSI-US/silence-db.
No necesita el framework Silence.

Desde la raíz de Web:

```bash
make -C _code load-usuarios
make -C _code test-usuarios
```

La carga recrea `UsersDB`: usar una instancia de prácticas. Para indicar otra
conexión, pasar `MYSQL="mariadb --socket=/ruta/al/socket -u usuario"` a make.
También se puede ejecutar `mariadb < loadDB.sql` y `mariadb < runTests.sql`
desde `_code/usuarios`. Las consultas se ejecutan desde ese mismo directorio
con `mariadb < queries.sql`.

`loadDB.sql` carga esquema, trigger, funciones y población. `runTests.sql`
comprueba que las dos pruebas heredadas produzcan PASS y genera un error si no.
`version2.sql` es un ejemplo parcial sobre fechas de nacimiento: no transforma
el esquema base. `avatars.sql` es una extensión opcional; sus imágenes del frontend
no forman parte de la migración. Ninguno de estos dos archivos se carga por defecto.

Las tres vistas UML (base, tutores y parejas) están integradas en
`_diagrams/usuarios/diagrams.puml` y usan el estilo compartido `final.iuml`.
Desde la raíz de Web: `bash _scripts/export_exercise.sh usuarios`.
La página utiliza la vista base; las ampliaciones se conservan como recursos.

## Pendiente de refinamiento

Se conserva la lógica SQL del origen. Discrepancias detectadas:

- RI-1 y PA-2 permiten omitir el género, pero el SQL lo declara NOT NULL.
- La explicación de SQL avanzado describe un trigger para fecha de nacimiento,
  pero `tCheckAge.sql` comprueba `age`. `version2.sql` no implementa esa validación
  y mantiene comentadas la tabla y población alternativas.
- Las pruebas heredadas verifican edad mínima y correo repetido; no cubren todas
  las pruebas de aceptación publicadas.

Incidencias registradas para la revisión posterior:

- [Usuarios: alinear el género opcional entre requisitos, UML y SQL](https://github.com/IISSI-US/web/issues/53)
- [Usuarios: completar y alinear la variante de fecha de nacimiento](https://github.com/IISSI-US/web/issues/54)
- [Usuarios: ampliar las pruebas para cubrir los criterios de aceptación](https://github.com/IISSI-US/web/issues/55)
- [Usuarios: reconciliar requisitos funcionales y consultas SQL de referencia](https://github.com/IISSI-US/web/issues/56)
