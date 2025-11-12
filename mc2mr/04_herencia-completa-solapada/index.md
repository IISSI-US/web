---
layout: single
title: Ejercicio 4
toc: true
toc_label: "Contenido"
sidebar:
    nav: mc2mr
---

# Ejercicio 4: Herencia completa y solapada (Contenido → Artículo | Video)
<!-- {: .fs-9 } -->

Especialización completa con solapamiento permitido
<!-- {: .fs-6 .fw-300 } -->

---

## Diagrama UML (Clases)
![Diagrama de Clases](/mc2mr/ejercicio-04-herencia-completa-solapada-clases.png)

## Intensión relacional
```
Contenidos(
    contenidoId, título, fechaPublicación, 
    esArtículo, textoMarkdown, númeroPalabras, 
    esVideo, urlStreaming, duraciónSeg, resolución)
    
    PK(contenidoId)
```

<!-- ## Diagrama de objetos
![Diagrama de Objetos](/mc2mr/ejercicio-04-herencia-completa-solapada-objetos.png) -->

## Extensión relacional
```text
Contenidos = {
    (c1, 'Tutorial de Java', 2023-01-15, true, 'Introducción básica a Java...', 1200, false, null, null, null),
    (c2, 'Demo de la aplicación', 2023-02-20, false, null, null, true, 'https://demo.mp4', 300, '1080p'),
    (c3, 'Video Tutorial Completo', 2023-03-10, true, 'Tutorial completo en video...', 800, true, 'https://tutorial.mp4', 1800, '1080p'),
    (c4, 'Guía de Python', 2023-03-25, true, 'Programación en Python desde cero...', 2500, false, null, null, null),
    (c5, 'Webinar JavaScript', 2023-04-05, true, 'Conceptos avanzados de JS...', 1800, true, 'https://webinar-js.mp4', 3600, '720p'),
    (c6, 'Presentación React', 2023-04-12, false, null, null, true, 'https://react-demo.mp4', 900, '1080p'),
    (c7, 'Documentación API', 2023-04-20, true, 'Especificación completa de la API...', 3200, false, null, null, null),
    (c8, 'Tutorial CSS Avanzado', 2023-05-01, true, 'Técnicas modernas de CSS...', 1500, true, 'https://css-tutorial.mp4', 2700, '1080p'),
    (c9, 'Demo Animaciones', 2023-05-10, false, null, null, true, 'https://animations.mp4', 450, '4K'),
    (c10, 'Curso Completo Full Stack', 2023-05-15, true, 'Desarrollo web full stack...', 4800, true, 'https://fullstack.mp4', 7200, '1080p')
}
```

---

## Álgebra relacional

### Enunciados

**1.** Obtener todos los contenidos que son artículos

**2.** Obtener todos los contenidos que son videos

**3.** Obtener contenidos que son tanto artículos como videos (contenido mixto)

**4.** Obtener el título y fecha de publicación de todos los videos con duración mayor a 1800 segundos

**5.** Obtener artículos con más de 2000 palabras

**6.** Obtener videos en resolución 1080p

**7.** Obtener el contenido con mayor número de palabras

**8.** Obtener todos los contenidos publicados en abril de 2023

**9.** Obtener la duración promedio de todos los videos

**10.** Obtener contenidos que son solo artículos (no videos)

### Soluciones

**Relaciones intermedias:**

$$Artículos \leftarrow \Sel{esArtículo = true}(Contenidos)$$

$$Videos \leftarrow \Sel{esVideo = true}(Contenidos)$$

**1. Obtener todos los contenidos que son artículos**

$$Artículos$$

```
Resultado: {
    (c1, 'Tutorial de Java', 2023-01-15, true, 'Introducción básica a Java...', 1200, false, null, null, null),
    (c3, 'Video Tutorial Completo', 2023-03-10, true, 'Tutorial completo en video...', 800, true, 'https://tutorial.mp4', 1800, '1080p'),
    (c4, 'Guía de Python', 2023-03-25, true, 'Programación en Python desde cero...', 2500, false, null, null, null),
    (c5, 'Webinar JavaScript', 2023-04-05, true, 'Conceptos avanzados de JS...', 1800, true, 'https://webinar-js.mp4', 3600, '720p'),
    (c7, 'Documentación API', 2023-04-20, true, 'Especificación completa de la API...', 3200, false, null, null, null),
    (c8, 'Tutorial CSS Avanzado', 2023-05-01, true, 'Técnicas modernas de CSS...', 1500, true, 'https://css-tutorial.mp4', 2700, '1080p'),
    (c10, 'Curso Completo Full Stack', 2023-05-15, true, 'Desarrollo web full stack...', 4800, true, 'https://fullstack.mp4', 7200, '1080p')
}
```

**2. Obtener todos los contenidos que son videos**

$$Videos$$

```
Resultado: {
    (c2, 'Demo de la aplicación', 2023-02-20, false, null, null, true, 'https://demo.mp4', 300, '1080p'),
    (c3, 'Video Tutorial Completo', 2023-03-10, true, 'Tutorial completo en video...', 800, true, 'https://tutorial.mp4', 1800, '1080p'),
    (c5, 'Webinar JavaScript', 2023-04-05, true, 'Conceptos avanzados de JS...', 1800, true, 'https://webinar-js.mp4', 3600, '720p'),
    (c6, 'Presentación React', 2023-04-12, false, null, null, true, 'https://react-demo.mp4', 900, '1080p'),
    (c8, 'Tutorial CSS Avanzado', 2023-05-01, true, 'Técnicas modernas de CSS...', 1500, true, 'https://css-tutorial.mp4', 2700, '1080p'),
    (c9, 'Demo Animaciones', 2023-05-10, false, null, null, true, 'https://animations.mp4', 450, '4K'),
    (c10, 'Curso Completo Full Stack', 2023-05-15, true, 'Desarrollo web full stack...', 4800, true, 'https://fullstack.mp4', 7200, '1080p')
}
```

**3. Obtener contenidos que son tanto artículos como videos (contenido mixto)**

$$Artículos \Inter Videos$$

```
Resultado: {
    (c3, 'Video Tutorial Completo', 2023-03-10, true, 'Tutorial completo en video...', 800, true, 'https://tutorial.mp4', 1800, '1080p'),
    (c5, 'Webinar JavaScript', 2023-04-05, true, 'Conceptos avanzados de JS...', 1800, true, 'https://webinar-js.mp4', 3600, '720p'),
    (c8, 'Tutorial CSS Avanzado', 2023-05-01, true, 'Técnicas modernas de CSS...', 1500, true, 'https://css-tutorial.mp4', 2700, '1080p'),
    (c10, 'Curso Completo Full Stack', 2023-05-15, true, 'Desarrollo web full stack...', 4800, true, 'https://fullstack.mp4', 7200, '1080p')
}
```

**4. Obtener el título y fecha de publicación de todos los videos con duración mayor a 1800 segundos**

$$\Proj{título, fechaPublicación}(\Sel{duraciónSeg > 1800}(Videos))$$

```
Resultado: {
    ('Webinar JavaScript', 2023-04-05),
    ('Tutorial CSS Avanzado', 2023-05-01),
    ('Curso Completo Full Stack', 2023-05-15)
}
```

**5. Obtener artículos con más de 2000 palabras**

$$\Sel{númeroPalabras > 2000}(Artículos)$$

```
Resultado: {
    (c4, 'Guía de Python', 2023-03-25, true, 'Programación en Python desde cero...', 2500, false, null, null, null),
    (c7, 'Documentación API', 2023-04-20, true, 'Especificación completa de la API...', 3200, false, null, null, null),
    (c10, 'Curso Completo Full Stack', 2023-05-15, true, 'Desarrollo web full stack...', 4800, true, 'https://fullstack.mp4', 7200, '1080p')
}
```

**6. Obtener videos en resolución 1080p**

$$\Sel{resolución = '1080p'}(Videos)$$

```
Resultado: {
    (c2, 'Demo de la aplicación', 2023-02-20, false, null, null, true, 'https://demo.mp4', 300, '1080p'),
    (c3, 'Video Tutorial Completo', 2023-03-10, true, 'Tutorial completo en video...', 800, true, 'https://tutorial.mp4', 1800, '1080p'),
    (c6, 'Presentación React', 2023-04-12, false, null, null, true, 'https://react-demo.mp4', 900, '1080p'),
    (c8, 'Tutorial CSS Avanzado', 2023-05-01, true, 'Técnicas modernas de CSS...', 1500, true, 'https://css-tutorial.mp4', 2700, '1080p'),
    (c10, 'Curso Completo Full Stack', 2023-05-15, true, 'Desarrollo web full stack...', 4800, true, 'https://fullstack.mp4', 7200, '1080p')
}
```

**7. Obtener el contenido con mayor número de palabras**

$$maxPalabras \leftarrow \Group{MAX(númeroPalabras)}{}(Artículos)$$

$$\Sel{númeroPalabras = maxPalabras}(Artículos)$$

```
Resultado: {
    (c10, 'Curso Completo Full Stack', 2023-05-15, true, 'Desarrollo web full stack...', 4800, true, 'https://fullstack.mp4', 7200, '1080p')
}
```

**8. Obtener todos los contenidos publicados en abril de 2023**

$$\Sel{fechaPublicación \geq '2023-04-01' \land fechaPublicación < '2023-05-01'}(Contenidos)$$

```
Resultado: {
    (c5, 'Webinar JavaScript', 2023-04-05, true, 'Conceptos avanzados de JS...', 1800, true, 'https://webinar-js.mp4', 3600, '720p'),
    (c6, 'Presentación React', 2023-04-12, false, null, null, true, 'https://react-demo.mp4', 900, '1080p'),
    (c7, 'Documentación API', 2023-04-20, true, 'Especificación completa de la API...', 3200, false, null, null, null)
}
```

**9. Obtener la duración promedio de todos los videos**

$$durPromedio \leftarrow \Group{AVG(duraciónSeg)}{}(Videos)$$

```
Resultado: {
    (2164.29)  -- (300 + 1800 + 3600 + 900 + 2700 + 450 + 7200) / 7
}
```

**10. Obtener contenidos que son solo artículos (no videos)**

$$
Artículos - Videos
$$

```
Resultado: {
    (c1, 'Tutorial de Java', 2023-01-15, true, 'Introducción básica a Java...', 1200, false, null, null, null),
    (c4, 'Guía de Python', 2023-03-25, true, 'Programación en Python desde cero...', 2500, false, null, null, null),
    (c7, 'Documentación API', 2023-04-20, true, 'Especificación completa de la API...', 3200, false, null, null, null)
}
```
