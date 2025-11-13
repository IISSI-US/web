---
layout: single
title: "Relaciones M:N"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
sidebar:
    nav: mc2mr
---

## Modelo Conceptual
![Diagrama de Clases](/mc2mr/ejercicio-08-relaciones-mn-clases.png)

## Modelo Relacional. Intensión
```
Autores(autorId, nombre, nacionalidad)
    PK(autorId)

Libros(libroId, isbn, titulo, añoPublicación)
    PK(libroId)
    AK(isbn) -- El MC no indica nada, pero parece lógico

Categorías(categoríaId, nombre, descripción)
    PK(categoríaId)

AutoresLibros(autoresLibrosId, autorId, libroId, orden)
    PK(autoresLibrosId)
    AK(autorId, libroId) -- El MC no indica nada, pero parece lógico
    FK(autorId)/Autores
    FK(libroId)/Libros

LibrosCategorías(librosCategoríasId, libroId, categoríaId)
    PK(librosCategoríasId)
    AK(libroId, categoríaId) -- El MC no indica nada, pero parece lógico
    FK(libroId)/Libros
    FK(categoríaId)/Categorías
```

<!-- ## Diagrama de objetos
![Diagrama de Objetos](/mc2mr/ejercicio-08-relaciones-mn-objetos.png) -->

## Modelo Relacional. Extensión
```text
Autores = {
    (a1, 'Gabriel García Márquez', 'Colombiana'),
    (a2, 'Mario Vargas Llosa', 'Peruana'),
    (a3, 'Jorge Luis Borges', 'Argentina'),
    (a4, 'Adolfo Bioy Casares', 'Argentina'),
    (a5, 'Isabel Allende', 'Chilena'),
    (a6, 'Octavio Paz', 'Mexicana'),
    (a7, 'Carlos Fuentes', 'Mexicana'),
    (a8, 'Julio Cortázar', 'Argentina')
}

Libros = {
    (l1, '978-84-376-0494-7', 'Cien años de soledad', 1967),
    (l2, '978-84-204-6625-8', 'La ciudad y los perros', 1963),
    (l3, '978-84-239-9876-5', 'Antología de la Literatura Fantástica', 1940),
    (l4, '978-84-204-8321-7', 'Cuentos Breves y Extraordinarios', 1955),
    (l5, '978-84-204-9876-2', 'La casa de los espíritus', 1982),
    (l6, '978-84-239-1234-8', 'Laberinto de la Soledad', 1950),
    (l7, '978-84-204-5432-1', 'La muerte de Artemio Cruz', 1962),
    (l8, '978-84-376-8765-4', 'El llano en llamas', 1953),
    (l9, '978-84-204-2468-9', 'Rayuela', 1963)
}

Categorías = {
    (c1, 'Ficción', 'Narrativa de ficción'),
    (c2, 'Realismo Mágico', 'Corriente literaria'),
    (c3, 'Clásicos', 'Literatura clásica'),
    (c4, 'Fantasía', 'Literatura fantástica'),
    (c5, 'Ensayo', 'Literatura ensayística')
}

AutoresLibros = {
    (al1, a1, l1, 1),
    (al2, a2, l2, 1),
    (al3, a3, l3, 1),
    (al4, a4, l3, 2),
    (al5, a3, l4, 1),
    (al6, a4, l4, 2),
    (al7, a5, l5, 1),
    (al8, a6, l6, 1),
    (al9, a7, l7, 1),
    (al10, a1, l8, 1),
    (al11, a8, l9, 1),
    (al12, a6, l8, 2)
}

LibrosCategorías = {
    (lc1, l1, c1),
    (lc2, l1, c2),
    (lc3, l1, c3),
    (lc4, l2, c1),
    (lc5, l2, c3),
    (lc6, l3, c1),
    (lc7, l3, c4),
    (lc8, l3, c3),
    (lc9, l4, c1),
    (lc10, l4, c4),
    (lc11, l5, c1),
    (lc12, l5, c2),
    (lc13, l6, c5),
    (lc14, l6, c3),
    (lc15, l7, c1),
    (lc16, l7, c3),
    (lc17, l8, c1),
    (lc18, l8, c5),
    (lc19, l9, c1),
    (lc20, l9, c3)
}
```

---

## Álgebra relacional

### Enunciados

**1.** Obtener todos los libros con sus autores y su posición en la autoría

**2.** Obtener libros que tienen múltiples autores

**3.** Obtener el primer autor (orden=1) de cada libro

**4.** Obtener todas las categorías de 'Cien años de soledad'

**5.** Obtener autores argentinos y sus libros

**6.** Obtener libros que pertenecen a más de 2 categorías

**7.** Obtener colaboraciones entre Jorge Luis Borges y Adolfo Bioy Casares

**8.** Obtener libros de la categoría 'Realismo Mágico'

**9.** Obtener el número de libros por autor

**10.** Obtener autores que han escrito tanto ficción como ensayo

### Soluciones

**Renombramiento de relaciones:**

$$A \leftarrow \Ren{A(aid,nom,nac)}(Autores)$$

$$L \leftarrow \Ren{L(lid,isbn,tit,año)}(Libros)$$

$$C \leftarrow \Ren{C(cid,nom,des)}(Categorías)$$

$$AL \leftarrow \Ren{AL(alid,aid,lid,ord)}(AutoresLibros)$$

$$LC \leftarrow \Ren{LC(lcid,lid,cid)}(LibrosCategorías)$$

**1. Obtener todos los libros con sus autores y su posición en la autoría**

$$\Proj{tit, nom, ord}(L \Join AL \Join A)$$

```
Resultado: {
    ('Antología de la Literatura Fantástica', 'Jorge Luis Borges', 1),
    ('Antología de la Literatura Fantástica', 'Adolfo Bioy Casares', 2),
    ('Cien años de soledad', 'Gabriel García Márquez', 1),
    ('Cuentos Breves y Extraordinarios', 'Jorge Luis Borges', 1),
    ('Cuentos Breves y Extraordinarios', 'Adolfo Bioy Casares', 2),
    ('El llano en llamas', 'Gabriel García Márquez', 1),
    ('El llano en llamas', 'Octavio Paz', 2),
    ('La casa de los espíritus', 'Isabel Allende', 1),
    ('La ciudad y los perros', 'Mario Vargas Llosa', 1),
    ('La muerte de Artemio Cruz', 'Carlos Fuentes', 1),
    ('Laberinto de la Soledad', 'Octavio Paz', 1),
    ('Rayuela', 'Julio Cortázar', 1)
}
```

**2. Obtener libros que tienen múltiples autores**

$$LibrosMultiples \leftarrow \Group{lid, \Ren{numAutores}COUNT(*)}{lid}(AL)$$

$$LibrosColaborativosIDS \leftarrow \Proj{lid}\left(\Sel{numAutores > 1}(LibrosMultiples)\right)$$

$$LibrosColaborativosIDS \Join L$$

```
Resultado: {
    (l3, '978-84-239-9876-5', 'Antología de la Literatura Fantástica', 1940),
    (l4, '978-84-204-8321-7', 'Cuentos Breves y Extraordinarios', 1955),
    (l8, '978-84-376-8765-4', 'El llano en llamas', 1953)
}
```

**3. Obtener el primer autor (orden=1) de cada libro**

$$PrimerosAutores \leftarrow \Sel{ord = 1}(AL)$$

$$\Proj{tit, nom}(L \Join PrimerosAutores \Join A)$$

```
Resultado: {
    ('Cien años de soledad', 'Gabriel García Márquez'),
    ('La ciudad y los perros', 'Mario Vargas Llosa'),
    ('Antología de la Literatura Fantástica', 'Jorge Luis Borges'),
    ('Cuentos Breves y Extraordinarios', 'Jorge Luis Borges'),
    ('La casa de los espíritus', 'Isabel Allende'),
    ('Laberinto de la Soledad', 'Octavio Paz'),
    ('La muerte de Artemio Cruz', 'Carlos Fuentes'),
    ('El llano en llamas', 'Gabriel García Márquez'),
    ('Rayuela', 'Julio Cortázar')
}
```

**4. Obtener todas las categorías de 'Cien años de soledad'**

$$CienAños \leftarrow \Sel{tit = \text{'Cien años de soledad'}}(L)$$

$$CategoriasLibroIDS \leftarrow \Proj{cid}(CienAños \Join LC)$$

$$CategoriasLibroIDS \Join C$$

```
Resultado: {
    (c1, 'Ficción', 'Narrativa de ficción'),
    (c2, 'Realismo Mágico', 'Corriente literaria'),
    (c3, 'Clásicos', 'Literatura clásica')
}
```

**5. Obtener autores argentinos y sus libros**

$$AutoresArgentinos \leftarrow \Sel{nac = 'Argentina'}(A)$$

$$\Proj{nom, tit}(AutoresArgentinos \Join AL \Join L)$$

```
Resultado: {
    ('Jorge Luis Borges', 'Antología de la Literatura Fantástica'),
    ('Adolfo Bioy Casares', 'Antología de la Literatura Fantástica'),
    ('Jorge Luis Borges', 'Cuentos Breves y Extraordinarios'),
    ('Adolfo Bioy Casares', 'Cuentos Breves y Extraordinarios')
}
```

**6. Obtener libros que pertenecen a más de 2 categorías**

$$CategoriasPorLibro \leftarrow \Group{lid, \Ren{numCategorias} COUNT(*)}{lid}(LC)$$

$$LibrosMulticatIDS \leftarrow \Proj{lid}\left(\Sel{numCategorias > 2}(CategoriasPorLibro)\right)$$

$$LibrosMulticatIDS \Join L$$

```
Resultado: {
    (l1, '978-84-376-0494-7', 'Cien años de soledad', 1967),
    (l3, '978-84-239-9876-5', 'Antología de la Literatura Fantástica', 1940)
}
```

**7. Obtener colaboraciones entre Jorge Luis Borges y Adolfo Bioy Casares**

$$Borges \leftarrow \Sel{nom = \text{'Jorge Luis Borges'}}(A)$$

$$Bioy \leftarrow \Sel{nom = \text{'Adolfo Bioy Casares'}}(A)$$

$$LibrosBorgesIDS \leftarrow \Proj{lid}(Borges \Join AL)$$

$$LibrosBioyIDS \leftarrow \Proj{lid}(Bioy \Join AL)$$

$$ColaboracionesIDS \leftarrow LibrosBorgesIDS \Inter LibrosBioyIDS$$

$$ColaboracionesIDS \Join L$$

```
Resultado: {
    (l3, '978-84-239-9876-5', 'Antología de la Literatura Fantástica', 1940),
    (l4, '978-84-204-8321-7', 'Cuentos Breves y Extraordinarios', 1955)
}
```

**8. Obtener libros de la categoría 'Realismo Mágico'**

$$RealismoMagico \leftarrow \Sel{nom = \text{'Realismo Mágico'}}(C)$$

$$LibrosRealismoIDS \leftarrow \Proj{lid}(RealismoMagico \Join LC)$$

$$LibrosRealismoIDS \Join L$$

```
Resultado: {
    (l1, '978-84-376-0494-7', 'Cien años de soledad', 1967),
    (l5, '978-84-204-9876-2', 'La casa de los espíritus', 1982)
}
```

**9. Obtener el número de libros por autor**

$$\Group{aid, nom; COUNT(*) \rightarrow numLibros}{aid}(A \Join AL)$$

```
Resultado: {
    (a1, 'Gabriel García Márquez', 2),
    (a2, 'Mario Vargas Llosa', 1),
    (a3, 'Jorge Luis Borges', 2),
    (a4, 'Adolfo Bioy Casares', 2),
    (a5, 'Isabel Allende', 1),
    (a6, 'Octavio Paz', 2),
    (a7, 'Carlos Fuentes', 1),
    (a8, 'Julio Cortázar', 1)
}
```

**10. Obtener autores que han escrito tanto ficción como ensayo**

$$AutoresFiccionIDS \leftarrow \Proj{aid}\left(AL \Join LC \Join \Sel{nom = 'Ficción'}(C)\right)$$

$$AutoresEnsayoIDS \leftarrow \Proj{aid}\left(AL \Join LC \Join \Sel{nom = 'Ensayo'}(C)\right)$$

$$AutoresVersatilesIDS \leftarrow AutoresFiccionIDS \Inter AutoresEnsayoIDS$$

$$AutoresVersatilesIDS \Join A$$

```
Resultado: {
    (a1, 'Gabriel García Márquez', 'Colombiana'),
    (a6, 'Octavio Paz', 'Mexicana')
}
```
