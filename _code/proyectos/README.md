# Proyectos

Ejercicio de req2sql importado desde `Proyectos` de IISSI-US/silence-db,
commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`. SQL y pruebas originales
conservados; los ajustes didácticos se realizarán después de la migración.

Desde la raíz de Web:

```bash
(cd _code/proyectos && mariadb < loadDB.sql)
(cd _code/proyectos && mariadb < tests.sql)
bash _scripts/export_diagrams.sh proyectos
```

La carga recrea `ProyectosDB`, instala los triggers de integridad y carga los
datos positivos. Usar una instancia de prácticas y configurar la conexión con
las opciones habituales de `mariadb`.
Desde este directorio también se puede ejecutar `mariadb < loadDB.sql`,
`mariadb < tests.sql` y `mariadb < queries.sql`.

`loadDB.sql` aplica el esquema, instala los triggers y carga el ejemplo. Estos
impiden solapar periodos de una tarea y vincular tareas de proyectos distintos.
`tests.sql` muestra los resultados PASS/FAIL/ERROR para que el alumnado los
revise.

El UML se integra en `_diagrams/proyectos/diagrams.puml`, con el estilo compartido
`final.iuml`. No se migran el frontend, endpoints ni configuraciones de Silence.

Refinamiento pendiente: [Proyectos: alinear datos del proyecto, asignaciones, historial y jerarquía de tareas](https://github.com/IISSI-US/web/issues/62).
