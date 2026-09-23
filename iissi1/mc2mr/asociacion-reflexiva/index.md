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
Usuarios = { usuarioId, nombreUsuario, edad, genero, ciudadOrigen, fechaRegistro }
    PK(usuarioId)
    AK(nombreUsuario)

Seguimientos = { seguidorId, seguidoId, fechaInicio }
    PK(seguidorId, seguidoId)
    FK(seguidorId)/Usuarios
    FK(seguidoId)/Usuarios

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
    (u1, u2, 2024-02-20),
    (u1, u3, 2024-02-21),
    (u1, u5, 2024-02-22),
    (u2, u1, 2024-03-01),
    (u2, u3, 2024-03-02),
    (u3, u1, 2024-02-25),
    (u3, u2, 2024-02-26),
    (u3, u5, 2024-02-27),
    (u4, u1, 2024-03-10),
    (u4, u2, 2024-03-11),
    (u5, u2, 2024-02-10),
    (u5, u3, 2024-02-11)
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

## Soluciones

**Renombramiento de relaciones:**

$$U \leftarrow \Ren{U(uid,nom,edad,gen,ciu,freg)}(Usuarios)$$

$$S \leftarrow \Ren{S(seg,seguid,fin)}(Seguimientos)$$

**1. Obtener los usuarios que sigue Ana**

Como Ana tiene identificador `u1`:

$$\Proj{nom, edad, gen, ciu}\left(\Sel{seg = u1}(S) \JoinR{seguid = uid} U\right)$$

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

$$\Proj{nom, edad, gen, ciu}\left(\Sel{seguid = u2}(S) \JoinR{seg = uid} U\right)$$

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

$$\Proj{U1.nom, U1.ciu, U2.nom, U2.ciu, fin}\left(U1 \JoinR{U1.uid = seg} S \JoinR{seguid = U2.uid} U2\right)$$

```mr-table
Resultado = { U1.nom, U1.ciu, U2.nom, U2.ciu, fin }

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

$$\Sel{fin \geq '2024-02-01' \land fin < '2024-03-01'}(S)$$

```mr-table
Resultado = { seg, seguid, fin }

Resultado = {
    (u1, u2, 2024-02-20),
    (u1, u3, 2024-02-21),
    (u1, u5, 2024-02-22),
    (u3, u1, 2024-02-25),
    (u3, u2, 2024-02-26),
    (u3, u5, 2024-02-27),
    (u5, u2, 2024-02-10),
    (u5, u3, 2024-02-11)
}
```

**5. Obtener los usuarios que siguen a tres o más usuarios**

$$SeguimientosPorUsuario \leftarrow \Group{seg,\rho_{numSeguidos}(COUNT(*))}{seg}(S)$$

```mr-table
SeguimientosPorUsuario = { seg, numSeguidos }

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
UsuariosMultiples = { seg, numSeguidos }

UsuariosMultiples = {
    (u1, 3),
    (u3, 3)
}
```

$$\Proj{nom, ciu, numSeguidos}\left(UsuariosMultiples \JoinR{seg = uid} U\right)$$

```mr-table
Resultado = { nom, ciu, numSeguidos }

Resultado = {
    ('Ana', 'Madrid', 3),
    ('Carla', 'Madrid', 3)
}
```

**6. Obtener los usuarios que no siguen a nadie**

$$UsuariosConSeguimientos \leftarrow \Proj{uid}\left(S \JoinR{seg = uid} U\right)$$

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

$$\Proj{S1.seg, S1.seguid, S1.fin, S2.fin}\left(\Sel{S1.seg = S2.seguid \land S1.seguid = S2.seg}\left(S1 \times S2\right)\right)$$

```mr-table
Resultado = { S1.seg, S1.seguid, S1.fin, S2.fin }

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

$$Carla \leftarrow \Proj{seg}\left(\Sel{seguid = 'u3'}(S)\right)$$

$$Bruno \leftarrow \Proj{seg}\left(\Sel{seguid = 'u2'}(S)\right)$$

$$\Proj{nom, ciu}\left(\left(Carla \Inter Bruno\right) \JoinR{seg = uid} U\right)$$

```mr-table
Resultado = { nom, ciu }

Resultado = {
    ('Elena', 'Barcelona')
}
```

**9. Obtener el número de seguidores de cada usuario**

$$SeguidoresPorUsuario \leftarrow \Group{seguid,\rho_{numSeguidores}(COUNT(*))}{seguid}(S)$$

```mr-table
SeguidoresPorUsuario = { seguid, numSeguidores }

SeguidoresPorUsuario = {
    (u1, 3),
    (u2, 4),
    (u3, 3),
    (u5, 2)
}
```

$$\Proj{nom, numSeguidores}\left(SeguidoresPorUsuario \JoinR{seguid = uid} U\right)$$

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

$$S \JoinR{seg = uid} Uenero$$

```mr-table
Resultado = { seg, seguid, fin }

Resultado = {
    (u1, u2, 2024-02-20),
    (u1, u3, 2024-02-21),
    (u1, u5, 2024-02-22),
    (u3, u1, 2024-02-25),
    (u3, u2, 2024-02-26),
    (u3, u5, 2024-02-27)
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

### [Relax](https://dbis-uibk.github.io/relax/calc/gist/1a3b279c0d10d438dd2f626b7040597c)

```
-- Usuarios que sigue Ana
-- π nombreUsuario, edad, genero, ciudadOrigen (σ seguidorId = 'u1' (Seguimientos) ⨝ seguidoId = usuarioId Usuarios)

-- Usuarios que siguen a Bruno
-- π nombreUsuario, edad, genero, ciudadOrigen (σ seguidoId = 'u2' (Seguimientos) ⨝ seguidorId = usuarioId Usuarios)

-- Seguimientos con los nombres y ciudades de ambos usuarios
-- U1 = ρ U1 (Usuarios)
-- U2 = ρ U2 (Usuarios)
-- π U1.nombreUsuario, U1.ciudadOrigen, U2.nombreUsuario, U2.ciudadOrigen, fechaInicio (U1 ⨝ U1.usuarioId = seguidorId Seguimientos ⨝ seguidoId = U2.usuarioId U2)

-- Seguimientos iniciados durante febrero de 2024
-- σ fechaInicio >= date('2024-02-01') and fechaInicio < date('2024-03-01') (Seguimientos)

-- Usuarios que siguen a tres o más usuarios
-- SeguimientosPorUsuario = γ seguidorId; count(seguidoId) → numSeguidos (Seguimientos)
-- UsuariosMultiples = σ numSeguidos >= 3 (SeguimientosPorUsuario)
-- π nombreUsuario, ciudadOrigen, numSeguidos (UsuariosMultiples ⨝ seguidorId = usuarioId Usuarios)

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
-- π nombreUsuario, ciudadOrigen ((Carla ∩ Bruno) ⨝ seguidorId = usuarioId Usuarios)

-- Número de seguidores de cada usuario
-- SeguidoresPorUsuario = γ seguidoId; count(seguidorId) → numSeguidores (Seguimientos)
-- π nombreUsuario, numSeguidores (SeguidoresPorUsuario ⨝ seguidoId = usuarioId Usuarios)

-- Seguimientos cuyo seguidor se registró durante enero de 2024
-- Uenero = σ fechaRegistro >= date('2024-01-01') and fechaRegistro < date('2024-02-01') (Usuarios)
-- π seguidorId, seguidoId, fechaInicio (Seguimientos ⨝ seguidorId = usuarioId Uenero)

-- Usuarios mayores de 25 años de Madrid o Valencia
-- π nombreUsuario, edad, genero, ciudadOrigen (σ edad > 25 and (ciudadOrigen = 'Madrid' or ciudadOrigen = 'Valencia') (Usuarios))
```

> [Versión PDF disponible](./index.pdf)
