# Documentación Unificada

Sitio web creado con Jekyll y el tema Just the Docs, desplegado en GitHub Pages.

## Características

Este sitio utiliza **colecciones de Jekyll** para organizar la documentación en diferentes secciones:

- 📋 **Requisitos** - Análisis y captura de requisitos
- 🎨 **Modelado Conceptual** - Diagramas entidad-relación
- 🗄️ **Modelado Relacional** - Modelo relacional de bases de datos
- 💾 **SQL** - Consultas y manipulación de datos

## Desarrollo local

### Prerrequisitos

- Ruby (versión 2.7 o superior)
- Bundler: `gem install bundler`

### Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/TU_USUARIO/hub.git
   cd hub
   ```

2. Instala las dependencias:
   ```bash
   bundle install
   ```

3. Ejecuta el servidor local:
   ```bash
   bundle exec jekyll serve
   ```

4. Abre tu navegador en `http://localhost:4000/hub/`

## Estructura del proyecto

```
.
├── _config.yml           # Configuración principal de Jekyll
├── _conceptual/          # Colección: Modelado Conceptual
├── _relacional/          # Colección: Modelado Relacional
├── _requisitos/          # Colección: Requisitos
├── _sql/                 # Colección: SQL
├── assets/               # Recursos estáticos (CSS, imágenes)
├── _includes/            # Componentes reutilizables
└── index.md              # Página de inicio
```

## Despliegue en GitHub Pages

El sitio está configurado para desplegarse automáticamente en GitHub Pages. Cualquier push a la rama `main` actualizará el sitio.

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.
