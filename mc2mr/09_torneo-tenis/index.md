---
layout: single
title: "Modelo Complejo (tenis)"
toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
---

## Modelo Conceptual
![Diagrama de Clases](/mc2mr/ejercicio-09-torneo-tenis-clases.png)

## Modelo Relacional. Intensión
```
Personas(personaId, nombre, apellido, fechaNacimiento, nacionalidad)
    PK(personaId)

Tenistas(personaId, ranking)
    PK(personaId)
    FK(personaId)/Personas

Árbitros(personaId, licencia)
    PK(personaId)
    AK(licencia) -- no lo indica el modelo, parece lógico
    FK(personaId)/Personas

Partidos(partidoId, tenista1Id, tenista2Id, ganadorId, árbitroId, torneo, fecha, ronda, duración)
    PK(partidoId)
    FK(tenista1Id)/Tenistas
    FK(tenista2Id)/Tenistas
    FK(ganadorId)/Tenistas
    FK(árbitroId)/Árbitros

    ** ganadorId \in = {tenista1Id, tenista2Id}

Sets(setId, partidoId, ganadorId, orden, resultado)
    PK(setId)
    FK(partidoId)/Partidos
    FK(ganadorId)/Tenistas
```

<!-- ## Diagrama de objetos
![Diagrama de Objetos](/mc2mr/ejercicio-09-torneo-tenis-objetos.png) -->

## Modelo Relacional. Extensión
```text
Personas = {
    (p1, 'Rafael', 'Nadal', 1986-06-03, 'España'),
    (p2, 'Novak', 'Djokovic', 1987-05-22, 'Serbia'),
    (p3, 'John', 'Hawkins', 1975-03-15, 'Reino Unido'),
    (p4, 'Roger', 'Federer', 1981-08-08, 'Suiza'),
    (p5, 'Carlos', 'Ramos', 1971-11-13, 'Portugal'),
    (p6, 'Serena', 'Williams', 1981-09-26, 'Estados Unidos'),
    (p7, 'Carlos', 'Alcaraz', 2003-05-05, 'España'),
    (p8, 'Maria', 'González', 1970-08-20, 'Argentina'),
    (p9, 'Andy', 'Murray', 1987-05-15, 'Reino Unido'),
    (p10, 'Elena', 'Rybakina', 1999-06-17, 'Kazajistán'),
    (p11, 'James', 'Mitchell', 1965-12-10, 'Australia'),
    (p12, 'Daniil', 'Medvedev', 1996-02-11, 'Rusia')
}

Tenistas = {
    (p1, 2),
    (p2, 1),
    (p4, 3),
    (p6, 1),
    (p7, 4),
    (p9, 5),
    (p10, 2),
    (p12, 6)
}

Árbitros = {
    (p3, 'ATP-001'),
    (p5, 'ATP-002'),
    (p8, 'WTA-003'),
    (p11, 'ATP-004')
}

Partidos = {
    (par1, p1, p2, p2, p3, 'Roland Garros 2025', 2025-07-11, 'Final', 195),
    (par2, p1, p4, p1, p5, 'Wimbledon 2025', 2025-07-08, 'Semifinal', 168),
    (par3, p6, p10, p6, p8, 'US Open 2025', 2025-09-12, 'Final', 142),
    (par4, p7, p9, p7, p11, 'Australian Open 2025', 2025-01-28, 'Cuartos', 203),
    (par5, p2, p12, p2, p3, 'Roland Garros 2025', 2025-07-09, 'Semifinal', 256),
    (par6, p4, p7, p4, p5, 'Wimbledon 2025', 2025-07-07, 'Cuartos', 178),
    (par7, p1, p7, p1, p11, 'US Open 2025', 2025-09-10, 'Semifinal', 189),
    (par8, p9, p12, p12, p8, 'Australian Open 2025', 2025-01-26, 'Octavos', 234)
}

Sets = {
    (s1, par1, p2, 1, '6-4'),
    (s2, par1, p1, 2, '7-5'),
    (s3, par1, p2, 3, '6-3'),
    (s4, par2, p1, 1, '6-2'),
    (s5, par2, p1, 2, '7-6'),
    (s6, par3, p6, 1, '6-1'),
    (s7, par3, p10, 2, '4-6'),
    (s8, par3, p6, 3, '6-4'),
    (s9, par4, p7, 1, '7-5'),
    (s10, par4, p9, 2, '3-6'),
    (s11, par4, p7, 3, '6-2'),
    (s12, par4, p7, 4, '6-4'),
    (s13, par5, p2, 1, '6-0'),
    (s14, par5, p12, 2, '6-7'),
    (s15, par5, p2, 3, '6-3'),
    (s16, par6, p4, 1, '6-3'),
    (s17, par6, p4, 2, '6-2'),
    (s18, par7, p1, 1, '7-6'),
    (s19, par7, p7, 2, '4-6'),
    (s20, par7, p1, 3, '6-1'),
    (s21, par8, p12, 1, '6-4'),
    (s22, par8, p9, 2, '7-5'),
    (s23, par8, p12, 3, '6-2')
}
```

---

## Álgebra relacional

### Enunciados

**1.** Obtener el nombre, apellido y ranking de todos los tenistas de nacionalidad española

**2.** Mostrar todos los partidos que fueron finales en Roland Garros 2025

**3.** Obtener nombre, apellido y licencia de todos los árbitros con licencia ATP

**4.** Nombres de tenistas que ganaron al menos un partido en Wimbledon 2025

**5.** Información de sets con resultado 6-0 (juego perfecto)

**6.** Obtener torneo, ronda y duración de partidos que duraron más de 200 minutos

**7.** Nombre y ranking de tenistas con ranking mejor que 3 (ranking ≤ 3)

**8.** Información de partidos arbitrados por árbitros de nacionalidad Reino Unido

**9.** Obtener el número de sets ganados por cada tenista

**10.** Partidos donde ambos tenistas tienen ranking ≤ 3

### Soluciones

**Renombramiento de relaciones:**

$$P \leftarrow \Ren{P(pId,nom,ape,fec,nac)}(Personas)$$

$$T \leftarrow \Ren{T(pId,ran)}(Tenistas)$$

$$A \leftarrow \Ren{A(pId,lic)}(Árbitros)$$

$$Par \leftarrow \Ren{Par(parId,ten1Id,ten2Id,ganId,arbId,tor,fec,ron,dur)}(Partidos)$$

$$S \leftarrow \Ren{S(setId,parId,ganId,ord,res)}(Sets)$$

**1. Obtener el nombre, apellido y ranking de todos los tenistas de nacionalidad española**

$$\Proj{nom, ape, ran}\left(\Sel{nac = \text{'España'}}(P \Join T)\right)$$


```
Resultado: {
    ('Rafael', 'Nadal', 2),
    ('Carlos', 'Alcaraz', 4)
}
```

**2. Mostrar todos los partidos que fueron finales en Roland Garros 2025**

$$\Sel{tor = '\text{Roland Garros 2025}' \land ron = '\text{Final}'}(Par)$$

```
Resultado: {
    (par1, p1, p2, p2, p3, 'Roland Garros 2025', 2025-07-11, 'Final', 195)
}
```

**3. Obtener nombre, apellido y licencia de todos los árbitros con licencia ATP**

$$\Proj{nom, ape, lic}\left(\Sel{lic\\ LIKE\\ 'ATP\%'}(P \Join A)\right)$$

```
Resultado: {
    ('John', 'Hawkins', 'ATP-001'),
    ('Carlos', 'Ramos', 'ATP-002'),
    ('James', 'Mitchell', 'ATP-004')
}
```

**4. Nombres de tenistas que ganaron al menos un partido en Wimbledon 2025**

$$GanadoresWim \leftarrow \Proj{ganId}(\Sel{tor = 'Wimbledon\ 2025'}(Par))$$

$$\Proj{nom, ape}(GanadoresWim \Join_{ganId = pId} P)$$

```
Resultado: {
    ('Rafael', 'Nadal'),
    ('Roger', 'Federer')
}
```

**5. Información de sets con resultado 6-0 (juego perfecto)**

$$\Sel{res = '6-0'}(S)$$

```
Resultado: {
    (s13, par5, p2, 1, '6-0')
}
```

**6. Obtener torneo, ronda y duración de partidos que duraron más de 200 minutos**

$$\Proj{tor, ron, dur}(\Sel{dur > 200}(Par))$$

```
Resultado: {
    ('Australian Open 2025', 'Cuartos', 203),
    ('Roland Garros 2025', 'Semifinal', 256),
    ('Australian Open 2025', 'Octavos', 234)
}
```

**7. Nombre y ranking de tenistas con ranking mejor que 3 (ranking ≤ 3)**

$$\Proj{nom, ape, ran}(\Sel{ran \leq 3}(P \Join T))$$

```
Resultado: {
    ('Rafael', 'Nadal', 2),
    ('Novak', 'Djokovic', 1),
    ('Roger', 'Federer', 3),
    ('Serena', 'Williams', 1),
    ('Elena', 'Rybakina', 2)
}
```

**8. Información de partidos arbitrados por árbitros de nacionalidad Reino Unido**

$$ArbitrosRU \leftarrow \Proj{pId}(\Sel{nac = 'Reino\ Unido'}(P \Join A))$$

$$PartidosArbitradosRU \leftarrow ArbitrosRU \Join_{pId = arbId} Par$$

$$\Proj{parId, tor, fec, ron}(PartidosArbitradosRU)$$

```
Resultado: {
    (par1, 'Roland Garros 2025', 2025-07-11, 'Final'),
    (par4, 'Australian Open 2025', 2025-01-28, 'Cuartos'),
    (par7, 'US Open 2025', 2025-09-10, 'Semifinal')
}
```

**9. Obtener el número de sets ganados por cada tenista**

$$SetsContados \leftarrow \Group{ganId, \Ren{numSets}COUNT(*)}{ganId}(S)$$

$$\Proj{nom, ape, numSets}(SetsContados \Join_{ganId = pId} P)$$

```
Resultado: {
    ('Rafael', 'Nadal', 6),
    ('Novak', 'Djokovic', 4),
    ('Roger', 'Federer', 2),
    ('Serena', 'Williams', 3),
    ('Carlos', 'Alcaraz', 5),
    ('Andy', 'Murray', 1),
    ('Daniil', 'Medvedev', 2)
}
```

**10. Partidos donde ambos tenistas tienen ranking ≤ 3**

$$TenistasTop3 \leftarrow \Proj{pId}(\Sel{ran \leq 3}(T))$$

$$PartidosTop3 \leftarrow \Sel{ten1Id \in TenistasTop3 \land ten2Id \in TenistasTop3}(Par)$$

$$\Proj{parId, tor, ron}(PartidosTop3)$$

```
Resultado: {
    (par1, 'Roland Garros 2025', 'Final'),
    (par2, 'Wimbledon 2025', 'Semifinal')
}
```
