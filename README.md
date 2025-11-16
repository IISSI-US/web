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
- Typst instalado (para generar PDFs)
- Python 3 (para el script `_scripts/build_pdfs.py`)

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

### Tareas automatizadas

Utiliza `make help` para ver los objetivos disponibles.

- `make images` renderiza todos los diagramas PlantUML (usa `make mc2mr-images` o `make req2sql-images` para colecciones concretas).
- `make pdfs` genera un PDF por cada `index.md` que tenga `pdf_version: true` en su cabecera y añade un aviso con el enlace.
- `make clean-images` elimina los PNG generados.

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
