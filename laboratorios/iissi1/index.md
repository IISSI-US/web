---
title: Laboratorios
layout: single
permalink: /laboratorios/iissi1/
sidebar:
  nav: labs-iissi-1
---

Bienvenido a la sección de Laboratorios.

Seleccione un laboratorio en la barra lateral para comenzar.

## Lista de laboratorios

{% assign lab_nav = site.data.navigation.laboratorios[0].children %}
<ul>
{% for item in lab_nav %}
  <li><a href="{{ item.url | relative_url }}">{{ item.title }}</a></li>
{% endfor %}
</ul>
