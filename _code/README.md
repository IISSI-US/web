# Código de ejercicios

`grades/` pertenece a los laboratorios de IISSI1 y conserva su flujo propio.
El piloto de migración de req2sql está en `usuarios/`.

Los ejecutores de carga y pruebas están aquí, adaptados de silence-db:

```bash
make -C _code load-all
make -C _code run-tests
```

La lista explícita del Makefile incluye únicamente Usuarios por ahora. Las cargas
recrean sus bases de datos. Ejecutarlas en una instancia de prácticas.
`MYSQL` permite configurar el cliente y la conexión.

Alternativa al objetivo `run-tests`, desde `_code`:

```bash
mariadb < runAllTests.sql
```

El script maestro usa la misma conexión, sin lanzar clientes secundarios.
