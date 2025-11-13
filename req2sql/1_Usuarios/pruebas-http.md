---
layout: default
published: false
title: Pruebas HTTP
parent: Usuarios
nav_order: 5
---

# Pruebas de aceptación

Para llevar a cabo las pruebas HTTP usaremos silence, que nos facilitará la labor. Hay que tener en cuenta los siguientes aspectos:

- Configurar el proyecto para trabajar con la BD de Usuarios. En el archivo `settings.py` hay que proporcionar los datos de la conexión a la BD y los archivos SQL para crear la BD.
- Ejecutar `silence createdb`.
- Ejecutar `silence createapi`. Esto crea un archivo JSON en la carpeta `endpoints/auto` por cada tabla en la que se define el API Rest para acceder a la BD.
- En el primer cuatrimestre no usamos autenticación, por lo que hay que modificar el API creado automáticamente, haciendo una copia, para poner el atributo `auth_required` a false en todos los casos.
- Ejecutar `silence createtest`. Este comando crea un archivo `.http` en la carpeta `tests/auto` para cada tabla de la BD. Estos tests generados automáticamente sirven de guía para personalizar los tests.

A partir de las pruebas de aceptación definidas en el catálogo de requisitos las peticiones HTTP serían:

<div class="http-file" data-src="{{ '/silence-db/tests/Usuarios/usuarios.http' | relative_url }}"></div>

La respuesta que se obtendría para cada petición es la siguiente:

<div class="http-file" data-src="{{ '/silence-db/tests/Usuarios/usuarios.response' | relative_url }}"></div>
