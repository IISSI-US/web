---
layout: default
title: Modelo Relacional
parent: Usuarios
nav_order: 3
math: mathjax     # o: katex
---

# Modelo relacional

## Intensión

```
Usuarios(usuarioId, nombre, género, edad, email)
	PK(usuarioId)
	AK(email)
```

## Extensión

```
Usuarios = {
	(u1,  "David Ruiz",      45, MASCULINO, "druiz@us.es"),
	(u2,  "Carlos Arévalo",  58, MASCULINO, "carevalo@us.es"),
	(u3,  "Margarita Cruz",  58, FEMENINO,  "mcruz@us.es"),
	(u4,  "Inma Hernández",  35, FEMENINO,  "inmahernandez@us.es"),
	(u5,  "Alfonso Márquez", 35, MASCULINO, "amarquez@us.es"),
	(u6,  "Daniel Ayala",     28, MASCULINO, "dayala1@us.es"),
	(u7,  "Raquel Sampedro", 55, FEMENINO,  "rsampedro@gmail.com"),
	(u8,  "Marta López",     18, FEMENINO,  "mlopez@mail.com"),
	(u9,  "David Ruiz",      25, MASCULINO, "druiz@mail.com"),
	(u10, "Andrea Gómez",     27, OTRO,      "agomez@mail.es"),
	(u11, "Ernesto Murillo",  55, OTRO,      "emurillo@correo.es")
}
```

## Álgebra relacional

- Renombrado de la relación Usuarios (corregido para incluir el atributo género):

$$
\Ren{U(uid,n,g,ed,em)}\left(Usuarios\right)
$$

- Nombre y correo de las usuarias (género femenino):

$$
Mujeres \leftarrow \Proj{n,em}\big(\Sel{g=\text{FEMENINO}}(U)\big)
$$

- Nombre, edad y correo de los usuarios con dominio “@us.es”:

$$
UsuariosUS \leftarrow \Proj{n,ed,em}\big(\Sel{\operatorname{dominio}(em)='us.es'}(U)\big)
$$

Asumimos una función $\operatorname{dominio}(\cdot)$ que dado un email devuelve su dominio (la cadena tras la @).

- Edad media y total de usuarios:

$$
MedTotUsuarios \leftarrow \GroupUp{\operatorname{AVG}(ed),\;\operatorname{COUNT}(*)}(U)
$$

- Edad media y total de los usuarios con dominio “@us.es”:

$$
MedTotUsuariosUS \leftarrow \GroupUp{\operatorname{AVG}(ed),\;\operatorname{COUNT}(*)}(UsuariosUS)
$$

- Edad media de los usuarios agrupada por género:

$$
MediaGenero \leftarrow \Group{\operatorname{AVG}(ed)}{g}(U)
$$

- Número de usuarios agrupados por género:

$$
TotalGenero \leftarrow \Group{\operatorname{COUNT}(*)}{g}(U)
$$

- Edad media y total de usuarios según el dominio del correo electrónico:

$$
MedTotDominio \leftarrow \Group{\operatorname{AVG}(ed),\;\operatorname{COUNT}(*)}{\operatorname{dominio}(em)}(U)
$$

- Edad del usuario de mayor edad:

$$
edadMayor \leftarrow \GroupUp{\operatorname{MAX}(ed)}(U)
$$

- Edad máxima por género:

$$
MayoresGenero \leftarrow \Group{\operatorname{MAX}(ed)}{g}(U)
$$
