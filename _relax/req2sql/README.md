# Datasets RELAX de Req2SQL

Estos ficheros son la fuente local de los datasets publicados como Gists
para abrirlos desde RELAX.

Convenciones:

- Se usa la sintaxis RELAX simple ya empleada en los Gists originales de
  Usuarios y Pedidos.
- Los nombres de atributos y valores de texto se normalizan a ASCII.
- Las fechas se escriben sin comillas cuando son fechas simples.
- Las marcas de fecha y hora se dejan como cadenas.
- `null` se escribe sin comillas.
- Un nombre de atributo solo se repite entre relaciones cuando representa la
  misma clave de unión. Los demás atributos usan nombres contextualizados
  (`nombreEmpleado`, `direccionAlojamiento`, etc.) para que el `natural join`
  no añada condiciones accidentales.

El ejercicio `10_Grados` no tiene extensión de datos en el enunciado actual,
por lo que no se genera dataset RELAX hasta disponer de una extensión.
