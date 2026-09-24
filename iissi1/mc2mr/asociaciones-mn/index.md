---
layout: single
title: "Asociaciones N:M"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---

## Modelo Conceptual
![Diagrama de Clases]({{ '/assets/images/iissi1/mc2mr/asociaciones-mn-clases.png' | relative_url }})

## Modelo Relacional
```mr-table
-- Intensión
Autores = { autorId, nombre, nacionalidad }
    PK(autorId)

Libros = { libroId, isbn, titulo, añoPublicación }
    PK(libroId)
    AK(isbn)

Categorías = { categoríaId, nombre, descripción }
    PK(categoríaId)

AutoresLibros = { autoresLibrosId, autorId, libroId, orden }
    PK(autoresLibrosId)
    AK(autorId, libroId)
    FK(autorId)/Autores
    FK(libroId)/Libros

LibrosCategorías = { librosCategoríasId, libroId, categoríaId }
    PK(librosCategoríasId)
    AK(libroId, categoríaId)
    FK(libroId)/Libros
    FK(categoríaId)/Categorías

-- Extensión
Autores = {
    (a1, 'Gabriel García Márquez', 'Colombiana'),
    (a2, 'Mario Vargas Llosa', 'Peruana'),
    (a3, 'Antonio Machado', 'Española'),
    (a4, 'Manuel Machado', 'Española'),
    (a5, 'Isabel Allende', 'Chilena'),
    (a6, 'Octavio Paz', 'Mexicana'),
    (a7, 'Carlos Fuentes', 'Mexicana'),
    (a8, 'Rosa Montero', 'Española')
}

Libros = {
    (l1, '978-84-376-0494-7', 'Cien años de soledad', 1967),
    (l2, '978-84-204-6625-8', 'La ciudad y los perros', 1963),
    (l3, '978-84-206-5102-9', 'La Lola se va a los puertos', 1929),
    (l4, '978-84-206-5103-6', 'Las adelfas', 1928),
    (l5, '978-84-204-9876-2', 'La casa de los espíritus', 1982),
    (l6, '978-84-239-1234-8', 'El laberinto de la soledad', 1950),
    (l7, '978-84-204-5432-1', 'La muerte de Artemio Cruz', 1962),
    (l8, '978-84-322-1542-1', 'La ridícula idea de no volver a verte', 2013),
    (l9, '978-84-204-4321-8', 'La hija del caníbal', 1997)
}

Categorías = {
    (c1, 'Ficción', 'Narrativa de ficción'),
    (c2, 'Realismo Mágico', 'Corriente literaria'),
    (c3, 'Clásicos', 'Literatura clásica'),
    (c4, 'Teatro', 'Obras dramáticas'),
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
    (al10, a8, l8, 1),
    (al11, a8, l9, 1)
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
    (lc9, l4, c4),
    (lc10, l4, c3),
    (lc11, l5, c1),
    (lc12, l5, c2),
    (lc13, l6, c5),
    (lc14, l6, c3),
    (lc15, l7, c1),
    (lc16, l7, c3),
    (lc17, l8, c5),
    (lc18, l9, c1),
    (lc19, l9, c5)
}
```

## Álgebra relacional

### Enunciados

**1.** Obtener todos los libros con sus autores y su posición en la autoría

**2.** Obtener libros que tienen múltiples autores

**3.** Obtener el primer autor (orden=1) de cada libro

**4.** Obtener todas las categorías de 'Cien años de soledad'

**5.** Obtener autores españoles y sus libros

**6.** Obtener libros que pertenecen a más de 2 categorías

**7.** Obtener colaboraciones entre Antonio Machado y Manuel Machado

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

$$\Proj{tit, nom, ord}(L \NatJoin AL \NatJoin A)$$

```mr-table
Resultado = { tit, nom, ord }

Resultado = {
    ('Cien años de soledad', 'Gabriel García Márquez', 1),
    ('El laberinto de la soledad', 'Octavio Paz', 1),
    ('La casa de los espíritus', 'Isabel Allende', 1),
    ('La ciudad y los perros', 'Mario Vargas Llosa', 1),
    ('La hija del caníbal', 'Rosa Montero', 1),
    ('La Lola se va a los puertos', 'Antonio Machado', 1),
    ('La Lola se va a los puertos', 'Manuel Machado', 2),
    ('La muerte de Artemio Cruz', 'Carlos Fuentes', 1),
    ('La ridícula idea de no volver a verte', 'Rosa Montero', 1),
    ('Las adelfas', 'Antonio Machado', 1),
    ('Las adelfas', 'Manuel Machado', 2)
}
```

**2. Obtener libros que tienen múltiples autores**

$$LibrosMultiples \leftarrow \Group{lid,\rho_{numAutores}(COUNT(*))}{lid}(AL)$$

```mr-table
LibrosMultiples = { lid, numAutores }

LibrosMultiples = {
    (l1, 1),
    (l2, 1),
    (l3, 2),
    (l4, 2),
    (l5, 1),
    (l6, 1),
    (l7, 1),
    (l8, 1),
    (l9, 1)
}
```

$$LibrosColaborativosIDS \leftarrow \Proj{lid}\left(\Sel{numAutores > 1}(LibrosMultiples)\right)$$

```mr-table
LibrosColaborativosIDS = { lid }

LibrosColaborativosIDS = {
    (l3),
    (l4)
}
```

$$LibrosColaborativosIDS \NatJoin L$$

```mr-table
Resultado = { lid, isbn, tit, año }

Resultado = {
    (l3, '978-84-206-5102-9', 'La Lola se va a los puertos', 1929),
    (l4, '978-84-206-5103-6', 'Las adelfas', 1928)
}
```

**3. Obtener el primer autor (orden=1) de cada libro**

$$PrimerosAutores \leftarrow \Sel{ord = 1}(AL)$$

$$\Proj{tit, nom}(L \NatJoin PrimerosAutores \NatJoin A)$$

```mr-table
Resultado = { tit, nom }

Resultado = {
    ('Cien años de soledad', 'Gabriel García Márquez'),
    ('La ciudad y los perros', 'Mario Vargas Llosa'),
    ('La Lola se va a los puertos', 'Antonio Machado'),
    ('Las adelfas', 'Antonio Machado'),
    ('La casa de los espíritus', 'Isabel Allende'),
    ('El laberinto de la soledad', 'Octavio Paz'),
    ('La muerte de Artemio Cruz', 'Carlos Fuentes'),
    ('La ridícula idea de no volver a verte', 'Rosa Montero'),
    ('La hija del caníbal', 'Rosa Montero')
}
```

**4. Obtener todas las categorías de 'Cien años de soledad'**

$$CienAños \leftarrow \Sel{tit = \text{'Cien años de soledad'}}(L)$$

$$CategoriasLibroIDS \leftarrow \Proj{cid}(CienAños \NatJoin LC)$$

$$CategoriasLibroIDS \NatJoin C$$

```mr-table
Resultado = { cid, nom, des }

Resultado = {
    (c1, 'Ficción', 'Narrativa de ficción'),
    (c2, 'Realismo Mágico', 'Corriente literaria'),
    (c3, 'Clásicos', 'Literatura clásica')
}
```

**5. Obtener autores españoles y sus libros**

$$AutoresEspanoles \leftarrow \Sel{nac = 'Española'}(A)$$

$$\Proj{nom, tit}(AutoresEspanoles \NatJoin AL \NatJoin L)$$

```mr-table
Resultado = { nom, tit }

Resultado = {
    ('Antonio Machado', 'La Lola se va a los puertos'),
    ('Manuel Machado', 'La Lola se va a los puertos'),
    ('Antonio Machado', 'Las adelfas'),
    ('Manuel Machado', 'Las adelfas'),
    ('Rosa Montero', 'La ridícula idea de no volver a verte'),
    ('Rosa Montero', 'La hija del caníbal')
}
```

**6. Obtener libros que pertenecen a más de 2 categorías**

$$CategoriasPorLibro \leftarrow \Group{lid,\rho_{numCategorias}(COUNT(*))}{lid}(LC)$$

$$LibrosMulticatIDS \leftarrow \Proj{lid}\left(\Sel{numCategorias > 2}(CategoriasPorLibro)\right)$$

$$LibrosMulticatIDS \NatJoin L$$

```mr-table
Resultado = { lid, isbn, tit, año }

Resultado = {
    (l1, '978-84-376-0494-7', 'Cien años de soledad', 1967),
    (l3, '978-84-206-5102-9', 'La Lola se va a los puertos', 1929)
}
```

**7. Obtener colaboraciones entre Antonio Machado y Manuel Machado**

$$Antonio \leftarrow \Sel{nom = \text{'Antonio Machado'}}(A)$$

$$Manuel \leftarrow \Sel{nom = \text{'Manuel Machado'}}(A)$$

$$LibrosAntonioIDS \leftarrow \Proj{lid}(Antonio \NatJoin AL)$$

$$LibrosManuelIDS \leftarrow \Proj{lid}(Manuel \NatJoin AL)$$

$$ColaboracionesIDS \leftarrow LibrosAntonioIDS \Inter LibrosManuelIDS$$

$$ColaboracionesIDS \NatJoin L$$

```mr-table
Resultado = { lid, isbn, tit, año }

Resultado = {
    (l3, '978-84-206-5102-9', 'La Lola se va a los puertos', 1929),
    (l4, '978-84-206-5103-6', 'Las adelfas', 1928)
}
```

**8. Obtener libros de la categoría 'Realismo Mágico'**

$$RealismoMagico \leftarrow \Sel{nom = \text{'Realismo Mágico'}}(C)$$

$$LibrosRealismoIDS \leftarrow \Proj{lid}(RealismoMagico \NatJoin LC)$$

$$LibrosRealismoIDS \NatJoin L$$

```mr-table
Resultado = { lid, isbn, tit, año }

Resultado = {
    (l1, '978-84-376-0494-7', 'Cien años de soledad', 1967),
    (l5, '978-84-204-9876-2', 'La casa de los espíritus', 1982)
}
```

**9. Obtener el número de libros por autor**

$$\Group{aid,nom,\rho_{numLibros}(COUNT(*))}{aid,nom}(A \NatJoin AL)$$

```mr-table
Resultado = { aid, nom, numLibros }

Resultado = {
    (a1, 'Gabriel García Márquez', 1),
    (a2, 'Mario Vargas Llosa', 1),
    (a3, 'Antonio Machado', 2),
    (a4, 'Manuel Machado', 2),
    (a5, 'Isabel Allende', 1),
    (a6, 'Octavio Paz', 1),
    (a7, 'Carlos Fuentes', 1),
    (a8, 'Rosa Montero', 2)
}
```

**10. Obtener autores que han escrito tanto ficción como ensayo**

$$AutoresFiccionIDS \leftarrow \Proj{aid}\left(AL \NatJoin LC \NatJoin \Sel{nom = 'Ficción'}(C)\right)$$

$$AutoresEnsayoIDS \leftarrow \Proj{aid}\left(AL \NatJoin LC \NatJoin \Sel{nom = 'Ensayo'}(C)\right)$$

$$AutoresVersatilesIDS \leftarrow AutoresFiccionIDS \Inter AutoresEnsayoIDS$$

$$AutoresVersatilesIDS \NatJoin A$$

```mr-table
Resultado = { aid, nom, nac }

Resultado = {
    (a8, 'Rosa Montero', 'Española')
}
```

### [Relax](https://dbis-uibk.github.io/relax/calc/gist/f726ddb46c4ac7f95f724225910121c7)

```
-- Libros con sus autores y la posición en la autoría
-- π titulo, nombre, orden (Libros ⨝ AutoresLibros ⨝ Autores)

-- Libros con múltiples autores
-- LibrosMultiples = γ libroId; count(autorId) → numAutores (AutoresLibros)
-- LibrosColaborativosIds = π libroId (σ numAutores > 1 (LibrosMultiples))
-- LibrosColaborativosIds ⨝ Libros

-- Primer autor de cada libro
-- PrimerosAutores = σ orden = 1 (AutoresLibros)
-- π titulo, nombre (Libros ⨝ PrimerosAutores ⨝ Autores)

-- Categorías de Cien años de soledad
-- CienAños = σ titulo = 'Cien años de soledad' (Libros)
-- CategoriasLibroIds = π categoríaId (CienAños ⨝ LibrosCategorías)
-- CategoriasLibroIds ⨝ Categorías

-- Autores españoles y sus libros
-- AutoresEspanoles = σ nacionalidad = 'Española' (Autores)
-- π nombre, titulo (AutoresEspanoles ⨝ AutoresLibros ⨝ Libros)

-- Libros que pertenecen a más de dos categorías
-- CategoriasPorLibro = γ libroId; count(categoríaId) → numCategorias (LibrosCategorías)
-- LibrosMulticatIds = π libroId (σ numCategorias > 2 (CategoriasPorLibro))
-- LibrosMulticatIds ⨝ Libros

-- Colaboraciones entre Antonio Machado y Manuel Machado
-- Antonio = π libroId (σ nombre = 'Antonio Machado' (Autores) ⨝ AutoresLibros)
-- Manuel = π libroId (σ nombre = 'Manuel Machado' (Autores) ⨝ AutoresLibros)
-- (Antonio ∩ Manuel) ⨝ Libros

-- Libros de Realismo Mágico
-- RealismoMagico = π libroId (σ nombre = 'Realismo Mágico' (Categorías) ⨝ LibrosCategorías)
-- RealismoMagico ⨝ Libros

-- Número de libros por autor
-- γ autorId, nombre; count(libroId) → numLibros (Autores ⨝ AutoresLibros)

-- Autores que han escrito ficción y ensayo
-- AutoresFiccionIds = π autorId (AutoresLibros ⨝ LibrosCategorías ⨝ σ nombre = 'Ficción' (Categorías))
-- AutoresEnsayoIds = π autorId (AutoresLibros ⨝ LibrosCategorías ⨝ σ nombre = 'Ensayo' (Categorías))
-- (AutoresFiccionIds ∩ AutoresEnsayoIds) ⨝ Autores
```

> [Versión PDF disponible](./index.pdf)
