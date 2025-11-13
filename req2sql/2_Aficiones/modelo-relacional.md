---
layout: default
title: Modelo Relacional
parent: Aficiones
nav_order: 3
---

# Modelo relacional

## Variante estática (Aficiones como atributos en su relación)

### Intensión

```
Usuarios(usuarioId, nombre, edad, género, email)
	PK(usuarioId)
	AK(email)
Aficiones(aficionId, usuarioId, afición)
	PK(aficionId)
	FK(usuarioId) / Usuarios
	AK(usuarioId, afición)
```

### Extensión

```
Usuarios = { u1..u11 como en el ejercicio de Usuarios }
Aficiones = {
    (a1, u1, "Deporte"), 
    (a2, u1, "Gastronomía"),
    (a3, u2, "Deporte"), 
    (a4, u2, "Literatura"), 
    (a5, u2, "Cine"),
    (a6, u4, "Gastronomía"), 
    (a7, u4, "Cine"), 
    (a8, u4, "Literatura"),
    (a9, u5, "Deporte"), 
    (a10, u6, "Cine"),
    (a11, u8, "Deporte"), 
    (a12, u8, "Gastronomía"), 
    (a13, u8, "Literatura"), 
    (a14, u8, "Cine"),
    (a15, u9, "Deporte"), 
    (a16, u9, "Literatura"), 
    (a17, u9, "Cine"),
    (a18, u10, "Gastronomía")
}
```

### Álgebra relacional

- Renombrado:

$$
\Ren{U(uid,nu,ed,g,em)}(Usuarios)
$$

$$
\Ren{A(aid,uid,af)}(Aficiones)
$$

- Usuarios con sus aficiones: 

$$
UA \leftarrow U \NatJoin A
$$

- Usuarias a las que les gusta el cine: 

$$
UCine \leftarrow \Sel{af=\text{CINE}}(UA)
$$

- Usuarios sin aficiones: 

$$
UsuSinAfi \leftarrow \Proj{uid,nu}\big(U \NatJoin (\Proj{uid}(U) \Diff \Proj{uid}(A))\big)
$$

- Número de aficiones por usuario: 

$$
NumAfiUsu \leftarrow \Group{\operatorname{COUNT}(*)}{uid}(UA)
$$


---

## Variante dinámica (tabla intermedia usuario–afición)

### Intensión

```
Usuarios(usuarioId, nombre, edad, género, email)
	PK(usuarioId)
	AK(email)
Aficiones(aficionId, afición)
	PK(aficionId)
UsuariosAficiones(usuarioAficionId, usuarioId, aficiónId)
	PK(usuarioAficionId)
	FK(usuarioId) / Usuarios
	FK(aficiónId) / Aficiones
	AK(usuarioId, aficiónId)
```

### Extensión

```
Usuarios = { u1..u11 como en el ejercicio de Usuarios }

Aficiones = { 
    (a1, "Cine"), (a2, "Deporte"), (a3, "Jugar al fútbol"), 
    (a4, "Hacer senderismo"), (a5, "Montar a caballo") 
}
UsuariosAficiones = { 
    (u1,a3), (u1,a4), (u2,a1), (u2,a2), (u2,a3), (u4,a4), 
    (u4,a2), (u4,a1), (u5,a3), (u6,a2), (u8,a3), (u8,a4), 
    (u8,a1), (u8,a2), (u9,a3), (u9,a1), (u9,a2), (u10,a4), 
    (u11,a5) 
}
```

### Álgebra relacional

- Renombrado:

$$
\Ren{U(uid,nu,ed,g,em)}(Usuarios)
$$

$$
\Ren{A(aid,af)}(Aficiones)
$$

$$
\Ren{UA(uid,aid)}(UsuariosAficiones)
$$

- Usuarios con sus aficiones: 

$$
UAA \leftarrow U \NatJoin UA \NatJoin A
$$

- Usuarios a los que les gusta el cine: 

$$
UCine \leftarrow \Proj{nu}\big(\Sel{af=\text{CINE}}(UAA)\big)
$$

- Usuarios sin aficiones: 

$$
USinAfi \leftarrow \Proj{nu}\big(U \NatJoin (\Proj{uid}(U) \Diff \Proj{uid}(UA))\big)
$$

- Usuarios con todas las aficiones: 

$$
UsuTodasAfi \leftarrow \Proj{nu,uid}\left(\frac{UA}{\Proj{aid}(A)} \NatJoin U\right)
$$

