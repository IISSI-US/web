# Código de ejercicios

`grades/` pertenece a los laboratorios de IISSI1 y conserva su flujo propio.
Los ejercicios de req2sql migrados se incorporan progresivamente al Makefile.

Los ejecutores de carga y pruebas están aquí, adaptados de silence-db:

```bash
make -C _code load-all
make -C _code run-tests
```

La lista explícita del Makefile contiene los proyectos migrados de req2sql. Las cargas
recrean sus bases de datos. Ejecutarlas en una instancia de prácticas.
`MYSQL` permite configurar el cliente y la conexión.

Alternativa al objetivo `run-tests`, desde `_code`:

```bash
mariadb --abort-source-on-error < runAllTests.sql
```

El script maestro usa la misma conexión, sin lanzar clientes secundarios.

- Aficiones: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/57).

- Pedidos: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/58).

El Makefile detiene la ejecución ante errores en archivos incluidos con SOURCE.

- Empleados: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/59).
