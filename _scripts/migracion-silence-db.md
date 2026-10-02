# Análisis de migración de silence-db

Rama de trabajo: `silence-db`. Análisis del checkout local
`/home/druiz/silence-db`, commit `73eae3ab2c8aed323f825d68bb1096c68c929f1a`.
No se ha contrastado ese commit con el remoto ni ejecutado las bases de datos.

## Alcance y separación de proyectos

Centralizar el SQL y sus pruebas en `_code/`, y las fuentes PlantUML en
`_diagrams/`. Ignorar `_sql/` y los frontends `web/` del origen.
Los proyectos deben poder cargarse y probarse con MariaDB sin el framework
Silence antiguo; no es necesario portar `settings.py`, endpoints ni pruebas HTTP
para este objetivo. Conservar los SQL auxiliares de `sql/`, aunque no participen
en la carga principal, y documentar su uso.

El alcance se limita a los nueve ejercicios enlazados desde
`iissi1/req2sql/index.md`: Usuarios, Aficiones, Pedidos, Empleados, Apartamentos,
Animales, Proyectos, Espectáculos y Bodegas. Aficiones aporta dos proyectos SQL,
por lo que se migran diez proyectos de origen.

**Grados y Bodegas2 quedan fuera de la migración**, al no estar incluidos en ese
índice de ejercicios publicados. La existencia de `10_Grados/` en el árbol no lo
incluye en el alcance. **`_code/grades` corresponde a los laboratorios de IISSI1**:
se conserva junto con `_diagrams/grades` y sus consumidores, sin cambios.

## Inventario y destinos propuestos

Se propone conservar los nombres de los ejercicios en minúsculas. SQL y pruebas
se reunirán en un directorio plano por proyecto, siguiendo la disposición de
`_code/grades`, sin exigir que tengan el mismo modelo de datos.

| Origen | Destino en `_code/` | SQL en sql/ | SQL en tests/ | Bloques UML |
| --- | --- | ---: | ---: | ---: |
| Usuarios | usuarios | 9 | 2 | 3 |
| AficionesEst | aficiones-est | 7 | 2 | 1 |
| AficionesDin | aficiones-din | 7 | 2 | 1 |
| Pedidos | pedidos | 5 | 2 | 2 |
| Empleados | empleados | 17 | 2 | 1 |
| Apartamentos | apartamentos | 5 | 2 | 1 |
| Animales | animales | 5 | 2 | 2 |
| Proyectos | proyectos | 4 | 2 | 1 |
| Espectaculos | espectaculos | 5 | 2 | 1 |
| Bodegas | bodegas | 4 | 2 | 2 |

Los destinos UML usarán el mismo identificador:
`_diagrams/<proyecto>/diagrams.puml`. Se conservan las variantes UML incluidas
en los proyectos seleccionados, como el diagrama de examen de Bodegas, sin
importar por ello el proyecto independiente Bodegas2.

## Dependencias encontradas

- Las nueve páginas incluidas en el alcance contienen 65 referencias al repositorio origen:
  61 fuera de comentarios HTML y cuatro dentro de un comentario sobre
  `_sql/_Usuarios2`. Retirar ese bloque obsoleto sin importar `_sql`.
- El include `_includes/sql-embed.html` ya admite rutas locales y aplica
  `relative_url`. Basta sustituir los `src` por `/_code/<proyecto>/<archivo>` y
  actualizar las etiquetas. `_config.yml` ya publica `_code`.
- Hay un enlace adicional al repositorio en la presentación generada
  `assets/slides/iissi1/t11-sql-avanzado/index.html`. Localizar su fuente y
  regenerar la presentación, o documentar cómo mantener ese artefacto.
  Las coincidencias `silence-db-manager` de IISSI2 son nombres de imágenes y
  títulos sobre el framework, no dependencias del repositorio de ejercicios.
- Las páginas siguen utilizando PNG de `assets/images/iissi1/req2sql/`.
  No basta con copiar las fuentes UML: hay que regenerar y enlazar sus imágenes.
- `md2pdf.typ` actualmente convierte los SQL remotos en enlaces, pero inserta
  el contenido completo cuando el `src` es local. La migración cambiará también
  la longitud y paginación de los PDF; hay que regenerarlos y revisarlos.

## Migración del SQL

1. Copiar `sql/*.sql` y `tests/*.sql` de cada proyecto al destino, detectando
   colisiones de nombres antes de aplanar. Conservar inicialmente nombres y
   contenido para distinguir la migración de cualquier corrección funcional.
2. Revisar cada `SOURCE` y documentar que la ejecución se hace desde el
   directorio del proyecto. Los cargadores actuales usan rutas relativas.
   Se puede normalizar `load_db.sql` a `loadDB.sql` como cambio explícito,
   actualizando sus consumidores y documentación a la vez.
3. Mantener variantes como `version2.sql` y scripts auxiliares identificados;
   no añadirlos indiscriminadamente al cargador principal.
4. Adaptar un ejecutor común de carga y pruebas al nuevo árbol. No copiar sin
   revisión el Makefile ni `runAllTests.sql` del origen, que asumen su estructura.
5. Validar en una instancia MariaDB desechable: carga, población, funciones,
   procedimientos, triggers y pruebas. Comprobar las filas `FAIL`/`ERROR` de
   `test_results`, no solo el código de salida del cliente: algunas pruebas
   capturan excepciones y las convierten en resultados.

## Migración de diagramas

Usar los `uml/` del origen como punto de partida y contrastarlos con los
requisitos publicados. Ya existen diagramas antiguos en `_diagrams/req2sql`,
pero no todos representan las mismas variantes.

Cada proyecto tendrá un único archivo `diagrams.puml` con sus bloques
`@startuml`. Integrar en él las clases, relaciones y restricciones de los
`.iuml` particulares. El único include compartido necesario será
`!include ../estilos/final.iuml`, dentro de cada bloque. Conservar variantes
didácticas y anotaciones específicas, como el resaltado de extensiones de examen.

Un archivo único no implica eliminar vistas: Usuarios tiene tres, Pedidos y
Animales dos y Bodegas dos. Los diagramas de Grados y de los laboratorios quedan
fuera del alcance.

Crear un exportador común en `_scripts/` con una lista explícita de proyectos y
salidas PNG bajo `assets/images/iissi1/req2sql/<proyecto>/`, usando los
identificadores de los bloques UML como nombres de archivo. Las páginas enlazan a
estas salidas y el renderizado queda fijado al exportar, sin depender de las fuentes
disponibles en el navegador o en el generador de PDF.

Retirar los estilos duplicados y `exporta`/`exportaTodo` de
`_diagrams/req2sql`. Aunque el flujo antiguo ya no se utilice, el Makefile todavía
invoca `_scripts/export_req2sql.sh` desde `req2sql-images` e `images`: sustituir
esas conexiones y actualizar `_scripts/README.md` y `_diagrams/README.md`.
Revisar los consumidores de Teoria, BaseDatosPedidos, Usuarios2 y diagramas de
objetos antes de retirar el árbol viejo completo. La limpieza debe preservar
material docente ajeno a los modelos de requisitos migrados.

## Secuencia propuesta y criterios de cierre

1. Importar Usuarios como piloto: SQL, pruebas, tres vistas UML, imágenes y página.
2. Verificar carga y pruebas, publicación local de SQL y compilación del PDF.
3. Migrar el resto por ejercicio, incluyendo las dos versiones de Aficiones y
   excluyendo Grados y Bodegas2.
4. Actualizar la presentación de SQL avanzado y retirar fuentes, estilos y
   exportadores obsoletos después de comprobar todos sus consumidores.
5. Construir Jekyll con baseurl vacío y `/web`; comprobar que todos los `data-src`
   locales e imágenes existen en la salida. Regenerar los PDF afectados.
6. Confirmar que no quedan URLs operativas a silence-db en las nueve páginas
   seleccionadas, su SQL, fuentes de diagramas y artefactos asociados. Las ocho
   referencias de `10_Grados/index.md` quedan fuera de esta migración, al igual que
   sus fuentes y artefactos exclusivos; no se exige eliminarlas para cerrar este
   alcance. Las menciones de procedencia en esta documentación tampoco cuentan
   como dependencias.

La migración estará completa cuando Web permita leer, descargar, cargar y probar
los nueve ejercicios seleccionados y regenerar sus diagramas sin consultar ni tener clonado el repo
origen. Los nueve ejercicios publicados ya están importados en esta rama.
Los ejecutores de carga y pruebas están en `_code/Makefile` y
`_code/runAllTests.sql`, con los diez proyectos correspondientes. Las incidencias
para el refinamiento posterior están registradas en las issues #53–#64 de
IISSI-US/web y enlazadas desde `_code/README.md`.


## Limpieza por ejercicio

La eliminación del UML antiguo forma parte de cada migración, no de una limpieza
final separada. Tras cambiar los consumidores, eliminar el directorio equivalente
de `_diagrams/req2sql/` y sus referencias de exportación. Los nueve ejercicios publicados ya están retirados de ese árbol;
solo se conserva el material ajeno al alcance de esta migración.

Los Markdown de los ejercicios no recibirán instrucciones de ejecución ni texto
nuevo durante la migración. Solo se adaptarán referencias a los recursos migrados
y se retirarán referencias obsoletas; la documentación operativa queda en `_code/`.


## Estado tras migrar los nueve ejercicios publicados

Usuarios fue confirmado en `649369a`; el resto se ha trasladado con un commit por
cada ejercicio (Aficiones incluye estática y dinámica). Los SQL originales se
conservan, con cargadores y ejecutores en `_code/`. Todos los UML de los nueve
ejercicios se han retirado de `_diagrams/req2sql/` y sustituido por archivos únicos
con el estilo compartido. `make req2sql-images` exporta los diez proyectos locales.

El material residual de `_diagrams/req2sql/` (Grados, Usuarios2, Teoria y
BaseDatosPedidos, junto con sus utilidades/estilos antiguos) queda fuera de esta
migración. No se ha alterado `_code/grades` ni `_diagrams/grades`.

Las incidencias de refinamiento de los ocho ejercicios restantes están enlazadas
en `_code/README.md`. Las suites heredadas no equivalen a una validación completa
de los requisitos; las correcciones funcionales se harán en la fase posterior.
