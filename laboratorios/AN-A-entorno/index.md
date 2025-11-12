---
layout: single
title: Anexo A · Entorno de trabajo
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
---

<!-- # Anexo A: Entorno de trabajo -->

## Objetivo
El objetivo de esta práctica es configurar el entorno de trabajo inicial para el desarrollo de la asignatura. El alumno aprenderá a:

- Instalar MariaDB y HeidiSQL.
- Crear conexiones con BBDD locales.
- Crear usuarios para las BBDD.
- Cargar y ejecutar un script SQL.
- Ejecutar una consulta simple sobre una BD.
- Instalar y configurar Python.
- Instalar Visual Studio Code y extensiones relacionadas.
- Instalar y configurar Git.

---

## Instalación de MariaDB y HeidiSQL

Durante el curso usaremos MariaDB, un *fork* de MySQL que comparte sus mismas funciones pero tiene una licencia más permisiva. En esta sección se explica su instalación para Windows, cuyo instalador puede encontrarse [aquí](https://mariadb.org/download/).

En Linux, puede instalarse el paquete `mariadb-server` usando `apt` o el gestor de paquetes correspondiente. En macOS, se puede instalar MariaDB usando Homebrew, como se explica [aquí](https://mariadb.com/kb/en/installing-mariadb-on-macos-using-homebrew/). El cliente HeidiSQL sólo está disponible para Windows, en otros SO pueden usarse alternativas como [MySQL Workbench](https://www.mysql.com/products/workbench/) o [DBeaver](https://dbeaver.io/).

Accederemos a la [página de descargas de MariaDB](https://mariadb.org/download/) y descargaremos e iniciaremos el instalador para Windows. Cuando se nos pregunte, dejaremos marcadas todas las características a instalar:

![Instalación MariaDB 1](/assets/images/laboratorios/fig/lab1-0/mariadb_install_1.png)

A continuación se nos preguntará por la contraseña del usuario *root* (administrador). Para nuestra BD usaremos la contraseña `iissi$root`:

![Instalación MariaDB 2](/assets/images/laboratorios/fig/lab1-0/mariadb_install_2.png)

> Por favor verifique que introduce la contraseña iissi$root correctamente para evitar problemas más adelante.

Aceptaremos las opciones por defecto a partir de este diálogo y esperaremos a que finalice la instalación, tras lo cual habrán quedado instalados tanto MariaDB como el cliente HeidiSQL.

---

## Creación de una conexión con HeidiSQL

Para trabajar con MariaDB usaremos el cliente HeidiSQL, que debería estar instalado si se han seguido adecuadamente las pautas de la sección anterior. Ejecutamos HeidiSQL y creamos una nueva sessión, a la que llamaremos `IISSI_ROOT`, en la que indicaremos los datos de acceso del usuario root que hemos configurado anteriormente:

![HeidiSQL sesión 2](/assets/images/laboratorios/fig/lab1-0/hs-2.png)

Tendremos acceso a todas las BD que tiene el SGBD. Las que aparecen por defecto (information_schema, mysql y performance_schema) son propias del SGBD y no deben ser modificadas manualmente.

![HeidiSQL sesión 3](/assets/images/laboratorios/fig/lab1-0/hs-3.png)

---

## Creación de una base de datos

Una "base de datos" o "database" en MariaDB (también llamada "schema") es un conjunto de tablas, que normalmente se corresponde con un proyecto o aplicación concreto. Mediante el uso de databases, se pueden tener varias aplicaciones con conjuntos diferentes de tablas funcionando sobre un mismo SGBD.

Como ejemplo, crearemos la base de datos "grados". Para ello, usando el usuario *root*, accederemos a la pestaña "Consulta" y ejecutaremos `CREATE DATABASE grados;`, tras ello, pulsaremos **F9** para ejecutar nuestra consulta:

![Crear database](/assets/images/laboratorios/fig/lab1-0/crearDatabase.png)

Si pulsamos sobre la conexión y la actualizamos mediante **F5**, podremos ver que se ha creado la base de datos "grados":

![Grados creada](/assets/images/laboratorios/fig/lab1-0/grados.png)

Sin embargo, realizar todas las operaciones con el usuario *root* no es aconsejable. En la siguiente sección, crearemos un nuevo usuario para operar con la base de datos recién creada.

---

## Creación de usuarios

Operar directamente con el usuario *root* está altamente desaconsejado, ya que éste tiene permisos ilimitados sobre el SGBD, y cualquier error cometido puede resultar potencialmente grave. En su lugar, crearemos un usuario y le otorgaremos los permisos adecuados para poder crear y manipular bases de datos.

Crearemos un usuario usando Herramientas → Administrador de usuarios:

![Administrador de usuarios](/assets/images/laboratorios/fig/lab1-0/adminUsuarios.png)

Pulsamos en ![Agregar usuario](/assets/images/laboratorios/fig/lab1-0/agregarUsuario.png) y creamos un nuevo usuario con nombre `iissi_user` y clave `iissi$user`. En "Desde el host" se deja marcado "localhost", lo cual indica que el usuario a crear sólo podrá ser accedido desde nuestra máquina, no por conexiones remotas.

En la parte inferior podremos asignarle permisos al usuario que vamos a crear. Es aconsejable otorgar los mínimos permisos imprescindibles, por lo que el nuevo usuario sólo tendrá permisos para modificar la base de datos "grados". Para otorgarle permisos en la BD que acabamos de crear, la seleccionamos en ![Agregar objeto](/assets/images/laboratorios/fig/lab1-0/agregarObjeto.png) y marcamos todos los permisos.

![Crear usuario](/assets/images/laboratorios/fig/lab1-0/crearUsuario.png)

Finalmente, pulsaremos en "Guardar" para registrar el nuevo usuario.

> Por favor verifique que introduce correctamente el usuario iissi_user y la contraseña iissi$user, sobre todo si lo copia y pega.

---

## Conexión con el nuevo usuario

Crearemos una nueva conexión “IISSI_USER” para el usuario que acabamos de crear, que será la que usaremos para trabajar con nuestras bases de datos:

![HeidiSQL sesión 6](/assets/images/laboratorios/fig/lab1-0/hs-6.png)

En esta sesión sólo se tiene acceso a las BD del usuario, no a las del sistema:

![HeidiSQL sesión 7](/assets/images/laboratorios/fig/lab1-0/hs-7.png)

---

## Ejecutar script de prueba

Para importar datos en la BD que acabamos de crear, utilizaremos el archivo [grados.sql](https://github.eii.us.es/IISSI-2223/IISSI1-ArchivosAuxiliares/blob/main/laboratorio/sql/grados.sql). 
Seleccionamos. Archivo → “Cargar archivo SQL” → grados.sql (Ejecutar **F9**, "Enviar lote de una sola vez"). Durante su ejecución se pueden producir advertencias, pero no es algo inusual.

Al actualizar usando **F5**, podrá comprobar que se ha creado una nueva tabla "Asignaturas" en la BD "Grados".

Podemos ejecutar una consulta SQL para obtener el nombre, el número de créditos y el tipo de las asignaturas impartidas por el departamento "LENGUAJES Y SISTEMAS INFORMÁTICOS" usando la pestaña "Consulta":

```sql
SELECT nombre, creditos, tipo
FROM Asignaturas
WHERE departamento = "LENGUAJES Y SISTEMAS INFORMÁTICOS";
```

![Consulta asignaturas](/assets/images/laboratorios/fig/lab1-0/hs-8.png)

---

## Instalación y configuración de Python
> Nota: si se tiene Python instalado mediante Anaconda, es posible que surjan problemas de compatibilidad. En ese caso, se recomienda desinstalar Anaconda antes de proceder.

Python es necesario para usar el framework Silence, que se empleará al final de IISSI-1 y durante IISSI-2. Descargamos e instalamos la versión 3.X más reciente de [Python](https://www.python.org/downloads/). Seleccionamos personalizar instalación ("customize installation"). **Es importante marcar antes la opción "Add Python 3.X to PATH":**

![Instalación Python](/assets/images/laboratorios/fig/lab1-0/python.png)

Entre las opciones de instalación opcionales, **dejamos marcadas todas las opciones**:

![Opciones Python](/assets/images/laboratorios/fig/lab1-0/python-opt.png)

Marcamos las siguientes opciones avanzadas:

![Opciones avanzadas Python](/assets/images/laboratorios/fig/lab1-0/python-opt-2.png)

Una vez concluya la instalación, podemos comprobar que ésta ha sido correcta abriendo una consola y consultando la versión de Python instalada mediante `python --version`:

![Comprobar Python](/assets/images/laboratorios/fig/lab1-0/pycheck.png)

Igualmente, comprobaremos que pip, el gestor de paquetes de Python, está correctamente instalado, ya que lo necesitaremos más adelante. Para ello podemos ejecutar `pip --version`:

![Comprobar pip](/assets/images/laboratorios/fig/lab1-0/pipcheck.png)

---

## Instalación de Visual Studio Code

Como editor de código se usará [Visual Studio Code](https://code.visualstudio.com/). Descargamos el instalador y lo ejecutamos. Mantenemos las opciones en sus valores por defecto e iniciamos Visual Studio Code una vez finalice la instalación:

![VS Code](/assets/images/laboratorios/fig/lab1-0/VSC.png)

Accedemos a File → Preferences → Extensions, seleccionamos la [extensión de Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python) y la instalamos:

![VS Code Python](/assets/images/laboratorios/fig/lab1-0/VSC-python.png)

Asimismo, instalaremos también la [extensión REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client):

![VS Code REST Client](/assets/images/laboratorios/fig/lab1-0/VSC-REST.png)

---

## Instalación de Git
Git es un sistema de control de versiones que usaremos a lo largo de IISSI-1 y 2 para descargar material relacionado con la asignatura, registrar nuestros cambios y mantener una copia de ellos en GitHub.

Para instalar Git, por favor, consulte el [boletín auxiliar de Git y GitHub](https://github.eii.us.es/IISSI-2223/IISSI1-ArchivosAuxiliares/blob/main/laboratorio/Git.pdf) que está publicado. 

Si desea consultar las nociones básicas sobre el funcionamiento de repositorios GitHub, en el boletín [Flujo de trabajo con GitHub](https://github.eii.us.es/IISSI-2223/IISSI1-ArchivosAuxiliares/blob/main/laboratorio/FlujoGitHub.pdf) se describe cómo crear una cuenta y gestionar un repositorio. En este boletín se utiliza una versión de GitHub de la escuela, que puede encontrarse en [https://github.eii.us.es](https://github.eii.us.es)
