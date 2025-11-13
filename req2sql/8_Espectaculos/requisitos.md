---
layout: default
published: false
title: Requisitos
parent: Espectáculos
nav_order: 1
---

# Catálogo de Requisitos 

La transcripción que aparece a continuación corresponde a una entrevista realizada al gerente de un teatro para determinar los objetivos y requisitos de una aplicación web que gestione la programación anual de espectáculos y venta de entradas a dichos espectáculos.

## Entrevista

- Cuestión: Para empezar, hábleme de los espectáculos. Me interesa conocer la información que debe gestionarse por parte de la aplicación web.
  - Respuesta: De acuerdo, los espectáculos que se programan en nuestro teatro pueden ser de distinto tipo (p.e. “Concierto”, “Opera”, .. ). Cada espectáculo es de un tipo.

- Cuestión: ¿Qué información desea recoger de los espectáculos?
  - Respuesta: Básicamente, su denominación, tipo, duración y fecha y hora en las que se representan. Un espectáculo puede tener varias representaciones.

- Cuestión: ¿Puede haber más de una representación el mismo día?
  - Respuesta: Sí, hay días con más de una representación pero nunca del mismo espectáculo.

- Cuestión: ¿Algo más acerca de los espectáculos?
  - Respuesta: Se me olvidaba, también quiero guardar el precio. Cada tipo de espectáculo tiene un precio de la entrada.

- Cuestión: ¿El precio varía según tipo de espectáculo?
  - Respuesta: Sí, pero también depende de la zona del teatro donde esté situada la localidad.

- Cuestión: Acláreme esto, por favor.
  - Respuesta: El teatro está dividido en zonas. Las localidades más caras corresponden a la zona mejor situada, es decir la zona de “Patio”. Otras zonas son "1 de Balcón", "1 de Terraza" etc. Cada zona tiene distinto precio.

- Cuestión: En definitiva ¿el precio depende del tipo de espectáculo y zona del teatro?
  - Respuesta: Así es. También quiero conocer las localidades vendidas para cada representación.

- Cuestión: ¿Hablamos de las entradas?
  - Respuesta: Una entrada es una localidad para una representación. Dentro de cada zona las localidades se identifican por fila y butaca (p.e. “fila 2, butaca 3 de Patio”, “fila 2, butaca 3 de 1 de Balcón”, ...)

- Cuestión: ¿Quiere que se puedan adquirir las entradas únicamente a través de la web?
  - Respuesta: No, seguiremos vendiendo entradas en taquilla. Además algunas entadas se regalan como invitación. Necesito saber el medio o canal por el que se han adquirido las entradas ya sea web, taquilla o invitación.

- Cuestión: ¿Qué información quiere almacenar de las entradas?
  - Respuesta: La fecha y hora de compra, el canal por el que se ha adquirido, representación, fila y butaca que le corresponde y el precio de compra al que se ha adquirido ya que puede variar con el paso del tiempo.

- Cuestión: ¿Algo más?
  - Respuesta: Creo que en principio es todo. Como ya le comenté, queremos que tanto la planificación de espectáculos como la venta de entradas estén gestionados por la aplicación y se puedan consultar a través de Internet.
