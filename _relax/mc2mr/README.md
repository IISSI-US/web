# Datasets RELAX de MC2MR

Estos ficheros son la fuente local de los datasets que se publicarán como Gists
para abrirlos desde RELAX.

Convenciones:

- Los nombres de relaciones, atributos y valores de texto usan ASCII.
- Las fechas usan formato ISO sin comillas: `YYYY-MM-DD`.
- Los booleanos y nulos usan `true`, `false` y `null` sin comillas.
- Los identificadores y cadenas se escriben con comillas dobles.
- Un nombre de atributo solo se repite entre relaciones cuando representa la
  misma clave de unión. Los demás atributos usan nombres contextualizados
  (`nombreAutor`, `nombreCurso`, etc.) para que el `natural join` no añada
  condiciones accidentales.

El contenido debe mantenerse coherente con las extensiones publicadas en los
ejercicios de `iissi1/mc2mr`.
