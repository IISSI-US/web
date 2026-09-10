---
layout: single
title: "Agregación y 1:N"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---

## Modelo Conceptual
![Diagrama de Clases]({{ '/assets/images/iissi1/mc2mr/ejercicio-02-biblioteca-clases.png' | relative_url }})

## Modelo Relacional. ([RELAX Calculator](https://dbis-uibk.github.io/relax/calc/gist/161f9826954987889517236781ca140d))

```mr-table
Bibliotecas = { bibliotecaId, nombre, dirección, añoInauguración }
    PK(bibliotecaId)

Autores = { autorId, nombre, fechaNacimiento }
    PK(autorId)

Libros = { libroId, bibliotecaId, autorId, isbn, titulo, precio, páginas }
    PK(libroId)
    AK(isbn)
    FK(bibliotecaId)/Bibliotecas
    FK(autorId)/Autores

Bibliotecas = {
    (b1, 'Central', 'Av. Siempre Viva 123', 1995-04-15),
    (b2, 'Norte', 'Calle Revolución 456', 2001-08-20),
    (b3, 'Sur', 'Blvd. Insurgentes 789', 1988-12-03)
}

Autores = {
    (a1, 'Carlos Pérez', 1980-06-10),
    (a2, 'María López', 1978-01-25),
    (a3, 'Ana García', 1985-03-15),
    (a4, 'Luis Martínez', 1975-11-08),
    (a5, 'Elena Rodriguez', 1982-09-22)
}

Libros = {
    (l1, b1, a1, '978-1', 'Introducción a Java', 39.90, 320),
    (l2, b1, a2, '978-2', 'Bases de Datos', 44.50, 410),
    (l3, b2, a1, '978-3', 'Programación Avanzada', 55.00, 485),
    (l4, b2, a3, '978-4', 'Análisis de Algoritmos', 62.75, 520),
    (l5, b3, a4, '978-5', 'Inteligencia Artificial', 68.20, 630),
    (l6, b3, a5, '978-6', 'Redes Neuronales', 71.50, 590),
    (l7, b1, a3, '978-7', 'Estructuras de Datos', 48.30, 395),
    (l8, b2, a5, '978-8', 'Machine Learning', 75.80, 680)
}
```

## Álgebra Relacional

Para simplificar la notación hacemos los siguientes renombrados:

$$ B\leftarrow \Ren{B(bid,bn,d,a)}(Bibliotecas)$$

$$A \leftarrow \Ren{A(aid,an,fn)}(Autores)$$

$$L \leftarrow \Ren{L(lid,bid,aid,isbn,t,p,pag)}(Libros)$$

### Enunciados de consultas:

1. **Libros con precio mayor a 50 euros**
2. **Autores nacidos después de 1980**
3. **Títulos y precios de libros de más de 500 páginas**
4. **Libros con información de sus autores**
5. **Bibliotecas con libros caros (> 60 euros)**
6. **Autores jóvenes con libros económicos**
7. **Libros que NO están en la biblioteca Central**
8. **Número de libros por biblioteca**
9. **Precio promedio de libros por autor**
10. **Biblioteca con el libro más caro**

---

### Soluciones:

**1. Libros con precio mayor a 50 euros**

$$\Sel{p > 50}(L)$$

```mr-table
Resultado = { lid, bid, aid, isbn, t, p, pag }

Resultado = {
  (l3, b2, a1, '978-3', 'Programación Avanzada', 55.00, 485),
  (l4, b2, a3, '978-4', 'Análisis de Algoritmos', 62.75, 520),
  (l5, b3, a4, '978-5', 'Inteligencia Artificial', 68.20, 630),
  (l6, b3, a5, '978-6', 'Redes Neuronales', 71.50, 590),
  (l8, b2, a5, '978-8', 'Machine Learning', 75.80, 680)
}
```

**2. Autores nacidos después de 1980**

$$\Sel{fn > 1980-01-01}(A)$$

```mr-table
Resultado = { aid, an, fn }

Resultado = {
  (a3, 'Ana García', 1985-03-15),
  (a5, 'Elena Rodriguez', 1982-09-22)
}
```

**3. Títulos y precios de libros de más de 500 páginas**

$$\Proj{t, p}(\Sel{pag > 500}(L))$$

```mr-table
Resultado = { t, p }

Resultado = {
  ('Análisis de Algoritmos', 62.75),
  ('Inteligencia Artificial', 68.20),
  ('Redes Neuronales', 71.50),
  ('Machine Learning', 75.80)
}
```

**4. Libros con información de sus autores**

$$L \NatJoin A$$

```mr-table
Resultado = { lid, bid, aid, isbn, t, p, pag, an, fn }

Resultado = {
  (l1, b1, a1, '978-1', 'Introducción a Java', 39.90, 320, 'Carlos Pérez', 1980-06-10),
  (l2, b1, a2, '978-2', 'Bases de Datos', 44.50, 410, 'María López', 1978-01-25),
  (l3, b2, a1, '978-3', 'Programación Avanzada', 55.00, 485, 'Carlos Pérez', 1980-06-10),
  (l4, b2, a3, '978-4', 'Análisis de Algoritmos', 62.75, 520, 'Ana García', 1985-03-15),
  (l5, b3, a4, '978-5', 'Inteligencia Artificial', 68.20, 630, 'Luis Martínez', 1975-11-08),
  (l6, b3, a5, '978-6', 'Redes Neuronales', 71.50, 590, 'Elena Rodriguez', 1982-09-22),
  (l7, b1, a3, '978-7', 'Estructuras de Datos', 48.30, 395, 'Ana García', 1985-03-15),
  (l8, b2, a5, '978-8', 'Machine Learning', 75.80, 680, 'Elena Rodriguez', 1982-09-22)
}
```

**5. Bibliotecas con libros caros (> 60 euros)**

$$\Proj{bn, d}(B \NatJoin \Sel{p > 60}(L))$$

```mr-table
Resultado = { bn, d }

Resultado = {
  ('Norte', 'Calle Revolución 456'),
  ('Sur', 'Blvd. Insurgentes 789')
}
```

**6. Autores jóvenes con libros económicos**

$$\Proj{an}(\Sel{fn > 1980-01-01}(A) \NatJoin \Sel{p < 50}(L))$$

```mr-table
Resultado = { an }

Resultado = {
  ('Ana García') -- Solo Ana tiene un libro < 50€ y nació después de 1980
}
```

**7. Libros que NO están en la biblioteca Central**

$$L - \Sel{bid = b1}(L)$$

```mr-table
Resultado = { lid, bid, aid, isbn, t, p, pag }

Resultado = {
  (l3, b2, a1, '978-3', 'Programación Avanzada', 55.00, 485),
  (l4, b2, a3, '978-4', 'Análisis de Algoritmos', 62.75, 520),
  (l5, b3, a4, '978-5', 'Inteligencia Artificial', 68.20, 630),
  (l6, b3, a5, '978-6', 'Redes Neuronales', 71.50, 590),
  (l8, b2, a5, '978-8', 'Machine Learning', 75.80, 680)
}
```

**8. Número de libros por biblioteca**

$$\Group{bid,\rho_{total}(COUNT(lid))}{bid}(L)$$

```mr-table
Resultado = { bid, total }

Resultado = {
  (b1, 3), (b2, 3), (b3, 2)
}
```

**9. Precio promedio de libros por autor**

$$\Group{aid,\rho_{media}(AVG(p))}{aid}(L)$$

```mr-table
Resultado = { aid, media }

Resultado = {
  (a1, 47.45), (a2, 44.50), (a3, 55.53), (a4, 68.20), (a5, 73.65)
}
```

**10. Biblioteca con el libro más caro**

$$precioMax \leftarrow \Group{\rho_{maxPrecio}(MAX(p))}{}(L)$$

$$\Proj{bn}\left(B \NatJoin \Sel{p = maxPrecio}(L \times precioMax)\right)$$

```mr-table
Resultado = { bn }

Resultado = {
  ('Norte') -- Biblioteca que tiene "Machine Learning" (75.80€)
}
```

> [Versión PDF disponible](./index.pdf)
