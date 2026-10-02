# Código de ejercicios

`grades/` pertenece a los laboratorios de IISSI1 y conserva su flujo propio.
Los nueve ejercicios publicados de req2sql están migrados; Aficiones incluye
las variantes estática y dinámica, para un total de diez proyectos.

Cada ejercicio se carga y se prueba desde su propio directorio:

```bash
cd _code/<ejercicio>
mariadb < loadDB.sql
mariadb < tests.sql
```

Las cargas recrean sus bases de datos; ejecutarlas en una instancia de prácticas.
Usar las opciones habituales de `mariadb` para configurar la conexión.

Para ejecutar todas las suites en lote, desde `_code`:

```bash
mariadb --abort-source-on-error < runAllTests.sql
```

El script maestro usa la misma conexión, sin lanzar clientes secundarios, y se
detiene ante errores en archivos incluidos con `SOURCE`.

## Refinamiento pendiente

- Usuarios: incidencias [#55](https://github.com/IISSI-US/web/issues/55) y [#56](https://github.com/IISSI-US/web/issues/56).
- Aficiones: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/57).
- Pedidos: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/58).
- Empleados: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/59).
- Apartamentos: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/60).
- Animales: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/61).
- Proyectos: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/62).
- Espectaculos: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/63).
- Bodegas: migrado; [incidencias para refinamiento](https://github.com/IISSI-US/web/issues/64).
