---
layout: single
title: "Asociación reflexiva N:M"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true
---

# Modelo Conceptual

![Diagrama de Clases]({{ '/assets/images/iissi1/mc2mr/asociacion-reflexiva-clases.png' | relative_url }})

# Modelo Relacional

```mr-table
-- Intensión
Usuarios = { usuarioId, nombre, edad, genero, ciudadOrigen, fechaRegistro }
    PK(usuarioId)
    AK(nombre)

Seguimientos = { seguimientoId, seguidorId, seguidoId, fechaInicio }
    PK(seguimientoId)
    FK(seguidorId)/Usuarios
    FK(seguidoId)/Usuarios
    AK(seguidorId, seguidoId)

-- Extensión
Usuarios = {
    (u1, 'Ana', 28, 'FEMENINO', 'Madrid', 2024-01-10),
    (u2, 'Bruno', 34, 'MASCULINO', 'Sevilla', 2024-02-15),
    (u3, 'Carla', 22, 'FEMENINO', 'Madrid', 2024-01-20),
    (u4, 'Diego', 31, 'MASCULINO', 'Valencia', 2024-03-05),
    (u5, 'Elena', 27, 'NO_BINARIO', 'Barcelona', 2024-02-01),
    (u6, 'Fabio', 19, 'MASCULINO', 'Sevilla', 2024-04-10)
}

Seguimientos = {
    (s1, u1, u2, 2024-02-20),
    (s2, u1, u3, 2024-02-21),
    (s3, u1, u5, 2024-02-22),
    (s4, u2, u1, 2024-03-01),
    (s5, u2, u3, 2024-03-02),
    (s6, u3, u1, 2024-02-25),
    (s7, u3, u2, 2024-02-26),
    (s8, u3, u5, 2024-02-27),
    (s9, u4, u1, 2024-03-10),
    (s10, u4, u2, 2024-03-11),
    (s11, u5, u2, 2024-02-10),
    (s12, u5, u3, 2024-02-11)
}
```

La clase asociación `Seguimiento` se transforma en la relación `Seguimientos`. Al tratarse de una asociación reflexiva, sus dos claves ajenas apuntan a `Usuarios`, pero representan roles distintos: `seguidorId` y `seguidoId`.

# Álgebra relacional

## Enunciados

**1.** Obtener los usuarios que sigue Ana, con su edad, género y ciudad.

**2.** Obtener los usuarios que siguen a Bruno, con su edad, género y ciudad.

**3.** Obtener todos los seguimientos con los nombres, las ciudades de origen y la fecha de inicio.

**4.** Obtener los seguimientos iniciados durante febrero de 2024.

**5.** Obtener los usuarios que siguen a tres o más usuarios, indicando su ciudad.

**6.** Obtener los usuarios que no siguen a nadie.

**7.** Obtener los pares de usuarios que se siguen mutuamente.

**8.** Obtener los usuarios que siguen a Carla y también a Bruno.

**9.** Obtener el número de seguidores de cada usuario.

**10.** Obtener los seguimientos en los que el seguidor se registró durante enero de 2024.

**11.** Obtener los usuarios mayores de 25 años de Madrid o Valencia.

**12.** Obtener los usuarios que siguen a todas las mujeres.

## Soluciones

**Renombramiento de relaciones:**

$$U \leftarrow \Ren{U(uid,nom,edad,gen,ciu,freg)}(Usuarios)$$

$$S \leftarrow \Ren{S(seguimientoId,seguidorId,seguidoId,fechaInicio)}(Seguimientos)$$

**1. Obtener los usuarios que sigue Ana**

Como Ana tiene identificador `u1`:

$$\Proj{nom, edad, gen, ciu}\left(\Sel{seguidorId = u1}(S) \JoinR{seguidoId = uid} U\right)$$

```mr-table
Resultado = { nom, edad, gen, ciu }

Resultado = {
    ('Bruno', 34, 'MASCULINO', 'Sevilla'),
    ('Carla', 22, 'FEMENINO', 'Madrid'),
    ('Elena', 27, 'NO_BINARIO', 'Barcelona')
}
```

**2. Obtener los usuarios que siguen a Bruno**

Como Bruno tiene identificador `u2`:

$$\Proj{nom, edad, gen, ciu}\left(\Sel{seguidoId = u2}(S) \JoinR{seguidorId = uid} U\right)$$

```mr-table
Resultado = { nom, edad, gen, ciu }

Resultado = {
    ('Ana', 28, 'FEMENINO', 'Madrid'),
    ('Carla', 22, 'FEMENINO', 'Madrid'),
    ('Diego', 31, 'MASCULINO', 'Valencia'),
    ('Elena', 27, 'NO_BINARIO', 'Barcelona')
}
```

**3. Obtener todos los seguimientos con los nombres de ambos usuarios**

$$U1 \leftarrow \Ren{U1}(U)$$

$$U2 \leftarrow \Ren{U2}(U)$$

$$\Proj{U1.nom, U1.ciu, U2.nom, U2.ciu, fechaInicio}\left(U1 \JoinR{U1.uid = seguidorId} S \JoinR{seguidoId = U2.uid} U2\right)$$

```mr-table
Resultado = { U1.nom, U1.ciu, U2.nom, U2.ciu, fechaInicio }

Resultado = {
    ('Ana', 'Madrid', 'Bruno', 'Sevilla', 2024-02-20),
    ('Ana', 'Madrid', 'Carla', 'Madrid', 2024-02-21),
    ('Ana', 'Madrid', 'Elena', 'Barcelona', 2024-02-22),
    ('Bruno', 'Sevilla', 'Ana', 'Madrid', 2024-03-01),
    ('Bruno', 'Sevilla', 'Carla', 'Madrid', 2024-03-02),
    ('Carla', 'Madrid', 'Ana', 'Madrid', 2024-02-25),
    ('Carla', 'Madrid', 'Bruno', 'Sevilla', 2024-02-26),
    ('Carla', 'Madrid', 'Elena', 'Barcelona', 2024-02-27),
    ('Diego', 'Valencia', 'Ana', 'Madrid', 2024-03-10),
    ('Diego', 'Valencia', 'Bruno', 'Sevilla', 2024-03-11),
    ('Elena', 'Barcelona', 'Bruno', 'Sevilla', 2024-02-10),
    ('Elena', 'Barcelona', 'Carla', 'Madrid', 2024-02-11)
}
```

**4. Obtener los seguimientos iniciados durante febrero de 2024**

$$\Sel{fechaInicio \geq '2024-02-01' \land fechaInicio < '2024-03-01'}(S)$$

```mr-table
Resultado = { seguimientoId, seguidorId, seguidoId, fechaInicio }

Resultado = {
    (s1, u1, u2, 2024-02-20),
    (s2, u1, u3, 2024-02-21),
    (s3, u1, u5, 2024-02-22),
    (s6, u3, u1, 2024-02-25),
    (s7, u3, u2, 2024-02-26),
    (s8, u3, u5, 2024-02-27),
    (s11, u5, u2, 2024-02-10),
    (s12, u5, u3, 2024-02-11)
}
```

**5. Obtener los usuarios que siguen a tres o más usuarios**

$$SeguimientosPorUsuario \leftarrow \Group{seguidorId,\rho_{numSeguidos}(COUNT(*))}{seguidorId}(S)$$

```mr-table
SeguimientosPorUsuario = { seguidorId, numSeguidos }

SeguimientosPorUsuario = {
    (u1, 3),
    (u2, 2),
    (u3, 3),
    (u4, 2),
    (u5, 2)
}
```

$$UsuariosMultiples \leftarrow \Sel{numSeguidos \geq 3}(SeguimientosPorUsuario)$$

```mr-table
UsuariosMultiples = { seguidorId, numSeguidos }

UsuariosMultiples = {
    (u1, 3),
    (u3, 3)
}
```

$$\Proj{nom, ciu, numSeguidos}\left(UsuariosMultiples \JoinR{seguidorId = uid} U\right)$$

```mr-table
Resultado = { nom, ciu, numSeguidos }

Resultado = {
    ('Ana', 'Madrid', 3),
    ('Carla', 'Madrid', 3)
}
```

**6. Obtener los usuarios que no siguen a nadie**

$$UsuariosConSeguimientos \leftarrow \Proj{uid}\left(S \JoinR{seguidorId = uid} U\right)$$

$$U - \left(UsuariosConSeguimientos \NatJoin U\right)$$

```mr-table
Resultado = { uid, nom, edad, gen, ciu, freg }

Resultado = {
    (u6, 'Fabio', 19, 'MASCULINO', 'Sevilla', 2024-04-10)
}
```

**7. Obtener los pares de usuarios que se siguen mutuamente**

$$S1 \leftarrow \Ren{S1}(S)$$

$$S2 \leftarrow \Ren{S2}(S)$$

$$\Proj{S1.seguidorId, S1.seguidoId, S1.fechaInicio, S2.fechaInicio}\left(\Sel{S1.seguidorId = S2.seguidoId \land S1.seguidoId = S2.seguidorId}\left(S1 \times S2\right)\right)$$

```mr-table
Resultado = { S1.seguidorId, S1.seguidoId, S1.fechaInicio, S2.fechaInicio }

Resultado = {
    (u1, u2, 2024-02-20, 2024-03-01),
    (u2, u1, 2024-03-01, 2024-02-20),
    (u1, u3, 2024-02-21, 2024-02-25),
    (u3, u1, 2024-02-25, 2024-02-21),
    (u2, u3, 2024-03-02, 2024-02-26),
    (u3, u2, 2024-02-26, 2024-03-02)
}
```

**8. Obtener los usuarios que siguen a Carla y también a Bruno**

$$Carla \leftarrow \Proj{seguidorId}\left(\Sel{seguidoId = 'u3'}(S)\right)$$

$$Bruno \leftarrow \Proj{seguidorId}\left(\Sel{seguidoId = 'u2'}(S)\right)$$

$$\Proj{nom, ciu}\left(\left(Carla \Inter Bruno\right) \JoinR{seguidorId = uid} U\right)$$

```mr-table
Resultado = { nom, ciu }

Resultado = {
    ('Elena', 'Barcelona')
}
```

**9. Obtener el número de seguidores de cada usuario**

$$SeguidoresPorUsuario \leftarrow \Group{seguidoId,\rho_{numSeguidores}(COUNT(*))}{seguidoId}(S)$$

```mr-table
SeguidoresPorUsuario = { seguidoId, numSeguidores }

SeguidoresPorUsuario = {
    (u1, 3),
    (u2, 4),
    (u3, 3),
    (u5, 2)
}
```

$$\Proj{nom, numSeguidores}\left(SeguidoresPorUsuario \JoinR{seguidoId = uid} U\right)$$

```mr-table
Resultado = { nom, numSeguidores }

Resultado = {
    ('Ana', 3),
    ('Bruno', 4),
    ('Carla', 3),
    ('Elena', 2)
}
```

**10. Obtener los seguimientos en los que el seguidor se registró durante enero de 2024**

$$Uenero \leftarrow \Sel{freg \geq '2024-01-01' \land freg < '2024-02-01'}(U)$$

$$\Proj{seguimientoId,seguidorId,seguidoId,fechaInicio}\left(S \JoinR{seguidorId = uid} Uenero\right)$$

```mr-table
Resultado = { seguimientoId, seguidorId, seguidoId, fechaInicio }

Resultado = {
    (s1, u1, u2, 2024-02-20),
    (s2, u1, u3, 2024-02-21),
    (s3, u1, u5, 2024-02-22),
    (s6, u3, u1, 2024-02-25),
    (s7, u3, u2, 2024-02-26),
    (s8, u3, u5, 2024-02-27)
}
```

**11. Obtener los usuarios mayores de 25 años de Madrid o Valencia**

$$\Proj{nom, edad, gen, ciu}\left(\Sel{edad > 25 \land \left(ciu = 'Madrid' \lor ciu = 'Valencia'\right)}(U)\right)$$

```mr-table
Resultado = { nom, edad, gen, ciu }

Resultado = {
    ('Ana', 28, 'FEMENINO', 'Madrid'),
    ('Diego', 31, 'MASCULINO', 'Valencia')
}
```

**12. Obtener los usuarios que siguen a todas las mujeres**

$$MujeresAseguir \leftarrow \Ren{MujeresAseguir(seguidoId)}\left(\Proj{uid}\left(\Sel{gen = 'FEMENINO'}(U)\right)\right)$$

$$UsuariosQueSiguenATodas \leftarrow \Proj{seguidorId,seguidoId}(S) \Div MujeresAseguir$$

$$\Proj{seguidorId,nom,edad,gen,ciu}\left(UsuariosQueSiguenATodas \JoinR{seguidorId = uid} U\right)$$

```mr-table
Resultado = { seguidorId, nom, edad, gen, ciu }

Resultado = {
    (u2, 'Bruno', 34, 'MASCULINO', 'Sevilla')
}
```

### [Relax](https://dbis-uibk.github.io/relax/calc/gist/1a3b279c0d10d438dd2f626b7040597c)

```
-- Usuarios que sigue Ana
-- π nombre, edad, genero, ciudadOrigen (σ seguidorId = 'u1' (Seguimientos) ⨝ seguidoId = usuarioId Usuarios)

-- Usuarios que siguen a Bruno
-- π nombre, edad, genero, ciudadOrigen (σ seguidoId = 'u2' (Seguimientos) ⨝ seguidorId = usuarioId Usuarios)

-- Seguimientos con los nombres y ciudades de ambos usuarios
-- U1 = ρ U1 (Usuarios)
-- U2 = ρ U2 (Usuarios)
-- π U1.nombre, U1.ciudadOrigen, U2.nombre, U2.ciudadOrigen, fechaInicio (U1 ⨝ U1.usuarioId = seguidorId Seguimientos ⨝ seguidoId = U2.usuarioId U2)

-- Seguimientos iniciados durante febrero de 2024
-- σ fechaInicio >= date('2024-02-01') and fechaInicio < date('2024-03-01') (Seguimientos)

-- Usuarios que siguen a tres o más usuarios
-- SeguimientosPorUsuario = γ seguidorId; count(seguidoId) → numSeguidos (Seguimientos)
-- UsuariosMultiples = σ numSeguidos >= 3 (SeguimientosPorUsuario)
-- π nombre, ciudadOrigen, numSeguidos (UsuariosMultiples ⨝ seguidorId = usuarioId Usuarios)

-- Usuarios que no siguen a nadie
-- UsuariosConSeguimientos = π usuarioId (Seguimientos ⨝ seguidorId = usuarioId Usuarios)
-- Usuarios - (UsuariosConSeguimientos ⨝ Usuarios)

-- Pares de usuarios que se siguen mutuamente
-- S1 = ρ S1 (Seguimientos)
-- S2 = ρ S2 (Seguimientos)
-- π S1.seguidorId, S1.seguidoId, S1.fechaInicio, S2.fechaInicio (σ S1.seguidorId = S2.seguidoId and S1.seguidoId = S2.seguidorId (S1 × S2))

-- Usuarios que siguen a Carla y también a Bruno
-- Carla = π seguidorId (σ seguidoId = 'u3' (Seguimientos))
-- Bruno = π seguidorId (σ seguidoId = 'u2' (Seguimientos))
-- π nombre, ciudadOrigen ((Carla ∩ Bruno) ⨝ seguidorId = usuarioId Usuarios)

-- Número de seguidores de cada usuario
-- SeguidoresPorUsuario = γ seguidoId; count(seguidorId) → numSeguidores (Seguimientos)
-- π nombre, numSeguidores (SeguidoresPorUsuario ⨝ seguidoId = usuarioId Usuarios)

-- Seguimientos cuyo seguidor se registró durante enero de 2024
-- Uenero = σ fechaRegistro >= date('2024-01-01') and fechaRegistro < date('2024-02-01') (Usuarios)
-- π seguidorId, seguidoId, fechaInicio (Seguimientos ⨝ seguidorId = usuarioId Uenero)

-- Usuarios mayores de 25 años de Madrid o Valencia
-- π nombre, edad, genero, ciudadOrigen (σ edad > 25 and (ciudadOrigen = 'Madrid' or ciudadOrigen = 'Valencia') (Usuarios))

-- Usuarios que siguen a todas las mujeres
-- MujeresAseguir = ρ seguidoId←usuarioId (π usuarioId (σ genero = 'FEMENINO' (Usuarios)))
-- UsuariosQueSiguenATodas = π seguidorId, seguidoId (Seguimientos) ÷ MujeresAseguir
-- UsuariosQueSiguenATodas ⨝ seguidorId = usuarioId Usuarios
```

> [Versión PDF disponible](./index.pdf)
